From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 06/19] aacraid: Change wait time for fib completion
Date: Sun, 7 May 2017 04:26:51 -0700
Message-ID: <20170507112704.21940-7-RaghavaAditya.Renukunta@microsemi.com>
References: <20170507112704.21940-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0069.outbound.protection.outlook.com ([104.47.38.69]:19672
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754429AbdEGVkR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 May 2017 17:40:17 -0400
In-Reply-To: <20170507112704.21940-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

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
