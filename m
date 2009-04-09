From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] scsi: a4000 - Correct driver unregistration in case of
 failure
Date: Thu, 9 Apr 2009 21:26:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0904092125540.22008@anakin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

commit 7a192ec334cab9fafe3a8665a65af398b0e24730 ("platform driver: fix
incorrect use of 'platform_bus_type' with 'struct device_driver') turned a
driver_UNregister into platform_driver_REGISTER. Correct this to
platform_driver_UNregister.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a4000t.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
index 61af3d9..e3519fa 100644
--- a/drivers/scsi/a4000t.c
+++ b/drivers/scsi/a4000t.c
@@ -129,7 +129,7 @@ static int __init a4000t_scsi_init(void)
 	a4000t_scsi_device = platform_device_register_simple("a4000t-scsi",
 			-1, NULL, 0);
 	if (IS_ERR(a4000t_scsi_device)) {
-		platform_driver_register(&a4000t_scsi_driver);
+		platform_driver_unregister(&a4000t_scsi_driver);
 		return PTR_ERR(a4000t_scsi_device);
 	}
 
-- 
1.6.2.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
