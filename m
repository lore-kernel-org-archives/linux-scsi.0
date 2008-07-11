From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] make sr_mod report more accurate drive status
 after	closing the tray.
Date: Fri, 11 Jul 2008 10:51:55 -0400
Message-ID: <4877738B.4090100@redhat.com>
References: <48767E08.50202@redhat.com>
	<1215726719.3353.92.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <fedora-kernel-list-bounces-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <1215726719.3353.92.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/fedora-kernel-list>,
	<mailto:fedora-kernel-list-request-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/fedora-kernel-list>
List-Post: <mailto:fedora-kernel-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Help: <mailto:fedora-kernel-list-request-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/fedora-kernel-list>,
	<mailto:fedora-kernel-list-request-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org?subject=subscribe>
Sender: fedora-kernel-list-bounces-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Errors-To: fedora-kernel-list-bounces-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: fedora-kernel-list <fedora-kernel-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2008-07-10 at 17:24 -0400, Peter Jones wrote:
>> Right now, when using sr_mod and issuing the CDROM_DRIVE_STATUS ioctl,
>> there's no way to differentiate between when you've just closed the
>> drive tray, but the media is not yet loaded, and when there's no media.
>> This seems to be accidental.
>>
>> Here's a patch that seems to fix this behaviour:
> 
> I'm very wary of doing something like this because it took us months to
> fix up all the breakage the last time ...

That's certainly understandable.  What I'm hitting is that I can't tell 
the difference any more between not having media and it simply not being 
ready yet.  And the amount of time it takes to become ready seems to 
vary wildly (1s on one drive I've got here, ~20s on another fairly new 
drive), so a timeout isn't even a very effective kludge.

>> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
>> index ae87d08..43a084b 100644
>> --- a/drivers/scsi/sr_ioctl.c
>> +++ b/drivers/scsi/sr_ioctl.c
>> @@ -306,10 +306,9 @@ int sr_drive_status(struct cdrom_device_info *cdi, 
>> int slot)
>>   		/* we have no changer support */
>>   		return -EINVAL;
>>   	}
>> -	if (0 == sr_test_unit_ready(cd->device, &sshdr))
>> -		return CDS_DISC_OK;
>> -
>> -	if (!cdrom_get_media_event(cdi, &med)) {
>> +	if (0 == sr_test_unit_ready(cd->device, &sshdr)
>> +			&& sshdr.sense_key == 0
> 
> This can't be right; if the return is zero, the sense_key must also be
> zero (as in to have valid sense, it must have returned with at least
> DRIVER_SENSE)
> 
>> +			&& !cdrom_get_media_event(cdi, &med)) {
> 
> And this really doesn't look right either.  Now you're only calling the
> media event if the test unit ready succeeded.  A drive can be open (thus
> returning not ready and hence non zero) and still give you a valid media
> event.

Ok, that's a fair point.  That part I'm really trying to avoid here is 
returning the CDS_NO_DSIC case when the sense key says we don't yet know 
(NOT_READY).  So probably that case simply shouldn't be returned until 
after we do the SK/ASC/ASCQ check.

> 
>>   		if (med.media_present)
>>   			return CDS_DISC_OK;
>>   		else if (med.door_open)
>> @@ -319,10 +318,27 @@ int sr_drive_status(struct cdrom_device_info *cdi, 
>> int slot)
>>   	}
>>
>>   	/*
>> -	 * 0x04 is format in progress .. but there must be a disc present!
>> +	 * ASC: 0x04: "logical unit is not ready"
>> +	 * ASCQ: 0x01: cause not reportable
>> +	 *       0x02: in process of becoming ready
>> +	 *       0x03: initializing command required
>> +	 *       0x04: format in progress .. but there must be a disc present!
>> +	 *       0x07: operation in progress
>> +	 *       0x08: long write in progress
>>   	 */
>> -	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04)
>> -		return CDS_DISC_OK;
> 
> This seems to be a nasty historical lie.  It seems to play into the new
> media changed stuff by stalling the change until the media is ready.
> Convince me that if we actually tell the truth here we're not going to
> fire a slew of spurious events at hal.

Would you be ok with a more minimal approach, where I only change the 
behaviour of NOT_READY/4/4 ?  I understand if you still want more study 
of the effects WRT udev/hal.

>> +	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04) {
>> +		switch (sshdr.ascq) {
>> +			case 0x01:
>> +			case 0x02:
>> +				return CDS_DRIVE_NOT_READY;
>> +			case 0x03:
>> +				return CDS_TRAY_OPEN;
> 
> That's a stretch ... the initialising command can be start motor, but
> the tray can be closed just fine.

Yes, it definitely is.  I don't feel strongly about this particular 
case, but the rationale was that as long as we're not handling that in 
the driver, then this case essentially means user intervention is 
required (though there's really no way for the user to know what that 
would be).  CDS_TRAY_OPEN is, AFAICT, the only return value that means 
that in other cases (i.e., on slot-loaders).  This part isn't critical 
to the functionality I need; it just seemed wrong when I was reading it.

-- 
   Peter
