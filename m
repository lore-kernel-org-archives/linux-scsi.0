From: Rob Evers <revers@redhat.com>
Subject: [PATCH V6 1/3] scsi: Avoid unnecessary GFP_ATOMIC allocation in scsi_report_lun_scan
Date: Tue, 16 Dec 2014 11:01:18 -0500
Message-ID: <1418745680-18126-2-git-send-email-revers@redhat.com>
References: <1418745680-18126-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaLPQBW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2014 11:01:22 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBGG1MeQ007609
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2014 11:01:22 -0500
Received: from localhost ([10.18.25.106])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sBGG1L6X006043
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2014 11:01:21 -0500
In-Reply-To: <1418745680-18126-1-git-send-email-revers@redhat.com>
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

