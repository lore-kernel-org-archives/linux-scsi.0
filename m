From: vikas.chaudhary@qlogic.com
Subject: [PATCH 2/5] qla4xxx: Restrict logout from boot target session using session id
Date: Fri,  5 Apr 2013 07:06:07 -0400
Message-ID: <1365159970-17672-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1365159970-17672-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:5820 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751250Ab3DEL3k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Apr 2013 07:29:40 -0400
In-Reply-To: <1365159970-17672-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 5f7a2bc..f82efcb 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5916,6 +5916,14 @@ static int qla4xxx_sysfs_ddb_logout_sid(struct iscsi_cls_session *cls_sess)
 		goto exit_ddb_logout;
 	}
 
+	if (test_bit(DF_BOOT_TGT, &ddb_entry->flags)) {
+		ql4_printk(KERN_ERR, ha,
+			   "%s: Logout from boot target entry is not permitted.\n",
+			   __func__);
+		ret = -EPERM;
+		goto exit_ddb_logout;
+	}
+
 	options = LOGOUT_OPTION_CLOSE_SESSION;
 	if (qla4xxx_session_logout_ddb(ha, ddb_entry, options) == QLA_ERROR) {
 		ql4_printk(KERN_ERR, ha, "%s: Logout failed\n", __func__);
-- 
1.8.2.GIT

