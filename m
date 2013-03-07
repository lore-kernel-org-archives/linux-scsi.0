From: Rob Evers <revers@redhat.com>
Subject: [PATCH V3 3/4] Change kmallocs in report_luns to use GFP_KERNEL
Date: Thu,  7 Mar 2013 08:38:34 -0500
Message-ID: <1362663515-3476-4-git-send-email-revers@redhat.com>
References: <1362663515-3476-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932956Ab3CGNis (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 08:38:48 -0500
In-Reply-To: <1362663515-3476-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: revers@redhat.com, michaelc@cs.wisc.edu, bvanassche@acm.org, emilne@redhat.com

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

