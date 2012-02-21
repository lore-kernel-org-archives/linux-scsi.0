From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Tue, 21 Feb 2012 22:43:52 +0100
Message-ID: <201202212243.52788.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org> <201202210013.02397.rjw@sisk.pl> <1329786806.1511.54.camel@rui.sh.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1329786806.1511.54.camel@rui.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday, February 21, 2012, Zhang Rui wrote:
> On =E4=BA=8C, 2012-02-21 at 00:13 +0100, Rafael J. Wysocki wrote:
> > > So how to handle this case, say, for a device in the generic PM d=
omain
> > > that supports 2 different low power state, D1 and D2.
> > > D2 is deeper than D1, and it is kind of cold power off with remot=
e
> > > wakeup disabled. If the driver needs to runtime suspend the devic=
e with
> > > remote wakeup enabled, it should set the device to D1, but it can=
 not
> > > set the RPM_SUSPEND?
> >=20
> > The device is regarded as "suspended" if its bus type's (or PM doma=
in's)
> > .runtime_suspend() callback has been executed and has returned 0 (s=
uccess).
> > What the callback has actually done is not of any interest to the c=
ore.
> >=20
> right.
>=20
> > Now, the D1 and D2 case has to be handled by the bus (PM domain) an=
d
> > driver.  In both cases the device will be regarded as "suspended" a=
nd the
> > core doesn't track the actual device state.
> >=20
>=20
>=20
> > I think the problem here is that the PCI bus type's runtime PM call=
backs
> > aren't very sophisticated (they just choose the lowest possible low=
-power
> > state and attempt to put the device into it) and I can see two poss=
ible
> > ways to address that.
> >=20
> > First, you can modify pci_pm_runtime_suspend/_resume() to handle mu=
ltiple
> > states (for example, to choose the target low-power state more inte=
lligently
> > than they do right now).  Second, you can add a PM domain that will=
 do what
> > you want from pci_pm_runtime_suspend/_resume() for a specific set o=
f devices.
> >=20
> But RPM_SUSPENDED is set by PM core after .runtime_suspend() being
> invoked, even if device is in D1 instead of D2, right?
>=20
> So the problem is that, if a device in a generic power domain support=
s
> two low power state, one is compatible with generic power domain powe=
r
> off and another is not, how can the device driver pass this informati=
on
> to the generic power domain, i.e. how to runtime suspend a device whi=
le
> keep the generic power domain always on?

There are two "low-power" levels in the generic PM domains framework.  =
The
first one is the per-device low-power in which devices are put into the=
ir
individual (programmable) low-power states by the domain .dev_ops->stop=
()
callback.  The second one is when .stop() has been called for all devic=
es,
so presumably all of them are in programmable low-power states and it's
possible to switch the entire domain off.  This is done by the domain
=2Epower_off() callback.

It seems that the trick might be to make .dev_ops->stop() avoid turning=
 off
power resources for the last suspending device in the domain and leave =
that
to domain .power_off().

Thanks,
Rafael
