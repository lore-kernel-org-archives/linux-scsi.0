From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v5 02/12] libata: bind the Linux device tree to the
 ACPI device tree
Date: Thu, 21 Jun 2012 14:37:06 +0800
Message-ID: <1340260626.24067.4.camel@minggr>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
	 <1340000766-129148-3-git-send-email-ming.m.lin@intel.com>
	 <CAA9_cmcX2pajewz1v864Ni2Z3XAy8UrCRg+mg3Y2qFEd2j=nDg@mail.gmail.com>
	 <1340242002.20081.84.camel@minggr>
	 <CAA9_cmfCVTWtqfDY4PAzK_yaVWXLV+oMO1qt_AtQKp2upPUX=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmfCVTWtqfDY4PAzK_yaVWXLV+oMO1qt_AtQKp2upPUX=Q@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <David.Woodhouse@intel.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-06-20 at 20:59 -0700, Dan Williams wrote:
> On Wed, Jun 20, 2012 at 6:26 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> > On Wed, 2012-06-20 at 16:50 -0700, Dan Williams wrote:
> >> On Sun, Jun 17, 2012 at 11:25 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> >> > From: Matthew Garrett <mjg@redhat.com>
> >> >
> >> > Associate the ACPI device tree and libata devices.
> >> > This patch uses the generic ACPI glue framework to do so.
> >> >
> >> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> >> > Signed-off-by: Holger Macht <holger@homac.de>
> >> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> >> > ---
> >> >
> >> > Changelog:
> >> >
> >> > - fixed crash reported at https://lkml.org/lkml/2012/2/24/2 (Aaron Lu)
> >> > - rename is_pci_ata to compat_pci_ata (Alan Cox)
> >> >
> >> >  drivers/acpi/glue.c       |    4 +-
> >> >  drivers/ata/libata-acpi.c |  125 +++++++++++++++++++++++++++++++++++++++++++++
> >> >  drivers/ata/libata-core.c |    3 ++
> >> >  drivers/ata/libata.h      |    4 ++
> >> >  4 files changed, 134 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
> >> > index 1564e09..18d6812 100644
> >> > --- a/drivers/acpi/glue.c
> >> > +++ b/drivers/acpi/glue.c
> >> [..]
> >> > +static int ata_acpi_bind_host(struct device *dev, int host, acpi_handle *handle)
> >> > +{
> >> > +       struct Scsi_Host *shost = dev_to_shost(dev);
> >> > +       struct ata_port *ap = ata_shost_to_port(shost);
> >> > +
> >> > +       if (ap->flags & ATA_FLAG_ACPI_SATA)
> >> > +               return -ENODEV;
> >> > +
> >> > +       *handle = acpi_get_child(DEVICE_ACPI_HANDLE(dev->parent), ap->port_no);
> >> > +
> >> > +       if (!*handle)
> >> > +               return -ENODEV;
> >> > +
> >> > +       return 0;
> >> > +}
> >>
> >> I think this patch should be squashed with patch 4, right?  That is if
> >> we keep the hard-coded ->parent chasing...
> >
> > Right. Will merge patch 4.
> >
> >>
> >> > +static int ata_acpi_find_device(struct device *dev, acpi_handle *handle)
> >> > +{
> >> > +       unsigned int host, channel, id, lun;
> >> > +
> >> > +       if (sscanf(dev_name(dev), "host%u", &host) == 1) {
> >> > +               if (!compat_pci_ata(dev->parent))
> >> > +                       return -ENODEV;
> >> > +
> >> > +               return ata_acpi_bind_host(dev, host, handle);
> >> > +       } else if (sscanf(dev_name(dev), "%d:%d:%d:%d",
> >> > +                       &host, &channel, &id, &lun) == 4) {
> >> > +               if (!compat_pci_ata(dev->parent->parent->parent))
> >> > +                       return -ENODEV;
> >>
> >> ...this looks like it should be using a dev_to_ata_port() helper which
> >> like dev_to_shost() skips the need to remember just how many parents
> >> until we get back to our ata_port, scsi_host, etc.
> >
> > Oh, no.
> >
> > compat_pci_ata checks whether the controller(rather than shost or ata
> > port) is pci SATA/IDE controller.
> >
> > As in patch 4:
> > compat_pci_ata(dev->parent->parent->parent->parent)
> >
> > The "dev" is ata port, and dev->parent->parent->parent->parent points to
> > the controller dev.
> >
> > This looks ugly. How about add two helpers?
> > shost_to_controller(dev) and ata_port_to_controller(dev)
> >
> 
> What about something like the following (untested)?  Makes it mostly
> independent of the topology, gives some type safety, and drops some
> redundant work finding the ata_port.
> 
> static int ata_acpi_find_device(struct device *dev, acpi_handle *handle)
> {
>         struct ata_port *ap = dev_to_ata_port(dev);
> 
>         if (!ap)
>                 return -ENODEV;
> 
>         if (!compat_pci_ata(ap))
>                 return -ENODEV;
> 
>         if (scsi_is_host_device(dev))
>                 return ata_acpi_bind_host(ap, handle);
>         else if (scsi_is_sdev_device(dev)) {
>                 struct scsi_device *sdev = to_scsi_device(dev);
> 
>                 return ata_acpi_bind_device(ap, sdev->channel,
> sdev->id, handle);
>         } else
>                 return -ENODEV;
> }

Good idea.

Below is the incremental patch on top of this series.

 drivers/ata/libata-acpi.c |   56 +++++++++++++++++++++++++++------------------
 drivers/ata/libata-core.c |    2 --
 drivers/ata/libata.h      |    2 ++
 3 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 08edebf..4112eaa 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -1075,8 +1075,9 @@ void ata_acpi_unbind(struct ata_device *dev)
 	ata_acpi_unregister_power_resource(dev);
 }
 
-static int compat_pci_ata(struct device *dev)
+static int compat_pci_ata(struct ata_port *ap)
 {
+	struct device *dev = ap->tdev.parent;
 	struct pci_dev *pdev;
 
 	if (!is_pci_dev(dev))
@@ -1091,15 +1092,13 @@ static int compat_pci_ata(struct device *dev)
 	return 1;
 }
 
-static int ata_acpi_bind_host(struct device *dev, int host, acpi_handle *handle)
+static int ata_acpi_bind_host(struct ata_port *ap, acpi_handle *handle)
 {
-	struct Scsi_Host *shost = dev_to_shost(dev);
-	struct ata_port *ap = ata_shost_to_port(shost);
-
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		return -ENODEV;
 
-	*handle = acpi_get_child(DEVICE_ACPI_HANDLE(dev->parent->parent), ap->port_no);
+	*handle = acpi_get_child(DEVICE_ACPI_HANDLE(ap->tdev.parent),
+			ap->port_no);
 
 	if (!*handle)
 		return -ENODEV;
@@ -1107,21 +1106,18 @@ static int ata_acpi_bind_host(struct device *dev, int host, acpi_handle *handle)
 	return 0;
 }
 
-static int ata_acpi_bind_device(struct device *dev, int channel, int id,
+static int ata_acpi_bind_device(struct ata_port *ap, struct scsi_device *sdev,
 				acpi_handle *handle)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
-	struct Scsi_Host *shost = sdev->host;
-	struct ata_port *ap = ata_shost_to_port(shost);
 	struct ata_device *ata_dev;
 	acpi_status status;
 	struct acpi_device *acpi_dev;
 	struct acpi_device_power_state *states;
 
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
-		ata_dev = &ap->link.device[channel];
+		ata_dev = &ap->link.device[sdev->channel];
 	else
-		ata_dev = &ap->link.device[id];
+		ata_dev = &ap->link.device[sdev->id];
 
 	*handle = ata_dev_acpi_handle(ata_dev);
 
@@ -1146,21 +1142,37 @@ static int ata_acpi_bind_device(struct device *dev, int channel, int id,
 	return 0;
 }
 
+static int is_ata_port(const struct device *dev)
+{
+	return dev->type == &ata_port_type;
+}
+
+static struct ata_port *dev_to_ata_port(struct device *dev)
+{
+	while (!is_ata_port(dev)) {
+		if (!dev->parent)
+			return NULL;
+		dev = dev->parent;
+	}
+	return to_ata_port(dev);
+}
+
 static int ata_acpi_find_device(struct device *dev, acpi_handle *handle)
 {
-	unsigned int host, channel, id, lun;
+	struct ata_port *ap = dev_to_ata_port(dev);
 
-	if (sscanf(dev_name(dev), "host%u", &host) == 1) {
-		if (!compat_pci_ata(dev->parent->parent))
-			return -ENODEV;
+	if (!ap)
+		return -ENODEV;
+
+	if (!compat_pci_ata(ap))
+		return -ENODEV;
 
-		return ata_acpi_bind_host(dev, host, handle);
-	} else if (sscanf(dev_name(dev), "%d:%d:%d:%d",
-			&host, &channel, &id, &lun) == 4) {
-		if (!compat_pci_ata(dev->parent->parent->parent->parent))
-			return -ENODEV;
+	if (scsi_is_host_device(dev))
+		return ata_acpi_bind_host(ap, handle);
+	else if (scsi_is_sdev_device(dev)) {
+		struct scsi_device *sdev = to_scsi_device(dev);
 
-		return ata_acpi_bind_device(dev, channel, id, handle);
+		return ata_acpi_bind_device(ap, sdev, handle);
 	} else
 		return -ENODEV;
 }
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ba169c4..c14f88c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5291,8 +5291,6 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 	return rc;
 }
 
-#define to_ata_port(d) container_of(d, struct ata_port, tdev)
-
 static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
 {
 	struct ata_port *ap = to_ata_port(dev);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index b0ba924..44a7939 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -107,6 +107,8 @@ extern const char *sata_spd_string(unsigned int spd);
 extern int ata_port_probe(struct ata_port *ap);
 extern void __ata_port_probe(struct ata_port *ap);
 
+#define to_ata_port(d) container_of(d, struct ata_port, tdev)
+
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
 extern unsigned int ata_acpi_gtf_filter;



