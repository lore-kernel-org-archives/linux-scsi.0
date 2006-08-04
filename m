From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] aacraid: Restart adapter on firmware assert
Date: Fri, 4 Aug 2006 16:24:11 +0100
Message-ID: <20060804152411.GB6224@infradead.org>
References: <1154617371.31319.21.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38337 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1161222AbWHDPYO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Aug 2006 11:24:14 -0400
Content-Disposition: inline
In-Reply-To: <1154617371.31319.21.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

> +	if (rkt_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC) {
> +		u32 var;
> +		printk(KERN_ERR "%s%d: adapter kernel panic'd.\n", dev->name, instance);
> +		var = 0;
> +		if ((aac_rkt_check_health(dev) <= 0)
> +		 || rkt_sync_cmd(dev, IOP_RESET, 0, 0, 0, 0, 0, 0,
> +		  &var, NULL, NULL, NULL, NULL)
> +		 || (var != 0x00000001)
> +		 || (rkt_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC))
> +			goto error_iounmap;
> +	}

I know you guys hate me for all that nitpicking, but can we write the
if condition in normal kernel style?  Even better untangle it a little
and put it into a helper function:

static int aac_rkt_restart(<args>)
{
	u32 var;

	printk(KERN_ERR "%s%d: adapter kernel panic'd.\n",
		dev->name, instance);
	if (aac_rkt_check_health(dev) <= 0)
		return 1;
	if (rkt_sync_cmd(dev, IOP_RESET, 0, 0, 0, 0, 0, 0,
			&var, NULL, NULL, NULL, NULL)
		return 1;
	if (var != 0x00000001)
		return 1;
	if (rkt_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC)
		return 1;
	return 0;
}

> +	if (rx_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC) {
> +		u32 var;
> +		printk(KERN_ERR "%s%d: adapter kernel panic.\n", dev->name, instance);
> +		var = 0;
> +		if ((aac_rx_check_health(dev) <= 0)
> +		 || rx_sync_cmd(dev, IOP_RESET, 0, 0, 0, 0, 0, 0,
> +		  &var, NULL, NULL, NULL, NULL)
> +		 || (var != 0x00000001)
> +		 || (rx_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC))
> +			goto error_iounmap;
> +	}

dito

