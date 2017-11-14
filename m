From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 0/2] sd: Fix a deadlock between event checking and device removal
Date: Tue, 14 Nov 2017 18:01:29 +0100
Message-ID: <CAD+HZHUVsaDYO7yL2Ct868kdK=dE3PuRmy-Jfp2d2zmEBJPwFg@mail.gmail.com>
References: <a8f0ee8f-7b40-2375-47a4-52f78af29d8d@sandisk.com>
 <1479016028.17624.16.camel@linux.vnet.ibm.com> <9500e9b2-2d34-099d-aa90-d38fb3feb02e@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:54285 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755641AbdKNRBa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2017 12:01:30 -0500
Received: by mail-wm0-f49.google.com with SMTP id r68so23496249wmr.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Nov 2017 09:01:30 -0800 (PST)
In-Reply-To: <9500e9b2-2d34-099d-aa90-d38fb3feb02e@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

2016-11-14 19:35 GMT+01:00 Bart Van Assche <bart.vanassche@sandisk.com>:
> On 11/12/2016 09:47 PM, James Bottomley wrote:
>>
>> On Fri, 2016-11-11 at 16:38 -0800, Bart Van Assche wrote:
>>>
>>> Hello James and Martin,
>>>
>>> This short patch series fixes a deadlock that I ran into for the
>>> first time several months ago but for which I had not yet had the
>>> time to post a fix. As usual, feedback is appreciated.
>>
>>
>> First question would be why do we need to push highly dm specific
>> knowledge into block, like REQ_FAIL_IF_NO_PATH.  Can't we just use
>> REQ_FAILFAST_X for this?
>>
>> Also, I don't quite understand how you've configured multipath
>> underneath SCSI.  I thought dm-mp always went on top?
>
>
> Hello James,
>
> dm-multipath was running on top of SCSI in my setup which means that at
> least the patch description is wrong. Since it was some time ago that I ran
> into this deadlock, I will check first whether I can still reproduce it.
>
> Bart.

Hi Bart,

I suspect we run into same bug you were trying to fix in this patch
set. we're running in v4.4.50

I was trying to reproduce it, but no lucky yet, do you still have your
reproducer?

Thanks,
Jack


>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
