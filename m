From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/6] fnic: add main file with module infrastructure, fnic structure, Makefile
Date: Sat, 23 May 2009 20:07:37 +0200
Message-ID: <200905232007.48340.eike-kernel@sf-tec.de>
References: <20090418012941.24787.58754.stgit@feynman.nuovasystems.com> <20090418013232.24787.33309.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2750345.gZO6qlf9DT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:37191 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZEWSPL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 May 2009 14:15:11 -0400
In-Reply-To: <20090418013232.24787.33309.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijeet Joglekar <abjoglek@cisco.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jeykholt@cisco.com

--nextPart2750345.gZO6qlf9DT
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Abhijeet Joglekar wrote:
> fnic_main.c: include module load and unload, PCI device probe, scsi-ml,
> libFC and scsi-transport-fc registration and interfaces
>
> fnic.h: has fnic definition and other related data types

I am really late, but just wanted to give my to cents.

> +static int __devinit fnic_probe(struct pci_dev *pdev,
> +				const struct pci_device_id *ent)
> +{
> +	struct Scsi_Host *host;
> +	struct fc_lport *lp;
> +	struct fnic *fnic;
> +	mempool_t *pool;
> +	int err;
> +	int i;
> +	unsigned long flags;
> +
> +	/*
> +	 * Allocate SCSI Host and set up association between host,
> +	 * local port, and fnic
> +	 */
> +	host =3D scsi_host_alloc(&fnic_host_template,
> +			       sizeof(struct fc_lport) + sizeof(struct fnic));
> +	if (!host) {
> +		printk(KERN_ERR PFX "Unable to alloc SCSI host\n");
> +		err =3D -ENOMEM;
> +		goto err_out;
> +	}
> +	lp =3D shost_priv(host);
> +	lp->host =3D host;
> +	fnic =3D lport_priv(lp);
> +	fnic->lport =3D lp;
> +
> +	snprintf(fnic->name, sizeof(fnic->name) - 1, "%s%d", DRV_NAME,
> +		 host->host_no);
> +
> +	host->transportt =3D fnic_fc_transport;
> +
> +	err =3D scsi_init_shared_tag_map(host, FNIC_MAX_IO_REQ);
> +	if (err) {
> +		shost_printk(KERN_ERR, fnic->lport->host,
> +			     "Unable to alloc shared tag map\n");
> +		goto err_out_free_hba;
> +	}
> +
> +	/* Setup PCI resources */
> +	pci_set_drvdata(pdev, fnic);
> +
> +	fnic->pdev =3D pdev;
> +
> +	err =3D pci_enable_device(pdev);
> +	if (err) {
> +		shost_printk(KERN_ERR, fnic->lport->host,
> +			     "Cannot enable PCI device, aborting.\n");
> +		goto err_out_free_hba;
> +	}

If you use devres here you can save some code both in init error path as we=
ll=20
as in the remove handler (see Documentation/driver-model/devres.txt).

> +	err =3D pci_request_regions(pdev, DRV_NAME);
> +	if (err) {
> +		shost_printk(KERN_ERR, fnic->lport->host,
> +			     "Cannot enable PCI resources, aborting\n");
> +		goto err_out_disable_device;
> +	}
> +
> +	pci_set_master(pdev);
> +
> +	/* Query PCI controller on system for DMA addressing
> +	 * limitation for the device.  Try 40-bit first, and
> +	 * fail to 32-bit.
> +	 */
> +	err =3D pci_set_dma_mask(pdev, DMA_40BIT_MASK);
> +	if (err) {
> +		err =3D pci_set_dma_mask(pdev, DMA_32BIT_MASK);
> +		if (err) {
> +			shost_printk(KERN_ERR, fnic->lport->host,
> +				     "No usable DMA configuration "
> +				     "aborting\n");
> +			goto err_out_release_regions;
> +		}
> +		err =3D pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
> +		if (err) {
> +			shost_printk(KERN_ERR, fnic->lport->host,
> +				     "Unable to obtain 32-bit DMA "
> +				     "for consistent allocations, aborting.\n");
> +			goto err_out_release_regions;
> +		}
> +	} else {
> +		err =3D pci_set_consistent_dma_mask(pdev, DMA_40BIT_MASK);
> +		if (err) {
> +			shost_printk(KERN_ERR, fnic->lport->host,
> +				     "Unable to obtain 40-bit DMA "
> +				     "for consistent allocations, aborting.\n");
> +			goto err_out_release_regions;
> +		}
> +	}
> +
> +	/* Map vNIC resources from BAR0 */
> +	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
> +		shost_printk(KERN_ERR, fnic->lport->host,
> +			     "BAR0 not memory-map'able, aborting.\n");
> +		err =3D -ENODEV;
> +		goto err_out_release_regions;
> +	}
> +
> +	fnic->bar0.vaddr =3D pci_iomap(pdev, 0, 0);
> +	fnic->bar0.bus_addr =3D pci_resource_start(pdev, 0);

bus_addr is used never again. Can it be removed?

> +	fnic->bar0.len =3D pci_resource_len(pdev, 0);
> +
> +	if (!fnic->bar0.vaddr) {
> +		shost_printk(KERN_ERR, fnic->lport->host,
> +			     "Cannot memory-map BAR0 res hdr, "
> +			     "aborting.\n");
> +		err =3D -ENODEV;
> +		goto err_out_release_regions;
> +	}
> +
> +	fnic->vdev =3D vnic_dev_register(NULL, fnic, pdev, &fnic->bar0);
> +	if (!fnic->vdev) {
> +		shost_printk(KERN_ERR, fnic->lport->host,
> +			     "vNIC registration failed, "
> +			     "aborting.\n");
> +		err =3D -ENODEV;
> +		goto err_out_iounmap;
> +	}
> +
> +	err =3D fnic_dev_wait(fnic->vdev, vnic_dev_open,
> +			    vnic_dev_open_done, 0);
> +	if (err) {
> +		shost_printk(KERN_ERR, fnic->lport->host,
> +			     "vNIC dev open failed, aborting.\n");
> +		goto err_out_vnic_unregister;
> +	}
> +
> +	err =3D vnic_dev_init(fnic->vdev, 0);
> +	if (err) {
> +		shost_printk(KERN_ERR, fnic->lport->host,
> +			     "vNIC dev init failed, aborting.\n");
> +		goto err_out_dev_close;
> +	}
> +
> +	err =3D vnic_dev_mac_addr(fnic->vdev, fnic->mac_addr);
> +	if (err) {
> +		shost_printk(KERN_ERR, fnic->lport->host,
> +			     "vNIC get MAC addr failed \n");
> +		goto err_out_dev_close;
> +	}
> +
> +	/* Get vNIC configuration */
> +	err =3D fnic_get_vnic_config(fnic);
> +	if (err) {
> +		shost_printk(KERN_ERR, fnic->lport->host,
> +			     "Get vNIC configuration failed, "
> +			     "aborting.\n");
> +		goto err_out_dev_close;
> +	}
> +	host->max_lun =3D fnic->config.luns_per_tgt;
> +	host->max_id =3D FNIC_MAX_FCP_TARGET;
> +
> +	fnic_get_res_counts(fnic);
> +
> +	err =3D fnic_set_intr_mode(fnic);
> +	if (err) {
> +		shost_printk(KERN_ERR, fnic->lport->host,
> +			     "Failed to set intr mode, "
> +			     "aborting.\n");
> +		goto err_out_dev_close;
> +	}
> +
> +	err =3D fnic_request_intr(fnic);
> +	if (err) {
> +		shost_printk(KERN_ERR, fnic->lport->host,
> +			     "Unable to request irq.\n");
> +		goto err_out_clear_intr;
> +	}
> +
> +	err =3D fnic_alloc_vnic_resources(fnic);
> +	if (err) {
> +		shost_printk(KERN_ERR, fnic->lport->host,
> +			     "Failed to alloc vNIC resources, "
> +			     "aborting.\n");
> +		goto err_out_free_intr;
> +	}
> +
> +
> +	/* initialize all fnic locks */
> +	spin_lock_init(&fnic->fnic_lock);
> +
> +	for (i =3D 0; i < FNIC_WQ_MAX; i++)
i < ARRAY_SIZE(fnic->wq_lock)

> +		spin_lock_init(&fnic->wq_lock[i]);
> +
> +	for (i =3D 0; i < FNIC_WQ_COPY_MAX; i++) {
i < ARRAY_SIZE(fnic->wq_copy_lock)

No matter by which number this will be scaled this gives you the right numb=
er=20
of elements.

Greetings,

Eike

--nextPart2750345.gZO6qlf9DT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkoYO3QACgkQXKSJPmm5/E5hOACgkGlRSP5pJx/zE7qbOikMPDDz
JTEAoKRUYVEU8z9P/BowtIdKZwz+Lge6
=R9u8
-----END PGP SIGNATURE-----

--nextPart2750345.gZO6qlf9DT--
