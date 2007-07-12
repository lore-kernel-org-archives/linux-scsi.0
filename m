From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH] mpt fusion: add sysfs attributes to display IOC parameters
Date: Thu, 12 Jul 2007 13:52:31 +0530
Message-ID: <20070712082230.GA27605@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53914 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759433AbXGLIY2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jul 2007 04:24:28 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id l6C8NCeP002771
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jul 2007 01:23:12 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

Resubmitting with the changes suggested by Brian King :

New sysfs scsi_host attributes are added to provide information about Firmware
version, BIOS version, Driver version, MPI version and other product related 
information

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff -Naurp b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-07-02 16:20:46.000000000 +0530
+++ a/drivers/message/fusion/mptbase.c	2007-07-11 19:00:40.000000000 +0530
@@ -161,6 +161,7 @@ static int	mpt_readScsiDevicePageHeaders
 static void 	mpt_read_ioc_pg_1(MPT_ADAPTER *ioc);
 static void 	mpt_read_ioc_pg_4(MPT_ADAPTER *ioc);
 static void	mpt_timer_expired(unsigned long data);
+static void	mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc);
 static int	SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch);
 static int	SendEventAck(MPT_ADAPTER *ioc, EventNotificationReply_t *evnp);
 static int	mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_value, int sleepFlag);
@@ -1880,6 +1881,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		}
 
 		GetIoUnitPage2(ioc);
+		mpt_get_manufacturing_pg_0(ioc);
 	}
 
 	/*
@@ -5190,6 +5192,49 @@ mpt_read_ioc_pg_1(MPT_ADAPTER *ioc)
 	return;
 }
 
+static void
+mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc)
+{
+	CONFIGPARMS		cfg;
+	ConfigPageHeader_t	hdr;
+	dma_addr_t		buf_dma;
+	ManufacturingPage0_t	*pbuf = NULL;
+
+	memset(&cfg, 0 , sizeof(CONFIGPARMS));
+	memset(&hdr, 0 , sizeof(ConfigPageHeader_t));
+
+	hdr.PageType = MPI_CONFIG_PAGETYPE_MANUFACTURING;
+	cfg.cfghdr.hdr = &hdr;
+	cfg.physAddr = -1;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.timeout = 10;
+
+	if (mpt_config(ioc, &cfg) != 0)
+		goto out;
+
+	if (!cfg.cfghdr.hdr->PageLength)
+		goto out;
+
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+	pbuf = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4, &buf_dma);
+	if (!pbuf)
+		goto out;
+
+	cfg.physAddr = buf_dma;
+
+	if (mpt_config(ioc, &cfg) != 0)
+		goto out;
+
+	memcpy(ioc->board_name, pbuf->BoardName, sizeof(ioc->board_name));
+	memcpy(ioc->board_assembly, pbuf->BoardAssembly, sizeof(ioc->board_assembly));
+	memcpy(ioc->board_tracer, pbuf->BoardTracerNumber, sizeof(ioc->board_tracer));
+
+	out:
+
+	if (pbuf)
+		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, pbuf, buf_dma);
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	SendEventNotification - Send EventNotification (on or off) request to adapter
diff -Naurp b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-07-02 16:20:46.000000000 +0530
+++ a/drivers/message/fusion/mptbase.h	2007-07-11 19:16:48.000000000 +0530
@@ -538,6 +538,13 @@ typedef struct _MPT_ADAPTER
 	int			 pci_irq;	/* This irq           */
 	char			 name[MPT_NAME_LENGTH];	/* "iocN"             */
 	char			*prod_name;	/* "LSIFC9x9"         */
+	char			 board_name[16];
+	char			 board_assembly[16];
+	char			 board_tracer[16];
+	u16			 nvdata_version_persistent;
+	u16			 nvdata_version_default;
+	u8			 io_missing_delay;
+	u8			 device_missing_delay;
 	SYSIF_REGS __iomem	*chip;		/* == c8817000 (mmap) */
 	SYSIF_REGS __iomem	*pio_chip;	/* Programmed IO (downloadboot) */
 	u8			 bus_type;
diff -Naurp b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2007-07-02 16:20:46.000000000 +0530
+++ a/drivers/message/fusion/mptfc.c	2007-07-11 18:48:35.000000000 +0530
@@ -130,6 +130,7 @@ static struct scsi_host_template mptfc_d
 	.max_sectors			= 8192,
 	.cmd_per_lun			= 7,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.shost_attrs			= mptscsih_host_attrs,
 };
 
 /****************************************************************************
diff -Naurp b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-07-02 16:20:46.000000000 +0530
+++ a/drivers/message/fusion/mptsas.c	2007-07-11 18:48:35.000000000 +0530
@@ -1119,6 +1119,7 @@ static struct scsi_host_template mptsas_
 	.max_sectors			= 8192,
 	.cmd_per_lun			= 7,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.shost_attrs			= mptscsih_host_attrs,
 };
 
 static int mptsas_get_linkerrors(struct sas_phy *phy)
@@ -1389,6 +1390,11 @@ mptsas_sas_io_unit_pg0(MPT_ADAPTER *ioc,
 		error = -ENOMEM;
 		goto out_free_consistent;
 	}
+	
+	ioc->nvdata_version_persistent =
+	    le16_to_cpu(buffer->NvdataVersionPersistent);
+	ioc->nvdata_version_default =
+	    le16_to_cpu(buffer->NvdataVersionDefault);
 
 	for (i = 0; i < port_info->num_phys; i++) {
 		mptsas_print_phy_data(&buffer->PhyData[i]);
@@ -1410,6 +1416,63 @@ mptsas_sas_io_unit_pg0(MPT_ADAPTER *ioc,
 }
 
 static int
+mptsas_sas_io_unit_pg1(MPT_ADAPTER *ioc)
+{
+	ConfigExtendedPageHeader_t hdr;
+	CONFIGPARMS cfg;
+	SasIOUnitPage1_t *buffer;
+	dma_addr_t dma_handle;
+	int error;
+	u16 device_missing_delay;
+
+	memset(&hdr, 0, sizeof(ConfigExtendedPageHeader_t));
+	memset(&cfg, 0, sizeof(CONFIGPARMS));
+
+	cfg.cfghdr.ehdr = &hdr;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.timeout = 10;
+	cfg.cfghdr.ehdr->PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
+	cfg.cfghdr.ehdr->ExtPageType = MPI_CONFIG_EXTPAGETYPE_SAS_IO_UNIT;
+	cfg.cfghdr.ehdr->PageVersion = MPI_SASIOUNITPAGE1_PAGEVERSION;
+	cfg.cfghdr.ehdr->PageNumber = 1;
+
+	error = mpt_config(ioc, &cfg);
+	if (error)
+		goto out;
+	if (!hdr.ExtPageLength) {
+		error = -ENXIO;
+		goto out;
+	}
+
+	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
+					    &dma_handle);
+	if (!buffer) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	cfg.physAddr = dma_handle;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+	error = mpt_config(ioc, &cfg);
+	if (error)
+		goto out_free_consistent;
+
+	ioc->io_missing_delay  =
+	    le16_to_cpu(buffer->IODeviceMissingDelay);
+	device_missing_delay = le16_to_cpu(buffer->ReportDeviceMissingDelay);
+	ioc->device_missing_delay = (device_missing_delay & MPI_SAS_IOUNIT1_REPORT_MISSING_UNIT_16) ?
+	    (device_missing_delay & MPI_SAS_IOUNIT1_REPORT_MISSING_TIMEOUT_MASK) * 16 :
+	    device_missing_delay & MPI_SAS_IOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
+
+ out_free_consistent:
+	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
+			    buffer, dma_handle);
+ out:
+	return error;
+}
+
+static int
 mptsas_sas_phy_pg0(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 		u32 form, u32 form_specific)
 {
@@ -1990,6 +2053,7 @@ mptsas_probe_hba_phys(MPT_ADAPTER *ioc)
 	if (error)
 		goto out_free_port_info;
 
+	mptsas_sas_io_unit_pg1(ioc);
 	mutex_lock(&ioc->sas_topology_mutex);
 	ioc->handle = hba->phy_info[0].handle;
 	port_info = mptsas_find_portinfo_by_handle(ioc, ioc->handle);
diff -Naurp b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-07-02 16:20:46.000000000 +0530
+++ a/drivers/message/fusion/mptscsih.c	2007-07-11 19:12:46.000000000 +0530
@@ -3187,6 +3187,167 @@ mptscsih_synchronize_cache(MPT_SCSI_HOST
 	mptscsih_do_cmd(hd, &iocmd);
 }
 
+static ssize_t
+mptscsih_version_fw_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_ADAPTER *ioc = hd->ioc;
+
+	return snprintf(buf, PAGE_SIZE, "%02d.%02d.%02d.%02d\n",
+	    (ioc->facts.FWVersion.Word & 0xFF000000) >> 24,
+	    (ioc->facts.FWVersion.Word & 0x00FF0000) >> 16,
+	    (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
+	    ioc->facts.FWVersion.Word & 0x000000FF);
+}
+static CLASS_DEVICE_ATTR(version_fw, S_IRUGO, mptscsih_version_fw_show, NULL);
+
+static ssize_t
+mptscsih_version_bios_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_ADAPTER *ioc = hd->ioc;
+
+	return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x.%02x\n",
+	    (ioc->biosVersion & 0xFF000000) >> 24,
+	    (ioc->biosVersion & 0x00FF0000) >> 16,
+	    (ioc->biosVersion & 0x0000FF00) >> 8,
+	    ioc->biosVersion & 0x000000FF);
+}
+static CLASS_DEVICE_ATTR(version_bios, S_IRUGO, mptscsih_version_bios_show, NULL);
+
+static ssize_t
+mptscsih_version_driver_show(struct class_device *cdev, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", MPT_LINUX_VERSION_COMMON);
+}
+static CLASS_DEVICE_ATTR(version_driver, S_IRUGO, mptscsih_version_driver_show, NULL);
+
+static ssize_t
+mptscsih_version_mpi_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_ADAPTER *ioc = hd->ioc;
+
+	return snprintf(buf, PAGE_SIZE, "%03x\n", ioc->facts.MsgVersion);
+}
+static CLASS_DEVICE_ATTR(version_mpi, S_IRUGO, mptscsih_version_mpi_show, NULL);
+
+static ssize_t
+mptscsih_version_product_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_ADAPTER *ioc = hd->ioc;
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->prod_name);
+}
+static CLASS_DEVICE_ATTR(version_product, S_IRUGO,
+    mptscsih_version_product_show, NULL);
+
+static ssize_t
+mptscsih_version_nvdata_persistent_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_ADAPTER *ioc = hd->ioc;
+
+	return snprintf(buf, PAGE_SIZE, "%02xh\n", 
+	    ioc->nvdata_version_persistent);
+}
+static CLASS_DEVICE_ATTR(version_nvdata_persistent, S_IRUGO,
+    mptscsih_version_nvdata_persistent_show, NULL);
+
+static ssize_t
+mptscsih_version_nvdata_default_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_ADAPTER *ioc = hd->ioc;
+
+	return snprintf(buf, PAGE_SIZE, "%02xh\n",ioc->nvdata_version_default);
+}
+static CLASS_DEVICE_ATTR(version_nvdata_default, S_IRUGO,
+    mptscsih_version_nvdata_default_show, NULL);
+
+static ssize_t
+mptscsih_board_name_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_ADAPTER *ioc = hd->ioc;
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->board_name);
+}
+static CLASS_DEVICE_ATTR(board_name, S_IRUGO, mptscsih_board_name_show, NULL);
+
+static ssize_t
+mptscsih_board_assembly_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_ADAPTER *ioc = hd->ioc;
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->board_assembly);
+}
+static CLASS_DEVICE_ATTR(board_assembly, S_IRUGO,
+    mptscsih_board_assembly_show, NULL);
+
+static ssize_t
+mptscsih_board_tracer_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_ADAPTER *ioc = hd->ioc;
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->board_tracer);
+}
+static CLASS_DEVICE_ATTR(board_tracer, S_IRUGO,
+    mptscsih_board_tracer_show, NULL);
+
+static ssize_t
+mptscsih_io_delay_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_ADAPTER *ioc = hd->ioc;
+
+	return snprintf(buf, PAGE_SIZE, "%02d\n", ioc->io_missing_delay);
+}
+static CLASS_DEVICE_ATTR(io_delay, S_IRUGO,
+    mptscsih_io_delay_show, NULL);
+
+static ssize_t
+mptscsih_device_delay_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_ADAPTER *ioc = hd->ioc;
+
+	return snprintf(buf, PAGE_SIZE, "%02d\n", ioc->device_missing_delay);
+}
+static CLASS_DEVICE_ATTR(device_delay, S_IRUGO,
+    mptscsih_device_delay_show, NULL);
+
+struct class_device_attribute *mptscsih_host_attrs[] = {
+	&class_device_attr_version_fw,
+	&class_device_attr_version_bios,
+	&class_device_attr_version_driver,
+	&class_device_attr_version_mpi,
+	&class_device_attr_version_product,
+	&class_device_attr_version_nvdata_persistent,
+	&class_device_attr_version_nvdata_default,
+	&class_device_attr_board_name,
+	&class_device_attr_board_assembly,
+	&class_device_attr_board_tracer,
+	&class_device_attr_io_delay,
+	&class_device_attr_device_delay,
+	NULL,
+};
+EXPORT_SYMBOL(mptscsih_host_attrs);
+
 EXPORT_SYMBOL(mptscsih_remove);
 EXPORT_SYMBOL(mptscsih_shutdown);
 #ifdef CONFIG_PM
diff -Naurp b/drivers/message/fusion/mptscsih.h a/drivers/message/fusion/mptscsih.h
--- b/drivers/message/fusion/mptscsih.h	2007-07-02 16:20:46.000000000 +0530
+++ a/drivers/message/fusion/mptscsih.h	2007-07-11 18:48:35.000000000 +0530
@@ -129,3 +129,4 @@ extern void mptscsih_timer_expired(unsig
 extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout);
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
+extern struct class_device_attribute *mptscsih_host_attrs[];
diff -Naurp b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-07-02 16:20:46.000000000 +0530
+++ a/drivers/message/fusion/mptspi.c	2007-07-11 18:48:35.000000000 +0530
@@ -819,6 +819,7 @@ static struct scsi_host_template mptspi_
 	.max_sectors			= 8192,
 	.cmd_per_lun			= 7,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.shost_attrs			= mptscsih_host_attrs,
 };
 
 static int mptspi_write_spi_device_pg1(struct scsi_target *starget,
