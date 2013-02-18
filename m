From: Rob Evers <revers@redhat.com>
Subject: [PATCH v2 3/3] Change kmallocs in report_luns to use GFP_KERNEL
Date: Mon, 18 Feb 2013 14:15:52 -0500
Message-ID: <1361214952-28978-4-git-send-email-revers@redhat.com>
References: <1361214952-28978-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631Ab3BRTPz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2013 14:15:55 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1IJFtSC012499
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2013 14:15:55 -0500
Received: from localhost (dhcp-186-142.bos.redhat.com [10.16.186.142])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r1IJFtVx028631
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2013 14:15:55 -0500
In-Reply-To: <1361214952-28978-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/scsi_scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 671ff58..1d41730 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1419,7 +1419,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		length = (max_scsi_report_luns + 1) *
 			sizeof(struct scsi_lun);
 
-	first_lun_data = kmalloc(length, GFP_ATOMIC |
+	first_lun_data = kmalloc(length, GFP_KERNEL |
 				 (sdev->host->unchecked_isa_dma ?
 				 __GFP_DMA : 0));
 	if (!first_lun_data) {
@@ -1463,7 +1463,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		 * add one for the header
 		 */
 		length = length + sizeof(struct scsi_lun);
-		second_lun_data = kmalloc(length, GFP_ATOMIC |
+		second_lun_data = kmalloc(length, GFP_KERNEL |
 					  (sdev->host->unchecked_isa_dma ?
 					  __GFP_DMA : 0));
 		if (!second_lun_data) {
-- 
1.7.11.7

