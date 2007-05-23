From: akpm@linux-foundation.org
Subject: [patch 09/25] SCSI: Fix obvious typo "spin_lock_irqrestore()" in gdth.c
Date: Wed, 23 May 2007 14:41:40 -0700
Message-ID: <200705232141.l4NLff7b001185@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758228AbXEWVvs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 17:51:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, rpjday@mindspring.com, achim_leubner@adaptec.com

From: "Robert P. J. Day" <rpjday@mindspring.com>

Fix misspelled "spin_lock_irqrestore" to read "spin_unlock_irqrestore"
instead.

Presumably, GDTH_RTC doesn't get used a lot.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: <achim_leubner@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/gdth.c~scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc
+++ a/drivers/scsi/gdth.c
@@ -1955,7 +1955,7 @@ static int __init gdth_search_drives(int
         for (j = 0; j < 12; ++j) 
             rtc[j] = CMOS_READ(j);
     } while (rtc[0] != CMOS_READ(0));
-    spin_lock_irqrestore(&rtc_lock, flags);
+    spin_unlock_irqrestore(&rtc_lock, flags);
     TRACE2(("gdth_search_drives(): RTC: %x/%x/%x\n",*(ulong32 *)&rtc[0],
             *(ulong32 *)&rtc[4], *(ulong32 *)&rtc[8]));
     /* 3. send to controller firmware */
_
