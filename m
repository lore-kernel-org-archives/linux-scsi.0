From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: use_10_for_ms revisited?
Date: Sun, 29 Jun 2003 13:58:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EFF28AC.104@pobox.com>
References: <3EFE8784.4000101@pobox.com> <20030629102222.GA14962@win.tue.nl> <3EFF14BD.3030406@pobox.com> <20030629173632.GA15024@win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9874 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265712AbTF2Rn4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 13:43:56 -0400
In-Reply-To: <20030629173632.GA15024@win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: linux-scsi@vger.kernel.org

Andries Brouwer wrote:
> Two that I have right here yield 0 80 2 2 20 0 0 0 and
> 0 80 0 2 1F 0 0 0, respectively. (All in hex.)

Ok, you've convinced me I found an ATAPI-only rule that doesn't apply to 
USB :)  Thanks.


> [I did introduce this use_10_for_ms; it allows a very large
> cleanup in the usb-storage code. Submitted the SCSI part of
> the patch and waited for it to be applied. That took a while
> and when it went in I was a bit short on Linux time. So Matt
> got impatient and started doing the rest himself. He patched
> sr.c - something I would not have done, I considered the SCSI
> part settled - perhaps things broke a bit but James went in and
> fixed some things again. So maybe we are now again ready for
> the intended large cleanup. I would like to see that done,
> and afterwards see this area stable for a few kernel versions.]

I would still prefer to detect "MMC", at least in ATAPI's case, and then 
use that flag to trickle down knowledge to use_10_for_ms and similar 
features.  ATAPI is even easier than I was previously thinking:  at 
host-alloc time, we already know the devices will be MMC, and never ever 
want 6-byte commands.

I grant you that ATAPI is not the whole world, here, but it presents 
sufficient cases to warrant a common approach.  Both ide-scsi and usb 
storage (and my ata-scsi driver) have atapi-specific logic in them for 
6-to-10 translation.  We can keep adding hueristic upon hueristic to the 
kernel to handle these things, or we can step back, look at the bigger 
picture, and take advantage of the commonality found.


Stepping back a bit and addressing previous "standards versus reality" 
comments (<grin>), I certainly understand the point, and am used to such 
things in all areas of hardware :)  My main point was that -- at least 
wrt ATAPI -- the scsi MMC standards seem to be moving in the direction 
of codifying _existing practice_, not making up new standards.  IOW, 
they are just writing down the things that have been in the field for years.

	Jeff



