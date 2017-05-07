From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 06/19] aacraid: Change wait time for fib completion
Date: Sun, 7 May 2017 06:34:11 -0700
Message-ID: <1494164064-17715-7-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
References: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0080.outbound.protection.outlook.com ([104.47.40.80]:51200
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752166AbdEGVpU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 May 2017 17:45:20 -0400
In-Reply-To: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

Change the completion wait time for the fibs in the reset and abort
callback from 2 minutes to 15 seconds.

2 minutes is too long for waiting for completion.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
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
