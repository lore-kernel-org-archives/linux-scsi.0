From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [BUG 2.6.17-git] kmem_cache_create: duplicate cache scsi_cmd_cache
Date: Fri, 12 May 2006 23:48:04 +0100
Message-ID: <20060512224804.GT27946@ftp.linux.org.uk>
References: <20060511151456.GD3755@harddisk-recovery.com> <15ddcffd0605112153q57f139a1k7068e204a3eeaf1f@mail.gmail.com> <20060512171632.GA29077@harddisk-recovery.com> <Pine.LNX.4.64.0605121024310.3866@g5.osdl.org> <20060512203416.GA17120@flint.arm.linux.org.uk> <20060512214354.GP27946@ftp.linux.org.uk> <20060512215520.GH17120@flint.arm.linux.org.uk> <20060512220807.GR27946@ftp.linux.org.uk> <Pine.LNX.4.64.0605121519420.3866@g5.osdl.org> <20060512222816.GS27946@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:21480 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S1751117AbWELWsG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 18:48:06 -0400
Content-Disposition: inline
In-Reply-To: <20060512222816.GS27946@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Erik Mouw <erik@harddisk-recovery.com>, Or Gerlitz <or.gerlitz@gmail.com>, linux-scsi@vger.kernel.org, axboe@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, May 12, 2006 at 11:28:16PM +0100, Al Viro wrote:
> Ah, right - there was another uevent mess in fs/super.c.  Sorry, got them
> confused... and that FPOS _is_ back.

Actually...

What happens is that turd in fs/super.c (one that should not have been
resurrected) triggers call of block_uevent().  Which uses ->driverfs_dev.
Which is a bug.

So IMO we should simply kill that animal _again_, and see if block_uevent()
is actually need for anything on its own.
