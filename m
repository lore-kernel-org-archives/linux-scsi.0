From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 0/5] fix iommu sg list merge problem
Date: Wed, 26 Sep 2007 17:57:57 +0900
Message-ID: <20070925142141N.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50170 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494AbXIZI7A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 04:59:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp

iommu code merges sg lists without considering lld's restrictions so
some llds need a workaround to split sg lists again. This patchset
fixes iommu to handle lld's max segment size limit properly.

The problem is that iommu code can't access to the restrictions
because they are in request_queue. iommu code can access to only
device structure. I chose the simplest approach, adding
max_segment_size to device structure.

We could remove the lld restrictions in request_queue strucutre and
have a new strucutre (something like struct io_restrictions). Then
somehow we could link the new structure with request_queue and device
strucutres. But iommu needs only max_segment_size and
seg_boundary_mask, so the simplest approach is not so bad, I think.

scsi_add_host sets shost_gendev.parent->max_segment_size for iommu
code (copied form shost->dma_max_segment_size).

This patchset includes only the x86_64 iommu patch but my git tree
includes x86_64, ppc, ia64, parisc, and alpha patches. As far as I
know, thye are all the iommu code that merges sg lists. The iommu
patchse are only compile tested.

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git iommu


3 llds, aacraid, scsi_debug, and sata_inic162x sets
shost->dma_max_segment_size in slave_configure hook. But
dma_max_segment_size is a lld restriction. I adds dma_max_segment_size
to scsi_host_template and scsi_host. llds specify dma_max_segment_size
in scsi_host_template, scsi-ml sets dma_max_segment_size in devices
and call blk_queue_max_segment_size. This patchset includes only the
sata_inic162x patch but all the patches for llds, aacraid and
scsi_debug are in the git tree.
