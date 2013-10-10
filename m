From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/8] lpfc 8.3.43: Fixed spinlock inversion problem.
Date: Thu, 10 Oct 2013 12:20:35 -0400
Message-ID: <1381422035.20248.13.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5420 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab3JJQUh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2013 12:20:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed spinlock inversion problem.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-10-09 10:39:20.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-10-09 17:25:28.940650536 -0400
@@ -15098,6 +15098,7 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phb
 	uint16_t max_rpi, rpi_limit;
 	uint16_t rpi_remaining, lrpi = 0;
 	struct lpfc_rpi_hdr *rpi_hdr;
+	unsigned long iflag;
 
 	max_rpi = phba->sli4_hba.max_cfg_param.max_rpi;
 	rpi_limit = phba->sli4_hba.next_rpi;
@@ -15106,7 +15107,7 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phb
 	 * Fetch the next logical rpi.  Because this index is logical,
 	 * the  driver starts at 0 each time.
 	 */
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irqsave(&phba->hbalock, iflag);
 	rpi = find_next_zero_bit(phba->sli4_hba.rpi_bmask, rpi_limit, 0);
 	if (rpi >= rpi_limit)
 		rpi = LPFC_RPI_ALLOC_ERROR;
@@ -15122,7 +15123,7 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phb
 	 */
 	if ((rpi == LPFC_RPI_ALLOC_ERROR) &&
 	    (phba->sli4_hba.rpi_count >= max_rpi)) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		return rpi;
 	}
 
@@ -15131,7 +15132,7 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phb
 	 * extents.
 	 */
 	if (!phba->sli4_hba.rpi_hdrs_in_use) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		return rpi;
 	}
 
@@ -15142,7 +15143,7 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phb
 	 * how many are supported max by the device.
 	 */
 	rpi_remaining = phba->sli4_hba.next_rpi - phba->sli4_hba.rpi_count;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
 	if (rpi_remaining < LPFC_RPI_LOW_WATER_MARK) {
 		rpi_hdr = lpfc_sli4_create_rpi_hdr(phba);
 		if (!rpi_hdr) {



