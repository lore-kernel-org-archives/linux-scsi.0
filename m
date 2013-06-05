From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 09/10] qla2xxx: Remove an unused variable from qla2x00_remove_one()
Date: Wed, 05 Jun 2013 15:09:01 +0200
Message-ID: <51AF386D.8080706@acm.org>
References: <51AF36BF.3030602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:34589 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab3FENJC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 09:09:02 -0400
In-Reply-To: <51AF36BF.3030602@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1d97626..2176cc9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2980,14 +2980,12 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	set_bit(UNLOADING, &base_vha->dpc_flags);
 	mutex_lock(&ha->vport_lock);
 	while (ha->cur_vport_count) {
-		struct Scsi_Host *scsi_host;
-
 		spin_lock_irqsave(&ha->vport_slock, flags);
 
 		BUG_ON(base_vha->list.next == &ha->vp_list);
 		/* This assumes first entry in ha->vp_list is always base vha */
 		vha = list_first_entry(&base_vha->list, scsi_qla_host_t, list);
-		scsi_host = scsi_host_get(vha->host);
+		scsi_host_get(vha->host);
 
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 		mutex_unlock(&ha->vport_lock);
-- 
1.7.10.4

