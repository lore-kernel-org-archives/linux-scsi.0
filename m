From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Kernel 3.10.3 "reset SuperSpeed USB device number 2 using
 xhci_hcd"
Date: Wed, 31 Jul 2013 10:50:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1307311049300.1546-100000@iolanthe.rowland.org>
References: <yq1d2pzigf9.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36678 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760250Ab3GaOuU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jul 2013 10:50:20 -0400
In-Reply-To: <yq1d2pzigf9.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, Stuart Foster <smf.linux@ntlworld.com>, Ed Tomlinson <edt@aei.ca>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, stable@vger.kernel.org

On Tue, 30 Jul 2013, Martin K. Petersen wrote:

> James?
> 
> [PATCH] SCSI: Don't attempt to send extended INQUIRY command if skip_vpd_pages is set
> 
> If a device has the skip_vpd_pages flag set we should simply fail the
> scsi_get_vpd_page() call.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Tested-by: Stuart Foster <smf.linux@ntlworld.com>
> Cc: stable@vger.kernel.org
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 3b1ea34..eaa808e 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -1031,6 +1031,9 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
>  {
>  	int i, result;
>  
> +	if (sdev->skip_vpd_pages)
> +		goto fail;
> +
>  	/* Ask for all the pages supported by this device */
>  	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
>  	if (result)

Thanks, Martin.

Alan Stern

