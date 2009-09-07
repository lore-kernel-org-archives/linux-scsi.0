From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mptsas: fix dma alignment
Date: Mon, 7 Sep 2009 16:42:54 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C8EAE0A19@inbmail01.lsi.com>
References: <20090902010331.37889a2c@vitb-lp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og116.obsmtp.com ([64.18.2.219]:37443 "EHLO
	exprod7og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbZIGLNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2009 07:13:00 -0400
In-Reply-To: <20090902010331.37889a2c@vitb-lp>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vitaly Bordug <vitb@kernel.crashing.org>, "Moore, Eric" <Eric.Moore@lsi.com>
Cc: DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Can you send an exact link for "465ff.. commit"?

Thanks,
Kashyap

-----Original Message-----
From: Vitaly Bordug [mailto:vitb@kernel.crashing.org] 
Sent: Wednesday, September 02, 2009 2:34 AM
To: Moore, Eric
Cc: DL-MPT Fusion Linux; linux-scsi@vger.kernel.org
Subject: [PATCH] mptsas: fix dma alignment


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
