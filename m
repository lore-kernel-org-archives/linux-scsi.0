From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] hpsa: use designated initializers
Date: Fri, 16 Dec 2016 17:04:49 -0800
Message-ID: <20161217010449.GA140636@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:35382 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935117AbcLQBEv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2016 20:04:51 -0500
Received: by mail-pg0-f47.google.com with SMTP id p66so37726746pga.2
        for <linux-scsi@vger.kernel.org>; Fri, 16 Dec 2016 17:04:51 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org

Prepare to mark sensitive kernel structures for randomization by making
sure they're using designated initializers. These were identified during
allyesconfig builds of x86, arm, and arm64, with most initializer fixes
extracted from grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/hpsa.h | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 64e98295b707..bf6cdc106654 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -578,38 +578,38 @@ static unsigned long SA5_ioaccel_mode1_completed(struct ctlr_info *h, u8 q)
 }
 
 static struct access_method SA5_access = {
-	SA5_submit_command,
-	SA5_intr_mask,
-	SA5_intr_pending,
-	SA5_completed,
+	.submit_command = SA5_submit_command,
+	.set_intr_mask = SA5_intr_mask,
+	.intr_pending = SA5_intr_pending,
+	.command_completed = SA5_completed,
 };
 
 static struct access_method SA5_ioaccel_mode1_access = {
-	SA5_submit_command,
-	SA5_performant_intr_mask,
-	SA5_ioaccel_mode1_intr_pending,
-	SA5_ioaccel_mode1_completed,
+	.submit_command = SA5_submit_command,
+	.set_intr_mask = SA5_performant_intr_mask,
+	.intr_pending = SA5_ioaccel_mode1_intr_pending,
+	.command_completed = SA5_ioaccel_mode1_completed,
 };
 
 static struct access_method SA5_ioaccel_mode2_access = {
-	SA5_submit_command_ioaccel2,
-	SA5_performant_intr_mask,
-	SA5_performant_intr_pending,
-	SA5_performant_completed,
+	.submit_command = SA5_submit_command_ioaccel2,
+	.set_intr_mask = SA5_performant_intr_mask,
+	.intr_pending = SA5_performant_intr_pending,
+	.command_completed = SA5_performant_completed,
 };
 
 static struct access_method SA5_performant_access = {
-	SA5_submit_command,
-	SA5_performant_intr_mask,
-	SA5_performant_intr_pending,
-	SA5_performant_completed,
+	.submit_command = SA5_submit_command,
+	.set_intr_mask = SA5_performant_intr_mask,
+	.intr_pending = SA5_performant_intr_pending,
+	.command_completed = SA5_performant_completed,
 };
 
 static struct access_method SA5_performant_access_no_read = {
-	SA5_submit_command_no_read,
-	SA5_performant_intr_mask,
-	SA5_performant_intr_pending,
-	SA5_performant_completed,
+	.submit_command = SA5_submit_command_no_read,
+	.set_intr_mask = SA5_performant_intr_mask,
+	.intr_pending = SA5_performant_intr_pending,
+	.command_completed = SA5_performant_completed,
 };
 
 struct board_type {
-- 
2.7.4


-- 
Kees Cook
Nexus Security
