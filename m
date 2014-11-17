From: Rob Evers <revers@redhat.com>
Subject: [PATCH V4 2/5] scsi: Fix scsi_report_lun_scan return when kmalloc fails
Date: Mon, 17 Nov 2014 10:22:07 -0500
Message-ID: <1416237730-1862-3-git-send-email-revers@redhat.com>
References: <1416237730-1862-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbaKQPWM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 10:22:12 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAHFMCFa026836
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2014 10:22:12 -0500
Received: from localhost ([10.18.25.106])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sAHFMBCE008013
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2014 10:22:11 -0500
In-Reply-To: <1416237730-1862-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/scsi_scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e460b35..69291bf3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1412,6 +1412,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
 	if (!lun_data) {
 		printk(ALLOC_FAILURE_MSG, __func__);
+		ret = 1;
 		goto out;
 	}
 
-- 
1.8.3.1

