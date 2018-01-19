From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] sd: succeed check_event if device is not removable
Date: Fri, 19 Jan 2018 10:59:04 +0100
Message-ID: <CAMGffE=_02C_xxcP73WcJHR1c5hmCcYD8hD1ZWScwbhJXf1tQA@mail.gmail.com>
References: <1516292559-26649-1-git-send-email-jinpu.wangl@profitbricks.com> <1516293172.3014.11.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:38023 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754911AbeASJ7Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jan 2018 04:59:25 -0500
Received: by mail-qt0-f195.google.com with SMTP id z10so2469794qti.5
        for <linux-scsi@vger.kernel.org>; Fri, 19 Jan 2018 01:59:25 -0800 (PST)
In-Reply-To: <1516293172.3014.11.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Gi-Oh Kim <gi-oh.kim@profitbricks.com>, Bart Van Assche <bvanassche@acm.org>

Hi James,

Thanks for prompt reply.

On Thu, Jan 18, 2018 at 5:32 PM, James Bottomley
<jejb@linux.vnet.ibm.com> wrote:
> On Thu, 2018-01-18 at 17:22 +0100, Jack Wang wrote:
>> From: Jack Wang <jinpu.wang@profitbricks.com>
>>
>> The check_events interface was added for check if device changes,
>> mainly for device is removable eg. CDROM
>>
>> In sd_open, it checks if device is removable then check_disk_change.
>>
>> when the device is not removable, we can simple succeeds the call
>> without send TUR.
>>
>> Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
>> ---
>>  drivers/scsi/sd.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index ab75ebd..773ce81 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -1576,6 +1576,10 @@ static unsigned int sd_check_events(struct
>> gendisk *disk, unsigned int clearing)
>>       sdp = sdkp->device;
>>       SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
>> "sd_check_events\n"));
>>
>> +     if (!sdp->removable) {
>> +             retval = 0;
>> +             goto out;
>> +     }
>
> This looks like very much the wrong place to fix whatever problem
> you're seeing is.  We could simply avoid setting up the events work
> function in genhd.c:device_add_disk(), which would be way more
> efficient.  However, I think some devices do require being probed
> occasionally with a TUR because its the only way SCSI gets AENs (not
> that we make much use of them).
>
> So first of all, what's the actual problem?
>
> James
>

Eagle eyes! The real problem I want to workaround is deadlock between
check_event and device removal, reported here:
https://patchwork.kernel.org/patch/10057977/

We've see in our production during incident, storage failure lead scsi
error handle and
offlined both devices, so both multipaths down, raid1 failed one leg (the
dm device).

During incident recovery, when tried to delete the broken scsi device,
there are processes in D state.

I failed to reproduce on my test machines, this is why I want to
workaround the problem by avoiding TUR.

Thanks,
-- 
Jack Wang
