From: Rob Evers <revers@redhat.com>
Subject: [PATCH V5 1/3] scsi: Avoid unnecessary GFP_ATOMIC allocation in scsi_report_lun_scan
Date: Fri,  5 Dec 2014 14:37:41 -0500
Message-ID: <1417808263-5632-2-git-send-email-revers@redhat.com>
References: <1417808263-5632-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbaLEThp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2014 14:37:45 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sB5Jbi6d002924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2014 14:37:44 -0500
Received: from localhost ([10.18.25.106])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sB5Jbift005506
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2014 14:37:44 -0500
In-Reply-To: <1417808263-5632-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/scsi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ba3f1e8..e460b35 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1408,7 +1408,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	 * prevent us from finding any LUNs on this target.
 	 */
 	length = (max_scsi_report_luns + 1) * sizeof(struct scsi_lun);
-	lun_data = kmalloc(length, GFP_ATOMIC |
+	lun_data = kmalloc(length, GFP_KERNEL |
 			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
 	if (!lun_data) {
 		printk(ALLOC_FAILURE_MSG, __func__);
-- 
1.8.3.1

