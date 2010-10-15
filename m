From: madhu.iyengar@qlogic.com
Subject: [PATCH 11/12] qla2xxx: Correct PRLI failure response code handling.
Date: Fri, 15 Oct 2010 11:27:48 -0700
Message-ID: <1287167269-8034-12-git-send-email-madhu.iyengar@qlogic.com>
References: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36967 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756485Ab0JOSg3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2010 14:36:29 -0400
In-Reply-To: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

This patch fixes an issue which causes the firmware to fail with a
'PRLI failed' status code (iop1 = 405). This status triggers the
driver to fall into an incorrect code-path which does not attempt
a login retry.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a47a38f..1f06ddd 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1240,12 +1240,6 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 	case LSC_SCODE_NPORT_USED:
 		data[0] = MBS_LOOP_ID_USED;
 		break;
-	case LSC_SCODE_CMD_FAILED:
-		if ((iop[1] & 0xff) == 0x05) {
-			data[0] = MBS_NOT_LOGGED_IN;
-			break;
-		}
-		/* Fall through. */
 	default:
 		data[0] = MBS_COMMAND_ERROR;
 		break;
-- 
1.6.0.2

