From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2/16] gdth: split out eisa probing
Date: Tue, 2 Oct 2007 19:20:38 +0200
Message-ID: <200710021920.40354.eike-kernel@sf-tec.de>
References: <46FFFC8C.6080804@panasas.com> <46FFFE21.4030902@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4415850.FsF7ykiVOi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:51659 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbXJCPpq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 11:45:46 -0400
In-Reply-To: <46FFFE21.4030902@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

--nextPart4415850.FsF7ykiVOi
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Boaz Harrosh wrote:
> Split eisa probing into it's own helper, and do proper error unwinding.
> Protect EISA probind by the proper CONFIG_EISA symbol.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

> @@ -5694,6 +5582,148 @@ static int gdth_isa_probe_one(struct
> scsi_host_template *shtp, ulong32 isa_bios) }
>  #endif /* CONFIG_ISA */
>
> +#ifdef CONFIG_EISA
> +static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
> +		ushort eisa_slot)
> +{
> +	struct Scsi_Host *shp;
> +	gdth_ha_str *ha;
> +	dma_addr_t scratch_dma_handle =3D 0;
> +	int error, hanum, i;
> +	u8 b;
> +
> +	if (!gdth_search_eisa(eisa_slot))
> +		return -ENXIO;
> +
> +	shp =3D scsi_register(shtp,sizeof(gdth_ext_str));
> +	if (!shp)
> +		return -ENOMEM;
> +	ha =3D HADATA(shp);
> +
> +	error =3D -ENODEV;
> +	if (!gdth_init_eisa(eisa_slot,ha))
> +		goto out_host_put;
> +
> +	/* controller found and initialized */
> +	printk("Configuring GDT-EISA HA at Slot %d IRQ %u\n",
> +		eisa_slot >> 12, ha->irq);
> +
> +	error =3D request_irq(ha->irq, gdth_interrupt, IRQF_DISABLED, "gdth", h=
a);
> +	if (error) {
> +		printk("GDT-EISA: Unable to allocate IRQ\n");
> +		goto out_host_put;
> +	}
> +
> +	shp->unchecked_isa_dma =3D 0;
> +	shp->irq =3D ha->irq;
> +	shp->dma_channel =3D 0xff;
> +	hanum =3D gdth_ctr_count;
> +	gdth_ctr_tab[gdth_ctr_count++] =3D shp;
> +	gdth_ctr_vtab[gdth_ctr_vcount++] =3D shp;
> +
> +	NUMDATA(shp)->hanum =3D (ushort)hanum;
> +	NUMDATA(shp)->busnum=3D 0;
> +	TRACE2(("EISA detect Bus 0: hanum %d\n",
> +		NUMDATA(shp)->hanum));
> +
> +	ha->pccb =3D CMDDATA(shp);
> +	ha->ccb_phys =3D 0L;
> +
> +	error =3D -ENOMEM;
> +
> +	ha->pdev =3D NULL;
> +	ha->pscratch =3D pci_alloc_consistent(ha->pdev, GDTH_SCRATCH,
> +						&scratch_dma_handle);
> +	if (!ha->pscratch)
> +		goto out_free_irq;
> +	ha->scratch_phys =3D scratch_dma_handle;
> +
> +	ha->pmsg =3D pci_alloc_consistent(ha->pdev, sizeof(gdth_msg_str),
> +						&scratch_dma_handle);
> +	if (!ha->pmsg)
> +		goto out_free_pscratch;
> +	ha->msg_phys =3D scratch_dma_handle;
> +
> +#ifdef INT_COAL
> +	ha->coal_stat =3D pci_alloc_consistent(ha->pdev,
> +			sizeof(gdth_coal_status) * MAXOFFSETS,
> +			&scratch_dma_handle);
> +	if (!ha->coal_stat)
> +		goto out_free_pmsg;
> +	ha->coal_stat_phys =3D scratch_dma_handle;
> +#endif
> +
> +	ha->ccb_phys =3D pci_map_single(ha->pdev,ha->pccb,
> +			sizeof(gdth_cmd_str), PCI_DMA_BIDIRECTIONAL);
> +	if (!ha->ccb_phys)
> +		goto out_free_coal_stat;

Same thing as in ISA patch: this is not PCI and we should not hide what we'=
re=20
doing so dma_alloc_consistent(NULL, ...) is better IMHO.

Eike

--nextPart4415850.FsF7ykiVOi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBHAn3oXKSJPmm5/E4RAnVbAKCfUHuih/ggboc0NmQPV93GvMO3EwCfZt/C
BPxbo80NUP3QzcgCGj/v67U=
=Wax1
-----END PGP SIGNATURE-----

--nextPart4415850.FsF7ykiVOi--
