From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 7/7] aic94xx: remove various inline functions
Date: Tue, 06 Jun 2006 16:53:52 -0700
Message-ID: <1149638032.25278.84.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:59075 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751380AbWFFXyJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jun 2006 19:54:09 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56Ns8mT012121
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 19:54:08 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k56Ns5Qq057122
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:54:05 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k56Ns8I3009694
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:54:08 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.62])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56Ns7E9009678
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:54:07 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Remove various inline functions

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>

---
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_discover.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_discover.c	2006-06-05 13:12:57.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_discover.c	2006-06-06 09:37:39.000000000 -0700
@@ -34,6 +34,27 @@
 
 /* ---------- Basic task processing for discovery purposes ---------- */
 
+void sas_init_dev(struct domain_device *dev)
+{
+        INIT_LIST_HEAD(&dev->siblings);
+        INIT_LIST_HEAD(&dev->dev_list_node);
+        switch (dev->dev_type) {
+        case SAS_END_DEV:
+                break;
+        case EDGE_DEV:
+        case FANOUT_DEV:
+                INIT_LIST_HEAD(&dev->ex_dev.children);
+                break;
+        case SATA_DEV:
+        case SATA_PM:
+        case SATA_PM_PORT:
+                INIT_LIST_HEAD(&dev->sata_dev.children);
+                break;
+        default:
+                break;
+        }
+}
+
 static void sas_task_timedout(unsigned long _task)
 {
 	struct sas_task *task = (void *) _task;
@@ -300,7 +321,7 @@
 
 /* ---------- SATA ---------- */
 
-static inline void sas_get_ata_command_set(struct domain_device *dev)
+static void sas_get_ata_command_set(struct domain_device *dev)
 {
 	struct dev_to_host_fis *fis =
 		(struct dev_to_host_fis *) dev->frame_rcvd;
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_expander.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_expander.c	2006-06-05 13:12:57.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_expander.c	2006-06-06 09:44:43.000000000 -0700
@@ -292,7 +292,7 @@
 
 #define MAX_EXPANDER_PHYS 128
 
-static inline void ex_assign_report_general(struct domain_device *dev,
+static void ex_assign_report_general(struct domain_device *dev,
 					    struct smp_resp *resp)
 {
 	struct report_general_resp *rg = &resp->rg;
@@ -357,7 +357,7 @@
 	return res;
 }
 
-static inline void ex_assign_manuf_info(struct domain_device *dev, void
+static void ex_assign_manuf_info(struct domain_device *dev, void
 					*_mi_resp)
 {
 	u8 *mi_resp = _mi_resp;
@@ -447,7 +447,7 @@
 	return res;
 }
 
-static inline void sas_ex_disable_phy(struct domain_device *dev, int phy_id)
+static void sas_ex_disable_phy(struct domain_device *dev, int phy_id)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *phy = &ex->ex_phy[phy_id];
@@ -456,7 +456,7 @@
 	phy->linkrate = PHY_DISABLED;
 }
 
-static inline void sas_ex_disable_port(struct domain_device *dev, u8 *sas_addr)
+static void sas_ex_disable_port(struct domain_device *dev, u8 *sas_addr)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	int i;
@@ -473,7 +473,7 @@
 	}
 }
 
-static inline int sas_dev_present_in_domain(struct asd_sas_port *port,
+static int sas_dev_present_in_domain(struct asd_sas_port *port,
 					    u8 *sas_addr)
 {
 	struct domain_device *dev;
@@ -490,7 +490,7 @@
 #define RPS_REQ_SIZE  16
 #define RPS_RESP_SIZE 60
 
-static inline int sas_get_report_phy_sata(struct domain_device *dev,
+static int sas_get_report_phy_sata(struct domain_device *dev,
 					  int phy_id,
 					  struct smp_resp *rps_resp)
 {
@@ -510,7 +510,7 @@
 	return 0;
 }
 
-static inline void sas_ex_get_linkrate(struct domain_device *parent,
+static void sas_ex_get_linkrate(struct domain_device *parent,
 				       struct domain_device *child,
 				       struct ex_phy *parent_phy)
 {
@@ -793,7 +793,7 @@
 	return res;
 }
 
-static inline int sas_find_sub_addr(struct domain_device *dev, u8 *sub_addr)
+static int sas_find_sub_addr(struct domain_device *dev, u8 *sub_addr)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	int i;
@@ -934,7 +934,7 @@
 	return 0;
 }
 
-static inline void sas_print_parent_topology_bug(struct domain_device *child,
+static void sas_print_parent_topology_bug(struct domain_device *child,
 						 struct ex_phy *parent_phy,
 						 struct ex_phy *child_phy)
 {
@@ -964,7 +964,7 @@
 		   ra_char[child_phy->routing_attr]);
 }
 
-static inline int sas_check_eeds(struct domain_device *child,
+static int sas_check_eeds(struct domain_device *child,
 				 struct ex_phy *parent_phy,
 				 struct ex_phy *child_phy)
 {
@@ -1192,7 +1192,7 @@
 	return res;
 }
 
-static inline int sas_configure_phy(struct domain_device *dev, int phy_id,
+static int sas_configure_phy(struct domain_device *dev, int phy_id,
 				    u8 *sas_addr, int include)
 {
 	int index;
@@ -1609,7 +1609,7 @@
 	return res;
 }
 
-static inline int sas_discover_new(struct domain_device *dev, int phy_id)
+static int sas_discover_new(struct domain_device *dev, int phy_id)
 {
 	struct ex_phy *ex_phy = &dev->ex_dev.ex_phy[phy_id];
 	struct domain_device *child;
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_scsi_host.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_scsi_host.c	2006-06-05 13:12:57.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_scsi_host.c	2006-06-06 09:46:23.000000000 -0700
@@ -121,7 +121,7 @@
 		sc->scsi_done(sc);
 }
 
-static inline enum task_attribute sas_scsi_get_task_attr(struct scsi_cmnd *cmd)
+static enum task_attribute sas_scsi_get_task_attr(struct scsi_cmnd *cmd)
 {
 	enum task_attribute ta = TASK_ATTR_SIMPLE;
 	if (cmd->request && blk_rq_tagged(cmd->request)) {
@@ -132,7 +132,7 @@
 	return ta;
 }
 
-static inline struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
+static struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
 					       struct domain_device *dev,
 					       unsigned long gfp_flags)
 {
@@ -165,7 +165,7 @@
 	return task;
 }
 
-static inline int sas_queue_up(struct sas_task *task)
+static int sas_queue_up(struct sas_task *task)
 {
 	struct sas_ha_struct *sas_ha = task->dev->port->ha;
 	struct scsi_core *core = &sas_ha->core;


