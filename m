From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.18-rc8
Date: Sat, 11 Aug 2018 08:50:42 -0700
Message-ID: <1534002642.3198.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Eight fixes.  The most important one is the mpt3sas fix which makes the
driver work again on big endian systems.  The rest are mostly minor
error path or checker issues and the vmw_scsi one fixes a performance
problem.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (2):
      scsi: sr: Avoid that opening a CD-ROM hangs with runtime power management enabled
      scsi: qedi: Fix a potential buffer overflow

Jim Gill (1):
      scsi: vmw_pvscsi: Return DID_RESET for status SAM_STAT_COMMAND_TERMINATED

Johannes Thumshirn (3):
      scsi: fcoe: clear FC_RP_STARTED flags when receiving a LOGO
      scsi: fcoe: drop frames in ELS LOGO error path
      scsi: fcoe: fix use-after-free in fcoe_ctlr_els_send

Quinn Tran (1):
      scsi: qla2xxx: Fix memory leak for allocating abort IOCB

Sreekanth Reddy (1):
      scsi: mpt3sas: Swap I/O memory read value back to cpu endianness

And the diffstat:

 drivers/scsi/fcoe/fcoe_ctlr.c       |  6 ++---
 drivers/scsi/libfc/fc_rport.c       |  1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c | 16 +++++------
 drivers/scsi/qedi/qedi_main.c       |  2 +-
 drivers/scsi/qla2xxx/qla_iocb.c     | 53 +++++++++++++++++++------------------
 drivers/scsi/sr.c                   | 29 ++++++++++++++------
 drivers/scsi/vmw_pvscsi.c           | 11 +++++---
 7 files changed, 69 insertions(+), 49 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index ea23c8dffc25..ffec695e0bfb 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -754,9 +754,9 @@ int fcoe_ctlr_els_send(struct fcoe_ctlr *fip, struct fc_lport *lport,
 	case ELS_LOGO:
 		if (fip->mode == FIP_MODE_VN2VN) {
 			if (fip->state != FIP_ST_VNMP_UP)
-				return -EINVAL;
+				goto drop;
 			if (ntoh24(fh->fh_d_id) == FC_FID_FLOGI)
-				return -EINVAL;
+				goto drop;
 		} else {
 			if (fip->state != FIP_ST_ENABLED)
 				return 0;
@@ -799,9 +799,9 @@ int fcoe_ctlr_els_send(struct fcoe_ctlr *fip, struct fc_lport *lport,
 	fip->send(fip, skb);
 	return -EINPROGRESS;
 drop:
-	kfree_skb(skb);
 	LIBFCOE_FIP_DBG(fip, "drop els_send op %u d_id %x\n",
 			op, ntoh24(fh->fh_d_id));
+	kfree_skb(skb);
 	return -EINVAL;
 }
 EXPORT_SYMBOL(fcoe_ctlr_els_send);
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 31d31aad3de1..89b1f1af2fd4 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -2164,6 +2164,7 @@ static void fc_rport_recv_logo_req(struct fc_lport *lport, struct fc_frame *fp)
 		FC_RPORT_DBG(rdata, "Received LOGO request while in state %s\n",
 			     fc_rport_state(rdata));
 
+		rdata->flags &= ~FC_RP_STARTED;
 		fc_rport_enter_delete(rdata, RPORT_EV_STOP);
 		mutex_unlock(&rdata->rp_mutex);
 		kref_put(&rdata->kref, fc_rport_destroy);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 569392d0d4c9..e44c91edf92d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3343,11 +3343,10 @@ _base_mpi_ep_writeq(__u64 b, volatile void __iomem *addr,
 					spinlock_t *writeq_lock)
 {
 	unsigned long flags;
-	__u64 data_out = b;
 
 	spin_lock_irqsave(writeq_lock, flags);
-	writel((u32)(data_out), addr);
-	writel((u32)(data_out >> 32), (addr + 4));
+	__raw_writel((u32)(b), addr);
+	__raw_writel((u32)(b >> 32), (addr + 4));
 	mmiowb();
 	spin_unlock_irqrestore(writeq_lock, flags);
 }
@@ -3367,7 +3366,8 @@ _base_mpi_ep_writeq(__u64 b, volatile void __iomem *addr,
 static inline void
 _base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t *writeq_lock)
 {
-	writeq(b, addr);
+	__raw_writeq(b, addr);
+	mmiowb();
 }
 #else
 static inline void
@@ -5268,7 +5268,7 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 
 	/* send message 32-bits at a time */
 	for (i = 0, failed = 0; i < request_bytes/4 && !failed; i++) {
-		writel((u32)(request[i]), &ioc->chip->Doorbell);
+		writel(cpu_to_le32(request[i]), &ioc->chip->Doorbell);
 		if ((_base_wait_for_doorbell_ack(ioc, 5)))
 			failed = 1;
 	}
@@ -5289,7 +5289,7 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 	}
 
 	/* read the first two 16-bits, it gives the total length of the reply */
-	reply[0] = (u16)(readl(&ioc->chip->Doorbell)
+	reply[0] = le16_to_cpu(readl(&ioc->chip->Doorbell)
 	    & MPI2_DOORBELL_DATA_MASK);
 	writel(0, &ioc->chip->HostInterruptStatus);
 	if ((_base_wait_for_doorbell_int(ioc, 5))) {
@@ -5298,7 +5298,7 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 			ioc->name, __LINE__);
 		return -EFAULT;
 	}
-	reply[1] = (u16)(readl(&ioc->chip->Doorbell)
+	reply[1] = le16_to_cpu(readl(&ioc->chip->Doorbell)
 	    & MPI2_DOORBELL_DATA_MASK);
 	writel(0, &ioc->chip->HostInterruptStatus);
 
@@ -5312,7 +5312,7 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 		if (i >=  reply_bytes/2) /* overflow case */
 			readl(&ioc->chip->Doorbell);
 		else
-			reply[i] = (u16)(readl(&ioc->chip->Doorbell)
+			reply[i] = le16_to_cpu(readl(&ioc->chip->Doorbell)
 			    & MPI2_DOORBELL_DATA_MASK);
 		writel(0, &ioc->chip->HostInterruptStatus);
 	}
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 091ec1207bea..cff83b9457f7 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -888,7 +888,7 @@ static void qedi_get_boot_tgt_info(struct nvm_iscsi_block *block,
 	ipv6_en = !!(block->generic.ctrl_flags &
 		     NVM_ISCSI_CFG_GEN_IPV6_ENABLED);
 
-	snprintf(tgt->iscsi_name, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN, "%s\n",
+	snprintf(tgt->iscsi_name, sizeof(tgt->iscsi_name), "%s\n",
 		 block->target[index].target_name.byte);
 
 	tgt->ipv6_en = ipv6_en;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index a91cca52b5d5..dd93a22fe843 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2130,34 +2130,11 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	req_cnt = 1;
 	handle = 0;
 
-	if (!sp)
-		goto skip_cmd_array;
-
-	/* Check for room in outstanding command list. */
-	handle = req->current_outstanding_cmd;
-	for (index = 1; index < req->num_outstanding_cmds; index++) {
-		handle++;
-		if (handle == req->num_outstanding_cmds)
-			handle = 1;
-		if (!req->outstanding_cmds[handle])
-			break;
-	}
-	if (index == req->num_outstanding_cmds) {
-		ql_log(ql_log_warn, vha, 0x700b,
-		    "No room on outstanding cmd array.\n");
-		goto queuing_error;
-	}
-
-	/* Prep command array. */
-	req->current_outstanding_cmd = handle;
-	req->outstanding_cmds[handle] = sp;
-	sp->handle = handle;
-
-	/* Adjust entry-counts as needed. */
-	if (sp->type != SRB_SCSI_CMD)
+	if (sp && (sp->type != SRB_SCSI_CMD)) {
+		/* Adjust entry-counts as needed. */
 		req_cnt = sp->iocbs;
+	}
 
-skip_cmd_array:
 	/* Check for room on request queue. */
 	if (req->cnt < req_cnt + 2) {
 		if (qpair->use_shadow_reg)
@@ -2183,6 +2160,28 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	if (req->cnt < req_cnt + 2)
 		goto queuing_error;
 
+	if (sp) {
+		/* Check for room in outstanding command list. */
+		handle = req->current_outstanding_cmd;
+		for (index = 1; index < req->num_outstanding_cmds; index++) {
+			handle++;
+			if (handle == req->num_outstanding_cmds)
+				handle = 1;
+			if (!req->outstanding_cmds[handle])
+				break;
+		}
+		if (index == req->num_outstanding_cmds) {
+			ql_log(ql_log_warn, vha, 0x700b,
+			    "No room on outstanding cmd array.\n");
+			goto queuing_error;
+		}
+
+		/* Prep command array. */
+		req->current_outstanding_cmd = handle;
+		req->outstanding_cmds[handle] = sp;
+		sp->handle = handle;
+	}
+
 	/* Prep packet */
 	req->cnt -= req_cnt;
 	pkt = req->ring_ptr;
@@ -2195,6 +2194,8 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 		pkt->handle = handle;
 	}
 
+	return pkt;
+
 queuing_error:
 	qpair->tgt_counters.num_alloc_iocb_failed++;
 	return pkt;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 3f3cb72e0c0c..d0389b20574d 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -523,18 +523,26 @@ static int sr_init_command(struct scsi_cmnd *SCpnt)
 static int sr_block_open(struct block_device *bdev, fmode_t mode)
 {
 	struct scsi_cd *cd;
+	struct scsi_device *sdev;
 	int ret = -ENXIO;
 
+	cd = scsi_cd_get(bdev->bd_disk);
+	if (!cd)
+		goto out;
+
+	sdev = cd->device;
+	scsi_autopm_get_device(sdev);
 	check_disk_change(bdev);
 
 	mutex_lock(&sr_mutex);
-	cd = scsi_cd_get(bdev->bd_disk);
-	if (cd) {
-		ret = cdrom_open(&cd->cdi, bdev, mode);
-		if (ret)
-			scsi_cd_put(cd);
-	}
+	ret = cdrom_open(&cd->cdi, bdev, mode);
 	mutex_unlock(&sr_mutex);
+
+	scsi_autopm_put_device(sdev);
+	if (ret)
+		scsi_cd_put(cd);
+
+out:
 	return ret;
 }
 
@@ -562,6 +570,8 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	if (ret)
 		goto out;
 
+	scsi_autopm_get_device(sdev);
+
 	/*
 	 * Send SCSI addressing ioctls directly to mid level, send other
 	 * ioctls to cdrom/block level.
@@ -570,15 +580,18 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case SCSI_IOCTL_GET_IDLUN:
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 		ret = scsi_ioctl(sdev, cmd, argp);
-		goto out;
+		goto put;
 	}
 
 	ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, arg);
 	if (ret != -ENOSYS)
-		goto out;
+		goto put;
 
 	ret = scsi_ioctl(sdev, cmd, argp);
 
+put:
+	scsi_autopm_put_device(sdev);
+
 out:
 	mutex_unlock(&sr_mutex);
 	return ret;
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 777e5f1e52d1..0cd947f78b5b 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -561,9 +561,14 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 	    (btstat == BTSTAT_SUCCESS ||
 	     btstat == BTSTAT_LINKED_COMMAND_COMPLETED ||
 	     btstat == BTSTAT_LINKED_COMMAND_COMPLETED_WITH_FLAG)) {
-		cmd->result = (DID_OK << 16) | sdstat;
-		if (sdstat == SAM_STAT_CHECK_CONDITION && cmd->sense_buffer)
-			cmd->result |= (DRIVER_SENSE << 24);
+		if (sdstat == SAM_STAT_COMMAND_TERMINATED) {
+			cmd->result = (DID_RESET << 16);
+		} else {
+			cmd->result = (DID_OK << 16) | sdstat;
+			if (sdstat == SAM_STAT_CHECK_CONDITION &&
+			    cmd->sense_buffer)
+				cmd->result |= (DRIVER_SENSE << 24);
+		}
 	} else
 		switch (btstat) {
 		case BTSTAT_SUCCESS:
