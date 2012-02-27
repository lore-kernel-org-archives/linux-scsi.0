From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 7/8] qla4xxx: trivial cleanup
Date: Mon, 27 Feb 2012 03:08:57 -0800
Message-ID: <1330340938-12893-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1330340938-12893-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:56107
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753385Ab2B0LWa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2012 06:22:30 -0500
In-Reply-To: <1330340938-12893-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

 1. Do not initialise globals to 0
 2. Fix wrong spelling in debug message
 3. Modified debug log messages

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c  |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index b2d336c..7ac21da 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -622,7 +622,7 @@ int qla4xxx_get_firmware_status(struct scsi_qla_host * ha)
 		return QLA_ERROR;
 	}
 
-	ql4_printk(KERN_INFO, ha, "%ld firmare IOCBs available (%d).\n",
+	ql4_printk(KERN_INFO, ha, "%ld firmware IOCBs available (%d).\n",
 	    ha->host_no, mbox_sts[2]);
 
 	return QLA_SUCCESS;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d1520ad..281328d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -39,7 +39,7 @@ MODULE_PARM_DESC(ql4xdisablesysfsboot,
 		 "\t\t  0 - Export boot targets\n"
 		 "\t\t  1 - Do not export boot targets (Default)");
 
-int ql4xdontresethba = 0;
+int ql4xdontresethba;
 module_param(ql4xdontresethba, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql4xdontresethba,
 		 " Don't reset the HBA for driver recovery.\n"
@@ -71,7 +71,7 @@ MODULE_PARM_DESC(ql4xmaxqdepth,
 static int ql4xsess_recovery_tmo = QL4_SESS_RECOVERY_TMO;
 module_param(ql4xsess_recovery_tmo, int, S_IRUGO);
 MODULE_PARM_DESC(ql4xsess_recovery_tmo,
-		"Target Session Recovery Timeout.\n"
+		" Target Session Recovery Timeout.\n"
 		"\t\t  Default: 120 sec.");
 
 static int qla4xxx_wait_for_hba_online(struct scsi_qla_host *ha);
@@ -5033,8 +5033,8 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	       ha->patch_number, ha->build_number);
 
 	if (qla4xxx_setup_boot_info(ha))
-		ql4_printk(KERN_ERR, ha, "%s:ISCSI boot info setup failed\n",
-			   __func__);
+		ql4_printk(KERN_ERR, ha,
+			   "%s: No iSCSI boot target configured\n", __func__);
 
 		/* Perform the build ddb list and login to each */
 	qla4xxx_build_ddb_list(ha, INIT_ADAPTER);
-- 
1.7.9.1.265.gb3a76


