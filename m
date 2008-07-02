From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 03/11] zfcp: Adapter reopen for large number of unsolicited status
Date: Wed, 02 Jul 2008 10:56:33 +0200
Message-ID: <20080702085948.334630000@de.ibm.com>
References: <20080702085630.473635000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:40800 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbYGBJAF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2008 05:00:05 -0400
Content-Disposition: inline; filename=zfcp_aux_cleanup_avoid_mini_race.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

When zfcp receives 16 unsolicited status messages, this could trigger
an adapter reopen. In this case, first try to send a new status read,
and only if this fails, go through the recovery.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c |   15 +++++++--------
 drivers/s390/scsi/zfcp_def.h |    3 +--
 2 files changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-06-27 18:06:59.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-06-27 18:07:57.000000000 +0200
@@ -550,15 +550,14 @@ static void zfcp_dummy_release(struct de
 int zfcp_status_read_refill(struct zfcp_adapter *adapter)
 {
 	while (atomic_read(&adapter->stat_miss) > 0)
-		if (zfcp_fsf_status_read(adapter, ZFCP_WAIT_FOR_SBAL))
+		if (zfcp_fsf_status_read(adapter, ZFCP_WAIT_FOR_SBAL)) {
+			if (atomic_read(&adapter->stat_miss) >= 16) {
+				zfcp_erp_adapter_reopen(adapter, 0, 103, NULL);
+				return 1;
+			}
 			break;
-	else
-		atomic_dec(&adapter->stat_miss);
-
-	if (ZFCP_STATUS_READS_RECOM <= atomic_read(&adapter->stat_miss)) {
-		zfcp_erp_adapter_reopen(adapter, 0, 103, NULL);
-		return 1;
-	}
+		} else
+			atomic_dec(&adapter->stat_miss);
 	return 0;
 }
 
--- a/drivers/s390/scsi/zfcp_def.h	2008-06-27 18:06:59.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-06-27 18:07:57.000000000 +0200
@@ -108,7 +108,6 @@ zfcp_address_to_sg(void *address, struct
 #define ZFCP_QTCB_VERSION	FSF_QTCB_CURRENT_VERSION
 /* ATTENTION: value must not be used by hardware */
 #define FSF_QTCB_UNSOLICITED_STATUS		0x6305
-#define ZFCP_STATUS_READS_RECOM		        FSF_STATUS_READS_RECOM
 
 /* Do 1st retry in 1 second, then double the timeout for each following retry */
 #define ZFCP_EXCHANGE_CONFIG_DATA_FIRST_SLEEP	1
@@ -743,7 +742,7 @@ struct zfcp_data {
 #define ZFCP_POOL_FSF_REQ_ERP_NR	1
 #define ZFCP_POOL_FSF_REQ_SCSI_NR	1
 #define ZFCP_POOL_FSF_REQ_ABORT_NR	1
-#define ZFCP_POOL_STATUS_READ_NR	ZFCP_STATUS_READS_RECOM
+#define ZFCP_POOL_STATUS_READ_NR	FSF_STATUS_READS_RECOM
 #define ZFCP_POOL_DATA_GID_PN_NR	1
 
 /* struct used by memory pools for fsf_requests */

-- 
