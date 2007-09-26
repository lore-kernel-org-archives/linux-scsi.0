From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 1/5] add dma_max_segment_size option to
 scsi_host_template
Date: Wed, 26 Sep 2007 23:34:51 +0900
Message-ID: <20070925200037W.tomof@acm.org>
References: <20070925142144Z.tomof@acm.org>
	<46FA3061.9060408@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47099 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbXIZOfh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 10:35:37 -0400
In-Reply-To: <46FA3061.9060408@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: tomof@acm.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, hch@infradead.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, 26 Sep 2007 06:11:45 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> FUJITA Tomonori wrote:
> > This patch moves blk_queue_max_segment_size to scsi_alloc_queue from
> > llds. It enables scsi_add_host to tells iommu lld's
> > dma_max_segment_size. If a low-level driver doesn't specify
> > dma_max_segment_size, scsi-ml uses 65536 (MAX_SEGMENT_SIZE). So there
> > are not any functional changes.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  drivers/scsi/hosts.c     |    5 +++++
> >  drivers/scsi/scsi_lib.c  |    1 +
> >  include/scsi/scsi_host.h |    6 ++++++
> >  3 files changed, 12 insertions(+), 0 deletions(-)
> 
> hmmmmm...  All the patches look technically correct, but IMO this really 
> should behave more the the dma_mask interface:  platform sets a sane 
> dma_mask (usually 0xffffffff), and LLDD calls dma_set_mask() or 
> pci_set_dma_mask().
>
> Thus, IMO an LLDD should call dma_set_max_seg(), and then SCSI midlayer 
> can obtain that value from struct device.

Yeah, I agreed that max_segment_size should work like dma_mask (that's
why I simply put max_segment_size to device structure).

scsi_debug doesn't use dma but calls blk_queue_max_segment_size (I
guess that it wants large I/Os). If we can remove it (thanks to
chaining sg), scsi-ml gets that value that llds set via
dma_set_max_seg and calls blk_queue_max_segment_size.
