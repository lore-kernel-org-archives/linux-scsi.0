From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/11] libfcoe: Remove mutex_trylock/restart_syscall checks
Date: Fri, 01 Apr 2011 16:05:53 -0700
Message-ID: <20110401230553.15001.13849.stgit@localhost6.localdomain6>
References: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45637 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab1DAXFy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 19:05:54 -0400
In-Reply-To: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>

This code was incorrectly ported from fcoe.c when the
fcoe transport infrastructure was put into place. It
was originally needed in fcoe.c when dealing with
the rtnl mutex. In that code it was only needed to
avoid a lockdep false positive. In libfcoe we don't
deal with the rtnl mutex, we don't get the lockdep
false positive and therefore we don't need these
checks.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 drivers/scsi/fcoe/fcoe_transport.c |   36 +++++++++++-------------------------
 1 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 2586841..7b61d00 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -530,9 +530,6 @@ static int fcoe_transport_create(const char *buffer, struct kernel_param *kp)
 	struct fcoe_transport *ft = NULL;
 	enum fip_state fip_mode = (enum fip_state)(long)kp->arg;
 
-	if (!mutex_trylock(&ft_mutex))
-		return restart_syscall();
-
 #ifdef CONFIG_LIBFCOE_MODULE
 	/*
 	 * Make sure the module has been initialized, and is not about to be
@@ -543,6 +540,8 @@ static int fcoe_transport_create(const char *buffer, struct kernel_param *kp)
 		goto out_nodev;
 #endif
 
+	mutex_lock(&ft_mutex);
+
 	netdev = fcoe_if_to_netdev(buffer);
 	if (!netdev) {
 		LIBFCOE_TRANSPORT_DBG("Invalid device %s.\n", buffer);
@@ -586,10 +585,7 @@ out_putdev:
 	dev_put(netdev);
 out_nodev:
 	mutex_unlock(&ft_mutex);
-	if (rc == -ERESTARTSYS)
-		return restart_syscall();
-	else
-		return rc;
+	return rc;
 }
 
 /**
@@ -608,9 +604,6 @@ static int fcoe_transport_destroy(const char *buffer, struct kernel_param *kp)
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
 
-	if (!mutex_trylock(&ft_mutex))
-		return restart_syscall();
-
 #ifdef CONFIG_LIBFCOE_MODULE
 	/*
 	 * Make sure the module has been initialized, and is not about to be
@@ -621,6 +614,8 @@ static int fcoe_transport_destroy(const char *buffer, struct kernel_param *kp)
 		goto out_nodev;
 #endif
 
+	mutex_lock(&ft_mutex);
+
 	netdev = fcoe_if_to_netdev(buffer);
 	if (!netdev) {
 		LIBFCOE_TRANSPORT_DBG("invalid device %s.\n", buffer);
@@ -645,11 +640,7 @@ out_putdev:
 	dev_put(netdev);
 out_nodev:
 	mutex_unlock(&ft_mutex);
-
-	if (rc == -ERESTARTSYS)
-		return restart_syscall();
-	else
-		return rc;
+	return rc;
 }
 
 /**
@@ -667,9 +658,6 @@ static int fcoe_transport_disable(const char *buffer, struct kernel_param *kp)
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
 
-	if (!mutex_trylock(&ft_mutex))
-		return restart_syscall();
-
 #ifdef CONFIG_LIBFCOE_MODULE
 	/*
 	 * Make sure the module has been initialized, and is not about to be
@@ -680,6 +668,8 @@ static int fcoe_transport_disable(const char *buffer, struct kernel_param *kp)
 		goto out_nodev;
 #endif
 
+	mutex_lock(&ft_mutex);
+
 	netdev = fcoe_if_to_netdev(buffer);
 	if (!netdev)
 		goto out_nodev;
@@ -716,9 +706,6 @@ static int fcoe_transport_enable(const char *buffer, struct kernel_param *kp)
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
 
-	if (!mutex_trylock(&ft_mutex))
-		return restart_syscall();
-
 #ifdef CONFIG_LIBFCOE_MODULE
 	/*
 	 * Make sure the module has been initialized, and is not about to be
@@ -729,6 +716,8 @@ static int fcoe_transport_enable(const char *buffer, struct kernel_param *kp)
 		goto out_nodev;
 #endif
 
+	mutex_lock(&ft_mutex);
+
 	netdev = fcoe_if_to_netdev(buffer);
 	if (!netdev)
 		goto out_nodev;
@@ -743,10 +732,7 @@ out_putdev:
 	dev_put(netdev);
 out_nodev:
 	mutex_unlock(&ft_mutex);
-	if (rc == -ERESTARTSYS)
-		return restart_syscall();
-	else
-		return rc;
+	return rc;
 }
 
 /**

