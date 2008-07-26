From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: scsi: Generalise last_sector_bug; fixes regression and
	potential future issues on USB cardreaders
Date: Sat, 26 Jul 2008 15:26:15 -0400
Message-ID: <1217100375.3908.12.camel@localhost.localdomain>
References: <4888524D.9070906@tuffmail.co.uk>
	 <4888565B.4020102@tuffmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60388 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbYGZT0s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jul 2008 15:26:48 -0400
In-Reply-To: <4888565B.4020102@tuffmail.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

On Thu, 2008-07-24 at 11:15 +0100, Alan Jenkins wrote:
> The last_sector_bug flag was added to work around a bug in certain usb
> cardreaders, where they would crash if a multiple sector read included the
> last sector. The original implementation avoids this by e.g. splitting an 8
> sector read which includes the last sector into a 7 sector read, and a single
> sector read for the last sector.  The flag is enabled for all USB devices.
> 
> This revealed a second bug in other usb cardreaders, which crash when they
> get a multiple sector read which stops 1 sector short of the last sector.
> Affected hardware includes the Kingston "MobileLite" external USB cardreader
> and the internal USB cardreader on the Asus EeePC.
> 
> Extend the last_sector_bug workaround to ensure that any access which touches
> the last 8 hardware sectors of the device is a single sector long.  Requests
> are shrunk as necessary to meet this constraint.
> 
> This gives us a safety margin against potential unknown or future bugs
> affecting multi-sector access to the end of the device.  The two known bugs
> only affect the last 2 sectors.  However, they suggest that these devices
> are prone to fencepost errors and that multi-sector access to the end of the
> device is not well tested.  Popular OS's use multi-sector accesses, but they
> rarely read the last few sectors.  Linux (with udev & vol_id) automatically
> reads sectors from the end of the device on insertion.  It is assumed that
> single sector accesses are more thoroughly tested during development.
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 01cefbb..2415a1b 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -406,13 +406,23 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
>  	}
>  
>  	/*
> -	 * Some devices (some sdcards for one) don't like it if the
> -	 * last sector gets read in a larger then 1 sector read.
> +	 * Some sd cardreaders can't handle multisector accesses which touch
> +	 * the last one or two hardware sectors.  There are likely to be even
> +	 * buggier devices, so apply a workaround to the last eight sectors.
>  	 */
> -	if (unlikely(sdp->last_sector_bug &&
> -	    rq->nr_sectors > sdp->sector_size / 512 &&
> -	    block + this_count == get_capacity(disk)))
> -		this_count -= sdp->sector_size / 512;
> +	if (sdp->last_sector_bug) {

This should be unlikely() as the previous one was

> +		unsigned threshold = get_capacity(disk) - 8 * (sdp->sector_size / 512);

This can't be an unsigned, it has to be sector_t otherwise it could
overflow on large capacity drives.

I can also see that someone will find a drive that needs the last 16 or
something sectors, so perhaps the bare 8 should be a nice #define in
sd.h (comment above would need altering too).

> +		if (block + this_count <= threshold) {

This should be likely() as well.

> +			;	/* Okay as is */
> +		} else if (block < threshold) {
> +			/* Access up to the threshold but not beyond */
> +			this_count = threshold - block;
> +		} else {
> +			/* Access only a single hardware sector */
> +			this_count = sdp->sector_size / 512;
> +		}
> +	}
>  
>  	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=%llu\n",
>  					(unsigned long long)block));
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index f6a9fe0..0d8d9c1 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -139,7 +139,8 @@ struct scsi_device {
>  	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
>  	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
>  	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
> -	unsigned last_sector_bug:1;	/* Always read last sector in a 1 sector read */
> +	unsigned last_sector_bug:1;	/* do not use multisector accesses on
> +					   the last 8 hardware sectors */
>  
>  	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
>  	struct list_head event_list;	/* asserted events */

Everything else looks fine ... do a quick turn around and I'll slide it
under the merge window.

Thanks,

James


