From: akpm@linux-foundation.org
Subject: [patch 20/23] aacraid driver fails with Dell PowerEdge Expandable RAID Controller 3/Di
Date: Wed, 21 Nov 2007 15:12:31 -0800
Message-ID: <200711212312.lALNCVWt014163@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56975 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754991AbXKUXR4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 18:17:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, mark_salyzyn@adaptec.com, Matt_Domsch@dell.com, aacraid@adaptec.com, hawk@pld-linux.org

From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>

As reported in http://bugzilla.kernel.org/show_bug.cgi?id=3D9133 it was
discovered that the PERC line of controllers lacked a key 64 bit
ScatterGather capable SCSI pass-through function. The adapters are still
capable of 64 bit ScatterGather I/O commands, but these two can not be
mixed. This problem was exacerbated by the introduction of the SCSI
Generic access to the DASD physical devices.

The fix for users before this patch is applied is aacraid.dacmode=3D0 on
the kernel command line to disable 64 bit I/O.

The enclosed patch introduces a new adapter quirk and tries to limp
along by enabling pass-through in situations where memory is 32 bit
addressable on 64 bit machines, or disable the pass-through functions
altogether. I expect that the check for 32 bit addressable memory to be
controversial in that it can be incorrect in non-Dell non-Intel systems
that PERC would never be installed under, the alternative is to disable
pass-through in all cases which could be reported as another regression.

Pass-through is used for SCSI Generic access to the physical devices, or
for the management applications to properly function.

In systems where this patch has disabled pass-through because it is
unsupportable in combination with I/O performance, the user can choose
to enable pass-through by turning off dacmode (aacraid.dacmode=3D0) or
limiting the discovered kernel memory (mem=3D4G) with an associated loss
in runtime performance. If we chose instead to turn off 64 bit dacmode
for the adapters with this quirk, then this would be reported as another
regression.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
Cc: Marcin Krol <hawk@pld-linux.org>
Cc: "Matt Domsch" <Matt_Domsch@dell.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/aachba.c  |   15 ++++++++++-
 drivers/scsi/aacraid/aacraid.h |    6 ++++
 drivers/scsi/aacraid/commsup.c |    6 ++--
 drivers/scsi/aacraid/linit.c   |   42 +++++++++++++++++--------------
 4 files changed, 47 insertions(+), 22 deletions(-)

diff -puN drivers/scsi/aacraid/aachba.c~aacraid-driver-fails-with-dell-poweredge-expandable-raid-controller-3-di drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c~aacraid-driver-fails-with-dell-poweredge-expandable-raid-controller-3-di
+++ a/drivers/scsi/aacraid/aachba.c
@@ -1190,6 +1190,15 @@ static int aac_scsi_32(struct fib * fib,
 				  (fib_callback) aac_srb_callback, (void *) cmd);
 }
 
+static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
+{
+	if ((sizeof(dma_addr_t) > 4) &&
+	 (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT)) &&
+	 (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
+		return FAILED;
+	return aac_scsi_32(fib, cmd);
+}
+
 int aac_get_adapter_info(struct aac_dev* dev)
 {
 	struct fib* fibptr;
@@ -1267,6 +1276,8 @@ int aac_get_adapter_info(struct aac_dev*
 			 1, 1,
 			 NULL, NULL);
 
+	/* reasoned default */
+	dev->maximum_num_physicals = 16;
 	if (rcode >= 0 && le32_to_cpu(bus_info->Status) == ST_OK) {
 		dev->maximum_num_physicals = le32_to_cpu(bus_info->TargetsPerBus);
 		dev->maximum_num_channels = le32_to_cpu(bus_info->BusCount);
@@ -1376,7 +1387,9 @@ int aac_get_adapter_info(struct aac_dev*
 	 * interface.
 	 */
 	dev->a_ops.adapter_scsi = (dev->dac_support)
-				? aac_scsi_64
+	  ? ((aac_get_driver_ident(dev->cardtype)->quirks & AAC_QUIRK_SCSI_32)
+				? aac_scsi_32_64
+				: aac_scsi_64)
 				: aac_scsi_32;
 	if (dev->raw_io_interface) {
 		dev->a_ops.adapter_bounds = (dev->raw_io_64)
diff -puN drivers/scsi/aacraid/aacraid.h~aacraid-driver-fails-with-dell-poweredge-expandable-raid-controller-3-di drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h~aacraid-driver-fails-with-dell-poweredge-expandable-raid-controller-3-di
+++ a/drivers/scsi/aacraid/aacraid.h
@@ -521,6 +521,12 @@ struct aac_driver_ident
 #define AAC_QUIRK_17SG	0x0010
 
 /*
+ *	Some adapter firmware does not support 64 bit scsi passthrough
+ * commands.
+ */
+#define AAC_QUIRK_SCSI_32	0x0020
+
+/*
  *	The adapter interface specs all queues to be located in the same
  *	physically contigous block. The host structure that defines the
  *	commuication queues will assume they are each a separate physically
diff -puN drivers/scsi/aacraid/commsup.c~aacraid-driver-fails-with-dell-poweredge-expandable-raid-controller-3-di drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c~aacraid-driver-fails-with-dell-poweredge-expandable-raid-controller-3-di
+++ a/drivers/scsi/aacraid/commsup.c
@@ -1099,7 +1099,8 @@ static int _aac_reset_adapter(struct aac
 	free_irq(aac->pdev->irq, aac);
 	kfree(aac->fsa_dev);
 	aac->fsa_dev = NULL;
-	if (aac_get_driver_ident(index)->quirks & AAC_QUIRK_31BIT) {
+	quirks = aac_get_driver_ident(index)->quirks;
+	if (quirks & AAC_QUIRK_31BIT) {
 		if (((retval = pci_set_dma_mask(aac->pdev, DMA_31BIT_MASK))) ||
 		  ((retval = pci_set_consistent_dma_mask(aac->pdev, DMA_31BIT_MASK))))
 			goto out;
@@ -1110,7 +1111,7 @@ static int _aac_reset_adapter(struct aac
 	}
 	if ((retval = (*(aac_get_driver_ident(index)->init))(aac)))
 		goto out;
-	if (aac_get_driver_ident(index)->quirks & AAC_QUIRK_31BIT)
+	if (quirks & AAC_QUIRK_31BIT)
 		if ((retval = pci_set_dma_mask(aac->pdev, DMA_32BIT_MASK)))
 			goto out;
 	if (jafo) {
@@ -1121,7 +1122,6 @@ static int _aac_reset_adapter(struct aac
 		}
 	}
 	(void)aac_get_adapter_info(aac);
-	quirks = aac_get_driver_ident(index)->quirks;
 	if ((quirks & AAC_QUIRK_34SG) && (host->sg_tablesize > 34)) {
  		host->sg_tablesize = 34;
  		host->max_sectors = (host->sg_tablesize * 8) + 112;
diff -puN drivers/scsi/aacraid/linit.c~aacraid-driver-fails-with-dell-poweredge-expandable-raid-controller-3-di drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~aacraid-driver-fails-with-dell-poweredge-expandable-raid-controller-3-di
+++ a/drivers/scsi/aacraid/linit.c
@@ -164,22 +164,22 @@ MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
  * for the card.  At that time we can remove the channels from here
  */
 static struct aac_driver_ident aac_drivers[] = {
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 2/Si (Iguana/PERC2Si) */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Di (Opal/PERC3Di) */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Si (SlimFast/PERC3Si */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Di (Iguana FlipChip/PERC3DiF */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Di (Viper/PERC3DiV) */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Di (Lexus/PERC3DiL) */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Di (Jaguar/PERC3DiJ) */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Di (Dagger/PERC3DiD) */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Di (Boxster/PERC3DiB) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* catapult */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* tomcat */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Adaptec 2120S (Crusader) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Adaptec 2200S (Vulcan) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Adaptec 2200S (Vulcan-2m) */
-	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Legend S220 (Legend Crusader) */
-	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Legend S230 (Legend Vulcan) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 2/Si (Iguana/PERC2Si) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 3/Di (Opal/PERC3Di) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 3/Si (SlimFast/PERC3Si */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 3/Di (Iguana FlipChip/PERC3DiF */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 3/Di (Viper/PERC3DiV) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 3/Di (Lexus/PERC3DiL) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 3/Di (Jaguar/PERC3DiJ) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 3/Di (Dagger/PERC3DiD) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 3/Di (Boxster/PERC3DiB) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* catapult */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* tomcat */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2120S (Crusader) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan-2m) */
+	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S220 (Legend Crusader) */
+	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S230 (Legend Vulcan) */
 
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3230S   ", 2 }, /* Adaptec 3230S (Harrier) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3240S   ", 2 }, /* Adaptec 3240S (Tornado) */
@@ -224,8 +224,8 @@ static struct aac_driver_ident aac_drive
 	{ aac_sa_init, "percraid", "DELL    ", "PERCRAID        ", 4, AAC_QUIRK_34SG }, /* Dell PERC2/QC */
 	{ aac_sa_init, "hpnraid",  "HP      ", "NetRAID         ", 4, AAC_QUIRK_34SG }, /* HP NetRAID-4M */
 
-	{ aac_rx_init, "aacraid",  "DELL    ", "RAID            ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Dell Catchall */
-	{ aac_rx_init, "aacraid",  "Legend  ", "RAID            ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Legend Catchall */
+	{ aac_rx_init, "aacraid",  "DELL    ", "RAID            ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Dell Catchall */
+	{ aac_rx_init, "aacraid",  "Legend  ", "RAID            ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend Catchall */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "RAID            ", 2 }, /* Adaptec Catch All */
 	{ aac_rkt_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }, /* Adaptec Rocket Catch All */
 	{ aac_nark_init, "aacraid", "ADAPTEC ", "RAID            ", 2 } /* Adaptec NEMER/ARK Catch All */
@@ -420,6 +420,12 @@ static int aac_slave_configure(struct sc
 		unsigned num_one = 0;
 		unsigned depth;
 
+		/*
+		 * Firmware has an individual device recovery time typically
+		 * of 35 seconds, give us a margin.
+		 */
+		if (sdev->timeout < (45 * HZ))
+			sdev->timeout = 45 * HZ;
 		__shost_for_each_device(dev, host) {
 			if (dev->tagged_supported && (dev->type == TYPE_DISK) &&
 				(sdev_channel(dev) == CONTAINER_CHANNEL))
_
