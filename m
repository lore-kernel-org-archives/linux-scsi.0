From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Sat, 18 Feb 2012 21:35:06 +0100
Message-ID: <201202182135.06868.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org> <201202180054.49284.rjw@sisk.pl> <CAC=cRTOCpH8haMGDEDDG8k0k2DpaVM7DoU5AayrcscR1rZKXgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAC=cRTOCpH8haMGDEDDG8k0k2DpaVM7DoU5AayrcscR1rZKXgQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Saturday, February 18, 2012, huang ying wrote:
> On Sat, Feb 18, 2012 at 7:54 AM, Rafael J. Wysocki <rjw@sisk.pl> wrot=
e:
> > On Thursday, February 16, 2012, Zhang Rui wrote:
> >> On =E4=BA=8C, 2012-02-14 at 23:39 +0100, Rafael J. Wysocki wrote:
> >> > On Tuesday, February 14, 2012, Zhang Rui wrote:
> >> > > On =E4=B8=80, 2012-02-13 at 20:38 +0100, Rafael J. Wysocki wro=
te:
> >> > > > On Monday, February 13, 2012, Alan Stern wrote:
> >> > > > > On Mon, 13 Feb 2012, Lin Ming wrote:
> [snip]
> >> Yeah, I have thought about this for quite a while before, there AR=
E
> >> several ways to do this, but these need a lot of changes in bus co=
de, at
> >> least for the buses that support device runtime D3 (off) by ACPI.
> >>
> >> Lets also take SATA port and ZPODD for example,
> >> proposal one,
> >> 1) introduce scsi_can_power_off and ata_can_power_off.
> >> 2) sr driver set scsi_can_power_off bit and scsi layer is aware of=
 this,
> >> thus the scsi host can set this bit as well.
> >> 3) in the .runtime_suspend callback of ata port, it knows that its=
 scsi
> >> host interface can be powered off, thus it invokes ata_can_power_o=
ff to
> >> tell the ata layer.
> >
> > Hmm.  I'm not sure why you want to introduce this special "power of=
f"
> > condition.  In fact, it's nothing special, it only means that the d=
evice
> > in question shouldn't be accessed by software, which pretty much is=
 equivalent
> > to the "suspended" condition (as defined in the runtime PM docs).
>=20
> I think some reasons to introduce can_poweroff can be:
>=20
> 1) To indicate the implementation of .runtime_suspend/.runtime_resume
> is compatible with power off.  That is, .runtime_suspend will save al=
l
> needed information and .runtime_resume can work on the uninitialized
> device.
>=20
> If this is already the requirement of
> .runtime_suspend/.runtime_resume.

Yes, it is.

> Then this is not needed.   Maybe we
> can make that explicitly for these callbacks via some kind of
> documentation.

I thought it was documented.

> 2) To support something like pm-qos.  power off device may have more
> exit.latency than normal low power state (such as D3Hot).  Some devic=
e
> may disable can_power_off based on that.

No, please.  There would be totally _no_ _meaning_ of that flag at the =
core
level.  Please use subsys_data in struct dev_pm_info for subsystem-spec=
ific
data (which is this one).

> 3) Whether to go to power off should be determined by leaf device
> (such as SATA disk), but that may be done by its parent device (such
> as SATA port).  It's a way for leaf device to tell its parent device
> whether it want to go to power off.

Well, please see above.

Thanks,
Rafael
