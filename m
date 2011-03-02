From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Should isci create its own device class?
Date: Wed, 02 Mar 2011 10:38:45 -0800
Message-ID: <1299091125.11010.4.camel@dwillia2-linux>
References: <4D6DB7FF.4090506@intel.com>
	 <1299070146.604.3.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36786 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab1CBSOT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2011 13:14:19 -0500
In-Reply-To: <1299070146.604.3.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>

On Wed, 2011-03-02 at 04:49 -0800, James Bottomley wrote:
> On Tue, 2011-03-01 at 19:22 -0800, Dan Williams wrote:
> > For compatibility with other software raid environments an isci [1] 
> > device may contain up to two controller instances per pci device.
> 
> So every other SCSI card I've seen that's done this, the multiple
> controllers have been different PCI functions, and thus distinguishable
> at the PCI level ... why is isci different?
> 

The existence of multiple SAS controllers is hidden behind a single
"RAID controller" in environments where software RAID is "request" based
and cannot span controllers with a single driver instance.  Linux
software RAID in contrast is bio based and controller spanning happens
naturally.

> > Currently the sysfs path for its scsi_host objects is:
> > > ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:08.0/0000:03:00.0/host10/scsi_host/host10
> > > ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:08.0/0000:03:00.0/host11/scsi_host/host11
> > 
> > But to reflect reality the pci device is actually the parent of two 
> > independent controller instances.  With a mockup like:
> > > ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:08.0/0000:03:00.0/controller0/host10/scsi_host/host10
> > > ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:08.0/0000:03:00.0/controller1/host11/scsi_host/host11
> > 
> > I can see this being beneficial in a few ways:
> > 
> > 1/ fix dev_printk() messages which right now give an ambiguous "isci 
> > 0000:03:00.0" prefix
> > 2/ controller boundaries are visible via the sysfs path without need to 
> > to look at sas_addresses to determine the controller.
> > 2/ if we ever wanted to support some per controller attributes between 
> > the global pci attributes and the scsi_host attributes.
> 
> So what's wrong with just using the hostX for this instead of inventing
> a new dummy level in the tree?
> 

Ok, I'm primarily concerned with userspace being able to map physical
connectors back to sas_phy objects.  I think an "isci_id" file at the
hostX level would be sufficient, and cleaner in the case of single
controller isci instances.  It does not address the dev_printk() nit,
but that is easy enough to workaround.  Is the following acceptable?

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 124f4c7..5f46124 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -237,12 +237,28 @@ static int isci_register_sas_ha(struct isci_host *isci_host)
 	return 0;
 }
 
-static void isci_unregister_sas_ha(struct isci_host *isci_host)
+static ssize_t isci_show_id(struct device *dev, struct device_attribute *attr, char *buf)
 {
+	struct Scsi_Host *shost = container_of(dev, typeof(*shost), shost_dev);
+	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
+	struct isci_host *ihost = container_of(sas_ha, typeof(*ihost), sas_ha);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", ihost->id);
+}
+
+static DEVICE_ATTR(isci_id, S_IRUGO, isci_show_id, NULL);
+
+static void isci_unregister(struct isci_host *isci_host)
+{
+	struct Scsi_Host *shost;
+
 	if (!isci_host)
 		return;
 
-	sas_unregister_ha(&(isci_host->sas_ha));
+	shost = isci_host->shost;
+	device_remove_file(&shost->shost_dev, &dev_attr_isci_id);
+
+	sas_unregister_ha(&isci_host->sas_ha);
 
 	sas_remove_host(isci_host->shost);
 	scsi_remove_host(isci_host->shost);
@@ -413,8 +429,14 @@ static struct isci_host *isci_host_alloc(struct pci_dev *pdev, int id)
 	if (err)
 		goto err_shost_remove;
 
+	err = device_create_file(&shost->shost_dev, &dev_attr_isci_id);
+	if (err)
+		goto err_unregister_ha;
+
 	return isci_host;
 
+ err_unregister_ha:
+	sas_unregister_ha(&(isci_host->sas_ha));
  err_shost_remove:
 	scsi_remove_host(shost);
  err_shost:
@@ -516,7 +538,7 @@ static int __devinit isci_pci_probe(struct pci_dev *pdev, const struct pci_devic
 
  err_host_alloc:
 	for_each_isci_host(isci_host, pdev)
-		isci_unregister_sas_ha(isci_host);
+		isci_unregister(isci_host);
 	return err;
 }
 
@@ -525,7 +547,7 @@ static void __devexit isci_pci_remove(struct pci_dev *pdev)
 	struct isci_host *isci_host;
 
 	for_each_isci_host(isci_host, pdev) {
-		isci_unregister_sas_ha(isci_host);
+		isci_unregister(isci_host);
 		isci_host_deinit(isci_host);
 		scic_controller_disable_interrupts(isci_host->core_controller);
 	}


