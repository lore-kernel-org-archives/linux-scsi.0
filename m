From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 6/8] scsi/sun3: Check for NCR_TIMEOUT being defined instead of having a value
Date: Mon, 13 Jun 2011 20:39:20 +0200
Message-ID: <1307990362-22768-7-git-send-email-geert@linux-m68k.org>
References: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

This fixes:

drivers/scsi/sun3_NCR5380.c:1448:5: warning: "NCR_TIMEOUT" is not defined

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>
---
 drivers/scsi/sun3_NCR5380.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 2ba1cb7..f3cffdf 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -1445,7 +1445,7 @@ static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd,
     local_irq_restore(flags);
 
     /* Wait for arbitration logic to complete */
-#if NCR_TIMEOUT
+#ifdef NCR_TIMEOUT
     {
       unsigned long timeout = jiffies + 2*NCR_TIMEOUT;
 
-- 
1.7.0.4
