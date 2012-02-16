From: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
Date: Thu, 16 Feb 2012 15:18:06 +0800
Message-ID: <1329376686.28581.15.camel@rui.sh.intel.com>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
	 <201202132148.04961.rjw@sisk.pl>
	 <1329206396.19384.58.camel@rui.sh.intel.com>
	 <201202142336.28706.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201202142336.28706.rjw@sisk.pl>
Sender: linux-ide-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On =E4=BA=8C, 2012-02-14 at 23:36 +0100, Rafael J. Wysocki wrote:
> > > > + */
> > > > +struct acpi_powered_device {
> > > > +	struct list_head node;
> > > > +	struct device *dev;
> > > > +};
> > > > +
> > > >  /* -----------------------------------------------------------=
---------------
> > > >                               Power Resource Management
> > > >     -----------------------------------------------------------=
--------------- */
> > > > @@ -455,6 +470,118 @@ int acpi_disable_wakeup_device_power(stru=
ct acpi_device *dev)
> > > >                               Device Power Management
> > > >     -----------------------------------------------------------=
--------------- */
> > > > =20
> > > > +int acpi_power_resource_register_device(struct device *dev, ac=
pi_handle handle)
> > > > +{
> > > > +	struct acpi_power_resource *resource;
> > > > +	struct acpi_device *acpi_dev, *res_dev;
> > > > +	acpi_handle res_handle =3D NULL;
> > > > +	struct acpi_powered_device *apd;
> > > > +	int i;
> > > > +	int ret;
> > > > +
> > > > +	if (!handle || !dev)
> > > > +		return -EINVAL;
> > > > +
> > > > +	ret =3D acpi_bus_get_device(handle, &acpi_dev);
> > > > +	if (ret)
> > > > +		goto no_power_resource;
> > > > +
> > > > +	if (!acpi_dev->power.flags.power_resources)
> > > > +		goto no_power_resource;
> > > > +
> > > > +	for (i =3D 0; i <=3D ACPI_STATE_D3; i++) {
> > > > +		struct acpi_device_power_state *ps =3D &acpi_dev->power.stat=
es[i];
> > > > +
> > > > +		if (!ps->flags.valid)
> > > > +			continue;
> > > > +
> > > > +		if (ps->resources.count > 1)
> > > > +			return 0;
> > > > +
> > > > +		if (!res_handle)
> > > > +			res_handle =3D ps->resources.handles[0];
> > > > +		else if (res_handle !=3D ps->resources.handles[0])
> > > > +			return 0;
> > > > +	}
> > >=20
> > > I'm not sure what the above checks are needed for.  It seems that=
 this function
> > > will only be called from acpi_bus_add_power_resource() (which nee=
ds to be
> > > modified for this purpose, BTW), so it doesn't need to check all =
those things
> > > (those checks have been made already).
> > >=20
> > No. These two APIs are introduced to support the runtime D3_COLD re=
mote
> > wakeup. And they should be invoked by drivers, either in driver cod=
e or
> > via bus layer code.
> >=20
> > Say, ATA port, who has _PR3 in its ACPI node, knows that it can ent=
er
> > D3_COLD at run time, and it supports remote wakeup in D3_COLD becau=
se it
> > has _S0W (return value 4).
> > When remote wakeup event is triggered, there is an ACPI event sent =
to
> > the ATA controller/port, which sets the ATA controller/port back to=
 D0
> > state.
> > At this time, what we actually need is to resume the ZPODD, rather =
than
> > the ATA controller/port. To follow the runtime PM model (runtime re=
sume
> > starts from leaf devices),
>=20
> Well, this isn't the case.  Parents are always resumed first.
>=20
Well, I mean runtime resume request issued by leaf devices first.

> > ATA code can use these two APIs to tell ACPI
> > to runtime resume ZPODD device directly, because ZPODD is powered b=
y
> > this Power Resource as well.
>=20
> I'm not exactly sure what you're trying to achieve and what you mean =
by
> "resume a device directly"?  Do you want to run the device's resume
> callback at the time when another device is being resumed?
>=20
I mean, wakeup event is sent to ATA port, but our goal is to resume
ZPODD after receiving this wakeup event.
Ideally, it is ACPI that resumes ATA port. And then, the ATA port
runtime resumes ZPODD. But this does not look good to runtime resume a
child device in the parent's .runtime_resume callback.
So I introduced these two APIs so that an runtime_resume request can be
sent to ZPODD directly and the runtime PM core can resume all the
parents of ZPODD automatically.

thanks,
rui

