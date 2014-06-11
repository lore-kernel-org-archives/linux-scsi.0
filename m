From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCHv4 0/6]  Support 64-bit LUNs
Date: Wed, 11 Jun 2014 09:44:47 -0400
Message-ID: <53985D4F.9010500@interlog.com>
References: <1401785937-43581-1-git-send-email-hare@suse.de> <53974739.8070303@acm.org> <5397F86D.1030503@suse.de> <5397FCEA.5040606@acm.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49430 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096AbaFKNox (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2014 09:44:53 -0400
In-Reply-To: <5397FCEA.5040606@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 14-06-11 02:53 AM, Bart Van Assche wrote:
> On 06/11/14 08:34, Hannes Reinecke wrote:
>> On 06/10/2014 07:58 PM, Bart Van Assche wrote:
>>> Many SCSI LLD's use int_to_scsilun() in the hot path (queuecommand()).
>>> This patch series makes the int_to_scsilun() function slightly more
>>> expensive. Has it been considered to cache the result of int_to_scsilun()
>>> such that LLD's can copy the cached int_to_scsilun() result instead of
>>> having to call int_to_scsilun() in the queuecommand() function ?
>>> Something like the (untested) patch below might be sufficient:
>>>
>>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>>> index e02b3aa..9e50d78 100644
>>> --- a/drivers/scsi/scsi_scan.c
>>> +++ b/drivers/scsi/scsi_scan.c
>>> @@ -244,6 +244,7 @@ static struct scsi_device *scsi_alloc_sdev(struct
>>> scsi_target *starget,
>>>        sdev->queue_ramp_up_period = SCSI_DEFAULT_RAMP_UP_PERIOD;
>>>        sdev->id = starget->id;
>>>        sdev->lun = lun;
>>> +    int_to_scsilun(lun, &sdev->scsi_lun);
>>>        sdev->channel = starget->channel;
>>>        sdev->sdev_state = SDEV_CREATED;
>>>        INIT_LIST_HEAD(&sdev->siblings);
>>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>>> index 5853c91..48ea68e 100644
>>> --- a/include/scsi/scsi_device.h
>>> +++ b/include/scsi/scsi_device.h
>>> @@ -100,6 +100,8 @@ struct scsi_device {
>>>
>>>        unsigned int id, lun, channel;
>>>
>>> +    struct scsi_lun scsi_lun;    /* int_to_scsilun(lun) */
>>> +
>>>        unsigned int manufacturer;    /* Manufacturer of device, for using
>>>                         * vendor-specific cmd's */
>>>        unsigned sector_size;    /* size in bytes */
>>>
>>> Thanks,
>>
>> Hmm. No, so far it hasn't been considered. Maybe it's even worthwhile to
>> move the situation around, ie using primarily the 64-bit LUN and only
>> convert it into an integer if so requested.
>> But yeah, it's definitely something we should look into.
>>
>> Maybe _after_ the patchset is in?
>
> That's fine with me. I have one more question about this patch series
> though: if you mention 64-bit LUNs, are you referring to multi-level
> LUNs only or also to so-called extended LUNs ? I think the byte
> reordering done by scsilun_to_int() is fine for multi-level LUNs but
> unnatural for extended LUNs. As an example, in SAM-5 the format for
> eight byte extended LUNs is defined as follows (paragraph 4.7.7.5.3):
>
> byte 0: address method (3), length (2) and extended address method (2)
> bytes 1..7: long extended flat space LUN with the MSB in byte 1 and LSB
> in byte 7.
>
> Today scsilun_to_int() does not preserve the MSB..LSB byte order for
> extended LUNs. I think if we want to preserve the byte order in
> scsilun_to_int() that that function will have to be made dependent on
> the LUN addressing method. That would make scsilun_to_int() more
> complex. Hence the proposal to cache the SCSI LUN such that the
> queuecommand() functions are not slowed down by a call into
> int_to_scsilun().

The only constant with LUNs is that T10 will keep tinkering with
them. The original LUNs were 3 bits long embedded in the cdb.
Today we have 65 bit LUNs (the 64 you have been looking at
and LU_CONG in the INQUIRY response). Decoding LUNs is best
avoided if possible.

int_to_scsilun() was a hack that made 16 bit LUNs look half
reasonable as integers. Beyond 16 bits, it just looks like
a random number generator. As long as the "int" that is
produced can be mapped to a T10 LUN and vice versa, it doesn't
matter.

Doug Gilbert


