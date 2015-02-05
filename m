From: James Smart <james.smart@emulex.com>
Subject: [PATCH 09/21] lpfc: Parse the new 20G, 25G and 40G link speeds in
 the lpfc driver
Date: Thu, 5 Feb 2015 14:24:20 -0500
Message-ID: <1423164260.7917.33.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:47577 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbbBETY3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 14:24:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


---
 drivers/scsi/lpfc/lpfc_hw4.h  |  5 ++++-
 drivers/scsi/lpfc/lpfc_init.c | 39 +++++++++++++++++++++++++++------------
 2 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 3121ec4..0b4c5afd6 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3085,6 +3085,9 @@ struct lpfc_acqe_link {
 #define LPFC_ASYNC_LINK_SPEED_100MBPS		0x2
 #define LPFC_ASYNC_LINK_SPEED_1GBPS		0x3
 #define LPFC_ASYNC_LINK_SPEED_10GBPS		0x4
+#define LPFC_ASYNC_LINK_SPEED_20GBPS		0x5
+#define LPFC_ASYNC_LINK_SPEED_25GBPS		0x6
+#define LPFC_ASYNC_LINK_SPEED_40GBPS		0x7
 #define lpfc_acqe_link_duplex_SHIFT		16
 #define lpfc_acqe_link_duplex_MASK		0x000000FF
 #define lpfc_acqe_link_duplex_WORD		word0
@@ -3166,7 +3169,7 @@ struct lpfc_acqe_fc_la {
 #define lpfc_acqe_fc_la_speed_SHIFT		24
 #define lpfc_acqe_fc_la_speed_MASK		0x000000FF
 #define lpfc_acqe_fc_la_speed_WORD		word0
-#define LPFC_FC_LA_SPEED_UNKOWN		0x0
+#define LPFC_FC_LA_SPEED_UNKNOWN		0x0
 #define LPFC_FC_LA_SPEED_1G		0x1
 #define LPFC_FC_LA_SPEED_2G		0x2
 #define LPFC_FC_LA_SPEED_4G		0x4
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index e01619c..84eb732 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3706,6 +3706,12 @@ lpfc_sli4_parse_latt_link_speed(struct lpfc_hba *phba,
 	case LPFC_ASYNC_LINK_SPEED_10GBPS:
 		link_speed = LPFC_LINK_SPEED_10GHZ;
 		break;
+	case LPFC_ASYNC_LINK_SPEED_20GBPS:
+	case LPFC_ASYNC_LINK_SPEED_25GBPS:
+	case LPFC_ASYNC_LINK_SPEED_40GBPS:
+		/* Waiting for defines in the upstream kernel */
+		link_speed = LPFC_LINK_SPEED_UNKNOWN;
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0483 Invalid link-attention link speed: x%x\n",
@@ -3777,46 +3783,55 @@ lpfc_sli4_port_speed_parse(struct lpfc_hba *phba, uint32_t evt_code,
 	switch (evt_code) {
 	case LPFC_TRAILER_CODE_LINK:
 		switch (speed_code) {
-		case LPFC_EVT_CODE_LINK_NO_LINK:
+		case LPFC_ASYNC_LINK_SPEED_ZERO:
 			port_speed = 0;
 			break;
-		case LPFC_EVT_CODE_LINK_10_MBIT:
+		case LPFC_ASYNC_LINK_SPEED_10MBPS:
 			port_speed = 10;
 			break;
-		case LPFC_EVT_CODE_LINK_100_MBIT:
+		case LPFC_ASYNC_LINK_SPEED_100MBPS:
 			port_speed = 100;
 			break;
-		case LPFC_EVT_CODE_LINK_1_GBIT:
+		case LPFC_ASYNC_LINK_SPEED_1GBPS:
 			port_speed = 1000;
 			break;
-		case LPFC_EVT_CODE_LINK_10_GBIT:
+		case LPFC_ASYNC_LINK_SPEED_10GBPS:
 			port_speed = 10000;
 			break;
+		case LPFC_ASYNC_LINK_SPEED_20GBPS:
+			port_speed = 20000;
+			break;
+		case LPFC_ASYNC_LINK_SPEED_25GBPS:
+			port_speed = 25000;
+			break;
+		case LPFC_ASYNC_LINK_SPEED_40GBPS:
+			port_speed = 40000;
+			break;
 		default:
 			port_speed = 0;
 		}
 		break;
 	case LPFC_TRAILER_CODE_FC:
 		switch (speed_code) {
-		case LPFC_EVT_CODE_FC_NO_LINK:
+		case LPFC_FC_LA_SPEED_UNKNOWN:
 			port_speed = 0;
 			break;
-		case LPFC_EVT_CODE_FC_1_GBAUD:
+		case LPFC_FC_LA_SPEED_1G:
 			port_speed = 1000;
 			break;
-		case LPFC_EVT_CODE_FC_2_GBAUD:
+		case LPFC_FC_LA_SPEED_2G:
 			port_speed = 2000;
 			break;
-		case LPFC_EVT_CODE_FC_4_GBAUD:
+		case LPFC_FC_LA_SPEED_4G:
 			port_speed = 4000;
 			break;
-		case LPFC_EVT_CODE_FC_8_GBAUD:
+		case LPFC_FC_LA_SPEED_8G:
 			port_speed = 8000;
 			break;
-		case LPFC_EVT_CODE_FC_10_GBAUD:
+		case LPFC_FC_LA_SPEED_10G:
 			port_speed = 10000;
 			break;
-		case LPFC_EVT_CODE_FC_16_GBAUD:
+		case LPFC_FC_LA_SPEED_16G:
 			port_speed = 16000;
 			break;
 		default:
-- 
1.7.11.7

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>



