From: merlin <merlin@merlin.org>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Wed, 30 Oct 2002 21:17:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031021718.8A55F866E5@primary.mx.nitric.com>
References: <200210302219.g9UMJ5w05948@eng2.beaverton.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-reply-to: <200210302219.g9UMJ5w05948@eng2.beaverton.ibm.com> 
List-Id: linux-scsi@vger.kernel.org
To: Badari Pulavarty <badari@us.ibm.com>
Cc: axboe@suse.de, linux-scsi@vger.kernel.org

r/badari@us.ibm.com/2002.10.30/14:19:05
>> >- Badari
>> 
>> Hi; if it's of any use, the patch doesn't seem to solve the scsi
>> problem for me (2.5.44-bk3-badari). I get the usual 'Incorrect number
>> of segments...' and random kernel death during the boot process.
>> 
>> Merlin
>
>Hi Merlin,
>
>I am looking at the output  of your problem ..
>
>
>Oct 28 12:36:09 badb kernel: Incorrect number of segments after building list 
>Oct 28 12:36:09 badb kernel: counted 2, received 1 
>Oct 28 12:36:09 badb kernel: req nr_sec 8, cur_nr_sec 8 
>Oct 28 12:36:09 badb kernel: end_request: I/O error, dev 08:40, sector 6784528
> 
>Oct 28 12:36:09 badb kernel: raid5: Disk failure on scsi/host0/bus0/target4/lu
>n0/part7, disabling device. Operation continuing on 4 devices 
>Oct 28 12:36:09 badb kernel: blk: request botched 
>
>Huh !! Your IO size is only 4K. You are using 2 sg entries ?
>I am curious on finding out whats happening here ..
>
>Would you mind adding few printk()s to following routine:
>
>drivers/block/ll_rw_blk.c: blk_rq_map_sg()
>
>Do something like this ...

Hi Badari,

I grabbed 2.5.45 and added the printks you describe.. The kernel
dies before the syslog is written and I don't have a serial device
to try capturing the output there, but this is what I scribbled
down:

  ...lots of stuff ...
  home: clean
  made a new seg: 1 (c18adc70, 4096, 0)
  Loop: brvprv: c18adc70 bvec:c18ad838 offset:0 length:4096
  made a new seg: 2 (c18ad838, 4096, 0)
  returning segs: 2
  Incorrect number of segments after building list
  counted 2, received 1
  ...some stuff...

Things went on for a few more messages before the kernel died
a death.

It's an SMP box so the seg stuff that precedes the error may
be unrelated; I don't have a good enough grasp to be sure. I
guess an interesting value to know might be max_segment_size.

Half tempted to try a non-SMP build, just to see. Each time I
do this, I get a bit more (recoverable) fs damage, but still..

merlin

>int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *
>sg)
>{
>        struct bio_vec *bvec, *bvprv;
>        struct bio *bio;
>        int nsegs, i, cluster;
>
>        nsegs = 0;
>        cluster = q->queue_flags & (1 << QUEUE_FLAG_CLUSTER);
>
>        /*
>         * for each bio in rq
>         */
>        bvprv = NULL;
>        rq_for_each_bio(bio, rq) {
>                /*
>                 * for each segment in bio
>                 */
>                bio_for_each_segment(bvec, bio, i) {
>                        int nbytes = bvec->bv_len;
>
>                        if (bvprv && cluster) {
>                                if (sg[nsegs - 1].length + nbytes > q->max_seg
>ment_size)
>                                        goto new_segment;
>
>printk("Loop: brvprv:%x bvec:%x offset:%d len:%d\n", bvprv->bv_page, bvec->bv_
>page, bvec->bv_offset, bvec->bv_len);
>                                if (!BIOVEC_PHYS_MERGEABLE(bvprv, bvec))
>                                        goto new_segment;
>                                if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bvec))
>                                        goto new_segment;
>
>                                sg[nsegs - 1].length += nbytes;
>                        } else {
>new_segment:
>                                memset(&sg[nsegs],0,sizeof(struct scatterlist)
>);
>                                sg[nsegs].page = bvec->bv_page;
>                                sg[nsegs].length = nbytes;
>                                sg[nsegs].offset = bvec->bv_offset;
>
>                                nsegs++;
>printk(">>>>> made a new seg:%d (%x, %d, %d)\n", nsegs, bvec->bv_page, nbytes,
>  bvec->bv_offset);
>                        }
>                        bvprv = bvec;
>                } /* segments in bio */
>        } /* bios in rq */
>
>printk(">>>>> returning segs:%d\n", nsegs);
>        return nsegs;
>}
