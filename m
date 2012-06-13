From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v4 02/13] libata: bind the Linux device tree to the ACPI
 device tree
Date: Wed, 13 Jun 2012 12:00:50 +0100
Message-ID: <20120613120050.164c3f29@pyramind.ukuu.org.uk>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
	<1338181720-4149-3-git-send-email-ming.m.lin@intel.com>
	<20120528105131.67d74d45@pyramind.ukuu.org.uk>
	<CAF1ivSYBjw+UP3vP8RHaftjR8NJZEaHA1rtJ5ujDjkj-djHLTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSYBjw+UP3vP8RHaftjR8NJZEaHA1rtJ5ujDjkj-djHLTQ@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <David.Woodhouse@intel.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 13 Jun 2012 16:03:23 +0800
Lin Ming <ming.m.lin@intel.com> wrote:

> On Mon, May 28, 2012 at 5:51 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> =
wrote:
> >> +static int is_pci_ata(struct device *dev)
> >> +{
> >> + =A0 =A0 struct pci_dev *pdev;
> >> +
> >> + =A0 =A0 if (!is_pci_dev(dev))
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >> +
> >> + =A0 =A0 pdev =3D to_pci_dev(dev);
> >> +
> >> + =A0 =A0 if ((pdev->class >> 8) !=3D PCI_CLASS_STORAGE_SATA &&
> >> + =A0 =A0 =A0 =A0 (pdev->class >> 8) !=3D PCI_CLASS_STORAGE_IDE)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >
> > This needs a better name. It doesn't check if a device is PCI ATA o=
r
> > anything of the sort, it checks if its probably a device in compati=
bility
> > mode. A lot of controllers will in fact report RAID class or simila=
r in
> > native mode.
>=20
> How about compat_pci_ata?

Sounds reasonable. I'm not btw sure the test is entirely right, but I'm
not sure quite what you are trying to figure out from it and how ACPI
expects this mapping to work.

Alan
--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
