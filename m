From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 09/21] lpfc: Correct FCOE discovery to avoid loss of
 storage devices after system reboot
Date: Wed, 06 Jul 2016 12:36:02 -0700
Message-ID: <577d5da2.z0GKKgjcgUhFJ0Im%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38566 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbcGFTgI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:08 -0400
Received: by mail-wm0-f45.google.com with SMTP id r201so5684559wme.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:07 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id bh7sm3814538wjb.22.2016.07.06.12.36.04
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct FCOE discovery to avoid loss of storage devices after system reboot

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index bb514d2..8d940ed 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4484,7 +4484,8 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
 		 * the corresponding FCF bit in the roundrobin bitmap.
 		 */
 		spin_lock_irq(&phba->hbalock);
-		if (phba->fcf.fcf_flag & FCF_DISCOVERY) {
+		if ((phba->fcf.fcf_flag & FCF_DISCOVERY) &&
+		    (phba->fcf.current_rec.fcf_indx != acqe_fip->index)) {
 			spin_unlock_irq(&phba->hbalock);
 			/* Update FLOGI FCF failover eligible FCF bmask */
 			lpfc_sli4_fcf_rr_index_clear(phba, acqe_fip->index);
-- 
2.5.0

