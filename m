From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 09/11] zfcp: Remove busid macro
Date: Fri, 19 Dec 2008 16:57:00 +0100
Message-ID: <20081219155756.192804000@de.ibm.com>
References: <20081219155651.010878000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:48717 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYLSP56 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2008 10:57:58 -0500
Content-Disposition: inline; filename=remove-busid.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

With the change to the dev_ message macros, the macro to get the busid
is only used in a few places. Remove it and directly get the dev_name
from the device.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c  |    8 ++++----
 drivers/s390/scsi/zfcp_def.h  |    2 --
 drivers/s390/scsi/zfcp_qdio.c |    4 ++--
 3 files changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-12-19 14:38:13.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-12-19 14:38:40.000000000 +0100
@@ -1246,7 +1246,7 @@ int zfcp_adapter_debug_register(struct z
 	char dbf_name[DEBUG_MAX_NAME_LEN];
 
 	/* debug feature area which records recovery activity */
-	sprintf(dbf_name, "zfcp_%s_rec", zfcp_get_busid_by_adapter(adapter));
+	sprintf(dbf_name, "zfcp_%s_rec", dev_name(&adapter->ccw_device->dev));
 	adapter->rec_dbf = debug_register(dbf_name, dbfsize, 1,
 					  sizeof(struct zfcp_rec_dbf_record));
 	if (!adapter->rec_dbf)
@@ -1256,7 +1256,7 @@ int zfcp_adapter_debug_register(struct z
 	debug_set_level(adapter->rec_dbf, 3);
 
 	/* debug feature area which records HBA (FSF and QDIO) conditions */
-	sprintf(dbf_name, "zfcp_%s_hba", zfcp_get_busid_by_adapter(adapter));
+	sprintf(dbf_name, "zfcp_%s_hba", dev_name(&adapter->ccw_device->dev));
 	adapter->hba_dbf = debug_register(dbf_name, dbfsize, 1,
 					  sizeof(struct zfcp_hba_dbf_record));
 	if (!adapter->hba_dbf)
@@ -1266,7 +1266,7 @@ int zfcp_adapter_debug_register(struct z
 	debug_set_level(adapter->hba_dbf, 3);
 
 	/* debug feature area which records SAN command failures and recovery */
-	sprintf(dbf_name, "zfcp_%s_san", zfcp_get_busid_by_adapter(adapter));
+	sprintf(dbf_name, "zfcp_%s_san", dev_name(&adapter->ccw_device->dev));
 	adapter->san_dbf = debug_register(dbf_name, dbfsize, 1,
 					  sizeof(struct zfcp_san_dbf_record));
 	if (!adapter->san_dbf)
@@ -1276,7 +1276,7 @@ int zfcp_adapter_debug_register(struct z
 	debug_set_level(adapter->san_dbf, 6);
 
 	/* debug feature area which records SCSI command failures and recovery */
-	sprintf(dbf_name, "zfcp_%s_scsi", zfcp_get_busid_by_adapter(adapter));
+	sprintf(dbf_name, "zfcp_%s_scsi", dev_name(&adapter->ccw_device->dev));
 	adapter->scsi_dbf = debug_register(dbf_name, dbfsize, 1,
 					   sizeof(struct zfcp_scsi_dbf_record));
 	if (!adapter->scsi_dbf)
--- a/drivers/s390/scsi/zfcp_def.h	2008-12-19 14:38:39.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2008-12-19 14:38:40.000000000 +0100
@@ -600,8 +600,6 @@ struct zfcp_fsf_req_qtcb {
 #define ZFCP_SET                0x00000100
 #define ZFCP_CLEAR              0x00000200
 
-#define zfcp_get_busid_by_adapter(adapter) (dev_name(&adapter->ccw_device->dev))
-
 /*
  * Helper functions for request ID management.
  */
--- a/drivers/s390/scsi/zfcp_qdio.c	2008-12-19 14:38:13.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_qdio.c	2008-12-19 14:38:40.000000000 +0100
@@ -109,7 +109,7 @@ static void zfcp_qdio_reqid_check(struct
 		 * corruption and must stop the machine immediatly.
 		 */
 		panic("error: unknown request id (%lx) on adapter %s.\n",
-		      req_id, zfcp_get_busid_by_adapter(adapter));
+		      req_id, dev_name(&adapter->ccw_device->dev));
 
 	zfcp_reqlist_remove(adapter, fsf_req);
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
@@ -389,7 +389,7 @@ int zfcp_qdio_allocate(struct zfcp_adapt
 
 	init_data->cdev = adapter->ccw_device;
 	init_data->q_format = QDIO_ZFCP_QFMT;
-	memcpy(init_data->adapter_name, zfcp_get_busid_by_adapter(adapter), 8);
+	memcpy(init_data->adapter_name, dev_name(&adapter->ccw_device->dev), 8);
 	ASCEBC(init_data->adapter_name, 8);
 	init_data->qib_param_field_format = 0;
 	init_data->qib_param_field = NULL;

-- 
