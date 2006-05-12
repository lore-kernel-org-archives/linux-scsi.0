From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [BUG 2.6.17-git] kmem_cache_create: duplicate cache scsi_cmd_cache
Date: Fri, 12 May 2006 21:34:16 +0100
Message-ID: <20060512203416.GA17120@flint.arm.linux.org.uk>
References: <20060511151456.GD3755@harddisk-recovery.com> <15ddcffd0605112153q57f139a1k7068e204a3eeaf1f@mail.gmail.com> <20060512171632.GA29077@harddisk-recovery.com> <Pine.LNX.4.64.0605121024310.3866@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:7437 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S932223AbWELUe0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 16:34:26 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0605121024310.3866@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Erik Mouw <erik@harddisk-recovery.com>, Or Gerlitz <or.gerlitz@gmail.com>, linux-scsi@vger.kernel.org, axboe@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, May 12, 2006 at 10:36:57AM -0700, Linus Torvalds wrote:
> Yes. We could just revert that commit, but it seems correct, and I'd 
> really like for somebody to understand _why_ that commit matters at all. I 
> certainly don't see the overlap here..

Reverting the commit breaks MMC/SD in a very real way, and the fix
is plainly correct and is actually the only possible fix that can be
applied.

It sounds to me like SCSI is relying on some buggy behaviour which is
specific to the way that the kernel works with the fix removed.  Maybe
thing is kfree'ing and then reallocating something which remained
registered somewhere when it shouldn't do?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 Serial core
