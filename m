From: Christoph Hellwig <hch@lst.de>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
        iscsi_tcp_segment_done+0x20d/0x2e0
Date: Fri, 23 Dec 2016 11:00:14 +0100
Message-ID: <20161223100014.GA29467@lst.de>
References: <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org> <20161221221638.GD4758@dastard> <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com> <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org> <20161222051322.GF4758@dastard> <CA+55aFza=cv6TGYh+Be1xz2x-G-U=vruhbmfGpHSqY1ocZrBeg@mail.gmail.com> <20161222065012.GI4758@dastard> <20161222185030.so4btkuzzkih3owz@straylight.hirudinean.org> <CACVXFVOGoh+AEGSSMsbxfdAjZQS5k_t+7uR-+qwusm0vfauHEA@mail.gmail.com> <20161223000356.dxwkgsei32w7hc4f@straylight.hirudinean.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59049 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757890AbcLWKAS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Dec 2016 05:00:18 -0500
Content-Disposition: inline
In-Reply-To: <20161223000356.dxwkgsei32w7hc4f@straylight.hirudinean.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <cleech@redhat.com>, Ming Lei <tom.leiming@gmail.com>, Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, axboe@fb.com, mst@redhat.com

On Thu, Dec 22, 2016 at 04:03:56PM -0800, Chris Leech wrote:
> Of course, looks like I've screwed up my bisect run on this so I'm still
> taking a look.  It triggers for me with 'hdparm -B /dev/vda' but may
> also depend on kernel configuration.
> 
> I started with the fedora rawhide config with a lot of debug on and
> trimed it down with a localmodconfig run in the VM to speed up rebuilds.

I think the configuration dependency is CONFIG_HAVE_ARCH_VMAP_STACK,
I've just reproduce the issue with it, and the backtrace points to
__virtblk_add_req when setting up the sense buffer.   And it turns out
that blk_execute_rq tries to do I/O to the on-stack sense buffer.
At least SCSI always has a kmalloced sense buffer, so I guess we'll
need something similar for virtio_blk for now.  For 4.11 I plan to
rework how BLOCK_PC commands work entirely, so hopefull we can make
the sense buffer handling a lot less wasteful.

---
>From 0a77bc424ed907c1e99b4756bb498370b498183a Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Fri, 23 Dec 2016 10:57:06 +0100
Subject: virtio_blk: avoid DMA to stack for the sense buffer

Most users of BLOCK_PC requests allocate the sense buffer on the stack,
so to avoid DMA to the stack copy them to a field in the heap allocated
virtblk_req structure.  Without that any attempt at SCSI passthrough I/O,
including the SG_IO ioctl from userspace will crash the kernel.  Note that
this includes running tools like hdparm even when the host does not have
SCSI passthrough enabled.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/virtio_blk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 5545a67..3c3b8f6 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -56,6 +56,7 @@ struct virtblk_req {
 	struct virtio_blk_outhdr out_hdr;
 	struct virtio_scsi_inhdr in_hdr;
 	u8 status;
+	u8 sense[SCSI_SENSE_BUFFERSIZE];
 	struct scatterlist sg[];
 };
 
@@ -102,7 +103,8 @@ static int __virtblk_add_req(struct virtqueue *vq,
 	}
 
 	if (type == cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_SCSI_CMD)) {
-		sg_init_one(&sense, vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
+		memcpy(vbr->sense, vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
+		sg_init_one(&sense, vbr->sense, SCSI_SENSE_BUFFERSIZE);
 		sgs[num_out + num_in++] = &sense;
 		sg_init_one(&inhdr, &vbr->in_hdr, sizeof(vbr->in_hdr));
 		sgs[num_out + num_in++] = &inhdr;
-- 
2.1.4

