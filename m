From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 07/24] arm: scsi convert to accessors and !use_sg cleanup
Date: Wed, 12 Sep 2007 08:42:05 +0100
Message-ID: <20070912074205.GB2653@flint.arm.linux.org.uk>
References: <46E6F92D.2090409@panasas.com> <46E72AE7.4030507@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58608 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764468AbXILHor (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Sep 2007 03:44:47 -0400
Content-Disposition: inline
In-Reply-To: <46E72AE7.4030507@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Jeff Garzik <jeff@garzik.org>, "David S. Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>

On Wed, Sep 12, 2007 at 02:55:19AM +0300, Boaz Harrosh wrote:
> -		if (SCpnt->request_bufflen != len)
> +		if (scsi_bufflen(SCpnt) != len) {
> +			WARN_ON(1);

NAK.  The call trace generally doesn't provide any additional information
on the cause of the error.

>  			printk(KERN_WARNING "scsi%d.%c: bad request buffer "
>  			       "length %d, should be %ld\n", SCpnt->device->host->host_no,
> -			       '0' + SCpnt->device->id, SCpnt->request_bufflen, len);
> -		SCpnt->request_bufflen = len;
> +			       '0' + SCpnt->device->id, scsi_bufflen(SCpnt), len);
> +		}
>  #endif
>  	} else {
> -		SCpnt->SCp.ptr = (unsigned char *)SCpnt->request_buffer;
> -		SCpnt->SCp.this_residual = SCpnt->request_bufflen;
> -		SCpnt->SCp.phase = SCpnt->request_bufflen;
> -	}
> -
> -	/*
> -	 * If the upper SCSI layers pass a buffer, but zero length,
> -	 * we aren't interested in the buffer pointer.
> -	 */
> -	if (SCpnt->SCp.this_residual == 0 && SCpnt->SCp.ptr) {
> -#if 0 //def BELT_AND_BRACES
> -		printk(KERN_WARNING "scsi%d.%c: zero length buffer passed for "
> -		       "command ", SCpnt->host->host_no, '0' + SCpnt->target);
> -		__scsi_print_command(SCpnt->cmnd);
> -#endif
>  		SCpnt->SCp.ptr = NULL;
> +		SCpnt->SCp.this_residual = 0;
> +		SCpnt->SCp.phase = 0;
>  	}
>  }

Also NAK.  This was added due to bad behaviour of the SCSI layer and
was found to be necessary.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
