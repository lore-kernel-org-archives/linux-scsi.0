From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] USB enclosures seem to require read(16) with >2TB drives
Date: Mon, 12 Nov 2012 11:33:10 +0000
Message-ID: <1352719990.2449.23.camel@dabdike.int.hansenpartnership.com>
References: <1352477289-8133-1-git-send-email-hernejj@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45851 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654Ab2KLLdO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Nov 2012 06:33:14 -0500
In-Reply-To: <1352477289-8133-1-git-send-email-hernejj@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Jason J. Herne" <hernejj@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, stern@rowland.harvard.edu

On Fri, 2012-11-09 at 11:08 -0500, Jason J. Herne wrote:
> diff --git a/drivers/usb/storage/scsiglue.c
> b/drivers/usb/storage/scsiglue.c
> index 13b8bcd..6ff785e 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -251,6 +251,11 @@ static int slave_configure(struct scsi_device
> *sdev)
>                                         US_FL_SCM_MULT_TARG)) &&
>                                 us->protocol == USB_PR_BULK)
>                         us->use_last_sector_hacks = 1;
> +
> +               /* Force read-16 for large capacity drives. */
> +               sdev->force_read_16 = 1;
> +
> +

This turns READ_16 on unconditionally for all USB disks ... is that
safe?  As in have you tested this with older USB thumb drives?

Also do we have to worry about TYPE_RBC? ... this looks like a bit of a
global omission in usbstorage.c


> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 5591ed5..e92b846 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -134,6 +134,7 @@ struct scsi_device {
>                                      * because we did a bus reset. */
>         unsigned use_10_for_rw:1; /* first try 10-byte read / write */
>         unsigned use_10_for_ms:1; /* first try 10-byte mode
> sense/select */
> +       unsigned force_read_16:1; /* Use read(16) over read(10) */

This should probably be use_16_for_rw:1 for consistency.

James


