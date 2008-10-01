From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 13/13] zfcp: fix double dbf id usage
Date: Wed, 01 Oct 2008 12:42:26 +0200
Message-ID: <20081001104806.921481000@de.ibm.com>
References: <20081001104213.585200000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:46540 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYJAKtV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 06:49:21 -0400
Content-Disposition: inline; filename=zfcp_remove_dupl_dbf_no.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Trace ids 107 and 3 are used twice, fix this to have unique ids for
the erp triggers.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |    2 +-
 drivers/s390/scsi/zfcp_erp.c |    2 +-
 drivers/s390/scsi/zfcp_fsf.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-09-30 13:51:51.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-09-30 13:52:47.000000000 +0200
@@ -572,7 +572,7 @@ static const char *zfcp_rec_dbf_ids[] = 
 	[81]	= "shared read-write unit access unsupported",
 	[82]	= "incoming rscn",
 	[83]	= "incoming wwpn",
-	[84]	= "",
+	[84]	= "wka port handle not valid close port",
 	[85]	= "online",
 	[86]	= "offline",
 	[87]	= "ccw device gone",
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-09-30 13:52:06.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-09-30 13:52:47.000000000 +0200
@@ -1641,7 +1641,7 @@ static void zfcp_fsf_close_wka_port_hand
 
 	if (req->qtcb->header.fsf_status == FSF_PORT_HANDLE_NOT_VALID) {
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		zfcp_erp_adapter_reopen(wka_port->adapter, 0, 107, req);
+		zfcp_erp_adapter_reopen(wka_port->adapter, 0, 84, req);
 	}
 
 	wka_port->status = ZFCP_WKA_PORT_OFFLINE;
--- a/drivers/s390/scsi/zfcp_erp.c	2008-09-30 13:52:38.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-09-30 13:52:47.000000000 +0200
@@ -1443,7 +1443,7 @@ void zfcp_erp_thread_kill(struct zfcp_ad
 {
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL, &adapter->status);
 	up(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread_lock(2, adapter);
+	zfcp_rec_dbf_event_thread_lock(3, adapter);
 
 	wait_event(adapter->erp_thread_wqh,
 		   !(atomic_read(&adapter->status) &

-- 
