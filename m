From: Heinz.Mauelshagen@t-online.de (Heinz J . Mauelshagen)
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Wed, 20 Aug 2003 15:02:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030820150253.X8420@sistina.com>
References: <20030819073926.GA423@fib011235813.fsnet.co.uk> <20030819094838.F8428@sistina.com> <1061283871.3f41e81f8226b@impt3-2.free.fr> <20030819115110.I8420@sistina.com> <1061290087.3f4200678f811@impt2-2.free.fr> <20030819143552.K8420@sistina.com> <1061299572.3f4225742287c@impt1-2.free.fr> <20030819182347.O8420@sistina.com> <20030820012204.449c2b34.christophe.varoqui@free.fr>
Reply-To: mauelshagen@sistina.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout06.sul.t-online.com ([194.25.134.19]:36791 "EHLO
	mailout06.sul.t-online.com") by vger.kernel.org with ESMTP
	id S261926AbTHTNJQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2003 09:09:16 -0400
In-Reply-To: <20030820012204.449c2b34.christophe.varoqui@free.fr>; from christophe.varoqui@free.fr on Wed, Aug 20, 2003 at 01:22:04AM +0200
List-Id: linux-scsi@vger.kernel.org
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: mauelshagen@sistina.com, linux-scsi@vger.kernel.org

On Wed, Aug 20, 2003 at 01:22:04AM +0200, christophe varoqui wrote:
> On Tue, 19 Aug 2003 18:23:47 +0200
> Heinz.Mauelshagen@t-online.de (Heinz J . Mauelshagen) wrote:
> 
> > > You realize that it make those tools unsuitable for general use : 
> > > * one may not want to use the full lvm compound binary to set up multipaths
> > > * one may not want to tag its devices to set up multipaths, where its not necessary
> > 
> > The "Yes" was about the LVM2 tools and we do recommend them to be installed
> > to support the variaty of volume management features.
> > 
> > If you have a corner use case where you don't need any of them but multipath,
> > dmsetup can be used to cover what you want out of the box (creating ASCII
> > mapping tables which is simple for multipath).
> > No need to install LVM2 at all for that.
> > 
> This is not a corner case use : most users who face multipath problem cope with FC raid controlers that embed the volume management. Those users are in need of a clean and stand alone multipath layer, not a swiss-knife volume manager.

Agreed that smart controlers and intelligent disk subsystems have intrinsic
volume management capabilities.
The point you miss IMHO is, that people using those nevertheless want volume
management on top of their EMC boxen in order to virtualize their storage
(i.e. to online move data or to have logical volumes spanning multiple
disk subsystems).

IOW: people want to have storage virtualization of _all_ their storage devices,
     not just some to handle their varying storage management needs for all of
     their storage.

That's why I talked about a corner case.

> 
> I understand that the implementation you propose offers a clean and coherent interface for volume management and multipath, but it will work as expected only for "all paths to LUN are active" configurations : ie high-end EMC clients (who don't need host volume management) and "FC JBOD connected through 2 HBA"-users. All other users must cope with ghosts.
> 

Well, the high-end storage boxen don't need volume management SW to do their
private business, right. But the point is, that volume management is not a
single storage device business as mentioned above.

> You suggest admins can filter those out with LVM2 config file : OK, easy to do at initialisation time, but how can admins cope with ghosts becoming active and valid paths becoming ghosts ?
> In the first case admins must insert the newly activated path in the multipath map _when the event occurs_.

If valid path can become ghosts it is an argument that ghosts need to report
errors on io accesses where they actually hang the application if they
behave the same way you mentioned for ghost in the first place.

Other than that, hotplug events should be used to cope with this.

> In the second case, admins must blacklist a former valid path in the LVM2 config file _when the event occurs_.

The filter in the config file is only used by the tools, not by
device-mapper at runtime. device-mapper's multipath target needs to get
an error reported in case a path fails in order to recognize it.

Hotplug to blacklist those as well ?

> 
> It can only be done by scripts/plugins triggered by path failures as
> * a ghost becomes active if 
>   1) the host explicitly ask for it, housekeeping is in charge of the initiator of the activation demand
>   2) the raid controler has fail an active path over the ghost which implies the hosts get a path failure in a mp target anyway
> * an active path becomes ghost implies a path failure
> 
> As a whole MP device is vendor coherent, but different MP devices can be hold by different vendors, I wonder if it would be right to set the vendor-specific script/plugin path as a parameter of the target map.
> 

The "activate all paths we want to use" is outside the scope of LVM.

a. If the vendors model handles activation on the host side, a script to do
   it (or some vendor daemon handling this on the host or hotplug) is necessary
   anyway because there's no standard.
   Additional programs need to be hookable into the (de)activation
   event queue to handle config file updates.

b. And if a invalid io path reports an error on io access (as i mentioned
   earlier in my posts), which is elementary to enable multipath to work as
   mentioned above (valid path -> ghost change), LVM2 and device-mapper can
   cope with it now. No principal need for config file updates if b is given
   (rather than maybe performance penalties accessing invalid paths
    by the tools)


If a valid io path can change to a ghost _and_ no io error is
reported accessing the ghost then, the system is in deep trouble anyway.

Or what happens now if you move LVM2/device-mapper completely out of the picture
and mount a filesystem on a valid path which turns into a ghost while
the filesystem is mounted and under load ?

Regards,
Heinz    -- The LVM Guy --





> Comments ?
> 
> > > 
> > > Shouldn't LVM2 just rely on an separate multipath management (dm-based). There
> > > surely will be one such implementation. We users don't need fragmentation in
> > > such a low-level area.
> > 
> > dm is the multipath runtime (through a dm multipath target).
> > 
> No discussion here.
> 
> > As said: you can set up multipath configs without LVM2 in case you
> > don't need full volume management functionality using the dmsetup tool.
> > This is not the recommended way but you still can do it ;)
> > 
> You just cannot recommend what you described to a HPQ StorageWorks customer, like me :)
> If the reasons why are still unclear, please point the blurry details as I'll be glad to elaborate.
> 
> regards,
>  cvaroqui

*** Software bugs are stupid.
    Nevertheless it needs not so stupid people to solve them ***

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Sistina Software Inc.
Senior Consultant/Developer                       Am Sonnenhang 11
                                                  56242 Marienrachdorf
                                                  Germany
Mauelshagen@Sistina.com                           +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
