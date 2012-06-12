From: James Smart <james.smart@emulex.com>
Subject: [PATCH 09/10] lpfc 8.3.32: Fix error reporting of misconfigured
 ports
Date: Tue, 12 Jun 2012 13:55:07 -0400
Message-ID: <1339523708.2162.9.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:17711 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753626Ab2FLRzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2012 13:55:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix bug with driver does not report misconfigured ports


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw4.h  |   23 ++++++++++++++++++
 lpfc_init.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 93 insertions(+), 6 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2012-06-08 11:55:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2012-06-08 11:55:49.000000000 -0400
@@ -3106,6 +3106,28 @@ struct lpfc_acqe_fc_la {
 #define LPFC_FC_LA_EVENT_TYPE_SHARED_LINK	0x2
 };
 
+struct lpfc_acqe_misconfigured_event {
+	struct {
+	uint32_t word0;
+#define lpfc_sli_misconfigured_port0_SHIFT	0
+#define lpfc_sli_misconfigured_port0_MASK	0x000000FF
+#define lpfc_sli_misconfigured_port0_WORD	word0
+#define lpfc_sli_misconfigured_port1_SHIFT	8
+#define lpfc_sli_misconfigured_port1_MASK	0x000000FF
+#define lpfc_sli_misconfigured_port1_WORD	word0
+#define lpfc_sli_misconfigured_port2_SHIFT	16
+#define lpfc_sli_misconfigured_port2_MASK	0x000000FF
+#define lpfc_sli_misconfigured_port2_WORD	word0
+#define lpfc_sli_misconfigured_port3_SHIFT	24
+#define lpfc_sli_misconfigured_port3_MASK	0x000000FF
+#define lpfc_sli_misconfigured_port3_WORD	word0
+	} theEvent;
+#define LPFC_SLI_EVENT_STATUS_VALID			0x00
+#define LPFC_SLI_EVENT_STATUS_NOT_PRESENT	0x01
+#define LPFC_SLI_EVENT_STATUS_WRONG_TYPE	0x02
+#define LPFC_SLI_EVENT_STATUS_UNSUPPORTED	0x03
+};
+
 struct lpfc_acqe_sli {
 	uint32_t event_data1;
 	uint32_t event_data2;
@@ -3116,6 +3138,7 @@ struct lpfc_acqe_sli {
 #define LPFC_SLI_EVENT_TYPE_NORM_TEMP		0x3
 #define LPFC_SLI_EVENT_TYPE_NVLOG_POST		0x4
 #define LPFC_SLI_EVENT_TYPE_DIAG_DUMP		0x5
+#define LPFC_SLI_EVENT_TYPE_MISCONFIGURED	0x9
 };
 
 /*
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-06-08 11:55:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-06-08 11:55:49.000000000 -0400
@@ -3726,12 +3726,76 @@ out_free_pmb:
 static void
 lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 {
-	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-			"2901 Async SLI event - Event Data1:x%08x Event Data2:"
-			"x%08x SLI Event Type:%d",
-			acqe_sli->event_data1, acqe_sli->event_data2,
-			bf_get(lpfc_trailer_type, acqe_sli));
-	return;
+	char port_name;
+	char message[80];
+	uint8_t status;
+	struct lpfc_acqe_misconfigured_event *misconfigured;
+
+	/* special case misconfigured event as it contains data for all ports */
+	if ((bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+		 LPFC_SLI_INTF_IF_TYPE_2) ||
+		(bf_get(lpfc_trailer_type, acqe_sli) !=
+			LPFC_SLI_EVENT_TYPE_MISCONFIGURED)) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+				"2901 Async SLI event - Event Data1:x%08x Event Data2:"
+				"x%08x SLI Event Type:%d\n",
+				acqe_sli->event_data1, acqe_sli->event_data2,
+				bf_get(lpfc_trailer_type, acqe_sli));
+		return;
+	}
+
+	port_name = phba->Port[0];
+	if (port_name == 0x00)
+		port_name = '?'; /* get port name is empty */
+
+	misconfigured = (struct lpfc_acqe_misconfigured_event *)
+					&acqe_sli->event_data1;
+
+	/* fetch the status for this port */
+	switch (phba->sli4_hba.lnk_info.lnk_no) {
+	case LPFC_LINK_NUMBER_0:
+		status = bf_get(lpfc_sli_misconfigured_port0,
+					&misconfigured->theEvent);
+		break;
+	case LPFC_LINK_NUMBER_1:
+		status = bf_get(lpfc_sli_misconfigured_port1,
+					&misconfigured->theEvent);
+		break;
+	case LPFC_LINK_NUMBER_2:
+		status = bf_get(lpfc_sli_misconfigured_port2,
+					&misconfigured->theEvent);
+		break;
+	case LPFC_LINK_NUMBER_3:
+		status = bf_get(lpfc_sli_misconfigured_port3,
+					&misconfigured->theEvent);
+		break;
+	default:
+		status = ~LPFC_SLI_EVENT_STATUS_VALID;
+		break;
+	}
+
+	switch (status) {
+	case LPFC_SLI_EVENT_STATUS_VALID:
+		return; /* no message if the sfp is okay */
+	case LPFC_SLI_EVENT_STATUS_NOT_PRESENT:
+		sprintf(message, "Not installed");
+		break;
+	case LPFC_SLI_EVENT_STATUS_WRONG_TYPE:
+		sprintf(message,
+			"Optics of two types installed");
+		break;
+	case LPFC_SLI_EVENT_STATUS_UNSUPPORTED:
+		sprintf(message, "Incompatible optics");
+		break;
+	default:
+		/* firmware is reporting a status we don't know about */
+		sprintf(message, "Unknown event status x%02x", status);
+		break;
+	}
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+			"3176 Misconfigured Physical Port - "
+			"Port Name %c %s\n", port_name, message);
 }
 
 /**



