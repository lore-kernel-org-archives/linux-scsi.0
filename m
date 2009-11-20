From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: [PATCH 1/1] pmcraid driver fixes to support SMI-S object model of
 storage pool
Date: Fri, 20 Nov 2009 09:39:30 -0800 (PST)
Message-ID: <alpine.LNX.1.10.0911200846100.27645@rslab159.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:48002 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754783AbZKTSpf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 13:45:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: anil_ravindranath@pmc-sierra.com


PMC-Sierra mgmt application uses SMI-S model. According to SMI-S, the 
object model exposed by the SMI-S provider should show an StoragePool 
which contains member disks of a RAID Virtual disk and StorageVolume 
based on the StoragePool. But according to SMI-S, there is a possibility 
where StoragePool is created but StorageVolume is not yet created. To 
satisfy this scenario, we are trying a hidden RAID Virtual disk. The 
hidden RAID virtual disk will not be exposed to OS. Once a StorageVolume 
is created for this RAID virtual disk it is exposed.

Signed-off-by: Anil Ravindranath<anil_ravindranath@pmc-sierra.com>

pmcraid.c |   34 +++++++++++++++++++++++++---------
pmcraid.h |    5 ++++-
2 files changed, 29 insertions(+), 10 deletions(-)

diff -urN scsi-misc-2.6.orig/drivers/scsi/pmcraid.c scsi-misc-2.6/drivers/scsi/pmcraid.c
--- scsi-misc-2.6.orig/drivers/scsi/pmcraid.c	2009-11-19 18:04:46.000000000 -0800
+++ scsi-misc-2.6/drivers/scsi/pmcraid.c	2009-11-19 18:04:37.000000000 -0800
@@ -1,7 +1,8 @@
 /*
  * pmcraid.c -- driver for PMC Sierra MaxRAID controller adapters
  *
- * Written By: PMC Sierra Corporation
+ * Written By: Anil Ravindranath<anil_ravindranath@pmc-sierra.com>
+ *             PMC-Sierra Inc
  *
  * Copyright (C) 2008, 2009 PMC Sierra Inc
  *
@@ -79,7 +80,7 @@
 /*
  * Module parameters
  */
-MODULE_AUTHOR("PMC Sierra Corporation, anil_ravindranath@pmc-sierra.com");
+MODULE_AUTHOR("Anil Ravindranath<anil_ravindranath@pmc-sierra.com>");
 MODULE_DESCRIPTION("PMC Sierra MaxRAID Controller Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(PMCRAID_DRIVER_VERSION);
@@ -162,10 +163,10 @@
 	spin_lock_irqsave(&pinstance->resource_lock, lock_flags);
 	list_for_each_entry(temp, &pinstance->used_res_q, queue) {
 
-		/* do not expose VSETs with order-ids >= 240 */
+		/* do not expose VSETs with order-ids > MAX_VSET_TARGETS */
 		if (RES_IS_VSET(temp->cfg_entry)) {
 			target = temp->cfg_entry.unique_flags1;
-			if (target >= PMCRAID_MAX_VSET_TARGETS)
+			if (target > PMCRAID_MAX_VSET_TARGETS)
 				continue;
 			bus = PMCRAID_VSET_BUS_ID;
 			lun = 0;
@@ -1210,7 +1211,7 @@
 	int retval = 0;
 
 	if (cfgte->resource_type == RES_TYPE_VSET)
-		retval = ((cfgte->unique_flags1 & 0xFF) < 0xFE);
+		retval = ((cfgte->unique_flags1 & 0x80) == 0);
 	else if (cfgte->resource_type == RES_TYPE_GSCSI)
 		retval = (RES_BUS(cfgte->resource_address) !=
 				PMCRAID_VIRTUAL_ENCL_BUS_ID);
@@ -1361,6 +1362,7 @@
  * Return value:
  *  none
  */
+
 static void pmcraid_handle_config_change(struct pmcraid_instance *pinstance)
 {
 	struct pmcraid_config_table_entry *cfg_entry;
@@ -1368,9 +1370,10 @@
 	struct pmcraid_cmd *cmd;
 	struct pmcraid_cmd *cfgcmd;
 	struct pmcraid_resource_entry *res = NULL;
-	u32 new_entry = 1;
 	unsigned long lock_flags;
 	unsigned long host_lock_flags;
+	u32 new_entry = 1;
+	u32 hidden_entry = 0;
 	int rc;
 
 	ccn_hcam = (struct pmcraid_hcam_ccn *)pinstance->ccn.hcam;
@@ -1406,9 +1409,15 @@
 	}
 
 	/* If this resource is not going to be added to mid-layer, just notify
-	 * applications and return
+	 * applications and return. If this notification is about hiding a VSET
+	 * resource, check if it was exposed already.
 	 */
-	if (!pmcraid_expose_resource(cfg_entry))
+	if (pinstance->ccn.hcam->notification_type ==
+	    NOTIFICATION_TYPE_ENTRY_CHANGED &&
+	    cfg_entry->resource_type == RES_TYPE_VSET &&
+	    cfg_entry->unique_flags1 & 0x80) {
+		hidden_entry = 1;
+	} else if (!pmcraid_expose_resource(cfg_entry))
 		goto out_notify_apps;
 
 	spin_lock_irqsave(&pinstance->resource_lock, lock_flags);
@@ -1424,6 +1433,12 @@
 
 	if (new_entry) {
 
+		if (hidden_entry) {
+			spin_unlock_irqrestore(&pinstance->resource_lock,
+						lock_flags);
+			goto out_notify_apps;
+		}
+
 		/* If there are more number of resources than what driver can
 		 * manage, do not notify the applications about the CCN. Just
 		 * ignore this notifications and re-register the same HCAM
@@ -1454,8 +1469,9 @@
 		sizeof(struct pmcraid_config_table_entry));
 
 	if (pinstance->ccn.hcam->notification_type ==
-	    NOTIFICATION_TYPE_ENTRY_DELETED) {
+	    NOTIFICATION_TYPE_ENTRY_DELETED || hidden_entry) {
 		if (res->scsi_dev) {
+			res->cfg_entry.unique_flags1 &= 0x7F;
 			res->change_detected = RES_CHANGE_DEL;
 			res->cfg_entry.resource_handle =
 				PMCRAID_INVALID_RES_HANDLE;
diff -urN scsi-misc-2.6.orig/drivers/scsi/pmcraid.h scsi-misc-2.6/drivers/scsi/pmcraid.h
--- scsi-misc-2.6.orig/drivers/scsi/pmcraid.h	2009-11-19 18:04:46.000000000 -0800
+++ scsi-misc-2.6/drivers/scsi/pmcraid.h	2009-11-19 18:04:37.000000000 -0800
@@ -1,6 +1,9 @@
 /*
  * pmcraid.h -- PMC Sierra MaxRAID controller driver header file
  *
+ * Written By: Anil Ravindranath<anil_ravindranath@pmc-sierra.com>
+ *             PMC-Sierra Inc
+ *
  * Copyright (C) 2008, 2009 PMC Sierra Inc.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -106,7 +109,7 @@
 #define PMCRAID_VSET_LUN_ID                      0x0
 #define PMCRAID_PHYS_BUS_ID                      0x0
 #define PMCRAID_VIRTUAL_ENCL_BUS_ID              0x8
-#define PMCRAID_MAX_VSET_TARGETS                 240
+#define PMCRAID_MAX_VSET_TARGETS                 0x7F
 #define PMCRAID_MAX_VSET_LUNS_PER_TARGET         8
 
 #define PMCRAID_IOA_MAX_SECTORS                  32767
