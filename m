From: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Subject: [PATCH] aacraid driver update
Date: Wed, 1 Apr 2009 07:16:08 -0700
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F40204F4B736@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:45145 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbZDAO3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2009 10:29:52 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>

I want to send out a required aacraid driver update from version 1.1.5-2456 to 1.1.5-2461 as a patch against the latest scsi-misc-2.6 kernel (2.6.29-rc7). It includes the following changes:
- set aac_cache=2 as default value to avoid performance problem (Novell bugzilla #469922)
- Dell/PERC controller boot problem fixed (RedHat bugzilla #457552)
- WWN flag added to fix SLES10 SP1/SP2 drive detection problems
- 64-bit support changes
- DECLARE_PCI_DEVICE_TABLE macro added
- controller type changes
Please see patch below.

===========================
Achim Leubner
Software Engineer / RAID drivers
ICP vortex GmbH / Adaptec Inc.
Phone: +49-351-8718291


This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's handling of patch attachments.

Signed-off-by: Achim Leubner <aacraid@adaptec.com>

 Documentation/scsi/aacraid.txt  |   15 ++++-----------
 drivers/scsi/aacraid/aachba.c   |   40 ++++++++++++++++++++++++++++++++--------
 drivers/scsi/aacraid/aacraid.h  |    9 +++++++--
 drivers/scsi/aacraid/comminit.c |   14 +++++++++++++-
 drivers/scsi/aacraid/linit.c    |    8 +++++++-
 5 files changed, 63 insertions(+), 23 deletions(-)

diff -ru a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c	2009-03-31 03:20:16.258111585 -0700
+++ b/drivers/scsi/aacraid/aachba.c	2009-03-31 03:25:47.038274824 -0700
@@ -143,7 +143,7 @@
  */
 
 static int nondasd = -1;
-static int aac_cache;
+static int aac_cache = 2;	/* WCE=0 to avoid performance problems */
 static int dacmode = -1;
 int aac_msi;
 int aac_commit = -1;
@@ -157,7 +157,7 @@
 MODULE_PARM_DESC(cache, "Disable Queue Flush commands:\n"
 	"\tbit 0 - Disable FUA in WRITE SCSI commands\n"
 	"\tbit 1 - Disable SYNCHRONIZE_CACHE SCSI command\n"
-	"\tbit 2 - Disable only if Battery not protecting Cache");
+	"\tbit 2 - Disable only if Battery is protecting Cache");
 module_param(dacmode, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(dacmode, "Control whether dma addressing is using 64 bit DAC."
 	" 0=off, 1=on");
@@ -217,6 +217,14 @@
 module_param_named(reset_devices, aac_reset_devices, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(reset_devices, "Force an adapter reset at initialization.");
 
+int aac_wwn = 1;
+module_param_named(wwn, aac_wwn, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(wwn, "Select a WWN type for the arrays:\n"
+	"\t0 - Disable\n"
+	"\t1 - Array Meta Data Signature (default)\n"
+	"\t2 - Adapter Serial Number");
+
+
 static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
 		struct fib *fibptr) {
 	struct scsi_device *device;
@@ -1206,9 +1214,8 @@
 
 static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
 {
-	if ((sizeof(dma_addr_t) > 4) &&
-	 (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT)) &&
-	 (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
+	if ((sizeof(dma_addr_t) > 4) && fib->dev->needs_dac &&
+	    (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
 		return FAILED;
 	return aac_scsi_32(fib, cmd);
 }
@@ -1371,8 +1378,11 @@
 	if (dev->nondasd_support && !dev->in_reset)
 		printk(KERN_INFO "%s%d: Non-DASD support enabled.\n",dev->name, dev->id);
 
+	if (dma_get_required_mask(&dev->pdev->dev) > DMA_32BIT_MASK)
+		dev->needs_dac = 1;
 	dev->dac_support = 0;
-	if( (sizeof(dma_addr_t) > 4) && (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)){
+	if ((sizeof(dma_addr_t) > 4) && dev->needs_dac &&
+	    (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)) {
 		if (!dev->in_reset)
 			printk(KERN_INFO "%s%d: 64bit support enabled.\n",
 				dev->name, dev->id);
@@ -1382,6 +1392,15 @@
 	if(dacmode != -1) {
 		dev->dac_support = (dacmode!=0);
 	}
+
+	/* avoid problems with AAC_QUIRK_SCSI_32 controllers */
+	if (dev->dac_support &&	(aac_get_driver_ident(dev->cardtype)->quirks
+		& AAC_QUIRK_SCSI_32)) {
+		dev->nondasd_support = 0;
+		dev->jbod = 0;
+		expose_physicals = 0;
+	}
+
 	if(dev->dac_support != 0) {
 		if (!pci_set_dma_mask(dev->pdev, DMA_64BIT_MASK) &&
 			!pci_set_consistent_dma_mask(dev->pdev, DMA_64BIT_MASK)) {
@@ -2058,7 +2077,7 @@
 		dprintk((KERN_DEBUG "INQUIRY command, ID: %d.\n", cid));
 		memset(&inq_data, 0, sizeof (struct inquiry_data));
 
-		if (scsicmd->cmnd[1] & 0x1) {
+		if ((scsicmd->cmnd[1] & 0x1) && aac_wwn) {
 			char *arr = (char *)&inq_data;
 
 			/* EVPD bit set */
@@ -2081,7 +2100,12 @@
 				arr[1] = scsicmd->cmnd[2];
 				scsi_sg_copy_from_buffer(scsicmd, &inq_data,
 							 sizeof(inq_data));
-				return aac_get_container_serial(scsicmd);
+				if (aac_wwn != 2)
+					return aac_get_container_serial(
+						scsicmd);
+				/* SLES 10 SP1 special */
+				scsicmd->result = DID_OK << 16 |
+				  COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 			} else {
 				/* vpd page not implemented */
 				scsicmd->result = DID_OK << 16 |
diff -ru a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h	2009-03-31 03:20:16.258111585 -0700
+++ b/drivers/scsi/aacraid/aacraid.h	2009-03-31 03:25:47.039274638 -0700
@@ -12,7 +12,7 @@
  *----------------------------------------------------------------------------*/
 
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 2456
+# define AAC_DRIVER_BUILD 2461
 # define AAC_DRIVER_BRANCH "-ms"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
@@ -865,7 +865,11 @@
 	u8	MfgPcbaSerialNo[12];
 	u8	MfgWWNName[8];
 	__le32	SupportedOptions2;
-	__le32	ReservedGrowth[1];
+	__le32	StructExpansion;
+	/* StructExpansion == 1 */
+	__le32	FeatureBits3;
+	__le32	SupportedPerformanceModes;
+	__le32	ReservedForFutureGrowth[80];
 };
 #define AAC_FEATURE_FALCON	cpu_to_le32(0x00000010)
 #define AAC_FEATURE_JBOD	cpu_to_le32(0x08000000)
@@ -1020,6 +1024,7 @@
 	u8			jbod;
 	u8			cache_protected;
 	u8			dac_support;
+	u8			needs_dac;
 	u8			raid_scsi_mode;
 	u8			comm_interface;
 #	define AAC_COMM_PRODUCER 0
diff -ru a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
--- a/drivers/scsi/aacraid/comminit.c	2009-03-31 03:20:16.259111398 -0700
+++ b/drivers/scsi/aacraid/comminit.c	2009-03-31 03:25:47.039274638 -0700
@@ -54,6 +54,7 @@
 	const unsigned long printfbufsiz = 256;
 	struct aac_init *init;
 	dma_addr_t phys;
+	unsigned long aac_max_hostphysmempages;
 
 	size = fibsize + sizeof(struct aac_init) + commsize + commalign + printfbufsiz;
 
@@ -90,7 +91,18 @@
 	init->AdapterFibsPhysicalAddress = cpu_to_le32((u32)phys);
 	init->AdapterFibsSize = cpu_to_le32(fibsize);
 	init->AdapterFibAlign = cpu_to_le32(sizeof(struct hw_fib));
-	init->HostPhysMemPages = cpu_to_le32(AAC_MAX_HOSTPHYSMEMPAGES);
+	/*
+	 * number of 4k pages of host physical memory. The aacraid fw needs
+	 * this number to be less than 4gb worth of pages. New firmware doesn't
+	 * have any issues with the mapping system, but older Firmware did, and
+	 * had *troubles* dealing with the math overloading past 32 bits, thus
+	 * we must limit this field.
+	 */
+	aac_max_hostphysmempages = dma_get_required_mask(&dev->pdev->dev) >> 12;
+	if (aac_max_hostphysmempages < AAC_MAX_HOSTPHYSMEMPAGES)
+		init->HostPhysMemPages = cpu_to_le32(aac_max_hostphysmempages);
+	else
+		init->HostPhysMemPages = cpu_to_le32(AAC_MAX_HOSTPHYSMEMPAGES);
 
 	init->InitFlags = 0;
 	if (dev->comm_interface == AAC_COMM_MESSAGE) {
diff -ru a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c	2009-03-31 03:20:16.259111398 -0700
+++ b/drivers/scsi/aacraid/linit.c	2009-03-31 03:25:47.040274451 -0700
@@ -86,7 +86,13 @@
  *
  * Note: The last field is used to index into aac_drivers below.
  */
-static struct pci_device_id aac_pci_tbl[] = {
+#ifdef DECLARE_PCI_DEVICE_TABLE
+static DECLARE_PCI_DEVICE_TABLE(aac_pci_tbl) = {
+#elif defined(__devinitconst)
+static const struct pci_device_id aac_pci_tbl[] __devinitconst = {
+#else
+static const struct pci_device_id aac_pci_tbl[] __devinitdata = {
+#endif
 	{ 0x1028, 0x0001, 0x1028, 0x0001, 0, 0, 0 }, /* PERC 2/Si (Iguana/PERC2Si) */
 	{ 0x1028, 0x0002, 0x1028, 0x0002, 0, 0, 1 }, /* PERC 3/Di (Opal/PERC3Di) */
 	{ 0x1028, 0x0003, 0x1028, 0x0003, 0, 0, 2 }, /* PERC 3/Si (SlimFast/PERC3Si */
diff -ru a/Documentation/scsi/aacraid.txt b/Documentation/scsi/aacraid.txt
--- a/Documentation/scsi/aacraid.txt	2009-03-31 03:20:16.264110464 -0700
+++ b/Documentation/scsi/aacraid.txt	2009-03-31 03:25:47.040274451 -0700
@@ -60,17 +60,9 @@
 	9005:0285:9005:02d5	Adaptec	ASR-2405 (Voodoo40 Lite)
 	9005:0285:9005:02d6	Adaptec	ASR-2445 (Voodoo44 Lite)
 	9005:0285:9005:02d7	Adaptec	ASR-2805 (Voodoo80 Lite)
-	9005:0285:9005:02d8	Adaptec	5405G (Voodoo40 PM)
-	9005:0285:9005:02d9	Adaptec	5445G (Voodoo44 PM)
-	9005:0285:9005:02da	Adaptec	5805G (Voodoo80 PM)
-	9005:0285:9005:02db	Adaptec	5085G (Voodoo08 PM)
-	9005:0285:9005:02dc	Adaptec	51245G (Voodoo124 PM)
-	9005:0285:9005:02dd	Adaptec	51645G (Voodoo164 PM)
-	9005:0285:9005:02de	Adaptec	52445G (Voodoo244 PM)
-	9005:0285:9005:02df	Adaptec	ASR-2045G (Voodoo04 Lite PM)
-	9005:0285:9005:02e0	Adaptec	ASR-2405G (Voodoo40 Lite PM)
-	9005:0285:9005:02e1	Adaptec	ASR-2445G (Voodoo44 Lite PM)
-	9005:0285:9005:02e2	Adaptec	ASR-2805G (Voodoo80 Lite PM)
+	9005:0285:9005:02d8	Adaptec	5405Z (Voodoo40 BLBU)
+	9005:0285:9005:02d9	Adaptec	5445Z (Voodoo44 BLBU)
+	9005:0285:9005:02da	Adaptec	5805Z (Voodoo80 BLBU)
 	1011:0046:9005:0364	Adaptec	5400S (Mustang)
 	1011:0046:9005:0365	Adaptec	5400S (Mustang)
 	9005:0287:9005:0800	Adaptec	Themisto (Jupiter)
@@ -140,6 +132,7 @@
 					 where fibs that go to the hardware are consistently called hw_fibs and
 					 not just fibs like the name of the driver tracking structure)
 Mark Salyzyn <Mark_Salyzyn@adaptec.com> Fixed panic issues and added some new product ids for upcoming hbas. Performance tuning, card failover and bug mitigations.
+Achim Leubner <Achim_Leubner@adaptec.com>
 
 Original Driver
 -------------------------


Regards - Achim Leubner

