From: "Abhijeet Joglekar (abjoglek)" <abjoglek@cisco.com>
Subject: RE: [PATCH 1/6] fnic: add main file with module infrastructure, fnic structure, Makefile
Date: Wed, 27 May 2009 09:36:01 -0700
Message-ID: <9E88C8678BF34240A8C61D4078A3D2510138260A@xmb-sjc-23e.amer.cisco.com>
References: <20090418012941.24787.58754.stgit@feynman.nuovasystems.com> <20090418013232.24787.33309.stgit@feynman.nuovasystems.com> <200905232007.48340.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1.cisco.com ([171.71.176.70]:4339 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbZE0QgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 12:36:04 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200905232007.48340.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, "Joe Eykholt (jeykholt)" <jeykholt@cisco.com>

> -----Original Message-----
> From: Rolf Eike Beer [mailto:eike-kernel@sf-tec.de] 
> Sent: Saturday, May 23, 2009 11:08 AM
> To: Abhijeet Arvind Joglekar (abjoglek)
> Cc: linux-scsi@vger.kernel.org; 
> James.Bottomley@hansenpartnership.com; Joe Eykholt (jeykholt)
> Subject: Re: [PATCH 1/6] fnic: add main file with module 
> infrastructure, fnic structure, Makefile
> 
> Abhijeet Joglekar wrote:
> > fnic_main.c: include module load and unload, PCI device probe, 
> > scsi-ml, libFC and scsi-transport-fc registration and interfaces
> >
> > fnic.h: has fnic definition and other related data types
> 
> I am really late, but just wanted to give my to cents.
> 
> > +static int __devinit fnic_probe(struct pci_dev *pdev,
> > +				const struct pci_device_id *ent)
> > +{
> > +	struct Scsi_Host *host;
> > +	struct fc_lport *lp;
> > +	struct fnic *fnic;
> > +	mempool_t *pool;
> > +	int err;
> > +	int i;
> > +	unsigned long flags;
> > +
> > +	/*
> > +	 * Allocate SCSI Host and set up association between host,
> > +	 * local port, and fnic
> > +	 */
> > +	host = scsi_host_alloc(&fnic_host_template,
> > +			       sizeof(struct fc_lport) + 
> sizeof(struct fnic));
> > +	if (!host) {
> > +		printk(KERN_ERR PFX "Unable to alloc SCSI host\n");
> > +		err = -ENOMEM;
> > +		goto err_out;
> > +	}
> > +	lp = shost_priv(host);
> > +	lp->host = host;
> > +	fnic = lport_priv(lp);
> > +	fnic->lport = lp;
> > +
> > +	snprintf(fnic->name, sizeof(fnic->name) - 1, "%s%d", DRV_NAME,
> > +		 host->host_no);
> > +
> > +	host->transportt = fnic_fc_transport;
> > +
> > +	err = scsi_init_shared_tag_map(host, FNIC_MAX_IO_REQ);
> > +	if (err) {
> > +		shost_printk(KERN_ERR, fnic->lport->host,
> > +			     "Unable to alloc shared tag map\n");
> > +		goto err_out_free_hba;
> > +	}
> > +
> > +	/* Setup PCI resources */
> > +	pci_set_drvdata(pdev, fnic);
> > +
> > +	fnic->pdev = pdev;
> > +
> > +	err = pci_enable_device(pdev);
> > +	if (err) {
> > +		shost_printk(KERN_ERR, fnic->lport->host,
> > +			     "Cannot enable PCI device, aborting.\n");
> > +		goto err_out_free_hba;
> > +	}
> 
> If you use devres here you can save some code both in init 
> error path as well as in the remove handler (see 
> Documentation/driver-model/devres.txt).

Will take a look. Thanks for the pointer.
 
> > +	err = pci_request_regions(pdev, DRV_NAME);
> > +	if (err) {
> > +		shost_printk(KERN_ERR, fnic->lport->host,
> > +			     "Cannot enable PCI resources, aborting\n");
> > +		goto err_out_disable_device;
> > +	}
> > +
> > +	pci_set_master(pdev);
> > +
> > +	/* Query PCI controller on system for DMA addressing
> > +	 * limitation for the device.  Try 40-bit first, and
> > +	 * fail to 32-bit.
> > +	 */
> > +	err = pci_set_dma_mask(pdev, DMA_40BIT_MASK);
> > +	if (err) {
> > +		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
> > +		if (err) {
> > +			shost_printk(KERN_ERR, fnic->lport->host,
> > +				     "No usable DMA configuration "
> > +				     "aborting\n");
> > +			goto err_out_release_regions;
> > +		}
> > +		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
> > +		if (err) {
> > +			shost_printk(KERN_ERR, fnic->lport->host,
> > +				     "Unable to obtain 32-bit DMA "
> > +				     "for consistent 
> allocations, aborting.\n");
> > +			goto err_out_release_regions;
> > +		}
> > +	} else {
> > +		err = pci_set_consistent_dma_mask(pdev, DMA_40BIT_MASK);
> > +		if (err) {
> > +			shost_printk(KERN_ERR, fnic->lport->host,
> > +				     "Unable to obtain 40-bit DMA "
> > +				     "for consistent 
> allocations, aborting.\n");
> > +			goto err_out_release_regions;
> > +		}
> > +	}
> > +
> > +	/* Map vNIC resources from BAR0 */
> > +	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
> > +		shost_printk(KERN_ERR, fnic->lport->host,
> > +			     "BAR0 not memory-map'able, aborting.\n");
> > +		err = -ENODEV;
> > +		goto err_out_release_regions;
> > +	}
> > +
> > +	fnic->bar0.vaddr = pci_iomap(pdev, 0, 0);
> > +	fnic->bar0.bus_addr = pci_resource_start(pdev, 0);
> 
> bus_addr is used never again. Can it be removed?

Yes, will fix this in subsequent patches.
 
> > +	fnic->bar0.len = pci_resource_len(pdev, 0);
> > +
> > +	if (!fnic->bar0.vaddr) {
> > +		shost_printk(KERN_ERR, fnic->lport->host,
> > +			     "Cannot memory-map BAR0 res hdr, "
> > +			     "aborting.\n");
> > +		err = -ENODEV;
> > +		goto err_out_release_regions;
> > +	}
> > +
> > +	fnic->vdev = vnic_dev_register(NULL, fnic, pdev, &fnic->bar0);
> > +	if (!fnic->vdev) {
> > +		shost_printk(KERN_ERR, fnic->lport->host,
> > +			     "vNIC registration failed, "
> > +			     "aborting.\n");
> > +		err = -ENODEV;
> > +		goto err_out_iounmap;
> > +	}
> > +
> > +	err = fnic_dev_wait(fnic->vdev, vnic_dev_open,
> > +			    vnic_dev_open_done, 0);
> > +	if (err) {
> > +		shost_printk(KERN_ERR, fnic->lport->host,
> > +			     "vNIC dev open failed, aborting.\n");
> > +		goto err_out_vnic_unregister;
> > +	}
> > +
> > +	err = vnic_dev_init(fnic->vdev, 0);
> > +	if (err) {
> > +		shost_printk(KERN_ERR, fnic->lport->host,
> > +			     "vNIC dev init failed, aborting.\n");
> > +		goto err_out_dev_close;
> > +	}
> > +
> > +	err = vnic_dev_mac_addr(fnic->vdev, fnic->mac_addr);
> > +	if (err) {
> > +		shost_printk(KERN_ERR, fnic->lport->host,
> > +			     "vNIC get MAC addr failed \n");
> > +		goto err_out_dev_close;
> > +	}
> > +
> > +	/* Get vNIC configuration */
> > +	err = fnic_get_vnic_config(fnic);
> > +	if (err) {
> > +		shost_printk(KERN_ERR, fnic->lport->host,
> > +			     "Get vNIC configuration failed, "
> > +			     "aborting.\n");
> > +		goto err_out_dev_close;
> > +	}
> > +	host->max_lun = fnic->config.luns_per_tgt;
> > +	host->max_id = FNIC_MAX_FCP_TARGET;
> > +
> > +	fnic_get_res_counts(fnic);
> > +
> > +	err = fnic_set_intr_mode(fnic);
> > +	if (err) {
> > +		shost_printk(KERN_ERR, fnic->lport->host,
> > +			     "Failed to set intr mode, "
> > +			     "aborting.\n");
> > +		goto err_out_dev_close;
> > +	}
> > +
> > +	err = fnic_request_intr(fnic);
> > +	if (err) {
> > +		shost_printk(KERN_ERR, fnic->lport->host,
> > +			     "Unable to request irq.\n");
> > +		goto err_out_clear_intr;
> > +	}
> > +
> > +	err = fnic_alloc_vnic_resources(fnic);
> > +	if (err) {
> > +		shost_printk(KERN_ERR, fnic->lport->host,
> > +			     "Failed to alloc vNIC resources, "
> > +			     "aborting.\n");
> > +		goto err_out_free_intr;
> > +	}
> > +
> > +
> > +	/* initialize all fnic locks */
> > +	spin_lock_init(&fnic->fnic_lock);
> > +
> > +	for (i = 0; i < FNIC_WQ_MAX; i++)
> i < ARRAY_SIZE(fnic->wq_lock)
> 
> > +		spin_lock_init(&fnic->wq_lock[i]);
> > +
> > +	for (i = 0; i < FNIC_WQ_COPY_MAX; i++) {
> i < ARRAY_SIZE(fnic->wq_copy_lock)
> 
> No matter by which number this will be scaled this gives you 
> the right number of elements.

Right, we have it in some of the files, not done uniformly. Will fix
this in subsequent patches.

-- abhijeet
 
> Greetings,
> 
> Eike
> 
