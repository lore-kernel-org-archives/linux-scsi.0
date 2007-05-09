From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 2/2] zfcp: IO stall after deleting and path checker changes after reenabling zfcp devices
Date: Wed, 9 May 2007 11:01:24 +0200
Message-ID: <200705091101.24917.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:12113 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbXEII64 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2007 04:58:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, mloehr2@linux.vnet.ibm.com

From: Michael Loehr <mloehr2@linux.vnet.ibm.com>

IO stall after deleting and path checker changes after reenabling zfcp device

Setting one zfcp device offline using chccwdev in a multipath
environment and waiting will lead to IO stall on all paths.
After setting the zfcp device back online using chccwdev,
the devices with io stall will have a different path checker.
Devices corresponding to the deleted units are never freed. 
This has the effect that 'slave_destroy' is never called and zfcp
still thinks that this unit is registered
(ZFCP_STATUS_UNIT_REGISTERED is still set). Hence the erp
routine is not called correctly and the unit is not enabled properly.

Do not delete rport and the sdev. Just set the host to block on
'offline'. Setting host online again will then remove the blocked status
and everything is fine again.

Signed-off-by: Michael Loehr <mloehr2@linux.vnet.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
h
---
 drivers/s390/scsi/zfcp_aux.c  |    1 +
 drivers/s390/scsi/zfcp_ccw.c  |    5 +----
 drivers/s390/scsi/zfcp_scsi.c |    3 +++
 3 files changed, 5 insertions(+), 4 deletions(-)

Index: linux_jb_patched/drivers/s390/scsi/zfcp_aux.c
===================================================================
--- linux_jb_patched.orig/drivers/s390/scsi/zfcp_aux.c
+++ linux_jb_patched/drivers/s390/scsi/zfcp_aux.c
@@ -1129,6 +1129,7 @@ zfcp_adapter_dequeue(struct zfcp_adapter
 	int retval = 0;
 	unsigned long flags;
 
+	zfcp_adapter_scsi_unregister(adapter);
 	device_unregister(&adapter->generic_services);
 	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
 	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
Index: linux_jb_patched/drivers/s390/scsi/zfcp_ccw.c
===================================================================
--- linux_jb_patched.orig/drivers/s390/scsi/zfcp_ccw.c
+++ linux_jb_patched/drivers/s390/scsi/zfcp_ccw.c
@@ -189,9 +189,7 @@ zfcp_ccw_set_online(struct ccw_device *c
  * @ccw_device: pointer to belonging ccw device
  *
  * This function gets called by the common i/o layer and sets an adapter
- * into state offline. Setting an fcp device offline means that it will be
- * unregistered from the SCSI stack and that the adapter will be shut down
- * asynchronously.
+ * into state offline.
  */
 static int
 zfcp_ccw_set_offline(struct ccw_device *ccw_device)
@@ -202,7 +200,6 @@ zfcp_ccw_set_offline(struct ccw_device *
 	adapter = dev_get_drvdata(&ccw_device->dev);
 	zfcp_erp_adapter_shutdown(adapter, 0);
 	zfcp_erp_wait(adapter);
-	zfcp_adapter_scsi_unregister(adapter);
 	zfcp_erp_thread_kill(adapter);
 	zfcp_adapter_debug_unregister(adapter);
 	up(&zfcp_data.config_sema);
Index: linux_jb_patched/drivers/s390/scsi/zfcp_scsi.c
===================================================================
--- linux_jb_patched.orig/drivers/s390/scsi/zfcp_scsi.c
+++ linux_jb_patched/drivers/s390/scsi/zfcp_scsi.c
@@ -569,6 +569,9 @@ zfcp_adapter_scsi_register(struct zfcp_a
 	int retval = 0;
 	static unsigned int unique_id = 0;
 
+	if (adapter->scsi_host)
+		goto out;
+
 	/* register adapter as SCSI host with mid layer of SCSI stack */
 	adapter->scsi_host = scsi_host_alloc(&zfcp_data.scsi_host_template,
 					     sizeof (struct zfcp_adapter *));
