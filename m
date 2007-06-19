From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [patch 0/5] m68k 53c700 SCSI
Date: Tue, 19 Jun 2007 09:47:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706190942180.3234@anakin>
References: <20070617124704.800461751@mail.of.borg>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ananke.telenet-ops.be ([195.130.137.78]:55983 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXFSHrc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 03:47:32 -0400
In-Reply-To: <20070617124704.800461751@mail.of.borg>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, Kars de Jong <jongk@linux-m68k.org>, Richard Hirst <rhirst@levanta.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org

	Hi James,

On Sun, 17 Jun 2007, Geert Uytterhoeven wrote:
> These patches add support for m68k to the 53c700 SCSI core and introduce new
> drivers for various m68k hardware using this 53c700 SCSI core, to replace the
> just removed drivers using the old 53c7xx SCSI core.
> 
>   [1] [PATCH] 53c700 scsi: m68k support for the 53c700 SCSI core
>   [2] [PATCH] 53c700 scsi: m68k BVME6000 NCR53C710 SCSI
>   [3] [PATCH] 53c700 scsi: m68k MVME16x NCR53C710 SCSI
>   [4] [PATCH] 53c700 scsi: Amiga 4000T NCR53c710 SCSI
>   [5] [PATCH] 53c700 scsi: Amiga Zorro NCR53c710 SCSI
> 
> Please apply for 2.6.23. Thx!

Apparently I made some major mistakes when preparing these patches.
Here are the fixes.
---

Fixup m68k 53c700 drivers:
  - a4000t.c: Add missing include, needed in some configurations
  - bvme6000_scsi.c: Kill bogus opening brace
  - zorro7xx.c: Remove MODULE_DEVICE_TABLE, it should be part of another
                patch

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a4000t.c        |    1 +
 drivers/scsi/bvme6000_scsi.c |    2 +-
 drivers/scsi/zorro7xx.c      |    1 -
 3 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/a4000t.c
+++ b/drivers/scsi/a4000t.c
@@ -12,6 +12,7 @@
 #include <linux/platform_device.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <asm/amigahw.h>
 #include <asm/amigaints.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_spi.h>
--- a/drivers/scsi/bvme6000_scsi.c
+++ b/drivers/scsi/bvme6000_scsi.c
@@ -112,7 +112,7 @@ static int __init bvme6000_scsi_init(voi
 	int err;
 
 	err = driver_register(&bvme6000_scsi_driver);
-	if (err) {
+	if (err)
 		return err;
 
 	bvme6000_scsi_device = platform_device_register_simple("bvme6000-scsi",
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -65,7 +65,6 @@ static struct zorro_device_id zorro7xx_z
 	},
 	{ 0 }
 };
-MODULE_DEVICE_TABLE(zorro, zorro7xx_zorro_tbl);
 
 static int __devinit zorro7xx_init_one(struct zorro_dev *z,
 				       const struct zorro_device_id *ent)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
