From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] mptsas driver
Date: Mon, 5 Sep 2005 01:52:07 +0200
Message-ID: <20050904235207.GB28799@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:38851 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932133AbVIDXwK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Sep 2005 19:52:10 -0400
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id j84Nq86t028839
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 5 Sep 2005 01:52:08 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id j84Nq8r0028837
	for linux-scsi@vger.kernel.org; Mon, 5 Sep 2005 01:52:08 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

New version of the mptsas driver that works with the new transport class
code and supports extenders.  Thanks a lot to Eric Moore for supply me
with code to support reading extender information from the Fusion
firmware.

This needs all the fusion changes I sent out earlier applied, aswell as
the SAS transport class patch I just posted.


Index: scsi-misc-2.6/drivers/message/fusion/Kconfig
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/Kconfig	2005-09-05 01:52:46.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/Kconfig	2005-09-05 01:55:20.000000000 +0200
@@ -35,6 +35,23 @@
 	  LSIFC929X
 	  LSIFC929XL
 
+config FUSION_SAS
+	tristate "Fusion MPT ScsiHost drivers for SAS"
+	depends on PCI && SCSI
+ 	select FUSION
+	select SCSI_SAS_ATTRS
+	---help---
+	  SCSI HOST support for a SAS host adapters.
+
+	  List of supported controllers:
+
+	  LSISAS1064
+	  LSISAS1066
+	  LSISAS1068
+	  LSISAS1064E
+	  LSISAS1066E
+	  LSISAS1068E
+
 config FUSION_MAX_SGE
 	int "Maximum number of scatter gather entries (16 - 128)"
 	depends on FUSION
Index: scsi-misc-2.6/drivers/message/fusion/Makefile
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/Makefile	2005-09-05 01:52:46.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/Makefile	2005-09-05 01:55:20.000000000 +0200
@@ -34,5 +34,6 @@
 
 obj-$(CONFIG_FUSION_SPI)	+= mptbase.o mptscsih.o mptspi.o
 obj-$(CONFIG_FUSION_FC)		+= mptbase.o mptscsih.o mptfc.o
+obj-$(CONFIG_FUSION_SAS)	+= mptbase.o mptscsih.o mptsas.o
 obj-$(CONFIG_FUSION_CTL)	+= mptctl.o
 obj-$(CONFIG_FUSION_LAN)	+= mptlan.o
Index: scsi-misc-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ scsi-misc-2.6/drivers/message/fusion/mptsas.c	2005-09-05 01:58:31.000000000 +0200
@@ -0,0 +1,1191 @@
+/*
+ *  linux/drivers/message/fusion/mptsas.c
+ *      For use with LSI Logic PCI chip/adapter(s)
+ *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
+ *
+ *  Copyright (c) 1999-2005 LSI Logic Corporation
+ *  (mailto:mpt_linux_developer@lsil.com)
+ *  Copyright (c) 2005 Dell
+ */
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; version 2 of the License.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    NO WARRANTY
+    THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
+    CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
+    LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
+    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
+    solely responsible for determining the appropriateness of using and
+    distributing the Program and assumes all risks associated with its
+    exercise of rights under this Agreement, including but not limited to
+    the risks and costs of program errors, damage to or loss of data,
+    programs or equipment, and unavailability or interruption of operations.
+
+    DISCLAIMER OF LIABILITY
+    NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
+    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+    DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
+    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+    TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+    USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
+    HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/workqueue.h>
+
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_sas.h>
+
+#include "mptbase.h"
+#include "mptscsih.h"
+
+
+#define my_NAME		"Fusion MPT SAS Host driver"
+#define my_VERSION	MPT_LINUX_VERSION_COMMON
+#define MYNAM		"mptsas"
+
+MODULE_AUTHOR(MODULEAUTHOR);
+MODULE_DESCRIPTION(my_NAME);
+MODULE_LICENSE("GPL");
+
+static int mpt_pq_filter;
+module_param(mpt_pq_filter, int, 0);
+MODULE_PARM_DESC(mpt_pq_filter,
+		"Enable peripheral qualifier filter: enable=1  "
+		"(default=0)");
+
+static int mpt_pt_clear;
+module_param(mpt_pt_clear, int, 0);
+MODULE_PARM_DESC(mpt_pt_clear,
+		"Clear persistency table: enable=1  "
+		"(default=MPTSCSIH_PT_CLEAR=0)");
+
+static int	mptsasDoneCtx = -1;
+static int	mptsasTaskCtx = -1;
+static int	mptsasInternalCtx = -1; /* Used only for internal commands */
+
+
+/*
+ * SAS topology structures
+ *
+ * The MPT Fusion firmware interface spreads information about the
+ * SAS topology over many manufacture pages, thus we need some data
+ * structure to collect it and process it for the SAS transport class.
+ */
+
+struct mptsas_devinfo {
+	u16	handle;		/* unique id to address this device */
+	u8	phy_id;		/* phy number of parent device */
+	u8	port_id;	/* sas physical port this device
+				   is assoc'd with */
+	u8	target;		/* logical target id of this device */
+	u8	bus;		/* logical bus number of this device */
+	u64	sas_address;    /* WWN of this device,
+				   SATA is assigned by HBA,expander */
+	u32	device_info;	/* bitfield detailed info about this device */
+};
+
+struct mptsas_phyinfo {
+	u8	phy_id; 		/* phy index */
+	u8	port_id; 		/* port number this phy is part of */
+	u8	negotiated_link_rate;	/* nego'd link rate for this phy */
+	u8	hw_link_rate; 		/* hardware max/min phys link rate */
+	u8	programmed_link_rate;	/* programmed max/min phy link rate */
+	struct mptsas_devinfo identify;	/* point to phy device info */
+	struct mptsas_devinfo attached;	/* point to attached device info */
+};
+
+struct mptsas_portinfo {
+	u16		handle;		/* unique id to address this */
+	u8		num_phys;	/* number of phys */
+	struct mptsas_phyinfo *phy_info;
+};
+
+
+//#define SASDEBUG	1
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
+	printk("Attached Device Handle=0x%X\n", le16_to_cpu(pg0->AttachedDevHandle));
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
+	printk("Owner Device Handle=0x%X\n", le16_to_cpu(pg1->OwnerDevHandle));
+	printk("Attached Device Handle=0x%X\n", le16_to_cpu(pg1->AttachedDevHandle));
+}
+
+#else
+#define mptsas_print_phy_data(phy_data)		do { } while (0)
+#define mptsas_print_phy_pg0(pg0)		do { } while (0)
+#define mptsas_print_device_pg0(pg0)		do { } while (0)
+#define mptsas_print_expander_pg1(pg1)		do { } while (0)
+#endif
+
+static u32
+mptsas_sas_io_unit_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
+{
+	ConfigExtendedPageHeader_t hdr;
+	CONFIGPARMS		cfg;
+	SasIOUnitPage0_t	*sasIoUnitPg0=NULL;
+	dma_addr_t		sasIoUnitPg0_dma;
+	int			sasIoUnitPg0_data_sz=0;
+	int 			ii,rc=0;
+
+	if(!port_info || port_info->num_phys || port_info->phy_info ){
+		rc=-1;
+		goto sas_io_unit_pg0_exit;
+	}
+
+	hdr.PageVersion = MPI_SASIOUNITPAGE0_PAGEVERSION;
+	hdr.ExtPageLength = 0;
+	hdr.PageNumber = 0;
+	hdr.Reserved1 = 0;
+	hdr.Reserved2 = 0;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
+	hdr.ExtPageType = MPI_CONFIG_EXTPAGETYPE_SAS_IO_UNIT;
+
+	cfg.cfghdr.ehdr = &hdr;
+	cfg.physAddr = -1;
+	cfg.pageAddr = 0;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.dir = 0;	/* read */
+	cfg.timeout = 10;
+
+	if ((rc = mpt_config(ioc, &cfg)) != 0) {
+		rc=-1;
+		goto sas_io_unit_pg0_exit;
+	}
+
+	if (hdr.ExtPageLength == 0) {
+		rc=-1;
+		goto sas_io_unit_pg0_exit;
+	}
+
+	sasIoUnitPg0_data_sz = hdr.ExtPageLength * 4;
+	sasIoUnitPg0 = (SasIOUnitPage0_t *) pci_alloc_consistent(ioc->pcidev,
+	    sasIoUnitPg0_data_sz, &sasIoUnitPg0_dma);
+	if (!sasIoUnitPg0) {
+		rc=-1;
+		goto sas_io_unit_pg0_exit;
+	}
+
+	memset((u8 *)sasIoUnitPg0, 0, sasIoUnitPg0_data_sz);
+	cfg.physAddr = sasIoUnitPg0_dma;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+	if ((rc = mpt_config(ioc, &cfg)) != 0) {
+		rc=-1;
+		goto sas_io_unit_pg0_exit;
+	}
+
+	/* save config data */
+	port_info->num_phys = sasIoUnitPg0->NumPhys;
+	port_info->phy_info = kcalloc(port_info->num_phys,
+		sizeof(struct mptsas_phyinfo),GFP_KERNEL);
+	if (!port_info->phy_info) {
+		rc=-1;
+		goto sas_io_unit_pg0_exit;
+	}
+	for (ii = 0; ii < port_info->num_phys; ii++) {
+		mptsas_print_phy_data(&sasIoUnitPg0->PhyData[ii]);
+		port_info->phy_info[ii].phy_id = ii;
+		port_info->phy_info[ii].port_id =
+		    sasIoUnitPg0->PhyData[ii].Port;
+		port_info->phy_info[ii].negotiated_link_rate =
+		    sasIoUnitPg0->PhyData[ii].NegotiatedLinkRate;
+	}
+
+sas_io_unit_pg0_exit:
+
+	if (sasIoUnitPg0)
+		pci_free_consistent(ioc->pcidev, sasIoUnitPg0_data_sz,
+		    (u8 *) sasIoUnitPg0, sasIoUnitPg0_dma);
+
+	return rc;
+}
+
+
+static u32
+mptsas_sas_phy_pg0(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
+		u32 form, u32 form_specific)
+{
+	ConfigExtendedPageHeader_t hdr;
+	CONFIGPARMS		cfg;
+	SasPhyPage0_t		*sasPhyPg0=NULL;
+	dma_addr_t		sasPhyPg0_dma;
+	int			sasPhyPg0_data_sz=0;
+	int 			rc=0;
+
+	if(!phy_info){
+		rc=-1;
+		goto sas_device_pg0_exit;
+	}
+
+	/* Issue a config request to get phy information. */
+	hdr.PageVersion = MPI_SASPHY0_PAGEVERSION;
+	hdr.ExtPageLength = 0;
+	hdr.PageNumber = 0;
+	hdr.Reserved1 = 0;
+	hdr.Reserved2 = 0;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
+	hdr.ExtPageType = MPI_CONFIG_EXTPAGETYPE_SAS_PHY;
+
+	cfg.cfghdr.ehdr = &hdr;
+	cfg.dir = 0;	/* read */
+	cfg.timeout = 10;
+
+	/* Get Phy Pg 0 for each Phy. */
+	cfg.physAddr = -1;
+	cfg.pageAddr = form + form_specific;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+
+	if ((rc = mpt_config(ioc, &cfg)) != 0) {
+		rc=-1;
+		goto sas_device_pg0_exit;
+	}
+
+	if (hdr.ExtPageLength == 0) {
+		rc=-1;
+		goto sas_device_pg0_exit;
+	}
+
+	sasPhyPg0_data_sz = hdr.ExtPageLength * 4;
+	sasPhyPg0 = (SasPhyPage0_t *) pci_alloc_consistent(
+	    ioc->pcidev, sasPhyPg0_data_sz, &sasPhyPg0_dma);
+	if (!sasPhyPg0) {
+		rc=-1;
+		goto sas_device_pg0_exit;
+	}
+
+	memset((u8 *)sasPhyPg0, 0, sasPhyPg0_data_sz);
+	cfg.physAddr = sasPhyPg0_dma;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+	if ((rc = mpt_config(ioc, &cfg)) != 0) {
+		rc=-1;
+		goto sas_device_pg0_exit;
+	}
+
+	mptsas_print_phy_pg0(sasPhyPg0);
+	/* save config data */
+	phy_info->hw_link_rate = sasPhyPg0->HwLinkRate;
+	phy_info->programmed_link_rate = sasPhyPg0->ProgrammedLinkRate;
+	phy_info->identify.handle = le16_to_cpu(sasPhyPg0->OwnerDevHandle);
+	phy_info->attached.handle = le16_to_cpu(sasPhyPg0->AttachedDevHandle);
+
+sas_device_pg0_exit:
+
+	if (sasPhyPg0)
+		pci_free_consistent(ioc->pcidev, sasPhyPg0_data_sz,
+		    (u8 *) sasPhyPg0, sasPhyPg0_dma);
+
+	return rc;
+}
+
+static u32
+mptsas_sas_device_pg0(MPT_ADAPTER *ioc, struct mptsas_devinfo *device_info,
+		u32 form, u32 form_specific)
+{
+	ConfigExtendedPageHeader_t hdr;
+	CONFIGPARMS		cfg;
+	SasDevicePage0_t	*sasDevicePg0=NULL;
+	dma_addr_t		sasDevicePg0_dma;
+	int			sasDevicePg0_data_sz=0;
+	int 			rc=0;
+	u64			SASAddress64;
+
+	if(!device_info){
+		rc=-1;
+		printk("no device info\n");
+		goto sas_device_pg0_exit;
+	}
+
+	hdr.PageVersion = MPI_SASDEVICE0_PAGEVERSION;
+	hdr.ExtPageLength = 0;
+	hdr.PageNumber = 0;
+	hdr.Reserved1 = 0;
+	hdr.Reserved2 = 0;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
+	hdr.ExtPageType = MPI_CONFIG_EXTPAGETYPE_SAS_DEVICE;
+
+	cfg.cfghdr.ehdr = &hdr;
+	cfg.pageAddr = form + form_specific;
+	cfg.physAddr = -1;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.dir = 0;	/* read */
+	cfg.timeout = 10;
+
+	if ((rc = mpt_config(ioc, &cfg)) != 0) {
+		printk("mpt_config failed");
+		goto sas_device_pg0_exit;
+	}
+
+	if (hdr.ExtPageLength == 0) {
+		printk("no exthdr");
+		rc = -EFAULT;
+		goto sas_device_pg0_exit;
+	}
+
+	sasDevicePg0_data_sz = hdr.ExtPageLength * 4;
+	sasDevicePg0 = (SasDevicePage0_t *) pci_alloc_consistent(
+	    ioc->pcidev, sasDevicePg0_data_sz, &sasDevicePg0_dma);
+	if (!sasDevicePg0) {
+		printk("alloc failed");
+		rc = -ENOMEM;
+		goto sas_device_pg0_exit;
+	}
+
+	memset((u8 *)sasDevicePg0, 0, sasDevicePg0_data_sz);
+	cfg.physAddr = sasDevicePg0_dma;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+	if ((rc = mpt_config(ioc, &cfg)) != 0) {
+		printk("second mpt_config failed\n");
+		rc=-1;
+		goto sas_device_pg0_exit;
+	}
+
+	mptsas_print_device_pg0(sasDevicePg0);
+
+	/* save config data */
+	device_info->handle = le16_to_cpu(sasDevicePg0->DevHandle);
+	device_info->phy_id = sasDevicePg0->PhyNum;
+	device_info->port_id = sasDevicePg0->PhysicalPort;
+	device_info->target = sasDevicePg0->TargetID;
+	device_info->bus = sasDevicePg0->Bus;
+	memcpy(&SASAddress64,&sasDevicePg0->SASAddress,
+	    sizeof(sasDevicePg0->SASAddress));
+	le64_to_cpus(&SASAddress64);
+	device_info->sas_address = SASAddress64;
+	device_info->device_info =
+	    le32_to_cpu(sasDevicePg0->DeviceInfo);
+
+sas_device_pg0_exit:
+
+	if (sasDevicePg0)
+		pci_free_consistent(ioc->pcidev, sasDevicePg0_data_sz,
+			    (u8 *) sasDevicePg0, sasDevicePg0_dma);
+
+	return rc;
+}
+
+
+static u32
+mptsas_sas_expander_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info,
+		u32 form, u32 form_specific)
+{
+	ConfigExtendedPageHeader_t hdr;
+	CONFIGPARMS		cfg;
+	SasExpanderPage0_t	*sasExpanderPg0=NULL;
+	dma_addr_t		sasExpanderPg0_dma;
+	int			sasExpanderPg0_data_sz=0;
+	int 			rc=0;
+
+	hdr.PageVersion = MPI_SASEXPANDER0_PAGEVERSION;
+	hdr.ExtPageLength = 0;
+	hdr.PageNumber = 0;
+	hdr.Reserved1 = 0;
+	hdr.Reserved2 = 0;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
+	hdr.ExtPageType = MPI_CONFIG_EXTPAGETYPE_SAS_EXPANDER;
+
+	cfg.cfghdr.ehdr = &hdr;
+	cfg.physAddr = -1;
+	cfg.pageAddr = form + form_specific;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.dir = 0;	/* read */
+	cfg.timeout = 10;
+
+	if ((rc = mpt_config(ioc, &cfg)) != 0) {
+		rc=-1;
+		goto sas_expander_pg0_exit;
+	}
+
+	if (hdr.ExtPageLength == 0) {
+		rc=-1;
+		goto sas_expander_pg0_exit;
+	}
+
+	sasExpanderPg0_data_sz = hdr.ExtPageLength * 4;
+	sasExpanderPg0 = (SasExpanderPage0_t *) pci_alloc_consistent(ioc->pcidev,
+	    sasExpanderPg0_data_sz, &sasExpanderPg0_dma);
+	if (!sasExpanderPg0) {
+		rc=-1;
+		goto sas_expander_pg0_exit;
+	}
+
+	memset((u8 *)sasExpanderPg0, 0, sasExpanderPg0_data_sz);
+	cfg.physAddr = sasExpanderPg0_dma;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+	if ((rc = mpt_config(ioc, &cfg)) != 0) {
+		rc=-1;
+		goto sas_expander_pg0_exit;
+	}
+
+	/* save config data */
+	port_info->num_phys = sasExpanderPg0->NumPhys;
+	port_info->handle = le16_to_cpu(sasExpanderPg0->DevHandle);
+	port_info->phy_info = kcalloc(port_info->num_phys,
+		sizeof(struct mptsas_phyinfo),GFP_KERNEL);
+	if (!port_info->phy_info) {
+		rc=-1;
+		goto sas_expander_pg0_exit;
+	}
+
+sas_expander_pg0_exit:
+
+	if (sasExpanderPg0)
+		pci_free_consistent(ioc->pcidev, sasExpanderPg0_data_sz,
+		    (u8 *) sasExpanderPg0, sasExpanderPg0_dma);
+
+	return rc;
+}
+
+static u32
+mptsas_sas_expander_pg1(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
+		u32 form, u32 form_specific)
+{
+	ConfigExtendedPageHeader_t hdr;
+	CONFIGPARMS		cfg;
+	SasExpanderPage1_t	*sasExpanderPg1=NULL;
+	dma_addr_t		sasExpanderPg1_dma;
+	int			sasExpanderPg1_data_sz=0;
+	int 			rc=0;
+
+	if(!phy_info) {
+		rc=-1;
+		goto sas_expander_pg1_exit;
+	}
+
+	hdr.PageVersion = MPI_SASEXPANDER0_PAGEVERSION;
+	hdr.ExtPageLength = 0;
+	hdr.PageNumber = 1;
+	hdr.Reserved1 = 0;
+	hdr.Reserved2 = 0;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
+	hdr.ExtPageType = MPI_CONFIG_EXTPAGETYPE_SAS_EXPANDER;
+
+	cfg.cfghdr.ehdr = &hdr;
+	cfg.physAddr = -1;
+	cfg.pageAddr = form + form_specific;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.dir = 0;	/* read */
+	cfg.timeout = 10;
+
+	if ((rc = mpt_config(ioc, &cfg)) != 0) {
+		rc=-1;
+		goto sas_expander_pg1_exit;
+	}
+
+	if (hdr.ExtPageLength == 0) {
+		rc=-1;
+		goto sas_expander_pg1_exit;
+	}
+
+	sasExpanderPg1_data_sz = hdr.ExtPageLength * 4;
+	sasExpanderPg1 = (SasExpanderPage1_t *) pci_alloc_consistent(ioc->pcidev,
+	    sasExpanderPg1_data_sz, &sasExpanderPg1_dma);
+	if (!sasExpanderPg1) {
+		rc=-1;
+		goto sas_expander_pg1_exit;
+	}
+
+	memset((u8 *)sasExpanderPg1, 0, sasExpanderPg1_data_sz);
+	cfg.physAddr = sasExpanderPg1_dma;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+	if ((rc = mpt_config(ioc, &cfg)) != 0) {
+		rc=-1;
+		goto sas_expander_pg1_exit;
+	}
+
+	mptsas_print_expander_pg1(sasExpanderPg1);
+
+	/* save config data */
+	phy_info->phy_id = sasExpanderPg1->Phy;
+	phy_info->port_id = sasExpanderPg1->PhysicalPort;
+	phy_info->negotiated_link_rate = sasExpanderPg1->NegotiatedLinkRate;
+	phy_info->programmed_link_rate = sasExpanderPg1->ProgrammedLinkRate;
+	phy_info->hw_link_rate = sasExpanderPg1->HwLinkRate;
+	phy_info->identify.handle = le16_to_cpu(sasExpanderPg1->OwnerDevHandle);
+	phy_info->attached.handle = le16_to_cpu(sasExpanderPg1->AttachedDevHandle);
+
+
+sas_expander_pg1_exit:
+
+	if (sasExpanderPg1)
+		pci_free_consistent(ioc->pcidev, sasExpanderPg1_data_sz,
+		    (u8 *) sasExpanderPg1, sasExpanderPg1_dma);
+
+	return rc;
+}
+
+static void
+mptsas_parse_device_info(struct sas_identify *identify,
+		struct mptsas_devinfo *device_info)
+{
+	u16 protocols;
+
+	identify->sas_address = device_info->sas_address;
+	identify->phy_identifier = device_info->phy_id;
+
+	/*
+	 * Fill in Phy Initiator Port Protocol.
+	 * Bits 6:3, more than one bit can be set, fall through cases.
+	 */
+	protocols = device_info->device_info & 0x78;
+	identify->initiator_port_protocols = 0;
+	if (protocols & MPI_SAS_DEVICE_INFO_SSP_INITIATOR)
+		identify->initiator_port_protocols |= SAS_PROTOCOL_SSP;
+	if (protocols & MPI_SAS_DEVICE_INFO_STP_INITIATOR)
+		identify->initiator_port_protocols |= SAS_PROTOCOL_STP;
+	if (protocols & MPI_SAS_DEVICE_INFO_SMP_INITIATOR)
+		identify->initiator_port_protocols |= SAS_PROTOCOL_SMP;
+	if (protocols & MPI_SAS_DEVICE_INFO_SATA_HOST)
+		identify->initiator_port_protocols |= SAS_PROTOCOL_SATA;
+
+	/*
+	 * Fill in Phy Target Port Protocol.
+	 * Bits 10:7, more than one bit can be set, fall through cases.
+	 */
+	protocols = device_info->device_info & 0x780;
+	identify->target_port_protocols = 0;
+	if (protocols & MPI_SAS_DEVICE_INFO_SSP_TARGET)
+		identify->target_port_protocols |= SAS_PROTOCOL_SSP;
+	if (protocols & MPI_SAS_DEVICE_INFO_STP_TARGET)
+		identify->target_port_protocols |= SAS_PROTOCOL_STP;
+	if (protocols & MPI_SAS_DEVICE_INFO_SMP_TARGET)
+		identify->target_port_protocols |= SAS_PROTOCOL_SMP;
+	if (protocols & MPI_SAS_DEVICE_INFO_SATA_DEVICE)
+		identify->target_port_protocols |= SAS_PROTOCOL_SATA;
+
+	/*
+	 * Fill in Attached device type.
+	 */
+	switch (device_info->device_info &
+			MPI_SAS_DEVICE_INFO_MASK_DEVICE_TYPE) {
+	case MPI_SAS_DEVICE_INFO_NO_DEVICE:
+		identify->device_type = SAS_PHY_UNUSED;
+		break;
+	case MPI_SAS_DEVICE_INFO_END_DEVICE:
+		identify->device_type = SAS_END_DEVICE;
+		break;
+	case MPI_SAS_DEVICE_INFO_EDGE_EXPANDER:
+		identify->device_type = SAS_EDGE_EXPANDER_DEVICE;
+		break;
+	case MPI_SAS_DEVICE_INFO_FANOUT_EXPANDER:
+		identify->device_type = SAS_FANOUT_EXPANDER_DEVICE;
+		break;
+	}
+}
+
+static int mptsas_probe_one_phy(struct device *dev,
+		struct mptsas_phyinfo *phy_info, int index)
+{
+	struct sas_port *port;
+
+	port = sas_port_alloc(dev, index);
+	if (!port)
+		return -ENOMEM;
+
+	port->port_identifier = phy_info->port_id;
+	mptsas_parse_device_info(&port->identify, &phy_info->identify);
+
+	/*
+	 * Set Negotiated link rate.
+	 */
+	switch (phy_info->negotiated_link_rate) {
+	case MPI_SAS_IOUNIT0_RATE_PHY_DISABLED:
+		port->negotiated_linkrate = SAS_PHY_DISABLED;
+		break;
+	case MPI_SAS_IOUNIT0_RATE_FAILED_SPEED_NEGOTIATION:
+		port->negotiated_linkrate = SAS_LINK_RATE_FAILED;
+		break;
+	case MPI_SAS_IOUNIT0_RATE_1_5:
+		port->negotiated_linkrate = SAS_LINK_RATE_1_5_GBPS;
+		break;
+	case MPI_SAS_IOUNIT0_RATE_3_0:
+		port->negotiated_linkrate = SAS_LINK_RATE_3_0_GBPS;
+		break;
+	case MPI_SAS_IOUNIT0_RATE_SATA_OOB_COMPLETE:
+	case MPI_SAS_IOUNIT0_RATE_UNKNOWN:
+	default:
+		port->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
+		break;
+	}
+
+	/*
+	 * Set Max hardware link rate.
+	 */
+	switch (phy_info->hw_link_rate & MPI_SAS_PHY0_PRATE_MAX_RATE_MASK) {
+	case MPI_SAS_PHY0_HWRATE_MAX_RATE_1_5:
+		port->maximum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
+		break;
+	case MPI_SAS_PHY0_PRATE_MAX_RATE_3_0:
+		port->maximum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
+		break;
+	default:
+		break;
+	}
+
+	/*
+	 * Set Max programmed link rate.
+	 */
+	switch (phy_info->programmed_link_rate & MPI_SAS_PHY0_PRATE_MAX_RATE_MASK) {
+	case MPI_SAS_PHY0_PRATE_MAX_RATE_1_5:
+		port->maximum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+		break;
+	case MPI_SAS_PHY0_PRATE_MAX_RATE_3_0:
+		port->maximum_linkrate = SAS_LINK_RATE_3_0_GBPS;
+		break;
+	default:
+		break;
+	}
+
+	/*
+	 * Set Min hardware link rate.
+	 */
+	switch (phy_info->hw_link_rate & MPI_SAS_PHY0_HWRATE_MIN_RATE_MASK) {
+	case MPI_SAS_PHY0_HWRATE_MIN_RATE_1_5:
+		port->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
+		break;
+	case MPI_SAS_PHY0_PRATE_MIN_RATE_3_0:
+		port->minimum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
+		break;
+	default:
+		break;
+	}
+
+	/*
+	 * Set Min programmed link rate.
+	 */
+	switch (phy_info->programmed_link_rate & MPI_SAS_PHY0_PRATE_MIN_RATE_MASK) {
+	case MPI_SAS_PHY0_PRATE_MIN_RATE_1_5:
+		port->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+		break;
+	case MPI_SAS_PHY0_PRATE_MIN_RATE_3_0:
+		port->minimum_linkrate = SAS_LINK_RATE_3_0_GBPS;
+		break;
+	default:
+		break;
+	}
+
+	sas_port_add(port);
+
+	if (phy_info->attached.handle) {
+		struct sas_rport *rport;
+
+		rport = sas_rport_alloc(dev, index, phy_info->attached.bus,
+					phy_info->attached.target);
+		if (!rport)
+			return 0; /* non-fatal: an rport can be added later */
+
+		mptsas_parse_device_info(&rport->identify, &phy_info->attached);
+		sas_rport_add(rport);
+	}
+
+	return 0;
+}
+
+static void
+mptsas_scan_sas_topology(MPT_ADAPTER *ioc)
+{
+	struct mptsas_portinfo port_info;
+	u32 	ii;
+	u32	handle;
+	int index = 0;
+
+	memset(&port_info, 0, sizeof(port_info));
+
+	/* direct attached hba - port info */
+	if((mptsas_sas_io_unit_pg0(ioc, &port_info) != 0) ||
+	    !port_info.num_phys) {
+		kfree(port_info.phy_info);
+		return;
+	}
+
+	/* direct attached hba - phys info */
+	for (ii = 0; ii < port_info.num_phys; ii++)
+		mptsas_sas_phy_pg0(ioc,
+		    &port_info.phy_info[ii],
+		    (MPI_SAS_PHY_PGAD_FORM_PHY_NUMBER <<
+		    MPI_SAS_PHY_PGAD_FORM_SHIFT),
+		    ii);
+
+	/* direct attached hba - fill identify device info */
+	handle = 0xFFFF;
+	for (ii = 0; ii < port_info.num_phys; ii++) {
+		mptsas_sas_device_pg0(ioc,
+		    &port_info.phy_info[ii].identify,
+		    (MPI_SAS_DEVICE_PGAD_FORM_GET_NEXT_HANDLE <<
+		    MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+		    handle);
+		handle = port_info.phy_info[ii].identify.handle;
+	}
+
+	/* direct attached hba - fill attached device info */
+	for (ii = 0; ii < port_info.num_phys; ii++) {
+		if (port_info.phy_info[ii].attached.handle) {
+			mptsas_sas_device_pg0(ioc,
+				&port_info.phy_info[ii].attached,
+				(MPI_SAS_DEVICE_PGAD_FORM_HANDLE <<
+				 MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+				port_info.phy_info[ii].attached.handle);
+			handle = port_info.phy_info[ii].identify.handle;
+		 }
+	}
+
+	for (ii = 0; ii < port_info.num_phys; ii++) {
+		mptsas_probe_one_phy(&ioc->sh->shost_gendev,
+				     &port_info.phy_info[ii], index++);
+	}
+
+	/* add expanders */
+	handle = 0xFFFF;
+	while (1) {
+		memset(&port_info, 0, sizeof(port_info));
+		if( mptsas_sas_expander_pg0(ioc,
+		    &port_info,
+		    (MPI_SAS_EXPAND_PGAD_FORM_GET_NEXT_HANDLE <<
+		    MPI_SAS_EXPAND_PGAD_FORM_SHIFT),
+		    handle) != 0) {
+			kfree(port_info.phy_info);
+			break;
+		}
+		handle = port_info.handle;
+
+		for (ii = 0; ii < port_info.num_phys; ii++)
+			mptsas_sas_expander_pg1(ioc,
+			    &port_info.phy_info[ii],
+			    (MPI_SAS_EXPAND_PGAD_FORM_HANDLE_PHY_NUM <<
+			    MPI_SAS_EXPAND_PGAD_FORM_SHIFT),
+			    (ii << 16) + handle);
+
+		for (ii = 0; ii < port_info.num_phys; ii++)
+		    if (port_info.phy_info[ii].identify.handle)
+				mptsas_sas_device_pg0(ioc,
+				    &port_info.phy_info[ii].identify,
+				    (MPI_SAS_DEVICE_PGAD_FORM_HANDLE <<
+				    MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+				    port_info.phy_info[ii].identify.handle);
+
+		for (ii = 0; ii < port_info.num_phys; ii++)
+			if (port_info.phy_info[ii].attached.handle)
+				mptsas_sas_device_pg0(ioc,
+				    &port_info.phy_info[ii].attached,
+				    (MPI_SAS_DEVICE_PGAD_FORM_HANDLE <<
+				    MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+				    port_info.phy_info[ii].attached.handle);
+
+		for (ii = 0; ii < port_info.num_phys; ii++) {
+			mptsas_probe_one_phy(&ioc->sh->shost_gendev,
+					     &port_info.phy_info[ii],
+					     index++);
+		}
+	}
+}
+
+static struct sas_function_template mptsas_transport_functions = {
+};
+
+static struct scsi_transport_template *mptsas_transport_template;
+
+static struct scsi_host_template mptsas_driver_template = {
+	.proc_name			= "mptsas",
+	.proc_info			= mptscsih_proc_info,
+	.name				= "MPT SPI Host",
+	.info				= mptscsih_info,
+	.queuecommand			= mptscsih_qcmd,
+	.slave_alloc			= mptscsih_slave_alloc,
+	.slave_configure		= mptscsih_slave_configure,
+	.slave_destroy			= mptscsih_slave_destroy,
+	.change_queue_depth 		= mptscsih_change_queue_depth,
+	.eh_abort_handler		= mptscsih_abort,
+	.eh_device_reset_handler	= mptscsih_dev_reset,
+	.eh_bus_reset_handler		= mptscsih_bus_reset,
+	.eh_host_reset_handler		= mptscsih_host_reset,
+	.bios_param			= mptscsih_bios_param,
+	.can_queue			= MPT_FC_CAN_QUEUE,
+	.this_id			= -1,
+	.sg_tablesize			= MPT_SCSI_SG_DEPTH,
+	.max_sectors			= 8192,
+	.cmd_per_lun			= 7,
+	.use_clustering			= ENABLE_CLUSTERING,
+};
+
+static int
+mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct Scsi_Host	*sh;
+	MPT_SCSI_HOST		*hd;
+	MPT_ADAPTER 		*ioc;
+	unsigned long		 flags;
+	int			 sz, ii;
+	int			 numSGE = 0;
+	int			 scale;
+	int			 ioc_cap;
+	u8			*mem;
+	int			error=0;
+	int			r;
+
+	r = mpt_attach(pdev,id);
+	if (r)
+		return r;
+
+	ioc = pci_get_drvdata(pdev);
+	ioc->DoneCtx = mptsasDoneCtx;
+	ioc->TaskCtx = mptsasTaskCtx;
+	ioc->InternalCtx = mptsasInternalCtx;
+
+	/*  Added sanity check on readiness of the MPT adapter.
+	 */
+	if (ioc->last_state != MPI_IOC_STATE_OPERATIONAL) {
+		printk(MYIOC_s_WARN_FMT
+		  "Skipping because it's not operational!\n",
+		  ioc->name);
+		return -ENODEV;
+	}
+
+	if (!ioc->active) {
+		printk(MYIOC_s_WARN_FMT "Skipping because it's disabled!\n",
+		  ioc->name);
+		return -ENODEV;
+	}
+
+	/*  Sanity check - ensure at least 1 port is INITIATOR capable
+	 */
+	ioc_cap = 0;
+	for (ii = 0; ii < ioc->facts.NumberOfPorts; ii++) {
+		if (ioc->pfacts[ii].ProtocolFlags &
+				MPI_PORTFACTS_PROTOCOL_INITIATOR)
+			ioc_cap++;
+	}
+
+	if (!ioc_cap) {
+		printk(MYIOC_s_WARN_FMT
+			"Skipping ioc=%p because SCSI Initiator mode "
+			"is NOT enabled!\n", ioc->name, ioc);
+		return -ENODEV;
+	}
+
+	sh = scsi_host_alloc(&mptsas_driver_template, sizeof(MPT_SCSI_HOST));
+	if (!sh) {
+		printk(MYIOC_s_WARN_FMT
+			"Unable to register controller with SCSI subsystem\n",
+			ioc->name);
+                return -1;
+        }
+
+	spin_lock_irqsave(&ioc->FreeQlock, flags);
+
+	/* Attach the SCSI Host to the IOC structure
+	 */
+	ioc->sh = sh;
+
+	sh->io_port = 0;
+	sh->n_io_port = 0;
+	sh->irq = 0;
+
+	/* set 16 byte cdb's */
+	sh->max_cmd_len = 16;
+
+	sh->max_id = ioc->pfacts->MaxDevices + 1;
+
+	sh->transportt = mptsas_transport_template;
+
+	sh->max_lun = MPT_LAST_LUN + 1;
+	sh->max_channel = 0;
+	sh->this_id = ioc->pfacts[0].PortSCSIID;
+
+	/* Required entry.
+	 */
+	sh->unique_id = ioc->id;
+
+	/* Verify that we won't exceed the maximum
+	 * number of chain buffers
+	 * We can optimize:  ZZ = req_sz/sizeof(SGE)
+	 * For 32bit SGE's:
+	 *  numSGE = 1 + (ZZ-1)*(maxChain -1) + ZZ
+	 *               + (req_sz - 64)/sizeof(SGE)
+	 * A slightly different algorithm is required for
+	 * 64bit SGEs.
+	 */
+	scale = ioc->req_sz/(sizeof(dma_addr_t) + sizeof(u32));
+	if (sizeof(dma_addr_t) == sizeof(u64)) {
+		numSGE = (scale - 1) *
+		  (ioc->facts.MaxChainDepth-1) + scale +
+		  (ioc->req_sz - 60) / (sizeof(dma_addr_t) +
+		  sizeof(u32));
+	} else {
+		numSGE = 1 + (scale - 1) *
+		  (ioc->facts.MaxChainDepth-1) + scale +
+		  (ioc->req_sz - 64) / (sizeof(dma_addr_t) +
+		  sizeof(u32));
+	}
+
+	if (numSGE < sh->sg_tablesize) {
+		/* Reset this value */
+		dprintk((MYIOC_s_INFO_FMT
+		  "Resetting sg_tablesize to %d from %d\n",
+		  ioc->name, numSGE, sh->sg_tablesize));
+		sh->sg_tablesize = numSGE;
+	}
+
+	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
+
+	hd = (MPT_SCSI_HOST *) sh->hostdata;
+	hd->ioc = ioc;
+
+	/* SCSI needs scsi_cmnd lookup table!
+	 * (with size equal to req_depth*PtrSz!)
+	 */
+	sz = ioc->req_depth * sizeof(void *);
+	mem = kmalloc(sz, GFP_ATOMIC);
+	if (mem == NULL) {
+		error = -ENOMEM;
+		goto mptsas_probe_failed;
+	}
+
+	memset(mem, 0, sz);
+	hd->ScsiLookup = (struct scsi_cmnd **) mem;
+
+	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p, sz=%d\n",
+		 ioc->name, hd->ScsiLookup, sz));
+
+	/* Allocate memory for the device structures.
+	 * A non-Null pointer at an offset
+	 * indicates a device exists.
+	 * max_id = 1 + maximum id (hosts.h)
+	 */
+	sz = sh->max_id * sizeof(void *);
+	mem = kmalloc(sz, GFP_ATOMIC);
+	if (mem == NULL) {
+		error = -ENOMEM;
+		goto mptsas_probe_failed;
+	}
+
+	memset(mem, 0, sz);
+	hd->Targets = (VirtDevice **) mem;
+
+	dprintk((KERN_INFO
+	  "  Targets @ %p, sz=%d\n", hd->Targets, sz));
+
+	/* Clear the TM flags
+	 */
+	hd->tmPending = 0;
+	hd->tmState = TM_STATE_NONE;
+	hd->resetPending = 0;
+	hd->abortSCpnt = NULL;
+
+	/* Clear the pointer used to store
+	 * single-threaded commands, i.e., those
+	 * issued during a bus scan, dv and
+	 * configuration pages.
+	 */
+	hd->cmdPtr = NULL;
+
+	/* Initialize this SCSI Hosts' timers
+	 * To use, set the timer expires field
+	 * and add_timer
+	 */
+	init_timer(&hd->timer);
+	hd->timer.data = (unsigned long) hd;
+	hd->timer.function = mptscsih_timer_expired;
+
+	hd->mpt_pq_filter = mpt_pq_filter;
+	ioc->sas_data.ptClear = mpt_pt_clear;
+
+	if (ioc->sas_data.ptClear==1) {
+		mptbase_sas_persist_operation(
+		    ioc, MPI_SAS_OP_CLEAR_ALL_PERSISTENT);
+	}
+
+	ddvprintk((MYIOC_s_INFO_FMT
+		"mpt_pq_filter %x mpt_pq_filter %x\n",
+		ioc->name,
+		mpt_pq_filter,
+		mpt_pq_filter));
+
+	init_waitqueue_head(&hd->scandv_waitq);
+	hd->scandv_wait_done = 0;
+	hd->last_queue_full = 0;
+
+	error = scsi_add_host(sh, &ioc->pcidev->dev);
+	if (error) {
+		dprintk((KERN_ERR MYNAM
+		  "scsi_add_host failed\n"));
+		goto mptsas_probe_failed;
+	}
+
+	mptsas_scan_sas_topology(ioc);
+
+	return 0;
+
+mptsas_probe_failed:
+
+	mptscsih_remove(pdev);
+	return error;
+}
+
+static void __devexit mptsas_remove(struct pci_dev *pdev)
+{
+	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
+
+	sas_remove_host(ioc->sh);
+	mptscsih_remove(pdev);
+}
+
+static struct pci_device_id mptsas_pci_table[] = {
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1064,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1066,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1068,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1064E,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1066E,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1068E,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{0}	/* Terminating entry */
+};
+MODULE_DEVICE_TABLE(pci, mptsas_pci_table);
+
+
+static struct pci_driver mptsas_driver = {
+	.name		= "mptsas",
+	.id_table	= mptsas_pci_table,
+	.probe		= mptsas_probe,
+	.remove		= __devexit_p(mptsas_remove),
+	.shutdown	= mptscsih_shutdown,
+#ifdef CONFIG_PM
+	.suspend	= mptscsih_suspend,
+	.resume		= mptscsih_resume,
+#endif
+};
+
+static int __init
+mptsas_init(void)
+{
+	show_mptmod_ver(my_NAME, my_VERSION);
+
+	mptsas_transport_template =
+	    sas_attach_transport(&mptsas_transport_functions);
+	if (!mptsas_transport_template)
+		return -ENODEV;
+
+	mptsasDoneCtx = mpt_register(mptscsih_io_done, MPTSAS_DRIVER);
+	mptsasTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSAS_DRIVER);
+	mptsasInternalCtx =
+		mpt_register(mptscsih_scandv_complete, MPTSAS_DRIVER);
+
+	if (mpt_event_register(mptsasDoneCtx, mptscsih_event_process) == 0) {
+		devtprintk((KERN_INFO MYNAM
+		  ": Registered for IOC event notifications\n"));
+	}
+
+	if (mpt_reset_register(mptsasDoneCtx, mptscsih_ioc_reset) == 0) {
+		dprintk((KERN_INFO MYNAM
+		  ": Registered for IOC reset notifications\n"));
+	}
+
+	return pci_register_driver(&mptsas_driver);
+}
+
+static void __exit
+mptsas_exit(void)
+{
+	pci_unregister_driver(&mptsas_driver);
+	sas_release_transport(mptsas_transport_template);
+
+	mpt_reset_deregister(mptsasDoneCtx);
+	mpt_event_deregister(mptsasDoneCtx);
+
+	mpt_deregister(mptsasInternalCtx);
+	mpt_deregister(mptsasTaskCtx);
+	mpt_deregister(mptsasDoneCtx);
+}
+
+module_init(mptsas_init);
+module_exit(mptsas_exit);
