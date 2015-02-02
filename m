From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] IB/srp: Add 64-bit LUN support
Date: Mon, 2 Feb 2015 18:21:44 +0100
Message-ID: <54CFB228.4070208@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0086.outbound.protection.outlook.com ([157.56.111.86]:13584
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751663AbbBBRWC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2015 12:22:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Brian King <brking@linux.vnet.ibm.com>, Nathan Fontenot <nfont@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

The largest LUN number that has been tested is 0xd2003fff00000000.

Checked the following structure sizes with gdb:
* sizeof(struct srp_cmd) = 48
* sizeof(struct srp_tsk_mgmt) = 48
* sizeof(struct srp_aer_req) = 36

The ibmvscsi changes have been compile tested only (on a PPC system).

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 8 ++++----
 drivers/scsi/ibmvscsi/ibmvscsi.c    | 6 +++---
 include/scsi/srp.h                  | 7 ++++---
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0747c05..e43cb86 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1841,7 +1841,7 @@ static void srp_process_aer_req(struct srp_rdma_ch *ch,
 	s32 delta = be32_to_cpu(req->req_lim_delta);
 
 	shost_printk(KERN_ERR, target->scsi_host, PFX
-		     "ignoring AER for LUN %llu\n", be64_to_cpu(req->lun));
+		     "ignoring AER for LUN %llu\n", scsilun_to_int(&req->lun));
 
 	if (srp_response_common(ch, delta, &rsp, sizeof(rsp)))
 		shost_printk(KERN_ERR, target->scsi_host, PFX
@@ -2033,7 +2033,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	memset(cmd, 0, sizeof *cmd);
 
 	cmd->opcode = SRP_CMD;
-	cmd->lun    = cpu_to_be64((u64) scmnd->device->lun << 48);
+	int_to_scsilun(scmnd->device->lun, &cmd->lun);
 	cmd->tag    = tag;
 	memcpy(cmd->cdb, scmnd->cmnd, scmnd->cmd_len);
 
@@ -2448,7 +2448,7 @@ static int srp_send_tsk_mgmt(struct srp_rdma_ch *ch, u64 req_tag,
 	memset(tsk_mgmt, 0, sizeof *tsk_mgmt);
 
 	tsk_mgmt->opcode 	= SRP_TSK_MGMT;
-	tsk_mgmt->lun		= cpu_to_be64((u64) lun << 48);
+	int_to_scsilun(lun, &tsk_mgmt->lun);
 	tsk_mgmt->tag		= req_tag | SRP_TAG_TSK_MGMT;
 	tsk_mgmt->tsk_mgmt_func = func;
 	tsk_mgmt->task_tag	= req_tag;
@@ -3145,7 +3145,7 @@ static ssize_t srp_create_target(struct device *dev,
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

