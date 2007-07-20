From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 3/3] scsi: wd33c93 needs <asm/irq.h>
Date: Fri, 20 Jul 2007 18:40:46 +0200
Message-ID: <20070720164324.097994947@mail.of.borg>
References: <20070720164043.523003359@mail.of.borg>
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline; filename=m68k-wd33c93-needs-asm-irq.diff
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-mips@linux-mips.org
List-Id: linux-scsi@vger.kernel.org

wd33c93 SCSI needs <asm/irq.h> on m68k

drivers/scsi/wd33c93.c: In function 'wd33c93_host_reset':
drivers/scsi/wd33c93.c:1582: error: implicit declaration of function 'disable_irq'
drivers/scsi/wd33c93.c:1603: error: implicit declaration of function 'enable_irq'

The driver still compiles on MIPS (CONFIG_SGIWD93_SCSI=y)

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/wd33c93.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -89,6 +89,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
+#include <asm/irq.h>
+
 #include "wd33c93.h"
 
 #define optimum_sx_per(hostdata) (hostdata)->sx_table[1].period_ns

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
