From: Brian King <brking@linux.vnet.ibm.com>
Subject: [RFC 2/3] [SCSI/libata] libata EH conversion for ipr SAS
Date: Mon, 29 Oct 2007 15:19:49 -0500
Message-ID: <47264065.3070602@linux.vnet.ibm.com>
References: <47263F85.70908@linux.vnet.ibm.com> <47264016.9060603@linux.vnet.ibm.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57607 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbXJ2UT6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 16:19:58 -0400
In-Reply-To: <47264016.9060603@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>


Currently, the SAS users of libata are using a mix of the
old and new error handling. This patch introduces a new
API which can be used by both ipr and libsas. It has several
advantages to the current implementation:

1. It uses the new libata EH
2. Device discovery is now driven by libata, which should hopefully
   make is easier to support PMP on SAS.
3. SATA rphy's have their own scsi_host, which makes SAS much more
   like all the other SATA drivers.
4. It eliminates tying scsi_target object lifetimes to ata_port lifetimes
   and introduces a cleaner API.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/ata/libata-scsi.c |  130 +++++++++++++++++++++++++++-
 linux-2.6-bjking1/include/linux/libata.h    |   18 +++
 2 files changed, 146 insertions(+), 2 deletions(-)

diff -puN drivers/ata/libata-scsi.c~libata_sas_rphy3 drivers/ata/libata-scsi.c
--- linux-2.6/drivers/ata/libata-scsi.c~libata_sas_rphy3	2007-10-29 11:46:23.000000000 -0500
+++ linux-2.6-bjking1/drivers/ata/libata-scsi.c	2007-10-29 11:53:14.000000000 -0500
@@ -3456,7 +3456,10 @@ EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
  */
 int ata_sas_port_start(struct ata_port *ap)
 {
-	return ata_pad_alloc(ap, ap->dev);
+	ap->pad_dma = 0;
+	ap->pad = dma_alloc_coherent(ap->dmadev, ATA_DMA_PAD_BUF_SZ,
+				     &ap->pad_dma, GFP_KERNEL);
+	return (ap->pad == NULL) ? -ENOMEM : 0;
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_start);
 
@@ -3474,7 +3477,11 @@ EXPORT_SYMBOL_GPL(ata_sas_port_start);
 
 void ata_sas_port_stop(struct ata_port *ap)
 {
-	ata_pad_free(ap, ap->dev);
+	if (ap->pad) {
+		dma_free_coherent(ap->dmadev, ATA_DMA_PAD_BUF_SZ, ap->pad, ap->pad_dma);
+		ap->pad = NULL;
+		ap->pad_dma = 0;
+	}
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_stop);
 
@@ -3560,3 +3567,122 @@ int ata_sas_queuecmd(struct scsi_cmnd *c
 	return rc;
 }
 EXPORT_SYMBOL_GPL(ata_sas_queuecmd);
+
+static unsigned int ata_rphy_id;
+
+static void ata_sas_rphy_release(struct device *dev)
+{
+	put_device(dev->parent);
+	kfree(dev_to_sata_rphy(dev));
+}
+
+/**
+ *	ata_sas_rphy_alloc - Allocate a SATA rphy in a SAS topology
+ *	@parent: parent device
+ *	@dmadev: device to use when mapping DMA buffers
+ *	@pinfo: ATA port info
+ *	@privsize: size of additional memory to allocate with ata_sas_rphy
+ *
+ *	RETURNS:
+ *	Pointer to ata_sas_rphy, NULL if a failure occurs.
+ */
+struct ata_sas_rphy *ata_sas_rphy_alloc(struct device *parent,
+					struct device *dmadev,
+					const struct ata_port_info *pinfo,
+					unsigned int privsize)
+{
+	const struct ata_port_info *apinfo[] = { pinfo, NULL };
+	struct ata_sas_rphy *rphy;
+
+	rphy = kzalloc(sizeof(*rphy) + privsize, GFP_KERNEL);
+	if (!rphy)
+		return NULL;
+
+	rphy->id = ata_rphy_id++;
+	device_initialize(&rphy->dev);
+	rphy->dev.parent = get_device(parent);
+	rphy->dev.release = ata_sas_rphy_release;
+	sprintf(rphy->dev.bus_id, "ata%u", rphy->id);
+
+	rphy->host = ata_host_alloc_pinfo(&rphy->dev, apinfo, 1);
+
+	if (!rphy->host) {
+		kfree(rphy);
+		return NULL;
+	}
+
+	rphy->host->dmadev = dmadev;
+	rphy->host->ports[0]->dmadev = dmadev;
+	transport_setup_device(&rphy->dev);
+	return rphy;
+}
+EXPORT_SYMBOL_GPL(ata_sas_rphy_alloc);
+
+/**
+ *	ata_sas_rphy_add - Add a SATA rphy to the device hierarchy
+ *	@rphy: SATA rphy to add
+ *	@sht: SCSI host template
+ *
+ *	Adds a SATA rphy to sysfs, allocates scsi hosts, and
+ *	scans for devices.
+ *
+ *	RETURNS:
+ *	0 on success, non-zero on error
+ */
+int ata_sas_rphy_add(struct ata_sas_rphy *rphy, struct scsi_host_template *sht)
+{
+	int rc = ata_host_start(rphy->host);
+
+	if (rc)
+		return rc;
+
+	rc = device_add(&rphy->dev);
+
+	if (rc)
+		return rc;
+
+	rc = ata_host_register(rphy->host, sht);
+
+	if (rc) {
+		device_del(&rphy->dev);
+		put_device(&rphy->dev);
+		return rc;
+	}
+
+	transport_add_device(&rphy->dev);
+	transport_configure_device(&rphy->dev);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ata_sas_rphy_add);
+
+/**
+ *	ata_sas_rphy_free - Free a SATA rphy
+ *	@rphy: SATA rphy to free
+ *
+ * Note:
+ *   This function must only be called on an rphy that has not
+ *   sucessfully been added using ata_sas_rphy_add().
+ */
+void ata_sas_rphy_free(struct ata_sas_rphy *rphy)
+{
+	transport_destroy_device(&rphy->dev);
+	put_device(&rphy->dev);
+}
+EXPORT_SYMBOL_GPL(ata_sas_rphy_free);
+
+/**
+ *	ata_sas_rphy_delete - Delete a SATA rphy
+ *	@rphy: SATA rphy to delete
+ *
+ */
+void ata_sas_rphy_delete(struct ata_sas_rphy *rphy)
+{
+	struct device *dev = &rphy->dev;
+
+	ata_host_detach(rphy->host);
+	transport_remove_device(dev);
+	device_del(dev);
+	transport_destroy_device(dev);
+	put_device(dev);
+}
+EXPORT_SYMBOL_GPL(ata_sas_rphy_delete);
diff -puN include/linux/libata.h~libata_sas_rphy3 include/linux/libata.h
--- linux-2.6/include/linux/libata.h~libata_sas_rphy3	2007-10-29 11:46:23.000000000 -0500
+++ linux-2.6-bjking1/include/linux/libata.h	2007-10-29 11:46:23.000000000 -0500
@@ -388,6 +388,15 @@ struct ata_ioports {
 	void __iomem		*scr_addr;
 };
 
+struct ata_sas_rphy {
+	struct ata_host *host;
+	struct device dev;
+	unsigned int id;
+};
+
+#define dev_to_sata_rphy(d) \
+	container_of((d), struct ata_sas_rphy, dev)
+
 struct ata_host {
 	spinlock_t		lock;
 	struct device 		*dev;
@@ -882,6 +891,15 @@ extern int ata_cable_80wire(struct ata_p
 extern int ata_cable_sata(struct ata_port *ap);
 extern int ata_cable_unknown(struct ata_port *ap);
 
+extern struct ata_sas_rphy *ata_sas_rphy_alloc(struct device *parent,
+					       struct device *dmadev,
+					       const struct ata_port_info *pinfo,
+					       unsigned int privsize);
+extern int ata_sas_rphy_add(struct ata_sas_rphy *rphy,
+			    struct scsi_host_template *sht);
+extern void ata_sas_rphy_free(struct ata_sas_rphy *rphy);
+extern void ata_sas_rphy_delete(struct ata_sas_rphy *rphy);
+
 /*
  * Timing helpers
  */
_

