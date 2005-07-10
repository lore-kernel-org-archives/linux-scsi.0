From: Olaf Hering <olh@suse.de>
Subject: [PATCH 22/82] remove linux/version.h from drivers/message/fusion
Date: Sun, 10 Jul 2005 19:35:30 +0000
Message-ID: <20050710193530.22.KSLVIt2863.2247.olh@nectarine.suse.de>
References: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262080AbVGJTka@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>  
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: Eric Moore <Eric.Moore@lsil.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


changing CONFIG_LOCALVERSION rebuilds too much, for no appearent reason.

remove also drivers/message/fusion/linux_compat.h,
because it is empty after the change

Signed-off-by: Olaf Hering <olh@suse.de>

drivers/message/fusion/linux_compat.h |   18 ------------------
drivers/message/fusion/mptbase.c      |    1 -
drivers/message/fusion/mptbase.h      |    1 -
drivers/message/fusion/mptctl.c       |    1 -
drivers/message/fusion/mptctl.h       |    1 -
drivers/message/fusion/mptfc.c        |    1 -
drivers/message/fusion/mptlan.h       |    1 -
drivers/message/fusion/mptscsih.c     |    1 -
drivers/message/fusion/mptspi.c       |    1 -
9 files changed, 26 deletions(-)

Index: linux-2.6.13-rc2-mm1/drivers/message/fusion/linux_compat.h
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/message/fusion/linux_compat.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/* drivers/message/fusion/linux_compat.h */
-
-#ifndef FUSION_LINUX_COMPAT_H
-#define FUSION_LINUX_COMPAT_H
-
-#include <linux/version.h>
-#include <scsi/scsi_device.h>
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,6))
-static int inline scsi_device_online(struct scsi_device *sdev)
-{
-	return sdev->online;
-}
-#endif
-
-
-/*}-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-#endif /* _LINUX_COMPAT_H */
Index: linux-2.6.13-rc2-mm1/drivers/message/fusion/mptbase.c
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/message/fusion/mptbase.c
+++ linux-2.6.13-rc2-mm1/drivers/message/fusion/mptbase.c
@@ -47,7 +47,6 @@
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/

#include <linux/config.h>
-#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/errno.h>
Index: linux-2.6.13-rc2-mm1/drivers/message/fusion/mptbase.h
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/message/fusion/mptbase.h
+++ linux-2.6.13-rc2-mm1/drivers/message/fusion/mptbase.h
@@ -49,7 +49,6 @@
#define MPTBASE_H_INCLUDED
/*{-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/

-#include <linux/version.h>
#include <linux/config.h>
#include <linux/kernel.h>
#include <linux/pci.h>
Index: linux-2.6.13-rc2-mm1/drivers/message/fusion/mptctl.c
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/message/fusion/mptctl.c
+++ linux-2.6.13-rc2-mm1/drivers/message/fusion/mptctl.c
@@ -45,7 +45,6 @@
*/
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/

-#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/errno.h>
Index: linux-2.6.13-rc2-mm1/drivers/message/fusion/mptctl.h
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/message/fusion/mptctl.h
+++ linux-2.6.13-rc2-mm1/drivers/message/fusion/mptctl.h
@@ -49,7 +49,6 @@
#define MPTCTL_H_INCLUDED
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/

-#include "linux/version.h"


/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
Index: linux-2.6.13-rc2-mm1/drivers/message/fusion/mptlan.h
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/message/fusion/mptlan.h
+++ linux-2.6.13-rc2-mm1/drivers/message/fusion/mptlan.h
@@ -66,7 +66,6 @@
#include <linux/slab.h>
#include <linux/miscdevice.h>
#include <linux/spinlock.h>
-#include <linux/version.h>
#include <linux/workqueue.h>
#include <linux/delay.h>
// #include <linux/trdevice.h>
Index: linux-2.6.13-rc2-mm1/drivers/message/fusion/mptfc.c
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/message/fusion/mptfc.c
+++ linux-2.6.13-rc2-mm1/drivers/message/fusion/mptfc.c
@@ -43,7 +43,6 @@
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-#include "linux_compat.h"	/* linux-2.6 tweaks */
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
Index: linux-2.6.13-rc2-mm1/drivers/message/fusion/mptscsih.c
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/message/fusion/mptscsih.c
+++ linux-2.6.13-rc2-mm1/drivers/message/fusion/mptscsih.c
@@ -44,7 +44,6 @@
*/
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/

-#include "linux_compat.h"	/* linux-2.6 tweaks */
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
Index: linux-2.6.13-rc2-mm1/drivers/message/fusion/mptspi.c
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/message/fusion/mptspi.c
+++ linux-2.6.13-rc2-mm1/drivers/message/fusion/mptspi.c
@@ -44,7 +44,6 @@
*/
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/

-#include "linux_compat.h"	/* linux-2.6 tweaks */
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
