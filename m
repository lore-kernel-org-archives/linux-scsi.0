From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] zfcp: handle unsolicited status notification lost
Date: Thu, 5 Jan 2006 09:56:47 +0100
Message-ID: <20060105085647.GA11165@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:49126 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751915AbWAEI4x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jan 2006 03:56:53 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id k058upWs218964
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jan 2006 08:56:51 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k058up7M179168
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jan 2006 09:56:51 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k058upgu007344
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jan 2006 09:56:51 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Maxim Shchetynin <maxim@de.ibm.com>

From: Maxim Shchetynin <maxim@de.ibm.com>

[PATCH] zfcp: handle unsolicited status notification lost

Handle unsolicited adapter status that informs about loss of
previous unsolicited status notification(s).

Signed-off-by: Maxim Shchetynin <maxim@de.ibm.com>
Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

 drivers/s390/scsi/zfcp_fsf.c |   35 +++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_fsf.h |   12 ++++++++++++
 2 files changed, 47 insertions(+), 0 deletions(-)

80c65f35dc67575864cc6aae70508575b61a093d
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 5958795..bf859c9 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -964,6 +964,40 @@ zfcp_fsf_status_read_handler(struct zfcp
 					| ZFCP_STATUS_COMMON_ERP_FAILED);
 		break;
 
+	case FSF_STATUS_READ_NOTIFICATION_LOST:
+		ZFCP_LOG_NORMAL("Unsolicited status notification(s) lost: "
+				"adapter %s%s%s%s%s%s%s%s%s\n",
+				zfcp_get_busid_by_adapter(adapter),
+				(status_buffer->status_subtype &
+					FSF_STATUS_READ_SUB_INCOMING_ELS) ?
+					", incoming ELS" : "",
+				(status_buffer->status_subtype &
+					FSF_STATUS_READ_SUB_SENSE_DATA) ?
+					", sense data" : "",
+				(status_buffer->status_subtype &
+					FSF_STATUS_READ_SUB_LINK_STATUS) ?
+					", link status change" : "",
+				(status_buffer->status_subtype &
+					FSF_STATUS_READ_SUB_PORT_CLOSED) ?
+					", port close" : "",
+				(status_buffer->status_subtype &
+					FSF_STATUS_READ_SUB_BIT_ERROR_THRESHOLD) ?
+					", bit error exception" : "",
+				(status_buffer->status_subtype &
+					FSF_STATUS_READ_SUB_ACT_UPDATED) ?
+					", ACT update" : "",
+				(status_buffer->status_subtype &
+					FSF_STATUS_READ_SUB_ACT_HARDENED) ?
+					", ACT hardening" : "",
+				(status_buffer->status_subtype &
+					FSF_STATUS_READ_SUB_FEATURE_UPDATE_ALERT) ?
+					", adapter feature change" : "");
+
+		if (status_buffer->status_subtype &
+		    FSF_STATUS_READ_SUB_ACT_UPDATED)
+			zfcp_erp_adapter_access_changed(adapter);
+		break;
+
 	case FSF_STATUS_READ_CFDC_UPDATED:
 		ZFCP_LOG_NORMAL("CFDC has been updated on the adapter %s\n",
 			      zfcp_get_busid_by_adapter(adapter));
@@ -1954,6 +1988,7 @@ zfcp_fsf_exchange_config_data(struct zfc
 	erp_action->fsf_req->qtcb->bottom.config.feature_selection =
 			FSF_FEATURE_CFDC |
 			FSF_FEATURE_LUN_SHARING |
+			FSF_FEATURE_NOTIFICATION_LOST |
 			FSF_FEATURE_UPDATE_ALERT;
 
 	/* start QDIO request for this FSF request */
diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index 48719f0..39475db 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -166,6 +166,7 @@
 #define FSF_STATUS_READ_BIT_ERROR_THRESHOLD	0x00000004
 #define FSF_STATUS_READ_LINK_DOWN		0x00000005
 #define FSF_STATUS_READ_LINK_UP          	0x00000006
+#define FSF_STATUS_READ_NOTIFICATION_LOST	0x00000009
 #define FSF_STATUS_READ_CFDC_UPDATED		0x0000000A
 #define FSF_STATUS_READ_CFDC_HARDENED		0x0000000B
 #define FSF_STATUS_READ_FEATURE_UPDATE_ALERT	0x0000000C
@@ -179,6 +180,16 @@
 #define FSF_STATUS_READ_SUB_FDISC_FAILED	0x00000001
 #define FSF_STATUS_READ_SUB_FIRMWARE_UPDATE	0x00000002
 
+/* status subtypes for unsolicited status notification lost */
+#define FSF_STATUS_READ_SUB_INCOMING_ELS	0x00000001
+#define FSF_STATUS_READ_SUB_SENSE_DATA		0x00000002
+#define FSF_STATUS_READ_SUB_LINK_STATUS		0x00000004
+#define FSF_STATUS_READ_SUB_PORT_CLOSED		0x00000008
+#define FSF_STATUS_READ_SUB_BIT_ERROR_THRESHOLD	0x00000010
+#define FSF_STATUS_READ_SUB_ACT_UPDATED		0x00000020
+#define FSF_STATUS_READ_SUB_ACT_HARDENED	0x00000040
+#define FSF_STATUS_READ_SUB_FEATURE_UPDATE_ALERT 0x00000080
+
 /* status subtypes for CFDC */
 #define FSF_STATUS_READ_SUB_CFDC_HARDENED_ON_SE	0x00000002
 #define FSF_STATUS_READ_SUB_CFDC_HARDENED_ON_SE2 0x0000000F
@@ -211,6 +222,7 @@
 /* channel features */
 #define FSF_FEATURE_CFDC			0x00000002
 #define FSF_FEATURE_LUN_SHARING			0x00000004
+#define FSF_FEATURE_NOTIFICATION_LOST		0x00000008
 #define FSF_FEATURE_HBAAPI_MANAGEMENT           0x00000010
 #define FSF_FEATURE_ELS_CT_CHAINED_SBALS        0x00000020
 #define FSF_FEATURE_UPDATE_ALERT		0x00000100
-- 
0.99.9n-g58e3
