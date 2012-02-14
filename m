From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Tue, 14 Feb 2012 23:38:13 +0100
Message-ID: <201202142338.13516.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1202131534040.11382-100000@iolanthe.rowland.org> <1329203489.19384.39.camel@rui.sh.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1329203489.19384.39.camel@rui.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday, February 14, 2012, Zhang Rui wrote:
> Hi, Alan,
>=20
> On =E4=B8=80, 2012-02-13 at 15:41 -0500, Alan Stern wrote:
> > On Mon, 13 Feb 2012, Rafael J. Wysocki wrote:
> >=20
> > > > I'm not sure if this is really the right approach.  What you're=
 trying=20
> > > > to do is implement two different low-power states, basically D3=
hot and=20
> > > > D3cold.  Currently the runtime PM core doesn't support such thi=
ngs; all=20
> > > > it knows about is low power and full power.
> > >=20
> > > I'd rather say all it knows about is "suspended" and "active", wh=
ich mean
> > > "the device is not processing I/O" and "the device may be process=
ing I/O",
> > > respectively.  A "suspended" device may or may not be in a low-po=
wer state,
> > > but the runtime PM core doesn't care about that.
> >=20
> > Yes, okay.  We can say that this patch tries to implement two diffe=
rent=20
> > "suspended" states, basically "low power" and "power off" (or D3hot=
 and=20
> > D3cold).
> >=20
> Right!
>=20
> > > > Before doing an ad-hoc implementation, it would be best to step=
 back
> > > > and think about other subsystems.  Other sorts of devices may w=
ell have
> > > > multiple low-power states.  What's the best way for this to be
> > > > supported by the PM core?
> > >=20
> > > Well, I honestly don't think there's any way they all can be cove=
red at the
> > > same time and that's why we chose to support only "suspended" and=
 "active"
> > > as defined above.  The handling of multiple low-power states must=
 be
> > > implemented outside of the runtime PM core (like in the PCI core,=
 for example).
> >=20
> > That's the point.  If this is to be implemented outside of the runt=
ime
> > PM core, should the patch be allowed to add new fields to struct
> > dev_pm_info (which has to be shared among all subsystems)?
> >=20
> Surely it shouldn't in this case.
>=20
> > Or to put it another way, if we do add new fields to struct dev_pm_=
info
> > (like can_power_off) in order to help support multiple "suspended" =
=20
> > states, shouldn't these new fields be such that they can be used by
> > many different subsystems rather than being special for the
> > full-power/no-power situation?
> >=20
> My opinion is that the concept of "no-power state" is unique for all
> devices/buses/platforms.

No, it is not, basically because of power domains.  If they are used,
then individual device power states are not well defined at all.

> If any of them support this, they can use the routines without any
> confusion.

No, they can't.

Thanks,
Rafael
