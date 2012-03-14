From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] fcoe: Drop the rtnl_mutex before calling fcoe_ctlr_link_up
Date: Tue, 13 Mar 2012 18:22:12 -0700
Message-ID: <20120314012212.7143.52793.stgit@localhost6.localdomain6>
References: <bug-42918-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16507 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760077Ab2CNBWM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Mar 2012 21:22:12 -0400
In-Reply-To: <bug-42918-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bvanassche@acm.org, linux-scsi@vger.kernel.org
Cc: devel@open-fcoe.org, yi.zou@intel.com

The rtnl_lock is primarily used to serialize networking
driver changes as well as to ensure that a networking driver
is not removed when making changes to it. fcoe also uses
the rtnl_lock to protect the fcoe hostlist.

fcoe_create holds the rtnl_lock over the entirity of the
routine including a the call to fcoe_ctlr_link_up.
This causes the below deadlock because fcoe_ctlr_link_up
acquires the fcoe_ctlr ctlr_mutex and this deadlocks with
a libfcoe thread that acquires the fcoe_ctlr ctlr_mutex and
then the rtnl_lock (to update a MAC address).

This patch drops the rtnl_lock before calling
fcoe_ctlr_link_up and therefore the deadlock is prevented.

https://bugzilla.kernel.org/show_bug.cgi?id=42918

the existing dependency chain (in reverse order) is:

-> #1 (&fip->ctlr_mutex){+.+...}:
       [<c1091f70>] lock_acquire+0x80/0x1b0
       [<c147655d>] mutex_lock_nested+0x6d/0x340
       [<f8970c32>] fcoe_ctlr_link_up+0x22/0x180 [libfcoe]
       [<f894620e>] fcoe_create+0x47e/0x6e0 [fcoe]
       [<f8973dd3>] fcoe_transport_create+0x143/0x250 [libfcoe]
       [<c10527e0>] param_attr_store+0x30/0x60
       [<c1052696>] module_attr_store+0x26/0x40
       [<c11a201e>] sysfs_write_file+0xae/0x100
       [<c11449df>] vfs_write+0x8f/0x160
       [<c1144cbd>] sys_write+0x3d/0x70
       [<c147a0c4>] syscall_call+0x7/0xb

-> #0 (rtnl_mutex){+.+.+.}:
       [<c109164b>] __lock_acquire+0x140b/0x1720
       [<c1091f70>] lock_acquire+0x80/0x1b0
       [<c147655d>] mutex_lock_nested+0x6d/0x340
       [<c13a10c4>] rtnl_lock+0x14/0x20
       [<f89445ac>] fcoe_update_src_mac+0x2c/0xb0 [fcoe]
       [<f8971712>] fcoe_ctlr_timer_work+0x712/0xb60 [libfcoe]
       [<c104fb69>] process_one_work+0x179/0x5d0
       [<c10502f1>] worker_thread+0x121/0x2d0
       [<c10550ed>] kthread+0x7d/0x90
       [<c1481a82>] kernel_thread_helper+0x6/0x10

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&fip->ctlr_mutex);
                               lock(rtnl_mutex);
                               lock(&fip->ctlr_mutex);
  lock(rtnl_mutex);

 *** DEADLOCK ***

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index e959960..408ca0e 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2133,8 +2133,12 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 	/* start FIP Discovery and FLOGI */
 	lport->boot_time = jiffies;
 	fc_fabric_login(lport);
-	if (!fcoe_link_ok(lport))
+	if (!fcoe_link_ok(lport)) {
+		rtnl_unlock();
 		fcoe_ctlr_link_up(&fcoe->ctlr);
+		mutex_unlock(&fcoe_config_mutex);
+		return rc;
+	}
 
 out_nodev:
 	rtnl_unlock();

