From: christophe.varoqui@free.fr
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Tue, 19 Aug 2003 11:04:31 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061283871.3f41e81f8226b@impt3-2.free.fr>
References: <20030819073926.GA423@fib011235813.fsnet.co.uk> <20030819094838.F8428@sistina.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix3-1.free.fr ([213.228.0.44]:15814 "EHLO
	postfix3-1.free.fr") by vger.kernel.org with ESMTP id S266985AbTHSJEd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2003 05:04:33 -0400
In-Reply-To: <20030819094838.F8428@sistina.com>
List-Id: linux-scsi@vger.kernel.org
To: mauelshagen@sistina.com
Cc: mge@sistina.com, thornber@sistina.com, linux-scsi@vger.kernel.org

Hello,

pvscan will block on ghosts (verified here).
It stays in uninterruptible sleep until a START_LUN is sent through the ghost it
blocks on. You need a way to detect and skip those : this detection is vendor
specific and not related to volume management.

I still consider multipath is a requirement above the LVM need, and as such it
shouldn't be included with LVM2 : LVM2 shouldn't be a requirement for
multipathing. Moreover, PV UUID should not be necessary for multipath, the
inquiry data suffice.

In a multipathed environment, with dm multipathed maps set up outside LVM2 as I
suggested, LVM2 just need to restrain its view (through /etc/lvm.conf) to those
maps in order to avoid ghosts-blocking.

I "cc:" linux-scsi as opinions of the folks from the OLS talk seem needed.

regards,
cvaroqui

Selon "Heinz J . Mauelshagen" <Heinz.Mauelshagen@t-online.de>:

> 
> Christophe,
> 
> in LVM2, such "ghosts disks" will never be used to multipath io
> to the device(s), because LVM2 discovers disks by label. In order to do
> this, the tools need to read the labels off the devices which is not
> possible
> for "ghosts disks" if I understand you correctly.
> 
> Please keep in mind, that LVM2 tool support for multipathing is under
> development (code will show up in October).
> 
> It should be trivial to call the respective LVM2 tool from a hotplug script
> to
> automatically enable new paths to the device.
> 
> IO balancing is already supprted in our multipath target code.
> 
> BTW: People could still use the dmsetup tool (which comes with the
> device-mapper
>      source distro) to set a multipath configuration accessing "ghosts
> disks"
>      up. But this is no problem IMO, because dmsetup is an expert tool which
> is
>      not to be used by regular users anyway who will be using the LVM2
> tools.
> 
> 
> Regards,
> Heinz    -- The LVM Guy --
> 
> 
> > Date: Tue, 19 Aug 2003 00:52:49 +0200
> > From: christophe varoqui <christophe.varoqui@free.fr>
> > To: thornber@sistina.com
> > Subject: dm multipath target
> > 
> > Hello,
> > 
> > I read that you prepare a dm multipath target for release.
> > As a Storageworks HSV client, I would like to know how/if you plan to 
> > manage "ghosts disks" ?
> > 
> > First a little background info :
> > A ghost is a path to a disk that you can use to submit inquiries but it 
> > cannot take IO. The HSV controler presents those ghosts through half of 
> > its 4 FC ports, for each LUN. A host can force the activation of a ghost 
> > by sending a "START_LUN" on it, thus a valid IO path become ghost in its 
> > place. Maybe other controlers use other activation procedures.
> > 
> > A complete multipath integration in Linux means (to me) :
> > 
> > * auto-detection and setting of the multipath device at boot and at LUN 
> > detection time : with dm (or md) and a block.* hotplug script for 2.6 
> > kernels, this seems easy.
> > * IO balancing across all paths active at any moment, and never send IO 
> > to ghosts : the tough part, as it certainly is vendor-specific.
> > 
> > In my case, the ghost paths can be seen as spares.
> > 
> > This notion of spare/ghost could be kept at a userland level, then the 
> > multipath target only need to know about active paths : Easy. But you 
> > need to call userland each time you fail a path for it to try and 
> > replace it by activating a ghost.
> > 
> > What are your current thoughts about that, especially about the timing 
> > and mecanics for the userland callbacks ? What hooks will be in the 
> > first release, and what's the larger plan ?
> > I certainly whish I can help with testing your target, with up to 8 
> > paths per LUN (4/4 active/passive) and I'll try to get a userland right 
> > for my environment.
> > 
> > regards,
> > cvaroqui
> > 
> > ----- End forwarded message -----
> 
> =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> 
> Heinz Mauelshagen                                 Sistina Software Inc.
> Senior Consultant/Developer                       Am Sonnenhang 11
>                                                   56242 Marienrachdorf
>                                                   Germany
> Mauelshagen@Sistina.com                           +49 2626 141200
>                                                        FAX 924446
> =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> 


-- 
