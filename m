From: christophe.varoqui@free.fr
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Thu, 21 Aug 2003 18:34:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061483692.3f44f4ac24e07@impt1-2.free.fr>
References: <20030819094838.F8428@sistina.com> <1061283871.3f41e81f8226b@impt3-2.free.fr> <20030819115110.I8420@sistina.com> <1061290087.3f4200678f811@impt2-2.free.fr> <20030819143552.K8420@sistina.com> <1061299572.3f4225742287c@impt1-2.free.fr> <20030819182347.O8420@sistina.com> <20030820012204.449c2b34.christophe.varoqui@free.fr> <20030820150253.X8420@sistina.com> <1061389164.3f43836ccaf56@impt1-1.free.fr> <20030821144716.Y8420@sistina.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-2.free.fr ([213.228.0.176]:55992 "EHLO
	postfix4-2.free.fr") by vger.kernel.org with ESMTP id S262787AbTHUQex
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2003 12:34:53 -0400
In-Reply-To: <20030821144716.Y8420@sistina.com>
List-Id: linux-scsi@vger.kernel.org
To: mauelshagen@sistina.com
Cc: linux-scsi@vger.kernel.org

> > 
> > The only use of hosts volume management would be persistant-mirroring 2
> suchs
> > arrays, which LVM2 does not propose at the moment.
> 
> Yep, that's an example (we'll support in fall this year).
> 
> Others are volumes larger than the largest array, striping beyond array
> limits,
> hot spot removal and online data relocation to newer disk subsystems in
> order
> to remove the old ones.
>
yes
 
> > 
> > I, for one, would the multipath implementation to be stand alone.
> > LVM2 can be layer on top of that without any modification : I see no
> > advantage
> > for you to merge the two subsystems.
> 
> They aren't. As I tried to explain before, LVM2 is just a volume management
> application supporting multipathing shortly.
> 
> If more people need stand alone multipathing, dmsetup can be used together
> with some scripting or a small multipathing appl can be created.
> 
Why favoring fragmentation ? An independant multipath implementation would
become a de facto standard. Instead, you force others to propose alternative
implementations : EVMS will do that and surely will do it in the IBM monolithic
way too, then another lean implementation will appear ...
What implementation will the vendors support ? all, random, none ...
Anyway, not good for us users.

You said it's not harder to do it independantly, so why ?

> I just can't see that there's lots of demand ;)
> 
Indeed, we feel alone in this thread :)

> > realize that a ghost becoming a valid path trigger
> > _nothing_
> > in a current kernel. I do not even know if the HSV notifies such a change.
> > Thus, no hotplug event get triggered.
> 
> Too bad.
> 
Yep

> > But there will be failpath events, which need to be notified to a
> > vendor-specific script.
> 
> Which in turn can run LVM2 tools or dmsetup in case not LVM2 is wanted
> to reload change multipath device mappings.
> 
Yes,
the question boils down to "will/do dm multipath target forward failpath events
to userspace ?"

> > but I rather say "the mp framework (be it LVM2 or anything else) accept
> > vendor-specific plugs" than "vendor specific hacks must accpet plugins for
> > LVM2
> > config housekeeping". Don't you agree ?
> 
> No, Linux device-mapper multipathing sits generically above any vendor
> specific lower level drivers and is set up from user-land (dmsetup or
> device-mapper library used by LVM2).
> If only the vendor knows about any internal state machinery of his storage
> subsystem and reports related state changes in a vendor specific way, part
> of that report processing should interface into device-mapping.
> 
Such a daemon may not be able to keep paths state in-memory representation in
sync with reality without path failure notification.
In the case of HSVs, in scanned all INQUIRY and saw nothing that differentiate a
ghost and a valid path. Most sense data is unreachable, as sg_mode hangs on
ghosts trying to retreive it.

> > No, you still need to rescan for new valid paths outside the dm target
> control,
> > as a path going ghost often implies a ghost going valid. The new valid path
> must
> > be added to the dm target to restore the redondancy level and nominal
> performance.
> > This rescan must be triggered on path failure. and this is vendor-specific
> too.
> 
> The vendor specific thing is the initiator then and should address
> device-mapping changes.
> 
As above

> 
> What about given MD multipath ?
> How does this work together with that array ?
>
awfully :)
I may be able to autoconfigure md mps at boot, but :
With ghosts included in md : a failover can elect a ghost then hang forever
(certainly true with a dm mp target too, but failfast could change that ?)
With ghosts excluded of md : I need a callback on path failure to hotadd
activated ghosts. This callback is absent (mdadm does that asynchronously but I
had not luck with that feature)
Both solutions : the selected active path going ghost leaves me hung, with no
failover happening (as you do load balancing you will certainly hit by that even
more)


We have had 3 hot spots in this thread :

1) failure notification on ghost IO path is needed : hanging is not acceptable
Agreement reached here :)

2) multipath support for "bizarre" arrays need a userspace callback on path failure.
Agreement seems to be reached. Still not clear what provides this callback :
MD/DM or Block Layer ?

3) multipath implementation need to be separate from volume managers. (DM is not
a volume manger, LVM2 & EVMS are !)
Agreement not reached :(

Do others on this list have comments/opinions ?

regards,
cvaroqui
-- 
