From: Jens Axboe <axboe@suse.de>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Thu, 31 Oct 2002 14:18:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031131824.GA6549@suse.de>
References: <200210302219.g9UMJ5w05948@eng2.beaverton.ibm.com> <20021031021718.8A55F866E5@primary.mx.nitric.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021031021718.8A55F866E5@primary.mx.nitric.com>
List-Id: linux-scsi@vger.kernel.org
To: merlin <merlin@merlin.org>
Cc: Badari Pulavarty <badari@us.ibm.com>, linux-scsi@vger.kernel.org

On Wed, Oct 30 2002, merlin wrote:
> r/badari@us.ibm.com/2002.10.30/14:19:05
> >> >- Badari
> >> 
> >> Hi; if it's of any use, the patch doesn't seem to solve the scsi
> >> problem for me (2.5.44-bk3-badari). I get the usual 'Incorrect number
> >> of segments...' and random kernel death during the boot process.
> >> 
> >> Merlin
> >
> >Hi Merlin,
> >
> >I am looking at the output  of your problem ..
> >
> >
> >Oct 28 12:36:09 badb kernel: Incorrect number of segments after building list 
> >Oct 28 12:36:09 badb kernel: counted 2, received 1 
> >Oct 28 12:36:09 badb kernel: req nr_sec 8, cur_nr_sec 8 
> >Oct 28 12:36:09 badb kernel: end_request: I/O error, dev 08:40, sector 6784528
> > 
> >Oct 28 12:36:09 badb kernel: raid5: Disk failure on scsi/host0/bus0/target4/lu
> >n0/part7, disabling device. Operation continuing on 4 devices 
> >Oct 28 12:36:09 badb kernel: blk: request botched 
> >
> >Huh !! Your IO size is only 4K. You are using 2 sg entries ?
> >I am curious on finding out whats happening here ..
> >
> >Would you mind adding few printk()s to following routine:
> >
> >drivers/block/ll_rw_blk.c: blk_rq_map_sg()
> >
> >Do something like this ...
> 
> Hi Badari,
> 
> I grabbed 2.5.45 and added the printks you describe.. The kernel
> dies before the syslog is written and I don't have a serial device
> to try capturing the output there, but this is what I scribbled
> down:
> 
>   ...lots of stuff ...
>   home: clean
>   made a new seg: 1 (c18adc70, 4096, 0)
>   Loop: brvprv: c18adc70 bvec:c18ad838 offset:0 length:4096
>   made a new seg: 2 (c18ad838, 4096, 0)
>   returning segs: 2
>   Incorrect number of segments after building list
>   counted 2, received 1
>   ...some stuff...
> 
> Things went on for a few more messages before the kernel died
> a death.
> 
> It's an SMP box so the seg stuff that precedes the error may
> be unrelated; I don't have a good enough grasp to be sure. I
> guess an interesting value to know might be max_segment_size.
> 
> Half tempted to try a non-SMP build, just to see. Each time I
> do this, I get a bit more (recoverable) fs damage, but still..

SMP should not make a difference. Does this patch make a difference?

===== drivers/block/ll_rw_blk.c 1.135 vs edited =====
--- 1.135/drivers/block/ll_rw_blk.c	Mon Oct 28 20:57:59 2002
+++ edited/drivers/block/ll_rw_blk.c	Thu Oct 31 14:17:09 2002
@@ -694,31 +694,23 @@
 	seg_size = nr_phys_segs = nr_hw_segs = 0;
 	bio_for_each_segment(bv, bio, i) {
 		if (bvprv && cluster) {
-			int phys, seg;
-
-			if (seg_size + bv->bv_len > q->max_segment_size) {
-				nr_phys_segs++;
+			if (seg_size + bv->bv_len > q->max_segment_size)
 				goto new_segment;
-			}
 
-			phys = BIOVEC_PHYS_MERGEABLE(bvprv, bv);
-			seg = BIOVEC_SEG_BOUNDARY(q, bvprv, bv);
-			if (!phys || !seg)
-				nr_phys_segs++;
-			if (!seg)
+			if (!BIOVEC_PHYS_MERGEABLE(bvprv, bv))
 				goto new_segment;
-
-			if (!BIOVEC_VIRT_MERGEABLE(bvprv, bv))
+			if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bv))
 				goto new_segment;
 
 			seg_size += bv->bv_len;
 			bvprv = bv;
 			continue;
-		} else {
-			nr_phys_segs++;
 		}
 new_segment:
-		nr_hw_segs++;
+		if (!bvprv || !BIOVEC_VIRT_MERGEABLE(bvprv, bv))
+			nr_hw_segs++;
+
+		nr_phys_segs++;
 		bvprv = bv;
 		seg_size = bv->bv_len;
 	}

-- 
Jens Axboe

