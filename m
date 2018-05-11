From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 7/7] cxlflash: Isolate external module dependencies
Date: Fri, 11 May 2018 14:06:19 -0500
Message-ID: <1526065579-39079-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1526065440-38806-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1526065440-38806-1-git-send-email-ukrishn@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Depending on the underlying transport, cxlflash has a dependency on either
the CXL or OCXL drivers, which are enabled via their Kconfig option.
Instead of having a module wide dependency on these config options, it is
better to isolate the object modules that are dependent on the CXL and OCXL
drivers and adjust the module dependencies accordingly.

This commit isolates the object files that are dependent on CXL and/or
OCXL. The cxl/ocxl fops used in the core driver are tucked under an ifdef
to avoid compilation errors.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/Kconfig     | 2 +-
 drivers/scsi/cxlflash/Makefile    | 4 +++-
 drivers/scsi/cxlflash/lunmgt.c    | 4 +++-
 drivers/scsi/cxlflash/main.c      | 2 --
 drivers/scsi/cxlflash/main.h      | 5 +++++
 drivers/scsi/cxlflash/superpipe.c | 3 ++-
 drivers/scsi/cxlflash/vlun.c      | 3 ++-
 7 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/cxlflash/Kconfig b/drivers/scsi/cxlflash/Kconfig
index e2a3a1b..f1b17e3 100644
--- a/drivers/scsi/cxlflash/Kconfig
+++ b/drivers/scsi/cxlflash/Kconfig
@@ -4,7 +4,7 @@
 
 config CXLFLASH
 	tristate "Support for IBM CAPI Flash"
-	depends on PCI && SCSI && CXL && OCXL && EEH
+	depends on PCI && SCSI && (CXL || OCXL) && EEH
 	select IRQ_POLL
 	default m
 	help
diff --git a/drivers/scsi/cxlflash/Makefile b/drivers/scsi/cxlflash/Makefile
index 5124c68..283377d 100644
--- a/drivers/scsi/cxlflash/Makefile
+++ b/drivers/scsi/cxlflash/Makefile
@@ -1,2 +1,4 @@
 obj-$(CONFIG_CXLFLASH) += cxlflash.o
-cxlflash-y += main.o superpipe.o lunmgt.o vlun.o cxl_hw.o ocxl_hw.o
+cxlflash-y += main.o superpipe.o lunmgt.o vlun.o
+cxlflash-$(CONFIG_CXL) += cxl_hw.o
+cxlflash-$(CONFIG_OCXL) += ocxl_hw.o
diff --git a/drivers/scsi/cxlflash/lunmgt.c b/drivers/scsi/cxlflash/lunmgt.c
index 4d232e2..edea125 100644
--- a/drivers/scsi/cxlflash/lunmgt.c
+++ b/drivers/scsi/cxlflash/lunmgt.c
@@ -12,9 +12,11 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <misc/cxl.h>
 #include <asm/unaligned.h>
 
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+
 #include <scsi/scsi_host.h>
 #include <uapi/scsi/cxlflash_ioctl.h>
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index cd7dcc5..6637116 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -19,8 +19,6 @@
 
 #include <asm/unaligned.h>
 
-#include <misc/cxl.h>
-
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 #include <uapi/scsi/cxlflash_ioctl.h>
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
index ed4908e..2a39778 100644
--- a/drivers/scsi/cxlflash/main.h
+++ b/drivers/scsi/cxlflash/main.h
@@ -107,10 +107,15 @@ cxlflash_assign_ops(struct dev_dependent_vals *ddv)
 {
 	const struct cxlflash_backend_ops *ops = NULL;
 
+#ifdef CONFIG_OCXL
 	if (ddv->flags & CXLFLASH_OCXL_DEV)
 		ops = &cxlflash_ocxl_ops;
+#endif
+
+#ifdef CONFIG_CXL
 	if (!(ddv->flags & CXLFLASH_OCXL_DEV))
 		ops = &cxlflash_cxl_ops;
+#endif
 
 	return ops;
 }
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 5ba6e62..e489d89 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -14,8 +14,9 @@
 
 #include <linux/delay.h>
 #include <linux/file.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
 #include <linux/syscalls.h>
-#include <misc/cxl.h>
 #include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 5deef57..66e445a 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -12,8 +12,9 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/interrupt.h>
+#include <linux/pci.h>
 #include <linux/syscalls.h>
-#include <misc/cxl.h>
 #include <asm/unaligned.h>
 #include <asm/bitsperlong.h>
 
-- 
2.1.0
