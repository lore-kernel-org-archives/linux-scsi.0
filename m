From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 2/2] aic94xx: ref count update
Date: Wed, 22 Mar 2006 13:44:11 -0800
Message-ID: <20060322214411.GC661@us.ibm.com>
References: <20060322214119.GA661@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:34259 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751232AbWCVVoM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 16:44:12 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k2MLiCkw021640
	for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 16:44:12 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2MLfAOa230250
	for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 14:41:10 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k2MLiCgM027418
	for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 14:44:12 -0700
Received: from hmsbounty.us.ibm.com (sig-9-76-215-94.mts.ibm.com [9.76.215.94])
	by d03av04.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id k2MLiBHr027382
	for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 14:44:11 -0700
Content-Disposition: inline
In-Reply-To: <20060322214119.GA661@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Allow aic94xx driver to unloaded and load.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>

 drivers/scsi/sas/sas_discover.c  |    2 ++
 drivers/scsi/sas/sas_init.c      |    2 --
 drivers/scsi/sas/sas_scsi_host.c |    1 +
 include/scsi/sas/sas_discover.h  |    3 ---
 4 files changed, 3 insertions(+), 5 deletions(-)

Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas_discover.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_discover.h	2006-03-22 13:22:22.000000000 -0800
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas_discover.h	2006-03-22 13:24:39.000000000 -0800
@@ -128,8 +128,6 @@ static inline int sas_notify_lldd_dev_fo
 	int res = 0;
 	struct sas_ha_struct *sas_ha = dev->port->ha;
 
-	if (!try_module_get(sas_ha->lldd_module))
-		return -ENOMEM;
 	if (sas_ha->lldd_dev_found) {
 		res = sas_ha->lldd_dev_found(dev);
 		if (res) {
@@ -146,7 +144,6 @@ static inline void sas_notify_lldd_dev_g
 {
 	if (dev->port->ha->lldd_dev_gone)
 		dev->port->ha->lldd_dev_gone(dev);
-	module_put(dev->port->ha->lldd_module);
 }
 
 static inline void sas_init_dev(struct domain_device *dev)
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_scsi_host.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_scsi_host.c	2006-03-22 13:22:22.000000000 -0800
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_scsi_host.c	2006-03-22 13:24:39.000000000 -0800
@@ -693,6 +693,7 @@ out_err:
 
 void sas_unregister_scsi_host(struct sas_ha_struct *sas_ha)
 {
+	sas_remove_host(sas_ha->core.shost);
 	scsi_remove_host(sas_ha->core.shost);
 	scsi_host_put(sas_ha->core.shost);
 	sas_ha->core.shost = NULL;
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_init.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_init.c	2006-03-22 13:22:22.000000000 -0800
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_init.c	2006-03-22 13:24:39.000000000 -0800
@@ -108,8 +108,6 @@ Undo:
 
 int sas_unregister_ha(struct sas_ha_struct *sas_ha)
 {
-	sas_unregister_devices(sas_ha);
-
 	if (sas_ha->lldd_max_execute_num > 1) {
 		sas_shutdown_queue(sas_ha);
 	}
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_discover.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_discover.c	2006-03-22 13:22:22.000000000 -0800
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_discover.c	2006-03-22 13:24:39.000000000 -0800
@@ -591,6 +591,8 @@ static void sas_unregister_domain_device
 
 	list_for_each_entry_reverse_safe(dev,n,&port->dev_list,dev_list_node)
 		sas_unregister_dev(dev);
+
+	complete(&port->port_gone_completion);
 }
 
 /* ---------- Discovery and Revalidation ---------- */
