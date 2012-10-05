From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/16] SCSI: ARM: ncr5380/oak uses no interrupts
Date: Fri,  5 Oct 2012 16:55:17 +0200
Message-ID: <1349448930-23976-4-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.infradead.org
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, arm@kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>
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
