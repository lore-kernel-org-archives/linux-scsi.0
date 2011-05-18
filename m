From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] scsi: netlink: avoid including netlink interface in scsi module
Date: Wed, 18 May 2011 23:25:39 +0200
Message-ID: <1305753940-18570-1-git-send-email-jengelh@medozas.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41990 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab1ERVZl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 17:25:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de

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
index 4a1f029..a61014b 100644
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
index 7ad0b8a..a18d5c6 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -162,7 +162,7 @@ scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
 				   scsicam.o scsi_error.o scsi_lib.o
 scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
 scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
-scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
+obj-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 scsi_mod-y			+= scsi_trace.o
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2aeb2e9..f2d27e6 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1327,8 +1327,6 @@ static int __init init_scsi(void)
 	if (error)
 		goto cleanup_sysctl;
 
-	scsi_netlink_init();
-
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
 
@@ -1349,7 +1347,6 @@ cleanup_queue:
 
 static void __exit exit_scsi(void)
 {
-	scsi_netlink_exit();
 	scsi_sysfs_unregister();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
index 26a8a45..62e23b5 100644
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
 		printk(KERN_ERR "%s: register of receive handler failed\n",
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
index 2a588955..b803ae8 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -138,13 +138,8 @@ extern struct bus_type scsi_bus_type;
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
1.7.3.4

