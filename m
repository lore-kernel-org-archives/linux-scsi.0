From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH v3 10/10] fcoe: Return ERESTARTSYS on rtnl_trylock failure
Date: Wed, 12 Jan 2011 18:20:42 -0800
Message-ID: <20110113022041.12798.64499.stg.yi.zou@intel.com>
References: <20110113021649.12798.71742.stg.yi.zou@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37843 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361Ab1AMCXt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2011 21:23:49 -0500
In-Reply-To: <20110113021649.12798.71742.stg.yi.zou@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: bprakash@broadcom.com, linux-scsi@vger.kernel.org

From: Bhanu Gollapudi <bprakash@broadcom.com>

fcoe driver should return -ERESTARTSYS instead of -ENODEV so
that rtnl lock will be retried.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index cd40fc8..eda70e5 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1948,7 +1948,7 @@ static int fcoe_disable(struct net_device *netdev)
 
 	if (!rtnl_trylock()) {
 		mutex_unlock(&fcoe_config_mutex);
-		return -ENODEV;
+		return -ERESTARTSYS;
 	}
 
 	fcoe = fcoe_hostlist_lookup_port(netdev);
@@ -1992,7 +1992,7 @@ static int fcoe_enable(struct net_device *netdev)
 #endif
 	if (!rtnl_trylock()) {
 		mutex_unlock(&fcoe_config_mutex);
-		return -ENODEV;
+		return -ERESTARTSYS;
 	}
 
 	fcoe = fcoe_hostlist_lookup_port(netdev);
@@ -2035,7 +2035,7 @@ static int fcoe_destroy(struct net_device *netdev)
 #endif
 	if (!rtnl_trylock()) {
 		mutex_unlock(&fcoe_config_mutex);
-		return -ENODEV;
+		return -ERESTARTSYS;
 	}
 
 	fcoe = fcoe_hostlist_lookup_port(netdev);
@@ -2088,7 +2088,7 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 
 	if (!rtnl_trylock()) {
 		mutex_unlock(&fcoe_config_mutex);
-		return -EIO;
+		return -ERESTARTSYS;
 	}
 
 #ifdef CONFIG_FCOE_MODULE

