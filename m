From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/6] scsi_debug: prohibit scsi_debug_unmap_granularity == scsi_debug_unmap_alignment
Date: Tue, 16 Apr 2013 22:11:56 +0900
Message-ID: <1366117920-11740-3-git-send-email-akinobu.mita@gmail.com>
References: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47835 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab3DPNM2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 09:12:28 -0400
Received: by mail-pa0-f41.google.com with SMTP id kx1so342166pab.28
        for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2013 06:12:27 -0700 (PDT)
In-Reply-To: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

scsi_debug prohibits setting scsi_debug_unmap_alignment to be greater
than scsi_debug_unmap_granularity.  But setting them to be the same value
is not prohibited.  In this case, the only difference with
scsi_debug_unmap_alignment == 0 is the logical blocks from 0 to
scsi_debug_unmap_alignment - 1 cannot be unmapped.  But the difference is
not properly handled in the current code.

So this prohibits such unusual setting.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 05abf4e..5c32140 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3413,9 +3413,10 @@ static int __init scsi_debug_init(void)
 			clamp(scsi_debug_unmap_granularity, 1U, 0xffffffffU);
 
 		if (scsi_debug_unmap_alignment &&
-		    scsi_debug_unmap_granularity < scsi_debug_unmap_alignment) {
+		    scsi_debug_unmap_granularity <=
+		    scsi_debug_unmap_alignment) {
 			printk(KERN_ERR
-			       "%s: ERR: unmap_granularity < unmap_alignment\n",
+			       "%s: ERR: unmap_granularity <= unmap_alignment\n",
 			       __func__);
 			return -EINVAL;
 		}
-- 
1.8.1.4

