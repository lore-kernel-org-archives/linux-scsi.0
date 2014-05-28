From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: Re: [PATCH] notify block layer when using temporary change to cache_type
Date: Wed, 28 May 2014 12:58:27 +0800
Message-ID: <1401253107-16138-1-git-send-email-vaughan.cao@oracle.com>
References: <1401190754-6822-1-git-send-email-vaughan.cao@oracle.com> <1401207496.14454.90.camel@dabdike>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401207496.14454.90.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vaughan.cao@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 05/28/2014 12:18 AM, James Bottomley wrote:
> On Tue, 2014-05-27 at 19:39 +0800, Vaughan Cao wrote:
>> This is a fix for commit:
>>   39c60a0948cc06139e2fbfe084f83cb7e7deae3b sd: fix array cache flushing bug causing performance problems
>> We must notify the block layer via q->flush_flags after temporary change the cache_type to write through.
>> If not, SYNCHRONIZE CACHE command will still be generated.
>>
>> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
>> ---
>>  drivers/scsi/sd.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 6146b9d..366e48b 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -144,6 +144,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
> This is a weird function name.  The name in the vanilla kernel is
> cache_type_store().
Sorry, this patch is created on oracle uek kernel, I just checked it can
apply to vanilla kernel cleanly and didn't notice they are using
different device attribute function name.

>>  	struct scsi_sense_hdr sshdr;
>>  	static const char temp[] = "temporary ";
>>  	int len;
>> +	unsigned flush;
>>  
>>  	if (sdp->type != TYPE_DISK)
>>  		/* no cache control on RBC devices; theoretically they
>> @@ -174,6 +175,17 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
>>  	if (sdkp->cache_override) {
>>  		sdkp->WCE = wce;
>>  		sdkp->RCD = rcd;
>> +
>> +		/* set flush_flags to notify the block layer */
>> +		flush = 0;
>> +		if (sdkp->WCE) {
>> +			flush |= REQ_FLUSH;
>> +			if (sdkp->DPOFUA)
>> +				flush |= REQ_FUA;
>> +		}
>> +
>> +		blk_queue_flush(sdkp->disk->queue, flush);
>> +
> Is there a reason you cut and paste from sd_revalidate_disk() instead of
> just calling it directly?
No, I just want to keep the modification as small as possible. Checked
the actions of sd_revalidate_disk() again, it seems no harm to call it
from here. Also actual actions are skipped in sd_read_cache_type() if
cache_override!=0, so I suppose your original plan is to jump to
sd_revalidate_disk() from here.

However, that way may not be acceptable after further code review.
Changing the sdkp->WCE,RCD will cause these real parameters of the
underlying device *lost*. In sd_shutdown() and sd_suspend_common(), we
need them to call sd_sync_cache() if necessary. I don't think this
action is avoidable, just for the performance issue to solve. And we
can't change the mode just by setting q->flush_flags while leave
sdkp->WCE,RCD untouched either, because cache_type_show() needs
sdkp->WCE,RCD to present the temporary config to userspace.

static void sd_shutdown(struct device *dev)
{
...
	if (sdkp->WCE && sdkp->media_present) {
		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
		sd_sync_cache(sdkp);
	}

static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
{
...
	if (sdkp->WCE && sdkp->media_present) {
		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
		ret = sd_sync_cache(sdkp);

So, It seems new fields like realWCE and readRCD in scsi_disk are needed
to save those configuration. What's your opinion?

Vaughan
>
> James
>
>
>
