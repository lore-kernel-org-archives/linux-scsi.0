From: merlin <merlin@merlin.org>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Thu, 31 Oct 2002 09:41:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031144103.103D286E73@primary.mx.nitric.com>
References: <20021031131824.GA6549@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-reply-to: <20021031131824.GA6549@suse.de> 
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Badari Pulavarty <badari@us.ibm.com>, linux-scsi@vger.kernel.org

r/axboe@suse.de/2002.10.31/14:18:24
>On Wed, Oct 30 2002, merlin wrote:
>> Hi Badari,
>> 
>> I grabbed 2.5.45 and added the printks you describe.. The kernel
>> dies before the syslog is written and I don't have a serial device
>> to try capturing the output there, but this is what I scribbled
>> down:
>> 
>>   ...lots of stuff ...
>>   home: clean
>>   made a new seg: 1 (c18adc70, 4096, 0)
>>   Loop: brvprv: c18adc70 bvec:c18ad838 offset:0 length:4096
>>   made a new seg: 2 (c18ad838, 4096, 0)
>>   returning segs: 2
>>   Incorrect number of segments after building list
>>   counted 2, received 1
>>   ...some stuff...
>> 
>> Things went on for a few more messages before the kernel died
>> a death.
>> 
>> It's an SMP box so the seg stuff that precedes the error may
>> be unrelated; I don't have a good enough grasp to be sure. I
>> guess an interesting value to know might be max_segment_size.
>> 
>> Half tempted to try a non-SMP build, just to see. Each time I
>> do this, I get a bit more (recoverable) fs damage, but still..
>
>SMP should not make a difference. Does this patch make a difference?

Same error I'm afraid; ``Incorrect number of segments after building list
counted 2, received 1'' follows shortly by kernel panic..

Thanks, merlin

>===== drivers/block/ll_rw_blk.c 1.135 vs edited =====
>--- 1.135/drivers/block/ll_rw_blk.c	Mon Oct 28 20:57:59 2002
>+++ edited/drivers/block/ll_rw_blk.c	Thu Oct 31 14:17:09 2002
>@@ -694,31 +694,23 @@
> 	seg_size = nr_phys_segs = nr_hw_segs = 0;
> 	bio_for_each_segment(bv, bio, i) {
> 		if (bvprv && cluster) {
>-			int phys, seg;
>-
>-			if (seg_size + bv->bv_len > q->max_segment_size) {
>-				nr_phys_segs++;
>+			if (seg_size + bv->bv_len > q->max_segment_size)
> 				goto new_segment;
>-			}
> 
>-			phys = BIOVEC_PHYS_MERGEABLE(bvprv, bv);
>-			seg = BIOVEC_SEG_BOUNDARY(q, bvprv, bv);
>-			if (!phys || !seg)
>-				nr_phys_segs++;
>-			if (!seg)
>+			if (!BIOVEC_PHYS_MERGEABLE(bvprv, bv))
> 				goto new_segment;
>-
>-			if (!BIOVEC_VIRT_MERGEABLE(bvprv, bv))
>+			if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bv))
> 				goto new_segment;
> 
> 			seg_size += bv->bv_len;
> 			bvprv = bv;
> 			continue;
>-		} else {
>-			nr_phys_segs++;
> 		}
> new_segment:
>-		nr_hw_segs++;
>+		if (!bvprv || !BIOVEC_VIRT_MERGEABLE(bvprv, bv))
>+			nr_hw_segs++;
>+
>+		nr_phys_segs++;
> 		bvprv = bv;
> 		seg_size = bv->bv_len;
> 	}
>
>-- 
>Jens Axboe
