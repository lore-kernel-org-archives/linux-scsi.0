From: Heinz.Mauelshagen@t-online.de (Heinz J . Mauelshagen)
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Tue, 19 Aug 2003 11:51:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030819115110.I8420@sistina.com>
References: <20030819073926.GA423@fib011235813.fsnet.co.uk> <20030819094838.F8428@sistina.com> <1061283871.3f41e81f8226b@impt3-2.free.fr>
Reply-To: mauelshagen@sistina.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout09.sul.t-online.com ([194.25.134.84]:59583 "EHLO
	mailout09.sul.t-online.com") by vger.kernel.org with ESMTP
	id S269514AbTHSJ5a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2003 05:57:30 -0400
In-Reply-To: <1061283871.3f41e81f8226b@impt3-2.free.fr>; from christophe.varoqui@free.fr on Tue, Aug 19, 2003 at 11:04:31AM +0200
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: mge@sistina.com

On Tue, Aug 19, 2003 at 11:04:31AM +0200, christophe.varoqui@free.fr wrote:
> Hello,
> 
> pvscan will block on ghosts (verified here).
> It stays in uninterruptible sleep until a START_LUN is sent through the ghost it
> blocks on. You need a way to detect and skip those : this detection is vendor
> specific and not related to volume management.

No, device-mapper is designed completely generic (LVM2 as well BTW).
It will never contain any vendor specific hacks.

Ghosts should report EIO in case of an unstarted LUN anyway ?
In case they are started they are supposed to report EPERM on IO because
they don't support any.

Even reporting EPERM in both cases would be sufficient, because IO
will never make it through a ghost. Blocking makes no sense to me at all.

> 
> I still consider multipath is a requirement above the LVM need,

There's various "flavours" where to put multipath into the io chain.
Kernel hacker conclusion is in device-mapper.

> and as such it
> shouldn't be included with LVM2 : LVM2 shouldn't be a requirement for
> multipathing.

It isn't: that was my point about device-mapper and dmsetup.
Multipathing is a device-mapper target and therefore offers a general kernel
service to be used by arbitrary applications.
LVM2 is the one from us supporting that in the future.

Other LVM applications are free to implement a different model.

> Moreover, PV UUID should not be necessary for multipath, the
> inquiry data suffice.

It isn't. Device-mapper has no clue of volume management metadata. LVM2 has.

We need better device recovery in Linux (which will happen in the Linux 2.7
series later). PV UUIDs enable LVM2 to discover PVs.

> 
> In a multipathed environment, with dm multipathed maps set up outside LVM2 as I
> suggested, LVM2 just need to restrain its view (through /etc/lvm.conf) to those
> maps in order to avoid ghosts-blocking.

Yep, it can already if the admin wants so.

I much rather prefer a cleaner ghosts implementation not blocking
critical applications.

> 
> I "cc:" linux-scsi as opinions of the folks from the OLS talk seem needed.

Ok.

Regards,
Heinz    -- The LVM Guy --

> 
> regards,
> cvaroqui
> 
> Selon "Heinz J . Mauelshagen" <Heinz.Mauelshagen@t-online.de>:
> 
> > 
> > Christophe,
> > 
> > in LVM2, such "ghosts disks" will never be used to multipath io
> > to the device(s), because LVM2 discovers disks by label. In order to do
> > this, the tools need to read the labels off the devices which is not
> > possible
> > for "ghosts disks" if I understand you correctly.
> > 
> > Please keep in mind, that LVM2 tool support for multipathing is under
> > development (code will show up in October).
> > 
> > It should be trivial to call the respective LVM2 tool from a hotplug script
> > to
> > automatically enable new paths to the device.
> > 
> > IO balancing is already supprted in our multipath target code.
> > 
> > BTW: People could still use the dmsetup tool (which comes with the
> > device-mapper
> >      source distro) to set a multipath configuration accessing "ghosts
> > disks"
> >      up. But this is no problem IMO, because dmsetup is an expert tool which
> > is
> >      not to be used by regular users anyway who will be using the LVM2
> > tools.
> > 
> > 
> > Regards,
> > Heinz    -- The LVM Guy --
> > 
> > 
> > > Date: Tue, 19 Aug 2003 00:52:49 +0200
> > > From: christophe varoqui <christophe.varoqui@free.fr>
> > > To: thornber@sistina.com
> > > Subject: dm multipath target
> > > 
> > > Hello,
> > > 
> > > I read that you prepare a dm multipath target for release.
> > > As a Storageworks HSV client, I would like to know how/if you plan to 
> > > manage "ghosts disks" ?
> > > 
> > > First a little background info :
> > > A ghost is a path to a disk that you can use to submit inquiries but it 
> > > cannot take IO. The HSV controler presents those ghosts through half of 
> > > its 4 FC ports, for each LUN. A host can force the activation of a ghost 
> > > by sending a "START_LUN" on it, thus a valid IO path become ghost in its 
> > > place. Maybe other controlers use other activation procedures.
> > > 
> > > A complete multipath integration in Linux means (to me) :
> > > 
> > > * auto-detection and setting of the multipath device at boot and at LUN 
> > > detection time : with dm (or md) and a block.* hotplug script for 2.6 
> > > kernels, this seems easy.
> > > * IO balancing across all paths active at any moment, and never send IO 
> > > to ghosts : the tough part, as it certainly is vendor-specific.
> > > 
> > > In my case, the ghost paths can be seen as spares.
> > > 
> > > This notion of spare/ghost could be kept at a userland level, then the 
> > > multipath target only need to know about active paths : Easy. But you 
> > > need to call userland each time you fail a path for it to try and 
> > > replace it by activating a ghost.
> > > 
> > > What are your current thoughts about that, especially about the timing 
> > > and mecanics for the userland callbacks ? What hooks will be in the 
> > > first release, and what's the larger plan ?
> > > I certainly whish I can help with testing your target, with up to 8 
> > > paths per LUN (4/4 active/passive) and I'll try to get a userland right 
> > > for my environment.
> > > 
> > > regards,
> > > cvaroqui
> > > 
> > > ----- End forwarded message -----
> > 

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Sistina Software Inc.
Senior Consultant/Developer                       Am Sonnenhang 11
                                                  56242 Marienrachdorf
                                                  Germany
Mauelshagen@Sistina.com                           +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
