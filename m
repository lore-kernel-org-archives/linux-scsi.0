From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 02/12] libata: bind the Linux device tree to the ACPI
 device tree
Date: Wed, 20 Jun 2012 16:50:50 -0700
Message-ID: <CAA9_cmcX2pajewz1v864Ni2Z3XAy8UrCRg+mg3Y2qFEd2j=nDg@mail.gmail.com>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
	<1340000766-129148-3-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1340000766-129148-3-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <David.Woodhouse@intel.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 17, 2012 at 11:25 PM, Lin Ming <ming.m.lin@intel.com> wrote=
:
> From: Matthew Garrett <mjg@redhat.com>
>
> Associate the ACPI device tree and libata devices.
> This patch uses the generic ACPI glue framework to do so.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Holger Macht <holger@homac.de>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>
> Changelog:
>
> - fixed crash reported at https://lkml.org/lkml/2012/2/24/2 (Aaron Lu=
)
> - rename is_pci_ata to compat_pci_ata (Alan Cox)
>
> =A0drivers/acpi/glue.c =A0 =A0 =A0 | =A0 =A04 +-
> =A0drivers/ata/libata-acpi.c | =A0125 +++++++++++++++++++++++++++++++=
++++++++++++++
> =A0drivers/ata/libata-core.c | =A0 =A03 ++
> =A0drivers/ata/libata.h =A0 =A0 =A0| =A0 =A04 ++
> =A04 files changed, 134 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
> index 1564e09..18d6812 100644
> --- a/drivers/acpi/glue.c
> +++ b/drivers/acpi/glue.c
[..]
> +static int ata_acpi_bind_host(struct device *dev, int host, acpi_han=
dle *handle)
> +{
> + =A0 =A0 =A0 struct Scsi_Host *shost =3D dev_to_shost(dev);
> + =A0 =A0 =A0 struct ata_port *ap =3D ata_shost_to_port(shost);
> +
> + =A0 =A0 =A0 if (ap->flags & ATA_FLAG_ACPI_SATA)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
> +
> + =A0 =A0 =A0 *handle =3D acpi_get_child(DEVICE_ACPI_HANDLE(dev->pare=
nt), ap->port_no);
> +
> + =A0 =A0 =A0 if (!*handle)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
> +
> + =A0 =A0 =A0 return 0;
> +}

I think this patch should be squashed with patch 4, right?  That is if
we keep the hard-coded ->parent chasing...

> +static int ata_acpi_find_device(struct device *dev, acpi_handle *han=
dle)
> +{
> + =A0 =A0 =A0 unsigned int host, channel, id, lun;
> +
> + =A0 =A0 =A0 if (sscanf(dev_name(dev), "host%u", &host) =3D=3D 1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!compat_pci_ata(dev->parent))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ata_acpi_bind_host(dev, host, ha=
ndle);
> + =A0 =A0 =A0 } else if (sscanf(dev_name(dev), "%d:%d:%d:%d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &host, &channel, &id, &=
lun) =3D=3D 4) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!compat_pci_ata(dev->parent->parent=
->parent))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;

=2E..this looks like it should be using a dev_to_ata_port() helper whic=
h
like dev_to_shost() skips the need to remember just how many parents
until we get back to our ata_port, scsi_host, etc.

--
Dan
