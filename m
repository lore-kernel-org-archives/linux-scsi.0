From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH, resend] IB/srp: Add 64-bit LUN support
Date: Wed, 4 Mar 2015 11:01:17 +0100
Message-ID: <54F6D7ED.3080606@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Nathan Fontenot <nfont-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Tyrel Datwyler <tyreld-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The SCSI standard defines 64-bit values for LUNs. Large arrays
employing large or hierarchical LUN numbers become more and more
common. So update the SRP initiator to use 64-bit LUN numbers.
See also Hannes Reinecke, commit 9cb78c16f5da ("scsi: use 64-bit LUNs"),
June 2014.

The largest LUN number that has been tested is 0xd2003fff00000000.

Checked the following structure sizes with gdb:
* sizeof(struct srp_cmd) = 48
* sizeof(struct srp_tsk_mgmt) = 48
* sizeof(struct srp_aer_req) = 36

The ibmvscsi changes have been compile tested only on a PPC system.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Nathan Fontenot <nfont-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Tyrel Datwyler <tyreld-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 12 ++++++------
 drivers/scsi/ibmvscsi/ibmvscsi.c    |  6 +++---
 include/scsi/srp.h                  |  7 ++++---
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a0e24a8..e427454 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1842,7 +1842,7 @@ static void srp_process_aer_req(struct srp_rdma_ch *ch,
 	s32 delta = be32_to_cpu(req->req_lim_delta);
 
 	shost_printk(KERN_ERR, target->scsi_host, PFX
-		     "ignoring AER for LUN %llu\n", be64_to_cpu(req->lun));
+		     "ignoring AER for LUN %llu\n", scsilun_to_int(&req->lun));
 
 	if (srp_response_common(ch, delta, &rsp, sizeof(rsp)))
 		shost_printk(KERN_ERR, target->scsi_host, PFX
@@ -2034,7 +2034,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	memset(cmd, 0, sizeof *cmd);
 
 	cmd->opcode = SRP_CMD;
-	cmd->lun    = cpu_to_be64((u64) scmnd->device->lun << 48);
+	int_to_scsilun(scmnd->device->lun, &cmd->lun);
 	cmd->tag    = tag;
 	memcpy(cmd->cdb, scmnd->cmnd, scmnd->cmd_len);
 
@@ -2414,8 +2414,8 @@ srp_change_queue_depth(struct scsi_device *sdev, int qdepth)
 	return scsi_change_queue_depth(sdev, qdepth);
 }
 
-static int srp_send_tsk_mgmt(struct srp_rdma_ch *ch, u64 req_tag,
-			     unsigned int lun, u8 func)
+static int srp_send_tsk_mgmt(struct srp_rdma_ch *ch, u64 req_tag, u64 lun,
+			     u8 func)
 {
 	struct srp_target_port *target = ch->target;
 	struct srp_rport *rport = target->rport;
@@ -2449,7 +2449,7 @@ static int srp_send_tsk_mgmt(struct srp_rdma_ch *ch, u64 req_tag,
 	memset(tsk_mgmt, 0, sizeof *tsk_mgmt);
 
 	tsk_mgmt->opcode 	= SRP_TSK_MGMT;
-	tsk_mgmt->lun		= cpu_to_be64((u64) lun << 48);
+	int_to_scsilun(lun, &tsk_mgmt->lun);
 	tsk_mgmt->tag		= req_tag | SRP_TAG_TSK_MGMT;
 	tsk_mgmt->tsk_mgmt_func = func;
 	tsk_mgmt->task_tag	= req_tag;
@@ -3146,7 +3146,7 @@ static ssize_t srp_create_target(struct device *dev,
 	target_host->transportt  = ib_srp_transport_template;
 	target_host->max_channel = 0;
 	target_host->max_id      = 1;
-	target_host->max_lun     = SRP_MAX_LUN;
+	target_host->max_lun     = -1LL;
 	target_host->max_cmd_len = sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
 
 	target = host_to_target(target_host);
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index acea5d6..6a41c36 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1053,7 +1053,7 @@ static int ibmvscsi_queuecommand_lck(struct scsi_cmnd *cmnd,
 	memset(srp_cmd, 0x00, SRP_MAX_IU_LEN);
 	srp_cmd->opcode = SRP_CMD;
 	memcpy(srp_cmd->cdb, cmnd->cmnd, sizeof(srp_cmd->cdb));
-	srp_cmd->lun = cpu_to_be64(((u64)lun) << 48);
+	int_to_scsilun(lun, &srp_cmd->lun);
 
 	if (!map_data_for_srp_cmd(cmnd, evt_struct, srp_cmd, hostdata->dev)) {
 		if (!firmware_has_feature(FW_FEATURE_CMO))
@@ -1529,7 +1529,7 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
 		/* Set up an abort SRP command */
 		memset(tsk_mgmt, 0x00, sizeof(*tsk_mgmt));
 		tsk_mgmt->opcode = SRP_TSK_MGMT;
-		tsk_mgmt->lun = cpu_to_be64(((u64) lun) << 48);
+		int_to_scsilun(lun, &tsk_mgmt->lun);
 		tsk_mgmt->tsk_mgmt_func = SRP_TSK_ABORT_TASK;
 		tsk_mgmt->task_tag = (u64) found_evt;
 
@@ -1652,7 +1652,7 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 		/* Set up a lun reset SRP command */
 		memset(tsk_mgmt, 0x00, sizeof(*tsk_mgmt));
 		tsk_mgmt->opcode = SRP_TSK_MGMT;
-		tsk_mgmt->lun = cpu_to_be64(((u64) lun) << 48);
+		int_to_scsilun(lun, &tsk_mgmt->lun);
 		tsk_mgmt->tsk_mgmt_func = SRP_TSK_LUN_RESET;
 
 		evt->sync_srp = &srp_rsp;
diff --git a/include/scsi/srp.h b/include/scsi/srp.h
index 1ae84db..5be834d 100644
--- a/include/scsi/srp.h
+++ b/include/scsi/srp.h
@@ -42,6 +42,7 @@
  */
 
 #include <linux/types.h>
+#include <scsi/scsi.h>
 
 enum {
 	SRP_LOGIN_REQ	= 0x00,
@@ -179,7 +180,7 @@ struct srp_tsk_mgmt {
 	u8	reserved1[6];
 	u64	tag;
 	u8	reserved2[4];
-	__be64	lun __attribute__((packed));
+	struct scsi_lun	lun;
 	u8	reserved3[2];
 	u8	tsk_mgmt_func;
 	u8	reserved4;
@@ -200,7 +201,7 @@ struct srp_cmd {
 	u8	data_in_desc_cnt;
 	u64	tag;
 	u8	reserved2[4];
-	__be64	lun __attribute__((packed));
+	struct scsi_lun	lun;
 	u8	reserved3;
 	u8	task_attr;
 	u8	reserved4;
@@ -265,7 +266,7 @@ struct srp_aer_req {
 	__be32	req_lim_delta;
 	u64	tag;
 	u32	reserved2;
-	__be64	lun;
+	struct scsi_lun	lun;
 	__be32	sense_data_len;
 	u32	reserved3;
 	u8	sense_data[0];
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
