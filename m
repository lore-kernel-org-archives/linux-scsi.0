From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [patch 3/4] zfcp: fix link down handling during firmware update
Date: Thu, 1 Dec 2005 02:48:41 +0100
Message-ID: <20051201014841.GA13077@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:25852 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751623AbVLABtz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 20:49:55 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id jB11nx5C142534
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 01:49:59 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jB11nr9Z178840
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 02:49:53 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id jB11nrM0008923
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 02:49:53 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Maxim Shchetynin <maxim@de.ibm.com>

From: Maxim Shchetynin <maxim@de.ibm.com>

[patch 3/4] zfcp: fix link down handling during firmware update

Don't check link down payload in case of firmware update.

Signed-off-by: Maxim Shchetynin <maxim@de.ibm.com>
Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -Nurp linux-2.6.15-rc3/drivers/s390/scsi/zfcp_fsf.c linux-2.6.x/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6.15-rc3/drivers/s390/scsi/zfcp_fsf.c	2005-12-01 01:17:15.000000000 +0100
+++ linux-2.6.x/drivers/s390/scsi/zfcp_fsf.c	2005-12-01 01:17:53.000000000 +0100
@@ -554,6 +554,17 @@ static void
 zfcp_fsf_link_down_info_eval(struct zfcp_adapter *adapter,
 			     struct fsf_link_down_info *link_down)
 {
+	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
+	                     &adapter->status))
+		return;
+
+	atomic_set_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED, &adapter->status);
+
+	if (link_down == NULL) {
+		zfcp_erp_adapter_reopen(adapter, 0);
+		return;
+	}
+
 	switch (link_down->error_code) {
 	case FSF_PSQ_LINK_NO_LIGHT:
 		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
@@ -634,20 +645,15 @@ zfcp_fsf_link_down_info_eval(struct zfcp
 				link_down->explanation_code,
 				link_down->vendor_specific_code);
 
-	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
-			      &adapter->status)) {
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
-				&adapter->status);
-		switch (link_down->error_code) {
-		case FSF_PSQ_LINK_NO_LIGHT:
-		case FSF_PSQ_LINK_WRAP_PLUG:
-		case FSF_PSQ_LINK_NO_FCP:
-		case FSF_PSQ_LINK_FIRMWARE_UPDATE:
-			zfcp_erp_adapter_reopen(adapter, 0);
-			break;
-		default:
-			zfcp_erp_adapter_failed(adapter);
-		}
+	switch (link_down->error_code) {
+	case FSF_PSQ_LINK_NO_LIGHT:
+	case FSF_PSQ_LINK_WRAP_PLUG:
+	case FSF_PSQ_LINK_NO_FCP:
+	case FSF_PSQ_LINK_FIRMWARE_UPDATE:
+		zfcp_erp_adapter_reopen(adapter, 0);
+		break;
+	default:
+		zfcp_erp_adapter_failed(adapter);
 	}
 }
 
@@ -919,30 +925,36 @@ zfcp_fsf_status_read_handler(struct zfcp
 		case FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK:
 			ZFCP_LOG_INFO("Physical link to adapter %s is down\n",
 				      zfcp_get_busid_by_adapter(adapter));
+			zfcp_fsf_link_down_info_eval(adapter,
+				(struct fsf_link_down_info *)
+				&status_buffer->payload);
 			break;
 		case FSF_STATUS_READ_SUB_FDISC_FAILED:
 			ZFCP_LOG_INFO("Local link to adapter %s is down "
 				      "due to failed FDISC login\n",
-			      zfcp_get_busid_by_adapter(adapter));
+				      zfcp_get_busid_by_adapter(adapter));
+			zfcp_fsf_link_down_info_eval(adapter,
+				(struct fsf_link_down_info *)
+				&status_buffer->payload);
 			break;
 		case FSF_STATUS_READ_SUB_FIRMWARE_UPDATE:
 			ZFCP_LOG_INFO("Local link to adapter %s is down "
 				      "due to firmware update on adapter\n",
 				      zfcp_get_busid_by_adapter(adapter));
+			zfcp_fsf_link_down_info_eval(adapter, NULL);
 			break;
 		default:
 			ZFCP_LOG_INFO("Local link to adapter %s is down "
 				      "due to unknown reason\n",
 				      zfcp_get_busid_by_adapter(adapter));
+			zfcp_fsf_link_down_info_eval(adapter, NULL);
 		};
-		zfcp_fsf_link_down_info_eval(adapter,
-			(struct fsf_link_down_info *) &status_buffer->payload);
 		break;
 
 	case FSF_STATUS_READ_LINK_UP:
 		ZFCP_LOG_NORMAL("Local link to adapter %s was replugged. "
-			      "Restarting operations on this adapter\n",
-			      zfcp_get_busid_by_adapter(adapter));
+				"Restarting operations on this adapter\n",
+				zfcp_get_busid_by_adapter(adapter));
 		/* All ports should be marked as ready to run again */
 		zfcp_erp_modify_adapter_status(adapter,
 					       ZFCP_STATUS_COMMON_RUNNING,
