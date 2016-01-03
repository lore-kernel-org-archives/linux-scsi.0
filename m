From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 01/78] atari_scsi: Fix SCSI host ID setting
Date: Sun, 03 Jan 2016 16:05:02 +1100
Message-ID: <20160103050501.301512545@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_scsi-fix-host-id
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The NVRAM location of this byte is 16, as documented in
http://toshyp.atari.org/en/004009.html

This was confirmed by Michael Schmitz, by setting the SCSI host ID
under EmuTOS and then checking the value in /proc/driver/nvram and
/dev/nvram under Linux.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/atari_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2016-01-03 16:02:39.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2016-01-03 16:02:40.000000000 +1100
@@ -880,7 +880,7 @@ static int __init atari_scsi_probe(struc
 	} else {
 		/* Test if a host id is set in the NVRam */
 		if (ATARIHW_PRESENT(TT_CLK) && nvram_check_checksum()) {
-			unsigned char b = nvram_read_byte(14);
+			unsigned char b = nvram_read_byte(16);
 
 			/* Arbitration enabled? (for TOS)
 			 * If yes, use configured host ID
