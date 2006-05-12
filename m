From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [BUG 2.6.17-git] kmem_cache_create: duplicate cache scsi_cmd_cache
Date: Fri, 12 May 2006 21:58:04 +0100
Message-ID: <20060512205804.GD17120@flint.arm.linux.org.uk>
References: <20060511151456.GD3755@harddisk-recovery.com> <15ddcffd0605112153q57f139a1k7068e204a3eeaf1f@mail.gmail.com> <20060512171632.GA29077@harddisk-recovery.com> <Pine.LNX.4.64.0605121024310.3866@g5.osdl.org> <1147456038.3769.39.camel@mulgrave.il.steeleye.com> <1147460325.3769.46.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0605121209020.3866@g5.osdl.org> <20060512203850.GC17120@flint.arm.linux.org.uk> <Pine.LNX.4.64.0605121346060.3866@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:18442 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S1750787AbWELU6N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 16:58:13 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0605121346060.3866@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Erik Mouw <erik@harddisk-recovery.com>, Or Gerlitz <or.gerlitz@gmail.com>, linux-scsi@vger.kernel.org, axboe@suse.de, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>

On Fri, May 12, 2006 at 01:50:46PM -0700, Linus Torvalds wrote:
> On Fri, 12 May 2006, Russell King wrote:
> > Great, I'm fucked by the SCSI folk again.
> 
> No, you introduced a regression. This isn't the SCSI layer being evil, 
> this is the "regressions aren't acceptable".

No - I introduced a correct fix.

I think actually we're heading towards needing Linux V2 - the rewrite.
It seems that fixing simple bugs cause other bugs, and that means we're
heading into a maintainability nightmare.

> > Can we revert the patch which broke the MMC/SD layer - the one which
> > added the mount/unmount hotplug events as well then.
> > 
> > That way we get back to a working MMC/SD layer as well as a working
> > SCSI layer.
> 
> That's certainly the logical fix - push the pain up the chain to the 
> person who introduced it. Which commit is that, do you know?

No idea I'm afraid, and since I've had a _really_ extremely shitty couple
of days I'm not about to start going to look for it.

> Really, the added ref-count should be gotten by whoever holds on to the 
> thing, and it sounds like it's the hotplug event that caused this and 
> should have held on to its hotplug reference.

... which would be the genhd layer - it's keeping the driverfs_dev
around so that the genhd layer can generate hotplug events using it
at mount/umount time.  Thanks for just re-confirming my original fix
and that it's SCSI which is the real problem. 8)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 Serial core
