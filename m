From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2 -mm 0/6] revert the commit 22a9189f (cdrom: use kmalloced buffers instead of buffers on stack)
Date: Mon,  2 Jun 2008 15:57:26 +0900
Message-ID: <1212389852-1277-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46904 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbYFBHlE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2008 03:41:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, petkovbb@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp

This is an updated version of the patchset to revert the commit
22a9189fd073db3d03a4cf8b8c098aa207602de1 (cdrom: use kmalloced buffers
instead of buffers on stack):

http://marc.info/?l=linux-scsi&m=121125981930673&w=2

The major change is that this version avoids DMA on the stack on all
the platforms (for simplicity) while the previous version uses the
dma_pad_mask on a non-coherent platform (in a bit hacky way).

With thic patchset, blk_rq_map_kern() always uses the bounce buffers
if a caller passes a stack buffer.

ide-cd has a mechanism to handle DMA alignment and padding for
SG_IO. This patchset extends the mechanism with regard to a stack
buffer.

This patchset is against -mm, replaces the following patches in -mm:

cdrom-revert-commit-22a9189-cdrom-use-kmalloced-buffers-instead-of-buffers-on-stack.patch
ide-use-the-dma-safe-check-for-req_type_ata_pc.patch 
block-add-blk_queue_update_dma_pad.patch 
block-use-arch_kmalloc_minalign-as-the-default-dma-pad-mask.patch

The diffstat is:

 block/blk-map.c           |    5 +
 block/blk-settings.c      |   24 ++++-
 drivers/ata/libata-scsi.c |    3 +-
 drivers/cdrom/cdrom.c     |  274 +++++++++++++++------------------------------
 drivers/ide/ide-cd.c      |   22 +++-
 drivers/scsi/sr.c         |   20 +---
 include/linux/blkdev.h    |    1 +
 7 files changed, 143 insertions(+), 206 deletions(-)


