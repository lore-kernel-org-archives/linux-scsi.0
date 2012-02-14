From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Tue, 14 Feb 2012 23:39:59 +0100
Message-ID: <201202142339.59423.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org> <201202132038.12927.rjw@sisk.pl> <1329200243.19384.16.camel@rui.sh.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1329200243.19384.16.camel@rui.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday, February 14, 2012, Zhang Rui wrote:
> On =E4=B8=80, 2012-02-13 at 20:38 +0100, Rafael J. Wysocki wrote:
> > On Monday, February 13, 2012, Alan Stern wrote:
> > > On Mon, 13 Feb 2012, Lin Ming wrote:
> > >=20
> > > > From: Zhang Rui <rui.zhang@intel.com>
> > > >=20
> > > > Introduce flag can_power_off in device structure to support run=
time
> > > > power off/on.
> > > >=20
> > > > Note that, for a specific device driver,
> > > > "support runtime power off/on" means that the driver .runtime_s=
uspend
> > > > callback needs to
> > > > 1) save all the context so that it can restore the device back =
to the previous
> > > >    working state after powered on.
> > > > 2) set can_power_off flag to tell the driver model that it's re=
ady for power off.
> > > >=20
> > > > The following example shows how this works.
> > > >=20
> > > > device A
> > > >  |---------|
> > > >  v         v
> > > > device B  device C
> > > >=20
> > > > A is the parent of device B and device C, and device A/B/C shar=
es the
> > > > same power logic
> > > > (Only device A knows how to turn on/off the power).
> > > >=20
> > > > In order to power off A, B, C at runtime,
> > > > 1) device B and device C should support runtime power off
> > > >    (runtime suspended with can_power_off flag set)
> > > > 2) pm idle request for device A is fired by runtime PM core.
> > > > 3) in device A .runtime_suspend callback, it tries to set can_p=
ower_off flag.
> > > > 4) if succeed, it means all its children have been ready for po=
wer off
> > > >    and it can turn off the power at any time.
> > > > 5) if failed, it means at least one of its children does not su=
pport runtime
> > > >    power off, thus the power can not be turned off.
> > >=20
> > > I'm not sure if this is really the right approach.  What you're t=
rying=20
> > > to do is implement two different low-power states, basically D3ho=
t and=20
> > > D3cold.  Currently the runtime PM core doesn't support such thing=
s; all=20
> > > it knows about is low power and full power.
> >=20
> > I'd rather say all it knows about is "suspended" and "active", whic=
h mean
> > "the device is not processing I/O" and "the device may be processin=
g I/O",
> > respectively.  A "suspended" device may or may not be in a low-powe=
r state,
> > but the runtime PM core doesn't care about that.
> >=20
> yes, I know that.
>=20
> > > Before doing an ad-hoc implementation, it would be best to step b=
ack
> > > and think about other subsystems.  Other sorts of devices may wel=
l have
> > > multiple low-power states.  What's the best way for this to be
> > > supported by the PM core?
> >=20
> > Well, I honestly don't think there's any way they all can be covere=
d at the
> > same time and that's why we chose to support only "suspended" and "=
active"
> > as defined above.
>=20
> > The handling of multiple low-power states must be
> > implemented outside of the runtime PM core (like in the PCI core, f=
or example).
>=20
> Surely I'd prefer to implement it in the bus code, :), but the proble=
m
> is that several buses maybe involved at the same time.
> Let's take ZPODD for example,
> ZPODD is attached to a SATA port. Only SATA port knows that it can be
> runtime powered off, because its ACPI node has _PR3._OFF.
> But when ATA layer code tries to put SATA port to D3_COLD at runtime,=
it
> must make sure all the devices/drivers in the same power domain are
> ready for power off, and in this case, we need to get this info from
> SCSI layer.

Then you need to get it from there.  I know that this is a difficult pr=
oblem,
have been working on a similar one for several months now. :-)

Thanks,
Rafael
