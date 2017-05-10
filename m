From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 06/19] aacraid: Change wait time for fib completion
Date: Wed, 10 May 2017 09:39:40 -0700
Message-ID: <1494434393-17261-7-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
References: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0076.outbound.protection.outlook.com ([104.47.34.76]:3610
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751625AbdEJGYM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 May 2017 02:24:12 -0400
In-Reply-To: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

Change the completion wait time for the fibs in the reset and abort
callback from 2 minutes to 15 seconds.

2 minutes is too long for waiting for completion.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <david.carroll@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/linit.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 9ef98e4..f6a11af 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -684,8 +684,8 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 				  (fib_callback) aac_hba_callback,
 				  (void *) cmd);
 
-		/* Wait up to 2 minutes for completion */
-		for (count = 0; count < 120; ++count) {
+		/* Wait up to 15 secs for completion */
+		for (count = 0; count < 15; ++count) {
 			if (cmd->SCp.sent_command) {
 				ret = SUCCESS;
 				break;
@@ -840,8 +840,8 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 				  (fib_callback) aac_hba_callback,
 				  (void *) cmd);
 
-		/* Wait up to 2 minutes for completion */
-		for (count = 0; count < 120; ++count) {
+		/* Wait up to 15 seconds for completion */
+		for (count = 0; count < 15; ++count) {
 			if (cmd->SCp.sent_command) {
 				ret = SUCCESS;
 				break;
-- 
2.7.4
