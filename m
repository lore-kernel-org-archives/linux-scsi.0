From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/3] zfcp: Print some messages only during ERP
Date: Thu, 24 Apr 2008 19:35:53 +0200
Message-ID: <20080424174055.560740000@de.ibm.com>
References: <20080424173551.821393000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:31945 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbYDXRk6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 13:40:58 -0400
Content-Disposition: inline; filename=zfcp-stat-message.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

When statistics are polled from sysfs, the statistics use the same
commands as the adapter initialization. Change the messages printed
here, so they are only printed during initialization and not for each
poll of adapter data.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2008-04-24 15:06:34.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-04-24 15:06:38.000000000 +0200
@@ -2036,21 +2036,21 @@ zfcp_fsf_exchange_config_evaluate(struct
 		       min(FC_SERIAL_NUMBER_SIZE, 17));
 	}
 
-	ZFCP_LOG_NORMAL("The adapter %s reported the following "
-			"characteristics:\n"
-			"WWNN 0x%016Lx, "
-			"WWPN 0x%016Lx, "
-			"S_ID 0x%06x,\n"
-			"adapter version 0x%x, "
-			"LIC version 0x%x, "
-			"FC link speed %d Gb/s\n",
-			zfcp_get_busid_by_adapter(adapter),
-			(wwn_t) fc_host_node_name(shost),
-			(wwn_t) fc_host_port_name(shost),
-			fc_host_port_id(shost),
-			adapter->hydra_version,
-			adapter->fsf_lic_version,
-			fc_host_speed(shost));
+	if (fsf_req->erp_action)
+		ZFCP_LOG_NORMAL("The adapter %s reported the following "
+				"characteristics:\n"
+				"WWNN 0x%016Lx, WWPN 0x%016Lx, "
+				"S_ID 0x%06x,\n"
+				"adapter version 0x%x, "
+				"LIC version 0x%x, "
+				"FC link speed %d Gb/s\n",
+				zfcp_get_busid_by_adapter(adapter),
+				(wwn_t) fc_host_node_name(shost),
+				(wwn_t) fc_host_port_name(shost),
+				fc_host_port_id(shost),
+				adapter->hydra_version,
+				adapter->fsf_lic_version,
+				fc_host_speed(shost));
 	if (ZFCP_QTCB_VERSION < bottom->low_qtcb_version) {
 		ZFCP_LOG_NORMAL("error: the adapter %s "
 				"only supports newer control block "
@@ -2115,8 +2115,10 @@ zfcp_fsf_exchange_config_data_handler(st
 			zfcp_erp_adapter_shutdown(adapter, 0, 127, fsf_req);
 			return -EIO;
 		case FC_PORTTYPE_NPORT:
-			ZFCP_LOG_NORMAL("Switched fabric fibrechannel "
-					"network detected at adapter %s.\n",
+			if (fsf_req->erp_action)
+				ZFCP_LOG_NORMAL("Switched fabric fibrechannel "
+						"network detected at adapter "
+						"%s.\n",
 					zfcp_get_busid_by_adapter(adapter));
 			break;
 		default:

-- 
