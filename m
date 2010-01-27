From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/8] lpfc 8.3.8: Add code to display logical link speed
Date: Tue, 26 Jan 2010 23:08:29 -0500
Message-ID: <1264565329.2972.3.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:39135 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752621Ab0A0EJK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2010 23:09:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Display Logical Link Speed when supported and is non-zero.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw4.h  |    3 +++
 lpfc_init.c |    2 ++
 lpfc_scsi.c |    7 +++++++
 lpfc_sli4.h |    1 +
 4 files changed, 13 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2010-01-22 12:03:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2010-01-22 21:54:42.000000000 -0500
@@ -1959,6 +1959,9 @@ struct lpfc_acqe_link {
 #define LPFC_ASYNC_LINK_FAULT_NONE	0x0
 #define LPFC_ASYNC_LINK_FAULT_LOCAL	0x1
 #define LPFC_ASYNC_LINK_FAULT_REMOTE	0x2
+#define lpfc_acqe_qos_link_speed_SHIFT	16
+#define lpfc_acqe_qos_link_speed_MASK	0x0000FFFF
+#define lpfc_acqe_qos_link_speed_WORD	word1
 	uint32_t event_tag;
 	uint32_t trailer;
 };
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-01-22 12:03:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-01-22 21:54:42.000000000 -0500
@@ -2978,6 +2978,8 @@ lpfc_sli4_async_link_evt(struct lpfc_hba
 				bf_get(lpfc_acqe_link_physical, acqe_link);
 	phba->sli4_hba.link_state.fault =
 				bf_get(lpfc_acqe_link_fault, acqe_link);
+	phba->sli4_hba.link_state.logical_speed =
+				bf_get(lpfc_acqe_qos_link_speed, acqe_link);
 
 	/* Invoke the lpfc_handle_latt mailbox command callback function */
 	lpfc_mbx_cmpl_read_la(phba, pmb);
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2009-12-08 09:43:11.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-01-22 21:54:42.000000000 -0500
@@ -2695,6 +2695,13 @@ lpfc_info(struct Scsi_Host *host)
 				 " port %s",
 				 phba->Port);
 		}
+		len = strlen(lpfcinfobuf);
+		if (phba->sli4_hba.link_state.logical_speed) {
+			snprintf(lpfcinfobuf + len,
+				 384-len,
+				 " Logical Link Speed: %d Mbps",
+				 phba->sli4_hba.link_state.logical_speed * 10);
+		}
 	}
 	return lpfcinfobuf;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-01-22 12:03:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-01-22 21:54:42.000000000 -0500
@@ -126,6 +126,7 @@ struct lpfc_sli4_link {
 	uint8_t status;
 	uint8_t physical;
 	uint8_t fault;
+	uint16_t logical_speed;
 };
 
 struct lpfc_fcf {


