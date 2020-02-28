Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC34C3F2D2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 16:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A89C520732
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 16:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgB1Qie (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 11:38:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:53294 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgB1Qie (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 11:38:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D588BAD86;
        Fri, 28 Feb 2020 16:38:31 +0000 (UTC)
Subject: Re: [PATCH v7 11/38] sg: change rwlock to spinlock
To:     dgilbert@interlog.com, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20200227165902.11861-1-dgilbert@interlog.com>
 <20200227165902.11861-12-dgilbert@interlog.com>
 <e7492987-ef65-50fb-ad9a-065a1935ef9e@suse.de>
 <a1d7d017-b87b-e7ac-a8cf-0d08ded8222a@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8a4555a0-9520-2374-12f1-c095d800c2d8@suse.de>
Date:   Fri, 28 Feb 2020 17:38:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a1d7d017-b87b-e7ac-a8cf-0d08ded8222a@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/28/20 5:25 PM, Douglas Gilbert wrote:
> On 2020-02-28 3:31 a.m., Hannes Reinecke wrote:
>> On 2/27/20 5:58 PM, Douglas Gilbert wrote:
>>> A reviewer suggested that the extra overhead associated with a
>>> rw lock compared to a spinlock was not worth it for short,
>>> oft-used critcal sections.
>>>
>>> So the rwlock on the request list/array is changed to a spinlock.
>>> The head of that list is in the owning sf file descriptor object.
>>>
>>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>>> ---
>>>   drivers/scsi/sg.c | 52 +++++++++++++++++++++++------------------------
>>>   1 file changed, 26 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>>> index eb3b333ea30b..99d7b1f76fc7 100644
>>> --- a/drivers/scsi/sg.c
>>> +++ b/drivers/scsi/sg.c
>>> @@ -139,7 +139,7 @@ struct sg_fd {        /* holds the state of a 
>>> file descriptor */
>>>       struct list_head sfd_entry;    /* member sg_device::sfds list */
>>>       struct sg_device *parentdp;    /* owning device */
>>>       wait_queue_head_t read_wait;    /* queue read until command 
>>> done */
>>> -    rwlock_t rq_list_lock;    /* protect access to list in req_arr */
>>> +    spinlock_t rq_list_lock;    /* protect access to list in req_arr */
>>>       struct mutex f_mutex;    /* protect against changes in this fd */
>>>       int timeout;        /* defaults to SG_DEFAULT_TIMEOUT      */
>>>       int timeout_user;    /* defaults to SG_DEFAULT_TIMEOUT_USER */
>>> @@ -738,17 +738,17 @@ sg_get_rq_mark(struct sg_fd *sfp, int pack_id)
>>>       struct sg_request *resp;
>>>       unsigned long iflags;
>>> -    write_lock_irqsave(&sfp->rq_list_lock, iflags);
>>> +    spin_lock_irqsave(&sfp->rq_list_lock, iflags);
>>>       list_for_each_entry(resp, &sfp->rq_list, entry) {
>>>           /* look for requests that are ready + not SG_IO owned */
>>>           if (resp->done == 1 && !resp->sg_io_owned &&
>>>               (-1 == pack_id || resp->header.pack_id == pack_id)) {
>>>               resp->done = 2;    /* guard against other readers */
>>> -            write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
>>> +            spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
>>>               return resp;
>>>           }
>>>       }
>>> -    write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
>>> +    spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
>>>       return NULL;
>>>   }
>>> @@ -802,9 +802,9 @@ srp_done(struct sg_fd *sfp, struct sg_request *srp)
>>>       unsigned long flags;
>>>       int ret;
>>> -    read_lock_irqsave(&sfp->rq_list_lock, flags);
>>> +    spin_lock_irqsave(&sfp->rq_list_lock, flags);
>>>       ret = srp->done;
>>> -    read_unlock_irqrestore(&sfp->rq_list_lock, flags);
>>> +    spin_unlock_irqrestore(&sfp->rq_list_lock, flags);
>>>       return ret;
>>>   }
>> This one is pretty much pointless.
>> By the time the 'return' statement is reached the 'ret' value is 
>> already stale, and the lock has achieved precisely nothing.
>> Use READ_ONCE() and drop the lock.
> 
> Yes. And its gone in a later patch where it is now part of the atomic
> state variable that is part of each sg_request object (i.e. rq_st).
> Again, I'm restricting my changes to the title of the patch.
> 
Yeah, I've seen in in the later patches.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
