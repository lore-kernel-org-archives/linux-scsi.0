From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
Date: Fri, 17 Feb 2012 23:34:04 +0100
Message-ID: <201202172334.04301.rjw@sisk.pl>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com> <201202142336.28706.rjw@sisk.pl> <1329376686.28581.15.camel@rui.sh.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1329376686.28581.15.camel@rui.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thursday, February 16, 2012, Zhang Rui wrote:
> On =E4=BA=8C, 2012-02-14 at 23:36 +0100, Rafael J. Wysocki wrote:
> > > > > + */
> > > > > +struct acpi_powered_device {
> > > > > +	struct list_head node;
> > > > > +	struct device *dev;
> > > > > +};
> > > > > +
> > > > >  /* ---------------------------------------------------------=
-----------------
> > > > >                               Power Resource Management
> > > > >     ---------------------------------------------------------=
----------------- */
> > > > > @@ -455,6 +470,118 @@ int acpi_disable_wakeup_device_power(st=
ruct acpi_device *dev)
> > > > >                               Device Power Management
> > > > >     ---------------------------------------------------------=
----------------- */
> > > > > =20
> > > > > +int acpi_power_resource_register_device(struct device *dev, =
acpi_handle handle)
> > > > > +{
> > > > > +	struct acpi_power_resource *resource;
> > > > > +	struct acpi_device *acpi_dev, *res_dev;
> > > > > +	acpi_handle res_handle =3D NULL;
> > > > > +	struct acpi_powered_device *apd;
> > > > > +	int i;
> > > > > +	int ret;
> > > > > +
> > > > > +	if (!handle || !dev)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	ret =3D acpi_bus_get_device(handle, &acpi_dev);
> > > > > +	if (ret)
> > > > > +		goto no_power_resource;
> > > > > +
> > > > > +	if (!acpi_dev->power.flags.power_resources)
> > > > > +		goto no_power_resource;
> > > > > +
> > > > > +	for (i =3D 0; i <=3D ACPI_STATE_D3; i++) {
> > > > > +		struct acpi_device_power_state *ps =3D &acpi_dev->power.st=
ates[i];
> > > > > +
> > > > > +		if (!ps->flags.valid)
> > > > > +			continue;
> > > > > +
> > > > > +		if (ps->resources.count > 1)
> > > > > +			return 0;
> > > > > +
> > > > > +		if (!res_handle)
> > > > > +			res_handle =3D ps->resources.handles[0];
> > > > > +		else if (res_handle !=3D ps->resources.handles[0])
> > > > > +			return 0;
> > > > > +	}
> > > >=20
> > > > I'm not sure what the above checks are needed for.  It seems th=
at this function
> > > > will only be called from acpi_bus_add_power_resource() (which n=
eeds to be
> > > > modified for this purpose, BTW), so it doesn't need to check al=
l those things
> > > > (those checks have been made already).
> > > >=20
> > > No. These two APIs are introduced to support the runtime D3_COLD =
remote
> > > wakeup. And they should be invoked by drivers, either in driver c=
ode or
> > > via bus layer code.
> > >=20
> > > Say, ATA port, who has _PR3 in its ACPI node, knows that it can e=
nter
> > > D3_COLD at run time, and it supports remote wakeup in D3_COLD bec=
ause it
> > > has _S0W (return value 4).
> > > When remote wakeup event is triggered, there is an ACPI event sen=
t to
> > > the ATA controller/port, which sets the ATA controller/port back =
to D0
> > > state.
> > > At this time, what we actually need is to resume the ZPODD, rathe=
r than
> > > the ATA controller/port. To follow the runtime PM model (runtime =
resume
> > > starts from leaf devices),
> >=20
> > Well, this isn't the case.  Parents are always resumed first.
> >=20
> Well, I mean runtime resume request issued by leaf devices first.

That still causes runtime PM callbacks for parents to be run before run=
time PM
callbacks for the children.

It is impossible to runtime-resume a child device (using the runtime PM
framework's functions at least) if the parent of it is not "active".

> > > ATA code can use these two APIs to tell ACPI
> > > to runtime resume ZPODD device directly, because ZPODD is powered=
 by
> > > this Power Resource as well.
> >=20
> > I'm not exactly sure what you're trying to achieve and what you mea=
n by
> > "resume a device directly"?  Do you want to run the device's resume
> > callback at the time when another device is being resumed?
> >=20
> I mean, wakeup event is sent to ATA port, but our goal is to resume
> ZPODD after receiving this wakeup event.
> Ideally, it is ACPI that resumes ATA port. And then, the ATA port
> runtime resumes ZPODD. But this does not look good to runtime resume =
a
> child device in the parent's .runtime_resume callback.

OK, I think I see what the problem is.

> So I introduced these two APIs so that an runtime_resume request can =
be
> sent to ZPODD directly and the runtime PM core can resume all the
> parents of ZPODD automatically.

It seems that you're confusing things.  In the Linux driver model a dev=
ice
cannot have more than a single parent.

Thanks,
Rafael
