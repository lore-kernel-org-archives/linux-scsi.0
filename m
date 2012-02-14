From: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Tue, 14 Feb 2012 15:11:29 +0800
Message-ID: <1329203489.19384.39.camel@rui.sh.intel.com>
References: <Pine.LNX.4.44L0.1202131534040.11382-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:57074 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab2BNHLm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2012 02:11:42 -0500
In-Reply-To: <Pine.LNX.4.44L0.1202131534040.11382-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org

Hi, Alan,

On =E4=B8=80, 2012-02-13 at 15:41 -0500, Alan Stern wrote:
> On Mon, 13 Feb 2012, Rafael J. Wysocki wrote:
>=20
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
>=20
> Yes, okay.  We can say that this patch tries to implement two differe=
nt=20
> "suspended" states, basically "low power" and "power off" (or D3hot a=
nd=20
> D3cold).
>=20
Right!

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
> > as defined above.  The handling of multiple low-power states must b=
e
> > implemented outside of the runtime PM core (like in the PCI core, f=
or example).
>=20
> That's the point.  If this is to be implemented outside of the runtim=
e
> PM core, should the patch be allowed to add new fields to struct
> dev_pm_info (which has to be shared among all subsystems)?
>=20
Surely it shouldn't in this case.

> Or to put it another way, if we do add new fields to struct dev_pm_in=
fo
> (like can_power_off) in order to help support multiple "suspended" =20
> states, shouldn't these new fields be such that they can be used by
> many different subsystems rather than being special for the
> full-power/no-power situation?
>=20
My opinion is that the concept of "no-power state" is unique for all
devices/buses/platforms.
If any of them support this, they can use the routines without any
confusion.

thanks,
rui

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
