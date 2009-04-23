From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 5 of 8] sd: Detect non-rotational devices
Date: Thu, 23 Apr 2009 13:13:37 +0200
Message-ID: <20090423111336.GZ4593@kernel.dk>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <d14109aa6209be628074.1240464572@sermon.lab.mkp.net> <20090423105245.GX4593@kernel.dk> <49F04C71.6050304@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49F04C71.6050304@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 23 2009, Jeff Garzik wrote:
> Jens Axboe wrote:
>>> +static void sd_read_block_characteristics(struct scsi_disk *sdkp)
>>> +{
>>> +	char *buffer;
>>> +	u16 rot;
>>> +
>>> +	/* Block Device Characteristics VPD */
>>> +	buffer = scsi_get_vpd_page(sdkp->device, 0xb1);
>>> +
>>> +	if (buffer == NULL)
>>> +		return;
>>> +
>>> +	rot = get_unaligned_be16(&buffer[4]);
>>> +
>>> +	if (rot == 1)
>>> +		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, sdkp->disk->queue);
>>> +
>>> +	kfree(buffer);
>>> +}
>>> +
>>> +/**
>>>   *	sd_revalidate_disk - called the first time a new disk is seen,
>>>   *	performs disk spin up, read_capacity, etc.
>>>   *	@disk: struct gendisk we care about
>>> @@ -1836,6 +1860,7 @@ static int sd_revalidate_disk(struct gen
>>>  	 */
>>>  	if (sdkp->media_present) {
>>>  		sd_read_capacity(sdkp, buffer);
>>> +		sd_read_block_characteristics(sdkp);
>>>  		sd_read_write_protect_flag(sdkp, buffer);
>>>  		sd_read_cache_type(sdkp, buffer);
>>>  		sd_read_app_tag_own(sdkp, buffer);
>>> @@ -1976,6 +2001,8 @@ static void sd_probe_async(void *data, a
>>>  	add_disk(gd);
>>>  	sd_dif_config_host(sdkp);
>>>  +	sd_revalidate_disk(gd);
>>> +
>>>  	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
>>>  		  sdp->removable ? "removable " : "");
>>
>> Make sure this works for libata as well, and then kill the rotational
>> check in there instead.
>
> Yep.  libata-scsi.c would need to simulate that VPD page.

Exactly

> Also (to mkp or whoever does the work) -- note Linus's comment, and my  
> provisional patch[1], about libata potentially wanting to detect NONROT  
> by looking for "*SSD" from IDENTIFY DEVICE'S model string.

I think that's an entirely orthogonal issue.

>
> 	Jeff
>
>
> [1] partial subject line, from the big "Ext3 latency fixes" thread):
> "libata: add SSD detection hueristic; move SSD setup to ata_dev_configure"
>
>

-- 
Jens Axboe

