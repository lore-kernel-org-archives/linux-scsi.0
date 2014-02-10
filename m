From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv2] Add EVPD page 0x83 entries to sysfs
Date: Mon, 10 Feb 2014 06:15:34 -0800
Message-ID: <20140210141534.GA17671@infradead.org>
References: <1392030699-105348-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44906 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaBJOPl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Feb 2014 09:15:41 -0500
Content-Disposition: inline
In-Reply-To: <1392030699-105348-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Jeremy Linton <jlinton@tributary.com>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Mon, Feb 10, 2014 at 12:11:39PM +0100, Hannes Reinecke wrote:
> +	int vpd_len = 255;
> +	unsigned char *buffer;
> +retry:
> +	buffer = kmalloc(vpd_len, GFP_KERNEL);
> +	if (!buffer)
> +		return;
> +
> +	ret = scsi_get_vpd_page(sdev, 0x83, buffer, vpd_len);
> +	if (ret) {
> +		kfree(buffer);
> +		return;
> +	}
> +
> +	vpd_len = (buffer[2] << 8) + buffer[3];
> +	if (vpd_len > 255) {
> +		kfree(buffer);
> +		goto retry;

Won't this create an infinite loop if the VPD is longer than 255 bytes?

