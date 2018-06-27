From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.18-rc2
Date: Wed, 27 Jun 2018 10:20:56 +0800
Message-ID: <1530066056.3699.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Three small bug fixes (barrier elimination, memory leak on unload,
spinlock recursion) and a technical enhancement left over from the
merge window: the TCMU read length support is required for tape devices
read when the length of the read is greater than the tape block size.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arnd Bergmann (1):
      scsi: ipr: Eliminate duplicate barriers

Luis Henriques (1):
      scsi: scsi_debug: Fix memory leak on module unload

Mikhail Malygin (1):
      scsi: qla2xxx: Spinlock recursion in qla_target

bstroesser@ts.fujitsu.com (1):
      scsi: target: tcmu: add read length support

And the diffstat:

 drivers/scsi/ipr.c                    |  2 --
 drivers/scsi/qla2xxx/qla_target.c     |  7 +++---
 drivers/scsi/scsi_debug.c             |  2 +-
 drivers/target/target_core_user.c     | 44 ++++++++++++++++++++++++++++-------
 include/uapi/linux/target_core_user.h |  4 +++-
 5 files changed, 43 insertions(+), 16 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 0a9b8b387bd2..02d65dce74e5 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -760,7 +760,6 @@ static void ipr_mask_and_clear_interrupts(struct ipr_ioa_cfg *ioa_cfg,
 		ioa_cfg->hrrq[i].allow_interrupts = 0;
 		spin_unlock(&ioa_cfg->hrrq[i]._lock);
 	}
-	wmb();
 
 	/* Set interrupt mask to stop all new interrupts */
 	if (ioa_cfg->sis64)
@@ -8403,7 +8402,6 @@ static int ipr_reset_enable_ioa(struct ipr_cmnd *ipr_cmd)
 		ioa_cfg->hrrq[i].allow_interrupts = 1;
 		spin_unlock(&ioa_cfg->hrrq[i]._lock);
 	}
-	wmb();
 	if (ioa_cfg->sis64) {
 		/* Set the adapter to the correct endian mode. */
 		writel(IPR_ENDIAN_SWAP_KEY, ioa_cfg->regs.endian_swap_reg);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0fea2e2326be..1027b0cb7fa3 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1224,7 +1224,6 @@ static void qla24xx_chk_fcp_state(struct fc_port *sess)
 void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 {
 	struct qla_tgt *tgt = sess->tgt;
-	struct qla_hw_data *ha = sess->vha->hw;
 	unsigned long flags;
 
 	if (sess->disc_state == DSC_DELETE_PEND)
@@ -1241,16 +1240,16 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 			return;
 	}
 
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	if (sess->deleted == QLA_SESS_DELETED)
 		sess->logout_on_delete = 0;
 
+	spin_lock_irqsave(&sess->vha->work_lock, flags);
 	if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
-		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+		spin_unlock_irqrestore(&sess->vha->work_lock, flags);
 		return;
 	}
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+	spin_unlock_irqrestore(&sess->vha->work_lock, flags);
 
 	sess->disc_state = DSC_DELETE_PEND;
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 24d7496cd9e2..364e71861bfd 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5507,9 +5507,9 @@ static void __exit scsi_debug_exit(void)
 	int k = sdebug_add_host;
 
 	stop_all_queued();
-	free_all_queued();
 	for (; k; k--)
 		sdebug_remove_adapter();
+	free_all_queued();
 	driver_unregister(&sdebug_driverfs_driver);
 	bus_unregister(&pseudo_lld_bus);
 	root_device_unregister(pseudo_primary);
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7f96dfa32b9c..d8dc3d22051f 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -656,7 +656,7 @@ static void scatter_data_area(struct tcmu_dev *udev,
 }
 
 static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
-			     bool bidi)
+			     bool bidi, uint32_t read_len)
 {
 	struct se_cmd *se_cmd = cmd->se_cmd;
 	int i, dbi;
@@ -689,7 +689,7 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	for_each_sg(data_sg, sg, data_nents, i) {
 		int sg_remaining = sg->length;
 		to = kmap_atomic(sg_page(sg)) + sg->offset;
-		while (sg_remaining > 0) {
+		while (sg_remaining > 0 && read_len > 0) {
 			if (block_remaining == 0) {
 				if (from)
 					kunmap_atomic(from);
@@ -701,6 +701,8 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 			}
 			copy_bytes = min_t(size_t, sg_remaining,
 					block_remaining);
+			if (read_len < copy_bytes)
+				copy_bytes = read_len;
 			offset = DATA_BLOCK_SIZE - block_remaining;
 			tcmu_flush_dcache_range(from, copy_bytes);
 			memcpy(to + sg->length - sg_remaining, from + offset,
@@ -708,8 +710,11 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 
 			sg_remaining -= copy_bytes;
 			block_remaining -= copy_bytes;
+			read_len -= copy_bytes;
 		}
 		kunmap_atomic(to - sg->offset);
+		if (read_len == 0)
+			break;
 	}
 	if (from)
 		kunmap_atomic(from);
@@ -1042,6 +1047,8 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 {
 	struct se_cmd *se_cmd = cmd->se_cmd;
 	struct tcmu_dev *udev = cmd->tcmu_dev;
+	bool read_len_valid = false;
+	uint32_t read_len = se_cmd->data_length;
 
 	/*
 	 * cmd has been completed already from timeout, just reclaim
@@ -1056,13 +1063,28 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		pr_warn("TCMU: Userspace set UNKNOWN_OP flag on se_cmd %p\n",
 			cmd->se_cmd);
 		entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION;
-	} else if (entry->rsp.scsi_status == SAM_STAT_CHECK_CONDITION) {
+		goto done;
+	}
+
+	if (se_cmd->data_direction == DMA_FROM_DEVICE &&
+	    (entry->hdr.uflags & TCMU_UFLAG_READ_LEN) && entry->rsp.read_len) {
+		read_len_valid = true;
+		if (entry->rsp.read_len < read_len)
+			read_len = entry->rsp.read_len;
+	}
+
+	if (entry->rsp.scsi_status == SAM_STAT_CHECK_CONDITION) {
 		transport_copy_sense_to_cmd(se_cmd, entry->rsp.sense_buffer);
-	} else if (se_cmd->se_cmd_flags & SCF_BIDI) {
+		if (!read_len_valid )
+			goto done;
+		else
+			se_cmd->se_cmd_flags |= SCF_TREAT_READ_AS_NORMAL;
+	}
+	if (se_cmd->se_cmd_flags & SCF_BIDI) {
 		/* Get Data-In buffer before clean up */
-		gather_data_area(udev, cmd, true);
+		gather_data_area(udev, cmd, true, read_len);
 	} else if (se_cmd->data_direction == DMA_FROM_DEVICE) {
-		gather_data_area(udev, cmd, false);
+		gather_data_area(udev, cmd, false, read_len);
 	} else if (se_cmd->data_direction == DMA_TO_DEVICE) {
 		/* TODO: */
 	} else if (se_cmd->data_direction != DMA_NONE) {
@@ -1070,7 +1092,13 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 			se_cmd->data_direction);
 	}
 
-	target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
+done:
+	if (read_len_valid) {
+		pr_debug("read_len = %d\n", read_len);
+		target_complete_cmd_with_length(cmd->se_cmd,
+					entry->rsp.scsi_status, read_len);
+	} else
+		target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
 
 out:
 	cmd->se_cmd = NULL;
@@ -1740,7 +1768,7 @@ static int tcmu_configure_device(struct se_device *dev)
 	/* Initialise the mailbox of the ring buffer */
 	mb = udev->mb_addr;
 	mb->version = TCMU_MAILBOX_VERSION;
-	mb->flags = TCMU_MAILBOX_FLAG_CAP_OOOC;
+	mb->flags = TCMU_MAILBOX_FLAG_CAP_OOOC | TCMU_MAILBOX_FLAG_CAP_READ_LEN;
 	mb->cmdr_off = CMDR_OFF;
 	mb->cmdr_size = udev->cmdr_size;
 
diff --git a/include/uapi/linux/target_core_user.h b/include/uapi/linux/target_core_user.h
index 6e299349b158..b7b57967d90f 100644
--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -44,6 +44,7 @@
 #define TCMU_MAILBOX_VERSION 2
 #define ALIGN_SIZE 64 /* Should be enough for most CPUs */
 #define TCMU_MAILBOX_FLAG_CAP_OOOC (1 << 0) /* Out-of-order completions */
+#define TCMU_MAILBOX_FLAG_CAP_READ_LEN (1 << 1) /* Read data length */
 
 struct tcmu_mailbox {
 	__u16 version;
@@ -71,6 +72,7 @@ struct tcmu_cmd_entry_hdr {
 	__u16 cmd_id;
 	__u8 kflags;
 #define TCMU_UFLAG_UNKNOWN_OP 0x1
+#define TCMU_UFLAG_READ_LEN   0x2
 	__u8 uflags;
 
 } __packed;
@@ -119,7 +121,7 @@ struct tcmu_cmd_entry {
 			__u8 scsi_status;
 			__u8 __pad1;
 			__u16 __pad2;
-			__u32 __pad3;
+			__u32 read_len;
 			char sense_buffer[TCMU_SENSE_BUFFERSIZE];
 		} rsp;
 	};
