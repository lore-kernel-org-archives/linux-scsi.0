From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/19] lpfc 10.4.8000.0: Use time_after()
Date: Wed, 3 Sep 2014 12:55:58 -0400
Message-ID: <1409763358.12357.6.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:47626 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413AbaICQ4M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 12:56:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Incorporating prior patch:
 http://marc.info/?l=3Dlinux-scsi&m=3D140053378307936&w=3D2

  manuel.schoelling@gmx.de
  [PATCH] lpfc: Use time_after()

  To be future-proof and for better readability the time comparisons
  are modified to use time_after() instead of plain, error-prone math.

Signed-off-by: Manuel Sch=C3=B6lling <manuel.schoelling@gmx.de>
Reviewed-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scs=
i.c
index 3c250e3..6094545 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -380,12 +380,14 @@ lpfc_rampdown_queue_depth(struct lpfc_hba *phba)
 {
 	unsigned long flags;
 	uint32_t evt_posted;
+	unsigned long expires;
=20
 	spin_lock_irqsave(&phba->hbalock, flags);
 	atomic_inc(&phba->num_rsrc_err);
 	phba->last_rsrc_error_time =3D jiffies;
=20
-	if ((phba->last_ramp_down_time + QUEUE_RAMP_DOWN_INTERVAL) > jiffies)=
 {
+	expires =3D phba->last_ramp_down_time + QUEUE_RAMP_DOWN_INTERVAL;
+	if (time_after(expires, jiffies)) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return;
 	}
--=20
1.7.11.7




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
