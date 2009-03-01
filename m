From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Sun, 1 Mar 2009 14:49:52 +0100
Message-ID: <200903011450.04274.eike-kernel@sf-tec.de>
References: <20090227230927.GA21377@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12121403.LEbqP6SMdT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:60032 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756351AbZCAXWU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Mar 2009 18:22:20 -0500
In-Reply-To: <20090227230927.GA21377@roadking.ldev.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com, iss.sbteam@hp.com

--nextPart12121403.LEbqP6SMdT
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

You wrote:

> +static int adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
> +	struct hpsa_scsi_dev_t sd[], int nsds)
> +{
> +	/* sd contains scsi3 addresses and devtypes, and inquiry */
> +	/* data.  This function takes what's in sd to be the current */
> +	/* reality and updates h->dev[] to reflect that reality. */
> +
> +	int i, entry, device_change, changes =3D 0;
> +	struct hpsa_scsi_dev_t *csd;
> +	unsigned long flags;
> +	struct scsi2map *added, *removed;
> +	int nadded, nremoved;
> +	struct Scsi_Host *sh =3D NULL;
> +
> +	added =3D kzalloc(sizeof(*added) * HPSA_MAX_SCSI_DEVS_PER_HBA,
> +		GFP_KERNEL);
> +	removed =3D kzalloc(sizeof(*removed) * HPSA_MAX_SCSI_DEVS_PER_HBA,
> +		GFP_KERNEL);

kcalloc()?

> +static struct CommandList_struct *cmd_alloc(struct ctlr_info *h)
> +{
> +	struct CommandList_struct *c;
> +	int i;
> +	union u64bit temp64;
> +	dma_addr_t cmd_dma_handle, err_dma_handle;
> +
> +	do {
> +		i =3D find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
> +		if (i =3D=3D h->nr_cmds)
> +			return NULL;
> +	} while (test_and_set_bit
> +		 (i & (BITS_PER_LONG - 1),
> +		  h->cmd_pool_bits + (i / BITS_PER_LONG)) !=3D 0);
> +	c =3D h->cmd_pool + i;
> +	memset(c, 0, sizeof(struct CommandList_struct));

sizeof(*c)

> +	cmd_dma_handle =3D h->cmd_pool_dhandle
> +	    + i * sizeof(struct CommandList_struct);
> +	c->err_info =3D h->errinfo_pool + i;
> +	memset(c->err_info, 0, sizeof(struct ErrorInfo_struct));

sizeof(c->err_info)

> +	err_dma_handle =3D h->errinfo_pool_dhandle
> +	    + i * sizeof(struct ErrorInfo_struct);
> +	h->nr_allocs++;
> +
> +	c->cmdindex =3D i;
> +
> +	INIT_HLIST_NODE(&c->list);
> +	c->busaddr =3D (__u32) cmd_dma_handle;
> +	temp64.val =3D (__u64) err_dma_handle;
> +	c->ErrDesc.Addr.lower =3D temp64.val32.lower;
> +	c->ErrDesc.Addr.upper =3D temp64.val32.upper;
> +	c->ErrDesc.Len =3D sizeof(struct ErrorInfo_struct);
> +
> +	c->ctlr =3D h->ctlr;
> +	return c;
> +}
> +
> +/* For operations that can wait for kmalloc to possibly sleep,
> + * this routine can be called. Lock need not be held to call
> + * cmd_special_alloc. cmd_special_free() is the complement.
> + */
> +static struct CommandList_struct *cmd_special_alloc(struct ctlr_info *h)
> +{
> +	struct CommandList_struct *c;
> +	union u64bit temp64;
> +	dma_addr_t cmd_dma_handle, err_dma_handle;
> +
> +	c =3D (struct CommandList_struct *) pci_alloc_consistent(h->pdev,
> +		sizeof(struct CommandList_struct), &cmd_dma_handle);

No need to cast a void pointer.

> +	if (c =3D=3D NULL)
> +		return NULL;
> +	memset(c, 0, sizeof(struct CommandList_struct));

sizeof(*c)

> +	c->cmdindex =3D -1;
> +
> +	c->err_info =3D (struct ErrorInfo_struct *)
> +	    pci_alloc_consistent(h->pdev, sizeof(struct ErrorInfo_struct),
> +		    &err_dma_handle);
> +
> +	if (c->err_info =3D=3D NULL) {
> +		pci_free_consistent(h->pdev,
> +			sizeof(struct CommandList_struct), c, cmd_dma_handle);
> +		return NULL;
> +	}
> +	memset(c->err_info, 0, sizeof(struct ErrorInfo_struct));

Here again.

> +	INIT_HLIST_NODE(&c->list);
> +	c->busaddr =3D (__u32) cmd_dma_handle;
> +	temp64.val =3D (__u64) err_dma_handle;
> +	c->ErrDesc.Addr.lower =3D temp64.val32.lower;
> +	c->ErrDesc.Addr.upper =3D temp64.val32.upper;
> +	c->ErrDesc.Len =3D sizeof(struct ErrorInfo_struct);
> +
> +	c->ctlr =3D h->ctlr;
> +	return c;
> +}
> +
> +
> +/* Free a command block previously allocated with cmd_alloc(). */
> +static void cmd_free(struct ctlr_info *h, struct CommandList_struct *c)
> +{
> +	int i;
> +	i =3D c - h->cmd_pool;
> +	clear_bit(i & (BITS_PER_LONG - 1),
> +		  h->cmd_pool_bits + (i / BITS_PER_LONG));
> +	h->nr_frees++;
> +}
> +
> +/* Free a command block previously allocated with cmd_special_alloc(). */
> +static void cmd_special_free(struct ctlr_info *h, struct
> CommandList_struct *c) +{
> +	union u64bit temp64;
> +
> +	temp64.val32.lower =3D c->ErrDesc.Addr.lower;
> +	temp64.val32.upper =3D c->ErrDesc.Addr.upper;
> +	pci_free_consistent(h->pdev, sizeof(struct ErrorInfo_struct),
> +			    c->err_info, (dma_addr_t) temp64.val);

sizeof(c->err_info)

> +	pci_free_consistent(h->pdev, sizeof(struct CommandList_struct),
> +			    c, (dma_addr_t) c->busaddr);

sizeof(*c)

I stopped looking for that here, there are maybe some more instances.

> +static int hpsa_pci_init(struct ctlr_info *c, struct pci_dev *pdev)
> +{
> +	ushort subsystem_vendor_id, subsystem_device_id, command;
> +	__u32 board_id, scratchpad =3D 0;
> +	__u64 cfg_offset;
> +	__u32 cfg_base_addr;
> +	__u64 cfg_base_addr_index;
> +	int i, prod_index, err;
> +
> +	subsystem_vendor_id =3D pdev->subsystem_vendor;
> +	subsystem_device_id =3D pdev->subsystem_device;
> +	board_id =3D (((__u32) (subsystem_device_id << 16) & 0xffff0000) |
> +		    subsystem_vendor_id);
> +
> +	for (i =3D 0; i < ARRAY_SIZE(products); i++)
> +		if (board_id =3D=3D products[i].board_id)
> +			break;
> +
> +	prod_index =3D i;
> +
> +	if (prod_index =3D=3D ARRAY_SIZE(products)) {
> +		prod_index--;
> +		if (subsystem_vendor_id =3D=3D !PCI_VENDOR_ID_HP ||
> +				!allow_unknown_smartarray) {
> +			printk(KERN_WARNING "hpsa: Sorry, I don't "
> +				"know how to access the Smart "
> +				"Array controller %08lx\n",
> +				(unsigned long) board_id);
> +			return -ENODEV;
> +		}
> +	}
> +	/* check to see if controller has been disabled */
> +	/* BEFORE trying to enable it */
> +	(void)pci_read_config_word(pdev, PCI_COMMAND, &command);
> +	if (!(command & 0x02)) {
> +		printk(KERN_WARNING
> +		       "hpsa: controller appears to be disabled\n");
> +		return -ENODEV;
> +	}
> +
> +	err =3D pci_enable_device(pdev);

You may want to use pcim_enable_device() as it moves the work of freeing a=
=20
bunch of resources (like pci_request_regions()) to devres and you don't nee=
d=20
to care about this.

Eike

--nextPart12121403.LEbqP6SMdT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmqkowACgkQXKSJPmm5/E7A6QCggdZt5WmsGREY8X9K191aJGBM
pRIAniWjlsONyMkpBN9krjIcDbvbCApd
=/8HZ
-----END PGP SIGNATURE-----

--nextPart12121403.LEbqP6SMdT--
