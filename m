Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90002C0650F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 09:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C62721874
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 09:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732375AbfHHJhE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 05:37:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37894 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731122AbfHHJhD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Aug 2019 05:37:03 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A7A6530BD1CD;
        Thu,  8 Aug 2019 09:37:03 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-144.ams2.redhat.com [10.36.116.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 640165EE1D;
        Thu,  8 Aug 2019 09:37:03 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 949A917444; Thu,  8 Aug 2019 11:37:02 +0200 (CEST)
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     dri-devel@lists.freedesktop.org
Cc:     tzimmermann@suse.de, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/8] scsi: core: fix the dma_max_mapping_size call
Date:   Thu,  8 Aug 2019 11:36:55 +0200
Message-Id: <20190808093702.29512-2-kraxel@redhat.com>
In-Reply-To: <20190808093702.29512-1-kraxel@redhat.com>
References: <20190808093702.29512-1-kraxel@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 08 Aug 2019 09:37:03 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20190808093655.o5ayQrP6awO4Nez9WF-Ajip3b7FEwn881C-TI6lYfRE@z>

From: Christoph Hellwig <hch@lst.de>

We should only call dma_max_mapping_size for devices that have a DMA mask
set, otherwise we can run into a NULL pointer dereference that will crash
the system.

Also we need to do right shift to get the sectors from the size in bytes,
not a left shift.

Fixes: bdd17bdef7d8 ("scsi: core: take the DMA max mapping size into account")
Reported-by: Bart Van Assche <bvanassche@acm.org>
Reported-by: Ming Lei <tom.leiming@gmail.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
(cherry picked from commit 1b5d9a6e98350e0713b4faa1b04e8f239f63b581)
---
 drivers/scsi/scsi_lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9381171c2fc0..11e64b50497f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1784,8 +1784,10 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 		blk_queue_max_integrity_segments(q, shost->sg_prot_tablesize);
 	}
 
-	shost->max_sectors = min_t(unsigned int, shost->max_sectors,
-			dma_max_mapping_size(dev) << SECTOR_SHIFT);
+	if (dev->dma_mask) {
+		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
+				dma_max_mapping_size(dev) >> SECTOR_SHIFT);
+	}
 	blk_queue_max_hw_sectors(q, shost->max_sectors);
 	if (shost->unchecked_isa_dma)
 		blk_queue_bounce_limit(q, BLK_BOUNCE_ISA);
-- 
2.18.1

