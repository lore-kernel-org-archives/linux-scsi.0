From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 1/8] SCSI: ARM: ncr5380/oak uses no interrupts
Date: Tue,  9 Oct 2012 22:13:51 +0200
Message-ID: <1349813638-4617-2-git-send-email-arnd@arndb.de>
References: <1349813638-4617-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349813638-4617-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Russell King <rmk+kernel@arm.linux.org.uk>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The ncr5380 driver is included by multiple board specific
drivers, which may or may not use the interrupt handler.
The oak variant doesn't, and should set the DONT_USE_INTR
macro.

Without this patch, building rpc_defconfig results in:

drivers/scsi/arm/../NCR5380.c:1160:20: warning: 'oakscsi_intr' defined but not used [-Wunused-function]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/arm/oak.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index d25f944..fc6a5aa 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -21,6 +21,7 @@
 /*#define PSEUDO_DMA*/
 
 #define OAKSCSI_PUBLIC_RELEASE 1
+#define DONT_USE_INTR
 
 #define priv(host)			((struct NCR5380_hostdata *)(host)->hostdata)
 #define NCR5380_local_declare()		void __iomem *_base
-- 
1.7.10
