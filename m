From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Sun, 22 Jun 2008 12:44:36 -0600
Message-ID: <20080622184435.GB4392@parisc-linux.org>
References: <20080619160342.GJ4392@parisc-linux.org> <1214141931.4047.5.camel@localhost.localdomain> <20080622140323.GZ4392@parisc-linux.org> <yq14p7lttuo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51496 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbYFVSoh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jun 2008 14:44:37 -0400
Content-Disposition: inline
In-Reply-To: <yq14p7lttuo.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Sun, Jun 22, 2008 at 10:41:35AM -0400, Martin K. Petersen wrote:
> +	memset(cmd, 0, 16);
> +	cmd[0] = INQUIRY;
> +	cmd[1] = 1;		/* EVPD */
> +	cmd[2] = page;		/* VPD page */
> +	cmd[3] = len;

This looks like a bug to me.

The MSB of the length is supposed to be in byte 3 and the LSB in byte 4.
So you're asking for much more data than could fit in the buffer --
fortunately the device won't be able to return as much as you ask for,
so the buffer won't overflow.

> +	result = scsi_execute_req(sdkp->device, cmd, DMA_FROM_DEVICE, buffer,
> +				  len, &sshdr, SD_TIMEOUT, SD_MAX_RETRIES);
> +
> +	if (media_not_present(sdkp, &sshdr))
> +		return -EIO;
> +
> +	if (result) {
> +		sd_printk(KERN_ERR, sdkp, "EVPD Inquiry failed\n");
> +		return -EIO;
> +	}
> +
> +	if (buffer[1] != page) {
> +		sd_printk(KERN_ERR, sdkp, "Page code not %2x (%2x)\n", page,
> +			  buffer[1]);
> +		return -EIO;
> +	}
> +
> +	return buffer[3];

This isn't true for all pages.  For example, 0x83 and 0x85 have a length in
buffer[2] and [3].  Now, all other pages I've looked at reserve byte 2,
and devices should be setting that to 0 ... but I wouldn't feel right
depending on it.  For scsi_request_vpd(), I think we should return 0 for
success and -Error.  The caller knows which page it requested and can
find out the length for itself.

> +static int sd_get_vpd_page(struct scsi_disk *sdkp, unsigned char *buffer, u8 page, u8 len)
> +{
> +	int i, result;
> +
> +	/* Get Supported Pages list */
> +	if (sd_vpd_inquiry(sdkp, buffer, 0x0, 255) < 0)
> +		return -1;
> +
> +	for (i = 0 ; i < buffer[3] ; i++)
> +		if (buffer[4+i] == page)
> +			goto found;
> +
> +	return -1;
> +
> +found:
> +	result = sd_vpd_inquiry(sdkp, buffer, page, len);
> +
> +	if (result < 0)
> +		return -1;
> +
> +	if (buffer[3] != len)
> +		sd_printk(KERN_ERR, sdkp, "VPD pg %x, req. %u bytes, got %u\n",
> +			  page, len, buffer[3]);
> +
> +	return result;
> +}

Yes, this refactoring is exactly what I had in mind.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
