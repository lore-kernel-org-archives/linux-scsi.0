From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: block: Always check queue limits for cloned requests
Date: Mon, 30 Nov 2015 14:11:41 +0800
Message-ID: <20151130141141.6ce3fadb@tom-T450>
References: <1448524017-130967-1-git-send-email-hare@suse.de>
	<20151126131104.GA24297@redhat.com>
	<20151129114956.GA321@x4>
	<565B1D2A.5010603@suse.de>
	<20151129161532.GA302@x4>
	<20151129164947.GA15021@redhat.com>
	<20151129170506.GB302@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151129170506.GB302@x4>
Sender: linux-kernel-owner@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ewan Milne <emilne@redhat.com>, Jeff Moyer <jmoyer@redhat.com>, Ming Lei <tom.leiming@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 29 Nov 2015 18:05:06 +0100
Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> On 2015.11.29 at 11:49 -0500, Mike Snitzer wrote:
> > On Sun, Nov 29 2015 at 11:15am -0500,
> > Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> > 
> > > On 2015.11.29 at 16:43 +0100, Hannes Reinecke wrote:
> > > > On 11/29/2015 12:49 PM, Markus Trippelsdorf wrote:
> > > > > 
> > > > > I'm still seeing the issue (BUG at drivers/scsi/scsi_lib.c:1096!) even
> > > > > with this patch applied.
> > > > > 
> > > > > markus@x4 linux % git describe
> > > > > v4.4-rc2-215-g081f3698e606
> > > > > 
> > > > Can you generate a crashdump?
> > > > I would need to cross-check with the other dumps I'm having to figure
> > > > out if this really is the same issue.
> > > > There have been other reports (and fixes) which show we're fighting
> > > > several distinct issues here.
> > > 
> > > Unfortunately no. The crash happens on the disk where I store my log
> > > files. And after it happened the magic SysRq keys don't work anymore.
> > > 
> > > The crash only happens on my spinning rust drive that uses the cfq
> > > scheduler. The SSDs (deadline) are fine.
> > > 
> > > The BUG happens reproducibly when building http://www.sagemath.org/ on
> > > that drive.
> > 
> > Are you using DM multipath?  If unsure, please let us know which
> > device(s) map to the "spinning rust drive", and provide output from:
> > lsblk
> 
> No, I'm not using DM multipath. 


OK, I guess it is still one block merge issue, care to test the
following patch?

The patch can address one issue when bio->bi_seg_front_size
is set as too small mistakenly, then fewer physical segment may
be figured out.

---
>From 7aa725205f400ee6823a0d19bf9f41a2464725ce Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@canonical.com>
Date: Mon, 30 Nov 2015 13:10:12 +0800
Subject: [PATCH] blk-merge: fix computing bio->bi_seg_front_size in case of
 single segment

When bio has only one physical segment, we should set bio's
bi_seg_front_size as the real(final) size of the single segment.

Fixes: 02e707424c2ea(blk-merge: fix blk_bio_segment_split)
Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-merge.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 41a55ba..e01405a 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -103,6 +103,9 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 			bvprv = bv;
 			bvprvp = &bvprv;
 			sectors += bv.bv_len >> 9;
+
+			if (nsegs == 1 && seg_size > front_seg_size)
+				front_seg_size = seg_size;
 			continue;
 		}
 new_segment:
-- 
1.9.1
