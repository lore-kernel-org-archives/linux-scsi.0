From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 4/6] qla4xxx: Add change_queue_depth API support
Date: Mon, 23 Apr 2012 22:32:35 -0700
Message-ID: <1335245557-17169-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1335245557-17169-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:20597
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295Ab2DXFsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2012 01:48:10 -0400
In-Reply-To: <1335245557-17169-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

From: Tej Parkash <tej.parkash@qlogic.com>

change_queue_depth will adjust device queuedepth upon receiving
"SAM_STAT_TASK_SET_FULL" scsi status from the target.
Also added ql4xqfulltracking command line param to enable or disable
queuefull tracking. One can disabling queuefull tracking to ensure
user set scsi device queuedepth is not altered.

Signed-off-by: Tej Parkash <tej.parkash@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 45144aa..613c119 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -68,6 +68,14 @@ MODULE_PARM_DESC(ql4xmaxqdepth,
 		 " Maximum queue depth to report for target devices.\n"
 		 "\t\t  Default: 32.");
 
+static int ql4xqfulltracking = 1;
+module_param(ql4xqfulltracking, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ql4xqfulltracking,
+		 " Enable or disable dynamic tracking and adjustment of\n"
+		 "\t\t scsi device queue depth.\n"
+		 "\t\t  0 - Disable.\n"
+		 "\t\t  1 - Enable. (Default)");
+
 static int ql4xsess_recovery_tmo = QL4_SESS_RECOVERY_TMO;
 module_param(ql4xsess_recovery_tmo, int, S_IRUGO);
 MODULE_PARM_DESC(ql4xsess_recovery_tmo,
@@ -140,6 +148,8 @@ static int qla4xxx_slave_configure(struct scsi_device *device);
 static void qla4xxx_slave_destroy(struct scsi_device *sdev);
 static umode_t ql4_attr_is_visible(int param_type, int param);
 static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type);
+static int qla4xxx_change_queue_depth(struct scsi_device *sdev, int qdepth,
+				      int reason);
 
 static struct qla4_8xxx_legacy_intr_set legacy_intr[] =
     QLA82XX_LEGACY_INTR_CONFIG;
@@ -159,6 +169,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.slave_configure	= qla4xxx_slave_configure,
 	.slave_alloc		= qla4xxx_slave_alloc,
 	.slave_destroy		= qla4xxx_slave_destroy,
+	.change_queue_depth	= qla4xxx_change_queue_depth,
 
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
@@ -5251,6 +5262,17 @@ static void qla4xxx_slave_destroy(struct scsi_device *sdev)
 	scsi_deactivate_tcq(sdev, 1);
 }
 
+static int qla4xxx_change_queue_depth(struct scsi_device *sdev, int qdepth,
+				      int reason)
+{
+	int queue_depth;
+	if (!ql4xqfulltracking)
+		return -EOPNOTSUPP;
+
+	queue_depth = iscsi_change_queue_depth(sdev, qdepth, reason);
+	return queue_depth;
+}
+
 /**
  * qla4xxx_del_from_active_array - returns an active srb
  * @ha: Pointer to host adapter structure.
-- 
1.7.9.1.265.gb3a76


