From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Blacklist devices that falsely claim an echo buffer
Date: 06 Dec 2004 08:59:13 -0600
Message-ID: <1102345160.2018.1.camel@mulgrave>
References: <20041203201937.GJ29370@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:30419 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261479AbULFO71 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Dec 2004 09:59:27 -0500
In-Reply-To: <20041203201937.GJ29370@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-12-03 at 14:19, Matthew Wilcox wrote:
> +	if ((sreq->sr_device->scsi_level < SCSI_3) &&
> +		((buffer[0] & 0xfe) || buffer[1] || (buffer[2] & 0xe0))) {
> +		/* Device is probably lying to us.  Skip write tests. */
> +		SPI_PRINTK(sreq->sr_device->sdev_target, KERN_INFO,
> +				"Target reports bogus echo buffer\n");
> +		return 0;
> +	}
> +

Well ... I'm not very keen on this.  Does the device support LVD?  i.e.
could we use the sreq->sr_device->ppr flag as a discriminator?  Write
echo buffer tests are really most useful for validating high LVD
transfer speeds, so it wouldn't be unreasonable simply to skip them if
the device isn't ppr capable.

James


