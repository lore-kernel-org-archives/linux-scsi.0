From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH] libfcoe: Replace module state checking with global flag
	checking
Date: Fri, 11 Mar 2011 18:07:37 -0800
Message-ID: <20110312020737.21655.31389.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3029 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab1CLCHh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2011 21:07:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

libfcoe uses module parameters for its create, destroy,
etc... interfaces. The user land application will write
the name of the netdevice to these interface files to
trigger the kernel to take some action.

Module parameter sysfs files are both present and writable
before the module has completed its initialization routine.
This means that the user could call 'create' before
libfcoe's global data structures have been initialized.

The current solution is to check the module's state in
the sysfs store functions and if the module is not
MODULE_STATE_LIVE the sysfs store routine will immediately
exit, thus not doing anything if the module has not
completed initialization. This solution is not sufficient
because it expects THIS_MODULE to have been initialized,
which is not guaranteed.

This patch adds a global (to libfcoe) atomic variable
which is used to track the modules initialization state.
In other words, this patch uses a flag to indicate
whether the module has completed initialization or not.

A few #defines are added to make the calling code more
readable.

This patch was created and tested on scsi-misc + two
patches:

fcoe: Remove mutex_trylock/restart_syscall checks
libfcoe: Remove mutex_trylock/restart_syscall checks

Applying this patch shouldn't be necessary for the
current discussion, but if someone wants to, these
dependent patches were patches 01/10 and 02/10 of my
recent fc_sysfs posting to scsi-misc.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_transport.c |   42 ++++++++----------------------------
 1 files changed, 9 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 7b61d00..70a8717 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -47,6 +47,9 @@ static DEFINE_MUTEX(ft_mutex);
 static LIST_HEAD(fcoe_netdevs);
 static DEFINE_MUTEX(fn_mutex);
 
+atomic_t libfcoe_initialized;
+#define libfcoe_module_usable() atomic_read(&libfcoe_initialized)
+
 unsigned int libfcoe_debug_logging;
 module_param_named(debug_logging, libfcoe_debug_logging, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
@@ -530,15 +533,8 @@ static int fcoe_transport_create(const char *buffer, struct kernel_param *kp)
 	struct fcoe_transport *ft = NULL;
 	enum fip_state fip_mode = (enum fip_state)(long)kp->arg;
 
-#ifdef CONFIG_LIBFCOE_MODULE
-	/*
-	 * Make sure the module has been initialized, and is not about to be
-	 * removed.  Module parameter sysfs files are writable before the
-	 * module_init function is called and after module_exit.
-	 */
-	if (THIS_MODULE->state != MODULE_STATE_LIVE)
+	if (!libfcoe_module_usable())
 		goto out_nodev;
-#endif
 
 	mutex_lock(&ft_mutex);
 
@@ -604,15 +600,8 @@ static int fcoe_transport_destroy(const char *buffer, struct kernel_param *kp)
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
 
-#ifdef CONFIG_LIBFCOE_MODULE
-	/*
-	 * Make sure the module has been initialized, and is not about to be
-	 * removed.  Module parameter sysfs files are writable before the
-	 * module_init function is called and after module_exit.
-	 */
-	if (THIS_MODULE->state != MODULE_STATE_LIVE)
+	if (!libfcoe_module_usable())
 		goto out_nodev;
-#endif
 
 	mutex_lock(&ft_mutex);
 
@@ -658,15 +647,8 @@ static int fcoe_transport_disable(const char *buffer, struct kernel_param *kp)
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
 
-#ifdef CONFIG_LIBFCOE_MODULE
-	/*
-	 * Make sure the module has been initialized, and is not about to be
-	 * removed.  Module parameter sysfs files are writable before the
-	 * module_init function is called and after module_exit.
-	 */
-	if (THIS_MODULE->state != MODULE_STATE_LIVE)
+	if (!libfcoe_module_usable())
 		goto out_nodev;
-#endif
 
 	mutex_lock(&ft_mutex);
 
@@ -706,15 +688,8 @@ static int fcoe_transport_enable(const char *buffer, struct kernel_param *kp)
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
 
-#ifdef CONFIG_LIBFCOE_MODULE
-	/*
-	 * Make sure the module has been initialized, and is not about to be
-	 * removed.  Module parameter sysfs files are writable before the
-	 * module_init function is called and after module_exit.
-	 */
-	if (THIS_MODULE->state != MODULE_STATE_LIVE)
+	if (!libfcoe_module_usable())
 		goto out_nodev;
-#endif
 
 	mutex_lock(&ft_mutex);
 
@@ -741,7 +716,7 @@ out_nodev:
 static int __init libfcoe_init(void)
 {
 	fcoe_transport_init();
-
+	atomic_set(&libfcoe_initialized, 1); /* module usable */
 	return 0;
 }
 module_init(libfcoe_init);
@@ -751,6 +726,7 @@ module_init(libfcoe_init);
  */
 static void __exit libfcoe_exit(void)
 {
+	atomic_set(&libfcoe_initialized, 0); /* module unusable */
 	fcoe_transport_exit();
 }
 module_exit(libfcoe_exit);

