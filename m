From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: PATCH [2/5]  qla2xxx: add remote port codes...
Date: Fri, 20 May 2005 08:15:42 -0700
Message-ID: <20050520151542.GA17419@plap.qlogic.org>
References: <20050413191548.GI9703@plap.qlogic.org> <20050413191824.GK9703@plap.qlogic.org> <20050413214023.GA18161@infradead.org> <20050419072751.GD5999@plap.qlogic.org> <20050520061736.GA11551@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:57496 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261479AbVETPPp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2005 11:15:45 -0400
Content-Disposition: inline
In-Reply-To: <20050520061736.GA11551@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Thu, 19 May 2005, Jeremy Higdon wrote:

> On Tue, Apr 19, 2005 at 12:27:51AM -0700, Andrew Vasquez wrote:
> > On Wed, 13 Apr 2005, Christoph Hellwig wrote:
> > 
> > > >  	atomic_set(&fcport->state, FCS_ONLINE);
> > > > +	if (ha->flags.init_done)
> > > > +		qla2x00_reg_remote_port(ha, fcport);
> > > >  }
> > > 
> > > ...
> > > 
> > > > -		goto probe_failed;
> > > > +		goto probe_alloc_failed;
> > > >  	}
> > > >  
> > > > +	pci_set_drvdata(pdev, ha);
> > > > +	host->this_id = 255;
> > > > +	host->cmd_per_lun = 3;
> > > > +	host->unique_id = ha->instance;
> > > > +	host->max_cmd_len = MAX_CMDSZ;
> > > > +	host->max_channel = ha->ports - 1;
> > > > +	host->max_id = ha->max_targets;
> > > > +	host->max_lun = ha->max_luns;
> > > > +	host->transportt = qla2xxx_transport_template;
> > > > +	if (scsi_add_host(host, &pdev->dev))
> > > > +		goto probe_alloc_failed;
> > > > +
> > > > +	qla2x00_alloc_sysfs_attr(ha);
> > > > +
> > > >  	if (qla2x00_initialize_adapter(ha) &&
> > > >  	    !(ha->device_flags & DFLG_NO_CABLE)) {
> > > 
> > > Now this I don't undersant.  You're moving the host registration earlier,
> > > maybe too earlier but I haven't checked that yet,
> > >
> > 
> > Yeah, that hunk is a residual of some other (trashy) changes I made
> > during early fc_rport integration and really should be reverted back
> > to the original...
> 
> In fact, it seems to break probing for luns other than zero.
> 
> You initialize ha->max_luns in qla2x00_nvram_config(), which is called form
> qla2x00_initialize_adapter().  So we're currently seeing messages like
> this during ISP2312 initialization:
> 
> <4>scsi: host 1 channel 0 id 0 lun1 has a LUN larger than allowed by the host adapter

Jeremy, could you try this patch out.

James, please apply.


[PATCH] Pull-down scsi-host-addition to follow board initialization.

Return to previous held-logic of calling scsi_add_host() only after
the board has been completely initialized.  Also return pci_*()
error-codes during probe failure paths.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

drivers/scsi/qla2xxx/qla_os.c: 7f8d747bd5e546e3b753ce06e3568f32d0a0ec07
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1106,7 +1106,7 @@ iospace_error_exit:
  */
 int qla2x00_probe_one(struct pci_dev *pdev, struct qla_board_info *brd_info)
 {
-	int	ret;
+	int	ret = -ENODEV;
 	device_reg_t __iomem *reg;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *ha;
@@ -1117,7 +1117,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 	fc_port_t *fcport;
 
 	if (pci_enable_device(pdev))
-		return -1;
+		goto probe_out;
 
 	host = scsi_host_alloc(&qla2x00_driver_template,
 	    sizeof(scsi_qla_host_t));
@@ -1139,9 +1139,8 @@ int qla2x00_probe_one(struct pci_dev *pd
 
 	/* Configure PCI I/O space */
 	ret = qla2x00_iospace_config(ha);
-	if (ret != 0) {
-		goto probe_alloc_failed;
-	}
+	if (ret)
+		goto probe_failed;
 
 	/* Sanitize the information from PCI BIOS. */
 	host->irq = pdev->irq;
@@ -1204,22 +1203,10 @@ int qla2x00_probe_one(struct pci_dev *pd
 		qla_printk(KERN_WARNING, ha,
 		    "[ERROR] Failed to allocate memory for adapter\n");
 
-		goto probe_alloc_failed;
+		ret = -ENOMEM;
+		goto probe_failed;
 	}
 
-	pci_set_drvdata(pdev, ha);
-	host->this_id = 255;
-	host->cmd_per_lun = 3;
-	host->unique_id = ha->instance;
-	host->max_cmd_len = MAX_CMDSZ;
-	host->max_channel = ha->ports - 1;
-	host->max_lun = MAX_LUNS;
-	host->transportt = qla2xxx_transport_template;
-	if (scsi_add_host(host, &pdev->dev))
-		goto probe_alloc_failed;
-
-	qla2x00_alloc_sysfs_attr(ha);
-
 	if (qla2x00_initialize_adapter(ha) &&
 	    !(ha->device_flags & DFLG_NO_CABLE)) {
 
@@ -1230,11 +1217,10 @@ int qla2x00_probe_one(struct pci_dev *pd
 		    "Adapter flags %x.\n",
 		    ha->host_no, ha->device_flags));
 
+		ret = -ENODEV;
 		goto probe_failed;
 	}
 
-	qla2x00_init_host_attr(ha);
-
 	/*
 	 * Startup the kernel thread for this host adapter
 	 */
@@ -1244,17 +1230,26 @@ int qla2x00_probe_one(struct pci_dev *pd
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to start DPC thread!\n");
 
+		ret = -ENODEV;
 		goto probe_failed;
 	}
 	wait_for_completion(&ha->dpc_inited);
 
+	host->this_id = 255;
+	host->cmd_per_lun = 3;
+	host->unique_id = ha->instance;
+	host->max_cmd_len = MAX_CMDSZ;
+	host->max_channel = ha->ports - 1;
+	host->max_lun = MAX_LUNS;
+	host->transportt = qla2xxx_transport_template;
+
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		ret = request_irq(host->irq, qla2100_intr_handler,
 		    SA_INTERRUPT|SA_SHIRQ, ha->brd_info->drv_name, ha);
 	else
 		ret = request_irq(host->irq, qla2300_intr_handler,
 		    SA_INTERRUPT|SA_SHIRQ, ha->brd_info->drv_name, ha);
-	if (ret != 0) {
+	if (ret) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve interrupt %d already in use.\n",
 		    host->irq);
@@ -1308,9 +1303,18 @@ int qla2x00_probe_one(struct pci_dev *pd
 		msleep(10);
 	}
 
+	pci_set_drvdata(pdev, ha);
 	ha->flags.init_done = 1;
 	num_hosts++;
 
+	ret = scsi_add_host(host, &pdev->dev);
+	if (ret)
+		goto probe_failed;
+
+	qla2x00_alloc_sysfs_attr(ha);
+
+	qla2x00_init_host_attr(ha);
+
 	qla_printk(KERN_INFO, ha, "\n"
 	    " QLogic Fibre Channel HBA Driver: %s\n"
 	    "  QLogic %s - %s\n"
@@ -1329,9 +1333,6 @@ int qla2x00_probe_one(struct pci_dev *pd
 probe_failed:
 	fc_remove_host(ha->host);
 
-	scsi_remove_host(host);
-
-probe_alloc_failed:
 	qla2x00_free_device(ha);
 
 	scsi_host_put(host);
@@ -1339,7 +1340,8 @@ probe_alloc_failed:
 probe_disable_device:
 	pci_disable_device(pdev);
 
-	return -1;
+probe_out:
+	return ret;
 }
 EXPORT_SYMBOL_GPL(qla2x00_probe_one);
 
