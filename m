From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/11] fcoe: Remove mutex_trylock/restart_syscall checks
Date: Fri, 01 Apr 2011 16:05:59 -0700
Message-ID: <20110401230559.15001.24133.stgit@localhost6.localdomain6>
References: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28075 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab1DAXGQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 19:06:16 -0400
In-Reply-To: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>

These checks were initially added to avoid a lockdep
false positive when dealing with the s_active, rtnl
and fcoe_config_mutex mutexes. Recently the create,
destroy, enable and disable sysfs entries were moved
from fcoe.ko to libfcoe.ko. With this change the mutex
usage was shuffled around and the lockdep false
positive stopped happening. We can now remove these
checks.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   24 ++++--------------------
 1 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index bde6ee5..9e7206e 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1795,11 +1795,7 @@ static int fcoe_disable(struct net_device *netdev)
 	}
 #endif
 
-	if (!rtnl_trylock()) {
-		mutex_unlock(&fcoe_config_mutex);
-		return -ERESTARTSYS;
-	}
-
+	rtnl_lock();
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	rtnl_unlock();
 
@@ -1839,11 +1835,7 @@ static int fcoe_enable(struct net_device *netdev)
 		goto out_nodev;
 	}
 #endif
-	if (!rtnl_trylock()) {
-		mutex_unlock(&fcoe_config_mutex);
-		return -ERESTARTSYS;
-	}
-
+	rtnl_lock();
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	rtnl_unlock();
 
@@ -1882,11 +1874,7 @@ static int fcoe_destroy(struct net_device *netdev)
 		goto out_nodev;
 	}
 #endif
-	if (!rtnl_trylock()) {
-		mutex_unlock(&fcoe_config_mutex);
-		return -ERESTARTSYS;
-	}
-
+	rtnl_lock();
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	if (!fcoe) {
 		rtnl_unlock();
@@ -1948,11 +1936,7 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 	struct fc_lport *lport;
 
 	mutex_lock(&fcoe_config_mutex);
-
-	if (!rtnl_trylock()) {
-		mutex_unlock(&fcoe_config_mutex);
-		return -ERESTARTSYS;
-	}
+	rtnl_lock();
 
 #ifdef CONFIG_FCOE_MODULE
 	/*

