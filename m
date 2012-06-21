From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 02/12] libata: bind the Linux device tree to the ACPI
 device tree
Date: Wed, 20 Jun 2012 20:59:20 -0700
Message-ID: <CAA9_cmfCVTWtqfDY4PAzK_yaVWXLV+oMO1qt_AtQKp2upPUX=Q@mail.gmail.com>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
	<1340000766-129148-3-git-send-email-ming.m.lin@intel.com>
	<CAA9_cmcX2pajewz1v864Ni2Z3XAy8UrCRg+mg3Y2qFEd2j=nDg@mail.gmail.com>
	<1340242002.20081.84.camel@minggr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1340242002.20081.84.camel@minggr>
Sender: linux-acpi-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <David.Woodhouse@intel.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 20, 2012 at 6:26 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Wed, 2012-06-20 at 16:50 -0700, Dan Williams wrote:
>> On Sun, Jun 17, 2012 at 11:25 PM, Lin Ming <ming.m.lin@intel.com> wr=
ote:
>> > From: Matthew Garrett <mjg@redhat.com>
>> >
>> > Associate the ACPI device tree and libata devices.
>> > This patch uses the generic ACPI glue framework to do so.
>> >
>> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
>> > Signed-off-by: Holger Macht <holger@homac.de>
>> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
>> > ---
>> >
>> > Changelog:
>> >
>> > - fixed crash reported at https://lkml.org/lkml/2012/2/24/2 (Aaron=
 Lu)
>> > - rename is_pci_ata to compat_pci_ata (Alan Cox)
>> >
>> > =A0drivers/acpi/glue.c =A0 =A0 =A0 | =A0 =A04 +-
>> > =A0drivers/ata/libata-acpi.c | =A0125 ++++++++++++++++++++++++++++=
+++++++++++++++++
>> > =A0drivers/ata/libata-core.c | =A0 =A03 ++
>> > =A0drivers/ata/libata.h =A0 =A0 =A0| =A0 =A04 ++
>> > =A04 files changed, 134 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
>> > index 1564e09..18d6812 100644
>> > --- a/drivers/acpi/glue.c
>> > +++ b/drivers/acpi/glue.c
>> [..]
>> > +static int ata_acpi_bind_host(struct device *dev, int host, acpi_=
handle *handle)
>> > +{
>> > + =A0 =A0 =A0 struct Scsi_Host *shost =3D dev_to_shost(dev);
>> > + =A0 =A0 =A0 struct ata_port *ap =3D ata_shost_to_port(shost);
>> > +
>> > + =A0 =A0 =A0 if (ap->flags & ATA_FLAG_ACPI_SATA)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
>> > +
>> > + =A0 =A0 =A0 *handle =3D acpi_get_child(DEVICE_ACPI_HANDLE(dev->p=
arent), ap->port_no);
>> > +
>> > + =A0 =A0 =A0 if (!*handle)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
>> > +
>> > + =A0 =A0 =A0 return 0;
>> > +}
>>
>> I think this patch should be squashed with patch 4, right? =A0That i=
s if
>> we keep the hard-coded ->parent chasing...
>
> Right. Will merge patch 4.
>
>>
>> > +static int ata_acpi_find_device(struct device *dev, acpi_handle *=
handle)
>> > +{
>> > + =A0 =A0 =A0 unsigned int host, channel, id, lun;
>> > +
>> > + =A0 =A0 =A0 if (sscanf(dev_name(dev), "host%u", &host) =3D=3D 1)=
 {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!compat_pci_ata(dev->parent))
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ata_acpi_bind_host(dev, host,=
 handle);
>> > + =A0 =A0 =A0 } else if (sscanf(dev_name(dev), "%d:%d:%d:%d",
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &host, &channel, &id=
, &lun) =3D=3D 4) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!compat_pci_ata(dev->parent->par=
ent->parent))
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
>>
>> ...this looks like it should be using a dev_to_ata_port() helper whi=
ch
>> like dev_to_shost() skips the need to remember just how many parents
>> until we get back to our ata_port, scsi_host, etc.
>
> Oh, no.
>
> compat_pci_ata checks whether the controller(rather than shost or ata
> port) is pci SATA/IDE controller.
>
> As in patch 4:
> compat_pci_ata(dev->parent->parent->parent->parent)
>
> The "dev" is ata port, and dev->parent->parent->parent->parent points=
 to
> the controller dev.
>
> This looks ugly. How about add two helpers?
> shost_to_controller(dev) and ata_port_to_controller(dev)
>

What about something like the following (untested)?  Makes it mostly
independent of the topology, gives some type safety, and drops some
redundant work finding the ata_port.

static int ata_acpi_find_device(struct device *dev, acpi_handle *handle=
)
{
        struct ata_port *ap =3D dev_to_ata_port(dev);

        if (!ap)
                return -ENODEV;

        if (!compat_pci_ata(ap))
                return -ENODEV;

        if (scsi_is_host_device(dev))
                return ata_acpi_bind_host(ap, handle);
        else if (scsi_is_sdev_device(dev)) {
                struct scsi_device *sdev =3D to_scsi_device(dev);

                return ata_acpi_bind_device(ap, sdev->channel,
sdev->id, handle);
        } else
                return -ENODEV;
}
--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
