From: Jose Castillo <jcastillo@redhat.com>
Subject: [PATCH] bnx2fc: Show information about log levels in 'modinfo'
Date: Fri, 29 Jan 2016 14:39:26 +0000
Message-ID: <1454078366-1839-1-git-send-email-jcastillo@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292AbcA2Oj2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jan 2016 09:39:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org

This patch adds the information of the different values that can be used
in the module parameter 'debug_logging', as it is shown below:

$ modinfo bnx2fc
[...]
parm:           debug_logging:Option to enable extended logging,
		Default is 0 - no logging.
		0x01 - SCSI cmd error, cleanup.
		0x02 - Session setup, cleanup, etc.
		0x04 - lport events, link, mtu, etc.
		0x08 - ELS logs.
		0x10 - fcoe L2 fame related logs.
		0xff - LOG all messages. (int)

Signed-off-by: Jose Castillo <jcastillo@redhat.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 67405c6..d7029ea 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -97,6 +97,15 @@ static void __exit bnx2fc_mod_exit(void);
 
 unsigned int bnx2fc_debug_level;
 module_param_named(debug_logging, bnx2fc_debug_level, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(debug_logging,
+		"Option to enable extended logging,\n"
+		"\t\tDefault is 0 - no logging.\n"
+		"\t\t0x01 - SCSI cmd error, cleanup.\n"
+		"\t\t0x02 - Session setup, cleanup, etc.\n"
+		"\t\t0x04 - lport events, link, mtu, etc.\n"
+		"\t\t0x08 - ELS logs.\n"
+		"\t\t0x10 - fcoe L2 fame related logs.\n"
+		"\t\t0xff - LOG all messages.");
 
 static int bnx2fc_cpu_callback(struct notifier_block *nfb,
 			     unsigned long action, void *hcpu);
-- 
2.1.0

