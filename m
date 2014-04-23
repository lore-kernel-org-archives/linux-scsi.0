From: Ben Collins <ben.c@servergy.com>
Subject: Re: [PATCH] megaraid: Use resource_size_t for PCI resources, not long
Date: Wed, 23 Apr 2014 11:19:08 -0400
Message-ID: <9A2B213F-FEDC-4558-BC75-B6F3C0DE9785@servergy.com>
References: <D74A8430-BF73-488F-8CD1-0E00B5FE75A6@servergy.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_67779574-277F-4350-8B3E-F917DC384996"; protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55014 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453AbaDWPTO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Apr 2014 11:19:14 -0400
Received: by mail-pd0-f174.google.com with SMTP id z10so70658pdj.19
        for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2014 08:19:13 -0700 (PDT)
In-Reply-To: <D74A8430-BF73-488F-8CD1-0E00B5FE75A6@servergy.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Sumit Saxena <Sumit.Saxena@lsi.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>


--Apple-Mail=_67779574-277F-4350-8B3E-F917DC384996
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

This is 7 months old. It's been ACK'd by LSI themselves and they even =
responded a few months later requesting it be included. It's also =
obviously correct. Can we get this included soonish? Please?

On Sep 13, 2013, at 12:46 PM, Ben Collins <ben.c@servergy.com> wrote:

> The assumption that sizeof(long) >=3D sizeof(resource_size_t) can lead =
to
> truncation of the PCI resource address, meaning this driver didn't =
work
> on 32-bit systems with 64-bit PCI adressing ranges.
>=20
> Signed-off-by: Ben Collins <ben.c@servergy.com>
> Cc: Sumit Saxena <Sumit.Saxena@lsi.com>
> Cc: DL-MegaRAID Linux <megaraidlinux@lsi.com>
> ---
> drivers/scsi/megaraid/megaraid_sas.h      | 1 -
> drivers/scsi/megaraid/megaraid_sas_base.c | 5 +++--
> 2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h =
b/drivers/scsi/megaraid/megaraid_sas.h
> index 04a42a5..2f58758 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -1460,7 +1460,6 @@ struct megasas_instance {
> 	u32 *reply_queue;
> 	dma_addr_t reply_queue_h;
>=20
> -	unsigned long base_addr;
> 	struct megasas_register_set __iomem *reg_set;
> 	u32 *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
> 	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c =
b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 1f0ca68..5df5522 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -3498,6 +3498,7 @@ static int megasas_init_fw(struct =
megasas_instance *instance)
> 	u32 max_sectors_1;
> 	u32 max_sectors_2;
> 	u32 tmp_sectors, msix_enable, scratch_pad_2;
> +	resource_size_t base_addr;
> 	struct megasas_register_set __iomem *reg_set;
> 	struct megasas_ctrl_info *ctrl_info;
> 	unsigned long bar_list;
> @@ -3506,14 +3507,14 @@ static int megasas_init_fw(struct =
megasas_instance *instance)
> 	/* Find first memory bar */
> 	bar_list =3D pci_select_bars(instance->pdev, IORESOURCE_MEM);
> 	instance->bar =3D find_first_bit(&bar_list, sizeof(unsigned =
long));
> -	instance->base_addr =3D pci_resource_start(instance->pdev, =
instance->bar);
> 	if (pci_request_selected_regions(instance->pdev, instance->bar,
> 					 "megasas: LSI")) {
> 		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
> 		return -EBUSY;
> 	}
>=20
> -	instance->reg_set =3D ioremap_nocache(instance->base_addr, =
8192);
> +	base_addr =3D pci_resource_start(instance->pdev, instance->bar);
> +	instance->reg_set =3D ioremap_nocache(base_addr, 8192);
>=20
> 	if (!instance->reg_set) {
> 		printk(KERN_DEBUG "megasas: Failed to map IO mem\n");
> --=20
> 1.8.3.2
>=20
>=20
> --
> Ben Collins - Principal Architect
> Servergy, Inc. - www.servergy.com
>=20

--
Ben Collins - Principal Architect
Servergy, Inc. - www.servergy.com


--Apple-Mail=_67779574-277F-4350-8B3E-F917DC384996
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iEYEARECAAYFAlNX2ewACgkQbVJJsWDoC1sVUACfYfeGdwsDSKwziqo8+cbVfCqS
+G4AoJXZ8oFEgeqBY0Y8Q97sKP1/Y2LO
=tEtO
-----END PGP SIGNATURE-----

--Apple-Mail=_67779574-277F-4350-8B3E-F917DC384996--
