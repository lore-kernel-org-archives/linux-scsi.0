From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Fri, 28 Feb 2014 09:01:31 -0800
Message-ID: <20140228170131.GA31510@infradead.org>
References: <1392286032-85036-1-git-send-email-hare@suse.de>
 <1392286032-85036-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37770 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaB1RBk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Feb 2014 12:01:40 -0500
Content-Disposition: inline
In-Reply-To: <1392286032-85036-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On Thu, Feb 13, 2014 at 11:07:11AM +0100, Hannes Reinecke wrote:
> EVPD page 0x83 is used to uniquely identify the device.
> So instead of having each and every program issue a separate
> SG_IO call to retrieve this information it does make far more
> sense to display it in sysfs.

This just shows binary data from the protocol, so shouldn't it be a
binary sysfs attribute?

In general I have to I prefer the actual text attributes, but this is
still better than having to do all the SG_IO inquirys.

> - * Returns 0 on success or a negative error number.
> + * Returns size of the vpg page on success or a negative error number.
>   */
>  static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
>  							u8 page, unsigned len)
> @@ -962,6 +962,9 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
>  	int result;
>  	unsigned char cmd[16];
>  
> +	if (len < 4)
> +		return -EINVAL;

Seems the change in calling conventions for these existing functions
should be split into a separate patch?

>  /**
> + * scsi_attach_vpd - Attach Vital Product Data to a SCSI device structure
> + * @sdev: The device to ask
> + *
> + * Attach the 'Device Identification' VPD page (0x83) to a SCSI device
> + * structure. This information can be used to identify the device
> + * uniquely.
> + */
> +void scsi_attach_vpd(struct scsi_device *sdev)
> +{
> +	int result, i;
> +	int vpd_len = 255;
> +	int pg83_supported = 0;
> +	unsigned char *vpd_buf;
> +
> +	if (sdev->skip_vpd_pages)
> +		return;
> +retry_pg0:
> +	vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
> +	if (!vpd_buf)
> +		return;
> +
> +	/* Ask for all the pages supported by this device */
> +	result = scsi_vpd_inquiry(sdev, vpd_buf, 0, vpd_len);
> +	if (result < 0) {
> +		kfree(vpd_buf);
> +		return;
> +	}
> +	if (result > vpd_len) {
> +		vpd_len = result;
> +		kfree(vpd_buf);
> +		goto retry_pg0;
> +	}
> +
> +	for (i = 4; i < result; i++) {
> +		if (vpd_buf[i] == 0x83) {
> +			pg83_supported = 1;
> +		}
> +	}
> +	kfree(vpd_buf);

Given how many checks all over the place we have which EVPD pages are
suppored shouldn't we have query for evpd 0, and then set flags in the
scsi device which are present?

Either way I think the call to query evpd 0 should be a separate
function, so even if we don't store the information it's abstracted out.


Also the ses code has another query for 0x83, which now could use the
one attached to the scsi_device.
