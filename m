From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Wed, 20 Oct 2004 16:44:32 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20041020154432.GE21985@infradead.org>
References: <20041007150709.B12688@infradead.org> <4165624C.5060405@rtr.ca> <416565DB.4050006@pobox.com> <4165A45D.2090200@rtr.ca> <4165A766.1040104@pobox.com> <4165A85D.7080704@rtr.ca> <4165AB1B.8000204@pobox.com> <4165ACF8.8060208@rtr.ca> <20041007221537.A17712@infradead.org> <4165BD38.4020403@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S268312AbUJTPxP@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4165BD38.4020403@rtr.ca>
To: Mark Lord <lkml@rtr.ca>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, Mark Lord <lsml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 07, 2004 at 06:03:36PM -0400, Mark Lord wrote:
> (Christoph Hellwig wrote:
>  >
> >  - the !dev case in qs_scsi_queuecomman can't happen
> 
> Are you sure?
> I have seen it occur immediately after hot-removal
> of a drive.  There have been other structural changes
> since then, so perhaps it is no longer possible,
> but I'd rather have the test there than have the
> kernel ooops again.  If you feel strongly about it,
> then away it goes.

Hmm.  It's freed in ->slave_destroy and the scsi state model shouldn't
allow new command submission long before.  If you still see it happen
please send a bugreport to linux-scsi.

> >  - never mess with eh_timeout from inside a driver
> 
> Give us an interface for it, please.
> In the meanwhile, gone!

set scsi_device->timeout in ->slave_alloc to the value you want.

> >  - please don't implemente the HDIO_ ioctls, Jeff said this can
> >    be done via SG_IO
> 
> SG_IO is incompatible with current user-mode toolsets.
> Once that interface becomes more mature, and the distributions
> gradually get updated with newer versions of the tools,
> then the HDIO_ stuff can go (as per the comments in the source).
> For now, it is essential for hdparm and smartmontools, among others.
> 
> Alternatively, as Jeff has suggested, we may be able to implement
> a generic HDIO_ mechanism in libata that re-issues the commands
> through SG_IO (perhaps that is what you meant).  Is that there now?

So please fixup userspace.  New hardware will require new system tools
once in a while.

> >  - if ->info return a static string you can just store it into ->name
> 
> So just nuke the _info() proc, and use .name = QS_DESC ?
> Okay, done.

Yes.
