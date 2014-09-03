From: James Smart <james.smart@emulex.com>
Subject: [PATCH 8/19] lpfc 10.4.8000.0: random32: do not feed jiffies as
 seed from lpfc driver
Date: Wed, 3 Sep 2014 12:56:20 -0400
Message-ID: <1409763380.12357.8.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:47633 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbaICQ4Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 12:56:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Incorporating prior patch:
 http://marc.info/?l=linux-scsi&m=140688548016998&w=2

  Daniel Borkmann <dborkman@redhat.com>
  [PATCH] random32: do not feed jiffies as seed from lpfc driver

  In prandom we have already reseeding mechanisms that trigger
  periodically from a much better entropy source than just
  feeding in jiffies through lpfc_mbx_cmpl_fcf_scan_read_fcf_rec()
  [what a function name 8-)]. Therefore, just remove this.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Reviewed-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 667d124..859fffa 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2147,7 +2147,6 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	uint16_t fcf_index, next_fcf_index;
 	struct lpfc_fcf_rec *fcf_rec = NULL;
 	uint16_t vlan_id;
-	uint32_t seed;
 	bool select_new_fcf;
 	int rc;
 
@@ -2384,9 +2383,6 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		phba->fcf.fcf_flag |= FCF_AVAILABLE;
 		/* Setup initial running random FCF selection count */
 		phba->fcf.eligible_fcf_cnt = 1;
-		/* Seeding the random number generator for random selection */
-		seed = (uint32_t)(0xFFFFFFFF & jiffies);
-		prandom_seed(seed);
 	}
 	spin_unlock_irq(&phba->hbalock);
 	goto read_next_fcf;
-- 
1.7.11.7




