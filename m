From: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Tue, 21 Feb 2012 09:13:26 +0800
Message-ID: <1329786806.1511.54.camel@rui.sh.intel.com>
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org>
	 <201202180054.49284.rjw@sisk.pl>
	 <1329708181.1511.18.camel@rui.sh.intel.com>
	 <201202210013.02397.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201202210013.02397.rjw@sisk.pl>
Sender: linux-ide-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On =E4=BA=8C, 2012-02-21 at 00:13 +0100, Rafael J. Wysocki wrote:
> > So how to handle this case, say, for a device in the generic PM dom=
ain
> > that supports 2 different low power state, D1 and D2.
> > D2 is deeper than D1, and it is kind of cold power off with remote
> > wakeup disabled. If the driver needs to runtime suspend the device =
with
> > remote wakeup enabled, it should set the device to D1, but it can n=
ot
> > set the RPM_SUSPEND?
>=20
> The device is regarded as "suspended" if its bus type's (or PM domain=
's)
> .runtime_suspend() callback has been executed and has returned 0 (suc=
cess).
> What the callback has actually done is not of any interest to the cor=
e.
>=20
right.

> Now, the D1 and D2 case has to be handled by the bus (PM domain) and
> driver.  In both cases the device will be regarded as "suspended" and=
 the
> core doesn't track the actual device state.
>=20


> I think the problem here is that the PCI bus type's runtime PM callba=
cks
> aren't very sophisticated (they just choose the lowest possible low-p=
ower
> state and attempt to put the device into it) and I can see two possib=
le
> ways to address that.
>=20
> First, you can modify pci_pm_runtime_suspend/_resume() to handle mult=
iple
> states (for example, to choose the target low-power state more intell=
igently
> than they do right now).  Second, you can add a PM domain that will d=
o what
> you want from pci_pm_runtime_suspend/_resume() for a specific set of =
devices.
>=20
But RPM_SUSPENDED is set by PM core after .runtime_suspend() being
invoked, even if device is in D1 instead of D2, right?

So the problem is that, if a device in a generic power domain supports
two low power state, one is compatible with generic power domain power
off and another is not, how can the device driver pass this information
to the generic power domain, i.e. how to runtime suspend a device while
keep the generic power domain always on?

thanks,
rui

