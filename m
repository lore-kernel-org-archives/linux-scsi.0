From: christophe.varoqui@free.fr
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Wed, 20 Aug 2003 16:19:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061389164.3f43836ccaf56@impt1-1.free.fr>
References: <20030819073926.GA423@fib011235813.fsnet.co.uk> <20030819094838.F8428@sistina.com> <1061283871.3f41e81f8226b@impt3-2.free.fr> <20030819115110.I8420@sistina.com> <1061290087.3f4200678f811@impt2-2.free.fr> <20030819143552.K8420@sistina.com> <1061299572.3f4225742287c@impt1-2.free.fr> <20030819182347.O8420@sistina.com> <20030820012204.449c2b34.christophe.varoqui@free.fr> <20030820150253.X8420@sistina.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix3-1.free.fr ([213.228.0.44]:36037 "EHLO
	postfix3-1.free.fr") by vger.kernel.org with ESMTP id S261978AbTHTOT0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2003 10:19:26 -0400
In-Reply-To: <20030820150253.X8420@sistina.com>
List-Id: linux-scsi@vger.kernel.org
To: mauelshagen@sistina.com
Cc: linux-scsi@vger.kernel.org

> > 
> > This is not a corner case use : most users who face multipath problem cope
> > with FC raid controlers that embed the volume management. Those users are in
> > need of a clean and stand alone multipath layer, not a swiss-knife volume
> > manager.
> 
> Agreed that smart controlers and intelligent disk subsystems have intrinsic
> volume management capabilities.
> The point you miss IMHO is, that people using those nevertheless want volume
> management on top of their EMC boxen in order to virtualize their storage
> (i.e. to online move data or to have logical volumes spanning multiple
> disk subsystems).
> 
> IOW: people want to have storage virtualization of _all_ their storage
> devices,
>      not just some to handle their varying storage management needs for all
> of
>      their storage.
> 
> That's why I talked about a corner case.
> 
I still politely disagree. Take the same HSV controler : this beast hosts up to
252 FC disks, up to 144 Go each. This controler embeds a _real_ volume manager
that allocate extents (striped, raid0, raid5) and uses a rotative allocator that
spreads every LUN on ALL disks. It also feature a load-leveler and allocation
leveler daemon. Admins can resize the LUNs, no matter the parity level ... and
soon Linux will support that (as Win2k & Tru64 already do).

The only use of hosts volume management would be persistant-mirroring 2 suchs
arrays, which LVM2 does not propose at the moment.

I, for one, would the multipath implementation to be stand alone.
LVM2 can be layer on top of that without any modification : I see no advantage
for you to merge the two subsystems.

> > 
> > I understand that the implementation you propose offers a clean and
> > coherent interface for volume management and multipath, but it will work as
> > expected only for "all paths to LUN are active" configurations : ie high-end
> > EMC clients (who don't need host volume management) and "FC JBOD connected
> > through 2 HBA"-users. All other users must cope with ghosts.
> > 
> 
> Well, the high-end storage boxen don't need volume management SW to do their
> private business, right. But the point is, that volume management is not a
> single storage device business as mentioned above.
> 
Point taken, but where you say "volume management is the answer", I rather say
"clean & lean multipath implementation is the answer"

> > You suggest admins can filter those out with LVM2 config file : OK, easy to
> > do at initialisation time, but how can admins cope with ghosts becoming
> > active and valid paths becoming ghosts ?
> > In the first case admins must insert the newly activated path in the
> > multipath map _when the event occurs_.
> 
> If valid path can become ghosts it is an argument that ghosts need to report
> errors on io accesses where they actually hang the application if they
> behave the same way you mentioned for ghost in the first place.
> 
Yes, James B seems to be confident failfast will permit to do that.
I'm eager to run tests if needed. 
James, Does the patch you posted along with OLS talk minutes over a test3 kernel
would be sufficient to see behaviour change with ghosts ?
 
> Other than that, hotplug events should be used to cope with this.
> 
No, I guess not : realize that a ghost becoming a valid path trigger _nothing_
in a current kernel. I do not even know if the HSV notifies such a change.
Thus, no hotplug event get triggered.

> > In the second case, admins must blacklist a former valid path in the LVM2
> config file _when the event occurs_.
> 
> The filter in the config file is only used by the tools, not by
> device-mapper at runtime. device-mapper's multipath target needs to get
> an error reported in case a path fails in order to recognize it.
> 
> Hotplug to blacklist those as well ?
> 
As said above no hotplug event will be generated when ghosts and valid paths get
swaped around. But there will be failpath events, which need to be notified to a
vendor-specific script.

> > 
> > It can only be done by scripts/plugins triggered by path failures as
> > * a ghost becomes active if 
> >   1) the host explicitly ask for it, housekeeping is in charge of the
> initiator of the activation demand
> >   2) the raid controler has fail an active path over the ghost which
> implies the hosts get a path failure in a mp target anyway
> > * an active path becomes ghost implies a path failure
> > 
> > As a whole MP device is vendor coherent, but different MP devices can be
> hold by different vendors, I wonder if it would be right to set the
> vendor-specific script/plugin path as a parameter of the target map.
> > 
> 
> The "activate all paths we want to use" is outside the scope of LVM.
> 
> a. If the vendors model handles activation on the host side, a script to do
>    it (or some vendor daemon handling this on the host or hotplug) is
> necessary
>    anyway because there's no standard.
>    Additional programs need to be hookable into the (de)activation
>    event queue to handle config file updates.
> 
ok,
but I rather say "the mp framework (be it LVM2 or anything else) accept
vendor-specific plugs" than "vendor specific hacks must accpet plugins for LVM2
config housekeeping". Don't you agree ?

> b. And if a invalid io path reports an error on io access (as i mentioned
>    earlier in my posts), which is elementary to enable multipath to work as
>    mentioned above (valid path -> ghost change), LVM2 and device-mapper can
>    cope with it now. No principal need for config file updates if b is given
>    (rather than maybe performance penalties accessing invalid paths
>     by the tools)
>
No, you still need to rescan for new valid paths outside the dm target control,
as a path going ghost often implies a ghost going valid. The new valid path must
be added to the dm target to restore the redondancy level and nominal performance.
This rescan must be triggered on path failure. and this is vendor-specific too.

>
> If a valid io path can change to a ghost _and_ no io error is
> reported accessing the ghost then, the system is in deep trouble anyway.
> 
I can START_LUN it back to unhang processes. Going ghost is not the same as failing.

> Or what happens now if you move LVM2/device-mapper completely out of the
> picture
> and mount a filesystem on a valid path which turns into a ghost while
> the filesystem is mounted and under load ?
Same as above.
But why would I want to do that anyway ?
Multipath devices need to be accessed through a multipath metadevice.

If Linux cannot do it, do not use Linux with this array : this is my regretful
conclusion. Hope it changes soon because I have a load of Linux-wannabe servers
& apps in that situation.
Of course there is HP SecurePath, but what's the point of an Open Source kernel
tainted with closed modules ?

regards,
cvaroqui
