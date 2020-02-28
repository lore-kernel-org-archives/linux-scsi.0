Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D4CC3F2CD
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 16:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 531CA2468E
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 16:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgB1QZW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 11:25:22 -0500
Received: from smtp.infotech.no ([82.134.31.41]:51159 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgB1QZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 11:25:21 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id A5E6020418E;
        Fri, 28 Feb 2020 17:25:19 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TaSXr84hWBc6; Fri, 28 Feb 2020 17:25:17 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 0EF9620414E;
        Fri, 28 Feb 2020 17:25:16 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v7 11/38] sg: change rwlock to spinlock
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20200227165902.11861-1-dgilbert@interlog.com>
 <20200227165902.11861-12-dgilbert@interlog.com>
 <e7492987-ef65-50fb-ad9a-065a1935ef9e@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <a1d7d017-b87b-e7ac-a8cf-0d08ded8222a@interlog.com>
Date:   Fri, 28 Feb 2020 11:25:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e7492987-ef65-50fb-ad9a-065a1935ef9e@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-28 3:31 a.m., Hannes Reinecke wrote:
> On 2/27/20 5:58 PM, Douglas Gilbert wrote:
>> A reviewer suggested that the extra overhead associated with a
>> rw lock compared to a spinlock was not worth it for short,
>> oft-used critcal sections.
>>
>> So the rwlock on the request list/array is changed to a spinlock.
>> The head of that list is in the owning sf file descriptor object.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/sg.c | 52 +++++++++++++++++++++++------------------------
>>   1 file changed, 26 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index eb3b333ea30b..99d7b1f76fc7 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -139,7 +139,7 @@ struct sg_fd {        /* holds the state of a file 
>> descriptor */
>>       struct list_head sfd_entry;    /* member sg_device::sfds list */
>>       struct sg_device *parentdp;    /* owning device */
>>       wait_queue_head_t read_wait;    /* queue read until command done */
>> -    rwlock_t rq_list_lock;    /* protect access to list in req_arr */
>> +    spinlock_t rq_list_lock;    /* protect access to list in req_arr */
>>       struct mutex f_mutex;    /* protect against changes in this fd */
>>       int timeout;        /* defaults to SG_DEFAULT_TIMEOUT      */
>>       int timeout_user;    /* defaults to SG_DEFAULT_TIMEOUT_USER */
>> @@ -738,17 +738,17 @@ sg_get_rq_mark(struct sg_fd *sfp, int pack_id)
>>       struct sg_request *resp;
>>       unsigned long iflags;
>> -    write_lock_irqsave(&sfp->rq_list_lock, iflags);
>> +    spin_lock_irqsave(&sfp->rq_list_lock, iflags);
>>       list_for_each_entry(resp, &sfp->rq_list, entry) {
>>           /* look for requests that are ready + not SG_IO owned */
>>           if (resp->done == 1 && !resp->sg_io_owned &&
>>               (-1 == pack_id || resp->header.pack_id == pack_id)) {
>>               resp->done = 2;    /* guard against other readers */
>> -            write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
>> +            spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
>>               return resp;
>>           }
>>       }
>> -    write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
>> +    spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
>>       return NULL;
>>   }
>> @@ -802,9 +802,9 @@ srp_done(struct sg_fd *sfp, struct sg_request *srp)
>>       unsigned long flags;
>>       int ret;
>> -    read_lock_irqsave(&sfp->rq_list_lock, flags);
>> +    spin_lock_irqsave(&sfp->rq_list_lock, flags);
>>       ret = srp->done;
>> -    read_unlock_irqrestore(&sfp->rq_list_lock, flags);
>> +    spin_unlock_irqrestore(&sfp->rq_list_lock, flags);
>>       return ret;
>>   }
> This one is pretty much pointless.
> By the time the 'return' statement is reached the 'ret' value is already stale, 
> and the lock has achieved precisely nothing.
> Use READ_ONCE() and drop the lock.

Yes. And its gone in a later patch where it is now part of the atomic
state variable that is part of each sg_request object (i.e. rq_st).
Again, I'm restricting my changes to the title of the patch.

Doug Gilbert

