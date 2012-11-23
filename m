From: vikas.chaudhary@qlogic.com
Subject: [PATCH 2/5] qla4xxx: Allow reset in link down case
Date: Fri, 23 Nov 2012 06:58:39 -0500
Message-ID: <1353671922-19090-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1353671922-19090-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:35828 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753551Ab2KWMRM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Nov 2012 07:17:12 -0500
In-Reply-To: <1353671922-19090-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Issue:
Reset operation fails if port is in Link Down state

Fix:
Do not wait till HBA comes online after reset command is invoked.

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a9ece28..25e994f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6006,14 +6006,6 @@ static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type)
 		goto exit_host_reset;
 	}
 
-	rval = qla4xxx_wait_for_hba_online(ha);
-	if (rval != QLA_SUCCESS) {
-		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: Unable to reset host "
-				  "adapter\n", __func__));
-		rval = -EIO;
-		goto exit_host_reset;
-	}
-
 	if (test_bit(DPC_RESET_HA, &ha->dpc_flags))
 		goto recover_adapter;
 
-- 
1.7.8.GIT

