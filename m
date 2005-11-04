From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC] yet more struct scsi_lun
Date: Thu, 03 Nov 2005 20:23:28 -0600
Message-ID: <436AC620.20505@cs.wisc.edu>
References: <20051023043301.GA22615@havoc.gtf.org> <20051023070011.GA26569@havoc.gtf.org> <435B6A62.8070306@torque.net> <435BBD9A.80603@pobox.com> <20051024075934.GK2811@suse.de> <43625EC3.9060708@cs.wisc.edu> <20051031102451.GR19267@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47078 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1161107AbVKDCYK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2005 21:24:10 -0500
In-Reply-To: <20051031102451.GR19267@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, dougg@torque.net, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> 
> On the SCSI side, I would suggest just making shost->max_sectors set
> q->max_hw_sectors and leave q->max_sectors to some generic kernel-wide
> block layer define (of course making sure that ->max_sectors <=

If the value for this block layer define was around 16,000 sectors, 
would that be ok? The reason I ask is becuase when I get .....


> ->max_hw_sectors). That's the easy part.
> 
> The bio_add_page() stuff is a little trickier, since it wants to know if
> this is fs or 'generic' io. For fs io, we would like to cap the building
> of the bio to ->max_sectors, but for eg SG_IO issued io it should go as
> high as ->max_hw_sectors. Perhaps the easiest is just to have
> bio_fs_add_page() and bio_pc_add_page(), each just passing in the max
> value as an integer to bio_add_page(). But it's not exactly pretty.
> 
> The ll_rw_blk.c merging is easy, since you don't need to do anything
> there. It should test against ->max_sectors as it already does, since
> this (sadly) is still the primary way we build large ios.
> 

.... here, I am running into a problem. Basically, as you know the 
largest BIO we can make is 1 MB due to BIO_MAX_PAGES, and for st and sg 
we need to support commands around 6 MB, so we would have a request with 
  6 BIOs. To make this monster request I wanted to use the block layer 
functions and do something like this:

+       for (i = 0; i < nsegs; i++) {
+               bio = bio_map_pages(q, sg[i].page, sg[i].length, 
sg[i].offset, gfp);
+               if (IS_ERR(bio)) {
+                       err = PTR_ERR(bio);
+                       goto free_bios;
+               }
+               len += sg[i].length;
+
+               bio->bi_flags &= ~(1 << BIO_SEG_VALID);
+               if (rq_data_dir(rq) == WRITE)
+                       bio->bi_rw |= (1 << BIO_RW);
+               blk_queue_bounce(q, &bio);
+
+               if (i == 0)
+                       blk_rq_bio_prep(q, rq, bio);

/* hope to carve out the __make_request code that does the below 
operations and make a fucntion that can be shared */

+               else if (!q->back_merge_fn(q, rq, bio)) {
+                       err = -EINVAL;
+                       bio_endio(bio, bio->bi_size, 0);
+                       goto free_bios;
+               } else {
+                       rq->biotail->bi_next = bio;
+                       rq->biotail = bio;
+                       rq->hard_nr_sectors += bio_sectors(bio);
+                       rq->nr_sectors = rq->hard_nr_sectors;

........

But since q->back_merge_fn() tests against q->max_sectors, it must be a 
high value so that we can merge in those BIOs. I mean if q->max_sectors 
is some reasonable number like only 1024 sectors, q->back_merge_fn will 
return a failure. Should I instead seperate ll_back_merge_fn into two 
functions, one that checks the sectors and one that checks the segments 
or if ll_back_merge_fn tested for max_hw_sectors we would be ok too?
