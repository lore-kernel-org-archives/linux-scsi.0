From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Emulex] Ready for next round...
Date: Wed, 16 Jun 2004 14:50:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040616135008.GA12260@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F94D5@xbl.ma.emulex.com> <20040616081757.GA8683@infradead.org> <20040616133518.GS11371@ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:56729 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S266282AbUFPNuS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 09:50:18 -0400
Content-Disposition: inline
In-Reply-To: <20040616133518.GS11371@ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Smart, James" <James.Smart@emulex.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Wed, Jun 16, 2004 at 09:35:18AM -0400, Jamie Wellnitz wrote:
> Christoph,
> 
> Am I missing the big diff for lpfc_fcp.c?  I don't see it . . .

Umm, sorry.  Here it is:

diff -uNr -p -X dontdiff lpfcdriver-2.6-8.0.4/lpfc_fcp.c lpfcdriver-2.6-8.0.4-hch/lpfc_fcp.c
--- lpfcdriver-2.6-8.0.4/lpfc_fcp.c	2004-06-15 00:07:01.000000000 +0200
+++ lpfcdriver-2.6-8.0.4-hch/lpfc_fcp.c	2004-06-16 10:15:00.306818584 +0200
@@ -70,71 +70,12 @@
 
 static char *lpfc_drvr_name = LPFC_DRIVER_NAME;
 
-MODULE_DESCRIPTION(LPFC_MODULE_DESC);
-MODULE_AUTHOR("Emulex Corporation - tech.support@emulex.com");
-MODULE_VERSION("0:" LPFC_DRIVER_VERSION);
-
 #define FC_EXTEND_TRANS_A 1
 
-static int lpfc_get_bind_type(struct lpfc_hba *);
-static int lpfc_slave_alloc(struct scsi_device *);
-static int lpfc_slave_configure(struct scsi_device *);
-static void lpfc_slave_destroy(struct scsi_device *);
-
-
-static int lpfc_device_queue_depth(struct lpfc_hba *, struct scsi_device *);
-static int lpfc_reset_bus_handler(struct scsi_cmnd *cmnd);
-
-static int lpfc_memmap(struct lpfc_hba *);
-static int lpfc_unmemmap(struct lpfc_hba *);
-static int lpfc_pcimap(struct lpfc_hba *);
-
-static int lpfc_config_setup(struct lpfc_hba *);
-static int lpfc_bind_setup(struct lpfc_hba *);
-static int lpfc_sli_setup(struct lpfc_hba *);
-static int lpfc_bind_wwpn(struct lpfc_hba *, char **, u_int);
-static int lpfc_bind_wwnn(struct lpfc_hba *, char **, u_int);
-static int lpfc_bind_did(struct lpfc_hba *, char **, u_int);
-static int lpfc_biosparam(struct scsi_device *, struct block_device *,
-			  sector_t capacity, int ip[]);
-static int lpfc_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
-static uint32_t lpfc_get_cfgparam(int, int);
-
-static int lpfc_do_dpc(void *);
-
 /* Binding Definitions: Max string size  */
 #define FC_MAX_DID_STRING       6
 #define FC_MAX_WW_NN_PN_STRING 16
 
-
-static struct scsi_host_template driver_template = {
-	.module = THIS_MODULE,
-	.name = LPFC_DRIVER_NAME,
-	.info = lpfc_info,
-	.queuecommand = lpfc_queuecommand,
-
-	.eh_abort_handler = lpfc_abort_handler,
-	.eh_device_reset_handler = lpfc_reset_lun_handler,
-	.eh_bus_reset_handler = lpfc_reset_bus_handler,
-
-	.slave_alloc = lpfc_slave_alloc,
-	.slave_configure = lpfc_slave_configure,
-	.slave_destroy = lpfc_slave_destroy,
-
-	.bios_param = lpfc_biosparam,
-	.proc_info = lpfc_proc_info,
-	.proc_name = LPFC_DRIVER_NAME,
-
-	.can_queue = LPFC_DFT_HBA_Q_DEPTH,
-	.this_id = -1,
-
-	.sg_tablesize = SG_ALL,
-	.cmd_per_lun = 30,
-	.use_clustering = ENABLE_CLUSTERING,
-};
-
-
-
 unsigned long lpfc_loadtime;
 static struct list_head lpfc_hba_list = LIST_HEAD_INIT(lpfc_hba_list);
 
@@ -259,1135 +200,793 @@ static DEVICE_ATTR(lpfc_max_target, S_IR
 		   lpfc_sysfs_max_target_show, lpfc_sysfs_max_target_store);
 static DRIVER_ATTR(version, S_IRUGO, lpfc_sysfs_version_show, NULL);
 
-static struct pci_device_id lpfc_id_table[] = {
-	{
-		.vendor = PCI_VENDOR_ID_EMULEX,
-		.device	= PCI_DEVICE_ID_VIPER,
-		.subvendor = PCI_ANY_ID,
-		.subdevice = PCI_ANY_ID,
-		.class = 0,
-		.class_mask = 0,
-		.driver_data = 0UL
-	},
-	{
-		.vendor = PCI_VENDOR_ID_EMULEX,
-		.device	= PCI_DEVICE_ID_THOR,
-		.subvendor = PCI_ANY_ID,
-		.subdevice = PCI_ANY_ID,
-		.class = 0,
-		.class_mask = 0,
-		.driver_data = 0UL
-	},
-	{
-		.vendor = PCI_VENDOR_ID_EMULEX,
-		.device	= PCI_DEVICE_ID_PEGASUS,
-		.subvendor = PCI_ANY_ID,
-		.subdevice = PCI_ANY_ID,
-		.class = 0,
-		.class_mask = 0,
-		.driver_data = 0UL
-	},
-	{
-		.vendor = PCI_VENDOR_ID_EMULEX,
-		.device	= PCI_DEVICE_ID_CENTAUR,
-		.subvendor = PCI_ANY_ID,
-		.subdevice = PCI_ANY_ID,
-	},
-	{
-		.vendor = PCI_VENDOR_ID_EMULEX,
-		.device	= PCI_DEVICE_ID_DRAGONFLY,
-		.subvendor = PCI_ANY_ID,
-		.subdevice = PCI_ANY_ID,
-		.class = 0,
-		.class_mask = 0,
-		.driver_data = 0UL
-	},
-	{
-		.vendor = PCI_VENDOR_ID_EMULEX,
-		.device	= PCI_DEVICE_ID_SUPERFLY,
-		.subvendor = PCI_ANY_ID,
-		.subdevice = PCI_ANY_ID,
-		.class = 0,
-		.class_mask = 0,
-		.driver_data = 0UL
-	},
-	{
-		.vendor = PCI_VENDOR_ID_EMULEX,
-		.device	= PCI_DEVICE_ID_RFLY,
-		.subvendor = PCI_ANY_ID,
-		.subdevice = PCI_ANY_ID,
-		.class = 0,
-		.class_mask = 0,
-		.driver_data = 0UL
-	},
-	{
-		.vendor = PCI_VENDOR_ID_EMULEX,
-		.device	= PCI_DEVICE_ID_PFLY,
-		.subvendor = PCI_ANY_ID,
-		.subdevice = PCI_ANY_ID,
-		.class = 0,
-		.class_mask = 0,
-		.driver_data = 0UL
-	},
-	{
-		.vendor = PCI_VENDOR_ID_EMULEX,
-		.device	= PCI_DEVICE_ID_TFLY,
-		.subvendor = PCI_ANY_ID,
-		.subdevice = PCI_ANY_ID,
-		.class = 0,
-		.class_mask = 0,
-		.driver_data = 0UL
-	},
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, lpfc_id_table);
-
-static int __devinit
-lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
+/*
+ * Retrieve lpfc_hba * matching instance (board no)
+ * If found return lpfc_hba *
+ * If not found return NULL
+ */
+struct lpfc_hba *
+lpfc_get_phba_by_inst(int inst)
 {
-	struct Scsi_Host *host;
-	struct lpfc_hba *phba;
-	struct lpfc_cfgparam *clp;
-	struct clk_data *clkData;
-	int rc, i;
-	unsigned long iflag;
-	uint32_t timeout;
-	struct timer_list *cur_timer;
-	
-
-	if (pci_enable_device(pdev))
-		return -ENODEV;
-	if (pci_request_regions(pdev, LPFC_DRIVER_NAME)) {
-		printk("lpfc PCI I/O region is already in use.\n");
-		printk("a driver for lpfc is already loaded on this system.\n");
-		return -ENODEV;
-	}
-	
-	/*
-	 * Allocate space for adapter info structure
-	 */
-	if (!(phba = kmalloc(sizeof (struct lpfc_hba), GFP_KERNEL))) {
-		goto error;
-	}
-
-	/* By default, the driver expects this attach to succeed. */
-	rc = 0;
-
-	memset(phba, 0, sizeof (struct lpfc_hba));
-	INIT_LIST_HEAD(&phba->timerList);
-
-	/* Initialize default values for configuration parameters */
-	if (!(phba->config = kmalloc(sizeof (lpfc_icfgparam), GFP_KERNEL))) {
-		goto error_1;
-	}
-	memset(phba->config, 0, sizeof (lpfc_icfgparam));
-
-	memcpy(&phba->config[0], (uint8_t *) & lpfc_icfgparam[0],
-	       sizeof (lpfc_icfgparam));
-
-	clp = &phba->config[0];
+	struct lpfc_hba * phba;
+	int    found = 0;
 
-	/* Set everything to the defaults */
-	for (i = 0; i < LPFC_TOTAL_NUM_OF_CFG_PARAM; i++)
-		clp[i].a_current = clp[i].a_default;
-	
-	/* Assign an unused board number */
-	i = 0;
-	while (1) {
-		if (lpfc_get_phba_by_inst(i) == NULL ) {
-			phba->brd_no = i;
+	phba = NULL;
+	list_for_each_entry(phba, &lpfc_hba_list, hba_list) {
+		if (phba->brd_no == inst) {
+			found = 1;
 			break;
 		}
-		i++;
 	}
+	
+	if (!found)
+		return(NULL);
+	else
+		return(phba);
+	
+}
 
-	/* Add adapter structure to list */
-	list_add_tail(&phba->hba_list, &lpfc_hba_list);
-
-	/* Initialize all internally managed lists. */
-	INIT_LIST_HEAD(&phba->fc_nlpmap_list);
-	INIT_LIST_HEAD(&phba->fc_nlpunmap_list);
-	INIT_LIST_HEAD(&phba->fc_plogi_list);
-	INIT_LIST_HEAD(&phba->fc_adisc_list);
-	INIT_LIST_HEAD(&phba->fc_nlpbind_list);
-
-	/* Initialize plxhba - LINUX specific */
-	phba->pcidev = pdev;
-	init_waitqueue_head(&phba->linkevtwq);
-	init_waitqueue_head(&phba->rscnevtwq);
-	init_waitqueue_head(&phba->ctevtwq);
-
-	if ((rc = lpfc_pcimap(phba))) {
-		goto error_2;
+const char *
+lpfc_info(struct Scsi_Host *host)
+{
+	struct lpfc_hba    *phba = (struct lpfc_hba *) host->hostdata[0];
+	int len;
+	static char  lpfcinfobuf[128];
+	
+	memset(lpfcinfobuf,0,128);
+	if(phba && phba->pcidev){
+	        lpfc_get_hba_model_desc(phba, 0, lpfcinfobuf);
+		len = strlen(lpfcinfobuf);	
+		snprintf(lpfcinfobuf + len,
+			128-len,
+	       		" on PCI bus %02x device %02x irq %d",
+			phba->pcidev->bus->number,
+		 	phba->pcidev->devfn,
+			phba->pcidev->irq);
 	}
+	return lpfcinfobuf;
+}
 
-	if ((rc = lpfc_memmap(phba))) {
-		goto error_2;
-	}
+static int
+lpfc_proc_info(struct Scsi_Host *host,
+	       char *buf, char **start, off_t offset, int count, int rw)
+{
 
-	lpfc_num_hba++;
-	lpfc_config_setup(phba);	/* Setup configuration parameters */
+	struct lpfc_hba *phba = NULL;
+	struct pci_dev *pdev;
+	char fwrev[32];
+	lpfc_vpd_t *vp;
+	struct lpfc_nodelist *ndlp;
+	int  i, j, incr;
+	char hdw[9];
+	int len = 0, found = 0;
+	
+	/* Sufficient bytes to hold a port or node name. */
+	uint8_t name[sizeof (struct lpfc_name)];
 
-	/*
-	 * If the t.o value is not set, set it to 30
+	/* If rw = 0, then read info
+	 * If rw = 1, then write info (NYI)
 	 */
-	if (clp[LPFC_CFG_SCSI_REQ_TMO].a_current == 0) {
-		clp[LPFC_CFG_SCSI_REQ_TMO].a_current = 30;
-	}
+	if (rw)
+		return -EINVAL;
 
-	if (clp[LPFC_CFG_DISC_THREADS].a_current) {
-		/*
-		 * Set to FC_NLP_REQ if automap is set to 0 since order of
-		 * discovery does not matter if everything is persistently
-		 * bound.
-		 */
-		if (clp[LPFC_CFG_AUTOMAP].a_current == 0) {
-			clp[LPFC_CFG_DISC_THREADS].a_current =
-			    LPFC_MAX_DISC_THREADS;
+
+	list_for_each_entry(phba, &lpfc_hba_list, hba_list) {
+		if (phba == (struct lpfc_hba *)host->hostdata[0]) {
+			found = 1;
+			break;
 		}
 	}
 
-	/* Initialize all per HBA locks */
-	spin_lock_init(&phba->drvrlock);
-	spin_lock_init(&phba->hiprilock);
-
-	lpfc_sli_setup(phba);	/* Setup SLI Layer to run over lpfc HBAs */
-	lpfc_sli_queue_setup(phba);	/* Initialize the SLI Layer */
-
-	if (lpfc_mem_alloc(phba) == 0) {
-		goto error_3;
+	if (!found) {
+		return sprintf(buf, "Cannot find adapter for requested host "
+			       "number.\n");
 	}
-	lpfc_bind_setup(phba);	/* Setup binding configuration parameters */
-
-	/* Initialize HBA structure */
-	phba->fc_edtov = FF_DEF_EDTOV;
-	phba->fc_ratov = FF_DEF_RATOV;
-	phba->fc_altov = FF_DEF_ALTOV;
-	phba->fc_arbtov = FF_DEF_ARBTOV;
 
-	/* Set the FARP and XRI timeout values now since they depend on
-	   fc_ratov. */
-	phba->fc_ipfarp_timeout = (3 * phba->fc_ratov);
-	phba->fc_ipxri_timeout = (3 * phba->fc_ratov);
+	vp = &phba->vpd;
+	pdev = phba->pcidev;
 
-	spin_lock_init(&phba->dpc_lock);
-	INIT_LIST_HEAD(&phba->dpc_disc);
-	init_completion(&phba->dpc_startup);
-	init_completion(&phba->dpc_exiting);
+	len += snprintf(buf, PAGE_SIZE, LPFC_MODULE_DESC "\n");
 
-	/*
-	* Startup the kernel thread for this host adapter
-	*/
-	phba->dpc_kill = 0;
-	phba->dpc_pid = kernel_thread(lpfc_do_dpc, phba, 0);
-	if (phba->dpc_pid < 0) {
-		goto error_3;
-	}
-	wait_for_completion(&phba->dpc_startup);
+	len += snprintf(buf + len, PAGE_SIZE-len, "%s\n",
+			lpfc_info(phba->host));
 
+	len += snprintf(buf + len, PAGE_SIZE-len, "SerialNum: %s\n",
+			phba->SerialNumber);
 
+	lpfc_decode_firmware_rev(phba, fwrev, 1);
+	len += snprintf(buf + len, PAGE_SIZE-len, "Firmware Version: %s\n",
+			fwrev);
 
-	/* Call SLI to initialize the HBA. */
-	if ((rc = lpfc_sli_hba_setup(phba)) != 0) {
-		goto error_5;
+	len += snprintf(buf + len, PAGE_SIZE-len, "Hdw: ");
+	/* Convert JEDEC ID to ascii for hardware version */
+	incr = vp->rev.biuRev;
+	for (i = 0; i < 8; i++) {
+		j = (incr & 0xf);
+		if (j <= 9)
+			hdw[7 - i] = (char)((uint8_t) 0x30 + (uint8_t) j);
+		else
+			hdw[7 - i] =
+			    (char)((uint8_t) 0x61 + (uint8_t) (j - 10));
+		incr = (incr >> 4);
 	}
+	hdw[8] = 0;
+	len += snprintf(buf + len, PAGE_SIZE-len, hdw);
 
+	len += snprintf(buf + len, PAGE_SIZE-len, "\nVendorId: 0x%x\n",
+		       ((((uint32_t) pdev->device) << 16) |
+			(uint32_t) (pdev->vendor)));
 
-	   /* Register this board */
-	host = scsi_host_alloc(&driver_template, sizeof (unsigned long));
-
-	if (host) {
-		phba->host = host;
-		host->can_queue = clp[LPFC_CFG_DFT_HBA_Q_DEPTH].a_current - 10;
-	}
-	else {
-		printk (KERN_WARNING "%s%d: scsi_host_alloc failed during "
-			"attach\n", lpfc_drvr_name, phba->brd_no);
-		goto error_5;
-	}
-
-	/*
-	 * Adjust the number of id's
-	 * Although max_id is an int, target id's are unsined chars
-	 * Do not exceed 255, otherwise the device scan will wrap around
+	/* A Fibre Channel node or port name is 8 octets long and delimited by
+	 * colons.
 	 */
-	if (clp[LPFC_CFG_MAX_TARGET].a_current > LPFC_MAX_TARGET) {
-		clp[LPFC_CFG_MAX_TARGET].a_current = LPFC_DFT_MAX_TARGET;
-	}
-	host->max_id = clp[LPFC_CFG_MAX_TARGET].a_current;
-	host->unique_id = lpfc_num_hba;
-
-	if (clp[LPFC_CFG_MAX_LUN].a_current > LPFC_MAX_LUN) {
-		clp[LPFC_CFG_MAX_LUN].a_current = LPFC_DFT_MAX_LUN;
-	}
-	host->max_lun = clp[LPFC_CFG_MAX_LUN].a_current;
+	len += snprintf(buf + len, PAGE_SIZE-len, "Portname: ");
+	memcpy (&name[0], &phba->fc_portname, sizeof (struct lpfc_name));
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
+			name[0], name[1], name[2], name[3], name[4], name[5],
+			name[6], name[7]);
 
-	/* Adapter ID - tell midlayer not to reserve an ID for us */
-	host->this_id = -1;
+	len += snprintf(buf + len, PAGE_SIZE-len, "   Nodename: ");
+	memcpy (&name[0], &phba->fc_nodename, sizeof (struct lpfc_name));
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
+			name[0], name[1], name[2], name[3], name[4], name[5],
+			name[6], name[7]);
 
-	/*
-	 * Setup the scsi timeout handler with a
-	 * timeout value = greater of (2*RATOV, 5).
-	 */
-	timeout = (phba->fc_ratov << 1) > 5 ? (phba->fc_ratov << 1) : 5;
-	phba->scsi_tmo_data.timeObj = &phba->scsi_tmofunc;
-	phba->scsi_tmo_data.phba = phba;
-	phba->scsi_tmo_data.clData1 = (unsigned long)timeout;
-	init_timer(&phba->scsi_tmofunc);
-	phba->scsi_tmofunc.function = lpfc_scsi_timeout_handler;
-	phba->scsi_tmofunc.expires = jiffies + HZ * timeout;
-	phba->scsi_tmofunc.data = (unsigned long)&phba->scsi_tmo_data;
-	list_add(&phba->scsi_tmo_data.listLink, &phba->timerList);
-	add_timer(&phba->scsi_tmofunc);
+	switch (phba->hba_state) {
+	case LPFC_INIT_START:
+	case LPFC_INIT_MBX_CMDS:
+	case LPFC_LINK_DOWN:
+		len += snprintf(buf + len, PAGE_SIZE-len, "\n\nLink Down\n");
+		break;
+	case LPFC_LINK_UP:
+	case LPFC_LOCAL_CFG_LINK:
+		len += snprintf(buf + len, PAGE_SIZE-len, "\n\nLink Up\n");
+		break;
+	case LPFC_FLOGI:
+	case LPFC_FABRIC_CFG_LINK:
+	case LPFC_NS_REG:
+	case LPFC_NS_QRY:
+	case LPFC_BUILD_DISC_LIST:
+	case LPFC_DISC_AUTH:
+	case LPFC_CLEAR_LA:
+		len += snprintf(buf + len, PAGE_SIZE-len,
+				"\n\nLink Up - Discovery\n");
+		break;
+	case LPFC_HBA_READY:
+		len += snprintf(buf + len, PAGE_SIZE-len,
+				"\n\nLink Up - Ready:\n");
+		len += snprintf(buf + len, PAGE_SIZE-len, "   PortID 0x%x\n",
+				phba->fc_myDID);
+		if (phba->fc_topology == TOPOLOGY_LOOP) {
+			if (phba->fc_flag & FC_PUBLIC_LOOP)
+				len += snprintf(buf + len, PAGE_SIZE-len,
+						"   Public Loop\n");
+			else
+				len += snprintf(buf + len, PAGE_SIZE-len,
+						"   Private Loop\n");
+		} else {
+			if (phba->fc_flag & FC_FABRIC)
+				len += snprintf(buf + len, PAGE_SIZE-len,
+						"   Fabric\n");
+			else
+				len += snprintf(buf + len, PAGE_SIZE-len,
+						"   Point-2-Point\n");
+		}
 
+		if (phba->fc_linkspeed == LA_2GHZ_LINK)
+			len += snprintf(buf + len, PAGE_SIZE-len,
+					"   Current speed 2G\n");
+		else
+			len += snprintf(buf + len, PAGE_SIZE-len,
+					"   Current speed 1G\n\n");
 
-	/*
-	 * Starting with 2.4.0 kernel, Linux can support commands longer
-	 * than 12 bytes. However, scsi_register() always sets it to 12.
-	 * For it to be useful to the midlayer, we have to set it here.
-	 */
-	host->max_cmd_len = 16;
+		/* Loop through the list of mapped nodes and dump the known node
+		   information. */
+		list_for_each_entry(ndlp, &phba->fc_nlpmap_list, nlp_listp) {
+			if (ndlp->nlp_state == NLP_STE_MAPPED_NODE){
+				len += snprintf(buf + len, PAGE_SIZE -len,
+						"lpfc%dt%02x DID %06x WWPN ",
+						ndlp->nlp_Target->pHba->brd_no,
+						ndlp->nlp_sid, ndlp->nlp_DID);
 
-	/*
-	 * Queue depths per lun
-	 */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,6)
-	host->transportt = lpfc_transport_template;
-#endif
-	host->hostdata[0] = (unsigned long)phba;
-	pci_set_drvdata(pdev, host);
-	if (scsi_add_host(host, &pdev->dev))
-		goto error_6;
-	device_create_file(&(pdev->dev), &dev_attr_info);
-	device_create_file(&(pdev->dev), &dev_attr_serialnum);
-	device_create_file(&(pdev->dev), &dev_attr_fwrev);
-	device_create_file(&(pdev->dev), &dev_attr_hdw);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_log_verbose);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_tgt_queue_depth);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_lun_queue_depth);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_extra_io_tmo);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_no_device_delay);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_linkdown_tmo);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_nodev_holdio);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_delay_rsp_err);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_check_cond_err);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_nodev_tmo);
-	device_create_file(&(pdev->dev),
-			   &dev_attr_lpfc_dqfull_throttle_up_time);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_dqfull_throttle_up_inc);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_max_lun);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_lun_skip);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_automap);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_fcp_class);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_use_adisc);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_network_on);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_post_ip_buf);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_xmt_que_size);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_ip_class);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_ack0);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_topology);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_scan_down);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_link_speed);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_cr_delay);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_cr_count);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_fdmi_on);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_fcp_bind_method);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_discovery_threads);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_scsi_req_tmo);
-	device_create_file(&(pdev->dev), &dev_attr_lpfc_max_target);
-	scsi_scan_host(host);
-	goto out;
-error_6:
-	scsi_host_put(host);
-error_5:
-	lpfc_sli_hba_down(phba);
+				/* A Fibre Channel node or port name is 8 octets
+				 * long and delimited by colons.
+				 */
+				memcpy (&name[0], &ndlp->nlp_portname,
+					sizeof (struct lpfc_name));
+				len += snprintf(buf + len, PAGE_SIZE-len,
+						"%02x:%02x:%02x:%02x:%02x:%02x:"
+						"%02x:%02x",
+						name[0], name[1], name[2],
+						name[3], name[4], name[5],
+						name[6], name[7]);
 
-error_3:
-	/* Stop any timers that were started during this attach. */
-	spin_lock_irqsave(&(phba->drvrlock), iflag);
-	while (!list_empty(&phba->timerList)) {
-		clkData = (struct clk_data *)(phba->timerList.next);
-		if (clkData) {
-			cur_timer = clkData->timeObj;
-			del_timer_sync(cur_timer);
-			cur_timer->function = 0;
-			list_del(&clkData->listLink);
+				len += snprintf(buf + len, PAGE_SIZE-len,
+						" WWNN ");
+				memcpy (&name[0], &ndlp->nlp_nodename,
+					sizeof (struct lpfc_name));
+				len += snprintf(buf + len, PAGE_SIZE-len,
+						"%02x:%02x:%02x:%02x:%02x:%02x:"
+						"%02x:%02x\n",
+						name[0], name[1], name[2],
+						name[3], name[4], name[5],
+						name[6], name[7]);
+
+			}
+			if(PAGE_SIZE - len < 90)
+				break;
 		}
+
+		if(&ndlp->nlp_listp != &phba->fc_nlpmap_list)
+			len += snprintf(buf+len, PAGE_SIZE-len, "...\n");
+
 	}
-	spin_unlock_irqrestore(&(phba->drvrlock), iflag);
+	return (len);
+}
 
-	/* Kill the kernel thread for this host */
-	if (phba->dpc_pid >= 0) {
-		phba->dpc_kill = 1;
-		wmb();
-		kill_proc(phba->dpc_pid, SIGHUP, 1);
-		wait_for_completion(&phba->dpc_exiting);
+static int
+lpfc_reset_bus_handler(struct scsi_cmnd *cmnd)
+{
+	struct lpfc_hba *phba;
+	LPFC_SCSI_BUF_t *lpfc_cmd;
+	unsigned long iflag;
+	int rc, tgt, lun;
+
+	phba = (struct lpfc_hba *) cmnd->device->host->hostdata[0];
+	tgt = cmnd->device->id;
+	lun = cmnd->device->lun;
+
+	rc = 0;
+	if ((lpfc_cmd = lpfc_get_scsi_buf(phba, GFP_ATOMIC))) {
+		rc = lpfc_scsi_hba_reset(phba, lpfc_cmd);
+		spin_lock_irqsave(&(phba->drvrlock), iflag);
+		lpfc_free_scsi_buf(lpfc_cmd);
+		spin_unlock_irqrestore(&(phba->drvrlock), iflag);
 	}
 
-	free_irq(phba->pcidev->irq, phba);
-	lpfc_mem_free(phba);
-	lpfc_unmemmap(phba);
-	lpfc_num_hba--;
+	/* SCSI layer issued Bus Reset */
+	lpfc_printf_log(phba,
+		        KERN_ERR,
+		        LOG_FCP,
+		        "0714 SCSI layer issued Bus Reset Data: x%x x%x x%x",
+		        tgt, lun, rc);
 
-error_2:
-	kfree(phba->config);
 
-error_1:
-	/* Remove from list of active HBAs */
-	list_del_init(&phba->hba_list);
-	kfree(phba);
+	return (SUCCESS);
+
+}				/* lpfc_reset_bus_handler */
+
+static int
+lpfc_slave_alloc(struct scsi_device *scsi_devs)
+{
+	struct lpfc_hba *phba;
+	struct lpfc_lun *lunp;
 
-error:
-	/* Any error in the attach routine will end up here.  Set the return
- 	 * code to 1 and exit.
+	/* Store the lun pointer in the scsi_device hostdata pointer provided
+	 * the driver has already discovered the target/lun id.  Undiscovered
+	 * target/lun information is handled dynamically via the driver's 
+	 * discovery state machine.
 	 */
-	rc = -1;
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);	
-out:	
-	return rc;
+	phba = (struct lpfc_hba *) scsi_devs->host->hostdata[0];
+	lunp = lpfc_find_lun(phba, scsi_devs->id, scsi_devs->lun, 1);
+	if (lunp) {
+		scsi_devs->hostdata = lunp;
+	}
+		
+	/* Always return success from this routine since the driver handles
+	 * target/lun discovery and resource allocation dynamically.  Failing
+	 * this call causes the midlayer to dump an error message per target 
+	 * based on conflicting information from the driver.  Although the 
+	 * driver could allocate a target instance here for each scsi device 
+	 * passed by the midlayer, a TUR or SCSI_INQUIRY issued to
+	 * queuecommand would just fail and result in lpfc_slave_destroy freeing
+	 * the memory.  Returning success avoids this situation.
+	 */
+	return 0;
 }
 
-static void __devexit
-lpfc_pci_remove_one(struct pci_dev *pdev)
+static int
+lpfc_slave_configure(struct scsi_device *sdev)
 {
-	struct Scsi_Host *host;
-	struct lpfc_hba        * phba;
-	LPFC_SLI_t       * psli;
-	struct clk_data  * clkData;
-	unsigned long      iflag;
-	struct timer_list *cur_timer;
+	struct lpfc_hba *phba = (struct lpfc_hba *)sdev->host->hostdata[0];
+	struct lpfc_cfgparam *clp = &phba->config[0];
 
-	host = pci_get_drvdata(pdev);
-	phba = (struct lpfc_hba *) host->hostdata[0];
+	if (sdev->tagged_supported) {
+		sdev->current_tag = 0;
+		sdev->queue_depth = clp[LPFC_CFG_DFT_LUN_Q_DEPTH].a_current;
+	} else
+		sdev->queue_depth = 16;
 
-	device_remove_file(&(pdev->dev), &dev_attr_info);
-	device_remove_file(&(pdev->dev), &dev_attr_serialnum);
-	device_remove_file(&(pdev->dev), &dev_attr_fwrev);
-	device_remove_file(&(pdev->dev), &dev_attr_hdw);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_log_verbose);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_tgt_queue_depth);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_lun_queue_depth);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_extra_io_tmo);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_no_device_delay);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_linkdown_tmo);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_nodev_holdio);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_delay_rsp_err);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_check_cond_err);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_nodev_tmo);
-	device_remove_file(&(pdev->dev),
-			   &dev_attr_lpfc_dqfull_throttle_up_time);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_dqfull_throttle_up_inc);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_max_lun);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_lun_skip);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_automap);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_fcp_class);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_use_adisc);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_network_on);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_post_ip_buf);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_xmt_que_size);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_ip_class);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_ack0);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_topology);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_scan_down);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_link_speed);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_cr_delay);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_cr_count);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_fdmi_on);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_fcp_bind_method);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_discovery_threads);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_scsi_req_tmo);
-	device_remove_file(&(pdev->dev), &dev_attr_lpfc_max_target);
+	return 0;
+}
 
-	/*
-	 *  detach the board
+static void
+lpfc_slave_destroy(struct scsi_device *sdev)
+{
+        /*
+	 * Since the driver allocated no memory in lpfc_slave_alloc,
+	 * no resources have to be released here.  Just set the hostdata
+	 * pointer to 0 provided the driver previously set it to a 
+	 * nonzero value.
 	 */
+	sdev->hostdata = NULL;
+}
 
-	psli = &phba->sli;
+static int
+lpfc_biosparam(struct scsi_device *sdev, struct block_device *bdev,
+		sector_t capacity, int ip[])
+{
+	int size = capacity;
 
-	spin_lock_irqsave(&(phba->drvrlock), iflag);
-	while (!list_empty(&phba->timerList)) {
-		clkData = (struct clk_data *)(phba->timerList.next);
-		if (clkData) {
-			cur_timer = clkData->timeObj;
-			del_timer_sync(cur_timer);
-			cur_timer->function = 0;
-			list_del(&clkData->listLink);
-		}
+	ip[0] = 64;
+	ip[1] = 32;
+	ip[2] = size >> 11;
+	if (ip[2] > 1024) {
+		ip[0] = 255;
+		ip[1] = 63;
+		ip[2] = size / (ip[0] * ip[1]);
+#ifndef FC_EXTEND_TRANS_A
+		if (ip[2] > 1023)
+			ip[2] = 1023;
+#endif
 	}
-	
-	spin_unlock_irqrestore(&(phba->drvrlock), iflag);
+	return (0);
+}
 
-	/* Kill the kernel thread for this host */
-	if (phba->dpc_pid >= 0) {
-		phba->dpc_kill = 1;
-		wmb();
-		kill_proc(phba->dpc_pid, SIGHUP, 1);
-		wait_for_completion(&phba->dpc_exiting);
-	}
+static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
+	.name			= LPFC_DRIVER_NAME,
+	.info			= lpfc_info,
+	.queuecommand		= lpfc_queuecommand,
+	.eh_abort_handler	= lpfc_abort_handler,
+	.eh_device_reset_handler= lpfc_reset_lun_handler,
+	.eh_bus_reset_handler	= lpfc_reset_bus_handler,
+	.slave_alloc		= lpfc_slave_alloc,
+	.slave_configure	= lpfc_slave_configure,
+	.slave_destroy		= lpfc_slave_destroy,
+	.bios_param		= lpfc_biosparam,
+	.proc_info		= lpfc_proc_info,
+	.proc_name		= LPFC_DRIVER_NAME,
+	.can_queue		= LPFC_DFT_HBA_Q_DEPTH,
+	.this_id		= -1,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= 30,
+	.use_clustering		= ENABLE_CLUSTERING,
+};
 
+void
+lpfc_setup_slim_access(struct lpfc_hba * arg)
+{
+	struct lpfc_hba *phba;
 
-	scsi_remove_host(phba->host);
-	scsi_host_put(phba->host);
+	phba = (struct lpfc_hba *) arg;
+	phba->MBslimaddr = phba->slim_memmap_p;
+	phba->HAregaddr = (uint32_t *) (phba->ctrl_regs_memmap_p) +
+		HA_REG_OFFSET;
+	phba->HCregaddr = (uint32_t *) (phba->ctrl_regs_memmap_p) +
+		HC_REG_OFFSET;
+	phba->CAregaddr = (uint32_t *) (phba->ctrl_regs_memmap_p) +
+		CA_REG_OFFSET;
+	phba->HSregaddr = (uint32_t *) (phba->ctrl_regs_memmap_p) +
+		HS_REG_OFFSET;
+	return;
+}
 
-	/*
-	 * Bring down the SLI Layer. This step disable all interrupts,
-	 * clears the rings, discards all mailbox commands, and resets
-	 * the HBA.
-	 */
-	lpfc_sli_hba_down(phba);	
 
-	/* Release the irq reservation */
-	free_irq(phba->pcidev->irq, phba);
+uint32_t
+lpfc_intr_prep(struct lpfc_hba * phba)
+{
+	uint32_t ha_copy;
 
-	if (phba->pcidev) {
-		pci_release_regions(phba->pcidev);
-		pci_disable_device(phba->pcidev);
+	/* Ignore all interrupts during initialization. */
+	if (phba->hba_state < LPFC_LINK_DOWN) {
+		return (0);
 	}
 
-	lpfc_cleanup(phba, 0);
-	lpfc_scsi_free(phba);
-	lpfc_mem_free(phba);
-	lpfc_unmemmap(phba);
-
-
-	if (phba->config)
-		kfree(phba->config);
-
-	/* Remove from list of active HBAs */
-	list_del(&phba->hba_list);
-
-	kfree(phba);
+	/* Read host attention register to determine interrupt source */
+	ha_copy = readl(phba->HAregaddr);
 
-	lpfc_num_hba--;
+	/* Clear Attention Sources, except ERATT (to preserve status) & LATT
+	 *    (ha_copy & ~(HA_ERATT | HA_LATT));
+	 */
+	writel((ha_copy & ~(HA_LATT | HA_ERATT)), phba->HAregaddr);
+	return (ha_copy);
+}				/* lpfc_intr_prep */
 
-	pci_set_drvdata(pdev, 0);
 
-	return;
-}
+static int
+lpfc_sli_setup(struct lpfc_hba * phba)
+{
+	int i, totiocb;
+	LPFC_SLI_t *psli;
+	LPFC_RING_INIT_t *pring;
+	struct lpfc_cfgparam *clp;
 
+	psli = &phba->sli;
+	psli->sliinit.num_rings = MAX_CONFIGURED_RINGS;
+	psli->fcp_ring = LPFC_FCP_RING;
+	psli->next_ring = LPFC_FCP_NEXT_RING;
+	psli->ip_ring = LPFC_IP_RING;
 
-/*
- * Retrieve lpfc_hba * matching instance (board no)
- * If found return lpfc_hba *
- * If not found return NULL
- */
-struct lpfc_hba *
-lpfc_get_phba_by_inst(int inst)
-{
-	struct lpfc_hba * phba;
-	int    found = 0;
+	clp = &phba->config[0];
 
-	phba = NULL;
-	list_for_each_entry(phba, &lpfc_hba_list, hba_list) {
-		if (phba->brd_no == inst) {
-			found = 1;
+	totiocb = 0;
+	for (i = 0; i < psli->sliinit.num_rings; i++) {
+		pring = &psli->sliinit.ringinit[i];
+		switch (i) {
+		case LPFC_FCP_RING:	/* ring 0 - FCP */
+			/* numCiocb and numRiocb are used in config_port */
+			pring->numCiocb = SLI2_IOCB_CMD_R0_ENTRIES;
+			pring->numRiocb = SLI2_IOCB_RSP_R0_ENTRIES;
+			pring->numCiocb += SLI2_IOCB_CMD_R1XTRA_ENTRIES;
+			pring->numRiocb += SLI2_IOCB_RSP_R1XTRA_ENTRIES;
+			pring->numCiocb += SLI2_IOCB_CMD_R3XTRA_ENTRIES;
+			pring->numRiocb += SLI2_IOCB_RSP_R3XTRA_ENTRIES;
+			pring->iotag_ctr = 0;
+			pring->iotag_max =
+			    (clp[LPFC_CFG_DFT_HBA_Q_DEPTH].a_current * 2);
+			pring->fast_iotag = pring->iotag_max;
+			pring->num_mask = 0;
+			break;
+		case LPFC_IP_RING:	/* ring 1 - IP */
+			/* numCiocb and numRiocb are used in config_port */
+			pring->numCiocb = SLI2_IOCB_CMD_R1_ENTRIES;
+			pring->numRiocb = SLI2_IOCB_RSP_R1_ENTRIES;
+			pring->num_mask = 0;
+			pring->iotag_ctr = 0;
+			pring->iotag_max = clp[LPFC_CFG_XMT_Q_SIZE].a_current;
+			pring->fast_iotag = 0;
+			break;
+		case LPFC_ELS_RING:	/* ring 2 - ELS / CT */
+			/* numCiocb and numRiocb are used in config_port */
+			pring->numCiocb = SLI2_IOCB_CMD_R2_ENTRIES;
+			pring->numRiocb = SLI2_IOCB_RSP_R2_ENTRIES;
+			pring->fast_iotag = 0;
+			pring->iotag_ctr = 0;
+			pring->iotag_max = 4096;
+			pring->num_mask = 4;
+			pring->prt[0].profile = 0;	/* Mask 0 */
+			pring->prt[0].rctl = FC_ELS_REQ;
+			pring->prt[0].type = FC_ELS_DATA;
+			pring->prt[0].lpfc_sli_rcv_unsol_event =
+			    lpfc_els_unsol_event;
+			pring->prt[1].profile = 0;	/* Mask 1 */
+			pring->prt[1].rctl = FC_ELS_RSP;
+			pring->prt[1].type = FC_ELS_DATA;
+			pring->prt[1].lpfc_sli_rcv_unsol_event =
+			    lpfc_els_unsol_event;
+			pring->prt[2].profile = 0;	/* Mask 2 */
+			/* NameServer Inquiry */
+			pring->prt[2].rctl = FC_UNSOL_CTL;
+			/* NameServer */
+			pring->prt[2].type = FC_COMMON_TRANSPORT_ULP;
+			pring->prt[2].lpfc_sli_rcv_unsol_event =
+			    lpfc_ct_unsol_event;
+			pring->prt[3].profile = 0;	/* Mask 3 */
+			/* NameServer response */
+			pring->prt[3].rctl = FC_SOL_CTL;
+			/* NameServer */
+			pring->prt[3].type = FC_COMMON_TRANSPORT_ULP;
+			pring->prt[3].lpfc_sli_rcv_unsol_event =
+			    lpfc_ct_unsol_event;
 			break;
 		}
+		totiocb += (pring->numCiocb + pring->numRiocb);
 	}
-	
-	if (!found)
-		return(NULL);
-	else
-		return(phba);
-	
-}
-
-const char *
-lpfc_info(struct Scsi_Host *host)
-{
-	struct lpfc_hba    *phba = (struct lpfc_hba *) host->hostdata[0];
-	int len;
-	static char  lpfcinfobuf[128];
-	
-	memset(lpfcinfobuf,0,128);
-	if(phba && phba->pcidev){
-	        lpfc_get_hba_model_desc(phba, 0, lpfcinfobuf);
-		len = strlen(lpfcinfobuf);	
-		snprintf(lpfcinfobuf + len,
-			128-len,
-	       		" on PCI bus %02x device %02x irq %d",
-			phba->pcidev->bus->number,
-		 	phba->pcidev->devfn,
-			phba->pcidev->irq);
+	if (totiocb > MAX_SLI2_IOCB) {
+		/* Too many cmd / rsp ring entries in SLI2 SLIM */
+		lpfc_printf_log(phba,
+			        KERN_ERR,
+			        LOG_INIT,
+			        "0462 Too many cmd / rsp ring entries in SLI2 SLIM Data: x%x x%x",
+			        totiocb, MAX_SLI2_IOCB);
 	}
-	return lpfcinfobuf;
+
+#ifdef USE_HGP_HOST_SLIM
+	psli->sliinit.sli_flag = LPFC_HGP_HOSTSLIM;
+#else
+	psli->sliinit.sli_flag = 0;
+#endif
+
+	return (0);
 }
 
-int
-lpfc_proc_info(struct Scsi_Host *host,
-	       char *buf, char **start, off_t offset, int count, int rw)
+irqreturn_t
+lpfc_intr_handler(int irq, void *dev_id, struct pt_regs * regs)
 {
+	struct lpfc_hba *phba;
+	int intr_status;
 
-	struct lpfc_hba *phba = NULL;
-	struct pci_dev *pdev;
-	char fwrev[32];
-	lpfc_vpd_t *vp;
-	struct lpfc_nodelist *ndlp;
-	int  i, j, incr;
-	char hdw[9];
-	int len = 0, found = 0;
-	
-	/* Sufficient bytes to hold a port or node name. */
-	uint8_t name[sizeof (struct lpfc_name)];
-
-	/* If rw = 0, then read info
-	 * If rw = 1, then write info (NYI)
+	/*
+	 * Get the driver's phba structure from the dev_id and
+	 * assume the HBA is not interrupting.
 	 */
-	if (rw)
-		return -EINVAL;
-
-
-	list_for_each_entry(phba, &lpfc_hba_list, hba_list) {
-		if (phba == (struct lpfc_hba *)host->hostdata[0]) {
-			found = 1;
-			break;
-		}
-	}
+	phba = (struct lpfc_hba *) dev_id;
 
-	if (!found) {
-		return sprintf(buf, "Cannot find adapter for requested host "
-			       "number.\n");
+	if (phba) {
+		/* Call SLI to handle the interrupt event. */
+		intr_status = lpfc_sli_intr(phba);
+		if (intr_status == 0)
+			return IRQ_HANDLED;
 	}
 
-	vp = &phba->vpd;
-	pdev = phba->pcidev;
-
-	len += snprintf(buf, PAGE_SIZE, LPFC_MODULE_DESC "\n");
-
-	len += snprintf(buf + len, PAGE_SIZE-len, "%s\n",
-			lpfc_info(phba->host));
-
-	len += snprintf(buf + len, PAGE_SIZE-len, "SerialNum: %s\n",
-			phba->SerialNumber);
-
-	lpfc_decode_firmware_rev(phba, fwrev, 1);
-	len += snprintf(buf + len, PAGE_SIZE-len, "Firmware Version: %s\n",
-			fwrev);
+	return IRQ_NONE;
 
-	len += snprintf(buf + len, PAGE_SIZE-len, "Hdw: ");
-	/* Convert JEDEC ID to ascii for hardware version */
-	incr = vp->rev.biuRev;
-	for (i = 0; i < 8; i++) {
-		j = (incr & 0xf);
-		if (j <= 9)
-			hdw[7 - i] = (char)((uint8_t) 0x30 + (uint8_t) j);
-		else
-			hdw[7 - i] =
-			    (char)((uint8_t) 0x61 + (uint8_t) (j - 10));
-		incr = (incr >> 4);
-	}
-	hdw[8] = 0;
-	len += snprintf(buf + len, PAGE_SIZE-len, hdw);
+} /* lpfc_intr_handler */
 
-	len += snprintf(buf + len, PAGE_SIZE-len, "\nVendorId: 0x%x\n",
-		       ((((uint32_t) pdev->device) << 16) |
-			(uint32_t) (pdev->vendor)));
+static int
+lpfc_get_bind_type(struct lpfc_hba * phba)
+{
+	int bind_type;
+	struct lpfc_cfgparam *clp;
 
-	/* A Fibre Channel node or port name is 8 octets long and delimited by
-	 * colons.
-	 */
-	len += snprintf(buf + len, PAGE_SIZE-len, "Portname: ");
-	memcpy (&name[0], &phba->fc_portname, sizeof (struct lpfc_name));
-	len += snprintf(buf + len, PAGE_SIZE-len,
-			"%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
-			name[0], name[1], name[2], name[3], name[4], name[5],
-			name[6], name[7]);
+	clp = &phba->config[0];
 
-	len += snprintf(buf + len, PAGE_SIZE-len, "   Nodename: ");
-	memcpy (&name[0], &phba->fc_nodename, sizeof (struct lpfc_name));
-	len += snprintf(buf + len, PAGE_SIZE-len,
-			"%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
-			name[0], name[1], name[2], name[3], name[4], name[5],
-			name[6], name[7]);
+	bind_type = clp[LPFC_CFG_BINDMETHOD].a_current;
 
-	switch (phba->hba_state) {
-	case LPFC_INIT_START:
-	case LPFC_INIT_MBX_CMDS:
-	case LPFC_LINK_DOWN:
-		len += snprintf(buf + len, PAGE_SIZE-len, "\n\nLink Down\n");
+	switch (bind_type) {
+	case 1:
+		phba->fcp_mapping = FCP_SEED_WWNN;
 		break;
-	case LPFC_LINK_UP:
-	case LPFC_LOCAL_CFG_LINK:
-		len += snprintf(buf + len, PAGE_SIZE-len, "\n\nLink Up\n");
+
+	case 2:
+		phba->fcp_mapping = FCP_SEED_WWPN;
 		break;
-	case LPFC_FLOGI:
-	case LPFC_FABRIC_CFG_LINK:
-	case LPFC_NS_REG:
-	case LPFC_NS_QRY:
-	case LPFC_BUILD_DISC_LIST:
-	case LPFC_DISC_AUTH:
-	case LPFC_CLEAR_LA:
-		len += snprintf(buf + len, PAGE_SIZE-len,
-				"\n\nLink Up - Discovery\n");
+
+	case 3:
+		phba->fcp_mapping = FCP_SEED_DID;
 		break;
-	case LPFC_HBA_READY:
-		len += snprintf(buf + len, PAGE_SIZE-len,
-				"\n\nLink Up - Ready:\n");
-		len += snprintf(buf + len, PAGE_SIZE-len, "   PortID 0x%x\n",
-				phba->fc_myDID);
-		if (phba->fc_topology == TOPOLOGY_LOOP) {
-			if (phba->fc_flag & FC_PUBLIC_LOOP)
-				len += snprintf(buf + len, PAGE_SIZE-len,
-						"   Public Loop\n");
-			else
-				len += snprintf(buf + len, PAGE_SIZE-len,
-						"   Private Loop\n");
-		} else {
-			if (phba->fc_flag & FC_FABRIC)
-				len += snprintf(buf + len, PAGE_SIZE-len,
-						"   Fabric\n");
-			else
-				len += snprintf(buf + len, PAGE_SIZE-len,
-						"   Point-2-Point\n");
-		}
 
-		if (phba->fc_linkspeed == LA_2GHZ_LINK)
-			len += snprintf(buf + len, PAGE_SIZE-len,
-					"   Current speed 2G\n");
-		else
-			len += snprintf(buf + len, PAGE_SIZE-len,
-					"   Current speed 1G\n\n");
+	case 4:
+		phba->fcp_mapping = FCP_SEED_DID;
+		break;
+	}
 
-		/* Loop through the list of mapped nodes and dump the known node
-		   information. */
-		list_for_each_entry(ndlp, &phba->fc_nlpmap_list, nlp_listp) {
-			if (ndlp->nlp_state == NLP_STE_MAPPED_NODE){
-				len += snprintf(buf + len, PAGE_SIZE -len,
-						"lpfc%dt%02x DID %06x WWPN ",
-						ndlp->nlp_Target->pHba->brd_no,
-						ndlp->nlp_sid, ndlp->nlp_DID);
+	return 0;
+}
 
-				/* A Fibre Channel node or port name is 8 octets
-				 * long and delimited by colons.
-				 */
-				memcpy (&name[0], &ndlp->nlp_portname,
-					sizeof (struct lpfc_name));
-				len += snprintf(buf + len, PAGE_SIZE-len,
-						"%02x:%02x:%02x:%02x:%02x:%02x:"
-						"%02x:%02x",
-						name[0], name[1], name[2],
-						name[3], name[4], name[5],
-						name[6], name[7]);
+static int
+lpfc_bind_wwpn(struct lpfc_hba * phba, char **arrayp, u_int cnt)
+{
+	uint8_t *datap, *np;
+	struct lpfc_bindlist *blp;
+	struct lpfc_name pn;
+	int i, entry, lpfc_num, rstatus;
+	unsigned int sum;
 
-				len += snprintf(buf + len, PAGE_SIZE-len,
-						" WWNN ");
-				memcpy (&name[0], &ndlp->nlp_nodename,
-					sizeof (struct lpfc_name));
-				len += snprintf(buf + len, PAGE_SIZE-len,
-						"%02x:%02x:%02x:%02x:%02x:%02x:"
-						"%02x:%02x\n",
-						name[0], name[1], name[2],
-						name[3], name[4], name[5],
-						name[6], name[7]);
+	phba->fcp_mapping = FCP_SEED_WWPN;
+	np = (uint8_t *) & pn;
 
-			}
-			if(PAGE_SIZE - len < 90)
+	for (entry = 0; entry < cnt; entry++) {
+		datap = (uint8_t *) arrayp[entry];
+		if (datap == 0)
+			break;
+		/* Determined the number of ASC hex chars in WWNN & WWPN */
+		for (i = 0; i < FC_MAX_WW_NN_PN_STRING; i++) {
+			if (!isxdigit(datap[i]))
 				break;
 		}
+		if ((rstatus = lpfc_parse_binding_entry(phba, datap, np,
+						i, sizeof (struct lpfc_name),
+						LPFC_BIND_WW_NN_PN, &sum, entry,
+						&lpfc_num)) > 0) {
+			if (rstatus == LPFC_SYNTAX_OK_BUT_NOT_THIS_BRD)
+				continue;
+
+			/* For syntax error code definitions see
+			   LPFC_SYNTAX_ERR_ defines. */
+			/* WWPN binding entry <num>: Syntax error code <code> */
+			lpfc_printf_log(phba,
+					KERN_ERR,
+					LOG_INIT,
+					"0430 WWPN binding entry %d: Syntax error code %d",
+					entry, rstatus);
+			goto out;
+		}
 
-		if(&ndlp->nlp_listp != &phba->fc_nlpmap_list)
-			len += snprintf(buf+len, PAGE_SIZE-len, "...\n");
+		/* Loop through all BINDLIST entries and find
+		 * the next available entry.
+		 */
+		if ((blp = mempool_alloc(phba->bind_mem_pool, GFP_ATOMIC))
+		    == 0) {
+			/* WWPN binding entry: node table full */
+			lpfc_printf_log(phba,
+					KERN_ERR,
+					LOG_INIT,
+					"0432 WWPN binding entry: node table full");
+			goto out;
+		}
+		memset(blp, 0, sizeof (struct lpfc_bindlist));
+		blp->nlp_bind_type = FCP_SEED_WWPN;
+		blp->nlp_sid = (sum & 0xff);
+		memcpy(&blp->nlp_portname, (uint8_t *) & pn,
+		       sizeof (struct lpfc_name));
 
+		lpfc_nlp_bind(phba, blp);
+
+out:
+		np = (uint8_t *) & pn;
 	}
-	return (len);
-}
+	return (0);
+}				/* lpfc_bind_wwpn */
 
-static int
-lpfc_reset_bus_handler(struct scsi_cmnd *cmnd)
+	static int
+lpfc_bind_wwnn(struct lpfc_hba * phba, char **arrayp, u_int cnt)
 {
-	struct lpfc_hba *phba;
-	LPFC_SCSI_BUF_t *lpfc_cmd;
-	unsigned long iflag;
-	int rc, tgt, lun;
+	uint8_t *datap, *np;
+	struct lpfc_bindlist *blp;
+	struct lpfc_name pn;
+	int i, entry, lpfc_num, rstatus;
+	unsigned int sum;
 
-	phba = (struct lpfc_hba *) cmnd->device->host->hostdata[0];
-	tgt = cmnd->device->id;
-	lun = cmnd->device->lun;
+	phba->fcp_mapping = FCP_SEED_WWNN;
+	np = (uint8_t *) & pn;
 
-	rc = 0;
-	if ((lpfc_cmd = lpfc_get_scsi_buf(phba, GFP_ATOMIC))) {
-		rc = lpfc_scsi_hba_reset(phba, lpfc_cmd);
-		spin_lock_irqsave(&(phba->drvrlock), iflag);
-		lpfc_free_scsi_buf(lpfc_cmd);
-		spin_unlock_irqrestore(&(phba->drvrlock), iflag);
-	}
-
-	/* SCSI layer issued Bus Reset */
-	lpfc_printf_log(phba,
-		        KERN_ERR,
-		        LOG_FCP,
-		        "0714 SCSI layer issued Bus Reset Data: x%x x%x x%x",
-		        tgt, lun, rc);
-
-
-	return (SUCCESS);
-
-}				/* lpfc_reset_bus_handler */
-
-int
-lpfc_slave_alloc(struct scsi_device *scsi_devs)
-{
-	struct lpfc_hba *phba;
-	struct lpfc_lun *lunp;
-
-	/* Store the lun pointer in the scsi_device hostdata pointer provided
-	 * the driver has already discovered the target/lun id.  Undiscovered
-	 * target/lun information is handled dynamically via the driver's 
-	 * discovery state machine.
-	 */
-	phba = (struct lpfc_hba *) scsi_devs->host->hostdata[0];
-	lunp = lpfc_find_lun(phba, scsi_devs->id, scsi_devs->lun, 1);
-	if (lunp) {
-		scsi_devs->hostdata = lunp;
-	}
-		
-	/* Always return success from this routine since the driver handles
-	 * target/lun discovery and resource allocation dynamically.  Failing
-	 * this call causes the midlayer to dump an error message per target 
-	 * based on conflicting information from the driver.  Although the 
-	 * driver could allocate a target instance here for each scsi device 
-	 * passed by the midlayer, a TUR or SCSI_INQUIRY issued to
-	 * queuecommand would just fail and result in lpfc_slave_destroy freeing
-	 * the memory.  Returning success avoids this situation.
-	 */
-	return 0;
-}
-
-int
-lpfc_slave_configure(struct scsi_device *scsi_devs)
-{
-	struct lpfc_hba *phba = (struct lpfc_hba *)scsi_devs->host->hostdata[0];
-	lpfc_device_queue_depth(phba, scsi_devs);
-	return 0;
-}
-
-void
-lpfc_slave_destroy(struct scsi_device *scsi_devs)
-{
-        /* Since the driver allocated no memory in lpfc_slave_alloc,
-	 * no resources have to be released here.  Just set the hostdata
-	 * pointer to 0 provided the driver previously set it to a 
-	 * nonzero value.
-	 */
-	if (scsi_devs->hostdata != 0) {
-		scsi_devs->hostdata = 0;
-	}
-
-	return;
-}
-
-static int
-lpfc_device_queue_depth(struct lpfc_hba * phba, struct scsi_device *device)
-{
-	struct lpfc_cfgparam *clp;
-
-	clp = &phba->config[0];
+	for (entry = 0; entry < cnt; entry++) {
+		datap = (uint8_t *) arrayp[entry];
+		if (datap == 0)
+			break;
+		/* Determined the number of ASC hex chars in WWNN & WWPN */
+		for (i = 0; i < FC_MAX_WW_NN_PN_STRING; i++) {
+			if (!isxdigit(datap[i]))
+				break;
+		}
+		if ((rstatus = lpfc_parse_binding_entry(phba, datap, np,
+						i, sizeof (struct lpfc_name),
+						LPFC_BIND_WW_NN_PN, &sum, entry,
+						&lpfc_num)) > 0) {
+			if (rstatus == LPFC_SYNTAX_OK_BUT_NOT_THIS_BRD) {
+				continue;
+			}
 
-	if (device->tagged_supported) {
-		device->current_tag = 0;
-		device->queue_depth = clp[LPFC_CFG_DFT_LUN_Q_DEPTH].a_current;
-	} else {
-		device->queue_depth = 16;
-	}
-	return (device->queue_depth);
-}
+			/* For syntax error code definitions see
+			   LPFC_SYNTAX_ERR_ defines. */
+			/* WWNN binding entry <num>: Syntax error code <code> */
+			lpfc_printf_log(phba,
+					KERN_ERR,
+					LOG_INIT,
+					"0431 WWNN binding entry %d: Syntax error code %d",
+					entry, rstatus);
+			goto out;
+		}
 
+		/* Loop through all BINDLIST entries and find
+		 * the next available entry.
+		 */
+		if ((blp = mempool_alloc(phba->bind_mem_pool, GFP_ATOMIC))
+		    == 0) {
+			/* WWNN binding entry: node table full */
+			lpfc_printf_log(phba,
+					KERN_ERR,
+					LOG_INIT,
+					"0433 WWNN binding entry: node table full");
+			goto out;
+		}
+		memset(blp, 0, sizeof (struct lpfc_bindlist));
+		blp->nlp_bind_type = FCP_SEED_WWNN;
+		blp->nlp_sid = (sum & 0xff);
+		memcpy(&blp->nlp_nodename, (uint8_t *) & pn,
+		       sizeof (struct lpfc_name));
+		lpfc_nlp_bind(phba, blp);
 
+out:
+		np = (uint8_t *) & pn;
+	}			/* for loop */
+	return (0);
+}				/* lpfc_bind_wwnn */
 
 static int
-lpfc_memmap(struct lpfc_hba * phba)
+lpfc_bind_did(struct lpfc_hba * phba, char **arrayp, u_int cnt)
 {
-	unsigned long bar0map_len, bar2map_len;
+	uint8_t *datap, *np;
+	struct lpfc_bindlist *blp;
+	D_ID ndid;
+	int i, entry, lpfc_num, rstatus;
+	unsigned int sum;
 
-	if (phba->pcidev == 0)
-		return (1);
+	phba->fcp_mapping = FCP_SEED_DID;
+	ndid.un.word = 0;
+	np = (uint8_t *) & ndid.un.word;
 
-	/* Configure DMA attributes. */
-	if (dma_set_mask(&phba->pcidev->dev, 0xffffffffffffffffULL)) {
-		if (dma_set_mask(&phba->pcidev->dev, 0xffffffffULL)) {
-			return (1);
+	for (entry = 0; entry < cnt; entry++) {
+		datap = (uint8_t *) arrayp[entry];
+		if (datap == 0)
+			break;
+		/* Determined the number of ASC hex chars in DID */
+		for (i = 0; i < FC_MAX_DID_STRING; i++) {
+			if (!isxdigit(datap[i]))
+				break;
 		}
-	}
-
-	/*
-	 * Get the physical address of Bar0 and Bar2 and the number of bytes
-	 * required by each mapping.
-	 */
-	phba->pci_bar0_map = pci_resource_start(phba->pcidev, 0);
-	bar0map_len        = pci_resource_len(phba->pcidev, 0);
-	
-	phba->pci_bar2_map = pci_resource_start(phba->pcidev, 2);
-	bar2map_len        = pci_resource_len(phba->pcidev, 2);
+		if ((rstatus = lpfc_parse_binding_entry(phba, datap, np,
+							i, sizeof (D_ID),
+							LPFC_BIND_DID, &sum,
+							entry,
+							&lpfc_num)) > 0) {
+			if (rstatus == LPFC_SYNTAX_OK_BUT_NOT_THIS_BRD)
+				continue;
 
-	/* Map HBA SLIM and Control Registers to a kernel virtual address. */
-	phba->slim_memmap_p      = ioremap(phba->pci_bar0_map, bar0map_len);
-	phba->ctrl_regs_memmap_p = ioremap(phba->pci_bar2_map, bar2map_len);
+			/* For syntax error code definitions see
+			   LPFC_SYNTAX_ERR_ defines. */
+			/* DID binding entry <num>: Syntax error code <code> */
+			lpfc_printf_log(phba,
+				        KERN_ERR,
+				        LOG_INIT,
+				        "0434 DID binding entry %d: Syntax error code %d",
+				        entry, rstatus);
+			goto out;
+		}
 
-	/* Setup SLI2 interface */
-	if (phba->slim2p.virt == 0) {
-		/*
-		 * Allocate memory for SLI-2 structures
+		/* Loop through all BINDLIST entries and find
+		 * the next available entry.
 		 */
-		phba->slim2p.virt = dma_alloc_coherent(&phba->pcidev->dev,
-						       sizeof (SLI2_SLIM_t),
-						       &(phba->slim2p.phys),
-						       GFP_ATOMIC);
-		
-		if (phba->slim2p.virt == 0) {
-			/* Cleanup adapter SLIM and Control Register
-			   mappings. */
-			iounmap(phba->ctrl_regs_memmap_p);
-			iounmap(phba->slim_memmap_p);
-			return (1);
+		if ((blp = mempool_alloc(phba->bind_mem_pool, GFP_ATOMIC))
+		    == 0) {
+			/* DID binding entry: node table full */
+			lpfc_printf_log(phba,
+				        KERN_ERR,
+				        LOG_INIT,
+				        "0435 DID binding entry: node table full");
+			goto out;
 		}
+		memset(blp, 0, sizeof (struct lpfc_bindlist));
+		blp->nlp_bind_type = FCP_SEED_DID;
+		blp->nlp_sid = (sum & 0xff);
+		blp->nlp_DID = be32_to_cpu(ndid.un.word);
 
-		/* The SLIM2 size is stored in the next field */
-		phba->slim_size = sizeof (SLI2_SLIM_t);
-		memset((char *)phba->slim2p.virt, 0, sizeof (SLI2_SLIM_t));
+		lpfc_nlp_bind(phba, blp);
+
+out:
+
+		np = (uint8_t *) & ndid.un.word;
 	}
 	return (0);
 }
 
-static int
-lpfc_unmemmap(struct lpfc_hba * phba)
+static void
+lpfc_wakeup_event(struct lpfc_hba * phba, fcEVTHDR_t * ep)
 {
-	struct pci_dev *pdev;
-
-	pdev = phba->pcidev;
-
-	/* unmap adapter SLIM and Control Registers */
-	iounmap(phba->ctrl_regs_memmap_p);
-	iounmap(phba->slim_memmap_p);
-	
-	/* Free resources associated with SLI2 interface */
-	if (phba->slim2p.virt) {
-
-		
-		dma_free_coherent(&pdev->dev,
-				  phba->slim_size,
-				  phba->slim2p.virt,
-				  phba->slim2p.phys);
-
+	ep->e_mode &= ~E_SLEEPING_MODE;
+	switch (ep->e_mask) {
+	case FC_REG_LINK_EVENT:
+		wake_up_interruptible(&phba->linkevtwq);
+		break;
+	case FC_REG_RSCN_EVENT:
+		wake_up_interruptible(&phba->rscnevtwq);
+		break;
+	case FC_REG_CT_EVENT:
+		wake_up_interruptible(&phba->ctevtwq);
+		break;
 	}
-	return (0);
+	return;
 }
 
+
 static int
-lpfc_pcimap(struct lpfc_hba * phba)
+lpfc_bind_setup(struct lpfc_hba * phba)
 {
-	struct pci_dev *pdev;
-	int ret_val;
+	struct lpfc_cfgparam *clp;
+	char **arrayp = 0;
+	u_int cnt = 0;
 
 	/*
-	 * PCI for board
-	 */
-	pdev = phba->pcidev;
-	if (!pdev)
-		return (1);
-
-	/* The LPFC HBAs are bus-master capable.  Call the kernel and have this
-	 * functionality enabled.  Note that setting pci bus master also sets
-	 * the latency value as well.  Also turn on MWI so that the cache line
-	 * size is set to match the host pci bridge.
+	 * Check if there are any WWNN / scsid bindings
 	 */
+	clp = &phba->config[0];
 
-	pci_set_master (pdev);
-	ret_val = pci_set_mwi (pdev);
-	if (ret_val != 0) {
-		/* The mwi set operation failed.  This is not a fatal error
-		 * so don't return an error.
-		 */
-	}
+	lpfc_get_bind_type(phba);
 
-	return (0);
-}
-
-void
-lpfc_setup_slim_access(struct lpfc_hba * arg)
-{
-	struct lpfc_hba *phba;
-
-	phba = (struct lpfc_hba *) arg;
-	phba->MBslimaddr = phba->slim_memmap_p;
-	phba->HAregaddr = (uint32_t *) (phba->ctrl_regs_memmap_p) +
-		HA_REG_OFFSET;
-	phba->HCregaddr = (uint32_t *) (phba->ctrl_regs_memmap_p) +
-		HC_REG_OFFSET;
-	phba->CAregaddr = (uint32_t *) (phba->ctrl_regs_memmap_p) +
-		CA_REG_OFFSET;
-	phba->HSregaddr = (uint32_t *) (phba->ctrl_regs_memmap_p) +
-		HS_REG_OFFSET;
-	return;
-}
-
-
-uint32_t
-lpfc_intr_prep(struct lpfc_hba * phba)
-{
-	uint32_t ha_copy;
-
-	/* Ignore all interrupts during initialization. */
-	if (phba->hba_state < LPFC_LINK_DOWN) {
-		return (0);
-	}
-
-	/* Read host attention register to determine interrupt source */
-	ha_copy = readl(phba->HAregaddr);
-
-	/* Clear Attention Sources, except ERATT (to preserve status) & LATT
-	 *    (ha_copy & ~(HA_ERATT | HA_LATT));
-	 */
-	writel((ha_copy & ~(HA_LATT | HA_ERATT)), phba->HAregaddr);
-	return (ha_copy);
-}				/* lpfc_intr_prep */
-
-
-static int
-lpfc_sli_setup(struct lpfc_hba * phba)
-{
-	int i, totiocb;
-	LPFC_SLI_t *psli;
-	LPFC_RING_INIT_t *pring;
-	struct lpfc_cfgparam *clp;
-
-	psli = &phba->sli;
-	psli->sliinit.num_rings = MAX_CONFIGURED_RINGS;
-	psli->fcp_ring = LPFC_FCP_RING;
-	psli->next_ring = LPFC_FCP_NEXT_RING;
-	psli->ip_ring = LPFC_IP_RING;
-
-	clp = &phba->config[0];
-
-	totiocb = 0;
-	for (i = 0; i < psli->sliinit.num_rings; i++) {
-		pring = &psli->sliinit.ringinit[i];
-		switch (i) {
-		case LPFC_FCP_RING:	/* ring 0 - FCP */
-			/* numCiocb and numRiocb are used in config_port */
-			pring->numCiocb = SLI2_IOCB_CMD_R0_ENTRIES;
-			pring->numRiocb = SLI2_IOCB_RSP_R0_ENTRIES;
-			pring->numCiocb += SLI2_IOCB_CMD_R1XTRA_ENTRIES;
-			pring->numRiocb += SLI2_IOCB_RSP_R1XTRA_ENTRIES;
-			pring->numCiocb += SLI2_IOCB_CMD_R3XTRA_ENTRIES;
-			pring->numRiocb += SLI2_IOCB_RSP_R3XTRA_ENTRIES;
-			pring->iotag_ctr = 0;
-			pring->iotag_max =
-			    (clp[LPFC_CFG_DFT_HBA_Q_DEPTH].a_current * 2);
-			pring->fast_iotag = pring->iotag_max;
-			pring->num_mask = 0;
-			break;
-		case LPFC_IP_RING:	/* ring 1 - IP */
-			/* numCiocb and numRiocb are used in config_port */
-			pring->numCiocb = SLI2_IOCB_CMD_R1_ENTRIES;
-			pring->numRiocb = SLI2_IOCB_RSP_R1_ENTRIES;
-			pring->num_mask = 0;
-			pring->iotag_ctr = 0;
-			pring->iotag_max = clp[LPFC_CFG_XMT_Q_SIZE].a_current;
-			pring->fast_iotag = 0;
-			break;
-		case LPFC_ELS_RING:	/* ring 2 - ELS / CT */
-			/* numCiocb and numRiocb are used in config_port */
-			pring->numCiocb = SLI2_IOCB_CMD_R2_ENTRIES;
-			pring->numRiocb = SLI2_IOCB_RSP_R2_ENTRIES;
-			pring->fast_iotag = 0;
-			pring->iotag_ctr = 0;
-			pring->iotag_max = 4096;
-			pring->num_mask = 4;
-			pring->prt[0].profile = 0;	/* Mask 0 */
-			pring->prt[0].rctl = FC_ELS_REQ;
-			pring->prt[0].type = FC_ELS_DATA;
-			pring->prt[0].lpfc_sli_rcv_unsol_event =
-			    lpfc_els_unsol_event;
-			pring->prt[1].profile = 0;	/* Mask 1 */
-			pring->prt[1].rctl = FC_ELS_RSP;
-			pring->prt[1].type = FC_ELS_DATA;
-			pring->prt[1].lpfc_sli_rcv_unsol_event =
-			    lpfc_els_unsol_event;
-			pring->prt[2].profile = 0;	/* Mask 2 */
-			/* NameServer Inquiry */
-			pring->prt[2].rctl = FC_UNSOL_CTL;
-			/* NameServer */
-			pring->prt[2].type = FC_COMMON_TRANSPORT_ULP;
-			pring->prt[2].lpfc_sli_rcv_unsol_event =
-			    lpfc_ct_unsol_event;
-			pring->prt[3].profile = 0;	/* Mask 3 */
-			/* NameServer response */
-			pring->prt[3].rctl = FC_SOL_CTL;
-			/* NameServer */
-			pring->prt[3].type = FC_COMMON_TRANSPORT_ULP;
-			pring->prt[3].lpfc_sli_rcv_unsol_event =
-			    lpfc_ct_unsol_event;
-			break;
-		}
-		totiocb += (pring->numCiocb + pring->numRiocb);
-	}
-	if (totiocb > MAX_SLI2_IOCB) {
-		/* Too many cmd / rsp ring entries in SLI2 SLIM */
-		lpfc_printf_log(phba,
-			        KERN_ERR,
-			        LOG_INIT,
-			        "0462 Too many cmd / rsp ring entries in SLI2 SLIM Data: x%x x%x",
-			        totiocb, MAX_SLI2_IOCB);
-	}
-
-#ifdef USE_HGP_HOST_SLIM
-	psli->sliinit.sli_flag = LPFC_HGP_HOSTSLIM;
-#else
-	psli->sliinit.sli_flag = 0;
-#endif
-
-	return (0);
-}
-
-irqreturn_t
-lpfc_intr_handler(int irq, void *dev_id, struct pt_regs * regs)
-{
-	struct lpfc_hba *phba;
-	int intr_status;
-
-	/*
-	 * Get the driver's phba structure from the dev_id and
-	 * assume the HBA is not interrupting.
-	 */
-	phba = (struct lpfc_hba *) dev_id;
-
-	if (phba) {
-		/* Call SLI to handle the interrupt event. */
-		intr_status = lpfc_sli_intr(phba);
-		if (intr_status == 0)
-			return IRQ_HANDLED;
-	}
-
-	return IRQ_NONE;
-
-} /* lpfc_intr_handler */
-
-static int
-lpfc_bind_setup(struct lpfc_hba * phba)
-{
-	struct lpfc_cfgparam *clp;
-	char **arrayp = 0;
-	u_int cnt = 0;
-
-	/*
-	 * Check if there are any WWNN / scsid bindings
-	 */
-	clp = &phba->config[0];
-
-	lpfc_get_bind_type(phba);
-
-	switch (phba->fcp_mapping) {
-	case FCP_SEED_WWNN:
-		arrayp = lpfc_fcp_bind_WWNN;
-		cnt = 0;
-		while (arrayp[cnt] != 0)
-			cnt++;
-		if (cnt && (*arrayp != 0)) {
-			lpfc_bind_wwnn(phba, arrayp, cnt);
-		}
-		break;
+	switch (phba->fcp_mapping) {
+	case FCP_SEED_WWNN:
+		arrayp = lpfc_fcp_bind_WWNN;
+		cnt = 0;
+		while (arrayp[cnt] != 0)
+			cnt++;
+		if (cnt && (*arrayp != 0)) {
+			lpfc_bind_wwnn(phba, arrayp, cnt);
+		}
+		break;
 
 	case FCP_SEED_WWPN:
 		arrayp = lpfc_fcp_bind_WWPN;
@@ -1436,67 +1035,197 @@ lpfc_bind_setup(struct lpfc_hba * phba)
 	return (0);
 }
 
-/******************************************************************************
-* Function name : lpfc_config_setup
-*
-* Description   : Called from attach to setup configuration parameters for
-*                 adapter
-*                 The goal of this routine is to fill in all the a_current
-*                 members of the CfgParam structure for all configuration
-*                 parameters.
-* Example:
-* clp[LPFC_CFG_XXX].a_current = (uint32_t)value;
-* value might be a define, a global variable, clp[LPFC_CFG_XXX].a_default,
-* or some other enviroment specific way of initializing config parameters.
-******************************************************************************/
-
-static int
-lpfc_config_setup(struct lpfc_hba * phba)
+static uint32_t
+lpfc_get_cfgtkval(const char *string, const char *tk)
 {
-	struct lpfc_cfgparam *clp;
-	LPFC_SLI_t *psli;
-	int i;
-	int brd;
-
-	clp = &phba->config[0];
-	psli = &phba->sli;
-	brd = phba->brd_no;
-
-	/*
-	 * Read the configuration parameters. Also set to default if
-	 * parameter value is out of allowed range.
-	 */
-	for (i = 0; i < LPFC_TOTAL_NUM_OF_CFG_PARAM; i++) {
-		clp[i].a_current = lpfc_get_cfgparam(brd, i);
+	int i=0,ibound,tklen,val=-1;
+	ibound = strlen(string);
+	tklen = strlen(tk);
+	while(i < ibound && strnicmp(string+i,tk,tklen) !=0)
+		i++;
+	i += tklen;
+	if( i < ibound){
+		if (strnicmp(string+i,"0x",2)==0)
+			sscanf(string+i,"0x%x",&val);
+		else
+			sscanf(string+i,"%d",&val);
+	}
+	return val;
+}
 
-		if (i == LPFC_CFG_DFT_HBA_Q_DEPTH)
-			continue;
+static uint32_t
+lpfc_get_cfgnamedparam(int brd, const char *param)
+{
+	uint32_t val = (uint32_t)-1;
+	uint32_t defval = (uint32_t)-1;
+	char tk[16];
+	snprintf(tk, 16, "lpfc:");
+	defval = lpfc_get_cfgtkval(param, tk);
+	snprintf(tk, 16, "lpfc%d:", brd);
+	val = lpfc_get_cfgtkval(param, tk);
+	if( val == -1 && defval != -1)
+		val = defval;
+	return val;
+}
 
-		if ((clp[i].a_current >= clp[i].a_low) &&
-		    (clp[i].a_current <= clp[i].a_hi)) {
-			/* we continue if the range check is satisfied
-			 * however LPFC_CFG_TOPOLOGY has holes and both
-			 * LPFC_CFG_FCP_CLASS AND LPFC_CFG_IP_CLASS need
-			 * to readjusted iff they satisfy the range check
-			 */
-			if (i == LPFC_CFG_TOPOLOGY) {
-				/* odd values 1,3,5 are out */
-				if (!(clp[i].a_current & 1))
-					continue;
-			} else if ((i == LPFC_CFG_FCP_CLASS)
-				   || (i == LPFC_CFG_IP_CLASS)) {
-				switch (clp[i].a_current) {
-				case 2:
-					/* CLASS2 = 1 */
-					clp[i].a_current = CLASS2;
-					break;
-				case 3:
-					/* CLASS3 = 2 */
-					clp[i].a_current = CLASS3;
-					break;
-				}
-				continue;
-			} else
+static uint32_t
+lpfc_get_cfgparam(int brd, int param)
+{
+	uint32_t value = (uint32_t)-1;
+	
+	switch (param) {
+	case LPFC_CFG_LOG_VERBOSE:	/* log-verbose */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_log_verbose);
+		break;
+	case LPFC_CFG_AUTOMAP:	/* automap */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_automap);
+		break;
+	case LPFC_CFG_BINDMETHOD:	/* bind-method */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_fcp_bind_method);
+		break;
+	case LPFC_CFG_CR_DELAY:	/* cr_delay */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_cr_delay);
+		break;
+	case LPFC_CFG_CR_COUNT:	/* cr_count */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_cr_count);
+		break;
+	case LPFC_CFG_DFT_TGT_Q_DEPTH:	/* tgt_queue_depth */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_tgt_queue_depth);
+		break;
+	case LPFC_CFG_DFT_LUN_Q_DEPTH:	/* lun_queue_depth */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_lun_queue_depth);
+		break;
+	case LPFC_CFG_EXTRA_IO_TMO:	/* fcpfabric-tmo */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_extra_io_tmo);
+		break;
+	case LPFC_CFG_FCP_CLASS:	/* fcp-class */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_fcp_class);
+		break;
+	case LPFC_CFG_USE_ADISC:	/* use-adisc */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_use_adisc);
+		break;
+	case LPFC_CFG_NO_DEVICE_DELAY:	/* no-device-delay */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_no_device_delay);
+		break;
+	case LPFC_CFG_NETWORK_ON:	/* network-on */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_network_on);
+		break;
+	case LPFC_CFG_POST_IP_BUF:	/* post-ip-buf */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_post_ip_buf);
+		break;
+	case LPFC_CFG_XMT_Q_SIZE:	/* xmt-que-size */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_xmt_que_size);
+		break;
+	case LPFC_CFG_IP_CLASS:	/* ip-class */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_ip_class);
+		break;
+	case LPFC_CFG_ACK0:	/* ack0 */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_ack0);
+		break;
+	case LPFC_CFG_TOPOLOGY:	/* topology */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_topology);
+		break;
+	case LPFC_CFG_SCAN_DOWN:	/* scan-down */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_scan_down);
+		break;
+	case LPFC_CFG_LINKDOWN_TMO:	/* linkdown-tmo */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_linkdown_tmo);
+		break;
+	case LPFC_CFG_HOLDIO:	/* nodev-holdio */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_nodev_holdio);
+		break;
+	case LPFC_CFG_DELAY_RSP_ERR:	/* delay-rsp-err */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_delay_rsp_err);
+		break;
+	case LPFC_CFG_CHK_COND_ERR:	/* check-cond-err */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_check_cond_err);
+		break;
+	case LPFC_CFG_NODEV_TMO:	/* nodev-tmo */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_nodev_tmo);
+		break;
+	case LPFC_CFG_LINK_SPEED:	/* link-speed */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_link_speed);
+		break;
+	case LPFC_CFG_DQFULL_THROTTLE_UP_TIME:	/* dqfull-throttle-up-time */
+		value = lpfc_get_cfgnamedparam(brd,
+					       lpfc_dqfull_throttle_up_time);
+		break;
+	case LPFC_CFG_DQFULL_THROTTLE_UP_INC:	/* dqfull-throttle-up-inc */
+		value = lpfc_get_cfgnamedparam(brd,
+					       lpfc_dqfull_throttle_up_inc);
+		break;
+	case LPFC_CFG_FDMI_ON:	/* fdmi-on */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_fdmi_on);
+		break;
+	case LPFC_CFG_MAX_LUN:	/* max-lun */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_max_lun);
+		break;
+	case LPFC_CFG_DISC_THREADS:	/* discovery-threads */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_discovery_threads);
+		break;
+	case LPFC_CFG_MAX_TARGET:	/* max-target */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_max_target);
+		break;
+	case LPFC_CFG_SCSI_REQ_TMO:	/* scsi-req-tmo */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_scsi_req_tmo);
+		break;
+	case LPFC_CFG_LUN_SKIP:	/* lun-skip */
+		value = lpfc_get_cfgnamedparam(brd, lpfc_lun_skip);
+		break;
+	default:
+		break;
+	}
+
+	return (value);
+}
+
+static int
+lpfc_config_setup(struct lpfc_hba * phba)
+{
+	struct lpfc_cfgparam *clp;
+	LPFC_SLI_t *psli;
+	int i;
+	int brd;
+
+	clp = &phba->config[0];
+	psli = &phba->sli;
+	brd = phba->brd_no;
+
+	/*
+	 * Read the configuration parameters. Also set to default if
+	 * parameter value is out of allowed range.
+	 */
+	for (i = 0; i < LPFC_TOTAL_NUM_OF_CFG_PARAM; i++) {
+		clp[i].a_current = lpfc_get_cfgparam(brd, i);
+
+		if (i == LPFC_CFG_DFT_HBA_Q_DEPTH)
+			continue;
+
+		if ((clp[i].a_current >= clp[i].a_low) &&
+		    (clp[i].a_current <= clp[i].a_hi)) {
+			/* we continue if the range check is satisfied
+			 * however LPFC_CFG_TOPOLOGY has holes and both
+			 * LPFC_CFG_FCP_CLASS AND LPFC_CFG_IP_CLASS need
+			 * to readjusted iff they satisfy the range check
+			 */
+			if (i == LPFC_CFG_TOPOLOGY) {
+				/* odd values 1,3,5 are out */
+				if (!(clp[i].a_current & 1))
+					continue;
+			} else if ((i == LPFC_CFG_FCP_CLASS)
+				   || (i == LPFC_CFG_IP_CLASS)) {
+				switch (clp[i].a_current) {
+				case 2:
+					/* CLASS2 = 1 */
+					clp[i].a_current = CLASS2;
+					break;
+				case 3:
+					/* CLASS3 = 2 */
+					clp[i].a_current = CLASS3;
+					break;
+				}
+				continue;
+			} else
 				continue;
 		}
 
@@ -1543,288 +1272,42 @@ lpfc_config_setup(struct lpfc_hba * phba
 	return (0);
 }
 
-static int
-lpfc_bind_wwpn(struct lpfc_hba * phba, char **arrayp, u_int cnt)
+int
+lpfc_put_event(struct lpfc_hba * phba,
+	      uint32_t evcode, uint32_t evdata0, void *evdata1, void *evdata2)
 {
-	uint8_t *datap, *np;
-	struct lpfc_bindlist *blp;
-	struct lpfc_name pn;
-	int i, entry, lpfc_num, rstatus;
-	unsigned int sum;
+	fcEVT_t *ep;
+	fcEVT_t *oep;
+	fcEVTHDR_t *ehp = 0;
+	int found;
+	DMABUF_t *mp;
+	void *fstype;
+	struct lpfc_sli_ct_request *ctp;
 
-	phba->fcp_mapping = FCP_SEED_WWPN;
-	np = (uint8_t *) & pn;
+	ehp = (fcEVTHDR_t *) phba->fc_evt_head;
+	fstype = 0;
+	switch (evcode) {
+	case FC_REG_CT_EVENT:
+		mp = (DMABUF_t *) evdata1;
+		ctp = (struct lpfc_sli_ct_request *) mp->virt;
+		fstype = (void *)(ulong) (ctp->FsType);
+		break;
+	}
 
-	for (entry = 0; entry < cnt; entry++) {
-		datap = (uint8_t *) arrayp[entry];
-		if (datap == 0)
+	while (ehp) {
+		if ((ehp->e_mask == evcode) && (ehp->e_type == fstype))
 			break;
-		/* Determined the number of ASC hex chars in WWNN & WWPN */
-		for (i = 0; i < FC_MAX_WW_NN_PN_STRING; i++) {
-			if (!isxdigit(datap[i]))
-				break;
-		}
-		if ((rstatus = lpfc_parse_binding_entry(phba, datap, np,
-						i, sizeof (struct lpfc_name),
-						LPFC_BIND_WW_NN_PN, &sum, entry,
-						&lpfc_num)) > 0) {
-			if (rstatus == LPFC_SYNTAX_OK_BUT_NOT_THIS_BRD)
-				continue;
-
-			/* For syntax error code definitions see
-			   LPFC_SYNTAX_ERR_ defines. */
-			/* WWPN binding entry <num>: Syntax error code <code> */
-			lpfc_printf_log(phba,
-					KERN_ERR,
-					LOG_INIT,
-					"0430 WWPN binding entry %d: Syntax error code %d",
-					entry, rstatus);
-			goto out;
-		}
-
-		/* Loop through all BINDLIST entries and find
-		 * the next available entry.
-		 */
-		if ((blp = mempool_alloc(phba->bind_mem_pool, GFP_ATOMIC))
-		    == 0) {
-			/* WWPN binding entry: node table full */
-			lpfc_printf_log(phba,
-					KERN_ERR,
-					LOG_INIT,
-					"0432 WWPN binding entry: node table full");
-			goto out;
-		}
-		memset(blp, 0, sizeof (struct lpfc_bindlist));
-		blp->nlp_bind_type = FCP_SEED_WWPN;
-		blp->nlp_sid = (sum & 0xff);
-		memcpy(&blp->nlp_portname, (uint8_t *) & pn,
-		       sizeof (struct lpfc_name));
-
-		lpfc_nlp_bind(phba, blp);
-
-out:
-		np = (uint8_t *) & pn;
+		
+		ehp = (fcEVTHDR_t *) ehp->e_next_header;
 	}
-	return (0);
-}				/* lpfc_bind_wwpn */
 
-static int
-lpfc_get_bind_type(struct lpfc_hba * phba)
-{
-	int bind_type;
-	struct lpfc_cfgparam *clp;
-
-	clp = &phba->config[0];
+	if (!ehp) {
+		return (0);
+	}
 
-	bind_type = clp[LPFC_CFG_BINDMETHOD].a_current;
-
-	switch (bind_type) {
-	case 1:
-		phba->fcp_mapping = FCP_SEED_WWNN;
-		break;
-
-	case 2:
-		phba->fcp_mapping = FCP_SEED_WWPN;
-		break;
-
-	case 3:
-		phba->fcp_mapping = FCP_SEED_DID;
-		break;
-
-	case 4:
-		phba->fcp_mapping = FCP_SEED_DID;
-		break;
-	}
-
-	return 0;
-}
-
-static int
-lpfc_bind_wwnn(struct lpfc_hba * phba, char **arrayp, u_int cnt)
-{
-	uint8_t *datap, *np;
-	struct lpfc_bindlist *blp;
-	struct lpfc_name pn;
-	int i, entry, lpfc_num, rstatus;
-	unsigned int sum;
-
-	phba->fcp_mapping = FCP_SEED_WWNN;
-	np = (uint8_t *) & pn;
-
-	for (entry = 0; entry < cnt; entry++) {
-		datap = (uint8_t *) arrayp[entry];
-		if (datap == 0)
-			break;
-		/* Determined the number of ASC hex chars in WWNN & WWPN */
-		for (i = 0; i < FC_MAX_WW_NN_PN_STRING; i++) {
-			if (!isxdigit(datap[i]))
-				break;
-		}
-		if ((rstatus = lpfc_parse_binding_entry(phba, datap, np,
-						i, sizeof (struct lpfc_name),
-						LPFC_BIND_WW_NN_PN, &sum, entry,
-						&lpfc_num)) > 0) {
-			if (rstatus == LPFC_SYNTAX_OK_BUT_NOT_THIS_BRD) {
-				continue;
-			}
-
-			/* For syntax error code definitions see
-			   LPFC_SYNTAX_ERR_ defines. */
-			/* WWNN binding entry <num>: Syntax error code <code> */
-			lpfc_printf_log(phba,
-					KERN_ERR,
-					LOG_INIT,
-					"0431 WWNN binding entry %d: Syntax error code %d",
-					entry, rstatus);
-			goto out;
-		}
-
-		/* Loop through all BINDLIST entries and find
-		 * the next available entry.
-		 */
-		if ((blp = mempool_alloc(phba->bind_mem_pool, GFP_ATOMIC))
-		    == 0) {
-			/* WWNN binding entry: node table full */
-			lpfc_printf_log(phba,
-					KERN_ERR,
-					LOG_INIT,
-					"0433 WWNN binding entry: node table full");
-			goto out;
-		}
-		memset(blp, 0, sizeof (struct lpfc_bindlist));
-		blp->nlp_bind_type = FCP_SEED_WWNN;
-		blp->nlp_sid = (sum & 0xff);
-		memcpy(&blp->nlp_nodename, (uint8_t *) & pn,
-		       sizeof (struct lpfc_name));
-		lpfc_nlp_bind(phba, blp);
-
-out:
-		np = (uint8_t *) & pn;
-	}			/* for loop */
-	return (0);
-}				/* lpfc_bind_wwnn */
-
-static int
-lpfc_bind_did(struct lpfc_hba * phba, char **arrayp, u_int cnt)
-{
-	uint8_t *datap, *np;
-	struct lpfc_bindlist *blp;
-	D_ID ndid;
-	int i, entry, lpfc_num, rstatus;
-	unsigned int sum;
-
-	phba->fcp_mapping = FCP_SEED_DID;
-	ndid.un.word = 0;
-	np = (uint8_t *) & ndid.un.word;
-
-	for (entry = 0; entry < cnt; entry++) {
-		datap = (uint8_t *) arrayp[entry];
-		if (datap == 0)
-			break;
-		/* Determined the number of ASC hex chars in DID */
-		for (i = 0; i < FC_MAX_DID_STRING; i++) {
-			if (!isxdigit(datap[i]))
-				break;
-		}
-		if ((rstatus = lpfc_parse_binding_entry(phba, datap, np,
-							i, sizeof (D_ID),
-							LPFC_BIND_DID, &sum,
-							entry,
-							&lpfc_num)) > 0) {
-			if (rstatus == LPFC_SYNTAX_OK_BUT_NOT_THIS_BRD)
-				continue;
-
-			/* For syntax error code definitions see
-			   LPFC_SYNTAX_ERR_ defines. */
-			/* DID binding entry <num>: Syntax error code <code> */
-			lpfc_printf_log(phba,
-				        KERN_ERR,
-				        LOG_INIT,
-				        "0434 DID binding entry %d: Syntax error code %d",
-				        entry, rstatus);
-			goto out;
-		}
-
-		/* Loop through all BINDLIST entries and find
-		 * the next available entry.
-		 */
-		if ((blp = mempool_alloc(phba->bind_mem_pool, GFP_ATOMIC))
-		    == 0) {
-			/* DID binding entry: node table full */
-			lpfc_printf_log(phba,
-				        KERN_ERR,
-				        LOG_INIT,
-				        "0435 DID binding entry: node table full");
-			goto out;
-		}
-		memset(blp, 0, sizeof (struct lpfc_bindlist));
-		blp->nlp_bind_type = FCP_SEED_DID;
-		blp->nlp_sid = (sum & 0xff);
-		blp->nlp_DID = be32_to_cpu(ndid.un.word);
-
-		lpfc_nlp_bind(phba, blp);
-
-out:
-
-		np = (uint8_t *) & ndid.un.word;
-	}
-	return (0);
-}
-
-static void
-lpfc_wakeup_event(struct lpfc_hba * phba, fcEVTHDR_t * ep)
-{
-	ep->e_mode &= ~E_SLEEPING_MODE;
-	switch (ep->e_mask) {
-	case FC_REG_LINK_EVENT:
-		wake_up_interruptible(&phba->linkevtwq);
-		break;
-	case FC_REG_RSCN_EVENT:
-		wake_up_interruptible(&phba->rscnevtwq);
-		break;
-	case FC_REG_CT_EVENT:
-		wake_up_interruptible(&phba->ctevtwq);
-		break;
-	}
-	return;
-}
-
-int
-lpfc_put_event(struct lpfc_hba * phba,
-	      uint32_t evcode, uint32_t evdata0, void *evdata1, void *evdata2)
-{
-	fcEVT_t *ep;
-	fcEVT_t *oep;
-	fcEVTHDR_t *ehp = 0;
-	int found;
-	DMABUF_t *mp;
-	void *fstype;
-	struct lpfc_sli_ct_request *ctp;
-
-	ehp = (fcEVTHDR_t *) phba->fc_evt_head;
-	fstype = 0;
-	switch (evcode) {
-	case FC_REG_CT_EVENT:
-		mp = (DMABUF_t *) evdata1;
-		ctp = (struct lpfc_sli_ct_request *) mp->virt;
-		fstype = (void *)(ulong) (ctp->FsType);
-		break;
-	}
-
-	while (ehp) {
-		if ((ehp->e_mask == evcode) && (ehp->e_type == fstype))
-			break;
-		
-		ehp = (fcEVTHDR_t *) ehp->e_next_header;
-	}
-
-	if (!ehp) {
-		return (0);
-	}
-
-	ep = ehp->e_head;
-	oep = 0;
-	found = 0;
+	ep = ehp->e_head;
+	oep = 0;
+	found = 0;
 
 	while (ep && !(found)) {
 		if (ep->evt_sleep) {
@@ -1899,157 +1382,630 @@ lpfc_hba_put_event(struct lpfc_hba * phb
 	return (0);
 }
 
-static uint32_t
-lpfc_get_cfgtkval(const char *string, const char *tk)
-{
-	int i=0,ibound,tklen,val=-1;
-	ibound = strlen(string);
-	tklen = strlen(tk);
-	while(i < ibound && strnicmp(string+i,tk,tklen) !=0)
-		i++;
-	i += tklen;
-	if( i < ibound){
-		if (strnicmp(string+i,"0x",2)==0)
-			sscanf(string+i,"0x%x",&val);
-		else
-			sscanf(string+i,"%d",&val);
-	}
-	return val;
-}
-static uint32_t
-lpfc_get_cfgnamedparam(int brd, const char *param)
+void
+lpfc_nodev(unsigned long l)
 {
-	uint32_t val = (uint32_t)-1;
-	uint32_t defval = (uint32_t)-1;
-	char tk[16];
-	snprintf(tk, 16, "lpfc:");
-	defval = lpfc_get_cfgtkval(param, tk);
-	snprintf(tk, 16, "lpfc%d:", brd);
-	val = lpfc_get_cfgtkval(param, tk);
-	if( val == -1 && defval != -1)
-		val = defval;
-	return val;
+	return;
 }
 
-static uint32_t
-lpfc_get_cfgparam(int brd, int param)
+/*
+ * This is only called to handle FC discovery events. Since this a rare
+ * occurance, we allocate an LPFC_DISC_EVT_t structure here instead of
+ * embedding it in the IOCB.
+ */
+int
+lpfc_discq_post_event(struct lpfc_hba * phba, void *arg1, void *arg2,
+		      uint32_t evt)
 {
-	uint32_t value = (uint32_t)-1;
-	
-	switch (param) {
-	case LPFC_CFG_LOG_VERBOSE:	/* log-verbose */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_log_verbose);
-		break;
-	case LPFC_CFG_AUTOMAP:	/* automap */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_automap);
-		break;
-	case LPFC_CFG_BINDMETHOD:	/* bind-method */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_fcp_bind_method);
-		break;
-	case LPFC_CFG_CR_DELAY:	/* cr_delay */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_cr_delay);
-		break;
-	case LPFC_CFG_CR_COUNT:	/* cr_count */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_cr_count);
-		break;
-	case LPFC_CFG_DFT_TGT_Q_DEPTH:	/* tgt_queue_depth */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_tgt_queue_depth);
-		break;
-	case LPFC_CFG_DFT_LUN_Q_DEPTH:	/* lun_queue_depth */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_lun_queue_depth);
-		break;
-	case LPFC_CFG_EXTRA_IO_TMO:	/* fcpfabric-tmo */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_extra_io_tmo);
-		break;
-	case LPFC_CFG_FCP_CLASS:	/* fcp-class */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_fcp_class);
-		break;
-	case LPFC_CFG_USE_ADISC:	/* use-adisc */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_use_adisc);
-		break;
-	case LPFC_CFG_NO_DEVICE_DELAY:	/* no-device-delay */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_no_device_delay);
-		break;
-	case LPFC_CFG_NETWORK_ON:	/* network-on */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_network_on);
-		break;
-	case LPFC_CFG_POST_IP_BUF:	/* post-ip-buf */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_post_ip_buf);
-		break;
-	case LPFC_CFG_XMT_Q_SIZE:	/* xmt-que-size */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_xmt_que_size);
-		break;
-	case LPFC_CFG_IP_CLASS:	/* ip-class */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_ip_class);
-		break;
-	case LPFC_CFG_ACK0:	/* ack0 */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_ack0);
-		break;
-	case LPFC_CFG_TOPOLOGY:	/* topology */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_topology);
-		break;
-	case LPFC_CFG_SCAN_DOWN:	/* scan-down */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_scan_down);
-		break;
-	case LPFC_CFG_LINKDOWN_TMO:	/* linkdown-tmo */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_linkdown_tmo);
-		break;
-	case LPFC_CFG_HOLDIO:	/* nodev-holdio */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_nodev_holdio);
-		break;
-	case LPFC_CFG_DELAY_RSP_ERR:	/* delay-rsp-err */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_delay_rsp_err);
-		break;
-	case LPFC_CFG_CHK_COND_ERR:	/* check-cond-err */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_check_cond_err);
-		break;
-	case LPFC_CFG_NODEV_TMO:	/* nodev-tmo */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_nodev_tmo);
-		break;
-	case LPFC_CFG_LINK_SPEED:	/* link-speed */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_link_speed);
-		break;
-	case LPFC_CFG_DQFULL_THROTTLE_UP_TIME:	/* dqfull-throttle-up-time */
-		value = lpfc_get_cfgnamedparam(brd,
-					       lpfc_dqfull_throttle_up_time);
-		break;
-	case LPFC_CFG_DQFULL_THROTTLE_UP_INC:	/* dqfull-throttle-up-inc */
-		value = lpfc_get_cfgnamedparam(brd,
-					       lpfc_dqfull_throttle_up_inc);
-		break;
-	case LPFC_CFG_FDMI_ON:	/* fdmi-on */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_fdmi_on);
-		break;
-	case LPFC_CFG_MAX_LUN:	/* max-lun */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_max_lun);
-		break;
-	case LPFC_CFG_DISC_THREADS:	/* discovery-threads */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_discovery_threads);
-		break;
-	case LPFC_CFG_MAX_TARGET:	/* max-target */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_max_target);
-		break;
-	case LPFC_CFG_SCSI_REQ_TMO:	/* scsi-req-tmo */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_scsi_req_tmo);
-		break;
-	case LPFC_CFG_LUN_SKIP:	/* lun-skip */
-		value = lpfc_get_cfgnamedparam(brd, lpfc_lun_skip);
-		break;
-	default:
-		break;
+	LPFC_DISC_EVT_t  *evtp;
+	unsigned long flags;
+
+	/* All Mailbox completions and LPFC_ELS_RING rcv ring IOCB events
+	 * will be queued to DPC for processing
+	 */
+	evtp = (LPFC_DISC_EVT_t *) kmalloc(sizeof(LPFC_DISC_EVT_t), GFP_ATOMIC);
+	if(evtp == 0) {
+		return (0);
+	}
+	evtp->evt_arg1  = arg1;
+	evtp->evt_arg2  = arg2;
+	evtp->evt       = evt;
+	evtp->evt_listp.next = 0;
+	evtp->evt_listp.prev = 0;
+
+	/* Queue the event to the DPC to be processed later */
+	spin_lock_irqsave(&phba->dpc_lock, flags);
+	list_add_tail(&evtp->evt_listp, &phba->dpc_disc);
+	spin_unlock_irqrestore(&phba->dpc_lock, flags);
+	if(phba->dpc_wait) {
+		up(phba->dpc_wait);
+	}
+
+	return (1);
+}
+
+
+static void
+lpfc_evt_iocb_free(struct lpfc_hba * phba, struct lpfc_iocbq * saveq)
+{
+	struct lpfc_iocbq  *rspiocbp, *tmpiocbp;
+
+	/* Free up iocb buffer chain for cmd just processed */
+	list_for_each_entry_safe(rspiocbp, tmpiocbp,
+		&saveq->list, list) {
+		list_del(&rspiocbp->list);
+		mempool_free( rspiocbp, phba->iocb_mem_pool);
+	}
+	mempool_free( saveq, phba->iocb_mem_pool);
+}
+
+int
+lpfc_disc_done(struct lpfc_hba * phba)
+{
+	LPFC_SLI_t       * psli;
+	LPFC_DISC_EVT_t  * evtp, *next_evtp;
+	LPFC_MBOXQ_t     * pmb;
+	struct lpfc_iocbq     * cmdiocbp;
+	struct lpfc_iocbq     * saveq;
+	LPFC_RING_MASK_t * func;
+	LIST_HEAD(local_dpc_disc);
+	unsigned long      flags;
+
+	psli = &phba->sli;
+	spin_lock_irqsave(&phba->dpc_lock, flags);
+	list_splice_init(&phba->dpc_disc, &local_dpc_disc);
+	spin_unlock_irqrestore(&phba->dpc_lock, flags);
+	/* check discovery event list */
+	list_for_each_entry_safe(evtp, next_evtp, &local_dpc_disc, evt_listp) {
+		list_del(&evtp->evt_listp);
+
+		spin_lock_irqsave(&(phba->drvrlock), flags);
+		switch(evtp->evt) {
+		case LPFC_EVT_MBOX:
+			pmb = (LPFC_MBOXQ_t *)(evtp->evt_arg1);
+			(pmb->mbox_cmpl) (phba, pmb);
+			break;
+		case LPFC_EVT_SOL_IOCB:
+			cmdiocbp = (struct lpfc_iocbq *)(evtp->evt_arg1);
+			saveq = (struct lpfc_iocbq *)(evtp->evt_arg2);
+			(cmdiocbp->iocb_cmpl) (phba, cmdiocbp, saveq);
+			lpfc_evt_iocb_free(phba, saveq);
+			break;
+		case LPFC_EVT_UNSOL_IOCB:
+			func = (LPFC_RING_MASK_t *)(evtp->evt_arg1);
+			saveq = (struct lpfc_iocbq *)(evtp->evt_arg2);
+			(func->lpfc_sli_rcv_unsol_event) (phba,
+	 		&psli->ring[LPFC_ELS_RING], saveq);
+			lpfc_evt_iocb_free(phba, saveq);
+			break;
+		}
+		spin_unlock_irqrestore(&(phba->drvrlock), flags);
+
+		kfree(evtp);
+	}
+	return(0);
+}
+
+static int
+lpfc_do_dpc(void *p)
+{
+	DECLARE_MUTEX_LOCKED(sem);
+	struct lpfc_hba        * phba = (struct lpfc_hba *)p;
+	unsigned long      flags;
+
+	lock_kernel();
+
+	daemonize("lpfc_dpc_%d", phba->brd_no);
+	allow_signal(SIGHUP);
+
+	phba->dpc_wait = &sem;
+	set_user_nice(current, -20);
+
+	unlock_kernel();
+
+	complete(&phba->dpc_startup);
+
+	while (1) {
+		if (down_interruptible(&sem))
+			break;
+
+		if (signal_pending(current) )
+			break;
+
+		if (phba->dpc_kill)
+			break;
+
+		spin_lock_irqsave(&phba->dpc_lock, flags);
+		if (!list_empty(&phba->dpc_disc)) {
+			spin_unlock_irqrestore(&phba->dpc_lock, flags);
+			lpfc_disc_done(phba);
+		}
+		else {
+			spin_unlock_irqrestore(&phba->dpc_lock, flags);
+		}
+	}
+	/*
+	* Zero out semaphore we were waiting on.
+	*/
+	phba->dpc_wait = NULL;
+
+	complete_and_exit(&phba->dpc_exiting, 0);
+
+	return(0);
+}
+
+static int __devinit
+lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
+{
+	struct Scsi_Host *host;
+	struct lpfc_hba *phba;
+	struct lpfc_cfgparam *clp;
+	struct clk_data *clkData;
+	unsigned long iflag;
+	uint32_t timeout;
+	struct timer_list *cur_timer;
+	unsigned long bar0map_len, bar2map_len;
+	int error = -ENODEV, i;
+	
+	if (pci_enable_device(pdev))
+		goto out;
+	if (pci_request_regions(pdev, LPFC_DRIVER_NAME))
+		goto out_disable_device;
+
+	/*
+	 * Allocate space for adapter info structure
+	 */
+	phba = kmalloc(sizeof(*phba), GFP_KERNEL);
+	if (!phba)
+		goto out_release_regions;
+
+	memset(phba, 0, sizeof (struct lpfc_hba));
+	INIT_LIST_HEAD(&phba->timerList);
+
+	error = -ENOMEM;
+	/* Initialize default values for configuration parameters */
+	phba->config = kmalloc(sizeof(*phba->config), GFP_KERNEL);
+	if (!phba)
+		goto out_kfree_phba;
+
+	memset(phba->config, 0, sizeof(lpfc_icfgparam));
+	memcpy(&phba->config[0], &lpfc_icfgparam[0], sizeof(lpfc_icfgparam));
+
+	clp = &phba->config[0];
+
+	/* Set everything to the defaults */
+	for (i = 0; i < LPFC_TOTAL_NUM_OF_CFG_PARAM; i++)
+		clp[i].a_current = clp[i].a_default;
+	
+	/* Assign an unused board number */
+	i = 0;
+	while (1) {
+		if (lpfc_get_phba_by_inst(i) == NULL ) {
+			phba->brd_no = i;
+			break;
+		}
+		i++;
+	}
+
+	/* Add adapter structure to list */
+	list_add_tail(&phba->hba_list, &lpfc_hba_list);
+
+	/* Initialize all internally managed lists. */
+	INIT_LIST_HEAD(&phba->fc_nlpmap_list);
+	INIT_LIST_HEAD(&phba->fc_nlpunmap_list);
+	INIT_LIST_HEAD(&phba->fc_plogi_list);
+	INIT_LIST_HEAD(&phba->fc_adisc_list);
+	INIT_LIST_HEAD(&phba->fc_nlpbind_list);
+
+	/* Initialize plxhba - LINUX specific */
+	phba->pcidev = pdev;
+	init_waitqueue_head(&phba->linkevtwq);
+	init_waitqueue_head(&phba->rscnevtwq);
+	init_waitqueue_head(&phba->ctevtwq);
+
+	pci_set_master(pdev);
+	pci_set_mwi(pdev);
+
+	/* Configure DMA attributes. */
+	if (dma_set_mask(&phba->pcidev->dev, 0xffffffffffffffffULL) &&
+	    dma_set_mask(&phba->pcidev->dev, 0xffffffffULL))
+		goto out_list_del;
+
+	/*
+	 * Get the physical address of Bar0 and Bar2 and the number of bytes
+	 * required by each mapping.
+	 */
+	phba->pci_bar0_map = pci_resource_start(phba->pcidev, 0);
+	bar0map_len        = pci_resource_len(phba->pcidev, 0);
+	
+	phba->pci_bar2_map = pci_resource_start(phba->pcidev, 2);
+	bar2map_len        = pci_resource_len(phba->pcidev, 2);
+
+	/* Map HBA SLIM and Control Registers to a kernel virtual address. */
+	phba->slim_memmap_p      = ioremap(phba->pci_bar0_map, bar0map_len);
+	phba->ctrl_regs_memmap_p = ioremap(phba->pci_bar2_map, bar2map_len);
+
+	/* Setup SLI2 interface */
+	if (!phba->slim2p.virt) {
+		/*
+		 * Allocate memory for SLI-2 structures
+		 */
+		phba->slim2p.virt = dma_alloc_coherent(&phba->pcidev->dev,
+						       sizeof (SLI2_SLIM_t),
+						       &(phba->slim2p.phys),
+						       GFP_ATOMIC);
+		if (!phba->slim2p.virt)
+			goto out_iounmap;
+
+		/* The SLIM2 size is stored in the next field */
+		phba->slim_size = sizeof (SLI2_SLIM_t);
+		memset(phba->slim2p.virt, 0, sizeof (SLI2_SLIM_t));
+	}
+
+	lpfc_num_hba++;
+	lpfc_config_setup(phba);	/* Setup configuration parameters */
+
+	/*
+	 * If the t.o value is not set, set it to 30
+	 */
+	if (clp[LPFC_CFG_SCSI_REQ_TMO].a_current == 0) {
+		clp[LPFC_CFG_SCSI_REQ_TMO].a_current = 30;
+	}
+
+	if (clp[LPFC_CFG_DISC_THREADS].a_current) {
+		/*
+		 * Set to FC_NLP_REQ if automap is set to 0 since order of
+		 * discovery does not matter if everything is persistently
+		 * bound.
+		 */
+		if (clp[LPFC_CFG_AUTOMAP].a_current == 0) {
+			clp[LPFC_CFG_DISC_THREADS].a_current =
+			    LPFC_MAX_DISC_THREADS;
+		}
+	}
+
+	/* Initialize all per HBA locks */
+	spin_lock_init(&phba->drvrlock);
+	spin_lock_init(&phba->hiprilock);
+
+	lpfc_sli_setup(phba);	/* Setup SLI Layer to run over lpfc HBAs */
+	lpfc_sli_queue_setup(phba);	/* Initialize the SLI Layer */
+
+	if (!lpfc_mem_alloc(phba))
+		goto out_dec_nhbas;
+
+	lpfc_bind_setup(phba);	/* Setup binding configuration parameters */
+
+	/* Initialize HBA structure */
+	phba->fc_edtov = FF_DEF_EDTOV;
+	phba->fc_ratov = FF_DEF_RATOV;
+	phba->fc_altov = FF_DEF_ALTOV;
+	phba->fc_arbtov = FF_DEF_ARBTOV;
+
+	/* Set the FARP and XRI timeout values now since they depend on
+	   fc_ratov. */
+	phba->fc_ipfarp_timeout = (3 * phba->fc_ratov);
+	phba->fc_ipxri_timeout = (3 * phba->fc_ratov);
+
+	spin_lock_init(&phba->dpc_lock);
+	INIT_LIST_HEAD(&phba->dpc_disc);
+	init_completion(&phba->dpc_startup);
+	init_completion(&phba->dpc_exiting);
+
+	/*
+	* Startup the kernel thread for this host adapter
+	*/
+	phba->dpc_kill = 0;
+	phba->dpc_pid = kernel_thread(lpfc_do_dpc, phba, 0);
+	if (phba->dpc_pid < 0) {
+		error = phba->dpc_pid;
+		goto out_free_mem;
+	}
+	wait_for_completion(&phba->dpc_startup);
+
+	/* Call SLI to initialize the HBA. */
+	/* Eek, this returns positive error codes, --hch */
+	error = -lpfc_sli_hba_setup(phba);
+	if (error)
+		goto out_hba_down;
+
+	/* Register this board */
+	host = scsi_host_alloc(&driver_template, sizeof (unsigned long));
+	if (!host) {
+		printk (KERN_WARNING "%s%d: scsi_host_alloc failed during "
+			"attach\n", lpfc_drvr_name, phba->brd_no);
+		error = -ENOMEM;
+		goto out_cleanup_timers;
+	}
+
+	phba->host = host;
+	host->can_queue = clp[LPFC_CFG_DFT_HBA_Q_DEPTH].a_current - 10;
+
+	/*
+	 * Adjust the number of id's
+	 * Although max_id is an int, target id's are unsined chars
+	 * Do not exceed 255, otherwise the device scan will wrap around
+	 */
+	if (clp[LPFC_CFG_MAX_TARGET].a_current > LPFC_MAX_TARGET)
+		clp[LPFC_CFG_MAX_TARGET].a_current = LPFC_DFT_MAX_TARGET;
+
+	host->max_id = clp[LPFC_CFG_MAX_TARGET].a_current;
+	host->unique_id = lpfc_num_hba;
+
+	if (clp[LPFC_CFG_MAX_LUN].a_current > LPFC_MAX_LUN)
+		clp[LPFC_CFG_MAX_LUN].a_current = LPFC_DFT_MAX_LUN;
+	host->max_lun = clp[LPFC_CFG_MAX_LUN].a_current;
+
+	/* Adapter ID - tell midlayer not to reserve an ID for us */
+	host->this_id = -1;
+
+	/*
+	 * Setup the scsi timeout handler with a
+	 * timeout value = greater of (2*RATOV, 5).
+	 */
+	timeout = (phba->fc_ratov << 1) > 5 ? (phba->fc_ratov << 1) : 5;
+	phba->scsi_tmo_data.timeObj = &phba->scsi_tmofunc;
+	phba->scsi_tmo_data.phba = phba;
+	phba->scsi_tmo_data.clData1 = (unsigned long)timeout;
+	init_timer(&phba->scsi_tmofunc);
+	phba->scsi_tmofunc.function = lpfc_scsi_timeout_handler;
+	phba->scsi_tmofunc.expires = jiffies + HZ * timeout;
+	phba->scsi_tmofunc.data = (unsigned long)&phba->scsi_tmo_data;
+	list_add(&phba->scsi_tmo_data.listLink, &phba->timerList);
+	add_timer(&phba->scsi_tmofunc);
+
+
+	/*
+	 * Starting with 2.4.0 kernel, Linux can support commands longer
+	 * than 12 bytes. However, scsi_register() always sets it to 12.
+	 * For it to be useful to the midlayer, we have to set it here.
+	 */
+	host->max_cmd_len = 16;
+
+	/*
+	 * Queue depths per lun
+	 */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,6)
+	host->transportt = lpfc_transport_template;
+#endif
+	host->hostdata[0] = (unsigned long)phba;
+	pci_set_drvdata(pdev, host);
+
+	error = scsi_add_host(host, &pdev->dev);
+	if (error)
+		goto out_put_host;
+
+	device_create_file(&(pdev->dev), &dev_attr_info);
+	device_create_file(&(pdev->dev), &dev_attr_serialnum);
+	device_create_file(&(pdev->dev), &dev_attr_fwrev);
+	device_create_file(&(pdev->dev), &dev_attr_hdw);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_log_verbose);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_tgt_queue_depth);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_lun_queue_depth);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_extra_io_tmo);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_no_device_delay);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_linkdown_tmo);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_nodev_holdio);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_delay_rsp_err);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_check_cond_err);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_nodev_tmo);
+	device_create_file(&(pdev->dev),
+			   &dev_attr_lpfc_dqfull_throttle_up_time);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_dqfull_throttle_up_inc);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_max_lun);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_lun_skip);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_automap);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_fcp_class);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_use_adisc);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_network_on);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_post_ip_buf);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_xmt_que_size);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_ip_class);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_ack0);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_topology);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_scan_down);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_link_speed);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_cr_delay);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_cr_count);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_fdmi_on);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_fcp_bind_method);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_discovery_threads);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_scsi_req_tmo);
+	device_create_file(&(pdev->dev), &dev_attr_lpfc_max_target);
+
+	scsi_scan_host(host);
+	return 0;
+
+ out_put_host:
+	scsi_host_put(host);
+ out_hba_down:
+	lpfc_sli_hba_down(phba);
+
+ out_cleanup_timers:
+	/* Stop any timers that were started during this attach. */
+	spin_lock_irqsave(&(phba->drvrlock), iflag);
+	while (!list_empty(&phba->timerList)) {
+		clkData = (struct clk_data *)(phba->timerList.next);
+		if (clkData) {
+			cur_timer = clkData->timeObj;
+			del_timer_sync(cur_timer);
+			cur_timer->function = 0;
+			list_del(&clkData->listLink);
+		}
+	}
+	spin_unlock_irqrestore(&(phba->drvrlock), iflag);
+
+	/* Kill the kernel thread for this host */
+	if (phba->dpc_pid >= 0) {
+		phba->dpc_kill = 1;
+		wmb();
+		kill_proc(phba->dpc_pid, SIGHUP, 1);
+		wait_for_completion(&phba->dpc_exiting);
+	}
+
+	free_irq(phba->pcidev->irq, phba);
+ out_free_mem:
+	lpfc_mem_free(phba);
+ out_dec_nhbas:
+	lpfc_num_hba--;
+	if (phba->slim2p.virt) {
+		dma_free_coherent(&pdev->dev,
+				  phba->slim_size,
+				  phba->slim2p.virt,
+				  phba->slim2p.phys);
+	}
+ out_iounmap:
+	iounmap(phba->ctrl_regs_memmap_p);
+	iounmap(phba->slim_memmap_p);
+ out_list_del:
+	list_del_init(&phba->hba_list);
+	kfree(phba->config);
+ out_kfree_phba:
+	kfree(phba);
+ out_release_regions:
+	pci_release_regions(pdev);
+ out_disable_device:
+	pci_disable_device(pdev);	
+ out:
+	return error;
+}
+
+static void __devexit
+lpfc_pci_remove_one(struct pci_dev *pdev)
+{
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = (struct lpfc_hba *)host->hostdata[0];
+	struct clk_data *clkData;
+	struct timer_list *cur_timer;
+	unsigned long iflag;
+
+	scsi_remove_host(phba->host);
+	list_del(&phba->hba_list);
+
+	device_remove_file(&(pdev->dev), &dev_attr_info);
+	device_remove_file(&(pdev->dev), &dev_attr_serialnum);
+	device_remove_file(&(pdev->dev), &dev_attr_fwrev);
+	device_remove_file(&(pdev->dev), &dev_attr_hdw);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_log_verbose);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_tgt_queue_depth);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_lun_queue_depth);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_extra_io_tmo);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_no_device_delay);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_linkdown_tmo);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_nodev_holdio);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_delay_rsp_err);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_check_cond_err);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_nodev_tmo);
+	device_remove_file(&(pdev->dev),
+			   &dev_attr_lpfc_dqfull_throttle_up_time);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_dqfull_throttle_up_inc);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_max_lun);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_lun_skip);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_automap);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_fcp_class);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_use_adisc);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_network_on);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_post_ip_buf);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_xmt_que_size);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_ip_class);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_ack0);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_topology);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_scan_down);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_link_speed);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_cr_delay);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_cr_count);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_fdmi_on);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_fcp_bind_method);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_discovery_threads);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_scsi_req_tmo);
+	device_remove_file(&(pdev->dev), &dev_attr_lpfc_max_target);
+
+	spin_lock_irqsave(&(phba->drvrlock), iflag);
+	while (!list_empty(&phba->timerList)) {
+		clkData = (struct clk_data *)(phba->timerList.next);
+		if (clkData) {
+			cur_timer = clkData->timeObj;
+			del_timer_sync(cur_timer);
+			cur_timer->function = 0;
+			list_del(&clkData->listLink);
+		}
 	}
+	spin_unlock_irqrestore(&(phba->drvrlock), iflag);
 
-	return (value);
-}
+	/* Kill the kernel thread for this host */
+	if (phba->dpc_pid >= 0) {
+		phba->dpc_kill = 1;
+		wmb();
+		kill_proc(phba->dpc_pid, SIGHUP, 1);
+		wait_for_completion(&phba->dpc_exiting);
+	}
+
+	/*
+	 * Bring down the SLI Layer. This step disable all interrupts,
+	 * clears the rings, discards all mailbox commands, and resets
+	 * the HBA.
+	 */
+	lpfc_sli_hba_down(phba);	
+
+	/* Release the irq reservation */
+	free_irq(phba->pcidev->irq, phba);
+
+	lpfc_cleanup(phba, 0);
+	lpfc_scsi_free(phba);
+	lpfc_mem_free(phba);
+
+	/* Free resources associated with SLI2 interface */
+	if (phba->slim2p.virt) {
+		dma_free_coherent(&pdev->dev,
+				  phba->slim_size,
+				  phba->slim2p.virt,
+				  phba->slim2p.phys);
+
+	}
+
+	/* unmap adapter SLIM and Control Registers */
+	iounmap(phba->ctrl_regs_memmap_p);
+	iounmap(phba->slim_memmap_p);
+
+	pci_release_regions(phba->pcidev);
+	pci_disable_device(phba->pcidev);
 
+	kfree(phba->config);
+	kfree(phba);
 
+	scsi_host_put(phba->host);
+	pci_set_drvdata(pdev, 0);
+	lpfc_num_hba--;
+}
 
+static struct pci_device_id lpfc_id_table[] = {
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_VIPER,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_THOR,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PEGASUS,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_CENTAUR,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_DRAGONFLY,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SUPERFLY,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_RFLY,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PFLY,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_TFLY,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, lpfc_id_table);
 
 static struct pci_driver lpfc_driver = {
-	.name = LPFC_DRIVER_NAME,
-	.id_table = lpfc_id_table,
-	.probe = lpfc_pci_probe_one,
-	.remove = __devexit_p(lpfc_pci_remove_one),
+	.name		= LPFC_DRIVER_NAME,
+	.id_table	= lpfc_id_table,
+	.probe		= lpfc_pci_probe_one,
+	.remove		= __devexit_p(lpfc_pci_remove_one),
 };
 
 static int __init
@@ -2059,20 +2015,15 @@ lpfc_init(void)
 
 	printk(LPFC_MODULE_DESC "\n");
 
-	lpfc_loadtime = jiffies;
-
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,6)
 	lpfc_transport_template =
 		fc_attach_transport(&lpfc_transport_functions);
-	if(!lpfc_transport_template)
+	if (!lpfc_transport_template)
 		return -ENODEV;
 #endif
 	rc = pci_module_init(&lpfc_driver);
-	
-	if(rc == 0)
+	if (!rc)
 		driver_create_file(&(lpfc_driver.driver), &driver_attr_version);
-	
-	
 	return rc;
 
 }
@@ -2086,182 +2037,10 @@ lpfc_exit(void)
 #endif
 }
 
-static int
-lpfc_biosparam(struct scsi_device *psdev,
-	      struct block_device *pbdev, sector_t capacity, int ip[])
-{
-	int size = capacity;
-
-	ip[0] = 64;
-	ip[1] = 32;
-	ip[2] = size >> 11;
-	if (ip[2] > 1024) {
-		ip[0] = 255;
-		ip[1] = 63;
-		ip[2] = size / (ip[0] * ip[1]);
-#ifndef FC_EXTEND_TRANS_A
-		if (ip[2] > 1023)
-			ip[2] = 1023;
-#endif
-	}
-	return (0);
-}
-
-
-void
-lpfc_nodev(unsigned long l)
-{
-	return;
-}
-
-
-
-/*
- * This is only called to handle FC discovery events. Since this a rare
- * occurance, we allocate an LPFC_DISC_EVT_t structure here instead of
- * embedding it in the IOCB.
- */
-int
-lpfc_discq_post_event(struct lpfc_hba * phba, void *arg1, void *arg2,
-		      uint32_t evt)
-{
-	LPFC_DISC_EVT_t  *evtp;
-	unsigned long flags;
-
-	/* All Mailbox completions and LPFC_ELS_RING rcv ring IOCB events
-	 * will be queued to DPC for processing
-	 */
-	evtp = (LPFC_DISC_EVT_t *) kmalloc(sizeof(LPFC_DISC_EVT_t), GFP_ATOMIC);
-	if(evtp == 0) {
-		return (0);
-	}
-	evtp->evt_arg1  = arg1;
-	evtp->evt_arg2  = arg2;
-	evtp->evt       = evt;
-	evtp->evt_listp.next = 0;
-	evtp->evt_listp.prev = 0;
-
-	/* Queue the event to the DPC to be processed later */
-	spin_lock_irqsave(&phba->dpc_lock, flags);
-	list_add_tail(&evtp->evt_listp, &phba->dpc_disc);
-	spin_unlock_irqrestore(&phba->dpc_lock, flags);
-	if(phba->dpc_wait) {
-		up(phba->dpc_wait);
-	}
-
-	return (1);
-}
-
-
-static void
-lpfc_evt_iocb_free(struct lpfc_hba * phba, struct lpfc_iocbq * saveq)
-{
-	struct lpfc_iocbq  *rspiocbp, *tmpiocbp;
-
-	/* Free up iocb buffer chain for cmd just processed */
-	list_for_each_entry_safe(rspiocbp, tmpiocbp,
-		&saveq->list, list) {
-		list_del(&rspiocbp->list);
-		mempool_free( rspiocbp, phba->iocb_mem_pool);
-	}
-	mempool_free( saveq, phba->iocb_mem_pool);
-}
-
-int
-lpfc_disc_done(struct lpfc_hba * phba)
-{
-	LPFC_SLI_t       * psli;
-	LPFC_DISC_EVT_t  * evtp, *next_evtp;
-	LPFC_MBOXQ_t     * pmb;
-	struct lpfc_iocbq     * cmdiocbp;
-	struct lpfc_iocbq     * saveq;
-	LPFC_RING_MASK_t * func;
-	LIST_HEAD(local_dpc_disc);
-	unsigned long      flags;
-
-	psli = &phba->sli;
-	spin_lock_irqsave(&phba->dpc_lock, flags);
-	list_splice_init(&phba->dpc_disc, &local_dpc_disc);
-	spin_unlock_irqrestore(&phba->dpc_lock, flags);
-	/* check discovery event list */
-	list_for_each_entry_safe(evtp, next_evtp, &local_dpc_disc, evt_listp) {
-		list_del(&evtp->evt_listp);
-
-		spin_lock_irqsave(&(phba->drvrlock), flags);
-		switch(evtp->evt) {
-		case LPFC_EVT_MBOX:
-			pmb = (LPFC_MBOXQ_t *)(evtp->evt_arg1);
-			(pmb->mbox_cmpl) (phba, pmb);
-			break;
-		case LPFC_EVT_SOL_IOCB:
-			cmdiocbp = (struct lpfc_iocbq *)(evtp->evt_arg1);
-			saveq = (struct lpfc_iocbq *)(evtp->evt_arg2);
-			(cmdiocbp->iocb_cmpl) (phba, cmdiocbp, saveq);
-			lpfc_evt_iocb_free(phba, saveq);
-			break;
-		case LPFC_EVT_UNSOL_IOCB:
-			func = (LPFC_RING_MASK_t *)(evtp->evt_arg1);
-			saveq = (struct lpfc_iocbq *)(evtp->evt_arg2);
-			(func->lpfc_sli_rcv_unsol_event) (phba,
-	 		&psli->ring[LPFC_ELS_RING], saveq);
-			lpfc_evt_iocb_free(phba, saveq);
-			break;
-		}
-		spin_unlock_irqrestore(&(phba->drvrlock), flags);
-
-		kfree(evtp);
-	}
-	return(0);
-}
-
-static int
-lpfc_do_dpc(void *p)
-{
-	DECLARE_MUTEX_LOCKED(sem);
-	struct lpfc_hba        * phba = (struct lpfc_hba *)p;
-	unsigned long      flags;
-
-	lock_kernel();
-
-	daemonize("lpfc_dpc_%d", phba->brd_no);
-	allow_signal(SIGHUP);
-
-	phba->dpc_wait = &sem;
-	set_user_nice(current, -20);
-
-	unlock_kernel();
-
-	complete(&phba->dpc_startup);
-
-	while (1) {
-		if (down_interruptible(&sem))
-			break;
-
-		if (signal_pending(current) )
-			break;
-
-		if (phba->dpc_kill)
-			break;
-
-		spin_lock_irqsave(&phba->dpc_lock, flags);
-		if (!list_empty(&phba->dpc_disc)) {
-			spin_unlock_irqrestore(&phba->dpc_lock, flags);
-			lpfc_disc_done(phba);
-		}
-		else {
-			spin_unlock_irqrestore(&phba->dpc_lock, flags);
-		}
-	}
-	/*
-	* Zero out semaphore we were waiting on.
-	*/
-	phba->dpc_wait = NULL;
-
-	complete_and_exit(&phba->dpc_exiting, 0);
-
-	return(0);
-}
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION(LPFC_MODULE_DESC);
+MODULE_AUTHOR("Emulex Corporation - tech.support@emulex.com");
+MODULE_VERSION("0:" LPFC_DRIVER_VERSION);
 
 module_init(lpfc_init);
 module_exit(lpfc_exit);
-MODULE_LICENSE("GPL");
