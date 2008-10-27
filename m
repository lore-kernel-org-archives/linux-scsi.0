From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: detect missing data for INQUIRY
Date: Mon, 27 Oct 2008 11:37:55 -0500
Message-ID: <1225125475.5146.24.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0810271212130.2296-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47712 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbYJ0Qh7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2008 12:37:59 -0400
In-Reply-To: <Pine.LNX.4.44L0.0810271212130.2296-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: =?ISO-8859-1?Q?=D6rjan?= Nordlund <orjan.nordlund@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2008-10-27 at 12:18 -0400, Alan Stern wrote:
> This patch (as1154) fixes a problem in scsi_probe_lun(): The function
> doesn't check whether the device has actually sent back any INQUIRY
> data!  The patch adds a test to see if the result buffer is still
> empty after the command has been executed.
> 
> This enables the Thecus N2050 storage device to work.  The firmware on
> that device starts up strangely; it sends no data in response to the
> initial INQUIRY, and it sends the INQUIRY information in response to
> the followup REQUEST SENSE!  But after that it works better, so
> retrying the INQUIRY is enough to get it going.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> This should get into 2.6.28.
> 
> 
> Index: usb-2.6/drivers/scsi/scsi_scan.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_scan.c
> +++ usb-2.6/drivers/scsi/scsi_scan.c
> @@ -602,6 +602,13 @@ static int scsi_probe_lun(struct scsi_de
>  				    (sshdr.ascq == 0))
>  					continue;
>  			}
> +		} else {
> +			/*
> +			 * Additional Length and Vendor fields missing
> +			 * probably means nothing was transferred.  Try again.
> +			 */
> +			if (inq_result[4] == 0 && inq_result[8] == 0)
> +				continue;

Really, no.

A legitimate minimal response from a device is zero in the additional
length field.  If it does that, then the vendor field is bound to be
zero as well.

About the best we can do is check the first four fields.  For them to be
all zero, it would have to be a minimal response SCSI-1 device (RDF of
zero) ... hopefully they're all dead by now.

James


