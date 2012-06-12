From: James Smart <james.smart@emulex.com>
Subject: [PATCH 04/10] lpfc 8.3.32: Correct host DIF configuration that hung
 system
Date: Tue, 12 Jun 2012 13:54:27 -0400
Message-ID: <1339523667.2162.4.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:17647 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752644Ab2FLRyh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2012 13:54:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix system hang due to bad protection module parameters (CR: 130769)


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-06-08 10:07:44.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-06-08 11:55:38.000000000 -0400
@@ -5514,14 +5514,45 @@ lpfc_destroy_shost(struct lpfc_hba *phba
 static void
 lpfc_setup_bg(struct lpfc_hba *phba, struct Scsi_Host *shost)
 {
+	uint32_t old_mask;
+	uint32_t old_guard;
+
 	int pagecnt = 10;
 	if (lpfc_prot_mask && lpfc_prot_guard) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"1478 Registering BlockGuard with the "
 				"SCSI layer\n");
-		scsi_host_set_prot(shost, lpfc_prot_mask);
-		scsi_host_set_guard(shost, lpfc_prot_guard);
+
+		old_mask = lpfc_prot_mask;
+		old_guard = lpfc_prot_guard;
+
+		/* Only allow supported values */
+		lpfc_prot_mask &= (SHOST_DIF_TYPE1_PROTECTION |
+			SHOST_DIX_TYPE0_PROTECTION |
+			SHOST_DIX_TYPE1_PROTECTION);
+		lpfc_prot_guard &= (SHOST_DIX_GUARD_IP | SHOST_DIX_GUARD_CRC);
+
+		/* DIF Type 1 protection for profiles AST1/C1 is end to end */
+		if (lpfc_prot_mask == SHOST_DIX_TYPE1_PROTECTION)
+			lpfc_prot_mask |= SHOST_DIF_TYPE1_PROTECTION;
+
+		if (lpfc_prot_mask && lpfc_prot_guard) {
+			if ((old_mask != lpfc_prot_mask) ||
+				(old_guard != lpfc_prot_guard))
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"1475 Registering BlockGuard with the "
+					"SCSI layer: mask %d  guard %d\n",
+					lpfc_prot_mask, lpfc_prot_guard);
+
+			scsi_host_set_prot(shost, lpfc_prot_mask);
+			scsi_host_set_guard(shost, lpfc_prot_guard);
+		} else
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1479 Not Registering BlockGuard with the SCSI "
+				"layer, Bad protection parameters: %d %d\n",
+				old_mask, old_guard);
 	}
+
 	if (!_dump_buf_data) {
 		while (pagecnt) {
 			spin_lock_init(&_dump_buf_lock);



