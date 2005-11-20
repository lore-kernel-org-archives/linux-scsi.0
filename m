From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] allow HW iSCSI cards to hook into iscsi class
Date: Sun, 20 Nov 2005 14:36:31 -0600
Message-ID: <1132518991.7006.10.camel@max>
References: <1132518580.7006.2.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46977 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750800AbVKTUgi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Nov 2005 15:36:38 -0500
In-Reply-To: <1132518580.7006.2.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org

On Sun, 2005-11-20 at 14:29 -0600, Mike Christie wrote:
> This patch was made against mainline. open-iscsi svn users should
> go here http://www.cs.wisc.edu/~michaelc/iscsi/open-iscsi/transport-class/v2/
> I also did a basic test patch for ql4xx to see how it would begin to
> look (this patch is not usable though since qlogic was using
> the old transport class and I do not have the resources ATM to
> backport it (still need uptodate source too).



Here is a patch to begin to integrate ql4xxx. It is no where near complete.
All it does is convert the probe function. Although at this point the
new class code should be usable by ql4xxx. ql4xxx just needs to be converted.


TODO: convert queuecommand and eh (when iscsi based eh is added) and update
ql4_attr.c.



Patch made against last Andrew's patchset sent. Not tested (no HW) or even
compile tested (just lazy becuase there is much to fix yet).

--- drivers/scsi/qla4xxx/ql4_os.c	2005-09-06 15:46:45.000000000 -0500
+++ drivers.work/scsi/qla4xxx/ql4_os.c	2005-11-19 17:31:00.000000000 -0600
@@ -177,13 +177,14 @@ static struct scsi_host_template qla4xxx
 
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
+	.can_queue		= REQUEST_QUEUE_DEPTH + 128;
 	.use_clustering		= ENABLE_CLUSTERING,
 	.sg_tablesize		= SG_ALL,
 
 	.max_sectors		= 0xFFFF,
 };
 
-/* static struct scsi_transport_template *qla4xxx_transport_template = NULL; */
+static struct scsi_transport_template *qla4xxx_transport_template;
 
 /*
  * Timer routines
@@ -373,7 +374,7 @@ static int __devinit
 qla4xxx_probe_adapter(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int ret = -ENODEV, status;
-	struct Scsi_Host *host;
+	struct iscsi_host *host;
 	scsi_qla_host_t *ha;
 	uint8_t init_retry_count = 0;
 	unsigned long flags;
@@ -381,8 +382,11 @@ qla4xxx_probe_adapter(struct pci_dev *pd
 	if (pci_enable_device(pdev))
 		return -1;
 
-	host = scsi_host_alloc(&qla4xxx_driver_template,
-	    sizeof(scsi_qla_host_t));
+	qla4xxx_transport_functions.host_template = &qla4xxx_driver_template;
+	qla4xxx_transport_functions.ihostdata_size = sizeof(scsi_qla_host_t);
+
+	host = iscsi_alloc_iscsi_host(&qla4xxx_transport_functions,
+				      &qla4xxx_transport_template);
 	if (host == NULL) {
 		printk(KERN_WARNING
 		       "qla4xxx: Couldn't allocate host from scsi layer!\n");
@@ -390,13 +394,14 @@ qla4xxx_probe_adapter(struct pci_dev *pd
 	}
 
 	/* Clear our data area */
-	ha = (scsi_qla_host_t *) host->hostdata;
+	ha = host->dd_data;
 	memset(ha, 0, sizeof(scsi_qla_host_t));
 
 	/* Save the information from PCI BIOS.  */
 	ha->pdev = pdev;
 	ha->host = host;
-	ha->host_no = host->host_no;
+	/* Not sure what to do here. Should probably just kill it */
+	ha->host_no = 0;
 
 	/* Configure PCI I/O space. */
 	ret = qla4xxx_iospace_config(ha);
@@ -467,16 +472,6 @@ qla4xxx_probe_adapter(struct pci_dev *pd
 		goto probe_failed;
 	}
 
-	host->cmd_per_lun = 3;
-	host->max_channel = 0;
-	host->max_lun = MAX_LUNS - 1;
-	host->max_id = MAX_TARGETS;
-	host->unique_id = ha->instance;
-	host->max_cmd_len = IOCB_MAX_CDB_LEN;
-	host->can_queue = REQUEST_QUEUE_DEPTH + 128;
-/* FIXME */
-/*	host->transportt = qla4xxx_transport_template; */
-
 	/* Startup the kernel thread for this host adapter. */
 	DEBUG2(printk("scsi: %s: Starting kernel thread for "
 		      "qla4xxx_dpc\n", __func__));
@@ -499,7 +494,6 @@ qla4xxx_probe_adapter(struct pci_dev *pd
 		goto probe_failed;
 	}
 	set_bit(AF_IRQ_ATTACHED, &ha->flags);
-	host->irq = pdev->irq;
 	DEBUG(printk("scsi%d: irq %d attached\n", ha->host_no, ha->pdev->irq));
 
 	qla4xxx_enable_intrs(ha);
@@ -519,7 +513,7 @@ qla4xxx_probe_adapter(struct pci_dev *pd
 
 	pci_set_drvdata(pdev, ha);
 
-	ret = scsi_add_host(host, &pdev->dev);
+	ret = iscsi_add_iscsi_host(host, &pdev->dev, NULL);
 	if (ret)
 		goto probe_failed;
 
@@ -533,13 +527,18 @@ qla4xxx_probe_adapter(struct pci_dev *pd
 	    ha->host_no, ha->firmware_version[0], ha->firmware_version[1],
 	    ha->patch_number, ha->build_number);
 
+	/*
+	The transport class (or userspace hotplug agent listening for session
+	and connection hotplug events will initiate the scan for each session
+
 	scsi_scan_host(host);
+	*/
 
 	return 0;
 
 probe_failed:
 	qla4xxx_free_adapter(ha);
-
+	iscsi_host_put(host);
 probe_disable_device:
 	pci_disable_device(pdev);
 
@@ -567,11 +566,11 @@ qla4xxx_remove_adapter(struct pci_dev *p
 	list_del_init(&ha->list);
 	write_unlock(&qla4xxx_hostlist_lock);
 
-	scsi_remove_host(ha->host);
+	iscsi_remove_iscsi_host(ha->host);
 
 	qla4xxx_free_adapter(ha);
 
-	scsi_host_put(ha->host);
+	iscsi_host_put(ha->host);
 
 	pci_set_drvdata(pdev, NULL);
 }
@@ -2271,7 +2270,11 @@ struct pci_driver qla4xxx_pci_driver = {
 static int __init
 qla4xxx_module_init(void)
 {
-	int ret;
+	int ret = -ENOMEM;
+
+	qla4xxx_transport_template = iscsi_register_transport(&qla4xxx_transport_functions);
+	if (!ql4xxx_transport_template)
+		return -ENOMEM;
 
 	/* Allocate cache for SRBs. */
 	srb_cachep = kmem_cache_create("qla4xxx_srbs", sizeof(srb_t), 0,
@@ -2279,7 +2282,7 @@ qla4xxx_module_init(void)
 	if (srb_cachep == NULL) {
 		printk(KERN_ERR
 		    "qla4xxx: Unable to allocate SRB cache...Failing load!\n");
-		return -ENOMEM;
+		goto unregister_transport;
 	}
 
 	/* Derive version string. */
@@ -2290,9 +2293,15 @@ qla4xxx_module_init(void)
 	printk(KERN_INFO "QLogic iSCSI HBA Driver\n");
 	ret = pci_module_init(&qla4xxx_pci_driver);
 	if (ret)
-		kmem_cache_destroy(srb_cachep);
+		goto free_srb_cache;
 
 	return ret;
+
+free_srb_cache:
+	kmem_cache_destroy(srb_cachep);
+unregister_transport:
+	iscsi_unregister_transport(&qla4xxx_transport_functions);
+	return ret;
 }
 
 static void __exit
@@ -2300,6 +2309,7 @@ qla4xxx_module_exit(void)
 {
 	pci_unregister_driver(&qla4xxx_pci_driver);
 	kmem_cache_destroy(srb_cachep);
+	iscsi_unregister_transport(&qla4xxx_transport_functions);
 }
 
 module_init(qla4xxx_module_init);


