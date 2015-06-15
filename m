From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 17/20] [SCSI] mpt3sas: Use alloc_ordered_workqueue() API
 instead of create_singlethread_workqueue() API
Date: Mon, 15 Jun 2015 16:26:29 +0530
Message-ID: <CAK=zhgrUh-Xcz2kqJRsdxmTKXE-hdLE52ya+5PDTTuNqN_Pwjw@mail.gmail.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-18-git-send-email-Sreekanth.Reddy@avagotech.com>
	<557B4923.1020608@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:32866 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbFOK4b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2015 06:56:31 -0400
Received: by wgez8 with SMTP id z8so65601090wge.0
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2015 03:56:30 -0700 (PDT)
In-Reply-To: <557B4923.1020608@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Sat, Jun 13, 2015 at 2:33 AM, Joe Lawrence <joe.lawrence@stratus.com> wrote:
> On 06/12/2015 05:42 AM, Sreekanth Reddy wrote:
> ...
>> +#if defined(alloc_ordered_workqueue)
>> +     ioc->firmware_event_thread = alloc_ordered_workqueue(
>> +             ioc->firmware_event_name, WQ_MEM_RECLAIM);
>> +#else
>> +             ioc->firmware_event_thread = create_singlethread_workqueue(
>>           ioc->firmware_event_name);
>> +#endif
>
> Hi Sreekanth,
>
> I think the upstream version of this code can safely assume
> alloc_ordered_workqueue is defined, no?

yes, upstream version of this code can safely assume that
alloc_ordered_workqueue is defined.

While working in-house, I observed that some of the older kernels
doesn't defined this macro, so I have added this else section.

>
> Regards,
>
> -- Joe



-- 

Regards,
Sreekanth
