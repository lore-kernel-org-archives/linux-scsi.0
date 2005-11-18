From: Michael Reed <mdr@hd29.engr.sgi.com>
Subject: [RFC] fc transport attributes for mpt fusion driver
Date: Fri, 18 Nov 2005 14:33:04 -0800 (PST)
Message-ID: <200511182233.OAA27309@hd29.engr.sgi.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:22991 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S1751073AbVKRWdG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 17:33:06 -0500
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx3.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id jAINT1vr023627
	for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2005 15:29:01 -0800
Received: from hd29.engr.sgi.com (hd29.engr.sgi.com [163.154.11.180])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id jAIMX4ws27946572
	for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2005 14:33:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, gwh@hd29.engr.sgi.com, jeremy@hd29.engr.sgi.com, mdr@hd29.engr.sgi.com

Hello,

I've been working on adding fc transport attributes to the mpt fusion
fibre channel driver.  This code is based on 2.6.15-rc1-git6 with the
most recent 8 patches posted by Eric Moore.  It's in working condition.
(There is an error recovery panic which appears to also be present
in the base code.  Eric's been notified.)

I would very much appreciate comments.

Thanks,
 Mike Reed
 SGI



diff -ru em/drivers/message/fusion/mptbase.c mdr/drivers/message/fusion/mptbase.c
--- em/drivers/message/fusion/mptbase.c	2005-11-18 11:54:02.000000000 -0600
+++ mdr/drivers/message/fusion/mptbase.c	2005-11-18 15:55:10.361190101 -0600
@@ -148,7 +148,6 @@
 static int	WaitForDoorbellInt(MPT_ADAPTER *ioc, int howlong, int sleepFlag);
 static int	WaitForDoorbellReply(MPT_ADAPTER *ioc, int howlong, int sleepFlag);
 static int	GetLanConfigPages(MPT_ADAPTER *ioc);
-static int	GetFcPortPage0(MPT_ADAPTER *ioc, int portnum);
 static int	GetIoUnitPage2(MPT_ADAPTER *ioc);
 int		mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
 static int	mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum);
@@ -1250,6 +1249,8 @@
 	ioc->pcidev = pdev;
 	ioc->diagPending = 0;
 	spin_lock_init(&ioc->diagLock);
+	spin_lock_init(&ioc->work_lock);
+	spin_lock_init(&ioc->fc_rport_lock);
 	spin_lock_init(&ioc->initializing_hba_lock);
 
 	/* Initialize the event logging.
@@ -1273,6 +1274,10 @@
 	 */
 	INIT_LIST_HEAD(&ioc->configQ);
 
+	/* Initialize the fc rport list head.
+	 */
+	INIT_LIST_HEAD(&ioc->l.fc_rports);
+
 	/* Find lookup slot. */
 	INIT_LIST_HEAD(&ioc->list);
 	ioc->id = mpt_ids++;
@@ -1885,7 +1890,7 @@
 			 *  (FCPortPage0_t stuff)
 			 */
 			for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
-				(void) GetFcPortPage0(ioc, ii);
+				(void) mptbase_GetFcPortPage0(ioc, ii);
 			}
 
 			if ((ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN) &&
@@ -4204,7 +4209,7 @@
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
- *	GetFcPortPage0 - Fetch FCPort config Page0.
+ *	mptbase_GetFcPortPage0 - Fetch FCPort config Page0.
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@portnum: IOC Port number
  *
@@ -4214,8 +4219,8 @@
  *		-EAGAIN if no msg frames currently available
  *		-EFAULT for non-successful reply or no reply (timeout)
  */
-static int
-GetFcPortPage0(MPT_ADAPTER *ioc, int portnum)
+int
+mptbase_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum)
 {
 	ConfigPageHeader_t	 hdr;
 	CONFIGPARMS		 cfg;
@@ -4225,6 +4230,8 @@
 	int			 data_sz;
 	int			 copy_sz;
 	int			 rc;
+	int			 count=2500;
+
 
 	/* Get FCPort Page 0 header */
 	hdr.PageVersion = 0;
@@ -4248,6 +4255,8 @@
 	rc = -ENOMEM;
 	ppage0_alloc = (FCPortPage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
 	if (ppage0_alloc) {
+
+ try_again:
 		memset((u8 *)ppage0_alloc, 0, data_sz);
 		cfg.physAddr = page0_dma;
 		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
@@ -4279,6 +4288,15 @@
 			pp0dest->DiscoveredPortsCount = le32_to_cpu(pp0dest->DiscoveredPortsCount);
 			pp0dest->MaxInitiators = le32_to_cpu(pp0dest->MaxInitiators);
 
+			if ((pp0dest->PortState != MPI_FCPORTPAGE0_PORTSTATE_ONLINE) ||
+					((pp0dest->Flags & MPI_FCPORTPAGE0_FLAGS_ATTACH_TYPE_MASK) ==
+					MPI_FCPORTPAGE0_FLAGS_ATTACH_NO_INIT)) {
+				if (count > 0) {
+					count --;
+					msleep_interruptible(1);
+					goto try_again;
+				}
+			}
 		}
 
 		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage0_alloc, page0_dma);
@@ -6361,6 +6379,7 @@
 EXPORT_SYMBOL(mpt_free_fw_memory);
 EXPORT_SYMBOL(mptbase_sas_persist_operation);
 EXPORT_SYMBOL(mpt_alt_ioc_wait);
+EXPORT_SYMBOL(mptbase_GetFcPortPage0);
 
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -ru em/drivers/message/fusion/mptbase.h mdr/drivers/message/fusion/mptbase.h
--- em/drivers/message/fusion/mptbase.h	2005-11-18 11:53:57.000000000 -0600
+++ mdr/drivers/message/fusion/mptbase.h	2005-11-18 12:16:53.000000000 -0600
@@ -499,6 +499,24 @@
 	int		 isRaid;		/* bit field, 1 if RAID */
 }RaidCfgData;
 
+#define MPT_RPORT_INFO_FLAGS_REGISTERED		0x01	/* rport registered */
+#define	MPT_RPORT_INFO_FLAGS_BLOCKED		0x02	/* rport blocked */
+#define	MPT_RPORT_INFO_FLAGS_MISSING		0x04	/* missing from DevPage0 scan */
+#define MPT_RPORT_INFO_FLAGS_MAPPED_VDEV	0x08	/* target mapped in vdev */
+
+/*
+ * data allocated for each fc rport device
+ */
+struct mptfc_rport_info
+{
+	struct list_head list;
+	struct fc_rport *rport;
+	VirtDevice	*vdev;
+	FCDevicePage0_t pg0;
+	u8		flags;
+	u8		debug;
+};
+
 /*
  *  Adapter Structure - pci_dev specific. Maximum: MPT_MAX_ADAPTERS
  */
@@ -611,7 +629,18 @@
 	int 	 		 initializing_hba_lock_flag;
 	struct list_head	 list;
 	struct net_device	*netdev;
+
+	union {
 	struct list_head	 sas_topology;
+	struct list_head	 fc_rports;	/* list of wwpn / sdev target / rport ptr */
+	} l;
+
+	spinlock_t		 fc_rport_lock;	/* for all accesses of list and ri flags */
+
+	spinlock_t		 work_lock;
+	int			 work_count;
+	struct work_struct	 work_task;	/* for use by personality, i.e., fc, sas, spi, lan */
+
 	MPT_SAS_MGMT		 sas_mgmt;
 } MPT_ADAPTER;
 
@@ -999,6 +1028,7 @@
 extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);
 extern int	 mpt_read_ioc_pg_3(MPT_ADAPTER *ioc);
 extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
+extern int	 mptbase_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum);
 extern int	 mpt_alt_ioc_wait(MPT_ADAPTER *ioc);
 
 /*
diff -ru em/drivers/message/fusion/mptfc.c mdr/drivers/message/fusion/mptfc.c
--- em/drivers/message/fusion/mptfc.c	2005-11-18 11:53:52.000000000 -0600
+++ mdr/drivers/message/fusion/mptfc.c	2005-11-18 15:57:24.958491843 -0600
@@ -55,16 +55,19 @@
 #include <linux/reboot.h>	/* notifier code */
 #include <linux/sched.h>
 #include <linux/workqueue.h>
+#include <linux/sort.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport_fc.h>
 
 #include "mptbase.h"
 #include "mptscsih.h"
 
+#define MPT_DEBUG 1
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #define my_NAME		"Fusion MPT FC Host driver"
 #define my_VERSION	MPT_LINUX_VERSION_COMMON
@@ -79,10 +82,18 @@
 module_param(mpt_pq_filter, int, 0);
 MODULE_PARM_DESC(mpt_pq_filter, " Enable peripheral qualifier filter: enable=1  (default=0)");
 
+static int mptfc_dev_loss_tmo = 60;	/* reasonable default */
+module_param(mptfc_dev_loss_tmo, int, 0);
+MODULE_PARM_DESC(mptfc_dev_loss_tmo, " Time (in seconds) the FC transport waits for a target"
+				     " to return following a device loss event.  Default=60.");
+
 static int	mptfcDoneCtx = -1;
 static int	mptfcTaskCtx = -1;
 static int	mptfcInternalCtx = -1; /* Used only for internal commands */
 
+int mptfc_slave_alloc(struct scsi_device *device);
+static void __devexit mptfc_remove(struct pci_dev *pdev);
+
 static struct scsi_host_template mptfc_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptfc",
@@ -91,7 +102,7 @@
 	.info				= mptscsih_info,
 	.queuecommand			= mptscsih_qcmd,
 	.target_alloc			= mptscsih_target_alloc,
-	.slave_alloc			= mptscsih_slave_alloc,
+	.slave_alloc			= mptfc_slave_alloc,
 	.slave_configure		= mptscsih_slave_configure,
 	.target_destroy			= mptscsih_target_destroy,
 	.slave_destroy			= mptscsih_slave_destroy,
@@ -132,15 +143,419 @@
 };
 MODULE_DEVICE_TABLE(pci, mptfc_pci_table);
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+static struct scsi_transport_template *mptfc_transport_template = NULL;
+
+struct fc_function_template mptfc_transport_functions = {
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.show_host_supported_classes = 1,
+
+	.get_host_port_id = NULL,
+	.show_host_port_id = 1,
+
+	.dd_fcrport_size = 0,
+	.show_rport_supported_classes = 1,
+
+	.get_starget_node_name = NULL,
+	.show_starget_node_name = 1,
+	.get_starget_port_name = NULL,
+	.show_starget_port_name = 1,
+	.get_starget_port_id  = NULL,
+	.show_starget_port_id = 1,
+
+	.get_rport_dev_loss_tmo = NULL,
+	.set_rport_dev_loss_tmo = NULL,
+	.show_rport_dev_loss_tmo = 0,
+
+};
+
+static int
+mptfc_FcDevPage0_cmp_func(const void *a, const void *b)
+{
+	FCDevicePage0_t **aa=(FCDevicePage0_t **)a;
+	FCDevicePage0_t **bb=(FCDevicePage0_t **)b;
+
+	if ((*aa)->CurrentBus == (*bb)->CurrentBus) {
+		if ((*aa)->CurrentTargetID == (*bb)->CurrentTargetID)
+			return 0;
+		if ((*aa)->CurrentTargetID < (*bb)->CurrentTargetID)
+			return -1;
+		return 1;
+	}
+	if ((*aa)->CurrentBus < (*bb)->CurrentBus)
+		return -1;
+	return 1;
+}
+
+static int
+mptfc_GetFcDevPage0(MPT_ADAPTER *ioc, int ioc_port, 
+	void(*func)(MPT_ADAPTER *ioc,int channel, FCDevicePage0_t *arg))
+{
+	ConfigPageHeader_t	 hdr;
+	CONFIGPARMS		 cfg;
+	FCDevicePage0_t		*ppage0_alloc, *fc;
+	dma_addr_t		 page0_dma;
+	int			 data_sz;
+	int			 ii;
+
+	FCDevicePage0_t		*p0_array=NULL, *p_p0;
+	FCDevicePage0_t		**pp0_array=NULL, **p_pp0;
+
+	int			 rc = -ENOMEM;
+	U32			 port_id = 0xffffff;
+	int			 num_targ = 0;
+	int			 max_bus = ioc->facts.MaxBuses;
+	int			 max_targ = ioc->facts.MaxDevices;
+
+	if (max_bus == 0 || max_targ == 0)
+		goto out;
+
+	data_sz = sizeof(FCDevicePage0_t) * max_bus * max_targ;
+	p_p0 = p0_array =  kmalloc(data_sz,GFP_KERNEL);
+	if (!p0_array)
+		goto out;
+	memset((u8 *)p0_array, 0, data_sz);
+
+	data_sz = sizeof(FCDevicePage0_t *) * max_bus * max_targ;
+	p_pp0 = pp0_array = kmalloc(data_sz,GFP_KERNEL);
+	if (!pp0_array)
+		goto out;
+	memset((u8 *)pp0_array, 0, data_sz);
+
+	do {
+		/* Get FC Device Page 0 header */
+		hdr.PageVersion = 0;
+		hdr.PageLength = 0;
+		hdr.PageNumber = 0;
+		hdr.PageType = MPI_CONFIG_PAGETYPE_FC_DEVICE;
+		cfg.cfghdr.hdr = &hdr;
+		cfg.physAddr = -1;
+		cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+		cfg.dir = 0;
+		cfg.pageAddr = port_id;
+		cfg.timeout = 0;
+
+		if ((rc = mpt_config(ioc, &cfg)) != 0)
+			break;
+
+		if (hdr.PageLength <= 0)
+			break;
+		else {
+			data_sz = hdr.PageLength * 4;
+			ppage0_alloc = (FCDevicePage0_t *) 
+					pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
+			rc = -ENOMEM;
+			if (ppage0_alloc) {
+				memset((u8 *)ppage0_alloc, 0, data_sz);
+				cfg.physAddr = page0_dma;
+				cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+				if ((rc = mpt_config(ioc, &cfg)) == 0) {
+					port_id = ppage0_alloc->PortIdentifier;
+					#ifdef MPT_DEBUG
+					printk ("adding %x\n",port_id);
+					#endif
+					num_targ++;
+					*p_p0 = *ppage0_alloc;	/* save data */
+					*p_pp0++ = p_p0++;	/* save addr */
+				}
+				pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage0_alloc, page0_dma);
+				if (rc != 0)
+					break;
+			}
+			else break;
+		}
+	} while (port_id <= 0xffff00);
+
+	if (num_targ) {
+		#ifdef MPT_DEBUG
+		printk ("%d targets\n",num_targ);
+		#endif
+		/* sort array */
+		if (num_targ > 1)
+			sort (pp0_array,num_targ,sizeof(FCDevicePage0_t *), 
+				mptfc_FcDevPage0_cmp_func, NULL);
+		/* call caller's func for each targ */
+		for (ii=0; ii<num_targ;  ii++) {
+			fc = *(pp0_array+ii);
+			func(ioc,ioc_port,fc);
+		}
+	}
+
+ out:
+	if (pp0_array)
+		kfree(pp0_array);
+	if (p0_array)
+		kfree(p0_array);
+	return rc;
+}
+
+static int
+mptfc_generate_rport_identifiers(FCDevicePage0_t *pg0, struct fc_rport_identifiers *rid)
+{
+	/* not currently usable */
+	if (pg0->Flags & (MPI_FC_DEVICE_PAGE0_FLAGS_PLOGI_INVALID |
+			  MPI_FC_DEVICE_PAGE0_FLAGS_PRLI_INVALID))
+		return -1;
+
+	if (!(pg0->Flags & MPI_FC_DEVICE_PAGE0_FLAGS_TARGETID_BUS_VALID))
+		return -1;
+
+	if (!(pg0->Protocol & MPI_FC_DEVICE_PAGE0_PROT_FCP_TARGET))
+		return -1;
+
+	rid->node_name = ((u64)pg0->WWNN.High) << 32 | (u64)pg0->WWNN.Low;
+	rid->port_name = ((u64)pg0->WWPN.High) << 32 | (u64)pg0->WWPN.Low;
+	rid->port_id =   pg0->PortIdentifier;
+	rid->roles = FC_RPORT_ROLE_UNKNOWN;
+	rid->roles |= FC_RPORT_ROLE_FCP_TARGET;
+	if (pg0->Protocol & MPI_FC_DEVICE_PAGE0_PROT_FCP_INITIATOR)
+		rid->roles |= FC_RPORT_ROLE_FCP_INITIATOR;
+
+	return 0;
+}
+
+static void
+mptfc_register_dev(MPT_ADAPTER *ioc, int channel, FCDevicePage0_t *pg0)
+{
+	struct fc_rport_identifiers rport_ids;
+	struct fc_rport		*rport;
+	struct mptfc_rport_info	*ri;
+	int			match=0;
+	u64			port_name;
+	unsigned long		flags;
+
+	if (mptfc_generate_rport_identifiers(pg0,&rport_ids) < 0)
+		return;
+
+	/* scan list looking for a match */
+	spin_lock_irqsave(&ioc->fc_rport_lock,flags);
+	list_for_each_entry(ri, &ioc->l.fc_rports, list) {
+		port_name = (u64)ri->pg0.WWPN.High << 32 | (u64)ri->pg0.WWPN.Low;
+		if (port_name == rport_ids.port_name) {	/* match */
+			list_move_tail(&ri->list,&ioc->l.fc_rports);
+			match = 1;
+			break;
+		}
+	}
+	if (!match) {	/* allocate one */
+		spin_unlock_irqrestore(&ioc->fc_rport_lock,flags);
+		ri = kmalloc(sizeof(struct mptfc_rport_info), GFP_KERNEL);
+		if (!ri)
+			return;
+		memset(ri, 0, sizeof(struct mptfc_rport_info));
+		spin_lock_irqsave(&ioc->fc_rport_lock,flags);
+		list_add_tail(&ri->list,&ioc->l.fc_rports);
+	}
+
+	ri->pg0 = *pg0;	/* add/update pg0 data */
+	ri->flags &= ~MPT_RPORT_INFO_FLAGS_MISSING;
+
+	if (!(ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED)) {
+		spin_unlock_irqrestore(&ioc->fc_rport_lock,flags);
+		rport = fc_remote_port_add(ioc->sh,channel,&rport_ids);
+		spin_lock_irqsave(&ioc->fc_rport_lock,flags);
+		if (rport) {
+			if (ri->rport != rport) {
+				ri->flags &= ~MPT_RPORT_INFO_FLAGS_MAPPED_VDEV;
+				ri->vdev = NULL;
+				ri->rport = rport;
+			}
+			rport->dd_data = (void *)ri;
+			rport->dev_loss_tmo = mptfc_dev_loss_tmo;
+			ri->flags |= MPT_RPORT_INFO_FLAGS_REGISTERED;
+			if (ri->flags & MPT_RPORT_INFO_FLAGS_MAPPED_VDEV) {
+				ri->vdev->target_id = ri->pg0.CurrentTargetID;
+				ri->vdev->bus_id = ri->pg0.CurrentBus;
+				ri->vdev->vtarget->target_id = ri->vdev->target_id;
+				ri->vdev->vtarget->bus_id = ri->vdev->bus_id;
+			}
+			#ifdef MPT_DEBUG
+			printk ("mptfc_reg_dev.%d: %x, %llx / %llx, debug %d, tid %d, rport tid %d, tmo %d\n",
+				ioc->sh->host_no,
+				pg0->PortIdentifier,
+				pg0->WWNN,
+				pg0->WWPN,
+ri->debug,
+				pg0->CurrentTargetID,
+				ri->rport->scsi_target_id,
+				ri->rport->dev_loss_tmo);
+			#endif
+		}
+		else {
+			list_del(&ri->list);
+			kfree(ri);
+			ri = NULL;
+		}
+	}
+	spin_unlock_irqrestore(&ioc->fc_rport_lock,flags);
+
+}
+
 /*
- *	mptfc_probe - Installs scsi devices per bus.
- *	@pdev: Pointer to pci_dev structure
- *
- *	Returns 0 for success, non-zero for failure.
- *
+ *	OS entry point to allow host driver to alloc memory
+ *	for each scsi device. Called once per device the bus scan.
+ *	Return non-zero if allocation fails.
+ *	Init memory once per id (not LUN).
  */
+int
+mptfc_slave_alloc(struct scsi_device *sdev)
+{
+	struct Scsi_Host	*host;
+	MPT_SCSI_HOST		*hd;
+	VirtTarget		*vtarget;
+	VirtDevice		*vdev;
+	struct scsi_target	*starget;
+	uint			target;
+	struct fc_rport		*rport;
+	struct mptfc_rport_info *ri;
+	unsigned long		flags;
+
+	if (!sdev
+	 || !(host=sdev->host)
+	 || !(hd=(MPT_SCSI_HOST *)host->hostdata)
+	 || !(hd->ioc)
+	) {
+
+		return -ENODEV;
+	}
+
+	vdev = kmalloc(sizeof(VirtDevice), GFP_KERNEL);
+	if (!vdev) {
+		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
+				hd->ioc->name, sizeof(VirtDevice));
+		return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&hd->ioc->fc_rport_lock,flags);
+
+	if (!(rport=starget_to_rport(scsi_target(sdev)))
+	 || !(ri=(struct mptfc_rport_info*)rport->dd_data)) {
+		spin_unlock_irqrestore(&hd->ioc->fc_rport_lock,flags);
+		kfree(vdev);
+		return -ENODEV;
+	}
+
+	memset(vdev, 0, sizeof(VirtDevice));
+	sdev->hostdata = vdev;
+	starget = scsi_target(sdev);
+	vtarget = starget->hostdata;
+	if (vtarget->num_luns == 0) {
+		vtarget->tflags = MPT_TARGET_FLAGS_Q_YES | MPT_TARGET_FLAGS_VALID_INQUIRY;
+		hd->Targets[sdev->id] = vtarget;
+	}
+
+	vdev->vtarget = vtarget;
+	vdev->ioc_id = hd->ioc->id;
+	vdev->lun = sdev->lun;
+	vdev->target_id = ri->pg0.CurrentTargetID;
+	vdev->bus_id = ri->pg0.CurrentBus;
+
+	vtarget->target_id = vdev->target_id;
+	vtarget->bus_id = vdev->bus_id;
+
+	ri->flags |= MPT_RPORT_INFO_FLAGS_MAPPED_VDEV;
+	ri->vdev = vdev;
+
+	spin_unlock_irqrestore(&hd->ioc->fc_rport_lock,flags);
+
+	vtarget->num_luns++;
+
+#ifdef MPT_DEBUG
+	printk ("mptfc_slv_alloc.%d: num_luns %d, sdev.id %d, CurrentTargetID %d, %x %llx %llx\n",host->host_no,
+		vtarget->num_luns,
+		sdev->id, ri->pg0.CurrentTargetID,
+		ri->pg0.PortIdentifier,ri->pg0.WWPN,ri->pg0.WWNN);
+#endif
+
+	return 0;
+}
+
+static void
+mptfc_init_host_attr(MPT_ADAPTER *ioc,int portnum)
+{
+	unsigned class=0, cos=0;
+
+	/* don't know what to do as only one scsi (fc) host was allocated */
+	if (portnum != 0)
+		return;
+
+	class = ioc->fc_port_page0[portnum].SupportedServiceClass;
+	if (class & MPI_FCPORTPAGE0_SUPPORT_CLASS_1)
+		cos |= FC_COS_CLASS1;
+	if (class & MPI_FCPORTPAGE0_SUPPORT_CLASS_2)
+		cos |= FC_COS_CLASS2;
+	if (class & MPI_FCPORTPAGE0_SUPPORT_CLASS_3)
+		cos |= FC_COS_CLASS3;
+
+	fc_host_node_name(ioc->sh) = (u64)ioc->fc_port_page0[portnum].WWNN.High << 32
+				    | (u64)ioc->fc_port_page0[portnum].WWNN.Low;
+
+	fc_host_port_name(ioc->sh) = (u64)ioc->fc_port_page0[portnum].WWPN.High << 32
+				    | (u64)ioc->fc_port_page0[portnum].WWPN.Low;
+
+	fc_host_port_id(ioc->sh) = ioc->fc_port_page0[portnum].PortIdentifier;
+
+	fc_host_supported_classes(ioc->sh) = cos;
+
+	fc_host_tgtid_bind_type(ioc->sh) = FC_TGTID_BIND_BY_WWPN;
+}
+
+static void
+mptfc_rescan_devices(void *arg)
+{
+	MPT_ADAPTER		*ioc = (MPT_ADAPTER *)arg;
+	int			ii;
+	int			work_to_do;
+	unsigned long		flags;
+	struct mptfc_rport_info *ri;
+
+	do {
+		/* start by tagging all ports as missing */
+		spin_lock_irqsave(&ioc->fc_rport_lock,flags);
+		list_for_each_entry(ri, &ioc->l.fc_rports, list) {
+			if (ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED) {
+				ri->flags |= MPT_RPORT_INFO_FLAGS_MISSING;
+			}
+		}
+		spin_unlock_irqrestore(&ioc->fc_rport_lock,flags);
+
+		/* now rescan devices known to adapter, will reregister existing rports */
+		for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
+			(void) mptbase_GetFcPortPage0(ioc, ii);
+			mptfc_init_host_attr(ioc,ii);	/* refresh */
+			mptfc_GetFcDevPage0(ioc,ii,mptfc_register_dev);
+		}
+
+		/* delete devices still missing */
+		spin_lock_irqsave(&ioc->fc_rport_lock,flags);
+		list_for_each_entry(ri, &ioc->l.fc_rports, list) {
+			/* if newly missing, delete it */
+			if ((ri->flags & (MPT_RPORT_INFO_FLAGS_REGISTERED |
+					  MPT_RPORT_INFO_FLAGS_MISSING))
+			  == (MPT_RPORT_INFO_FLAGS_REGISTERED | MPT_RPORT_INFO_FLAGS_MISSING)) {
+				ri->flags &= ~(MPT_RPORT_INFO_FLAGS_REGISTERED|MPT_RPORT_INFO_FLAGS_MISSING);
+				fc_remote_port_delete(ri->rport);
+				/* remote port not deleted 'cause binding is by WWPN
+				 * and driver only registers FCP_TARGETs */
+				#ifdef MPT_DEBUG
+ri->debug++;
+				printk ("mptfc_rescan.%d: %llx, deleted %d\n",ioc->sh->host_no,ri->pg0.WWPN,
+					ri->debug);
+				#endif
+			}
+		}
+		spin_unlock_irqrestore(&ioc->fc_rport_lock,flags);
+
+		/* allow multiple passes as target state might have changed during scan */
+		spin_lock_irqsave(&ioc->work_lock,flags);
+		if (ioc->work_count > 2) 	/* don't need THAT many passes */
+			ioc->work_count = 2;
+		work_to_do = --ioc->work_count;
+		spin_unlock_irqrestore(&ioc->work_lock,flags);
+	} while (work_to_do);
+}
+
 static int
 mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
@@ -155,10 +570,10 @@
 	u8			*mem;
 	int			error=0;
 	int			r;
-		
+
 	if ((r = mpt_attach(pdev,id)) != 0)
 		return r;
-	
+
 	ioc = pci_get_drvdata(pdev);
 	ioc->DoneCtx = mptfcDoneCtx;
 	ioc->TaskCtx = mptfcTaskCtx;
@@ -194,7 +609,7 @@
 		printk(MYIOC_s_WARN_FMT
 			"Skipping ioc=%p because SCSI Initiator mode is NOT enabled!\n",
 			ioc->name, ioc);
-		return 0;
+		return -ENODEV;
 	}
 
 	sh = scsi_host_alloc(&mptfc_driver_template, sizeof(MPT_SCSI_HOST));
@@ -207,6 +622,8 @@
 		goto out_mptfc_probe;
         }
 
+	INIT_WORK(&ioc->work_task, mptfc_rescan_devices,(void *)ioc);
+
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
 
 	/* Attach the SCSI Host to the IOC structure
@@ -332,6 +749,7 @@
 	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
 
+	sh->transportt = mptfc_transport_template;
 	error = scsi_add_host (sh, &ioc->pcidev->dev);
 	if(error) {
 		dprintk((KERN_ERR MYNAM
@@ -339,7 +757,11 @@
 		goto out_mptfc_probe;
 	}
 
-	scsi_scan_host(sh);
+	for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
+		mptfc_init_host_attr(ioc,ii);
+		mptfc_GetFcDevPage0(ioc,ii,mptfc_register_dev);
+	}
+
 	return 0;
 
 out_mptfc_probe:
@@ -352,7 +774,7 @@
 	.name		= "mptfc",
 	.id_table	= mptfc_pci_table,
 	.probe		= mptfc_probe,
-	.remove		= __devexit_p(mptscsih_remove),
+	.remove		= __devexit_p(mptfc_remove),
 	.shutdown	= mptscsih_shutdown,
 #ifdef CONFIG_PM
 	.suspend	= mptscsih_suspend,
@@ -370,9 +792,14 @@
 static int __init
 mptfc_init(void)
 {
+	int error;
 
 	show_mptmod_ver(my_NAME, my_VERSION);
 
+	mptfc_transport_template = fc_attach_transport(&mptfc_transport_functions);
+	if (!mptfc_transport_template)
+		return -ENODEV;
+
 	mptfcDoneCtx = mpt_register(mptscsih_io_done, MPTFC_DRIVER);
 	mptfcTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTFC_DRIVER);
 	mptfcInternalCtx = mpt_register(mptscsih_scandv_complete, MPTFC_DRIVER);
@@ -387,7 +814,33 @@
 		  ": Registered for IOC reset notifications\n"));
 	}
 
-	return pci_register_driver(&mptfc_driver);
+	error = pci_register_driver(&mptfc_driver);
+	if (error) {
+		fc_release_transport(mptfc_transport_template);
+	}
+
+	return error;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
+ *	mptfc_remove - Removed fc infrastructure for devices
+ *	@pdev: Pointer to pci_dev structure
+ *
+ */
+static void __devexit mptfc_remove(struct pci_dev *pdev)
+{
+	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
+	struct mptfc_rport_info *p, *n;
+
+	fc_remove_host(ioc->sh);
+
+	list_for_each_entry_safe(p, n, &ioc->l.fc_rports, list) {
+		list_del(&p->list);
+		kfree(p);
+	}
+
+	mptscsih_remove(pdev);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -400,7 +853,8 @@
 mptfc_exit(void)
 {
 	pci_unregister_driver(&mptfc_driver);
-	
+	fc_release_transport(mptfc_transport_template);
+
 	mpt_reset_deregister(mptfcDoneCtx);
 	dprintk((KERN_INFO MYNAM
 	  ": Deregistered for IOC reset notifications\n"));
diff -ru em/drivers/message/fusion/mptsas.c mdr/drivers/message/fusion/mptsas.c
--- em/drivers/message/fusion/mptsas.c	2005-11-18 11:53:52.000000000 -0600
+++ mdr/drivers/message/fusion/mptsas.c	2005-11-18 12:22:32.000000000 -0600
@@ -994,7 +994,7 @@
 	if (error)
 		goto out_free_port_info;
 
-	list_add_tail(&port_info->list, &ioc->sas_topology);
+	list_add_tail(&port_info->list, &ioc->l.sas_topology);
 	for (i = 0; i < port_info->num_phys; i++) {
 		mptsas_sas_phy_pg0(ioc, &port_info->phy_info[i],
 			(MPI_SAS_PHY_PGAD_FORM_PHY_NUMBER <<
@@ -1047,7 +1047,7 @@
 
 	*handle = port_info->handle;
 
-	list_add_tail(&port_info->list, &ioc->sas_topology);
+	list_add_tail(&port_info->list, &ioc->l.sas_topology);
 	for (i = 0; i < port_info->num_phys; i++) {
 		struct device *parent;
 
@@ -1079,7 +1079,7 @@
 		 * HBA phys.
 		 */
 		parent = &ioc->sh->shost_gendev;
-		list_for_each_entry(p, &ioc->sas_topology, list) {
+		list_for_each_entry(p, &ioc->l.sas_topology, list) {
 			for (j = 0; j < p->num_phys; j++) {
 				if (port_info->phy_info[i].identify.handle ==
 						p->phy_info[j].attached.handle)
@@ -1202,7 +1202,7 @@
 	 */
 	sh->unique_id = ioc->id;
 
-	INIT_LIST_HEAD(&ioc->sas_topology);
+	INIT_LIST_HEAD(&ioc->l.sas_topology);
 	init_MUTEX(&ioc->sas_mgmt.mutex);
 	init_completion(&ioc->sas_mgmt.done);
 
@@ -1339,7 +1339,7 @@
 
 	sas_remove_host(ioc->sh);
 
-	list_for_each_entry_safe(p, n, &ioc->sas_topology, list) {
+	list_for_each_entry_safe(p, n, &ioc->l.sas_topology, list) {
 		list_del(&p->list);
 		kfree(p);
 	}
diff -ru em/drivers/message/fusion/mptscsih.c mdr/drivers/message/fusion/mptscsih.c
--- em/drivers/message/fusion/mptscsih.c	2005-11-18 11:54:02.000000000 -0600
+++ mdr/drivers/message/fusion/mptscsih.c	2005-11-18 12:33:33.000000000 -0600
@@ -58,6 +58,7 @@
 #include <linux/workqueue.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
@@ -893,6 +894,7 @@
  *		when a lun is disable by mid-layer.
  *		Do NOT access the referenced scsi_cmnd structure or
  *		members. Will cause either a paging or NULL ptr error.
+ * (BUT, BUT, BUT, the code does reference it!)
  *      @hd: Pointer to a SCSI HOST structure
  *	@vdevice: per device private data
  *
@@ -2566,6 +2568,18 @@
 			ddvtprintk(("Set reload IOC Pg3 Flag\n"));
 		}
 
+		/* 7. FC: Rescan for blocked rports which might have returned.
+		 */
+		else if (ioc->bus_type == FC) {
+			int work_count;
+			unsigned long flags;
+
+			spin_lock_irqsave(&ioc->work_lock,flags);
+			work_count = ++ioc->work_count;
+			spin_unlock_irqrestore(&ioc->work_lock,flags);
+			if (work_count == 1)
+				schedule_work(&ioc->work_task);
+		}
 		dtmprintk((MYIOC_s_WARN_FMT "Post-Reset complete.\n", ioc->name));
 
 	}
@@ -2589,6 +2603,8 @@
 {
 	MPT_SCSI_HOST *hd;
 	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
+	int work_count;
+	unsigned long flags;
 
 	devtprintk((MYIOC_s_INFO_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
 			ioc->name, event));
@@ -2610,11 +2626,18 @@
 		/* FIXME! */
 		break;
 
+	case MPI_EVENT_RESCAN:				/* 06 */
+		spin_lock_irqsave(&ioc->work_lock,flags);
+		work_count = ++ioc->work_count;
+		spin_unlock_irqrestore(&ioc->work_lock,flags);
+		if (work_count == 1)
+			schedule_work(&ioc->work_task);
+		break;
+
 		/*
 		 *  CHECKME! Don't think we need to do
 		 *  anything for these, but...
 		 */
-	case MPI_EVENT_RESCAN:				/* 06 */
 	case MPI_EVENT_LINK_STATUS_CHANGE:		/* 07 */
 	case MPI_EVENT_LOOP_STATE_CHANGE:		/* 08 */
 		/*
@@ -3954,8 +3977,6 @@
 
 /* Search IOC page 3 to determine if this is hidden physical disk
  */
-/* Search IOC page 3 to determine if this is hidden physical disk
- */
 static int
 mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id)
 {
