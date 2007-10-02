From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/16] gdth: split out isa probing
Date: Tue, 2 Oct 2007 19:17:58 +0200
Message-ID: <200710021918.11183.eike-kernel@sf-tec.de>
References: <46FFFC8C.6080804@panasas.com> <46FFFDE9.3010500@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2538236.cYJ19sCd5s";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:47707 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbXJCPpr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 11:45:47 -0400
In-Reply-To: <46FFFDE9.3010500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

--nextPart2538236.cYJ19sCd5s
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Boaz Harrosh wrote:
> (note: this is ontop of Jeff's pci cleanup patch)
>
> Split out isa probing into a helper of it's own.  Error handling is
> cleaned up, but errors are not propagated yet.  Also enclose the isa
> probe under the proper CONFIG_ISA symbol instead of the !IA64 hack.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

> @@ -4277,6 +4280,7 @@ int __init option_setup(char *str)
>      return 1;
>  }
>
> +
>  #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
>  static int __init gdth_detect(struct scsi_host_template *shtp)
>  #else

Extra newline for nothing?

> @@ -5668,6 +5552,149 @@ static Scsi_Host_Template driver_template =3D {
>  #endif
>  };
>
> +#ifdef CONFIG_ISA
> +static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32
> isa_bios) +{
> +	struct Scsi_Host *shp;
> +	gdth_ha_str *ha;
> +	dma_addr_t scratch_dma_handle =3D 0;
> +	int error, hanum, i;
> +	u8 b;
> +
> +	if (!gdth_search_isa(isa_bios))
> +		return -ENXIO;
> +
> +	shp =3D scsi_register(shtp, sizeof(gdth_ext_str));
> +	if (!shp)
> +		return -ENOMEM;
> +	ha =3D HADATA(shp);
> +
> +	error =3D -ENODEV;
> +	if (!gdth_init_isa(isa_bios,ha))
> +		goto out_host_put;
> +
> +	/* controller found and initialized */
> +	printk("Configuring GDT-ISA HA at BIOS 0x%05X IRQ %u DRQ %u\n",
> +		isa_bios, ha->irq, ha->drq);
> +
> +	error =3D request_irq(ha->irq, gdth_interrupt, IRQF_DISABLED, "gdth", h=
a);
> +	if (error) {
> +		printk("GDT-ISA: Unable to allocate IRQ\n");
> +		goto out_host_put;
> +	}
> +
> +	error =3D request_dma(ha->drq, "gdth");
> +	if (error) {
> +		printk("GDT-ISA: Unable to allocate DMA channel\n");
> +		goto out_free_irq;
> +	}
> +
> +	set_dma_mode(ha->drq,DMA_MODE_CASCADE);
> +	enable_dma(ha->drq);
> +	shp->unchecked_isa_dma =3D 1;
> +	shp->irq =3D ha->irq;
> +	shp->dma_channel =3D ha->drq;
> +	hanum =3D gdth_ctr_count;
> +	gdth_ctr_tab[gdth_ctr_count++] =3D shp;
> +	gdth_ctr_vtab[gdth_ctr_vcount++] =3D shp;
> +
> +	NUMDATA(shp)->hanum =3D (ushort)hanum;
> +	NUMDATA(shp)->busnum=3D 0;
> +
> +	ha->pccb =3D CMDDATA(shp);
> +	ha->ccb_phys =3D 0L;
> +	ha->pdev =3D NULL;
> +
> +	error =3D -ENOMEM;
> +
> +	ha->pscratch =3D pci_alloc_consistent(ha->pdev, GDTH_SCRATCH,
> +						&scratch_dma_handle);
> +	if (!ha->pscratch)
> +		goto out_dec_counters;
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
> +				sizeof(gdth_coal_status) * MAXOFFSETS,
> +				&scratch_dma_handle);
> +	if (!ha->coal_stat)
> +		goto out_free_pmsg;
> +	ha->coal_stat_phys =3D scratch_dma_handle;
> +#endif

What we have here is cleanly not PCI memory as it's ISA initialisation. And=
=20
for making things obvious passing NULL as first argument of=20
dma_alloc_consistent() is IMHO the better way.

Greetings,

Eike

--nextPart2538236.cYJ19sCd5s
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBHAn1TXKSJPmm5/E4RAlIfAJ4xxGsUmwxuT0e8/HOHdXTxxLv4zQCeKWSd
VVWds1aVjsjI2Uhm7Iiv8vg=
=TTRt
-----END PGP SIGNATURE-----

--nextPart2538236.cYJ19sCd5s--
