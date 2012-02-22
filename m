From: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Wed, 22 Feb 2012 08:57:47 +0800
Message-ID: <1329872267.1511.76.camel@rui.sh.intel.com>
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org>
	 <201202210013.02397.rjw@sisk.pl>
	 <1329786806.1511.54.camel@rui.sh.intel.com>
	 <201202212243.52788.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201202212243.52788.rjw@sisk.pl>
Sender: linux-ide-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On =E4=BA=8C, 2012-02-21 at 22:43 +0100, Rafael J. Wysocki wrote:
> On Tuesday, February 21, 2012, Zhang Rui wrote:
> > On =E4=BA=8C, 2012-02-21 at 00:13 +0100, Rafael J. Wysocki wrote:
> > > > So how to handle this case, say, for a device in the generic PM=
 domain
> > > > that supports 2 different low power state, D1 and D2.
> > > > D2 is deeper than D1, and it is kind of cold power off with rem=
ote
> > > > wakeup disabled. If the driver needs to runtime suspend the dev=
ice with
> > > > remote wakeup enabled, it should set the device to D1, but it c=
an not
> > > > set the RPM_SUSPEND?
> > >=20
> > > The device is regarded as "suspended" if its bus type's (or PM do=
main's)
> > > .runtime_suspend() callback has been executed and has returned 0 =
(success).
> > > What the callback has actually done is not of any interest to the=
 core.
> > >=20
> > right.
> >=20
> > > Now, the D1 and D2 case has to be handled by the bus (PM domain) =
and
> > > driver.  In both cases the device will be regarded as "suspended"=
 and the
> > > core doesn't track the actual device state.
> > >=20
> >=20
> >=20
> > > I think the problem here is that the PCI bus type's runtime PM ca=
llbacks
> > > aren't very sophisticated (they just choose the lowest possible l=
ow-power
> > > state and attempt to put the device into it) and I can see two po=
ssible
> > > ways to address that.
> > >=20
> > > First, you can modify pci_pm_runtime_suspend/_resume() to handle =
multiple
> > > states (for example, to choose the target low-power state more in=
telligently
> > > than they do right now).  Second, you can add a PM domain that wi=
ll do what
> > > you want from pci_pm_runtime_suspend/_resume() for a specific set=
 of devices.
> > >=20
> > But RPM_SUSPENDED is set by PM core after .runtime_suspend() being
> > invoked, even if device is in D1 instead of D2, right?
> >=20
> > So the problem is that, if a device in a generic power domain suppo=
rts
> > two low power state, one is compatible with generic power domain po=
wer
> > off and another is not, how can the device driver pass this informa=
tion
> > to the generic power domain, i.e. how to runtime suspend a device w=
hile
> > keep the generic power domain always on?
>=20
> There are two "low-power" levels in the generic PM domains framework.=
  The
> first one is the per-device low-power in which devices are put into t=
heir
> individual (programmable) low-power states by the domain .dev_ops->st=
op()
> callback.  The second one is when .stop() has been called for all dev=
ices,
> so presumably all of them are in programmable low-power states and it=
's
> possible to switch the entire domain off.  This is done by the domain
> .power_off() callback.
>=20
> It seems that the trick might be to make .dev_ops->stop() avoid turni=
ng off
> power resources for the last suspending device in the domain and leav=
e that
> to domain .power_off().
>=20
Yeah, that's a good idea.
so how about this proposal for ZPODD.
1. create an ACPI generic power domain for every device that has an _PR=
3
   method, the SATA port in this case.
2. add sr device to the generic power domain via genpd APIs.
   this can be done either in ATA port driver or in sr driver.
3. the .power_off callback of the generic power domain
   a) checks if all the devices allows power off (for the trick above)
   b) turns off the power resources in _PR3.

thanks,
rui

