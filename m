From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 1/6] qla2xxx: Fix shost use-after-free on device removal
Date: Wed, 18 Jun 2014 10:02:14 -0400
Message-ID: <1403100139-1798-2-git-send-email-joe.lawrence@stratus.com>
References: <1403100139-1798-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:34586 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaFRODC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jun 2014 10:03:02 -0400
In-Reply-To: <1403100139-1798-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Bill Kuzeja <william.kuzeja@stratus.com>, Dave Bulkow <david.bulkow@stratus.com>, Joe Lawrence <joe.lawrence@stratus.com>

Once calling scsi_host_put, be careful to not access qla_hw_data through
the Scsi_Host private data (ie, scsi_qla_host base_vha).

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5a430c7..6a512b7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3111,10 +3111,8 @@ qla2x00_unmap_iobases(struct qla_hw_data *ha)
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
@@ -3185,7 +3183,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	scsi_host_put(base_vha->host);
 
-	qla2x00_clear_drv_active(base_vha);
+	qla2x00_clear_drv_active(ha);
 
 	qla2x00_unmap_iobases(ha);
 
-- 
1.7.10.4

