From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Suggested patch for testing last sector of USB devices
Date: Sun, 21 Dec 2008 19:04:33 +0100
Message-ID: <494E8531.3000205@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0812192009210.16918-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53410 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYLUSFT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Dec 2008 13:05:19 -0500
In-Reply-To: <Pine.LNX.4.44L0.0812192009210.16918-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

Alan Stern wrote:
> --- usb-2.6.orig/include/scsi/scsi_device.h
> +++ usb-2.6/include/scsi/scsi_device.h
> @@ -142,6 +142,7 @@ struct scsi_device {
>  	unsigned select_no_atn:1;
>  	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
>  	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
> +	unsigned check_capacity:1;	/* Verify READ_CAPACITY result */

Maybe add "ignored if no USB_STORAGE support is built" to the comment
since it is a no-op otherwise:

> --- usb-2.6.orig/drivers/scsi/sd.c
> +++ usb-2.6/drivers/scsi/sd.c
> @@ -1275,6 +1275,88 @@ disable:
>  	sdkp->capacity = 0;
>  }
>  
> +#if defined(CONFIG_USB_STORAGE) || defined(CONFIG_USB_STORAGE_MODULE)
> +/*
> + * Test disk capacity by trying to read the last sector
> + */
> +static int sd_read_last_sector(struct scsi_disk *sdkp, unsigned char *buffer,
> +		int sector_size)
> +{
...
> +#else
> +static inline int sd_read_last_sector(struct scsi_disk *sdkp,
> +		unsigned char *buffer, int sector_size)
> +{
> +	return 0;
> +}
> +
> +#endif /* defined(CONFIG_USB_STORAGE) || ... */

-- 
Stefan Richter
-=====-==--- ==-- =-=-=
http://arcgraph.de/sr/
