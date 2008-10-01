From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 12/13] zfcp: wait on SCSI work to be finished before proceeding with init dev
Date: Wed, 01 Oct 2008 12:42:25 +0200
Message-ID: <20081001104805.918759000@de.ibm.com>
References: <20081001104213.585200000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:54924 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbYJAKso (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 06:48:44 -0400
Content-Disposition: inline; filename=zfcp_wait_on_initial_lun_avail.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Due to the character of a scheduled work we cannot guarantee the
LUN register to be finished before an initial device tries to use it.
Therefor we have to wait for PENDING_SCSI_WORK flag to be cleared
before proceeding.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c |    5 +++++
 drivers/s390/scsi/zfcp_erp.c |    1 +
 2 files changed, 6 insertions(+)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-09-30 13:52:06.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-09-30 13:52:38.000000000 +0200
@@ -129,7 +129,12 @@ static void __init zfcp_init_device_conf
 		goto out_unit;
 	up(&zfcp_data.config_sema);
 	ccw_device_set_online(adapter->ccw_device);
+
 	zfcp_erp_wait(adapter);
+	wait_event(adapter->erp_done_wqh,
+		   !(atomic_read(&unit->status) &
+				ZFCP_STATUS_UNIT_SCSI_WORK_PENDING));
+
 	down(&zfcp_data.config_sema);
 	zfcp_unit_put(unit);
 out_unit:
--- a/drivers/s390/scsi/zfcp_erp.c	2008-09-30 13:52:30.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-09-30 13:52:38.000000000 +0200
@@ -1189,6 +1189,7 @@ static void zfcp_erp_scsi_scan(struct wo
 			 scsilun_to_int((struct scsi_lun *)&unit->fcp_lun), 0);
 	atomic_clear_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
 	zfcp_unit_put(unit);
+	wake_up(&unit->port->adapter->erp_done_wqh);
 	kfree(p);
 }
 

-- 
