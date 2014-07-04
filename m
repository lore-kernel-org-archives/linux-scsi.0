From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/2] ib_srp: 64bit LUN fixes
Date: Fri, 04 Jul 2014 18:53:10 +0200
Message-ID: <53B6DBF6.5060702@acm.org>
References: <1404474875-109997-1-git-send-email-hare@suse.de> <1404474875-109997-3-git-send-email-hare@suse.de> <53B69E97.4050901@acm.org> <53B6A5B4.2040807@suse.de> <20140704134835.GB12345@infradead.org> <53B6B669.10704@suse.de> <53B6BC72.6040204@acm.org> <53B6BD14.5050606@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:45366 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaGDQxR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2014 12:53:17 -0400
In-Reply-To: <53B6BD14.5050606@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 07/04/14 16:41, Hannes Reinecke wrote:
> On 07/04/2014 04:38 PM, Bart Van Assche wrote:
>> On 07/04/14 16:12, Hannes Reinecke wrote:
>>> On 07/04/2014 03:48 PM, Christoph Hellwig wrote:
>>>> I think storing the struct scsi_lun in the scsi_device is the right way
>>>> to go ahead.  Any "accessors" for 8 or 32-bit LUNs should be simply
>>>> enough by just ignoring bits in the array, so there's very little
>>>> performance overhead.
>>>>
>>>> If we can get rid of the old scalar LUN field that would be great,
>>>> and given that we know the printk format fallout already it doesn't
>>>> look
>>>> like too much work.  Do you want to look into this?
>>>
>>> Already working on it.
>>
>> That sounds great. Regarding the SRP initiator driver: if the "__be64
>> lun" declarations in <scsi/srp.h> are changed into "struct scsi_lun lun"
>> then that allows to encode / decode LUNs inside the SRP initiator
>> without having to cast the address of these "lun" members into struct
>> scsi_lun *. In case you would prefer me to have a look into this, please
>> let me know.
>>
> That would be perfect.
> Most of the HBAs supporting 64bit LUNs internally are already doing this.

Here it is (compile tested only on x86 and ppc - will do more testing
once the entire series is available). Please CC all maintainers and
relevant mailing lists for the next version of the 64-bit LUN patch
series. Several IB/SRP users are reading the linux-rdma mailing list
but not the linux-scsi mailing list.


From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 4 Jul 2014 17:11:31 +0200
Subject: [PATCH] SRP: Convert lun into struct scsi_lun

Checked the following structure sizes with gdb:
* sizeof(struct srp_cmd) = 48
* sizeof(struct srp_tsk_mgmt) = 48
* sizeof(struct srp_aer_req) = 36

The ibmvscsi changes have been compile tested only (on a PPC system).

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c   |  6 ++--
 drivers/infiniband/ulp/srpt/ib_srpt.c | 68 ++---------------------------------
 drivers/scsi/ibmvscsi/ibmvscsi.c      |  6 ++--
 drivers/scsi/libsrp.c                 |  7 ++--
 include/scsi/srp.h                    |  6 ++--
 5 files changed, 14 insertions(+), 79 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b017a3a..a04f245 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1719,7 +1719,7 @@ static void srp_process_aer_req(struct srp_target_port *target,
 	s32 delta = be32_to_cpu(req->req_lim_delta);
 
 	shost_printk(KERN_ERR, target->scsi_host, PFX
-		     "ignoring AER for LUN %llu\n", be64_to_cpu(req->lun));
+		     "ignoring AER for LUN %u\n", scsilun_to_int(&req->lun));
 
 	if (srp_response_common(target, delta, &rsp, sizeof rsp))
 		shost_printk(KERN_ERR, target->scsi_host, PFX
@@ -1914,7 +1914,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	memset(cmd, 0, sizeof *cmd);
 
 	cmd->opcode = SRP_CMD;
-	cmd->lun    = cpu_to_be64((u64) scmnd->device->lun << 48);
+	int_to_scsilun(scmnd->device->lun, &cmd->lun);
 	cmd->tag    = req->index;
 	memcpy(cmd->cdb, scmnd->cmnd, scmnd->cmd_len);
 
@@ -2365,7 +2365,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	memset(tsk_mgmt, 0, sizeof *tsk_mgmt);
 
 	tsk_mgmt->opcode 	= SRP_TSK_MGMT;
-	tsk_mgmt->lun		= cpu_to_be64((u64) lun << 48);
+	int_to_scsilun(lun, &tsk_mgmt->lun);
 	tsk_mgmt->tag		= req_tag | SRP_TAG_TSK_MGMT;
 	tsk_mgmt->tsk_mgmt_func = func;
 	tsk_mgmt->task_tag	= req_tag;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index fe09f27..8a52cec 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1614,68 +1614,6 @@ enum scsi_lun_addr_method {
 	SCSI_LUN_ADDR_METHOD_EXTENDED_LUN = 3,
 };
 
-/*
- * srpt_unpack_lun() - Convert from network LUN to linear LUN.
- *
- * Convert an 2-byte, 4-byte, 6-byte or 8-byte LUN structure in network byte
- * order (big endian) to a linear LUN. Supports three LUN addressing methods:
- * peripheral, flat and logical unit. See also SAM-2, section 4.9.4 (page 40).
- */
-static uint64_t srpt_unpack_lun(const uint8_t *lun, int len)
-{
-	uint64_t res = NO_SUCH_LUN;
-	int addressing_method;
-
-	if (unlikely(len < 2)) {
-		printk(KERN_ERR "Illegal LUN length %d, expected 2 bytes or "
-		       "more", len);
-		goto out;
-	}
-
-	switch (len) {
-	case 8:
-		if ((*((__be64 *)lun) &
-		     __constant_cpu_to_be64(0x0000FFFFFFFFFFFFLL)) != 0)
-			goto out_err;
-		break;
-	case 4:
-		if (*((__be16 *)&lun[2]) != 0)
-			goto out_err;
-		break;
-	case 6:
-		if (*((__be32 *)&lun[2]) != 0)
-			goto out_err;
-		break;
-	case 2:
-		break;
-	default:
-		goto out_err;
-	}
-
-	addressing_method = (*lun) >> 6; /* highest two bits of byte 0 */
-	switch (addressing_method) {
-	case SCSI_LUN_ADDR_METHOD_PERIPHERAL:
-	case SCSI_LUN_ADDR_METHOD_FLAT:
-	case SCSI_LUN_ADDR_METHOD_LUN:
-		res = *(lun + 1) | (((*lun) & 0x3f) << 8);
-		break;
-
-	case SCSI_LUN_ADDR_METHOD_EXTENDED_LUN:
-	default:
-		printk(KERN_ERR "Unimplemented LUN addressing method %u",
-		       addressing_method);
-		break;
-	}
-
-out:
-	return res;
-
-out_err:
-	printk(KERN_ERR "Support for multi-level LUNs has not yet been"
-	       " implemented");
-	goto out;
-}
-
 static int srpt_check_stop_free(struct se_cmd *cmd)
 {
 	struct srpt_send_ioctx *ioctx = container_of(cmd,
@@ -1728,8 +1666,7 @@ static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		goto send_sense;
 	}
 
-	unpacked_lun = srpt_unpack_lun((uint8_t *)&srp_cmd->lun,
-				       sizeof(srp_cmd->lun));
+	unpacked_lun = scsilun_to_int(&srp_cmd->lun);
 	rc = target_submit_cmd(cmd, ch->sess, srp_cmd->cdb,
 			&send_ioctx->sense_data[0], unpacked_lun, data_len,
 			MSG_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
@@ -1840,8 +1777,7 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 			TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
 		goto fail;
 	}
-	unpacked_lun = srpt_unpack_lun((uint8_t *)&srp_tsk->lun,
-				       sizeof(srp_tsk->lun));
+	unpacked_lun = scsilun_to_int(&srp_tsk->lun);
 
 	if (srp_tsk->tsk_mgmt_func == SRP_TSK_ABORT_TASK) {
 		rc = srpt_rx_mgmt_fn_tag(send_ioctx, srp_tsk->task_tag);
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 2ebfb2b..34fcfc5 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1042,7 +1042,7 @@ static int ibmvscsi_queuecommand_lck(struct scsi_cmnd *cmnd,
 	memset(srp_cmd, 0x00, SRP_MAX_IU_LEN);
 	srp_cmd->opcode = SRP_CMD;
 	memcpy(srp_cmd->cdb, cmnd->cmnd, sizeof(srp_cmd->cdb));
-	srp_cmd->lun = cpu_to_be64(((u64)lun) << 48);
+	int_to_scsilun(lun, &srp_cmd->lun);
 
 	if (!map_data_for_srp_cmd(cmnd, evt_struct, srp_cmd, hostdata->dev)) {
 		if (!firmware_has_feature(FW_FEATURE_CMO))
@@ -1518,7 +1518,7 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
 		/* Set up an abort SRP command */
 		memset(tsk_mgmt, 0x00, sizeof(*tsk_mgmt));
 		tsk_mgmt->opcode = SRP_TSK_MGMT;
-		tsk_mgmt->lun = cpu_to_be64(((u64) lun) << 48);
+		int_to_scsilun(lun, &tsk_mgmt->lun);
 		tsk_mgmt->tsk_mgmt_func = SRP_TSK_ABORT_TASK;
 		tsk_mgmt->task_tag = (u64) found_evt;
 
@@ -1641,7 +1641,7 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 		/* Set up a lun reset SRP command */
 		memset(tsk_mgmt, 0x00, sizeof(*tsk_mgmt));
 		tsk_mgmt->opcode = SRP_TSK_MGMT;
-		tsk_mgmt->lun = cpu_to_be64(((u64) lun) << 48);
+		int_to_scsilun(lun, &tsk_mgmt->lun);
 		tsk_mgmt->tsk_mgmt_func = SRP_TSK_LUN_RESET;
 
 		evt->sync_srp = &srp_rsp;
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 0707ecd..0768051 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -421,8 +421,8 @@ int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
 	dir = srp_cmd_direction(cmd);
 	len = vscsis_data_length(cmd, dir);
 
-	dprintk("%p %x %lx %d %d %d %llx\n", info, cmd->cdb[0],
-		cmd->lun, dir, len, tag, (unsigned long long) cmd->tag);
+	dprintk("%p %x %u %d %d %d %llx\n", info, cmd->cdb[0],
+		scsilun_to_int(&cmd->lun), dir, len, tag, cmd->tag);
 
 	sc = scsi_host_get_command(shost, dir, GFP_KERNEL);
 	if (!sc)
@@ -433,8 +433,7 @@ int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
 	sc->sdb.length = len;
 	sc->sdb.table.sgl = (void *) (unsigned long) addr;
 	sc->tag = tag;
-	err = scsi_tgt_queue_command(sc, itn_id, (struct scsi_lun *)&cmd->lun,
-				     cmd->tag);
+	err = scsi_tgt_queue_command(sc, itn_id, &cmd->lun, cmd->tag);
 	if (err)
 		scsi_host_put_command(shost, sc);
 
diff --git a/include/scsi/srp.h b/include/scsi/srp.h
index 1ae84db..4844516 100644
--- a/include/scsi/srp.h
+++ b/include/scsi/srp.h
@@ -179,7 +179,7 @@ struct srp_tsk_mgmt {
 	u8	reserved1[6];
 	u64	tag;
 	u8	reserved2[4];
-	__be64	lun __attribute__((packed));
+	struct scsi_lun	lun;
 	u8	reserved3[2];
 	u8	tsk_mgmt_func;
 	u8	reserved4;
@@ -200,7 +200,7 @@ struct srp_cmd {
 	u8	data_in_desc_cnt;
 	u64	tag;
 	u8	reserved2[4];
-	__be64	lun __attribute__((packed));
+	struct scsi_lun	lun;
 	u8	reserved3;
 	u8	task_attr;
 	u8	reserved4;
@@ -265,7 +265,7 @@ struct srp_aer_req {
 	__be32	req_lim_delta;
 	u64	tag;
 	u32	reserved2;
-	__be64	lun;
+	struct scsi_lun	lun;
 	__be32	sense_data_len;
 	u32	reserved3;
 	u8	sense_data[0];
-- 
1.8.4.5


