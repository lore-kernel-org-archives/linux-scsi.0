From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] sg: use standard lists for sg_requests
Date: Fri, 3 Feb 2017 11:48:34 +0100
Message-ID: <3da1ab0a-8bb2-cf4a-c0bb-ab47535e68fe@suse.de>
References: <1486112091-68470-1-git-send-email-hare@suse.de>
 <1486112091-68470-5-git-send-email-hare@suse.de>
 <20170203104327.GB29497@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49555 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752200AbdBCKsg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 05:48:36 -0500
In-Reply-To: <20170203104327.GB29497@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 02/03/2017 11:43 AM, Christoph Hellwig wrote:
>>  typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
>> -	struct sg_request *nextrp;	/* NULL -> tail request (slist) */
>> +	struct list_head nextrp;	/* list entry */
> 
> s/nextrp/entry/
> 
>> @@ -2078,16 +2076,13 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
>>  			if (k < SG_MAX_QUEUE) {
>>  				memset(rp, 0, sizeof (Sg_request));
>>  				rp->parentfp = sfp;
>> +				list_add(&rp->nextrp, &sfp->rq_list);
> 
> The old code did a tail insertation.  And this whole function should
> become a lot simpler with proper lists anyway:
> 
Yeah, thought about that, too, but then I just went for the sloppy
approach to minimize changes.

> static Sg_request *
> sg_add_request(Sg_fd * sfp)
> {
> 	int k;
> 	unsigned long iflags;
> 	Sg_request *rp = sfp->req_arr;
> 
> 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
> 	if (!list_empty(&sfp->rq_list)) {
> 		if (!sfp->cmd_q)
> 			goto out_unlock;
> 
> 		for (k = 0; k < SG_MAX_QUEUE; ++k, ++rp) {
> 			if (!rp->parentfp)
> 				break;
> 		}
> 		if (k >= SG_MAX_QUEUE)
> 			goto out_unlock;
> 	}
> 
> 	memset(rp, 0, sizeof (Sg_request));
> 	rp->parentfp = sfp;
> 	rp->header.duration = jiffies_to_msecs(jiffies);
> 	list_add_tail(&rp->nextrp, &sfp->rq_list);
> 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> 	return rp;
> 
> out_unlock:
> 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> 	return NULL;
> 
Okay, will be updating the patch.

>> +	if ((!sfp) || (!srp) || (list_empty(&sfp->rq_list)))
> 
> No need for all these braces.
> 
Okay.

>> +	if (!list_empty(&srp->nextrp)) {
>> +		list_del_init(&srp->nextrp);
> 
> I don't think we need the _init as we never check for an empty entry.
> 
Yes.

>>  {
>>  	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
>>  	struct sg_device *sdp = sfp->parentdp;
>> +	Sg_request *srp, *tmp;
>>  
>>  	/* Cleanup any responses which were never read(). */
>> -	while (sfp->headrp)
>> -		sg_finish_rem_req(sfp->headrp);
>> +	list_for_each_entry_safe(srp, tmp, &sfp->rq_list, nextrp)
>> +		sg_finish_rem_req(srp);
> 
> What protects us from concurrent removals here?
> 
Nothing.
But this patch is intended to just replace the hand-rolled list
implementation, not fixing bugs here.
The problem is that 'sg_finish_rem_req()' is taking the rq_list_lock,
so it needs a bit of rework to make that work properly.
But I'll give it a go.

> Either way I'd rather keep the whіle not empty style even with
> proper lists.
> 
Okay.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
