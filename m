From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] [PATCH]indistinguishable devices with broken and
 unbroken firmware
Date: Wed, 7 Feb 2007 13:40:28 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0702071339230.4502-100000@iolanthe.rowland.org>
References: <200702071522.39529.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57410 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422695AbXBGSkb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 13:40:31 -0500
In-Reply-To: <200702071522.39529.oneukum@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org

On Wed, 7 Feb 2007, Oliver Neukum wrote:

> --- a/drivers/scsi/sd.c	2007-02-06 14:14:48.000000000 +0100
> +++ b/drivers/scsi/sd.c	2007-02-07 15:14:01.000000000 +0100
> @@ -1273,6 +1273,13 @@
>  	if (sdp->fix_capacity)
>  		--sdkp->capacity;
>  
> +	/* Some devices have version which report the correct sizes
> +	 * and others which do not. We guess size according to a heuristic
> +	 * and err on the side of lowering the capacity. */
> +	if (sdp->guess_capacity)
> +		if (sdkp->capacity & 0x01) /* odd sizes are odd */
> +			--sdkp->capacity;

Please make this "else if ...".  Just in case somebody ever manages to set 
both sdp->fix_capacity and sdp->guess_capacity.

Otherwise it looks reasonable to me.

Alan Stern

