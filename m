From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: sun3_scsi: Mark expected switch fall-throughs
Date: Mon, 29 Jul 2019 09:30:07 -0500
Message-ID: <20190729143007.GA8067@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org

Mark switch cases where we are expecting to fall through.

This patch fixes the following warnings:

drivers/scsi/sun3_scsi.c: warning: this statement may fall through
[-Wimplicit-fallthrough=]:  => 399:9, 403:9

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/sun3_scsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 3d80ab67a626..955e4c938d49 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -397,10 +397,12 @@ static int sun3scsi_dma_finish(int write_flag)
 		case CSR_LEFT_3:
 			*vaddr = (dregs->bpack_lo & 0xff00) >> 8;
 			vaddr--;
+			/* Fall through */
 
 		case CSR_LEFT_2:
 			*vaddr = (dregs->bpack_hi & 0x00ff);
 			vaddr--;
+			/* Fall through */
 
 		case CSR_LEFT_1:
 			*vaddr = (dregs->bpack_hi & 0xff00) >> 8;
-- 
2.22.0
