From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 01/77] atari_scsi: Fix SCSI host ID setting
Date: Tue, 22 Dec 2015 12:17:39 +1100
Message-ID: <20151222011738.355505173@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_scsi-fix-host-id
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

The NVRAM location of this byte is 16, as documented in
http://toshyp.atari.org/en/004009.html

This was confirmed by Michael Schmitz, by setting the SCSI host ID
under EmuTOS and then checking the value in /proc/driver/nvram and
/dev/nvram under Linux.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/atari_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2015-12-22 12:14:49.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2015-12-22 12:15:21.000000000 +1100
@@ -880,7 +880,7 @@ static int __init atari_scsi_probe(struc
 	} else {
 		/* Test if a host id is set in the NVRam */
 		if (ATARIHW_PRESENT(TT_CLK) && nvram_check_checksum()) {
-			unsigned char b = nvram_read_byte(14);
+			unsigned char b = nvram_read_byte(16);
 
 			/* Arbitration enabled? (for TOS)
 			 * If yes, use configured host ID
