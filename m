From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] scsi_sysfs: fix hang when removing scsi device
Date: Sat, 18 Mar 2017 12:17:28 +0100
Message-ID: <bdf76dc7-fa5f-ed9f-c16a-4d6165f8f952@suse.de>
References: <1489077442-20610-1-git-send-email-israelr@mellanox.com>
 <1489088191.2597.9.camel@sandisk.com>
 <22efc8bd-ae71-14c7-247b-7399bfd28c6d@mellanox.com>
 <1489430936.2658.9.camel@sandisk.com>
 <1489432986.23810.12.camel@HansenPartnership.com>
 <1489437175.2658.17.camel@sandisk.com>
 <1489442133.23810.24.camel@HansenPartnership.com>
 <1489705225.2574.22.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751320AbdCRLdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Mar 2017 07:33:41 -0400
In-Reply-To: <1489705225.2574.22.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

On 03/17/2017 12:00 AM, Bart Van Assche wrote:
> On Mon, 2017-03-13 at 14:55 -0700, James Bottomley wrote:
>> On Mon, 2017-03-13 at 20:33 +0000, Bart Van Assche wrote:
>>> On Mon, 2017-03-13 at 12:23 -0700, James Bottomley wrote:
>>>> On Mon, 2017-03-13 at 18:49 +0000, Bart Van Assche wrote:
>>>>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>>>>> index 7bfbcfa7af40..b3bb49d06943 100644
>>>>> --- a/drivers/scsi/scsi.c
>>>>> +++ b/drivers/scsi/scsi.c
>>>>> @@ -602,7 +602,7 @@ EXPORT_SYMBOL(scsi_device_get);
>>>>>   */
>>>>>  void scsi_device_put(struct scsi_device *sdev)
>>>>>  {
>>>>> -       module_put(sdev->host->hostt->module);
>>>>> +       module_put(sdev->hostt->module);
>>>>>         put_device(&sdev->sdev_gendev);
>>>>>  }
>>>>>  EXPORT_SYMBOL(scsi_device_put);
>>>>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>>>>> index 6f7128f49c30..7134487abbb1 100644
>>>>> --- a/drivers/scsi/scsi_scan.c
>>>>> +++ b/drivers/scsi/scsi_scan.c
>>>>> @@ -227,6 +227,7 @@ static struct scsi_device
>>>>> *scsi_alloc_sdev(struct
>>>>> scsi_target *starget,
>>>>>         sdev->model = scsi_null_device_strs;
>>>>>         sdev->rev = scsi_null_device_strs;
>>>>>         sdev->host = shost;
>>>>> +       sdev->hostt = shost->hostt;
>>>>>         sdev->queue_ramp_up_period = SCSI_DEFAULT_RAMP_UP_PERIOD;
>>>>>         sdev->id = starget->id;
>>>>>         sdev->lun = lun;
>>>>> diff --git a/include/scsi/scsi_device.h
>>>>> b/include/scsi/scsi_device.h
>>>>> index 6f22b39f1b0c..cda620ed5922 100644
>>>>> --- a/include/scsi/scsi_device.h
>>>>> +++ b/include/scsi/scsi_device.h
>>>>> @@ -82,6 +82,7 @@ struct scsi_event {
>>>>>  
>>>>>  struct scsi_device {
>>>>>         struct Scsi_Host *host;
>>>>> +       struct scsi_host_template *hostt;
>>>>>         struct request_queue *request_queue;
>>>>>  
>>>>
>>>> The apparent assumption behind this patch is that sdev->host can be
>>>> freed but the sdev will still exist?  That shouldn't be correct:
>>>> the
>>>> rule for struct devices is that the child always holds the parent
>>>> and
>>>> the host is parented (albeit not necessarily directly) to the sdev,
>>>> so
>>>> it looks like something has gone wrong if the host had been freed
>>>> before the sdev.
>>>
>>> Hello James,
>>>
>>> scsi_remove_host() decreases the sdev reference count but does not 
>>> wait until the sdev release work has finished. This is why the SCSI
>>> host can already have disappeared before the last scsi_device_put()
>>> call occurs.
>>
>> This is true, but I don't see how it can cause the host to be freed
>> before the sdev.  The memory for struct Scsi_Host is freed in the
>> shost_gendev release routine, which should be pinned by the parent
>> traversal from sdev.  So it should not be possible for
>>  scsi_host_dev_release() to be called before
>>  scsi_device_dev_release_usercontext() becase the latter has the final
>> put of the parent device.
> 
> Hello Hannes,
> 
> The following crash only occurs with async aborts enabled:
> 
> general protection fault: 0000 [#1] SMP
> RIP: 0010:scsi_device_put+0xb/0x30
> Call Trace:
>  scsi_disk_put+0x2d/0x40
>  sd_release+0x3d/0xb0
>  __blkdev_put+0x29e/0x360
>  blkdev_put+0x49/0x170
>  dm_put_table_device+0x58/0xc0 [dm_mod]
>  dm_put_device+0x70/0xc0 [dm_mod]
>  free_priority_group+0x92/0xc0 [dm_multipath]
>  free_multipath+0x70/0xc0 [dm_multipath]
>  multipath_dtr+0x19/0x20 [dm_multipath]
>  dm_table_destroy+0x67/0x120 [dm_mod]
>  dev_suspend+0xde/0x240 [dm_mod]
>  ctl_ioctl+0x1f5/0x520 [dm_mod]
>  dm_ctl_ioctl+0xe/0x20 [dm_mod]
>  do_vfs_ioctl+0x8f/0x700
>  SyS_ioctl+0x3c/0x70
>  entry_SYSCALL_64_fastpath+0x18/0xad
> 
> I hadn't seen this crash before kernel v4.11-rc1 but with kernel v4.11-rc1
> and later I see it if I let the srp-test scripts run for a few minutes. The
> patch I used to disable async aborts on my test setup is as follows:
> 
How utterly curious.

Thing is, I didn't change anything in the async abort case; all my
patches haven't been merged yet.
So I would rather think this being the side effect of something else

And I just noticed that you found the real issue with your alua fixes,
so I guess this can be ignored, right?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
