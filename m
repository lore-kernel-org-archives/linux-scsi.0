From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 07/24] arm: scsi convert to accessors and !use_sg	cleanup
Date: Fri, 1 Feb 2008 20:10:47 +0000
Message-ID: <20080201201047.GC12138@flint.arm.linux.org.uk>
References: <46E6F92D.2090409@panasas.com> <46E72AE7.4030507@panasas.com> <20070912074205.GB2653@flint.arm.linux.org.uk> <46EFE8FF.3010907@panasas.com> <1197678458.3154.119.camel@localhost.localdomain> <47654421.1030704@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39612 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbYBAUO3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 15:14:29 -0500
Content-Disposition: inline
In-Reply-To: <47654421.1030704@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Jeff Garzik <jeff@garzik.org>, "David S. Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>

On Sun, Dec 16, 2007 at 05:28:33PM +0200, Boaz Harrosh wrote:
> Russell or any other arm person. Please first see if this compiles at all, as I do
> not have a cross compiler set up, and please check that this code works.
> (Should apply on top of Linus latest)

This patch seems to work with one change:

> +				SCpnt->SCp.phase =
> +					min(len, scsi_bufflen(SCpnt));

This min wants to be

+					min_t(unsigned long, len, scsi_bufflen(SCpnt));

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
