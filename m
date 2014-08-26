From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH RESEND 1/6] qla2xxx: Fix shost use-after-free on device removal
Date: Tue, 26 Aug 2014 17:10:41 -0400
Message-ID: <1409087441-18702-1-git-send-email-joe.lawrence@stratus.com>
References: <1409087303-18479-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o142.mxlogic.net ([208.65.145.75]:35510 "EHLO
	p02c12o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaHZVLd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Aug 2014 17:11:33 -0400
In-Reply-To: <1409087303-18479-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Bill Kuzeja <william.kuzeja@stratus.com>, Dave Bulkow <david.bulkow@stratus.com>, Joe Lawrence <joe.lawrence@stratus.com>

Once calling scsi_host_put, be careful to not access qla_hw_data through
the Scsi_Host private data (ie, scsi_qla_host base_vha).

Fixes: fe1b806f4f71 ("qla2xxx: Refactor shutdown code so some functionality can be reused")                                                                     
Cc: stable@vger.kernel.org # 3.14, 3.15, 3.16
Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index be9698d..8252c0e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3119,10 +3119,8 @@ qla2x00_unmap_iobases(struct qla_hw_data *ha)
 }
 
 static void
-qla2x00_clear_drv_active(scsi_qla_host_t *vha)
+qla2x00_clear_drv_active(struct qla_hw_data *ha)
 {
-	struct qla_hw_data *ha = vha->hw;
-
 	if (IS_QLA8044(ha)) {
 		qla8044_idc_lock(ha);
 		qla8044_clear_drv_active(ha);
@@ -3193,7 +3191,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	scsi_host_put(base_vha->host);
 
-	qla2x00_clear_drv_active(base_vha);
+	qla2x00_clear_drv_active(ha);
 
 	qla2x00_unmap_iobases(ha);
 
-- 
1.7.10.4

