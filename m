From: Heinz.Mauelshagen@t-online.de (Heinz J . Mauelshagen)
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Fri, 22 Aug 2003 10:51:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030822105146.B8420@sistina.com>
References: <20030819115110.I8420@sistina.com> <1061290087.3f4200678f811@impt2-2.free.fr> <20030819143552.K8420@sistina.com> <1061299572.3f4225742287c@impt1-2.free.fr> <20030819182347.O8420@sistina.com> <20030820012204.449c2b34.christophe.varoqui@free.fr> <20030820150253.X8420@sistina.com> <1061389164.3f43836ccaf56@impt1-1.free.fr> <20030821144716.Y8420@sistina.com> <1061483692.3f44f4ac24e07@impt1-2.free.fr>
Reply-To: mauelshagen@sistina.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout03.sul.t-online.com ([194.25.134.81]:40389 "EHLO
	mailout03.sul.t-online.com") by vger.kernel.org with ESMTP
	id S263133AbTHVI6V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2003 04:58:21 -0400
In-Reply-To: <1061483692.3f44f4ac24e07@impt1-2.free.fr>; from christophe.varoqui@free.fr on Thu, Aug 21, 2003 at 06:34:52PM +0200
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: mauelshagen@sistina.com, linux-scsi@vger.kernel.org

On Thu, Aug 21, 2003 at 06:34:52PM +0200, christophe.varoqui@free.fr wrote:
> > > 
> > > The only use of hosts volume management would be persistant-mirroring 2
> > suchs
> > > arrays, which LVM2 does not propose at the moment.
> > 
> > Yep, that's an example (we'll support in fall this year).
> > 
> > Others are volumes larger than the largest array, striping beyond array
> > limits,
> > hot spot removal and online data relocation to newer disk subsystems in
> > order
> > to remove the old ones.
> >
> yes
>  
> > > 
> > > I, for one, would the multipath implementation to be stand alone.
> > > LVM2 can be layer on top of that without any modification : I see no
> > > advantage
> > > for you to merge the two subsystems.
> > 
> > They aren't. As I tried to explain before, LVM2 is just a volume management
> > application supporting multipathing shortly.
> > 
> > If more people need stand alone multipathing, dmsetup can be used together
> > with some scripting or a small multipathing appl can be created.
> > 
> Why favoring fragmentation ? An independant multipath implementation would
> become a de facto standard. Instead, you force others to propose alternative
> implementations : EVMS will do that and surely will do it in the IBM monolithic
> way too, then another lean implementation will appear ...
> What implementation will the vendors support ? all, random, none ...
> Anyway, not good for us users.
> 
> You said it's not harder to do it independantly, so why ?

dmsetup + script.

> 
> > I just can't see that there's lots of demand ;)
> > 
> Indeed, we feel alone in this thread :)

If there's more demand later, it will happen.

> 
> > > realize that a ghost becoming a valid path trigger
> > > _nothing_
> > > in a current kernel. I do not even know if the HSV notifies such a change.
> > > Thus, no hotplug event get triggered.
> > 
> > Too bad.
> > 
> Yep
> 
> > > But there will be failpath events, which need to be notified to a
> > > vendor-specific script.
> > 
> > Which in turn can run LVM2 tools or dmsetup in case not LVM2 is wanted
> > to reload change multipath device mappings.
> > 
> Yes,
> the question boils down to "will/do dm multipath target forward failpath events
> to userspace ?"

It does. "dmsetup status MAPPED-DEVICE" shows it (using the LGPLed
device-mapper library).

> 
> > > but I rather say "the mp framework (be it LVM2 or anything else) accept
> > > vendor-specific plugs" than "vendor specific hacks must accpet plugins for
> > > LVM2
> > > config housekeeping". Don't you agree ?
> > 
> > No, Linux device-mapper multipathing sits generically above any vendor
> > specific lower level drivers and is set up from user-land (dmsetup or
> > device-mapper library used by LVM2).
> > If only the vendor knows about any internal state machinery of his storage
> > subsystem and reports related state changes in a vendor specific way, part
> > of that report processing should interface into device-mapping.
> > 
> Such a daemon may not be able to keep paths state in-memory representation in
> sync with reality without path failure notification.
> In the case of HSVs, in scanned all INQUIRY and saw nothing that differentiate a
> ghost and a valid path. Most sense data is unreachable, as sg_mode hangs on
> ghosts trying to retreive it.
> 
> > > No, you still need to rescan for new valid paths outside the dm target
> > control,
> > > as a path going ghost often implies a ghost going valid. The new valid path
> > must
> > > be added to the dm target to restore the redondancy level and nominal
> > performance.
> > > This rescan must be triggered on path failure. and this is vendor-specific
> > too.
> > 
> > The vendor specific thing is the initiator then and should address
> > device-mapping changes.
> > 
> As above
> 
> > 
> > What about given MD multipath ?
> > How does this work together with that array ?
> >
> awfully :)
> I may be able to autoconfigure md mps at boot, but :
> With ghosts included in md : a failover can elect a ghost then hang forever
> (certainly true with a dm mp target too, but failfast could change that ?)
> With ghosts excluded of md : I need a callback on path failure to hotadd
> activated ghosts. This callback is absent (mdadm does that asynchronously but I
> had not luck with that feature)
> Both solutions : the selected active path going ghost leaves me hung, with no
> failover happening (as you do load balancing you will certainly hit by that even
> more)
> 

Get's us back to my other argument: ghosts should _never_ hang, they should
report an error.

> 
> We have had 3 hot spots in this thread :
> 
> 1) failure notification on ghost IO path is needed : hanging is not acceptable
> Agreement reached here :)

Good :)

> 
> 2) multipath support for "bizarre" arrays need a userspace callback on path failure.
> Agreement seems to be reached. Still not clear what provides this callback :
> MD/DM or Block Layer ?

Presumably device-mapper multipath is the one we end up with at the
end of the day, the answer is DM (the status information retrievable from
DM provides it already)

> 
> 3) multipath implementation need to be separate from volume managers. (DM is not
> a volume manger, LVM2 & EVMS are !)
> Agreement not reached :(

Seems more to be a misunderstanding we have ITR to me.

Our multipathing target is part of device-mapper, which is completely
seperate from LVM2, EVMS, ...
Those volume manager applications _use_ device-mapper as the mapping runtime
by providing appropriate mapping tables to be loaded into device-mapper
or unloaded from it. There can be others (such as EVMS).

As I mentioned before: dmsetup is the device-mapper tool which supports
such (un)loading of mapping tables _without_ any line of LVM2 (or arbitrary
other volume management application) code at all.

Setting up a multipath mapping using dmsetup means creating a one line
mapping table with a couple of parameters per path (see multipath target
code we plan to release next week).

> 
> Do others on this list have comments/opinions ?
> 
> regards,
> cvaroqui
> -- 

-- 

Regards,
Heinz    -- The LVM Guy --

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
