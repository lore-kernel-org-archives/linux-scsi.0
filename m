From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 3/6] mpt fusion - set fibre channel fw target missing timers
 to one second
Date: Thu, 18 May 2006 15:00:03 -0500
Message-ID: <446CD243.5050006@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020405000701040608020407"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:42681 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751393AbWERUAE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 16:00:04 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k4IMHp5w010259
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 15:17:51 -0700
Received: from [128.162.233.78] (hd28.americas.sgi.com [128.162.233.78])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k4IK034126268083
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 13:00:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020405000701040608020407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The fibre channel firmware provides a timer which is similar in purpose
to the fibre channel transport's device loss timer.  The effect of this
timer is to extend the total time that a target will be missing beyond
the value associated with the transport's timer.  This patch changes
the firmware timer to a default of one second which significantly reduces
the lag between when a target goes missing and the notification of the
fibre channel transport.

Signed-off-by: Michael Reed <mdr@sgi.com>




--------------020405000701040608020407
Content-Type: text/x-patch;
 name="03-mptfc_change_fw_timers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03-mptfc_change_fw_timers.patch"

The fibre channel firmware provides a timer which is similar in purpose
to the fibre channel transport's device loss timer.  The effect of this
timer is to extend the total time that a target will be missing beyond
the value associated with the transport's timer.  This patch changes
the firmware timer to a default of one second which significantly reduces
the lag between when a target goes missing and the notification of the
fibre channel transport.

Signed-off-by: Michael Reed <mdr@sgi.com>

--- rc3c/drivers/message/fusion/mptbase.h	2006-05-08 14:41:20.330842216 -0500
+++ rc3/drivers/message/fusion/mptbase.h	2006-05-08 14:36:43.340659662 -0500
@@ -487,6 +487,15 @@
 	int		 isRaid;		/* bit field, 1 if RAID */
 }RaidCfgData;
 
+typedef struct _FcCfgData {
+	/* will ultimately hold fc_port_page0 also */
+	struct {
+		FCPortPage1_t	*data;
+		dma_addr_t	 dma;
+		int		 pg_sz;
+	}			 fc_port_page1[2];
+} FcCfgData;
+
 #define MPT_RPORT_INFO_FLAGS_REGISTERED	0x01	/* rport registered */
 #define MPT_RPORT_INFO_FLAGS_MISSING	0x02	/* missing from DevPage0 scan */
 
@@ -565,6 +574,7 @@
 	SpiCfgData		spi_data;	/* Scsi config. data */
 	RaidCfgData		raid_data;	/* Raid config. data */
 	SasCfgData		sas_data;	/* Sas config. data */
+	FcCfgData		fc_data;	/* Fc config. data */
 	MPT_IOCTL		*ioctl;		/* ioctl data pointer */
 	struct proc_dir_entry	*ioc_dentry;
 	struct _MPT_ADAPTER	*alt_ioc;	/* ptr to 929 bound adapter port */
--- rc3c/drivers/message/fusion/mptfc.c	2006-05-08 14:41:20.330842216 -0500
+++ rc3/drivers/message/fusion/mptfc.c	2006-05-08 14:43:57.732490957 -0500
@@ -169,13 +169,6 @@
 
 };
 
-/* FIXME! values controlling firmware RESCAN event
- * need to be set low to allow dev_loss_tmo to
- * work as expected.  Currently, firmware doesn't
- * notify driver of RESCAN event until some number
- * of seconds elapse.  This value can be set via
- * lsiutil.
- */
 static void
 mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 {
@@ -700,6 +693,153 @@
 	return rc;
 }
 
+static int
+mptfc_WriteFcPortPage1(MPT_ADAPTER *ioc, int portnum)
+{
+	ConfigPageHeader_t	 hdr;
+	CONFIGPARMS		 cfg;
+	int			 rc;
+
+	if (portnum > 1)
+		return -EINVAL;
+
+	if (!(ioc->fc_data.fc_port_page1[portnum].data))
+		return -EINVAL;
+
+	/* get fcport page 1 header */
+	hdr.PageVersion = 0;
+	hdr.PageLength = 0;
+	hdr.PageNumber = 1;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_FC_PORT;
+	cfg.cfghdr.hdr = &hdr;
+	cfg.physAddr = -1;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.dir = 0;
+	cfg.pageAddr = portnum;
+	cfg.timeout = 0;
+
+	if ((rc = mpt_config(ioc, &cfg)) != 0)
+		return rc;
+
+	if (hdr.PageLength == 0)
+		return -ENODEV;
+
+	if (hdr.PageLength*4 != ioc->fc_data.fc_port_page1[portnum].pg_sz)
+		return -EINVAL;
+
+	cfg.physAddr = ioc->fc_data.fc_port_page1[portnum].dma;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
+	cfg.dir = 1;
+
+	rc = mpt_config(ioc, &cfg);
+
+	return rc;
+}
+
+static int
+mptfc_GetFcPortPage1(MPT_ADAPTER *ioc, int portnum)
+{
+	ConfigPageHeader_t	 hdr;
+	CONFIGPARMS		 cfg;
+	FCPortPage1_t		*page1_alloc;
+	dma_addr_t		 page1_dma;
+	int			 data_sz;
+	int			 rc;
+
+	if (portnum > 1)
+		return -EINVAL;
+
+	/* get fcport page 1 header */
+	hdr.PageVersion = 0;
+	hdr.PageLength = 0;
+	hdr.PageNumber = 1;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_FC_PORT;
+	cfg.cfghdr.hdr = &hdr;
+	cfg.physAddr = -1;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.dir = 0;
+	cfg.pageAddr = portnum;
+	cfg.timeout = 0;
+
+	if ((rc = mpt_config(ioc, &cfg)) != 0)
+		return rc;
+
+	if (hdr.PageLength == 0)
+		return -ENODEV;
+
+start_over:
+
+	if (ioc->fc_data.fc_port_page1[portnum].data == NULL) {
+		data_sz = hdr.PageLength * 4;
+		if (data_sz < sizeof(FCPortPage1_t))
+			data_sz = sizeof(FCPortPage1_t);
+
+		page1_alloc = (FCPortPage1_t *) pci_alloc_consistent(ioc->pcidev,
+						data_sz,
+						&page1_dma);
+		if (!page1_alloc)
+			return -ENOMEM;
+	}
+	else {
+		page1_alloc = ioc->fc_data.fc_port_page1[portnum].data;
+		page1_dma = ioc->fc_data.fc_port_page1[portnum].dma;
+		data_sz = ioc->fc_data.fc_port_page1[portnum].pg_sz;
+		if (hdr.PageLength * 4 > data_sz) {
+			ioc->fc_data.fc_port_page1[portnum].data = NULL;
+			pci_free_consistent(ioc->pcidev, data_sz, (u8 *)
+				page1_alloc, page1_dma);
+			goto start_over;
+		}
+	}
+
+	memset(page1_alloc,0,data_sz);
+
+	cfg.physAddr = page1_dma;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+	if ((rc = mpt_config(ioc, &cfg)) == 0) {
+		ioc->fc_data.fc_port_page1[portnum].data = page1_alloc;
+		ioc->fc_data.fc_port_page1[portnum].pg_sz = data_sz;
+		ioc->fc_data.fc_port_page1[portnum].dma = page1_dma;
+	}
+	else {
+		ioc->fc_data.fc_port_page1[portnum].data = NULL;
+		pci_free_consistent(ioc->pcidev, data_sz, (u8 *)
+			page1_alloc, page1_dma);
+	}
+
+	return rc;
+}
+
+static void
+mptfc_SetFcPortPage1_defaults(MPT_ADAPTER *ioc)
+{
+	int		ii;
+	FCPortPage1_t	*pp1;
+
+	#define MPTFC_FW_DEVICE_TIMEOUT	(1)
+	#define MPTFC_FW_IO_PEND_TIMEOUT (1)
+	#define ON_FLAGS  (MPI_FCPORTPAGE1_FLAGS_IMMEDIATE_ERROR_REPLY)
+	#define OFF_FLAGS (MPI_FCPORTPAGE1_FLAGS_VERBOSE_RESCAN_EVENTS)
+
+	for (ii=0; ii<ioc->facts.NumberOfPorts; ii++) {
+		if (mptfc_GetFcPortPage1(ioc, ii) != 0)
+			continue;
+		pp1 = ioc->fc_data.fc_port_page1[ii].data;
+		if ((pp1->InitiatorDeviceTimeout == MPTFC_FW_DEVICE_TIMEOUT)
+		 && (pp1->InitiatorIoPendTimeout == MPTFC_FW_IO_PEND_TIMEOUT)
+		 && ((pp1->Flags & ON_FLAGS) == ON_FLAGS)
+		 && ((pp1->Flags & OFF_FLAGS) == 0))
+			continue;
+		pp1->InitiatorDeviceTimeout = MPTFC_FW_DEVICE_TIMEOUT;
+		pp1->InitiatorIoPendTimeout = MPTFC_FW_IO_PEND_TIMEOUT;
+		pp1->Flags &= ~OFF_FLAGS;
+		pp1->Flags |= ON_FLAGS;
+		mptfc_WriteFcPortPage1(ioc, ii);
+	}
+}
+
+
 static void
 mptfc_init_host_attr(MPT_ADAPTER *ioc,int portnum)
 {
@@ -1019,6 +1159,7 @@
 	for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
 		(void) mptfc_GetFcPortPage0(ioc, ii);
 	}
+	mptfc_SetFcPortPage1_defaults(ioc);
 
 	/*
 	 * scan for rports -
@@ -1105,6 +1246,7 @@
 	}
 
 	else {	/* MPT_IOC_POST_RESET */
+		mptfc_SetFcPortPage1_defaults(ioc);
 		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
 		if (ioc->fc_rescan_work_q) {
 			if (ioc->fc_rescan_work_count++ == 0) {
@@ -1131,8 +1273,8 @@
 
 	show_mptmod_ver(my_NAME, my_VERSION);
 
-	/* sanity check module parameter */
-	if (mptfc_dev_loss_tmo == 0)
+	/* sanity check module parameters */
+	if (mptfc_dev_loss_tmo <= 0)
 		mptfc_dev_loss_tmo = MPTFC_DEV_LOSS_TMO;
 
 	mptfc_transport_template =
@@ -1175,6 +1317,7 @@
 	struct mptfc_rport_info	*p, *n;
 	struct workqueue_struct *work_q;
 	unsigned long		flags;
+	int			ii;
 
 	/* destroy workqueue */
 	if ((work_q=ioc->fc_rescan_work_q)) {
@@ -1192,6 +1335,16 @@
 		kfree(p);
 	}
 
+	for (ii=0; ii<ioc->facts.NumberOfPorts; ii++) {
+		if (ioc->fc_data.fc_port_page1[ii].data) {
+			pci_free_consistent(ioc->pcidev,
+				ioc->fc_data.fc_port_page1[ii].pg_sz,
+				(u8 *) ioc->fc_data.fc_port_page1[ii].data,
+				ioc->fc_data.fc_port_page1[ii].dma);
+			ioc->fc_data.fc_port_page1[ii].data = NULL;
+		}
+	}
+
 	mptscsih_remove(pdev);
 }
 

--------------020405000701040608020407--
