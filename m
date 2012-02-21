From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
Date: Tue, 21 Feb 2012 11:06:39 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202211059180.1366-100000@iolanthe.rowland.org>
References: <CAF1ivSY4-cYsHjrM3g5D_Skt=mCxvKuLWc+fgGDEgE2XaZN+gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSY4-cYsHjrM3g5D_Skt=mCxvKuLWc+fgGDEgE2XaZN+gQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 21 Feb 2012, Lin Ming wrote:

> > Then maybe you can use pm_runtime_no_callbacks() for the ZPODD devi=
ce.
> > It's explained in Documentation/power/runtime_pm.txt, and I use it =
for
> > USB interfaces.
>=20
> If pm_runtime_no_callbacks() is used, runtime PM sysfs attributes
> won't be created.
> Then how to disable ZPODD feature in userspace?
>=20
> Currently, I use "control" file of scsi device to enable/disable
> ZPODD, for example
> echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata0/host1/target1:0=
:0/1:0:0:0/power/control
> echo on > /sys/devices/pci0000:00/0000:00:1f.2/ata0/host1/target1:0:0=
/1:0:0:0/power/control

You could get the same result by using the "control" file for the ATA
port.

> > The idea is that the ZPODD will never receive any runtime PM callba=
cks
> > from the PM core. =A0Instead the ATA port callback routines will be
> > responsible for power management of the ZPODD device.
>=20
> Does the ATA port callback also responsible to resume its child?
>=20
> For example,
> /sys/devices/pci0000:00/0000:00:1f.2/ata0/host1/target1:0:0/1:0:0:0/
>=20
> ata0 is resumed.
>=20
> Then who will be responsible to resume host1, target1:0:0 and 1:0:0:0=
?
>=20
> Or do you mean that we don't need to resume these devices at all?
> host1 and target1:0:0 are logical devices, but I think 1:0:0:0 is not=
=2E

That's right.  It makes no difference whether the host and target=20
are resumed or suspended.  In fact, you could also call=20
pm_runtime_no_callbacks() for them.

Alan Stern

