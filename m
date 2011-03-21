From: vikas.chaudhary@qlogic.com
Subject: [PATCH 09/13] qla4xxx: add support for ql4xsess_recovery_tmo cmd line param
Date: Mon, 21 Mar 2011 03:34:32 -0700
Message-ID: <1300703676-27398-9-git-send-email-vikas.chaudhary@qlogic.com>
References: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46162 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753060Ab1CUKqG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 06:46:06 -0400
In-Reply-To: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Target Session Recovery Timeout

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 051c049..4a599d3 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -57,6 +57,12 @@ MODULE_PARM_DESC(ql4xmaxqdepth,
 		"Maximum queue depth to report for target devices.\n"
 		" Default: 32.");
 
+static int ql4xsess_recovery_tmo = QL4_SESS_RECOVERY_TMO;
+module_param(ql4xsess_recovery_tmo, int, S_IRUGO);
+MODULE_PARM_DESC(ql4xsess_recovery_tmo,
+		"Target Session Recovery Timeout.\n"
+		" Default: 30 sec.");
+
 /*
  * SCSI host template entry points
  */
@@ -166,7 +172,7 @@ static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
 		DEBUG2(printk("scsi%ld: %s: ddb [%d] session recovery timeout "
 			      "of (%d) secs exhausted, marking device DEAD.\n",
 			      ha->host_no, __func__, ddb_entry->fw_ddb_index,
-			      QL4_SESS_RECOVERY_TMO));
+			      ddb_entry->sess->recovery_tmo));
 	}
 }
 
@@ -296,7 +302,7 @@ int qla4xxx_add_sess(struct ddb_entry *ddb_entry)
 {
 	int err;
 
-	ddb_entry->sess->recovery_tmo = QL4_SESS_RECOVERY_TMO;
+	ddb_entry->sess->recovery_tmo = ql4xsess_recovery_tmo;
 
 	err = iscsi_add_session(ddb_entry->sess, ddb_entry->fw_ddb_index);
 	if (err) {
-- 
1.7.3.2

