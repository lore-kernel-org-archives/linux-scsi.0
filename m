From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Re: libata:  BLKFLSBUF ioctl broken
Date: Fri, 22 Oct 2004 17:14:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098461668.19463.22.camel@localhost.localdomain>
References: <4178244E.1060906@rtr.ca> <20041022040423.GA28782@havoc.gtf.org>
	 <41791728.7060106@rtr.ca>  <41793E68.6010000@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:26849 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S266512AbUJVRRP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 13:17:15 -0400
In-Reply-To: <41793E68.6010000@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mark Lord <lsml@rtr.ca>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

On Gwe, 2004-10-22 at 18:07, Jeff Garzik wrote:
> Ok, I think I see what's going on.  Can you get your users to try the 
> attached patch?

This patch is definitely wrong.

> Maybe libata should be returning ENOTTY, but that's _quite_ nonsensical 
> considering that EOPNOTSUPP describes the error much better (and is a 
> standard I-don't-support-that-operation return code in tons of other 
> Linux ioctl-handling code).

libata should be returning -ENOTTY "I don't know what you are talking
about", and the core block layer will then fallback and do generic
handling

-EOPNOTSUPP is saying "I do know what is going on but its broken so
fail it totally".


