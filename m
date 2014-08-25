From: subhashj@codeaurora.org
Subject: Re: [PATCH/RFC V2 07/16] scsi: support well known logical units
Date: Mon, 25 Aug 2014 05:26:08 -0000
Message-ID: <17bd9ca5264ba4dea13aa889814a9d99.squirrel@www.codeaurora.org>
References: <82e763120409310e9d6b332854804858.squirrel@www.codeaurora.org>
    <20140824205605.GA30004@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:46875 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaHYF0K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2014 01:26:10 -0400
In-Reply-To: <20140824205605.GA30004@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: subhashj@codeaurora.org, Dolev Raviv <draviv@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

> On Fri, Aug 22, 2014 at 12:02:30AM -0000, subhashj@codeaurora.org wrote:
>> >> +	/*
>> >> +	 * put runtime pm reference for well-known logical units,
>> >> +	 * drivers are expected to _get_* again during probe.
>> >> +	 */
>> >> +	if (scsi_is_wlun(sdev->lun))
>> >> +		scsi_autopm_put_device(sdev);
>> > Special casing the well known LUNs here seems wrong.  Shouldn't we do
>> this
>> > for any devices that don't get a driver attached to them?
>>
>> Agreed, i will replace "if (scsi_is_wlun(sdev->lun))" check with "if
>> (sdev->sdev_gendev.driver)".
>
> I would really prefer the callers of autopm get/put to be symmetric to
> issues with later than probe driver attach or similar.  Think of the
> case say the CDROM or tape driver only gets loaded after we already
> did a bus scan.  A quick check of the autopm code and it's underlying
> implementation seems to suggest that nesting them is okay.  If that's
> indeed the case I would suggest to restructure it the following way:
>
>  - make the scsi_autopm_put_device call you add at the end of
>    scsi_sysfs_add_sdev unconditional to make it balance out
>    the get earlier in the function (and delete the now incorrect comment
>    above the scsi_autopm_get_device call).
>  - let drivers do paired get/put calls in their probe/remove methods.
>
> If you still need any wlun changes after that please send them as a
> separate patch with a detailed description on why you need it.

Thanks, yes I was also thinking on same lines but was not sure if it would
work or not. But let me check this more and if it works, will make a
different patch for it.

> All in all the autopm code and it's underlying implementation is highly
> confusing, so additional documentation on it would also be very welcome.

I would agree but not sure if I would be able to add it now, hopefully
some time in future.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


