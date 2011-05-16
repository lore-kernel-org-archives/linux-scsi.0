From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 8/8] libfcoe: Remove unnecessary module state checks
Date: Mon, 16 May 2011 16:46:02 -0700
Message-ID: <20110516234602.24502.34765.stgit@localhost6.localdomain6>
References: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13859 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab1EPXqC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2011 19:46:02 -0400
In-Reply-To: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>

libfcoe's interface consists of create, destroy, enable,
disable and create_vn2vn. These are currently module
paramaters added durring the module initialization. A
concern arose that the module parameters were being added
with write permissions before the module had completed
initialization. The following code was added to each
sysfs store file.

* Make sure the module has been initialized, and is not about to be
* removed.  Module parameter sysfs files are writable before the
* module_init function is called and after module_exit.
*/
if (THIS_MODULE->state != MODULE_STATE_LIVE)
    goto out_nodev;

This check was called out as unhelpful as the module can
go dead at any time and therefore its state isn't a reliable
thing to look at as a sign of stability and initialization
completion. Also, that functional interfaces like these
should be added after module initialization.

This patch removes the unnecessary checks and hopes to
disprove the concern about initialization ordering.

Recent fcoe transport rework changes now require fcoe
transports to register with libfcoe before any operation
can take place. libfcoe may access some static variables
but nothing that could cause a problem. Once a fcoe transport
is registered, libfcoe is usable and any interface calls will
be functional.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 drivers/scsi/fcoe/fcoe_transport.c |   40 ------------------------------------
 1 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index f81f77c..41068e8 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -544,16 +544,6 @@ static int fcoe_transport_create(const char *buffer, struct kernel_param *kp)
 	struct fcoe_transport *ft = NULL;
 	enum fip_state fip_mode = (enum fip_state)(long)kp->arg;
 
-#ifdef CONFIG_LIBFCOE_MODULE
-	/*
-	 * Make sure the module has been initialized, and is not about to be
-	 * removed.  Module parameter sysfs files are writable before the
-	 * module_init function is called and after module_exit.
-	 */
-	if (THIS_MODULE->state != MODULE_STATE_LIVE)
-		goto out_nodev;
-#endif
-
 	mutex_lock(&ft_mutex);
 
 	netdev = fcoe_if_to_netdev(buffer);
@@ -618,16 +608,6 @@ static int fcoe_transport_destroy(const char *buffer, struct kernel_param *kp)
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
 
-#ifdef CONFIG_LIBFCOE_MODULE
-	/*
-	 * Make sure the module has been initialized, and is not about to be
-	 * removed.  Module parameter sysfs files are writable before the
-	 * module_init function is called and after module_exit.
-	 */
-	if (THIS_MODULE->state != MODULE_STATE_LIVE)
-		goto out_nodev;
-#endif
-
 	mutex_lock(&ft_mutex);
 
 	netdev = fcoe_if_to_netdev(buffer);
@@ -672,16 +652,6 @@ static int fcoe_transport_disable(const char *buffer, struct kernel_param *kp)
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
 
-#ifdef CONFIG_LIBFCOE_MODULE
-	/*
-	 * Make sure the module has been initialized, and is not about to be
-	 * removed.  Module parameter sysfs files are writable before the
-	 * module_init function is called and after module_exit.
-	 */
-	if (THIS_MODULE->state != MODULE_STATE_LIVE)
-		goto out_nodev;
-#endif
-
 	mutex_lock(&ft_mutex);
 
 	netdev = fcoe_if_to_netdev(buffer);
@@ -720,16 +690,6 @@ static int fcoe_transport_enable(const char *buffer, struct kernel_param *kp)
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
 
-#ifdef CONFIG_LIBFCOE_MODULE
-	/*
-	 * Make sure the module has been initialized, and is not about to be
-	 * removed.  Module parameter sysfs files are writable before the
-	 * module_init function is called and after module_exit.
-	 */
-	if (THIS_MODULE->state != MODULE_STATE_LIVE)
-		goto out_nodev;
-#endif
-
 	mutex_lock(&ft_mutex);
 
 	netdev = fcoe_if_to_netdev(buffer);

