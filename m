From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/6] scsi_debug: call map_region() and unmap_region() only when needed
Date: Tue, 16 Apr 2013 22:11:55 +0900
Message-ID: <1366117920-11740-2-git-send-email-akinobu.mita@gmail.com>
References: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59728 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab3DPNM0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 09:12:26 -0400
Received: by mail-pa0-f44.google.com with SMTP id bi5so342247pad.3
        for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2013 06:12:25 -0700 (PDT)
In-Reply-To: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

If the logical block provisioning is not enabled, map_region() and
unmap_region() have no effect and they don't need to be called.

So this makes map_region() and unmap_region() to be called only
when scsi_debug_lbp() returns true, i.e. logical block provisioning is
enabled.

While I'm at it, this also removes meaningless non-zero check for
scsi_debug_unmap_granularity.

Because scsi_debug_unmap_granularity cannot be zero with usual setting:
scsi_debug_unmap_granularity is 1 by default, and it can be changed to
zero with explicit module parameter setting only when the logical block
provisioning is disabled.  But it is only meaningful module parameter
when the logical block provisioning is enabled.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5cda11c..05abf4e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2089,7 +2089,7 @@ static int resp_write(struct scsi_cmnd *SCpnt, unsigned long long lba,
 
 	write_lock_irqsave(&atomic_rw, iflags);
 	ret = do_device_access(SCpnt, devip, lba, num, 1);
-	if (scsi_debug_unmap_granularity)
+	if (scsi_debug_lbp())
 		map_region(lba, num);
 	write_unlock_irqrestore(&atomic_rw, iflags);
 	if (-1 == ret)
@@ -2122,7 +2122,7 @@ static int resp_write_same(struct scsi_cmnd *scmd, unsigned long long lba,
 
 	write_lock_irqsave(&atomic_rw, iflags);
 
-	if (unmap && scsi_debug_unmap_granularity) {
+	if (unmap && scsi_debug_lbp()) {
 		unmap_region(lba, num);
 		goto out;
 	}
@@ -2146,7 +2146,7 @@ static int resp_write_same(struct scsi_cmnd *scmd, unsigned long long lba,
 		       fake_storep + (lba * scsi_debug_sector_size),
 		       scsi_debug_sector_size);
 
-	if (scsi_debug_unmap_granularity)
+	if (scsi_debug_lbp())
 		map_region(lba, num);
 out:
 	write_unlock_irqrestore(&atomic_rw, iflags);
-- 
1.8.1.4

