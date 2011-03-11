From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 02/10] fcoe: Remove mutex_trylock/restart_syscall checks
Date: Fri, 11 Mar 2011 13:54:39 -0800
Message-ID: <20110311215439.18760.76775.stgit@localhost6.localdomain6>
References: <20110311215428.18760.80632.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:52300 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab1CKVyk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2011 16:54:40 -0500
In-Reply-To: <20110311215428.18760.80632.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

These checks were initially added to avoid a lockdep
false positive when dealing with the s_active, rtnl
and fcoe_config_mutex mutexes. Recently the create,
destroy, enable and disable sysfs entries were moved
from fcoe.ko to libfcoe.ko. With this change the mutex
usage was shuffled around and the lockdep false
positive stopped happening. We can now remove these
checks.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   24 ++++--------------------
 1 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 94fb480..488b7d9 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1797,11 +1797,7 @@ static int fcoe_disable(struct net_device *netdev)
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
 
@@ -1841,11 +1837,7 @@ static int fcoe_enable(struct net_device *netdev)
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
 
@@ -1884,11 +1876,7 @@ static int fcoe_destroy(struct net_device *netdev)
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
@@ -1950,11 +1938,7 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
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

