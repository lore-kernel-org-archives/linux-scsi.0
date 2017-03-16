From: Israel Rukshin <israelr@mellanox.com>
Subject: Re: [PATCH v2] scsi_sysfs: fix hang when removing scsi device
Date: Thu, 16 Mar 2017 11:02:02 +0200
Message-ID: <8e4daba5-b172-2ee1-e889-93892079e839@mellanox.com>
References: <1489077442-20610-1-git-send-email-israelr@mellanox.com>
 <1489088191.2597.9.camel@sandisk.com>
 <22efc8bd-ae71-14c7-247b-7399bfd28c6d@mellanox.com>
 <1489430936.2658.9.camel@sandisk.com>
 <1489432986.23810.12.camel@HansenPartnership.com>
 <1489437175.2658.17.camel@sandisk.com>
 <1489442133.23810.24.camel@HansenPartnership.com>
 <1489458944.2987.1.camel@sandisk.com>
 <c9afc172-105a-cabf-b286-150c6dc11a68@mellanox.com>
 <96b2016e-c9a0-07e8-0af3-be04802162a9@mellanox.com>
 <1489620422.2660.16.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve1eur01on0089.outbound.protection.outlook.com ([104.47.1.89]:64960
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752253AbdCPJC0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Mar 2017 05:02:26 -0400
In-Reply-To: <1489620422.2660.16.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "maxg@mellanox.com" <maxg@mellanox.com>

Hi Bart,

I tested your patches and the hang disappeared when fast_io_fail_tmo 
expired.
The warning from patch 1 still exist, so we need an additional fix for that.

Regards,
Israel

On 3/16/2017 1:27 AM, Bart Van Assche wrote:
> On Tue, 2017-03-14 at 16:23 +0200, Israel Rukshin wrote:
>> Patch number 5 doesn't handle the case when device_for_each_child() is
>> called. device_for_each_child() calls to target_unblock() that uses also
>> starget_for_each_device(). After applying also the following change the
>> hang disappeared but it didn't fix the warning. Those fixes are not enough
>> because if fast_io_fail_tmo is set to infinity then the hang will remain,
>> because only __rport_fail_io_fast() calls to scsi_target_unblock() and
>> terminate_rport_io() that free the sync cache command.
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index e5d4b50..09f9566 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -3068,9 +3068,15 @@ void scsi_device_resume(struct scsi_device *sdev)
>>    static int
>>    target_unblock(struct device *dev, void *data)
>>    {
>> -       if (scsi_is_target_device(dev))
>> -               starget_for_each_device(to_scsi_target(dev), data,
>> -                                       device_unblock);
>> +       if (scsi_is_target_device(dev)) {
>> +               struct scsi_target *starget = to_scsi_target(dev);
>> +               struct Scsi_Host *shost = dev_to_shost(dev->parent);
>> +               unsigned long flags;
>> +
>> +               spin_lock_irqsave(shost->host_lock, flags);
>> +               __starget_for_each_device(starget, data, device_unblock);
>> +               spin_unlock_irqrestore(shost->host_lock, flags);
>> +       }
>>           return 0;
>>    }
> Hello Israel,
>
> Regarding setting fast_io_fail_tmo to infinity: that does not prevent
> kernel module unloading because srp_timed_out() stops resetting the
> timer as soon as the SCSI device is unblocked. The above patch should
> realize that but suffers from the same issue as a patch attached to
> my previous e-mail, namely lock inversion. For at least the following
> call chain the block layer queue lock is the outer lock and the SCSI
> host lock is the inner lock:
> ata_qc_schedule_eh()
> -> blk_abort_request()
>    -> blk_mq_rq_timed_out()
>      -> scsi_timeout()
>        -> scsi_times_out()
>          -> scsi_eh_scmd_add()
>
> So I think we should avoid introducing code with the SCSI host lock
> as outer lock and the block layer queue lock as inner lock. How about
> the attached four patches?
>
> Thanks,
>
> Bart.
