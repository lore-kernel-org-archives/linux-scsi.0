From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 6/9] scsi_dh: add generic SPC-3 alua handler
Date: Fri, 27 Jun 2008 10:51:07 -0500
Message-ID: <48650C6B.4030404@cs.wisc.edu>
References: <20080624100504.7D8C210B5DE@craiglockhart-ipmi.suse.de> <486424BA.8040301@cs.wisc.edu> <4864FA31.9020401@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53966 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbYF0PvW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2008 11:51:22 -0400
In-Reply-To: <4864FA31.9020401@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> Mike Christie wrote:
>> Hannes Reinecke wrote:
>>> +
>>> +static struct request *get_alua_req(struct scsi_device *sdev,
>>> +                    void *buffer, unsigned buflen, int rw)
>>> +{
>>> +    struct request *rq;
>>> +    struct request_queue *q = sdev->request_queue;
>>> +
>>> +    rq = blk_get_request(q, rw, GFP_KERNEL);
>>> +
>>> +    if (!rq) {
>>> +        sdev_printk(KERN_INFO, sdev,
>>> +                "%s: blk_get_request failed\n", __FUNCTION__);
>>> +        return NULL;
>>> +    }
>>> +
>>> +    if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_KERNEL)) {
>>> +        blk_put_request(rq);
>>> +        sdev_printk(KERN_INFO, sdev,
>>> +                "%s: blk_rq_map_kern failed\n", __FUNCTION__);
>>> +        return NULL;
>>> +    }
>>> +
>>> +    rq->cmd_type = REQ_TYPE_BLOCK_PC;
>>> +    rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
>>> +    rq->retries = ALUA_FAILOVER_RETRIES;
>>> +    rq->timeout = ALUA_FAILOVER_TIMEOUT;
>>> +
>>> +    return rq;
>>> +}
>>
>>
>> It looks like this can be called from alua_activate, and we cannot use 
>> GFP_KERNEL in the same IO path something could get written to.
>>
> Is something like GFP_ATOMIC more appropriate?
> 


It will work. I thought we would want to have used GFP_NOIO though since 
we are running from work queue. I do not know why we have been using 
GFP_ATOMIC in the other handlers. Chandra?


Oh yeah, I was wondering what is up with EMC? Do they need a different 
alua handler? Is that needed to handle some quirks in it or something?
