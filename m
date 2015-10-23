From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] scsi_sysfs: protect against double execution of __scsi_remove_device()
Date: Fri, 23 Oct 2015 11:14:19 +0200
Message-ID: <87lhaugd5g.fsf@vitty.brq.redhat.com>
References: <1445533954-19857-1-git-send-email-vkuznets@redhat.com>
	<56291DD2.90104@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbbJWJOX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Oct 2015 05:14:23 -0400
In-Reply-To: <56291DD2.90104@sandisk.com> (Bart Van Assche's message of "Thu,
	22 Oct 2015 10:33:06 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>

Bart Van Assche <bart.vanassche@sandisk.com> writes:

> On 10/22/2015 10:12 AM, Vitaly Kuznetsov wrote:
>> On some host errors storvsc module tries to remove sdev by scheduling a job
>> which does the following:
>>
>>     sdev = scsi_device_lookup(wrk->host, 0, 0, wrk->lun);
>>     if (sdev) {
>>         scsi_remove_device(sdev);
>>         scsi_device_put(sdev);
>>     }
>>
>> While this code seems correct the following crash is observed:
>>
>>   general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
>>   RIP: 0010:[<ffffffff81169979>]  [<ffffffff81169979>] bdi_destroy+0x39/0x220
>>   ...
>>   [<ffffffff814aecdc>] ? _raw_spin_unlock_irq+0x2c/0x40
>>   [<ffffffff8127b7db>] blk_cleanup_queue+0x17b/0x270
>>   [<ffffffffa00b54c4>] __scsi_remove_device+0x54/0xd0 [scsi_mod]
>>   [<ffffffffa00b556b>] scsi_remove_device+0x2b/0x40 [scsi_mod]
>>   [<ffffffffa00ec47d>] storvsc_remove_lun+0x3d/0x60 [hv_storvsc]
>>   [<ffffffff81080791>] process_one_work+0x1b1/0x530
>>   ...
>>
>> The problem comes with the fact that many such jobs (for the same device)
>> are being scheduled simultaneously. While scsi_remove_device() uses
>> shost->scan_mutex and scsi_device_lookup() will fail for a device in
>> SDEV_DEL state there is no protection against someone who did
>> scsi_device_lookup() before we actually entered __scsi_remove_device(). So
>> the whole scenario looks like that: two callers do simultaneous (or
>> preemption happens) calls to scsi_device_lookup() ant these calls succeed
>> for all of them, after that both callers try doing scsi_remove_device().
>> shost->scan_mutex only serializes their calls to __scsi_remove_device()
>> and we end up doing the cleanup path twice.
>>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>   drivers/scsi/scsi_sysfs.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index b333389..e0d2707 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -1076,6 +1076,14 @@ void __scsi_remove_device(struct scsi_device *sdev)
>>   {
>>   	struct device *dev = &sdev->sdev_gendev;
>>
>> +	/*
>> +	 * This cleanup path is not reentrant and while it is impossible
>> +	 * to get a new reference with scsi_device_get() someone can still
>> +	 * hold a previously acquired one.
>> +	 */
>> +	if (sdev->sdev_state == SDEV_DEL)
>> +		return;
>> +
>>   	if (sdev->is_visible) {
>>   		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
>>   			return;
>
> Hello Vitaly,
>
> Sorry but I don't see how the above patch could be a proper fix. If
> two calls to __scsi_remove_device() occur concurrently the crash
> explained above can still occur. The storsvc driver should be modified
> such that concurrent __scsi_remove_device() calls do not occur. How
> about preventing concurrent calls via a mutex ?

Nobody is supposed to call __scsi_remove_device() without holding
shost->scan_mutex and scsi_remove_device() does that. Here I'm trying to
protect against two *consequent* calls to the __scsi_remove_device(). As
we set sdev_state to SDEV_DEL on the cleanup path checking it should be
enough.

> Another possible
> approach is to use the workqueue mechanism. An example can be found in
> the SRP initiator driver (ib_srp).

Yes, but I think the existent approach is good enough:
1) Every caller is supposed to get a reference to the device with
scsi_device_get() (scsi_device_lookup() does that).
2) shost->scan_mutex is suppose to be held by all __scsi_remove_device()
callers.

-- 
  Vitaly
