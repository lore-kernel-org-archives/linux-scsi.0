From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 09/13] qla4xxx: add support for ql4xsess_recovery_tmo cmd
 line param
Date: Sun, 13 Mar 2011 22:25:17 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872263B150F@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:15945
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935Ab1CNFZY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 01:25:24 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

This will allow to modify Target Session Recovery Timeout from cmd line
while loading driver.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c7c675b..61b599a 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -62,6 +62,12 @@ MODULE_PARM_DESC(ql4xmaxqdepth,
                "Maximum queue depth to report for target devices.\n"
                " Default: 32.");

+static int ql4xsess_recovery_tmo = QL4_SESS_RECOVERY_TMO;
+module_param(ql4xsess_recovery_tmo, int, S_IRUGO);
+MODULE_PARM_DESC(ql4xsess_recovery_tmo,
+               "Target Session Recovery Timeout.\n"
+               " Default: 30 sec.");
+
 /*
  * SCSI host template entry points
  */
@@ -171,7 +177,7 @@ static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
                DEBUG2(printk("scsi%ld: %s: ddb [%d] session recovery timeout "
                              "of (%d) secs exhausted, marking device DEAD.\n",
                              ha->host_no, __func__, ddb_entry->fw_ddb_index,
-                             QL4_SESS_RECOVERY_TMO));
+                             ddb_entry->sess->recovery_tmo));
        }
 }

@@ -301,7 +307,7 @@ int qla4xxx_add_sess(struct ddb_entry *ddb_entry)
 {
        int err;

-       ddb_entry->sess->recovery_tmo = QL4_SESS_RECOVERY_TMO;
+       ddb_entry->sess->recovery_tmo = ql4xsess_recovery_tmo;

        err = iscsi_add_session(ddb_entry->sess, ddb_entry->fw_ddb_index);
        if (err) {
--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

