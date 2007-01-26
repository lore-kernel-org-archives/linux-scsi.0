From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [patch] scsi: use lock per host instead of per device for shared queue tag host
Date: Thu, 25 Jan 2007 17:15:45 -0800
Message-ID: <B70A50D07063384EB9BCE3330D18414F02F5B011@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:3735 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030553AbXAZBOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jan 2007 20:14:43 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Somayajulu <david.somayajulu@qlogic.com>, Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, Promise_Linux <Promise_Linux@promise.com>



> -----Original Message-----
> From: Jens Axboe [mailto:jens.axboe@oracle.com] 
> Sent: Thursday, January 25, 2007 7:48 AM
> To: Ed Lin
> Cc: David Somayajulu; Michael Reed; linux-scsi; linux-kernel; 
> james.Bottomley; jeff; Promise_Linux
> Subject: Re: [patch] scsi: use lock per host instead of per 
> device for shared queue tag host
> 
> 
> On Thu, Jan 25 2007, Jens Axboe wrote:
> > On Wed, Jan 24 2007, Ed Lin wrote:
> > > 
> > > 
> > > > -----Original Message-----
> > > > From: David Somayajulu [mailto:david.somayajulu@qlogic.com] 
> > > > Sent: Wednesday, January 24, 2007 5:03 PM
> > > > To: Ed Lin; Michael Reed
> > > > Cc: linux-scsi; linux-kernel; james.Bottomley; jeff; 
> > > > Promise_Linux; Jens Axboe
> > > > Subject: RE: [patch] scsi: use lock per host instead of per 
> > > > device for shared queue tag host
> > > > 
> > > > 
> > > > > It seems another driver(qla4xxx) is also using shared 
> queue tag.
> > > > > It is natural to imagine there might be same symptom in that
> > > > > driver. But I don't know the driver and have no hardware so I
> > > > > can not say anything certain about it.
> > > > 
> > > > qla4xxx implements slightly differently, in the sense we 
> > > > don't have the
> > > > equivalent of         
> > > > struct st_ccb ccb[MU_MAX_REQUEST]; 
> > > > which is in struct st_hba. In other words we don't have 
> a local array
> > > > which like stex to keep track of the outstanding 
> commands to the hba.
> > > > 
> > > > We had a discussion on this one while implementing 
> block-layer tagging
> > > > in qla4xxx and Jens Axboe added the test_and_set_bit() in the 
> > > > following
> > > > code in blk_queue_start_tag() to take care of it.
> > > > 	do {
> > > > 		tag = find_first_zero_bit(bqt->tag_map, 
> bqt->max_depth);
> > > > 		if (tag >= bqt->max_depth)
> > > > 			return 1;
> > > > 	} while (test_and_set_bit(tag, bqt->tag_map));
> > > > Please see the following link for the discussion
> > > > http://marc.theaimsgroup.com/?l=linux-scsi&m=115886351206726&w=2
> > > > 
> > > > Cheers
> > > > David Somayajulu
> > > > QLogic Corporation
> > > >
> > > 
> > > Yes, this piece of code of allocating tag, in itself, is safe.
> > > But the following
> > > 
> > > 	if (unlikely(!__test_and_clear_bit(tag, bqt->tag_map))) {
> > > 		printk(KERN_ERR "%s: attempt to clear non-busy tag
> > > (%d)\n",
> > > 		       __FUNCTION__, tag);
> > > 		return;
> > > 	}
> > > 
> > > code of freeing tag (in blk_queue_end_tag())seems to be using
> > > unsafe __test_and_clear_bit instead of test_and_clear_bit.
> > > I once changed it to test_and_clear_bit and thought it was fixed.
> > > But the panic happened thereafter nonetheless(using gcc 3.4.6.
> > > gcc 4.1.0 is better but still with kernel errors). bqt also needs
> > > to be protected in this case. Replacing queue lock per device with
> > > a host lock is a simple but logical fix for it. To introduce a
> > > more refined lock is possible, but seems too tedious and elaborate
> > > for this issue, since a queue lock is already out there, and a
> > > hostwide lock is needed anyway.
> > 
> > Does this fix it? There really should be no need to add 
> extra locking
> > for this, it would be a shame.
> > 
> > diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
> > index fb67897..e752e5d 100644
> > --- a/block/ll_rw_blk.c
> > +++ b/block/ll_rw_blk.c
> > @@ -1072,12 +1072,16 @@ void 
> blk_queue_end_tag(request_queue_t *q, struct request *rq)
> >  		 */
> >  		return;
> >  
> > -	if (unlikely(!__test_and_clear_bit(tag, bqt->tag_map))) {
> > +	smp_mb__before_clear_bit();
> > +
> > +	if (unlikely(!test_and_clear_bit(tag, bqt->tag_map))) {
> >  		printk(KERN_ERR "%s: attempt to clear non-busy 
> tag (%d)\n",
> >  		       __FUNCTION__, tag);
> >  		return;
> >  	}
> >  
> > +	smp_mb__after_clear_bit();
> > +
> >  	list_del_init(&rq->queuelist);
> >  	rq->cmd_flags &= ~REQ_QUEUED;
> >  	rq->tag = -1;
> > 
> 
> Double checking the actual implementation, the smp_mb__* should not be
> needed with the test_and_*_bit operations. The __test_and_clear_bit()
> change is needed, though. What kind of crash did you see when you did
> that? It should not crash, but you could see the "attempt to clear
> non-busy tag" error though.

Besides the test_and_clear_bit, I think the bqt code(refer to last mail)
also needs protection, like:

	list_del_init(&rq->queuelist);
	...
	if (unlikely(bqt->tag_index[tag] == NULL))
		printk(KERN_ERR "%s: tag %d is missing\n",
		       __FUNCTION__, tag);

	bqt->tag_index[tag] = NULL;
	bqt->busy--;

and

	bqt->tag_index[tag] = rq;
	...
	list_add(&rq->queuelist, &bqt->busy_list);
	bqt->busy++;

because bqt is also globally shared within all devices in the host in
this case. (q->queue_tags was assigned as host->bqt in scsi_activate_tcq
)

With a gcc 4.1.0 compiled kernel, I did not get kernel panic, but
still got kernel errors: "tag  is missing". I guess a possible race
scenario could be:

cpu a:__test_and_clear_bit
cpu b:test_and_set_bit, allocate a tag just freed by cpu a
cpu b:bqt->tag_index[tag] = rq; 
cpu a:bqt->tag_index[tag] = NULL;

Next time, when the request returns,  
	if (unlikely(bqt->tag_index[tag] == NULL))
		printk(KERN_ERR "%s: tag %d is missing\n",
		       __FUNCTION__, tag);
prints out "tag  is missing".

There may possibly be some other errors. So we need a lock here.
I think the simple but reliable way to do it is just to replace
queue lock with a host lock. James pointed out that there may be
performance slow down when many devices are accessed at the
same time. But I think the major part is still on the hardware,
and a host lock is the price these kind of controllers must pay.

To your question:
but you could see the "attempt to clear non-busy tag" error though

Yes I did see it. And then I see the BUG() at blk_queue_start_tag()

	if (unlikely((rq->cmd_flags & REQ_QUEUED))) {
		printk(KERN_ERR 
		       "%s: request %p for device [%s] already tagged
%d",
		       __FUNCTION__, rq,
		       rq->rq_disk ? rq->rq_disk->disk_name : "?",
rq->tag);
		BUG();
	}

Because after "attempt to clear non-busy tag" error REQ_QUEUED flag
is not cleared.

Thanks,

Ed Lin
