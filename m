From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 6/9] scsi_dh: add generic SPC-3 alua handler
Date: Tue, 01 Jul 2008 11:46:09 -0700
Message-ID: <1214937969.27507.15.camel@chandra-ubuntu>
References: <20080624100504.7D8C210B5DE@craiglockhart-ipmi.suse.de>
	 <486424BA.8040301@cs.wisc.edu> <4864FA31.9020401@suse.de>
	 <48650C6B.4030404@cs.wisc.edu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38283 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbYGASqQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jul 2008 14:46:16 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m61IkF1m025054
	for <linux-scsi@vger.kernel.org>; Tue, 1 Jul 2008 14:46:15 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m61IkF9J215656
	for <linux-scsi@vger.kernel.org>; Tue, 1 Jul 2008 14:46:15 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m61IkEBI008431
	for <linux-scsi@vger.kernel.org>; Tue, 1 Jul 2008 14:46:15 -0400
In-Reply-To: <48650C6B.4030404@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org


On Fri, 2008-06-27 at 10:51 -0500, Mike Christie wrote:
> Hannes Reinecke wrote:
> > Mike Christie wrote:
> >> Hannes Reinecke wrote:
> >>> +
> >>> +static struct request *get_alua_req(struct scsi_device *sdev,
> >>> +                    void *buffer, unsigned buflen, int rw)
> >>> +{
> >>> +    struct request *rq;
> >>> +    struct request_queue *q = sdev->request_queue;
> >>> +
> >>> +    rq = blk_get_request(q, rw, GFP_KERNEL);
> >>> +
> >>> +    if (!rq) {
> >>> +        sdev_printk(KERN_INFO, sdev,
> >>> +                "%s: blk_get_request failed\n", __FUNCTION__);
> >>> +        return NULL;
> >>> +    }
> >>> +
> >>> +    if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_KERNEL)) {
> >>> +        blk_put_request(rq);
> >>> +        sdev_printk(KERN_INFO, sdev,
> >>> +                "%s: blk_rq_map_kern failed\n", __FUNCTION__);
> >>> +        return NULL;
> >>> +    }
> >>> +
> >>> +    rq->cmd_type = REQ_TYPE_BLOCK_PC;
> >>> +    rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
> >>> +    rq->retries = ALUA_FAILOVER_RETRIES;
> >>> +    rq->timeout = ALUA_FAILOVER_TIMEOUT;
> >>> +
> >>> +    return rq;
> >>> +}
> >>
> >>
> >> It looks like this can be called from alua_activate, and we cannot use 
> >> GFP_KERNEL in the same IO path something could get written to.
> >>
> > Is something like GFP_ATOMIC more appropriate?
> > 
> 
> 
> It will work. I thought we would want to have used GFP_NOIO though since 
> we are running from work queue. I do not know why we have been using 
> GFP_ATOMIC in the other handlers. Chandra?

Mike,

I do not recall discussing about this. But, my memory is not that good
anyways :)...

As it stands now, the current code is all GFP_ATOMIC. I agree with you
that the workqueue allocs could be made GFP_NOIO. I can roll up a patch
(on top of Hannes's) to fix those.

Thanks,

chandra
> 
> 
> Oh yeah, I was wondering what is up with EMC? Do they need a different 
> alua handler? Is that needed to handle some quirks in it or something?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

