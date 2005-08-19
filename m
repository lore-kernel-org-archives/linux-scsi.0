From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] fusion: add mptsas driver
Date: Fri, 19 Aug 2005 18:28:59 +0200
Message-ID: <20050819162859.GC15401@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:39388 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S965006AbVHSQ3H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 12:29:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

This adds the actual mptsas driver.  Based on lsi's driver with the
transport class integration and the different discovery scheme added
by me.  This is pretty minimal still, no support for hotplug or any
fancyness yet.


Index: scsi-misc-2.6/drivers/message/fusion/Kconfig
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/Kconfig	2005-08-18 15:52:12.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/Kconfig	2005-08-18 15:52:31.000000000 +0200
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
--- scsi-misc-2.6.orig/drivers/message/fusion/Makefile	2005-08-18 15:52:12.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/Makefile	2005-08-18 15:52:31.000000000 +0200
@@ -34,5 +34,6 @@
 
 obj-$(CONFIG_FUSION_SPI)	+= mptbase.o mptscsih.o mptspi.o
 obj-$(CONFIG_FUSION_FC)		+= mptbase.o mptscsih.o mptfc.o
+obj-$(CONFIG_FUSION_SAS)	+= mptbase.o mptscsih.o mptsas.o
 obj-$(CONFIG_FUSION_CTL)	+= mptctl.o
 obj-$(CONFIG_FUSION_LAN)	+= mptlan.o
Index: scsi-misc-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ scsi-misc-2.6/drivers/message/fusion/mptsas.c	2005-08-19 18:31:36.000000000 +0200
@@ -0,0 +1,877 @@
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
+	/* XXX(hch): that stupid LSI U64 type is not a scalar.. */
+	memcpy(&sas_address, &pg0->SASAddress, sizeof(__le64));
+
+	printk("---- SAS PHY PAGE 0 ------------\n");
+	printk("Handle=0x%X\n", le16_to_cpu(pg0->AttachedDevHandle));
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
+	/* XXX(hch): that stupid LSI U64 type is not a scalar.. */
+	memcpy(&sas_address, &pg0->SASAddress, sizeof(__le64));
+
+	printk("---- SAS DEVICE PAGE 0 ---------\n");
+	printk("Handle=0x%X\n" ,le16_to_cpu(pg0->DevHandle));
+	printk("Enclosure Handle=0x%X\n", le16_to_cpu(pg0->EnclosureHandle));
+	printk("Slot=0x%X\n", le16_to_cpu(pg0->Slot));
+	printk("SAS Address=0x%lX\n", le64_to_cpu(sas_address));
+	printk("Target ID=0x%X\n", pg0->TargetID);
+	printk("Bus=0x%X\n", pg0->Bus);
+	printk("PhyNum=0x%X\n", pg0->PhyNum);
+	printk("AccessStatus=0x%X\n", le16_to_cpu(pg0->AccessStatus));
+	printk("Device Info=0x%X\n", le32_to_cpu(pg0->DeviceInfo));
+	printk("Flags=0x%X\n", le16_to_cpu(pg0->Flags));
+	printk("Physical Port=0x%X\n", pg0->PhysicalPort);
+	printk("\n");
+}
+#else
+#define mptsas_print_phy_data(phy_data)		do { } while (0)
+#define mptsas_print_phy_pg0(pg0)		do { } while (0)
+#define mptsas_print_device_pg0(pg0)		do { } while (0)
+#endif
+
+static void mptsas_parse_device_info(struct sas_identify *identify,
+		__le32 mpt_device_info)
+{
+	u16 protocols;
+
+	/*
+	 * Fill in Phy Initiator Port Protocol.
+	 * Bits 6:3, more than one bit can be set, fall through cases.
+	 */
+	protocols = le32_to_cpu(mpt_device_info) & 0x78;
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
+	protocols = le32_to_cpu(mpt_device_info) & 0x780;
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
+	switch (le32_to_cpu(mpt_device_info) &
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
+static void mptsas_get_attached_device_info(struct sas_identify *attached,
+		SasPhyPage0_t *pg0)
+{
+	__le64 sas_address;
+
+	mptsas_parse_device_info(attached, pg0->AttachedDeviceInfo);
+
+	/* XXX(hch): that stupid LSI U64 type is not a scalar.. */
+	memcpy(&sas_address, &pg0->SASAddress, sizeof(__le64));
+	attached->sas_address = le64_to_cpu(sas_address);
+	attached->phy_identifier = pg0->AttachedPhyIdentifier;
+}
+
+static int mptsas_get_phy_info_pg0(MPT_ADAPTER *ioc, int phy_num,
+		struct sas_port_attrs *attr, struct sas_identify *attached)
+{
+	ConfigExtendedPageHeader_t  hdr;
+	CONFIGPARMS cfg;
+	SasPhyPage0_t *pg0;
+	dma_addr_t pg0_handle;
+	int pg0_size;
+	int error;
+	__le64 sas_address;
+
+	memset(&hdr, 0, sizeof(hdr));
+	hdr.PageVersion = MPI_SASPHY0_PAGEVERSION;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
+	hdr.ExtPageType = MPI_CONFIG_EXTPAGETYPE_SAS_PHY;
+
+	memset(&cfg, 0, sizeof(cfg));
+	cfg.cfghdr.ehdr = &hdr;
+	cfg.physAddr = -1;
+	cfg.pageAddr = phy_num;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.timeout = 10;
+
+	error = mpt_config(ioc, &cfg);
+	if (error)
+		goto out;
+	if (!hdr.ExtPageLength) {
+		error = -ENXIO;
+		goto out;
+	}
+
+	pg0_size = hdr.ExtPageLength * 4;
+
+	pg0 = pci_alloc_consistent(ioc->pcidev, pg0_size, &pg0_handle);
+	if (!pg0) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	cfg.physAddr = pg0_handle;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+	error = mpt_config(ioc, &cfg);
+	if (error)
+		goto out_free_consistent;
+
+	mptsas_print_phy_pg0(pg0);
+
+	/*
+	 * Set Max hardware link rate.
+	 */
+	switch (pg0->HwLinkRate & MPI_SAS_PHY0_PRATE_MAX_RATE_MASK) {
+	case MPI_SAS_PHY0_HWRATE_MAX_RATE_1_5:
+		attr->maximum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
+		break;
+	case MPI_SAS_PHY0_PRATE_MAX_RATE_3_0:
+		attr->maximum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
+		break;
+	default:
+		break;
+	}
+
+	/*
+	 * Set Max programmed link rate.
+	 */
+	switch (pg0->ProgrammedLinkRate & MPI_SAS_PHY0_PRATE_MAX_RATE_MASK) {
+	case MPI_SAS_PHY0_PRATE_MAX_RATE_1_5:
+		attr->maximum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+		break;
+	case MPI_SAS_PHY0_PRATE_MAX_RATE_3_0:
+		attr->maximum_linkrate = SAS_LINK_RATE_3_0_GBPS;
+		break;
+	default:
+		break;
+	}
+
+	/*
+	 * Set Min hardware link rate.
+	 */
+	switch (pg0->HwLinkRate & MPI_SAS_PHY0_HWRATE_MIN_RATE_MASK) {
+	case MPI_SAS_PHY0_HWRATE_MIN_RATE_1_5:
+		attr->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
+		break;
+	case MPI_SAS_PHY0_PRATE_MIN_RATE_3_0:
+		attr->minimum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
+		break;
+	default:
+		break;
+	}
+
+	/*
+	 * Set Min programmed link rate.
+	 */
+	switch (pg0->ProgrammedLinkRate & MPI_SAS_PHY0_PRATE_MIN_RATE_MASK) {
+	case MPI_SAS_PHY0_PRATE_MIN_RATE_1_5:
+		attr->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+		break;
+	case MPI_SAS_PHY0_PRATE_MIN_RATE_3_0:
+		attr->minimum_linkrate = SAS_LINK_RATE_3_0_GBPS;
+		break;
+	default:
+		break;
+	}
+
+	/* XXX(hch): that stupid LSI U64 type is not a scalar.. */
+	memcpy(&sas_address, &pg0->SASAddress, sizeof(__le64));
+	attr->identify.sas_address = le64_to_cpu(sas_address);
+
+	/*
+	 * Get information about the attached device.
+	 */
+	mptsas_get_attached_device_info(attached, pg0);
+
+ out_free_consistent:
+	pci_free_consistent(ioc->pcidev, pg0_size, pg0, pg0_handle);
+ out:
+	return error;
+}
+
+static void mptsas_get_phy_info(MPT_ADAPTER *ioc,
+		MPI_SAS_IO_UNIT0_PHY_DATA *phy_data,
+		struct sas_port_attrs *attr)
+{
+	mptsas_print_phy_data(phy_data);
+
+	attr->port_identifier = phy_data->Port;
+
+	switch (phy_data->NegotiatedLinkRate) {
+	case MPI_SAS_IOUNIT0_RATE_PHY_DISABLED:
+		attr->negotiated_linkrate = SAS_PHY_DISABLED;
+		break;
+	case MPI_SAS_IOUNIT0_RATE_FAILED_SPEED_NEGOTIATION:
+		attr->negotiated_linkrate = SAS_LINK_RATE_FAILED;
+		break;
+	case MPI_SAS_IOUNIT0_RATE_1_5:
+		attr->negotiated_linkrate = SAS_LINK_RATE_1_5_GBPS;
+		break;
+	case MPI_SAS_IOUNIT0_RATE_3_0:
+		attr->negotiated_linkrate = SAS_LINK_RATE_3_0_GBPS;
+		break;
+	case MPI_SAS_IOUNIT0_RATE_SATA_OOB_COMPLETE:
+	case MPI_SAS_IOUNIT0_RATE_UNKNOWN:
+	default:
+		attr->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
+		break;
+	}
+
+	mptsas_parse_device_info(&attr->identify,
+			phy_data->ControllerPhyDeviceInfo);
+}
+
+static int
+mptsas_probe_phys(MPT_SCSI_HOST *hd)
+{
+	MPT_ADAPTER *ioc = hd->ioc;
+	ConfigExtendedPageHeader_t  hdr;
+	CONFIGPARMS cfg;
+	SasIOUnitPage0_t *iounit;
+	dma_addr_t iounit_handle;
+	int iounit_size, error, i;
+
+	memset(&hdr, 0, sizeof(hdr));
+	hdr.PageVersion = MPI_SASIOUNITPAGE0_PAGEVERSION;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
+	hdr.ExtPageType = MPI_CONFIG_EXTPAGETYPE_SAS_IO_UNIT;
+
+	memset(&cfg, 0, sizeof(cfg));
+	cfg.cfghdr.ehdr = &hdr;
+	cfg.physAddr = -1;
+	cfg.pageAddr = 0;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.dir = 0;	/* read */
+	cfg.timeout = 10;
+
+	error = mpt_config(ioc, &cfg);
+	if (error)
+		goto out;
+	if (!hdr.ExtPageLength) {
+		error = -ENXIO;
+		goto out;
+	}
+
+	iounit_size = hdr.ExtPageLength * 4;
+	iounit = pci_alloc_consistent(ioc->pcidev, iounit_size, &iounit_handle);
+	if (!iounit) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	cfg.physAddr = iounit_handle;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+	error = mpt_config(ioc, &cfg);
+	if (error)
+		goto out_free_consistent;
+
+	ioc->num_sas_ports = iounit->NumPhys;
+	ioc->sas_attached = kcalloc(iounit->NumPhys,
+			sizeof(struct sas_identify), GFP_KERNEL);
+	if (!ioc->sas_attached) {
+		error = -ENOMEM;
+		goto out_free_consistent;
+	}
+	ioc->sas_ports = kcalloc(iounit->NumPhys,
+			sizeof(struct sas_port *), GFP_KERNEL);
+	if (!ioc->sas_ports) {
+		error = -ENOMEM;
+		goto out_free_attached;
+	}
+
+	for (i = 0; i < ioc->num_sas_ports; i++) {
+		struct sas_port_attrs *attrs;
+
+		attrs = kmalloc(sizeof(*attrs), GFP_KERNEL);
+		if (!attrs)
+			goto out_free_ports;
+		memset(attrs, 0, sizeof(*attrs));
+
+		error = mptsas_get_phy_info_pg0(ioc, i, attrs,
+				&ioc->sas_attached[i]);
+		if (error) {
+			kfree(attrs);
+			goto out_free_ports;
+		}
+		mptsas_get_phy_info(ioc, &iounit->PhyData[i], attrs);
+		attrs->identify.phy_identifier = i;
+
+		ioc->sas_ports[i] = sas_port_add(ioc->sh, i, attrs);
+		if (IS_ERR(ioc->sas_ports[i])) {
+			error = PTR_ERR(ioc->sas_ports[i]);
+			goto out_free_ports;
+		}
+	}
+
+	error = 0;
+	goto out_free_consistent;
+
+ out_free_ports:
+	while (--i >= 0)
+		sas_port_delete(ioc->sas_ports[i]);
+	kfree(ioc->sas_ports);
+ out_free_attached:
+	kfree(ioc->sas_attached);
+ out_free_consistent:
+	pci_free_consistent(ioc->pcidev, iounit_size, iounit, iounit_handle);
+ out:
+	return error;
+}
+
+static int mptsas_probe_attached_device(MPT_ADAPTER *ioc,
+		u32 *dev_handle, int *phy_counter)
+{
+	ConfigExtendedPageHeader_t hdr;
+	CONFIGPARMS cfg;
+	SasDevicePage0_t *pg0;
+	dma_addr_t pg0_handle;
+	int pg0_size, error;
+
+	memset(&hdr, 0, sizeof(hdr));
+	hdr.PageVersion = MPI_SASDEVICE0_PAGEVERSION;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
+	hdr.ExtPageType = MPI_CONFIG_EXTPAGETYPE_SAS_DEVICE;
+
+	memset(&cfg, 0, sizeof(cfg));
+	cfg.cfghdr.ehdr = &hdr;
+	cfg.physAddr = -1;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.timeout = 10;
+
+	error = mpt_config(ioc, &cfg);
+	if (error)
+		goto out;
+	if (!hdr.ExtPageLength) {
+		error = -ENXIO;
+		goto out;
+	}
+
+	pg0_size = hdr.ExtPageLength * 4;
+	pg0 = pci_alloc_consistent(ioc->pcidev, pg0_size, &pg0_handle);
+	if (!pg0) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	cfg.physAddr = pg0_handle;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+	cfg.pageAddr = *dev_handle;
+
+	error = mpt_config(ioc, &cfg);
+	if (error) {
+		/*
+		 * break from the while loop when this fails
+		 * which means we have discovered all devices
+		 */
+		error = 1;
+		goto out_free_consistent;
+	}
+
+	mptsas_print_device_pg0(pg0);
+
+	if (*phy_counter >= ioc->num_sas_ports) {
+		sas_add_target(ioc->sas_ports[pg0->PhysicalPort],
+				&ioc->sas_attached[pg0->PhysicalPort],
+				pg0->Bus, pg0->TargetID);
+	} else
+		(*phy_counter)++;
+
+	*dev_handle =
+		(MPI_SAS_DEVICE_PGAD_FORM_GET_NEXT_HANDLE <<
+		 MPI_SAS_DEVICE_PGAD_FORM_SHIFT) | le16_to_cpu(pg0->DevHandle);
+
+ out_free_consistent:
+	pci_free_consistent(ioc->pcidev, pg0_size, pg0, pg0_handle);
+ out:
+	return error;
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
+	u32			dev_handle = 0xFFFF, phy_counter = 0;
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
+	error = mptsas_probe_phys(hd);
+	if (error)
+		goto mptsas_probe_failed;
+
+	/*
+	 * A positive return value from mptsas_probe_attached_device means
+	 * we have discovered all devices and is not an error.
+	 */
+	do {
+		error = mptsas_probe_attached_device(ioc,
+				&dev_handle, &phy_counter);
+		if (error < 0)
+			goto mptsas_probe_failed;
+	} while (!error);
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
+	int i;
+
+	for (i = 0; i < ioc->num_sas_ports; i++)
+		sas_port_delete(ioc->sas_ports[i]);
+
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
Index: scsi-misc-2.6/drivers/message/fusion/mptbase.h
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptbase.h	2005-08-18 15:52:12.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/mptbase.h	2005-08-18 15:52:31.000000000 +0200
@@ -595,6 +595,9 @@
 	int			 InternalCtx;
 	struct list_head	 list;
 	struct net_device	*netdev;
+	int			 num_sas_ports;
+	struct sas_port	       **sas_ports;
+	struct sas_identify	*sas_attached;
 } MPT_ADAPTER;
 
 /*
