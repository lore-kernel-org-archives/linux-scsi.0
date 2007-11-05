From: swen@vnet.ibm.com
Subject: [patch 5/6] zfcp: Fix deadlock when adding invalid LUN
Date: Mon, 05 Nov 2007 12:37:47 +0100
Message-ID: <20071105114627.467128000@vnet.ibm.com>
References: <20071105113742.233391000@vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:18161 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbXKELqg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 06:46:36 -0500
Content-Disposition: inline; filename=805-zfcp-deadlock.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When adding an invalid LUN, there is a deadlock between the add
via scsi_scan_target and the slave_destroy handler: The handler
waits for the scan to complete, but for an invalid unit,
scsi_scan_target directly calls the slave_destroy handler.

Fix the deadlock by removing the wait in the slave_destroy
handler, it was not necessary anyway.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c  |    2 --
 drivers/s390/scsi/zfcp_def.h  |    4 ----
 drivers/s390/scsi/zfcp_erp.c  |    1 -
 drivers/s390/scsi/zfcp_scsi.c |    3 ---
 4 files changed, 10 deletions(-)

Index: scsi-misc/drivers/s390/scsi/zfcp_aux.c
===================================================================
--- scsi-misc.orig/drivers/s390/scsi/zfcp_aux.c
+++ scsi-misc/drivers/s390/scsi/zfcp_aux.c
@@ -844,8 +844,6 @@ zfcp_unit_enqueue(struct zfcp_port *port
 	unit->sysfs_device.release = zfcp_sysfs_unit_release;
 	dev_set_drvdata(&unit->sysfs_device, unit);
 
-	init_waitqueue_head(&unit->scsi_scan_wq);
-
 	/* mark unit unusable as long as sysfs registration is not complete */
 	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
 
Index: scsi-misc/drivers/s390/scsi/zfcp_def.h
===================================================================
--- scsi-misc.orig/drivers/s390/scsi/zfcp_def.h
+++ scsi-misc/drivers/s390/scsi/zfcp_def.h
@@ -982,10 +982,6 @@ struct zfcp_unit {
         struct scsi_device     *device;        /* scsi device struct pointer */
 	struct zfcp_erp_action erp_action;     /* pending error recovery */
         atomic_t               erp_counter;
-	wait_queue_head_t      scsi_scan_wq;   /* can be used to wait until
-						  all scsi_scan_target
-						  requests have been
-						  completed. */
 };
 
 /* FSF request */
Index: scsi-misc/drivers/s390/scsi/zfcp_erp.c
===================================================================
--- scsi-misc.orig/drivers/s390/scsi/zfcp_erp.c
+++ scsi-misc/drivers/s390/scsi/zfcp_erp.c
@@ -1609,7 +1609,6 @@ static void zfcp_erp_scsi_scan(struct wo
 	scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
 			 unit->scsi_lun, 0);
 	atomic_clear_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
-	wake_up(&unit->scsi_scan_wq);
 	zfcp_unit_put(unit);
 	kfree(p);
 }
Index: scsi-misc/drivers/s390/scsi/zfcp_scsi.c
===================================================================
--- scsi-misc.orig/drivers/s390/scsi/zfcp_scsi.c
+++ scsi-misc/drivers/s390/scsi/zfcp_scsi.c
@@ -180,9 +180,6 @@ static void zfcp_scsi_slave_destroy(stru
 
 	if (unit) {
 		zfcp_erp_wait(unit->port->adapter);
-		wait_event(unit->scsi_scan_wq,
-			   atomic_test_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING,
-					    &unit->status) == 0);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_REGISTERED, &unit->status);
 		sdpnt->hostdata = NULL;
 		unit->device = NULL;

-- 
