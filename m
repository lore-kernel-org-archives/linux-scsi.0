From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] zfcp: Test kmalloc failure in scsi_get_vpd_page()
Date: Wed, 04 Nov 2009 18:18:09 +0200
Message-ID: <4AF1A941.3080808@panasas.com>
References: <4A92BE18.50208@gmail.com>	 <1251416731.27356.8.camel@mulgrave.site>  <4A9A6676.8050304@panasas.com>	 <1251642902.10135.4.camel@mulgrave.site>	 <1257273187.9427.22.camel@mulgrave.site>  <4AF14147.4050102@panasas.com> <1257347360.2697.20.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:23631 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756743AbZKDQSH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 11:18:07 -0500
In-Reply-To: <1257347360.2697.20.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Roel Kluin <roel.kluin@gmail.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 11/04/2009 05:09 PM, James Bottomley wrote:
> On Wed, 2009-11-04 at 10:54 +0200, Boaz Harrosh wrote:
>>> +
>>> +	if (i < buf[3] && i > buf_len)
>>> +		/* ran off the end of the buffer, give us benefit of doubt */
>>> +		goto found;
>>
>> Some cheep devices are known to break when asked for pages they do not support
>> better return an -ETOOSMALL the user can check for. (And the comment above should
>> also take care of it)
> 
> OK, so I struggled with this.  The reason for the behaviour is  that
> only USB devices with incredibly small page lists are likely to exhibit
> the problem.  Whereas the page lists in array type devices are likely to
> grow.  I don't want to run into the situation that your new $10m array
> suddenly gives an error with DIF/DIX because the page list is too big
> and the problem this is checking for only afflicts cheap and badly
> implemented HW.
> 

If I remember the standard correctly and from inspecting the code 260 is the
maximum size for page 0. (And the maximum we supported until today for page
0 was 256) so there is no speculations here. 256 it should be. If you want
you can do an:

	if (i < buf[3] && i > buf_len) {
		if (likely(buf_len >= 255))
			/* ran off the end of the buffer, give us benefit of doubt */
			goto found;
		else
			return -ETOOSMALL;
	}

which is only theoretical because we only check against buf[3] that cannot
be more then 255 so all is left is return -ETOOSMALL;

Callers that allocate smaller then 256 for this (hence the comment)
must check for -ETOOSMALL;. Or should call with >= 256.

<snip>
>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>>> index 9093c72..fd1bd8f 100644
>>> --- a/drivers/scsi/sd.c
>>> +++ b/drivers/scsi/sd.c
>>> @@ -1864,19 +1864,20 @@ void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
>>>  static void sd_read_block_limits(struct scsi_disk *sdkp)
>>>  {
>>>  	unsigned int sector_sz = sdkp->device->sector_size;
>>> -	char *buffer;
>>> +	const int vpd_len = 32;
>>> +	unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);
>>>  
>>
>> 32 sounds two small for me. Not because of the page but because of the
>> first pass. Why not just 255 as a rule. We kmalloc it anyway.
> 
> It only needs 16 if you look at the code.  32 is actually the smallest
> kmalloc slab on 32 bit systems.
> 

>> We used to allocate 255 here, for some devices out there this is surly
>> a regression.
> 
> We did 255 because we were concerned about space for the page list ...
> hopefully I answered that one above.
> 

No, I still disagree. Whats the point of checking at all? Surly there is a device
out there that has more then 12 pages but will breaks with wrong page. So what's
the limit? the standards say 260 why not stick with that. It's not at any hot path.

> James
> 
> 

Boaz
