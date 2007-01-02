From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH: SNI RM 53c710 driver
Date: Tue, 2 Jan 2007 11:52:41 +0000
Message-ID: <20070102115241.GD24951@infradead.org>
References: <20061225203204.GB3293@alpha.franken.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38598 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888AbXABLwo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2007 06:52:44 -0500
Content-Disposition: inline
In-Reply-To: <20061225203204.GB3293@alpha.franken.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Mon, Dec 25, 2006 at 09:32:04PM +0100, Thomas Bogendoerfer wrote:
> This patch adds a SCSI driver for the onboard 53c710 chip of some
> SNI RM machines.

Nice, this looks really clean.  I haven't seen the code to declare
the platform devices in the mips queue yet, do you plan to submit it
soon?

> +static int __init snirm710_init(void)
> +{
> +	int err;
> +	
> +	if ((err = platform_driver_register(&snirm710_driver))) {
> +		printk(KERN_ERR "Driver registration failed\n");
> +		return err;
> +	}
> +	return 0;
> +}

Please just write this as:

static int __init snirm710_init(void)
{
	return platform_driver_register(&snirm710_driver)));
}

In the modular case we already get a message from modprobe and in
the builtin-case verbose initcalls also display the error.

