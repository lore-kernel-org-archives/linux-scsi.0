From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH] - mptfusion - adding Fibre Channel Transport Layer Support
Date: Thu, 23 Jun 2005 17:18:05 -0600
Message-ID: <200506231718.05290.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61916 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262623AbVFWXQ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2005 19:16:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>

This patch for mpt fusion driver, adding support for FC transport Layer:

Target Attributes
	port_id
	port_name
	node_name

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarN b/drivers/message/fusion/Kconfig a/drivers/message/fusion/Kconfig
--- b/drivers/message/fusion/Kconfig	2005-05-10 15:01:27.000000000 -0600
+++ a/drivers/message/fusion/Kconfig	2005-06-23 17:07:37.000000000 -0600
@@ -23,6 +23,7 @@
 	tristate "Fusion MPT ScsiHost drivers for FC"
 	depends on PCI && SCSI
 	select FUSION
+	select SCSI_FC_ATTRS
 	---help---
 	  SCSI HOST support for a Fiber Channel host adapters.
 
diff -uarN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2005-06-23 16:19:39.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2005-06-23 16:53:51.000000000 -0600
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.03.03"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.03"
+#define MPT_LINUX_VERSION_COMMON	"3.03.04"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.04"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
diff -uarN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2005-06-23 15:09:00.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2005-06-23 17:11:52.000000000 -0600
@@ -61,6 +61,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
 
 #include "mptbase.h"
 #include "mptscsih.h"
@@ -83,6 +85,80 @@
 static int	mptfcTaskCtx = -1;
 static int	mptfcInternalCtx = -1; /* Used only for internal commands */
 
+static struct scsi_transport_template *mptfc_transport_template = NULL;
+
+static void
+mptfc_get_port_id(struct scsi_target *starget)
+{
+	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
+	MPT_SCSI_HOST	*hd;
+	MPT_ADAPTER 	*ioc;
+	FCDevicePage0_t fcDevicePage;
+	int rc;
+
+	fc_starget_port_id(starget) = -1;
+	hd = (MPT_SCSI_HOST *)host->hostdata;
+	if (hd==NULL)
+		return;
+	ioc = hd->ioc;
+	rc = mptscsih_readFCDevicePage0(ioc, starget->channel, starget->id, &fcDevicePage);
+	if (rc > offsetof(FCDevicePage0_t,Protocol))
+		fc_starget_port_id(starget) = le64_to_cpu(fcDevicePage.PortIdentifier);
+}
+
+static void
+mptfc_get_port_name(struct scsi_target *starget)
+{
+	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
+	MPT_SCSI_HOST	*hd;
+	MPT_ADAPTER 	*ioc;
+	FCDevicePage0_t fcDevicePage;
+	int rc;
+
+	fc_starget_port_name(starget) = -1;
+	hd = (MPT_SCSI_HOST *)host->hostdata;
+	if (hd==NULL)
+		return;
+	ioc = hd->ioc;
+	rc = mptscsih_readFCDevicePage0(ioc, starget->channel, starget->id, &fcDevicePage);
+	if (rc > offsetof(FCDevicePage0_t,PortIdentifier)) {
+		memcpy(&fc_starget_port_name(starget),&fcDevicePage.WWPN,
+		    sizeof(fcDevicePage.WWPN));
+		le64_to_cpus(&fc_starget_port_name(starget));
+	}
+}
+
+static void
+mptfc_get_node_name(struct scsi_target *starget)
+{
+	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
+	MPT_SCSI_HOST	*hd;
+	MPT_ADAPTER 	*ioc;
+	FCDevicePage0_t fcDevicePage;
+	int rc;
+
+	fc_starget_node_name(starget) = -1;
+	hd = (MPT_SCSI_HOST *)host->hostdata;
+	if (hd==NULL)
+		return;
+	ioc = hd->ioc;
+	rc = mptscsih_readFCDevicePage0(ioc, starget->channel, starget->id, &fcDevicePage);
+	if (rc > offsetof(FCDevicePage0_t,WWPN)) {
+		memcpy(&fc_starget_node_name(starget),&fcDevicePage.WWNN,
+		    sizeof(fcDevicePage.WWNN));
+		le64_to_cpus(&fc_starget_node_name(starget));
+	}
+}
+
+static struct fc_function_template mptfc_transport_functions = {
+	.get_starget_port_id = mptfc_get_port_id,
+	.show_starget_port_id = 1,
+	.get_starget_port_name = mptfc_get_port_name,
+	.show_starget_port_name = 1,
+	.get_starget_node_name = mptfc_get_node_name,
+	.show_starget_node_name = 1,
+};
+
 static struct scsi_host_template mptfc_driver_template = {
 	.proc_name			= "mptfc",
 	.proc_info			= mptscsih_proc_info,
@@ -220,6 +296,9 @@
 	sh->max_channel = 0;
 	sh->this_id = ioc->pfacts[0].PortSCSIID;
 
+	BUG_ON(mptfc_transport_template == NULL);
+	sh->transportt = mptfc_transport_template;
+
 	/* Required entry.
 	 */
 	sh->unique_id = ioc->id;
@@ -373,6 +452,11 @@
 
 	show_mptmod_ver(my_NAME, my_VERSION);
 
+	mptfc_transport_template =
+	    fc_attach_transport(&mptfc_transport_functions);
+	if (!mptfc_transport_template)
+		return -ENODEV;
+
 	mptfcDoneCtx = mpt_register(mptscsih_io_done, MPTFC_DRIVER);
 	mptfcTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTFC_DRIVER);
 	mptfcInternalCtx = mpt_register(mptscsih_scandv_complete, MPTFC_DRIVER);
@@ -400,7 +484,9 @@
 mptfc_exit(void)
 {
 	pci_unregister_driver(&mptfc_driver);
-	
+
+	fc_release_transport(mptfc_transport_template);
+
 	mpt_reset_deregister(mptfcDoneCtx);
 	dprintk((KERN_INFO MYNAM
 	  ": Deregistered for IOC reset notifications\n"));
diff -uarN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2005-06-23 16:19:26.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2005-06-23 16:55:37.000000000 -0600
@@ -944,6 +944,70 @@
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
+ *	mptscsih_readFCDevicePage0 - returns FC Device Page 0 data
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@bus: bus id
+ *	@targetId: target id
+ *	@fcDevicePage: FC Device Page 0 data
+ *
+ *	Returns count of number bytes copied into @fcDevicePage
+ *
+ */
+
+int
+mptscsih_readFCDevicePage0(MPT_ADAPTER *ioc, u8 bus, u8 targetId, pFCDevicePage0_t fcDevicePage)
+{
+	ConfigPageHeader_t	 hdr;
+	CONFIGPARMS		 cfg;
+	pFCDevicePage0_t	 ppage0_alloc;
+	dma_addr_t		 page0_dma;
+	int			 data_sz;
+	int			 copy_sz=0;
+	int			 rc;
+
+	/* Get FCPort Page 0 header */
+	hdr.PageVersion = 0;
+	hdr.PageLength = 0;
+	hdr.PageNumber = 0;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_FC_DEVICE;
+	cfg.hdr = &hdr;
+	cfg.physAddr = -1;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.dir = 0;
+
+	cfg.pageAddr = (bus << 8) + targetId + MPI_FC_DEVICE_PGAD_FORM_BUS_TID;
+	cfg.timeout = 0;
+
+	if ((rc = mpt_config(ioc, &cfg)) != 0)
+		return 0;
+
+	if (hdr.PageLength == 0)
+		return 0;
+
+	data_sz = hdr.PageLength * 4;
+	rc = -ENOMEM;
+	ppage0_alloc = (pFCDevicePage0_t ) pci_alloc_consistent(ioc->pcidev,
+	    data_sz, &page0_dma);
+	if (ppage0_alloc) {
+		memset((u8 *)ppage0_alloc, 0, data_sz);
+		cfg.physAddr = page0_dma;
+		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+		if ((rc = mpt_config(ioc, &cfg)) == 0) {
+			/* save the data */
+			copy_sz = min_t(int, sizeof(FCDevicePage0_t), data_sz);
+			memcpy(fcDevicePage, ppage0_alloc, copy_sz);
+		}
+
+		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage0_alloc,
+		    page0_dma);
+	}
+
+	return copy_sz;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
  *	mptscsih_remove - Removed scsi devices
  *	@pdev: Pointer to pci_dev structure
  *
@@ -5596,6 +5660,7 @@
 EXPORT_SYMBOL(mptscsih_event_process);
 EXPORT_SYMBOL(mptscsih_ioc_reset);
 EXPORT_SYMBOL(mptscsih_change_queue_depth);
+EXPORT_SYMBOL(mptscsih_readFCDevicePage0);
 EXPORT_SYMBOL(mptscsih_timer_expired);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarN b/drivers/message/fusion/mptscsih.h a/drivers/message/fusion/mptscsih.h
--- b/drivers/message/fusion/mptscsih.h	2005-06-23 14:50:34.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.h	2005-06-23 16:52:46.000000000 -0600
@@ -105,3 +105,4 @@
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 extern void mptscsih_timer_expired(unsigned long data);
+extern int mptscsih_readFCDevicePage0(MPT_ADAPTER *ioc, u8 bus, u8 targetId, pFCDevicePage0_t fcDevicePage);


