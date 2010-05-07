From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/10] fcoe: fix a circular locking issue with rtnl and sysfs
	mutex
Date: Fri, 07 May 2010 15:18:46 -0700
Message-ID: <20100507221846.14971.26889.stgit@localhost.localdomain>
References: <20100507221804.14971.11739.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:20509 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0EGWSs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2010 18:18:48 -0400
In-Reply-To: <20100507221804.14971.11739.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Currently rtnl mutex is grabbed during fcoe create, destroy, enable
and disable operations while sysfs s_active read mutex is already
held, but simultaneously other networking events could try grabbing
write s_active mutex while rtnl is already held and that is causing
circular lock warning, its detailed log pasted at end.

In this log, the rtnl was held before write s_active during device
renaming but there are more such cases as Joe reported another
instance with tg3 open at:-
http://www.open-fcoe.org/pipermail/devel/2010-February/008263.html

This patch fixes this issue by not waiting for rtnl mutex during
fcoe ops, that means if rtnl mutex is not immediately available
then restart_syscall() to allow others waiting in line to
grab s_active along with rtnl mutex to finish their work first
under these mutex.

Currently rtnl mutex was grabbed twice during fcoe_destroy call flow,
second grab was from fcoe_if_destroy called from fcoe_destroy after
dropping rtnl mutex before calling fcoe_if_destroy, so instead made
fcoe_if_destroy always called with rtnl mutex held to have this mutex
grabbed only once in this code path.

However left matching rtnl_unlock as-is in its original place as it was
dropped there for good reason since very next call causes synchronous
fip worker flush and if rtnl mutex is still held before flush
then that would cause new circular warning between fip->recv_work and
rtnl mutex, I've added detailed comment for this on fcoe_if_destroy
calling and rtnl muxtes unlocking.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.33.1linux-stable-2.6.33 #1
-------------------------------------------------------
fcoemon/18823 is trying to acquire lock:
(fcoe_config_mutex){+.+.+.}, at: [<ffffffffa02ba5fc>] fcoe_create+0x27/0x4f7
[fcoe]

but task is already holding lock:
(s_active){++++.+}, at: [<ffffffff8115ef93>] sysfs_get_active_two+0x31/0x48

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (s_active){++++.+}:
   [<ffffffff81077bdb>] __lock_acquire+0xb73/0xd2b
   [<ffffffff81077e60>] lock_acquire+0xcd/0xf1
   [<ffffffff8115e5df>] sysfs_deactivate+0x8b/0xe0
   [<ffffffff8115edfb>] sysfs_addrm_finish+0x36/0x55
   [<ffffffff8115d0cc>] sysfs_hash_and_remove+0x53/0x6a
   [<ffffffff8115f353>] sysfs_remove_link+0x21/0x23
   [<ffffffff812b6c93>] device_rename+0x99/0xcb
   [<ffffffff8138dbf0>] dev_change_name+0xd5/0x1d2
   [<ffffffff8138deee>] dev_ifsioc+0x201/0x2ac
   [<ffffffff8138e4ba>] dev_ioctl+0x521/0x632
   [<ffffffff81379e43>] sock_do_ioctl+0x3d/0x47
   [<ffffffff8137a254>] sock_ioctl+0x213/0x222
   [<ffffffff81114614>] vfs_ioctl+0x32/0xa6
   [<ffffffff81114b94>] do_vfs_ioctl+0x490/0x4d6
   [<ffffffff81114c30>] sys_ioctl+0x56/0x79
   [<ffffffff81009b42>] system_call_fastpath+0x16/0x1b

-> #1 (rtnl_mutex){+.+.+.}:
   [<ffffffff81077bdb>] __lock_acquire+0xb73/0xd2b
   [<ffffffff81077e60>] lock_acquire+0xcd/0xf1
   [<ffffffff8142f343>] __mutex_lock_common+0x4b/0x383
   [<ffffffff8142f73f>] mutex_lock_nested+0x3e/0x43
   [<ffffffff813959f9>] rtnl_lock+0x17/0x19
   [<ffffffff8138ccae>] register_netdevice_notifier+0x1e/0x19b
   [<ffffffffa02580c1>] 0xffffffffa02580c1
   [<ffffffff81002069>] do_one_initcall+0x5e/0x15e
   [<ffffffff81084094>] sys_init_module+0xd8/0x23a
   [<ffffffff81009b42>] system_call_fastpath+0x16/0x1b

-> #0 (fcoe_config_mutex){+.+.+.}:
   [<ffffffff81077a85>] __lock_acquire+0xa1d/0xd2b
   [<ffffffff81077e60>] lock_acquire+0xcd/0xf1
   [<ffffffff8142f343>] __mutex_lock_common+0x4b/0x383
   [<ffffffff8142f73f>] mutex_lock_nested+0x3e/0x43
   [<ffffffffa02ba5fc>] fcoe_create+0x27/0x4f7 [fcoe]
   [<ffffffff810635b1>] param_attr_store+0x27/0x35
   [<ffffffff81063619>] module_attr_store+0x26/0x2a
   [<ffffffff8115dae3>] sysfs_write_file+0x108/0x144
   [<ffffffff81107bd1>] vfs_write+0xae/0x10b
   [<ffffffff81107cee>] sys_write+0x4a/0x6e
   [<ffffffff81009b42>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

3 locks held by fcoemon/18823:
#0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8115da17>]
sysfs_write_file+0x3c/0x144
#1:  (s_active){++++.+}, at: [<ffffffff8115ef86>]
sysfs_get_active_two+0x24/0x48
#2:  (s_active){++++.+}, at: [<ffffffff8115ef93>]
sysfs_get_active_two+0x31/0x48

stack backtrace:
Pid: 18823, comm: fcoemon Tainted: G        W  2.6.33.1linux-stable-2.6.33 #1
Call Trace:
[<ffffffff81076c38>] print_circular_bug+0xa8/0xb6
[<ffffffff81077a85>] __lock_acquire+0xa1d/0xd2b
[<ffffffffa02ba5fc>] ? fcoe_create+0x27/0x4f7 [fcoe]
[<ffffffff81077e60>] lock_acquire+0xcd/0xf1
[<ffffffffa02ba5fc>] ? fcoe_create+0x27/0x4f7 [fcoe]
[<ffffffffa02ba5fc>] ? fcoe_create+0x27/0x4f7 [fcoe]
[<ffffffff8142f343>] __mutex_lock_common+0x4b/0x383
[<ffffffffa02ba5fc>] ? fcoe_create+0x27/0x4f7 [fcoe]
[<ffffffff8106ac70>] ? cpu_clock+0x43/0x5e
[<ffffffff81074e12>] ? lockstat_clock+0x11/0x13
[<ffffffff81074e40>] ? lock_release_holdtime+0x2c/0x127
[<ffffffff8115ef93>] ? sysfs_get_active_two+0x31/0x48
[<ffffffff8142f73f>] mutex_lock_nested+0x3e/0x43
[<ffffffffa02ba5fc>] fcoe_create+0x27/0x4f7 [fcoe]
[<ffffffff810635b1>] param_attr_store+0x27/0x35
[<ffffffff81063619>] module_attr_store+0x26/0x2a
[<ffffffff8115dae3>] sysfs_write_file+0x108/0x144
[<ffffffff81107bd1>] vfs_write+0xae/0x10b
[<ffffffff81076596>] ? trace_hardirqs_on_caller+0x125/0x150
[<ffffffff81107cee>] sys_write+0x4a/0x6e
[<ffffffff81009b42>] system_call_fastpath+0x16/0x1b

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 4834d3c..0c825c0 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -801,6 +801,12 @@ skip_oem:
 /**
  * fcoe_if_destroy() - Tear down a SW FCoE instance
  * @lport: The local port to be destroyed
+ *
+ * Locking: must be called with the RTNL mutex held and RTNL mutex
+ * needed to be dropped by this function since not dropping RTNL
+ * would cause circular locking warning on synchronous fip worker
+ * cancelling thru fcoe_interface_put invoked by this function.
+ *
  */
 static void fcoe_if_destroy(struct fc_lport *lport)
 {
@@ -823,7 +829,6 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	/* Free existing transmit skbs */
 	fcoe_clean_pending_queue(lport);
 
-	rtnl_lock();
 	if (!is_zero_ether_addr(port->data_src_addr))
 		dev_unicast_delete(netdev, port->data_src_addr);
 	rtnl_unlock();
@@ -1902,7 +1907,12 @@ static int fcoe_disable(const char *buffer, struct kernel_param *kp)
 		goto out_nodev;
 	}
 
-	rtnl_lock();
+	if (!rtnl_trylock()) {
+		dev_put(netdev);
+		mutex_unlock(&fcoe_config_mutex);
+		return restart_syscall();
+	}
+
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	rtnl_unlock();
 
@@ -1952,7 +1962,12 @@ static int fcoe_enable(const char *buffer, struct kernel_param *kp)
 		goto out_nodev;
 	}
 
-	rtnl_lock();
+	if (!rtnl_trylock()) {
+		dev_put(netdev);
+		mutex_unlock(&fcoe_config_mutex);
+		return restart_syscall();
+	}
+
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	rtnl_unlock();
 
@@ -2003,7 +2018,12 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 		goto out_nodev;
 	}
 
-	rtnl_lock();
+	if (!rtnl_trylock()) {
+		dev_put(netdev);
+		mutex_unlock(&fcoe_config_mutex);
+		return restart_syscall();
+	}
+
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	if (!fcoe) {
 		rtnl_unlock();
@@ -2012,7 +2032,7 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 	}
 	list_del(&fcoe->list);
 	fcoe_interface_cleanup(fcoe);
-	rtnl_unlock();
+	/* RTNL mutex is dropped by fcoe_if_destroy */
 	fcoe_if_destroy(fcoe->ctlr.lp);
 	module_put(THIS_MODULE);
 
@@ -2033,6 +2053,8 @@ static void fcoe_destroy_work(struct work_struct *work)
 
 	port = container_of(work, struct fcoe_port, destroy_work);
 	mutex_lock(&fcoe_config_mutex);
+	rtnl_lock();
+	/* RTNL mutex is dropped by fcoe_if_destroy */
 	fcoe_if_destroy(port->lport);
 	mutex_unlock(&fcoe_config_mutex);
 }
@@ -2054,6 +2076,12 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	struct net_device *netdev;
 
 	mutex_lock(&fcoe_config_mutex);
+
+	if (!rtnl_trylock()) {
+		mutex_unlock(&fcoe_config_mutex);
+		return restart_syscall();
+	}
+
 #ifdef CONFIG_FCOE_MODULE
 	/*
 	 * Make sure the module has been initialized, and is not about to be
@@ -2071,7 +2099,6 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 		goto out_nomod;
 	}
 
-	rtnl_lock();
 	netdev = fcoe_if_to_netdev(buffer);
 	if (!netdev) {
 		rc = -ENODEV;
@@ -2126,9 +2153,9 @@ out_free:
 out_putdev:
 	dev_put(netdev);
 out_nodev:
-	rtnl_unlock();
 	module_put(THIS_MODULE);
 out_nomod:
+	rtnl_unlock();
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;
 }

