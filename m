From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 5 of 8] sd: Detect non-rotational devices
Date: Thu, 23 Apr 2009 14:03:18 +0200
Message-ID: <20090423120317.GF4593@kernel.dk>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <d14109aa6209be628074.1240464572@sermon.lab.mkp.net> <20090423105245.GX4593@kernel.dk> <49F04C71.6050304@garzik.org> <20090423113841.GK1926@parisc-linux.org> <49F057DD.6090009@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49F057DD.6090009@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>, "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 23 2009, Jeff Garzik wrote:
> Matthew Wilcox wrote:
>> On Thu, Apr 23, 2009 at 07:09:37AM -0400, Jeff Garzik wrote:
>>> Jens Axboe wrote:
>>>>> +	/* Block Device Characteristics VPD */
>>>>> +	buffer = scsi_get_vpd_page(sdkp->device, 0xb1);
>>>>> +
>>>>> +	if (buffer == NULL)
>>>>> +		return;
>>>>> +
>>>>> +	rot = get_unaligned_be16(&buffer[4]);
>>>> Make sure this works for libata as well, and then kill the rotational
>>>> check in there instead.
>>> Yep.  libata-scsi.c would need to simulate that VPD page.
>>
>> I already did that.  The only problem is that you made me include the stupid:
>>
>>         if (ata_id_major_version(args->id) > 7) {
>>
>> so of course it doesn't work on any existing hardware.  How about
>> applying this patch:
>>
>> ----
>>
>> libata: fill in b1 page for all drives, not just ATA-8
>>
>> Some of the drives on the market fill in the rotational speed and form
>> factor correctly, even though they claim support for an earlier version
>> of ATA.  The current ata_id_is_ssd() code doesn't check the version
>> number and doesn't appear to have caused any trouble.  Besides, SCSI devices
>> are also capable of returning garbage in these fields.
>>
>> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
>>
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 2733b0c..59358ca 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -2144,11 +2144,9 @@ static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
>>  {
>>  	rbuf[1] = 0xb1;
>>  	rbuf[3] = 0x3c;
>> -	if (ata_id_major_version(args->id) > 7) {
>> -		rbuf[4] = args->id[217] >> 8;
>> -		rbuf[5] = args->id[217];
>> -		rbuf[7] = args->id[168] & 0xf;
>> -	}
>> +	rbuf[4] = args->id[217] >> 8;
>> +	rbuf[5] = args->id[217];
>> +	rbuf[7] = args->id[168] & 0xf;
>
> Thus returning undefined garbage for the vast majority of ATA devices?  
> Might as well admit that a call to get_random_bytes() is a valid  
> implementation, at that point.
>
> Linux users deserve more than that :)
>
> If you want to find a better test than "version > 7", that is fine.
>
> Surely a few minutes of thinking and a few minutes of research will  
> yield a reasonable hueristic, that gives a reasonable estimation of  
> when/if these fields are valid?
>
> linux/ata.h is filled with examples of proper range checking -- ensuring  
> that a range of IDENTIFY DEVICE words are valid.  There are also typical  
> tests such as assuming values other than 0x0000 and 0xffff are valid.
>
>
>>> Also (to mkp or whoever does the work) -- note Linus's comment, and 
>>> my provisional patch[1], about libata potentially wanting to detect 
>>> NONROT by looking for "*SSD" from IDENTIFY DEVICE'S model string.
>>
>> Found it ... and Jens' suggestion that this be done in userspace instead.
>
> It is trivial to do in the kernel, where we already match against model  
> info for a long list of quirks.
>
> Therefore, I think the Just Works(tm) value to SSD owners is higher.  
> That way old userlands work with SSDs too.

But it's just as easy to do in udev, it's just a one-line udev rule.
Don't care much either way, though.

-- 
Jens Axboe

