From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] cciss: use designated initializers
Date: Fri, 16 Dec 2016 17:05:30 -0800
Message-ID: <20161217010530.GA140708@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:35571 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935967AbcLQBFc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2016 20:05:32 -0500
Received: by mail-pf0-f176.google.com with SMTP id i88so16311055pfk.2
        for <linux-scsi@vger.kernel.org>; Fri, 16 Dec 2016 17:05:32 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Don Brace <don.brace@microsemi.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org

Prepare to mark sensitive kernel structures for randomization by making
sure they're using designated initializers. These were identified during
allyesconfig builds of x86, arm, and arm64, with most initializer fixes
extracted from grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/block/cciss.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 7fda30e4a241..428766d1ce80 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -402,27 +402,27 @@ static bool SA5_performant_intr_pending(ctlr_info_t *h)
 }
 
 static struct access_method SA5_access = {
-	SA5_submit_command,
-	SA5_intr_mask,
-	SA5_fifo_full,
-	SA5_intr_pending,
-	SA5_completed,
+	.submit_command = SA5_submit_command,
+	.set_intr_mask = SA5_intr_mask,
+	.fifo_full = SA5_fifo_full,
+	.intr_pending = SA5_intr_pending,
+	.command_completed = SA5_completed,
 };
 
 static struct access_method SA5B_access = {
-        SA5_submit_command,
-        SA5B_intr_mask,
-        SA5_fifo_full,
-        SA5B_intr_pending,
-        SA5_completed,
+	.submit_command = SA5_submit_command,
+	.set_intr_mask = SA5B_intr_mask,
+	.fifo_full = SA5_fifo_full,
+	.intr_pending = SA5B_intr_pending,
+	.command_completed = SA5_completed,
 };
 
 static struct access_method SA5_performant_access = {
-	SA5_submit_command,
-	SA5_performant_intr_mask,
-	SA5_fifo_full,
-	SA5_performant_intr_pending,
-	SA5_performant_completed,
+	.submit_command = SA5_submit_command,
+	.set_intr_mask = SA5_performant_intr_mask,
+	.fifo_full = SA5_fifo_full,
+	.intr_pending = SA5_performant_intr_pending,
+	.command_completed = SA5_performant_completed,
 };
 
 struct board_type {
-- 
2.7.4


-- 
Kees Cook
Nexus Security
