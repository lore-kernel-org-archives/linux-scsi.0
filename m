From: Vitaly Bordug <vitb@kernel.crashing.org>
Subject: [PATCH] mptsas: fix dma alignment
Date: Wed, 2 Sep 2009 01:03:31 +0400
Message-ID: <20090902010331.37889a2c@vitb-lp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:37876 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZIAVCv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 17:02:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org


From: Yuri Tikhonov <yur@emcraft.com>

fusion mptsas: fix dma alignment

     Since the 465ff.. commit from James Bottomley relaxes the default
     SCSI DMA alignment from 512 bytes to 4 bytes, then, in the mptsas
     driver, we should explicitly set the alignment to the workable
     512 bytes value.

    Signed-off-by: Ilya Yanok <yanok@emcraft.com>
    Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
    Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
    Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
---

 drivers/message/fusion/mptsas.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/message/fusion/mptsas.c
b/drivers/message/fusion/mptsas.c index 55ff252..2334f26 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1843,6 +1843,7 @@ mptsas_slave_alloc(struct scsi_device *sdev)
 	return -ENXIO;
 
  out:
+	blk_queue_update_dma_alignment(sdev->request_queue, 511);
 	vdevice->vtarget->num_luns++;
 	sdev->hostdata = vdevice;
 	return 0;
