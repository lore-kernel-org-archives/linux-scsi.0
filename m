From: Jens Axboe <axboe@suse.de>
Subject: Re: writable mmc profiles actually are writable
Date: Tue, 7 Oct 2003 09:04:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007070404.GU972@suse.de>
References: <20031006182510.GG972@suse.de> <1065469831.5185.44.camel@patehci2> <20031006203816.GJ972@suse.de> <1065473899.6835.41.camel@patehci2> <1065478448.2361.1.camel@patehci2> <1065484607.2899.7.camel@patehci2> <20031007053858.GL972@suse.de> <20031006234543.A11937@one-eyed-alien.net> <20031007064829.GQ972@suse.de> <20031007000018.B11937@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:19936 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261802AbTJGHEJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2003 03:04:09 -0400
Content-Disposition: inline
In-Reply-To: <20031007000018.B11937@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>, linux-scsi@vger.kernel.org

On Tue, Oct 07 2003, Matthew Dharm wrote:
> On Tue, Oct 07, 2003 at 08:48:29AM +0200, Jens Axboe wrote:
> > On Mon, Oct 06 2003, Matthew Dharm wrote:
> > > On Tue, Oct 07, 2003 at 07:38:58AM +0200, Jens Axboe wrote:
> > > > On Mon, Oct 06 2003, Pat LaVarre wrote:
> > > > > Yep, still happy, same in -test6 as in -test5 e.g.
> > > > > 
> > > > > $ dmesg | grep ^sr
> > > > > sr0: scsi3-mmc drive: 125x/125x caddy
> > > > > sr0: scsi3-mmc maybe not writeable
> > > > > sr0: scsi3-mmc writable profile: 0x0002
> > > > > $
> > > > > $ grep MMC /proc/sys/dev/cdrom/info
> > > > > Can write other MMC-RW: 1 ...
> > > > 
> > > > I don't quite agree with this patch. Please add the GET_CONFIGURATION
> > > > stuff to cdrom.c instead so it works with ide-cd as well (ide-scsi is
> > > > basically dead, and the number of scsi drives out there isn't exactly
> > > > big and increasing). GPCMD_GET_CONFIGURATION already exists. Also, make
> > > > DVD-RAM drives set CDC_MMC_RW as well and only check for that at open.
> > > 
> > > While the number of SCSI CD-ROM drives may be shrinking, the ATAPI drives
> > > behind a USB/ATAPI bridge is skyrocketing.
> > 
> > Doesn't change the picture, if you put it in cdrom.c it will work for
> > both.
> 
> It will?  I'll have to take your word for that, as I don't immediately see
> how that works... then again, much of the higher layers of SCSI are a
> mystery to me.
> 
> I think I see how this work.... sr.c registers with cdrom.c, and cdrom.c
> actually provides the interface to the /dev/scdN node, right?

Precisely.

> If that's the case, why is there so much code in sr.c anyway?  The
> get_capabilities() function really should be moved, as well as media-change
> detection, much of the probe function (dealing with initialization of the
> new structre), reading sector sizes, and sr_ioctl.c should probably be
> renamed (as it doesn't really do IOCTL processing).
> 
> Am I on the right track?  That seems like an awfully long list of things
> that suggest against my interpretation....

Yes you are essentially correct. Some things have been killed from sr a
long time ago, but I generally resist adding new things to sr and ide-cd
unless I really have to. And I've been doing so since 2.2, so I really
don't want to reverse that right now.

It's also confusing why then some things only work if you have ide-cd
loaded, or if you use ide-scsi and sr. It's just a bad idea.

-- 
Jens Axboe

