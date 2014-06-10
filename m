From: Vishwanath Pai <vpai@akamai.com>
Subject: Re: [RFC Patch]: scsi: sysfs file cache_type not in sync with mode
 page
Date: Mon, 09 Jun 2014 20:16:19 -0400
Message-ID: <53964E53.3000106@akamai.com>
References: <E1Wt1Sq-0000LA-Ez@bos-lpci1.kendall.corp.akamai.com> <1402095314.2207.105.camel@dabdike.int.hansenpartnership.com> <53926F99.4030003@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:25506 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754160AbaFJAQU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2014 20:16:20 -0400
In-Reply-To: <53926F99.4030003@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

In order to issue a BLKRRPART the drive needs to be unmounted first, this 
is not always possible on a machine. There is another way though: 
'echo 1 > /sys/block/sda/device/rescan'. This rescans all the mode pages 
so that the kernel is in sync.

Writing to cache_type does seem to be a better idea than using sdparm, but
this is erroring out on one of our drives, whereas sdparm sets it without 
an error.

$echo "write through" > /sys/class/scsi_disk/6\:0\:0\:0/cache_type 
-bash: echo: write error: Invalid argument

$dmesg | tail -4
[1667272.378024] sd 6:0:0:0: [sda]  
[1667272.378547] Sense Key : Illegal Request [current] 
[1667272.379254] sd 6:0:0:0: [sda]  
[1667272.379758] Add. Sense: Invalid field in parameter list

I can think of a scenario where the kernel thinks that WCE is not set and issue
wrong flush commands and assume that the cache has been cleared. I think we 
should find a better way to keep the kernel in sync, or inform the kernel of 
this change.

- Vishwanath

On 06/06/2014 09:49 PM, Douglas Gilbert wrote:
> On 14-06-06 06:55 PM, James Bottomley wrote:
>> On Fri, 2014-06-06 at 17:14 -0400, Pai wrote:
>>> Hi All,
>>>
>>> I noticed that the sysfs file cache_type is not is sync with the information in the mode page. If we change the WCE attribute in the mode page (sdparm --set=WCE /dev/sda  and sdparm --clear=WCE /dev/sda) it does not reflect this in the sysfs file.
>>>
>>> $ cat /sys/block/sda/device/scsi_disk/6\:0\:0\:0/cache_type
>>> write back
>>>
>>> $ sdparm --clear=WCE /dev/sda
>>>      /dev/sda: TOSHIBA   AL13SEB600        0101
>>>
>>> $ cat /sys/block/sda/device/scsi_disk/6\:0\:0\:0/cache_type
>>> write back
>>>
>>> Ideally cache_type should have changed to 'write through' or 'none'. I have a small one line change that can fix this one. This patch applies against the latest branch "linux-3.15-rc8".
>>>
>>> Few things to note:
>>> 1. revalidate_disk() also reads a whole bunch of other things from the mode page and I don't know if this will have any side effects. This call is made on store_cache_type as well, so I think it should be OK.
>>> 2. This is extra work which is not needed in most cases (mode pages hardly change). Is there an event that we can subscribe to when the modpages change?
>>>
>>> Please review.
>>>
>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>>> index efcbcd1..5b65ccc 100644
>>> --- a/drivers/scsi/sd.c
>>> +++ b/drivers/scsi/sd.c
>>> @@ -256,6 +256,7 @@ static ssize_t
>>>   cache_type_show(struct device *dev, struct device_attribute *attr, char *buf)
>>>   {
>>>   	struct scsi_disk *sdkp = to_scsi_disk(dev);
>>> +	revalidate_disk(sdkp->disk);
>>>   	int ct = sdkp->RCD + 2*sdkp->WCE;
>>>
>>>   	return snprintf(buf, 40, "%s\n", sd_cache_types[ct]);
>> The behaviour you describe is correct.  The cache type is probed once at
>> init.  If you change the cache behind the back of the linux code, you
>> have to expect that we won't see it.  We're definitely not doing a
>> revalidate on every write just in case, so by extension we expect that
>> to see it via sysfs either you change it through the provided interface
>> (writing to the cache_type file) or you inform the kernel if you change
>> it via other means by issuing the BLKRRPART ioctl.
> Have a look at
>    echo "write through" > /sys/class/scsi_disk/6\:0\:0\:0/cache_type
>
> and/or
>    echo "write back" > /sys/class/scsi_disk/6\:0\:0\:0/cache_type
>
> and those strings can be prefixed by "temporary ". The explanation
> and mapping to T10 terms is in drivers/scsi/sd.c cache_type_store(),
> or at least should be.
>
> Doug Gilbert
>
>

