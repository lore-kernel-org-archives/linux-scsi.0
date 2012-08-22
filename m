From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 35/42] qla2xxx: Restrict nic core reset to one function for mctp.
Date: Wed, 22 Aug 2012 14:21:29 -0400
Message-ID: <1345659696-3670-36-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:48005 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S965013Ab2HVSig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:36 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ba3a2fa..5dff3be 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4153,7 +4153,7 @@ qla2xxx_mctp_dump(scsi_qla_host_t *vha)
 		ha->mctp_dumped = 1;
 	}
 
-	if (!ha->flags.nic_core_reset_hdlr_active) {
+	if (!ha->flags.nic_core_reset_hdlr_active && !ha->portnum) {
 		ha->flags.nic_core_reset_hdlr_active = 1;
 		if ((rval = qla83xx_restart_nic_firmware(vha)))
 			/* NIC Core reset failed. */
-- 
1.7.7

