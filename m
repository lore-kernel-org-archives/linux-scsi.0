From: Geoff Levand <geoffrey.levand@am.sony.com>
Subject: PS3: sg chaining support
Date: Tue, 17 Jul 2007 14:18:28 -0700
Message-ID: <469D3224.50608@am.sony.com>
References: <Pine.LNX.4.62.0707171806100.29326@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:7184 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754745AbXGQVSj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 17:18:39 -0400
In-Reply-To: <Pine.LNX.4.62.0707171806100.29326@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, linux-scsi@vger.kernel.org

Hi Jens.

Geert Uytterhoeven wrote:
> ---------- Forwarded message ----------
> Date: Mon, 16 Jul 2007 11:47:26 +0200
> From: Jens Axboe <jens.axboe@oracle.com>
> To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
> Cc: Jens Axboe <jens.axboe@oracle.com>, paulus@samba.org
> Subject: [PATCH 12/33] PPC: sg chaining support
> 
> This updates the ppc iommu/pci dma mappers to sg chaining.
> 
> Cc: paulus@samba.org
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  arch/powerpc/kernel/dma_64.c            |    5 +++--
>  arch/powerpc/kernel/ibmebus.c           |   11 ++++++-----
>  arch/powerpc/kernel/iommu.c             |   18 +++++++++++-------
>  arch/powerpc/platforms/ps3/system-bus.c |    5 +++--
>  include/asm-powerpc/dma-mapping.h       |    2 +-
>  include/asm-powerpc/scatterlist.h       |    2 ++
>  6 files changed, 26 insertions(+), 17 deletions(-)

I'm wondering what the status of this work is.  The patch I've
seen no longer applies to ps3/system-bus.c.  A rebase to
linux-2.6.git a5fcaa210626a79465321e344c91a6a7dc3881fa is below,
but untested, as I don't have the other patches to do the build.

-Geoff


Subject: PS3: sg chaining support

This updates the ps3 system bus dma mappers to sg chaining.

CC: Jens Axboe <jens.axboe@oracle.com>
From: Geoff Levand <geoffrey.levand@am.sony.com>

---
 arch/powerpc/platforms/ps3/system-bus.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -622,17 +622,18 @@ static void ps3_unmap_single(struct devi
 	}
 }
 
-static int ps3_sb_map_sg(struct device *_dev, struct scatterlist *sg, int nents,
-	enum dma_data_direction direction)
+static int ps3_sb_map_sg(struct device *_dev, struct scatterlist *sgl,
+	int nents, enum dma_data_direction direction)
 {
 #if defined(CONFIG_PS3_DYNAMIC_DMA)
 	BUG_ON("do");
 	return -EPERM;
 #else
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
+	struct scatterlist *sg;
 	int i;
 
-	for (i = 0; i < nents; i++, sg++) {
+	for_each_sg(sgl, sg, nents, i) {
 		int result = ps3_dma_map(dev->d_region,
 			page_to_phys(sg->page) + sg->offset, sg->length,
 					 &sg->dma_address, 0);
@@ -650,7 +651,7 @@ static int ps3_sb_map_sg(struct device *
 #endif
 }
 
-static int ps3_ioc0_map_sg(struct device *_dev, struct scatterlist *sg,
+static int ps3_ioc0_map_sg(struct device *_dev, struct scatterlist *sgl,
 			   int nents,
 			   enum dma_data_direction direction)
 {
@@ -658,7 +659,7 @@ static int ps3_ioc0_map_sg(struct device
 	return 0;
 }
 
-static void ps3_sb_unmap_sg(struct device *_dev, struct scatterlist *sg,
+static void ps3_sb_unmap_sg(struct device *_dev, struct scatterlist *sgl,
 	int nents, enum dma_data_direction direction)
 {
 #if defined(CONFIG_PS3_DYNAMIC_DMA)
@@ -666,7 +667,7 @@ static void ps3_sb_unmap_sg(struct devic
 #endif
 }
 
-static void ps3_ioc0_unmap_sg(struct device *_dev, struct scatterlist *sg,
+static void ps3_ioc0_unmap_sg(struct device *_dev, struct scatterlist *sgl,
 			    int nents, enum dma_data_direction direction)
 {
 	BUG();

