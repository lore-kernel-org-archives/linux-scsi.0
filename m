From: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Tue, 14 Feb 2012 14:07:07 +0800
Message-ID: <1329199627.19384.6.camel@rui.sh.intel.com>
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7395 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab2BNGHU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2012 01:07:20 -0500
In-Reply-To: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org

On =E4=B8=80, 2012-02-13 at 10:01 -0500, Alan Stern wrote:
> On Mon, 13 Feb 2012, Lin Ming wrote:
>=20
> > From: Zhang Rui <rui.zhang@intel.com>
> >=20
> > Introduce flag can_power_off in device structure to support runtime
> > power off/on.
> >=20
> > Note that, for a specific device driver,
> > "support runtime power off/on" means that the driver .runtime_suspe=
nd
> > callback needs to
> > 1) save all the context so that it can restore the device back to t=
he previous
> >    working state after powered on.
> > 2) set can_power_off flag to tell the driver model that it's ready =
for power off.
> >=20
> > The following example shows how this works.
> >=20
> > device A
> >  |---------|
> >  v         v
> > device B  device C
> >=20
> > A is the parent of device B and device C, and device A/B/C shares t=
he
> > same power logic
> > (Only device A knows how to turn on/off the power).
> >=20
> > In order to power off A, B, C at runtime,
> > 1) device B and device C should support runtime power off
> >    (runtime suspended with can_power_off flag set)
> > 2) pm idle request for device A is fired by runtime PM core.
> > 3) in device A .runtime_suspend callback, it tries to set can_power=
_off flag.
> > 4) if succeed, it means all its children have been ready for power =
off
> >    and it can turn off the power at any time.
> > 5) if failed, it means at least one of its children does not suppor=
t runtime
> >    power off, thus the power can not be turned off.
>=20
> I'm not sure if this is really the right approach.  What you're tryin=
g=20
> to do is implement two different low-power states, basically D3hot an=
d=20
> D3cold.  Currently the runtime PM core doesn't support such things; a=
ll=20
> it knows about is low power and full power.
>=20
Exactly.
what I'm trying to fix here is to add a "special" runtime low power
state, aka, power off.

> Before doing an ad-hoc implementation, it would be best to step back
> and think about other subsystems.  Other sorts of devices may well ha=
ve
> multiple low-power states.  What's the best way for this to be
> supported by the PM core?
>=20
I thought about this before, e.g. introduce support for multiple runtim=
e
low power states in runtime PM core, like suspend/hibernate for system
low power states. But I'm not sure if this is workable because the low
power states varies between devices/buses/platforms.

So I decided to introduce a special low power state, aka, runtime power
off, first, which means the same thing to different
devices/buses/platforms.

thanks,
rui


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
