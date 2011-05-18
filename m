From: vikas.chaudhary@qlogic.com
Subject: [PATCH 06/10] qla4xxx: Don't check FW alive if ISP82XX reset is in progress
Date: Tue, 17 May 2011 23:17:08 -0700
Message-ID: <1305699432-13225-7-git-send-email-vikas.chaudhary@qlogic.com>
References: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:50945 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754222Ab1ERGXr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 02:23:47 -0400
In-Reply-To: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Corrected logic to don't check for F/W is alive if reset is already
in progress for ISP82XX

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index b657ece..302938e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -735,7 +735,7 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 	/* don't poll if reset is going on */
 	if (!(test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags) ||
 	    test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
-	    test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags))) {
+	    test_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags))) {
 		if (dev_state == QLA82XX_DEV_NEED_RESET &&
 		    !test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
 			if (!ql4xdontresethba) {
-- 
1.7.3.2

