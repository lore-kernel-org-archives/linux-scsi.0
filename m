From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 3/3] libata: Change transport topology layout
Date: Fri, 28 Sep 2012 14:38:22 +0800
Message-ID: <20120928063820.GA19771@aaronlu.sh.intel.com>
References: <20120920020145.GA23210@mint-spring.sh.intel.com>
 <1348772644-12486-4-git-send-email-gwendal@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1348772644-12486-4-git-send-email-gwendal@google.com>
Sender: linux-ide-owner@vger.kernel.org
To: Gwendal Grignou <gwendal@google.com>
Cc: minggr@gmail.com, tj@kernel.org, jgarzik@pobox.com, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 27, 2012 at 12:04:04PM -0700, Gwendal Grignou wrote:
> Integrate ata objects [port, link, device] with scsi objects.
> 
> 
> The path of a scsi device is:
> .../0000:00:1f.2/host0/ata1/link1/dev1.0/target0:0:0/0:0:0:0

After test, I noticed that this will break the current ata acpi binding
code, but can be fixed with the following changes:

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 30eb7177..459c5b4 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -978,7 +978,7 @@ void ata_acpi_on_disable(struct ata_device *dev)
 
 static int compat_pci_ata(struct ata_port *ap)
 {
-	struct device *dev = ap->tdev.parent;
+	struct device *dev = ap->host->dev;
 	struct pci_dev *pdev;
 
 	if (!is_pci_dev(dev))
@@ -998,7 +998,7 @@ static int ata_acpi_bind_host(struct ata_port *ap, acpi_handle *handle)
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		return -ENODEV;
 
-	*handle = acpi_get_child(DEVICE_ACPI_HANDLE(ap->tdev.parent),
+	*handle = acpi_get_child(DEVICE_ACPI_HANDLE(ap->host->dev),
 			ap->port_no);
 
 	if (!*handle)
@@ -1061,7 +1061,12 @@ static struct ata_port *dev_to_ata_port(struct device *dev)
 
 static int ata_acpi_find_device(struct device *dev, acpi_handle *handle)
 {
-	struct ata_port *ap = dev_to_ata_port(dev);
+	struct ata_port *ap;
+
+	if (scsi_is_host_device(dev))
+		ap = ata_shost_to_port(dev_to_shost(dev));
+	else
+		ap = dev_to_ata_port(dev);
 
 	if (!ap)
 		return -ENODEV;


And to make zero power ODD function, the following changes to enable
runtime pm with no callbacks for the ata_link/ata_device transport
devices are necessary.

diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index c04d393..ce91bd2 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -421,6 +421,10 @@ int ata_tlink_add(struct ata_link *link)
 		goto tlink_err;
 	}
 
+	pm_runtime_no_callbacks(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	transport_add_device(dev);
 	transport_configure_device(dev);
 
@@ -649,6 +653,10 @@ static int ata_tdev_add(struct ata_device *ata_dev)
 		return error;
 	}
 
+	pm_runtime_no_callbacks(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	transport_add_device(dev);
 	transport_configure_device(dev);
 	return 0;

There is no other problems I can see.
Should I prepare a patch to addess the 2 issues?

Thanks,
Aaron

> 
> or when a port multiplier is present: for instance the device in port 4 of the
> port multiplier:
> .../0000:00:06.0/0000:09:00.0/host5/ata6/link6.4/dev6.4.0/target5:4:0/5:4:0:0
> 
> 
> Change-Id: I202e089208e8746ccdaf2053d43da831a0c0976d
> 
> Signed-off-by: Gwendal Grignou <gwendal@google.com>
> ---
>  drivers/ata/libata-core.c      |   13 ++++++-------
>  drivers/ata/libata-scsi.c      |    4 ++--
>  drivers/ata/libata-transport.c |    2 +-
>  3 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 611050d..c83590b 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -6063,19 +6063,18 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
>  	for (i = 0; i < host->n_ports; i++)
>  		host->ports[i]->print_id = atomic_inc_return(&ata_print_id);
>  
> +	rc = ata_scsi_add_hosts(host, sht);
> +	if (rc)
> +		return rc;
>  
>  	/* Create associated sysfs transport objects  */
>  	for (i = 0; i < host->n_ports; i++) {
> -		rc = ata_tport_add(host->dev,host->ports[i]);
> -		if (rc) {
> +		struct ata_port *ap = host->ports[i];
> +		rc = ata_tport_add(&ap->scsi_host->shost_gendev, ap);
> +		if (rc)
>  			goto err_tadd;
> -		}
>  	}
>  
> -	rc = ata_scsi_add_hosts(host, sht);
> -	if (rc)
> -		goto err_tadd;
> -
>  	/* set cable, sata_spd_limit and report */
>  	for (i = 0; i < host->n_ports; i++) {
>  		struct ata_port *ap = host->ports[i];
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index bfda61f..9023bb1 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3649,8 +3649,8 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>  			else
>  				channel = link->pmp;
>  
> -			sdev = __scsi_add_device(&ap->scsi_host->shost_gendev,
> -						 channel, id, 0, NULL);
> +			sdev = __scsi_add_device(&dev->tdev, channel, id, 0,
> +						 NULL);
>  			if (!IS_ERR(sdev)) {
>  				dev->sdev = sdev;
>  				scsi_device_put(sdev);
> diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
> index c04d393..6829be6 100644
> --- a/drivers/ata/libata-transport.c
> +++ b/drivers/ata/libata-transport.c
> @@ -284,7 +284,7 @@ int ata_tport_add(struct device *parent,
>  
>  	dev->parent = get_device(parent);
>  	dev->release = ata_tport_release;
> -	dev_set_name(dev, "ata%d", ap->print_id);
> +	dev_set_name(dev, "port%d", ap->print_id);
>  	transport_setup_device(dev);
>  	error = device_add(dev);
>  	if (error) {
> -- 
> 1.7.7.3
> 
