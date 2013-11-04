From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] scsi: Do not call do_div() with a 64-bit divisor
Date: Mon,  4 Nov 2013 10:21:05 +0100
Message-ID: <1383556865-7031-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

do_div() is meant for divisions of 64-bit number by 32-bit numbers.
Passing 64-bit divisor types caused issues in the past on 32-bit platforms,
cfr. commit ea077b1b96e073eac5c3c5590529e964767fc5f7 ("m68k: Truncate base
in do_div()").

As scsi_device.sector_size is unsigned (int), factor should be unsigned
int, too.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5693f6d7eddb..d6645c70cceb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1607,7 +1607,7 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 		end_lba <<= 1;
 	} else {
 		/* be careful ... don't want any overflows */
-		u64 factor = scmd->device->sector_size / 512;
+		unsigned int factor = scmd->device->sector_size / 512;
 		do_div(start_lba, factor);
 		do_div(end_lba, factor);
 	}
-- 
1.7.9.5
