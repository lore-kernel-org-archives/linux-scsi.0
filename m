From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI core: always store >= 36 bytes of INQUIRY data
Date: Fri, 27 Oct 2006 14:43:43 -0700
Message-ID: <20061027214343.GA1701@us.ibm.com>
References: <Pine.LNX.4.44L0.0610261709360.9684-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:20420 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1752516AbWJ0Vnq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Oct 2006 17:43:46 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9RLhgR2008454
	for <linux-scsi@vger.kernel.org>; Fri, 27 Oct 2006 17:43:42 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9RLhgOp089144
	for <linux-scsi@vger.kernel.org>; Fri, 27 Oct 2006 17:43:42 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9RLhfxb031017
	for <linux-scsi@vger.kernel.org>; Fri, 27 Oct 2006 17:43:41 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0610261709360.9684-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Oct 26, 2006 at 05:11:27PM -0400, Alan Stern wrote:
> This patch (as810) sets the length of the INQUIRY data to a minimum of
> 36 bytes, even if the device claims that not all of them are valid.
> Using the data sent by the device is better than allocating a short
> buffer and then reading beyond the end of it, which is what we do now.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> Index: usb-2.6/drivers/scsi/scsi_scan.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_scan.c
> +++ usb-2.6/drivers/scsi/scsi_scan.c
> @@ -575,6 +575,19 @@ static int scsi_probe_lun(struct scsi_de
>  	 * short INQUIRY), an abort here prevents any further use of the
>  	 * device, including spin up.
>  	 *
> +	 * On the whole, the best approach seems to be to assume the first
> +	 * 36 bytes are valid no matter what the device says.  That's

The comment is confusing, as it implies the device will modify data past
the indicated length, but well behaved devices should not do that, and
with your patch should point to zero filled data.

Just comment on what its avoiding or such like:

	Modify short inquiry_len values so we don't later point at random
	values. Devices returning an incorrect value in the INQUIRY
	additional length field will point at potentially valid data for
	Vendor, Product and Revsion, while conforming devices will point
	to zero filled data.

But definitely better to use possibly valid data for broken devices or
NUL for well behaved devices rather than garbage values.

> +	 * better than copying < 36 bytes to the inquiry-result buffer
> +	 * and displaying garbage for the Vendor, Product, and Revision
> +	 * strings.
> +	 */
> +	if (sdev->inquiry_len < 36) {
> +		printk(KERN_INFO "scsi scan: INQUIRY result too short (%d),"
> +				" using 36\n", sdev->inquiry_len);
> +		sdev->inquiry_len = 36;
> +	}
> +
> +	/*

-- Patrick Mansfield
