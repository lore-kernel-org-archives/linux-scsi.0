From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
Date: Tue, 14 Feb 2012 23:36:28 +0100
Message-ID: <201202142336.28706.rjw@sisk.pl>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com> <201202132148.04961.rjw@sisk.pl> <1329206396.19384.58.camel@rui.sh.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1329206396.19384.58.camel@rui.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday, February 14, 2012, Zhang Rui wrote:
> On =E4=B8=80, 2012-02-13 at 21:48 +0100, Rafael J. Wysocki wrote:
> > On Monday, February 13, 2012, Lin Ming wrote:
> > > From: Zhang Rui <rui.zhang@intel.com>
> > >=20
> > > ACPI Power Resource can power on/off a couple of devices.
> > > Introduce interfaces to register/unregister a device to/from
> > > an ACPI Power Resource.
> > >=20
> > > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > > ---
> > >  drivers/acpi/power.c    |  128 +++++++++++++++++++++++++++++++++=
++++++++++++++
> > >  include/acpi/acpi_bus.h |    2 +
> > >  2 files changed, 130 insertions(+), 0 deletions(-)
> > >=20
> > > diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> > > index 0d681fb..a7e2305 100644
> > > --- a/drivers/acpi/power.c
> > > +++ b/drivers/acpi/power.c
> > > @@ -84,10 +84,25 @@ struct acpi_power_resource {
> > >  	u32 order;
> > >  	unsigned int ref_count;
> > >  	struct mutex resource_lock;
> > > +	struct list_head devices; /* list for devices powered by this P=
R */
> > >  };
> > > =20
> > >  static struct list_head acpi_power_resource_list;
> > > =20
> > > +/*
> > > + * When a power resource is turned on, all the devices are put t=
o an uninitialized
> > > + * state although their ACPI states are still D0.
> > > + * To handle this, we need to keep a list of all devices powered=
 by the power resource,
> > > + * and resume all of them.
> > > + * Currently, we only support this case:
> > > + * 1) multiple devices share the same power resoruce,
> > > + * 2) One device uses One Power Resource ONLY.
> >=20
> > This is incorrect.  We actually support all combinations.
>=20
> Agreed.
>=20
> >   However, we don't
> > generally support checking what devices depend on the given power r=
esource.
> >=20
> Yes.
> But all the code in this patch is for runtime D3_COLD support only.
> At least for the BIOS code on hand, a device that support runtime
> D3_COLD uses one ACPI Power Resource only.
> We can add the support for all combinations if there are such kind of
> BIOS in the market, which I do not think there would be.
>=20
> Besides, as a RFC version, I do not want to make a over designed
> proposal at the beginning.
>=20
> > > + */
> > > +struct acpi_powered_device {
> > > +	struct list_head node;
> > > +	struct device *dev;
> > > +};
> > > +
> > >  /* -------------------------------------------------------------=
-------------
> > >                               Power Resource Management
> > >     -------------------------------------------------------------=
------------- */
> > > @@ -455,6 +470,118 @@ int acpi_disable_wakeup_device_power(struct=
 acpi_device *dev)
> > >                               Device Power Management
> > >     -------------------------------------------------------------=
------------- */
> > > =20
> > > +int acpi_power_resource_register_device(struct device *dev, acpi=
_handle handle)
> > > +{
> > > +	struct acpi_power_resource *resource;
> > > +	struct acpi_device *acpi_dev, *res_dev;
> > > +	acpi_handle res_handle =3D NULL;
> > > +	struct acpi_powered_device *apd;
> > > +	int i;
> > > +	int ret;
> > > +
> > > +	if (!handle || !dev)
> > > +		return -EINVAL;
> > > +
> > > +	ret =3D acpi_bus_get_device(handle, &acpi_dev);
> > > +	if (ret)
> > > +		goto no_power_resource;
> > > +
> > > +	if (!acpi_dev->power.flags.power_resources)
> > > +		goto no_power_resource;
> > > +
> > > +	for (i =3D 0; i <=3D ACPI_STATE_D3; i++) {
> > > +		struct acpi_device_power_state *ps =3D &acpi_dev->power.states=
[i];
> > > +
> > > +		if (!ps->flags.valid)
> > > +			continue;
> > > +
> > > +		if (ps->resources.count > 1)
> > > +			return 0;
> > > +
> > > +		if (!res_handle)
> > > +			res_handle =3D ps->resources.handles[0];
> > > +		else if (res_handle !=3D ps->resources.handles[0])
> > > +			return 0;
> > > +	}
> >=20
> > I'm not sure what the above checks are needed for.  It seems that t=
his function
> > will only be called from acpi_bus_add_power_resource() (which needs=
 to be
> > modified for this purpose, BTW), so it doesn't need to check all th=
ose things
> > (those checks have been made already).
> >=20
> No. These two APIs are introduced to support the runtime D3_COLD remo=
te
> wakeup. And they should be invoked by drivers, either in driver code =
or
> via bus layer code.
>=20
> Say, ATA port, who has _PR3 in its ACPI node, knows that it can enter
> D3_COLD at run time, and it supports remote wakeup in D3_COLD because=
 it
> has _S0W (return value 4).
> When remote wakeup event is triggered, there is an ACPI event sent to
> the ATA controller/port, which sets the ATA controller/port back to D=
0
> state.
> At this time, what we actually need is to resume the ZPODD, rather th=
an
> the ATA controller/port. To follow the runtime PM model (runtime resu=
me
> starts from leaf devices),

Well, this isn't the case.  Parents are always resumed first.

> ATA code can use these two APIs to tell ACPI
> to runtime resume ZPODD device directly, because ZPODD is powered by
> this Power Resource as well.

I'm not exactly sure what you're trying to achieve and what you mean by
"resume a device directly"?  Do you want to run the device's resume
callback at the time when another device is being resumed?

Rafael
