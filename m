From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 02/18] [PATCH] zfcp: Remove UNIT_REGISTERED status flag
Date: Mon, 02 Mar 2009 13:08:55 +0100
Message-ID: <20090302121002.289821000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:49626 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758678AbZCBMKG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:06 -0500
Content-Disposition: inline; filename=701-zfcp-unit-registered.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Use the device pointer in zfcp_unit for tracking if we have a
registered SCSI device. With this approach, the flag
ZFCP_STATUS_UNIT_REGISTERED is only redundant and can be removed.

Acked-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_ccw.c  |    3 +--
 drivers/s390/scsi/zfcp_def.h  |    1 -
 drivers/s390/scsi/zfcp_erp.c  |    2 --
 drivers/s390/scsi/zfcp_scsi.c |    4 +---
 4 files changed, 2 insertions(+), 8 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2009-03-01 16:41:01.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2009-03-01 16:41:30.000000000 +0100
@@ -72,8 +72,7 @@ static void zfcp_ccw_remove(struct ccw_d
 
 	list_for_each_entry_safe(port, p, &port_remove_lh, list) {
 		list_for_each_entry_safe(unit, u, &unit_remove_lh, list) {
-			if (atomic_read(&unit->status) &
-			    ZFCP_STATUS_UNIT_REGISTERED)
+			if (unit->device)
 				scsi_remove_device(unit->device);
 			zfcp_unit_dequeue(unit);
 		}
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2009-03-01 16:41:30.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2009-03-01 16:41:30.000000000 +0100
@@ -255,7 +255,6 @@ enum zfcp_wka_status {
 /* logical unit status */
 #define ZFCP_STATUS_UNIT_SHARED			0x00000004
 #define ZFCP_STATUS_UNIT_READONLY		0x00000008
-#define ZFCP_STATUS_UNIT_REGISTERED		0x00000010
 #define ZFCP_STATUS_UNIT_SCSI_WORK_PENDING	0x00000020
 
 /* FSF request status (this does not have a common part) */
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2009-03-01 16:41:30.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2009-03-01 16:41:30.000000000 +0100
@@ -1250,8 +1250,6 @@ static void zfcp_erp_action_cleanup(stru
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
 		if ((result == ZFCP_ERP_SUCCEEDED) &&
 		    !unit->device && port->rport) {
-			atomic_set_mask(ZFCP_STATUS_UNIT_REGISTERED,
-					&unit->status);
 			if (!(atomic_read(&unit->status) &
 			      ZFCP_STATUS_UNIT_SCSI_WORK_PENDING))
 				zfcp_erp_schedule_work(unit);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2009-03-01 16:41:01.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2009-03-01 16:41:30.000000000 +0100
@@ -27,7 +27,6 @@ char *zfcp_get_fcp_sns_info_ptr(struct f
 static void zfcp_scsi_slave_destroy(struct scsi_device *sdpnt)
 {
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;
-	atomic_clear_mask(ZFCP_STATUS_UNIT_REGISTERED, &unit->status);
 	unit->device = NULL;
 	zfcp_erp_unit_failed(unit, 12, NULL);
 	zfcp_unit_put(unit);
@@ -133,8 +132,7 @@ static int zfcp_scsi_slave_alloc(struct 
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	unit = zfcp_unit_lookup(adapter, sdp->channel, sdp->id, sdp->lun);
-	if (unit &&
-	    (atomic_read(&unit->status) & ZFCP_STATUS_UNIT_REGISTERED)) {
+	if (unit) {
 		sdp->hostdata = unit;
 		unit->device = sdp;
 		zfcp_unit_get(unit);

