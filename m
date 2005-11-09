From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security
 in usb-storage driver
Date: Wed, 9 Nov 2005 10:35:52 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0511091015200.5129-100000@iolanthe.rowland.org>
References: <20051108230536.GB5388@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54193 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751421AbVKIPfx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Nov 2005 10:35:53 -0500
In-Reply-To: <20051108230536.GB5388@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, thomas schorpp <t.schorpp@gmx.de>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Timothy Thelin <Timothy.Thelin@wdc.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Tue, 8 Nov 2005, Mike Anderson wrote:

> Alan,
> 
> Instead of adding a new bit field to scsi_target could we utilize bflags
> in the scsi_target. Currently we have sdev_bflags in the scsi_device which
> we are not utilizing. We could remove sdev_bflags and add a bflags to
> scsi_target
> 
> In the usb slave configure we could "or" in BLIST_NOREPORTLUN.
> 
> Then in the function scsi_get_device_flags we could reference the
> scsi_target bflags instead of sdev_bflags.
> 
> The bflags check in scsi_scan.c for BLIST_NOREPORTLUN could stay the same
> and we would not have two flags for a similar no report luns check.

That's a good idea.  Except that we should keep sdev_bflags while adding 
target_bflags.

I see there's a comment in scsi_probe_lun:

                /*
                 * Get any flags for this device.
                 *
                 * XXX add a bflags to Scsi_Device, and replace the
                 * corresponding bit fields in Scsi_Device, so bflags
                 * need not be passed as an argument.
                 */

Does that need to be updated?

There are several other flags in scsi_device that are duplicates of things
in bflags:

	lockable		BLIST_NOT_LOCKABLE
	use_10_for_ms		BLIST_USE_10_BYTE_MS
	use_192_bytes_for_3f	BLIST_MS_192_BYTES_FOR_3F
	skip_ms_page_8		BLIST_MS_SKIP_PAGE_08
	skip_ms_page_3f		BLIST_MS_SKIP_PAGE_3F
	no_start_on_add		BLIST_NOSTARTONADD
	retry_hwerr		BLIST_RETRY_HWERROR

Maybe I've missed some.  Then there are flags which aren't used any more,
like BLIST_INQUIRY_36 (although for backward compatibility we should try
to keep them).  Note also that some of these flags apply to individual
LUNs while others apply to entire targets.

There's a good reason for storing these flags in the device or target.  
If they're available only in the blacklist database then drivers can't 
adjust them for specific devices.  Ideally, once that structures have been 
set up and the blacklist flags copied into them, there will be no need to 
refer back to the original database entry.

The whole situation is thoroughly disorganized.  If you would like to 
rearrange everything, you've got my support.

Alan Stern

