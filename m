From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] mptsas: support link error attributes
Date: Tue, 11 Oct 2005 20:35:36 +0200
Message-ID: <20051011183536.GA15805@lst.de>
References: <91888D455306F94EBD4D168954A9457C046A718D@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:36489 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932275AbVJKSf4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Oct 2005 14:35:56 -0400
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C046A718D@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Oct 11, 2005 at 11:00:00AM -0600, Moore, Eric Dean wrote:
> On Monday, September 19, 2005 2:01 PM, Christoph Hellwig wrote:
> 
> > +#endif
> > +
> > +
> >  /*
> >   * This is pretty ugly.  We will be able to seriously clean it up
> >   * once the DV code in mptscsih goes away and we can 
> > properly @@ -200,91 +295,76 @@
> >  	.use_clustering			= ENABLE_CLUSTERING,
> >  };
> >  
> 
> 
> Christoph:  I'm unable to apply this patch due to this
> section of the patch above.   Can you resend patch versus
> the 2.6.14-rc4 kernel stream.  That comment "this is pretty
> ugly" isn't there in kernel tree.

The patch I sent out (and attached again) applies perfect against
2.6.14-rc4.  The comment is there in 2.6.14-rc4 aswell.

Index: linux-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptsas.c	2005-09-19 17:05:55.000000000 +0200
+++ linux-2.6/drivers/message/fusion/mptsas.c	2005-09-19 21:51:45.000000000 +0200
@@ -123,6 +123,101 @@
 	struct mptsas_phyinfo *phy_info;
 };
 
+
+#ifdef SASDEBUG
+static void mptsas_print_phy_data(MPI_SAS_IO_UNIT0_PHY_DATA *phy_data)
+{
+	printk("---- IO UNIT PAGE 0 ------------\n");
+	printk("Handle=0x%X\n",
+		le16_to_cpu(phy_data->AttachedDeviceHandle));
+	printk("Controller Handle=0x%X\n",
+		le16_to_cpu(phy_data->ControllerDevHandle));
+	printk("Port=0x%X\n", phy_data->Port);
+	printk("Port Flags=0x%X\n", phy_data->PortFlags);
+	printk("PHY Flags=0x%X\n", phy_data->PhyFlags);
+	printk("Negotiated Link Rate=0x%X\n", phy_data->NegotiatedLinkRate);
+	printk("Controller PHY Device Info=0x%X\n",
+		le32_to_cpu(phy_data->ControllerPhyDeviceInfo));
+	printk("DiscoveryStatus=0x%X\n",
+		le32_to_cpu(phy_data->DiscoveryStatus));
+	printk("\n");
+}
+
+static void mptsas_print_phy_pg0(SasPhyPage0_t *pg0)
+{
+	__le64 sas_address;
+
+	memcpy(&sas_address, &pg0->SASAddress, sizeof(__le64));
+
+	printk("---- SAS PHY PAGE 0 ------------\n");
+	printk("Attached Device Handle=0x%X\n",
+			le16_to_cpu(pg0->AttachedDevHandle));
+	printk("SAS Address=0x%llX\n",
+			(unsigned long long)le64_to_cpu(sas_address));
+	printk("Attached PHY Identifier=0x%X\n", pg0->AttachedPhyIdentifier);
+	printk("Attached Device Info=0x%X\n",
+			le32_to_cpu(pg0->AttachedDeviceInfo));
+	printk("Programmed Link Rate=0x%X\n", pg0->ProgrammedLinkRate);
+	printk("Change Count=0x%X\n", pg0->ChangeCount);
+	printk("PHY Info=0x%X\n", le32_to_cpu(pg0->PhyInfo));
+	printk("\n");
+}
+
+static void mptsas_print_phy_pg1(SasPhyPage1_t *pg1)
+{
+	printk("---- SAS PHY PAGE 1 ------------\n");
+        printk("Invalid Dword Count=0x%x\n", pg1->InvalidDwordCount);
+        printk("Running Disparity Error Count=0x%x\n",
+			pg1->RunningDisparityErrorCount);
+        printk("Loss Dword Synch Count=0x%x\n", pg1->LossDwordSynchCount);
+        printk("PHY Reset Problem Count=0x%x\n", pg1->PhyResetProblemCount);
+        printk("\n");
+}
+
+static void mptsas_print_device_pg0(SasDevicePage0_t *pg0)
+{
+	__le64 sas_address;
+
+	memcpy(&sas_address, &pg0->SASAddress, sizeof(__le64));
+
+	printk("---- SAS DEVICE PAGE 0 ---------\n");
+	printk("Handle=0x%X\n" ,le16_to_cpu(pg0->DevHandle));
+	printk("Enclosure Handle=0x%X\n", le16_to_cpu(pg0->EnclosureHandle));
+	printk("Slot=0x%X\n", le16_to_cpu(pg0->Slot));
+	printk("SAS Address=0x%llX\n", le64_to_cpu(sas_address));
+	printk("Target ID=0x%X\n", pg0->TargetID);
+	printk("Bus=0x%X\n", pg0->Bus);
+	printk("PhyNum=0x%X\n", pg0->PhyNum);
+	printk("AccessStatus=0x%X\n", le16_to_cpu(pg0->AccessStatus));
+	printk("Device Info=0x%X\n", le32_to_cpu(pg0->DeviceInfo));
+	printk("Flags=0x%X\n", le16_to_cpu(pg0->Flags));
+	printk("Physical Port=0x%X\n", pg0->PhysicalPort);
+	printk("\n");
+}
+
+static void mptsas_print_expander_pg1(SasExpanderPage1_t *pg1)
+{
+	printk("---- SAS EXPANDER PAGE 1 ------------\n");
+
+	printk("Physical Port=0x%X\n", pg1->PhysicalPort);
+	printk("PHY Identifier=0x%X\n", pg1->Phy);
+	printk("Negotiated Link Rate=0x%X\n", pg1->NegotiatedLinkRate);
+	printk("Programmed Link Rate=0x%X\n", pg1->ProgrammedLinkRate);
+	printk("Hardware Link Rate=0x%X\n", pg1->HwLinkRate);
+	printk("Owner Device Handle=0x%X\n",
+			le16_to_cpu(pg1->OwnerDevHandle));
+	printk("Attached Device Handle=0x%X\n",
+			le16_to_cpu(pg1->AttachedDevHandle));
+}
+#else
+#define mptsas_print_phy_data(phy_data)		do { } while (0)
+#define mptsas_print_phy_pg0(pg0)		do { } while (0)
+#define mptsas_print_phy_pg1(pg1)		do { } while (0)
+#define mptsas_print_device_pg0(pg0)		do { } while (0)
+#define mptsas_print_expander_pg1(pg1)		do { } while (0)
+#endif
+
+
 /*
  * This is pretty ugly.  We will be able to seriously clean it up
  * once the DV code in mptscsih goes away and we can properly
@@ -200,91 +295,76 @@
 	.use_clustering			= ENABLE_CLUSTERING,
 };
 
-static struct sas_function_template mptsas_transport_functions = {
-};
-
-static struct scsi_transport_template *mptsas_transport_template;
-
-#ifdef SASDEBUG
-static void mptsas_print_phy_data(MPI_SAS_IO_UNIT0_PHY_DATA *phy_data)
+static inline MPT_ADAPTER *phy_to_ioc(struct sas_phy *phy)
 {
-	printk("---- IO UNIT PAGE 0 ------------\n");
-	printk("Handle=0x%X\n",
-		le16_to_cpu(phy_data->AttachedDeviceHandle));
-	printk("Controller Handle=0x%X\n",
-		le16_to_cpu(phy_data->ControllerDevHandle));
-	printk("Port=0x%X\n", phy_data->Port);
-	printk("Port Flags=0x%X\n", phy_data->PortFlags);
-	printk("PHY Flags=0x%X\n", phy_data->PhyFlags);
-	printk("Negotiated Link Rate=0x%X\n", phy_data->NegotiatedLinkRate);
-	printk("Controller PHY Device Info=0x%X\n",
-		le32_to_cpu(phy_data->ControllerPhyDeviceInfo));
-	printk("DiscoveryStatus=0x%X\n",
-		le32_to_cpu(phy_data->DiscoveryStatus));
-	printk("\n");
+	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+	return ((MPT_SCSI_HOST *)shost->hostdata)->ioc;
 }
 
-static void mptsas_print_phy_pg0(SasPhyPage0_t *pg0)
+static int mptsas_get_linkerrors(struct sas_phy *phy)
 {
-	__le64 sas_address;
+	MPT_ADAPTER *ioc = phy_to_ioc(phy);
+	ConfigExtendedPageHeader_t hdr;
+	CONFIGPARMS cfg;
+	SasPhyPage1_t *buffer;
+	dma_addr_t dma_handle;
+	int error;
 
-	memcpy(&sas_address, &pg0->SASAddress, sizeof(__le64));
+	hdr.PageVersion = MPI_SASPHY1_PAGEVERSION;
+	hdr.ExtPageLength = 0;
+	hdr.PageNumber = 1 /* page number 1*/;
+	hdr.Reserved1 = 0;
+	hdr.Reserved2 = 0;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
+	hdr.ExtPageType = MPI_CONFIG_EXTPAGETYPE_SAS_PHY;
 
-	printk("---- SAS PHY PAGE 0 ------------\n");
-	printk("Attached Device Handle=0x%X\n",
-			le16_to_cpu(pg0->AttachedDevHandle));
-	printk("SAS Address=0x%llX\n",
-			(unsigned long long)le64_to_cpu(sas_address));
-	printk("Attached PHY Identifier=0x%X\n", pg0->AttachedPhyIdentifier);
-	printk("Attached Device Info=0x%X\n",
-			le32_to_cpu(pg0->AttachedDeviceInfo));
-	printk("Programmed Link Rate=0x%X\n", pg0->ProgrammedLinkRate);
-	printk("Change Count=0x%X\n", pg0->ChangeCount);
-	printk("PHY Info=0x%X\n", le32_to_cpu(pg0->PhyInfo));
-	printk("\n");
-}
+	cfg.cfghdr.ehdr = &hdr;
+	cfg.physAddr = -1;
+	cfg.pageAddr = phy->identify.phy_identifier;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.dir = 0;    /* read */
+	cfg.timeout = 10;
 
-static void mptsas_print_device_pg0(SasDevicePage0_t *pg0)
-{
-	__le64 sas_address;
+	error = mpt_config(ioc, &cfg);
+	if (error)
+		return error;
+	if (!hdr.ExtPageLength)
+		return -ENXIO;
 
-	memcpy(&sas_address, &pg0->SASAddress, sizeof(__le64));
+	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
+				      &dma_handle);
+	if (!buffer)
+		return -ENOMEM;
 
-	printk("---- SAS DEVICE PAGE 0 ---------\n");
-	printk("Handle=0x%X\n" ,le16_to_cpu(pg0->DevHandle));
-	printk("Enclosure Handle=0x%X\n", le16_to_cpu(pg0->EnclosureHandle));
-	printk("Slot=0x%X\n", le16_to_cpu(pg0->Slot));
-	printk("SAS Address=0x%llX\n", le64_to_cpu(sas_address));
-	printk("Target ID=0x%X\n", pg0->TargetID);
-	printk("Bus=0x%X\n", pg0->Bus);
-	printk("PhyNum=0x%X\n", pg0->PhyNum);
-	printk("AccessStatus=0x%X\n", le16_to_cpu(pg0->AccessStatus));
-	printk("Device Info=0x%X\n", le32_to_cpu(pg0->DeviceInfo));
-	printk("Flags=0x%X\n", le16_to_cpu(pg0->Flags));
-	printk("Physical Port=0x%X\n", pg0->PhysicalPort);
-	printk("\n");
-}
+	cfg.physAddr = dma_handle;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 
-static void mptsas_print_expander_pg1(SasExpanderPage1_t *pg1)
-{
-	printk("---- SAS EXPANDER PAGE 1 ------------\n");
+	error = mpt_config(ioc, &cfg);
+	if (error)
+		goto out_free_consistent;
 
-	printk("Physical Port=0x%X\n", pg1->PhysicalPort);
-	printk("PHY Identifier=0x%X\n", pg1->Phy);
-	printk("Negotiated Link Rate=0x%X\n", pg1->NegotiatedLinkRate);
-	printk("Programmed Link Rate=0x%X\n", pg1->ProgrammedLinkRate);
-	printk("Hardware Link Rate=0x%X\n", pg1->HwLinkRate);
-	printk("Owner Device Handle=0x%X\n",
-			le16_to_cpu(pg1->OwnerDevHandle));
-	printk("Attached Device Handle=0x%X\n",
-			le16_to_cpu(pg1->AttachedDevHandle));
+	mptsas_print_phy_pg1(buffer);
+
+	phy->invalid_dword_count = le32_to_cpu(buffer->InvalidDwordCount);
+	phy->running_disparity_error_count =
+		le32_to_cpu(buffer->RunningDisparityErrorCount);
+	phy->loss_of_dword_sync_count =
+		le32_to_cpu(buffer->LossDwordSynchCount);
+	phy->phy_reset_problem_count =
+		le32_to_cpu(buffer->PhyResetProblemCount);
+
+ out_free_consistent:
+	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
+			    buffer, dma_handle);
+	return error;
 }
-#else
-#define mptsas_print_phy_data(phy_data)		do { } while (0)
-#define mptsas_print_phy_pg0(pg0)		do { } while (0)
-#define mptsas_print_device_pg0(pg0)		do { } while (0)
-#define mptsas_print_expander_pg1(pg1)		do { } while (0)
-#endif
+
+
+static struct sas_function_template mptsas_transport_functions = {
+	.get_linkerrors		= mptsas_get_linkerrors,
+};
+
+static struct scsi_transport_template *mptsas_transport_template;
 
 static int
 mptsas_sas_io_unit_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
