From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/5] convert sg to use the block layer
Date: Tue, 26 Aug 2008 11:10:49 +0900
Message-ID: <1219716654-27827-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46415 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbYHZCNK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 22:13:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp

This patchset converts sg to use the block layer functions. That is,
sg doesn't use scsi_execute_async() any more. This is a part of the
overdue task to remove scsi_req_map_sg.

I tested this patchset with sg v3 and the old interface (struct
sg_header) via SG_IO (v3) and the vfs API.


Doug,

1. I don't demote the sg driver's GFP_ATOMIC to GFP_KERNEL. sg always
uses GFP_ATOMIC as before.

2. I don't remove GFP_DMA allocation. As before, sg allocates reserved
pages with GFP_DMA (sfp->low_dma case).

3. I keep the reserved buffer per struct sg_fd as before.

4. I use high-order page allocation for reserved buffer as before. sg
works well with HBAs that have the limitation of the number of sg
entries.

5. I think that you were concern about the overhead of the block layer
functions. But if you look at scsi_execute_async() that sg uses now,
you can find that scsi_execute_async() uses the block layer functions
internally. So the current sg incurs the overhead (if such overhead
exists).


Jens,

I keep the block API changes to a minimum (I might need more changes
for st/osst but I'd like to progress step by step). I did only two
things.

1. I add gfp_mask argument to blk_rq_map_user and blk_rq_map_user_iov.

2. I introduces struct rq_map_data holding pages. sg puts
pre-allocated pages to it and passes it to bio_copy_user_iov(). The
current users of bio_copy_user_iov simply passes NULL. blk_rq_map_user
and blk_rq_map_user_iov take a pointer to struct rq_map_data and in
the end bio_copy_user_iov gets it.


This patchset against the for-linus branch in Jens' tree + the two
patches for 2.6.27:

http://marc.info/?l=linux-kernel&m=121964251911717&w=2
http://marc.info/?l=linux-kernel&m=121964241911611&w=2

After Jens rebases the for-2.6.28 brach, I'll update this patchset
too.

This patchset also is available at:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git sg-block



