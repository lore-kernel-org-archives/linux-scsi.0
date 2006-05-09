From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 5/8] aic94xx: remove inline functions
Date: Tue, 09 May 2006 14:33:57 -0700
Message-ID: <1147210437.11847.55.camel@localhost.localdomain>
References: <1147209211.11847.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:52455 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751108AbWEIVd6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 May 2006 17:33:58 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k49LXwej007620
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 17:33:58 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k49LXwUi140916
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:33:58 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k49LXwP7030354
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:33:58 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.121])
	by d03av01.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id k49LXvO1030345
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:33:58 -0600
In-Reply-To: <1147209211.11847.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Remove various needless inline functions

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
Signed-off-by: Mike Anderson <andmike@us.ibm.com>

---
 drivers/scsi/sas/sas_discover.c  |   23 ++++++++++++++++++++++-
 drivers/scsi/sas/sas_expander.c  |   22 +++++++++++-----------
 drivers/scsi/sas/sas_scsi_host.c |    6 +++---
 include/scsi/sas/sas_discover.h  |   22 ++--------------------
 4 files changed, 38 insertions(+), 35 deletions(-)

Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_discover.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_discover.c
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_discover.c
@@ -36,6 +36,27 @@
 
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
@@ -300,7 +321,7 @@ static int sas_get_port_device(struct sa
 
 /* ---------- SATA ---------- */
 
-static inline void sas_get_ata_command_set(struct domain_device *dev)
+static void sas_get_ata_command_set(struct domain_device *dev)
 {
 	struct dev_to_host_fis *fis =
 		(struct dev_to_host_fis *) dev->frame_rcvd;
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_expander.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_expander.c
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_expander.c
@@ -289,7 +289,7 @@ out_err:
 
 #define MAX_EXPANDER_PHYS 128
 
-static inline void ex_assign_report_general(struct domain_device *dev,
+static void ex_assign_report_general(struct domain_device *dev,
 					    struct smp_resp *resp)
 {
 	struct report_general_resp *rg = &resp->rg;
@@ -354,7 +354,7 @@ out:
 	return res;
 }
 
-static inline void ex_assign_manuf_info(struct domain_device *dev, void
+static void ex_assign_manuf_info(struct domain_device *dev, void
 					*_mi_resp)
 {
 	u8 *mi_resp = _mi_resp;
@@ -453,7 +453,7 @@ static inline void sas_ex_disable_phy(st
 	phy->linkrate = PHY_DISABLED;
 }
 
-static inline void sas_ex_disable_port(struct domain_device *dev, u8 *sas_addr)
+static void sas_ex_disable_port(struct domain_device *dev, u8 *sas_addr)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	int i;
@@ -470,7 +470,7 @@ static inline void sas_ex_disable_port(s
 	}
 }
 
-static inline int sas_dev_present_in_domain(struct sas_port *port,
+static int sas_dev_present_in_domain(struct sas_port *port,
 					    u8 *sas_addr)
 {
 	struct domain_device *dev;
@@ -487,7 +487,7 @@ static inline int sas_dev_present_in_dom
 #define RPS_REQ_SIZE  16
 #define RPS_RESP_SIZE 60
 
-static inline int sas_get_report_phy_sata(struct domain_device *dev,
+static int sas_get_report_phy_sata(struct domain_device *dev,
 					  int phy_id,
 					  struct smp_resp *rps_resp)
 {
@@ -507,7 +507,7 @@ static inline int sas_get_report_phy_sat
 	return 0;
 }
 
-static inline void sas_ex_get_linkrate(struct domain_device *parent,
+static void sas_ex_get_linkrate(struct domain_device *parent,
 				       struct domain_device *child,
 				       struct ex_phy *parent_phy)
 {
@@ -774,7 +774,7 @@ static int sas_ex_discover_dev(struct do
 	return res;
 }
 
-static inline int sas_find_sub_addr(struct domain_device *dev, u8 *sub_addr)
+static int sas_find_sub_addr(struct domain_device *dev, u8 *sub_addr)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	int i;
@@ -915,7 +915,7 @@ static int sas_check_ex_subtractive_boun
 	return 0;
 }
 
-static inline void sas_print_parent_topology_bug(struct domain_device *child,
+static void sas_print_parent_topology_bug(struct domain_device *child,
 						 struct ex_phy *parent_phy,
 						 struct ex_phy *child_phy)
 {
@@ -945,7 +945,7 @@ static inline void sas_print_parent_topo
 		   ra_char[child_phy->routing_attr]);
 }
 
-static inline int sas_check_eeds(struct domain_device *child,
+static int sas_check_eeds(struct domain_device *child,
 				 struct ex_phy *parent_phy,
 				 struct ex_phy *child_phy)
 {
@@ -1173,7 +1173,7 @@ out:
 	return res;
 }
 
-static inline int sas_configure_phy(struct domain_device *dev, int phy_id,
+static int sas_configure_phy(struct domain_device *dev, int phy_id,
 				    u8 *sas_addr, int include)
 {
 	int index;
@@ -1590,7 +1590,7 @@ out:
 	return res;
 }
 
-static inline int sas_discover_new(struct domain_device *dev, int phy_id)
+static int sas_discover_new(struct domain_device *dev, int phy_id)
 {
 	struct ex_phy *ex_phy = &dev->ex_dev.ex_phy[phy_id];
 	struct domain_device *child;
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_scsi_host.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_scsi_host.c
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_scsi_host.c
@@ -123,7 +123,7 @@ static void sas_scsi_task_done(struct sa
 		sc->scsi_done(sc);
 }
 
-static inline enum task_attribute sas_scsi_get_task_attr(struct scsi_cmnd *cmd)
+static enum task_attribute sas_scsi_get_task_attr(struct scsi_cmnd *cmd)
 {
 	enum task_attribute ta = TASK_ATTR_SIMPLE;
 	if (cmd->request && blk_rq_tagged(cmd->request)) {
@@ -134,7 +134,7 @@ static inline enum task_attribute sas_sc
 	return ta;
 }
 
-static inline struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
+static struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
 					       struct domain_device *dev,
 					       unsigned long gfp_flags)
 {
@@ -167,7 +167,7 @@ static inline struct sas_task *sas_creat
 	return task;
 }
 
-static inline int sas_queue_up(struct sas_task *task)
+static int sas_queue_up(struct sas_task *task)
 {
 	struct sas_ha_struct *sas_ha = task->dev->port->ha;
 	struct scsi_core *core = &sas_ha->core;
Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas_discover.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_discover.h
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas_discover.h
@@ -122,26 +122,6 @@ struct domain_device {
 	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
 
 
-static inline void sas_init_dev(struct domain_device *dev)
-{
-	INIT_LIST_HEAD(&dev->siblings);
-	INIT_LIST_HEAD(&dev->dev_list_node);
-	switch (dev->dev_type) {
-	case SAS_END_DEV:
-		break;
-	case EDGE_DEV:
-	case FANOUT_DEV:
-		INIT_LIST_HEAD(&dev->ex_dev.children);
-		break;
-	case SATA_DEV:
-	case SATA_PM:
-	case SATA_PM_PORT:
-		INIT_LIST_HEAD(&dev->sata_dev.children);
-		break;
-	default:
-		break;
-	}
-}
 
 void sas_init_disc(struct sas_discovery *disc, struct sas_port *port);
 int  sas_discover_event(struct sas_port *sas_port, enum discover_event ev);
@@ -153,4 +133,6 @@ void sas_unregister_dev(struct domain_de
 
 void sas_unregister_devices(struct sas_ha_struct *sas_ha);
 
+void sas_init_dev(struct domain_device *dev);
+
 #endif /* _SAS_DISCOVER_H_ */


