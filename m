From: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH 1/6] ACPI: Introduce ACPI D3_COLD state support
Date: Thu, 16 Feb 2012 15:08:26 +0800
Message-ID: <1329376106.28581.5.camel@rui.sh.intel.com>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
	 <201202132125.15537.rjw@sisk.pl>
	 <1329203228.19384.35.camel@rui.sh.intel.com>
	 <201202142329.16516.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <201202142329.16516.rjw@sisk.pl>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On =E4=BA=8C, 2012-02-14 at 23:29 +0100, Rafael J. Wysocki wrote:
> On Tuesday, February 14, 2012, Zhang Rui wrote:
> > Hi, Rafael,
> >=20
> > On =E4=B8=80, 2012-02-13 at 21:25 +0100, Rafael J. Wysocki wrote:
> > > On Monday, February 13, 2012, Lin Ming wrote:
> > > > From: Zhang Rui <rui.zhang@intel.com>
> > > >=20
> > > > If a device has _PR3._ON, it means the device supports D3_HOT.
> > > > If a device has _PR3._OFF, it means the device supports D3_COLD=
=2E
> > > > Add the ability to validate and enter D3_COLD state in ACPI.
> > > >=20
> > > > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > >=20
> > > This is supposed to be ACPI 5.0 support, right?
> > >=20
> > No, D3_HOT is introduced in ACPI spec 4.0.
> > According to the spec, _PR3 is used for devices that support both
> > D3(D3_COLD) and D3HOT.
>=20
> Yes, it does.
>=20
> > The confusion here is that Linux D3 equals ACPICA D3HOT and Linux
> > D3_COLD equals ACPICA D3.
> > For example, when enter Linux ACPI D3, the reference count of ACPI =
Power
> > Resources in _PR3 is increased by one.
>=20
> That's correct.
>=20
> > > So can anyone please tell me what part of the ACPI 5.0 spec is th=
e
> > > basis of this patch, because I can't see that immediately?
> > >=20
> > > The only places where D3Cold is _mentioned_ are Section 7.2.12 (_=
PRE, which
> > > appears to be new in 5.0), Section 7.2.20 (_S0W), Section 7.2.21 =
(_S1W),
> > > Section 7.2.22 (_S2W), Section 7.2.23 (_S3W) and Section 7.2.24 (=
_S4W).
> > > None of them mentions those _PR3._ON and _PR3._OFF things above.
> > >=20
> > > Moreover, my understanding of the spec is that D3Cold means all o=
f the
> > > power resources returned by _PR3 are "off" (whereas some of them =
will be
> > > "on" in D3hot).
> > >=20
> > Agreed.
> >=20
> > > > ---
> > > >  drivers/acpi/power.c |    4 ++--
> > > >  drivers/acpi/scan.c  |   10 +++++++++-
> > > >  2 files changed, 11 insertions(+), 3 deletions(-)
> > > >=20
> > > > diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> > > > index 9ac2a9f..0d681fb 100644
> > > > --- a/drivers/acpi/power.c
> > > > +++ b/drivers/acpi/power.c
> > > > @@ -500,14 +500,14 @@ int acpi_power_transition(struct acpi_dev=
ice *device, int state)
> > > >  {
> > > >  	int result;
> > > > =20
> > > > -	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE=
_D3))
> > > > +	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE=
_D3_COLD))
> > > >  		return -EINVAL;
> > > > =20
> > > >  	if (device->power.state =3D=3D state)
> > > >  		return 0;
> > > > =20
> > > >  	if ((device->power.state < ACPI_STATE_D0)
> > > > -	    || (device->power.state > ACPI_STATE_D3))
> > > > +	    || (device->power.state > ACPI_STATE_D3_COLD))
> > > >  		return -ENODEV;
> > > > =20
> > > >  	/* TBD: Resources must be ordered. */
> > > > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > > > index 8ab80ba..a9d4391 100644
> > > > --- a/drivers/acpi/scan.c
> > > > +++ b/drivers/acpi/scan.c
> > > > @@ -881,8 +881,16 @@ static int acpi_bus_get_power_flags(struct=
 acpi_device *device)
> > > > =20
> > > >  			device->power.flags.power_resources =3D 1;
> > > >  			ps->flags.valid =3D 1;
> > > > -			for (j =3D 0; j < ps->resources.count; j++)
> > > > +			for (j =3D 0; j < ps->resources.count; j++) {
> > > >  				acpi_bus_add_power_resource(ps->resources.handles[j]);
> > > > +				/* Check for D3_COLD support. _PR3._OFF equals D3_COLD ? *=
/
> > > > +				if (i =3D=3D ACPI_STATE_D3) {
> > > > +					if (j =3D=3D 0)
> > > > +						device->power.states[ACPI_STATE_D3_COLD].flags.valid =3D=
 1;
> > > > +					status =3D acpi_get_handle(ps->resources.handles[j], "_OF=
=46",  &handle);
> > > > +					device->power.states[ACPI_STATE_D3_COLD].flags.valid &=3D=
 ACPI_SUCCESS(status);
> > > > +				}
> > > > +			}
> > >=20
> > > Sorry, but this doesn't make sense to me.  Power resources always=
 have
> > > the _OFF method, right?
> > >=20
> > I'm not sure.
>=20
> That would be explicitly against the spec that says that power resour=
ces
> are *required* to have _ON, _OFF and _STA.
>=20
> > I thought I had seen ACPI Power Resources without _OFF
> > control method somewhere in bugzilla, but I can not find it out now=
=2E
>=20
> That, clearly, is a firmware bug.
>=20
Okay, agreed.
so how about this? _PR3 equals D3_HOT support.

> > Hmm, how about set D3_COLD support if _PR3 exists, but leave a warn=
ing
> > message if _OFF doesn't exist, for now?
>=20
> I don't think we need to set D3_COLD support at all.  In fact, it is =
always
> supported (as I said, if all power resources used by a device are off=
, the
> device is in D3_COLD pretty much by definition).
>=20
Yeah, but it seems that Linux uses ACPI_D3 for both ACPICA D3_HOT and D=
3
(off). I'm generating a patch to remove ACPI_D3_COLD and introduce
D3_HOT support in Linux kernel.

thanks,
rui

--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
