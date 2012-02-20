From: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Mon, 20 Feb 2012 11:23:01 +0800
Message-ID: <1329708181.1511.18.camel@rui.sh.intel.com>
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org>
	 <201202142339.59423.rjw@sisk.pl>
	 <1329378119.28581.34.camel@rui.sh.intel.com>
	 <201202180054.49284.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201202180054.49284.rjw@sisk.pl>
Sender: linux-ide-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On =E5=85=AD, 2012-02-18 at 00:54 +0100, Rafael J. Wysocki wrote:
>=20
> > > have been working on a similar one for several months now. :-)
> >=20
> > That's why generic power domain is introduced?
> > Can you tell me what's your idea please?
> > It would be GREAT if you can share your experience on this.
>=20
> Well, a power domain (which seems to be what you have in the ZPODD ca=
se)
> is analogous to a package with multiple CPU cores.  In that case you
> can put individual cores into per-core low-power ("idle") states (tha=
t
> roughly corresponds to the D1-D3hot device states) or you can put the
> whole package into a low-power state ("package idle") resulting in th=
e
> removal of power from all the cores (more-or-less).  Now, it has to b=
e
> decided which approach to use and if the "package idle" is used, it m=
ay
> be necessary to restore the cores' "state" when they are "resumed".
>=20
> Analogously, for devices in a power domain you usually can use some
> programmable mechanism to put each of them into some sort of a low-po=
wer
> state (e.g. D3hot or "stop clock" etc.) such that the device may be p=
rogrammed
> to go out of it.  Alternatively, you can use a different mechanism to
> remove power from the entire domain, in which case devices, when powe=
r is
> restored, may need to be re-initialized.  Of course, you need to know=
 when
> this happens, so that you know when to carry out the re-initializatio=
n.
>=20
> Our approach in the generic PM domains framework is, essentially, to =
provide
> a special set of PM callbacks ("domain callbacks") that are run (by t=
he PM
> core) instead of bus-type PM callbacks.  Those domain callbacks are a=
dded to
> every device in the domain through its pm_domain pointer.  Of course,=
 this
> means that devices have to be added to the domains explicitly and we =
have some
> helpers for that.  We also use some additional data structures allowi=
ng the
> domain callbacks to track devices in the domain.
>=20
> Now, when a device in a domain is "suspended" (meaning its runtime PM=
 status
> changes from "active" to "suspended"), the domain callbacks check if =
this is
> the last device in the domain whose status is "active" at that point.=
  If
> that is not the case, they simply call a special .stop() callback to =
put the
> device into a "normal" per-device low-power state (the .stop() callba=
ck may be
> defined per device and in principle it may be designed to call the bu=
s-type
> or driver .runtime_suspend() callback for the device).  Otherwise (i.=
e. if
> this is the last device in the domain whose status was "active" befor=
e) and if
> the PM QoS constraints allow that to happen, power is removed from th=
e domain
> as a whole.  Then, all devices in the domain are marked as "need re-i=
nit upon
> resume" and the resume domain callbacks take care of re-initializing =
them as
> appropriate when their status changes from "suspended" back to "activ=
e".  [The
> domain callbacks use the subsys_data pointer in dev_pm_info to attach=
 their own
> data to device objects.]
>=20
> The actual code is more complicated than that, but that's the idea.
>=20
Yeah, I have read the generic PM domain code before. and I have a
question about the generic PM domain code.

genpd->pow_off is invoked if all devices in a generic PM domain are
pm_runtime_suspended(). This suggests that the device driver can set
RPM_SUSPENDED flag only if it is able to bring the device from a cold
power off, right?

So how to handle this case, say, for a device in the generic PM domain
that supports 2 different low power state, D1 and D2.
D2 is deeper than D1, and it is kind of cold power off with remote
wakeup disabled. If the driver needs to runtime suspend the device with
remote wakeup enabled, it should set the device to D1, but it can not
set the RPM_SUSPEND?

thanks,
rui


