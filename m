From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch] scsi: netlink: avoid including netlink interface in scsi
 module
Date: Mon, 1 Nov 2010 21:08:29 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011012104060.7293@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1010311949300.17994@obet.zrqbmnf.qr> <4CCE31D4.3050008@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46661 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab0KAUIa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Nov 2010 16:08:30 -0400
In-Reply-To: <4CCE31D4.3050008@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>


On Monday 2010-11-01 04:19, Randy Dunlap wrote:
>On 10/31/10 11:50, Jan Engelhardt wrote:
>> scsi: netlink: avoid including netlink interface in scsi module
>
>Mostly looks good to me, just one warning:
>drivers/scsi/scsi_netlink.c:678: warning: initialization from incompatible pointer type
>The init() function should return an int (status/error code).

Ah indeed, thank you. I must have missed that somehow. Maybe I should get a
slower CPU so that I actually have time to read messages (make -j8 kinda rushes
just through, despite kbuild-2.6's efforts to reduce 2.4-ish verbosity :)


Updated: As this is now a separate module, I took the courtesy to
err out completely if scsi_nl_add_transport fails.


parent 3985c7ce85039adacdf882904ca096f091d39346 (v2.6.36-9871-g3985c7c)
commit 78d7ac1cd86667ad5735fd3899b7cea55ec50aed
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Oct 30 19:51:53 2010 +0200

scsi: netlink: avoid including netlink interface in scsi module

Only scsi_transport_fc needs it, so don't include it in scsi_mod
if fc=m.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 drivers/scsi/Kconfig        |    3 ++-
 drivers/scsi/Makefile       |    2 +-
 drivers/scsi/scsi.c         |    3 ---
 drivers/scsi/scsi_netlink.c |   22 +++++++++++++---------
 drivers/scsi/scsi_priv.h    |    7 +------
 5 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 8616496..b4e1e2d 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -48,8 +48,9 @@ config SCSI_TGT
 	  If you choose M, the module will be called scsi_tgt.
 
 config SCSI_NETLINK
-	bool
+	tristate "SCSI Netlink interface"
 	default	n
+	depends on SCSI
 	select NET
 
 config SCSI_PROC_FS
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 2e9a87e..0870038 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -161,7 +161,7 @@ scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
 				   scsicam.o scsi_error.o scsi_lib.o
 scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
 scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
-scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
+obj-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 scsi_mod-y			+= scsi_trace.o
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 348fba0..31a07b1 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1335,8 +1335,6 @@ static int __init init_scsi(void)
 	if (error)
 		goto cleanup_sysctl;
 
-	scsi_netlink_init();
-
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
 
@@ -1357,7 +1355,6 @@ cleanup_queue:
 
 static void __exit exit_scsi(void)
 {
-	scsi_netlink_exit();
 	scsi_sysfs_unregister();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
index d53e650..c01cf67 100644
--- a/drivers/scsi/scsi_netlink.c
+++ b/drivers/scsi/scsi_netlink.c
@@ -18,6 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
  */
+#include <linux/module.h>
 #include <linux/time.h>
 #include <linux/jiffies.h>
 #include <linux/security.h>
@@ -481,8 +482,7 @@ EXPORT_SYMBOL_GPL(scsi_nl_remove_driver);
  * 	the SCSI transport netlink interface
  *
  **/
-void
-scsi_netlink_init(void)
+static int __init scsi_netlink_init(void)
 {
 	int error;
 
@@ -492,7 +492,7 @@ scsi_netlink_init(void)
 	if (error) {
 		printk(KERN_ERR "%s: register of event handler failed - %d\n",
 				__func__, error);
-		return;
+		return error;
 	}
 
 	scsi_nl_sock = netlink_kernel_create(&init_net, NETLINK_SCSITRANSPORT,
@@ -502,16 +502,19 @@ scsi_netlink_init(void)
 		printk(KERN_ERR "%s: register of recieve handler failed\n",
 				__func__);
 		netlink_unregister_notifier(&scsi_netlink_notifier);
-		return;
+		return -ENOMEM;
 	}
 
 	/* Register the entry points for the generic SCSI transport */
 	error = scsi_nl_add_transport(SCSI_NL_TRANSPORT,
 				scsi_generic_msg_handler, NULL);
-	if (error)
+	if (error) {
 		printk(KERN_ERR "%s: register of GENERIC transport handler"
 				"  failed - %d\n", __func__, error);
-	return;
+		netlink_kernel_release(scsi_nl_sock);
+		netlink_unregister_notifier(&scsi_netlink_notifier);
+	}
+	return error;
 }
 
 
@@ -519,8 +522,7 @@ scsi_netlink_init(void)
  * scsi_netlink_exit - Called by SCSI subsystem to disable the SCSI transport netlink interface
  *
  **/
-void
-scsi_netlink_exit(void)
+static void __exit scsi_netlink_exit(void)
 {
 	scsi_nl_remove_transport(SCSI_NL_TRANSPORT);
 
@@ -676,4 +678,6 @@ send_vendor_fail:
 }
 EXPORT_SYMBOL(scsi_nl_send_vendor_msg);
 
-
+module_init(scsi_netlink_init);
+module_exit(scsi_netlink_exit);
+MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index b4056d1..55fba9e 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -136,13 +136,8 @@ extern struct bus_type scsi_bus_type;
 extern const struct attribute_group *scsi_sysfs_shost_attr_groups[];
 
 /* scsi_netlink.c */
-#ifdef CONFIG_SCSI_NETLINK
-extern void scsi_netlink_init(void);
-extern void scsi_netlink_exit(void);
+#if defined(CONFIG_SCSI_NETLINK) || defined(CONFIG_SCSI_NETLINK_MODULE)
 extern struct sock *scsi_nl_sock;
-#else
-static inline void scsi_netlink_init(void) {}
-static inline void scsi_netlink_exit(void) {}
 #endif
 
 /* scsi_pm.c */
-- 
# Created with git-export-patch
