Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368F0C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 13:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05C86206F1
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 13:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgE2Ni7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 09:38:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:59242 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgE2Ni7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 May 2020 09:38:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A0DCBAF16;
        Fri, 29 May 2020 13:38:57 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_scan: handle REPORT LUN overflow
Date:   Fri, 29 May 2020 15:38:55 +0200
Message-Id: <20200529133855.146357-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Devices might report a really large REPORT LUN buffer, which will
cause kmalloc to bail if it can't allocate enough continuguous pages.
However, at that time we already have received a perfectly good
response, so we should continue using that buffer to allow us to
register at least the LUNs from the 'good' response.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 82a00d7751b3..0a344653487d 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1290,7 +1290,8 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
-	int ret = 0;
+	int ret = 0, alloc_flags =
+		shost->unchecked_isa_dma ? __GFP_DMA : 0;
 
 	/*
 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
@@ -1327,14 +1328,13 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	 * value of the now removed max_report_luns parameter.
 	 */
 	length = (511 + 1) * sizeof(struct scsi_lun);
-retry:
-	lun_data = kmalloc(length, GFP_KERNEL |
-			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
+	lun_data = kmalloc(length, GFP_KERNEL | alloc_flags);
 	if (!lun_data) {
 		printk(ALLOC_FAILURE_MSG, __func__);
 		goto out;
 	}
 
+retry:
 	scsi_cmd[0] = REPORT_LUNS;
 
 	/*
@@ -1395,12 +1395,21 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	 */
 	if (get_unaligned_be32(lun_data->scsi_lun) +
 	    sizeof(struct scsi_lun) > length) {
-		length = get_unaligned_be32(lun_data->scsi_lun) +
+		unsigned int resp_length;
+		void *resp_data;
+
+		resp_length = get_unaligned_be32(lun_data->scsi_lun) +
 			 sizeof(struct scsi_lun);
-		kfree(lun_data);
-		goto retry;
-	}
-	length = get_unaligned_be32(lun_data->scsi_lun);
+		resp_data = kmalloc(resp_length, GFP_KERNEL | alloc_flags);
+		if (resp_data) {
+			kfree(lun_data);
+			lun_data = resp_data;
+			length = resp_length;
+			goto retry;
+		}
+		printk(ALLOC_FAILURE_MSG, __func__);
+	} else
+		length = get_unaligned_be32(lun_data->scsi_lun);
 
 	num_luns = (length / sizeof(struct scsi_lun));
 
-- 
2.16.4

