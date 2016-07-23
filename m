From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 1/5] sd: configure ZBC devices
Date: Sat, 23 Jul 2016 22:31:28 +0200
Message-ID: <a3d658d8-ad55-2888-aca5-d30476767526@suse.com>
References: <1468934710-93876-1-git-send-email-hare@suse.de>
 <1468934710-93876-2-git-send-email-hare@suse.de>
 <1469224578.4042.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:52034 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbcGWUbu (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Sat, 23 Jul 2016 16:31:50 -0400
In-Reply-To: <1469224578.4042.34.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@hgst.com>

On 07/22/2016 11:56 PM, Ewan D. Milne wrote:
> On Tue, 2016-07-19 at 15:25 +0200, Hannes Reinecke wrote:
>> For ZBC devices I/O must not cross zone boundaries, so setup
>> the 'chunk_sectors' block queue setting to the zone size.
>> This is only valid for REPORT ZONES SAME type 2 or 3;
>> for other types the zone sizes might be different
>> for individual zones. So issue a warning if the type is
>> found to be different.
>> Also the capacity might be different from the announced
>> capacity, so adjust it as needed.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
> 
> ...
> 
>> +static void sd_read_zones(struct scsi_disk *sdkp, unsigned char *buffer)
>> +{
>> +	int retval;
>> +	unsigned char *desc;
>> +	u32 rep_len;
>> +	u8 same;
>> +	u64 zone_len, lba;
>> +
>> +	if (sdkp->zoned != 1)
>> +		/* Device managed, no special handling required */
>> +		return;
>> +
>> +	retval = sd_zbc_report_zones(sdkp, buffer, SD_BUF_SIZE,
>> +				     0, ZBC_ZONE_REPORTING_OPTION_ALL, false);
>> +	if (retval < 0)
>> +		return;
>> +
>> +	rep_len = get_unaligned_be32(&buffer[0]);
>> +	if (rep_len < 64) {
>> +		sd_printk(KERN_WARNING, sdkp,
>> +			  "REPORT ZONES report invalid length %u\n",
>> +			  rep_len);
>> +		return;
>> +	}
>> +
>> +	if (sdkp->rc_basis == 0) {
>> +		/* The max_lba field is the capacity of a zoned device */
>> +		lba = get_unaligned_be64(&buffer[8]);
>> +		if (lba + 1 > sdkp->capacity) {
>> +			sd_printk(KERN_WARNING, sdkp,
>> +				  "Max LBA %zu (capacity %zu)\n",
>> +				  (sector_t) lba + 1, sdkp->capacity);
>> +			sdkp->capacity = lba + 1;
>> +		}
>> +	}
>> +
>> +	/*
>> +	 * Adjust 'chunk_sectors' to the zone length if the device
>> +	 * supports equal zone sizes.
>> +	 */
>> +	same = buffer[4] & 0xf;
>> +	if (same == 0 || same > 3) {
>> +		sd_printk(KERN_WARNING, sdkp,
>> +			  "REPORT ZONES SAME type %d not supported\n", same);
>> +		return;
>> +	}
>> +	/* Read the zone length from the first zone descriptor */
>> +	desc = &buffer[64];
>> +	zone_len = logical_to_sectors(sdkp->device,
>> +				      get_unaligned_be64(&desc[8]));
>> +	blk_queue_chunk_sectors(sdkp->disk->queue, zone_len);
>> +}
>> +
> 
> So, blk_queue_chunk_sectors() has:
> 
> void blk_queue_chunk_sectors(struct request_queue *q, unsigned int chunk_sectors)
> {
>         BUG_ON(!is_power_of_2(chunk_sectors));
>         q->limits.chunk_sectors = chunk_sectors;
> }
> 
> and it seems like if some device reports a non-power-of-2 zone_len then we
> will BUG_ON().  Probably would be better if we reported an error instead?
> 
The ZBC spec mandates that the zone size must be a power of 2.
So I don't have problems with triggering a BUG_ON for non-compliant
drives.

Cheers,

Hannes

