From: Badari Pulavarty <badari@us.ibm.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Wed, 30 Oct 2002 14:19:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210302219.g9UMJ5w05948@eng2.beaverton.ibm.com>
References: <20021030213619.A183086E82@primary.mx.nitric.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021030213619.A183086E82@primary.mx.nitric.com> from "merlin hughes" at Oct 30, 2002 03:36:19 PM PST
List-Id: linux-scsi@vger.kernel.org
To: merlin hughes <merlin@merlin.org>
Cc: axboe@suse.de, linux-scsi@vger.kernel.org

> >- Badari
> 
> Hi; if it's of any use, the patch doesn't seem to solve the scsi
> problem for me (2.5.44-bk3-badari). I get the usual 'Incorrect number
> of segments...' and random kernel death during the boot process.
> 
> Merlin

Hi Merlin,

I am looking at the output  of your problem ..


Oct 28 12:36:09 badb kernel: Incorrect number of segments after building list 
Oct 28 12:36:09 badb kernel: counted 2, received 1 
Oct 28 12:36:09 badb kernel: req nr_sec 8, cur_nr_sec 8 
Oct 28 12:36:09 badb kernel: end_request: I/O error, dev 08:40, sector 6784528 
Oct 28 12:36:09 badb kernel: raid5: Disk failure on scsi/host0/bus0/target4/lun0/part7, disabling device. Operation continuing on 4 devices 
Oct 28 12:36:09 badb kernel: blk: request botched 

Huh !! Your IO size is only 4K. You are using 2 sg entries ?
I am curious on finding out whats happening here ..

Would you mind adding few printk()s to following routine:

drivers/block/ll_rw_blk.c: blk_rq_map_sg()

Do something like this ...

int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg)
{
        struct bio_vec *bvec, *bvprv;
        struct bio *bio;
        int nsegs, i, cluster;

        nsegs = 0;
        cluster = q->queue_flags & (1 << QUEUE_FLAG_CLUSTER);

        /*
         * for each bio in rq
         */
        bvprv = NULL;
        rq_for_each_bio(bio, rq) {
                /*
                 * for each segment in bio
                 */
                bio_for_each_segment(bvec, bio, i) {
                        int nbytes = bvec->bv_len;

                        if (bvprv && cluster) {
                                if (sg[nsegs - 1].length + nbytes > q->max_segment_size)
                                        goto new_segment;

printk("Loop: brvprv:%x bvec:%x offset:%d len:%d\n", bvprv->bv_page, bvec->bv_page, bvec->bv_offset, bvec->bv_len);
                                if (!BIOVEC_PHYS_MERGEABLE(bvprv, bvec))
                                        goto new_segment;
                                if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bvec))
                                        goto new_segment;

                                sg[nsegs - 1].length += nbytes;
                        } else {
new_segment:
                                memset(&sg[nsegs],0,sizeof(struct scatterlist));
                                sg[nsegs].page = bvec->bv_page;
                                sg[nsegs].length = nbytes;
                                sg[nsegs].offset = bvec->bv_offset;

                                nsegs++;
printk(">>>>> made a new seg:%d (%x, %d, %d)\n", nsegs, bvec->bv_page, nbytes,  bvec->bv_offset);
                        }
                        bvprv = bvec;
                } /* segments in bio */
        } /* bios in rq */

printk(">>>>> returning segs:%d\n", nsegs);
        return nsegs;
}


