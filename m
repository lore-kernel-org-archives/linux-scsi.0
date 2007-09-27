From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 1/5] add dma_max_segment_size option to
 scsi_host_template
Date: Thu, 27 Sep 2007 09:37:13 +0900
Message-ID: <20070926023531I.tomof@acm.org>
References: <46FA3061.9060408@garzik.org>
	<20070925200037W.tomof@acm.org>
	<46FA6FBE.2060100@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:59843 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbXI0AiS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 20:38:18 -0400
In-Reply-To: <46FA6FBE.2060100@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: tomof@acm.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, hch@infradead.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, 26 Sep 2007 10:42:06 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> FUJITA Tomonori wrote:
> > On Wed, 26 Sep 2007 06:11:45 -0400
> > Jeff Garzik <jeff@garzik.org> wrote:
> > 
> >> FUJITA Tomonori wrote:
> >>> This patch moves blk_queue_max_segment_size to scsi_alloc_queue from
> >>> llds. It enables scsi_add_host to tells iommu lld's
> >>> dma_max_segment_size. If a low-level driver doesn't specify
> >>> dma_max_segment_size, scsi-ml uses 65536 (MAX_SEGMENT_SIZE). So there
> >>> are not any functional changes.
> >>>
> >>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >>> ---
> >>>  drivers/scsi/hosts.c     |    5 +++++
> >>>  drivers/scsi/scsi_lib.c  |    1 +
> >>>  include/scsi/scsi_host.h |    6 ++++++
> >>>  3 files changed, 12 insertions(+), 0 deletions(-)
> >> hmmmmm...  All the patches look technically correct, but IMO this really 
> >> should behave more the the dma_mask interface:  platform sets a sane 
> >> dma_mask (usually 0xffffffff), and LLDD calls dma_set_mask() or 
> >> pci_set_dma_mask().
> >>
> >> Thus, IMO an LLDD should call dma_set_max_seg(), and then SCSI midlayer 
> >> can obtain that value from struct device.
> > 
> > Yeah, I agreed that max_segment_size should work like dma_mask (that's
> > why I simply put max_segment_size to device structure).
> 
> Yep!
> 
> 
> > scsi_debug doesn't use dma but calls blk_queue_max_segment_size (I
> > guess that it wants large I/Os). If we can remove it (thanks to
> > chaining sg), scsi-ml gets that value that llds set via
> > dma_set_max_seg and calls blk_queue_max_segment_size.
> 
> [/me checks the code]  Actually scsi_debug has its own pseudo-bus and 
> struct device, so it sounds like scsi_debug can call dma_set_max_seg() 
> just like any other LLDD?

You are right. scsi_debug's pseudo-bus works.

But probabaly, scsi_debug doesn't need to call
blk_queue_max_segment_size now.


> Maybe dev_set_max_seg() is a better name, if people get really picky (I 
> don't care).

How about dma_set_max_seg_size()?


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a417a6f..7adadfb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1554,6 +1554,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 					 request_fn_proc *request_fn)
 {
 	struct request_queue *q;
+	struct device *dev = shost->shost_gendev.parent;
 
 	q = blk_init_queue(request_fn, NULL);
 	if (!q)
@@ -1565,6 +1566,9 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 
+	if (dev->max_segment_size)
+		blk_queue_max_segment_size(q, dev->max_segment_size);
+
 	if (!shost->use_clustering)
 		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 	return q;
diff --git a/include/linux/device.h b/include/linux/device.h
index 3a38d1f..8046b60 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -443,6 +443,13 @@ struct device {
 
 	struct dma_coherent_mem	*dma_mem; /* internal for coherent mem
 					     override */
+
+	/*
+	 * a low level driver may set these to teach IOMMU code about
+	 * sg limitations.
+	 */
+	unsigned int max_segment_size;
+
 	/* arch specific additions */
 	struct dev_archdata	archdata;
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 2dc21cb..30404b8 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -31,6 +31,11 @@ static inline int valid_dma_direction(int dma_direction)
 		(dma_direction == DMA_FROM_DEVICE));
 }
 
+static inline void dma_set_max_seg_size(struct device *dev, unsigned int size)
+{
+	dev->max_segment_size = size;
+}
+
 #ifdef CONFIG_HAS_DMA
 #include <asm/dma-mapping.h>
 #else
