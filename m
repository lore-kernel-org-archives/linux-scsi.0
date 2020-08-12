Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF77C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 20:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E722E20774
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 20:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHLU4P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 16:56:15 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:26277 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbgHLU4P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Aug 2020 16:56:15 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 12 Aug 2020 13:56:12 -0700
Received: from petr-dev3.eng.vmware.com (petr-dev2.eng.vmware.com [10.20.78.5])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 3273E40097;
        Wed, 12 Aug 2020 13:56:15 -0700 (PDT)
Received: by petr-dev3.eng.vmware.com (Postfix, from userid 1078)
        id 2E025A00680; Wed, 12 Aug 2020 13:56:15 -0700 (PDT)
Date:   Wed, 12 Aug 2020 13:56:15 -0700
From:   Jim Gill <jgill@vmware.com>
To:     <pv-drivers@vmware.com>
CC:     <jgill@vmware.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 3/3 for-next] pvscsi: Fix uninitialized sense buffer with
 swiotlb
Message-ID: <20200812205615.GA18423@petr-dev3.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Received-SPF: None (EX13-EDG-OU-002.vmware.com: jgill@vmware.com does not
 designate permitted sender hosts)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It seems like the device sometimes leaves part of the
 sense buffer uninitialized. This causes massive problems with swiotlb where
 any previous initialization of the sense buffer by the scsi middle-layer is
 not propagated to the device since we use DMA_FROM_DEVICE when dma-mapping
 the sense buffer. Fix this by specifying DMA_BIDIRECTIONAL instead. Makes the
 scsi errors go away.

Tested using a bonnie++ run on an swiotlb=force booted kernel.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
[jgill@vmware.com: Forwarding patch on behalf of thellstrom]
Acked-by: jgill@vmware.com
---
 drivers/scsi/vmw_pvscsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index fa2748f..c179a5d 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -429,7 +429,7 @@ static void pvscsi_unmap_buffers(const struct pvscsi_adapter *adapter,
 	}
 	if (cmd->sense_buffer)
 		dma_unmap_single(&adapter->dev->dev, ctx->sensePA,
-				 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+				 SCSI_SENSE_BUFFERSIZE, DMA_BIDIRECTIONAL);
 }
 
 static int pvscsi_allocate_rings(struct pvscsi_adapter *adapter)
@@ -714,7 +714,7 @@ static int pvscsi_queue_ring(struct pvscsi_adapter *adapter,
 	if (cmd->sense_buffer) {
 		ctx->sensePA = dma_map_single(&adapter->dev->dev,
 				cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
-				DMA_FROM_DEVICE);
+				DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(&adapter->dev->dev, ctx->sensePA)) {
 			scmd_printk(KERN_DEBUG, cmd,
 				    "vmw_pvscsi: Failed to map sense buffer for DMA.\n");
@@ -746,7 +746,7 @@ static int pvscsi_queue_ring(struct pvscsi_adapter *adapter,
 		if (cmd->sense_buffer) {
 			dma_unmap_single(&adapter->dev->dev, ctx->sensePA,
 					 SCSI_SENSE_BUFFERSIZE,
-					 DMA_FROM_DEVICE);
+					 DMA_BIDIRECTIONAL);
 			ctx->sensePA = 0;
 		}
 		return -ENOMEM;
-- 
2.7.4

