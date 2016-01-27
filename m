From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/7] scsi: acornscsi: mark calc_sync_xfer as __maybe_unused
Date: Wed, 27 Jan 2016 16:57:19 +0100
Message-ID: <1453910247-3447628-4-git-send-email-arnd@arndb.de>
References: <1453910247-3447628-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453910247-3447628-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James.Bottomley@HansenPartnership.com
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The calc_sync_xfer function is only used if CONFIG_SCSI_ACORNSCSI_SYNC
is set, otherwise we get a compiler warning:

scsi/arm/acornscsi.c:680:15: warning: 'calc_sync_xfer' defined but not used [-Wunused-function]
 unsigned char calc_sync_xfer(unsigned int period, unsigned int offset)

This marks the function as __maybe_unused to shut up the
warning and silently drop the function in the object code
when there is no caller.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/arm/acornscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index deaaf84989cd..12b88294d667 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -677,7 +677,8 @@ int round_period(unsigned int period)
  * Copyright: Copyright (c) 1996 John Shifflett, GeoLog Consulting
  */
 static
-unsigned char calc_sync_xfer(unsigned int period, unsigned int offset)
+unsigned char __maybe_unused calc_sync_xfer(unsigned int period,
+					    unsigned int offset)
 {
     return sync_xfer_table[round_period(period)].reg_value |
 		((offset < SDTR_SIZE) ? offset : SDTR_SIZE);
-- 
2.7.0
