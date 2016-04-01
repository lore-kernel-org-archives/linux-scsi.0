From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 1/5] bnx2fc: Add driver tunables.
Date: Fri, 1 Apr 2016 09:10:19 -0400
Message-ID: <1459516223-32106-2-git-send-email-chad.dupuis@qlogic.com>
References: <1459516223-32106-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:37534 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755484AbcDANvf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2016 09:51:35 -0400
In-Reply-To: <1459516223-32106-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chad.dupuis@qlogic.com, saurav.kashyap@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Per customer request, add the following driver tunables:

o devloss_tmo
o max_luns
o queue_depth
o tm_timeout

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 38 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/bnx2fc/bnx2fc_io.c   |  4 +++-
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index d7029ea..600c29d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -107,6 +107,26 @@ MODULE_PARM_DESC(debug_logging,
 		"\t\t0x10 - fcoe L2 fame related logs.\n"
 		"\t\t0xff - LOG all messages.");
 
+uint bnx2fc_devloss_tmo;
+module_param_named(devloss_tmo, bnx2fc_devloss_tmo, uint, S_IRUGO);
+MODULE_PARM_DESC(devloss_tmo, " Change devloss_tmo for the remote ports "
+	"attached via bnx2fc.");
+
+uint bnx2fc_max_luns = BNX2FC_MAX_LUN;
+module_param_named(max_luns, bnx2fc_max_luns, uint, S_IRUGO);
+MODULE_PARM_DESC(max_luns, " Change the default max_lun per SCSI host. Default "
+	"0xffff.");
+
+uint bnx2fc_queue_depth;
+module_param_named(queue_depth, bnx2fc_queue_depth, uint, S_IRUGO);
+MODULE_PARM_DESC(queue_depth, " Change the default queue depth of SCSI devices "
+	"attached via bnx2fc.");
+
+uint bnx2fc_tm_timeout = BNX2FC_TM_TIMEOUT;
+module_param_named(tm_timeout, bnx2fc_tm_timeout, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(tm_timeout, " Change the default timeout for "
+	"task management commands. Default 60 seconds.");
+
 static int bnx2fc_cpu_callback(struct notifier_block *nfb,
 			     unsigned long action, void *hcpu);
 /* notification function for CPU hotplug events */
@@ -692,7 +712,7 @@ static int bnx2fc_shost_config(struct fc_lport *lport, struct device *dev)
 	int rc = 0;
 
 	shost->max_cmd_len = BNX2FC_MAX_CMD_LEN;
-	shost->max_lun = BNX2FC_MAX_LUN;
+	shost->max_lun = bnx2fc_max_luns;
 	shost->max_id = BNX2FC_MAX_FCP_TGT;
 	shost->max_channel = 0;
 	if (lport->vport)
@@ -1102,6 +1122,9 @@ static int bnx2fc_vport_create(struct fc_vport *vport, bool disabled)
 		return -EIO;
 	}
 
+	if (bnx2fc_devloss_tmo)
+		fc_host_dev_loss_tmo(vn_port->host) = bnx2fc_devloss_tmo;
+
 	if (disabled) {
 		fc_vport_set_state(vport, FC_VPORT_DISABLED);
 	} else {
@@ -1495,6 +1518,9 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_interface *interface,
 	}
 	fc_host_port_type(lport->host) = FC_PORTTYPE_UNKNOWN;
 
+	if (bnx2fc_devloss_tmo)
+		fc_host_dev_loss_tmo(shost) = bnx2fc_devloss_tmo;
+
 	/* Allocate exchange manager */
 	if (!npiv)
 		rc = bnx2fc_em_config(lport, hba);
@@ -2612,6 +2638,15 @@ static int bnx2fc_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
+static int bnx2fc_slave_configure(struct scsi_device *sdev)
+{
+	if (!bnx2fc_queue_depth)
+		return 0;
+
+	scsi_change_queue_depth(sdev, bnx2fc_queue_depth);
+	return 0;
+}
+
 /**
  * bnx2fc_mod_init - module init entry point
  *
@@ -2877,6 +2912,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.sg_tablesize		= BNX2FC_MAX_BDS_PER_CMD,
 	.max_sectors		= 1024,
 	.track_queue_depth	= 1,
+	.slave_configure = bnx2fc_slave_configure,
 };
 
 static struct libfc_function_template bnx2fc_libfc_fcn_templ = {
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 0002caf..0f60e22 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -15,6 +15,8 @@
 
 #define RESERVE_FREE_LIST_INDEX num_possible_cpus()
 
+extern uint bnx2fc_tm_timeout;
+
 static int bnx2fc_split_bd(struct bnx2fc_cmd *io_req, u64 addr, int sg_len,
 			   int bd_index);
 static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req);
@@ -770,7 +772,7 @@ retry_tmf:
 	spin_unlock_bh(&tgt->tgt_lock);
 
 	rc = wait_for_completion_timeout(&io_req->tm_done,
-					 BNX2FC_TM_TIMEOUT * HZ);
+					 bnx2fc_tm_timeout * HZ);
 	spin_lock_bh(&tgt->tgt_lock);
 
 	io_req->wait_for_comp = 0;
-- 
2.0.0.rc0.26.g779792a

