From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Tue, 8 Nov 2005 15:05:36 -0800
Message-ID: <20051108230536.GB5388@us.ibm.com>
References: <1131401153.3333.6.camel@mulgrave> <Pine.LNX.4.44L0.0511081203280.4438-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:21895 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S1030391AbVKHXFa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Nov 2005 18:05:30 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0511081203280.4438-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, thomas schorpp <t.schorpp@gmx.de>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Timothy Thelin <Timothy.Thelin@wdc.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> wrote:
> ===================================================================
> --- usb-2.6.orig/include/scsi/scsi_device.h
> +++ usb-2.6/include/scsi/scsi_device.h
> @@ -161,7 +161,8 @@ struct scsi_target {
>  	unsigned int		channel;
>  	unsigned int		id; /* target id ... replace
>  				     * scsi_device.id eventually */
> -	unsigned long		create:1; /* signal that it needs to be added */
> +	unsigned int		create:1; /* signal that it needs to be added */
> +	unsigned int		no_report_lun:1; /* do not use REPORT LUNS */
>  	char			scsi_level;
>  	void 			*hostdata; /* available to low-level driver */
>  	unsigned long		starget_data[0]; /* for the transport */

Alan,

Instead of adding a new bit field to scsi_target could we utilize bflags
in the scsi_target. Currently we have sdev_bflags in the scsi_device which
we are not utilizing. We could remove sdev_bflags and add a bflags to
scsi_target

In the usb slave configure we could "or" in BLIST_NOREPORTLUN.

Then in the function scsi_get_device_flags we could reference the
scsi_target bflags instead of sdev_bflags.

The bflags check in scsi_scan.c for BLIST_NOREPORTLUN could stay the same
and we would not have two flags for a similar no report luns check.

-andmike
--
Michael Anderson
andmike@us.ibm.com
