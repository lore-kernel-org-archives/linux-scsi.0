From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/2] dpt_i2o: 64 bit support (take 4)
Date: Fri, 25 Apr 2008 09:46:48 +0200
Message-ID: <200804250946.56076.eike-kernel@sf-tec.de>
References: <20080424213355.GA21682@xs4all.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2136109.NgPOTf46Ez";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:46751 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539AbYDYHwf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 03:52:35 -0400
In-Reply-To: <20080424213355.GA21682@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-scsi@vger.kernel.org

--nextPart2136109.NgPOTf46Ez
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Miquel van Smoorenburg wrote:
> I've taken out the ifdef __linux__ code that was added, and
> I removed the unused reboot_notifier code.

This is yet another patch as it has nothing to do with the 64 bit changes.

> As before, 1/2 is the 64 bit code, 2/2 is the sysfs code.
>
> # -----
>
> This patch is an update for drivers/scsi/dpt_i2o.c.
> It applies to both 2.6.24.4 and 2.6.25
>
> It contains the following changes:
>
> * 64 bit code based on unofficial Adaptec 64 bit driver
> * removes scsi_module.c dependency, adds module_init / module_exit
>   this is needed because we need to pass the proper device to
>   scsi_add_host(), and the scsi_module.c passes NULL. With NULL,
>   code like arch/x64/kernel/pci-gart_64.c::need_iommu() crashes
>   because the dev pointer it is passed is NULL.
> * adds sysfs entry for /sys/class/dpt_i2o/dptiX so that udev
>   can create /dev/dptiX dynamically

Please trim the changelog to only describe what you are doing in this exact=
=20
patch. For a general description you might want to send a "[patch 0/3]" mai=
l=20
with some text about the complete series of patches. Sending all patches of=
=20
this series as a reply to the "0/n" mail also helps keeping the things=20
together in mail clients.


> +#ifdef CONFIG_COMPAT
> +static long compat_adpt_ioctl(struct file *, unsigned int, unsigned long=
);
> +#endif
> +
>  static const struct file_operations adpt_fops =3D {
>  	.ioctl		=3D adpt_ioctl,
>  	.open		=3D adpt_open,
> -	.release	=3D adpt_close
> -};
> -
> -#ifdef REBOOT_NOTIFIER
> -static struct notifier_block adpt_reboot_notifier =3D
> -{
> -	 adpt_reboot_event,
> -	 NULL,
> -	 0
> -};
> +	.release	=3D adpt_close,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl	=3D compat_adpt_ioctl,
>  #endif
> +};
>
>  /* Structures and definitions for synchronous message posting.
>   * See adpt_i2o_post_wait() for description

I doubt this has anything to do with 64 bit changes, has it?

> @@ -178,8 +192,6 @@
>  	struct pci_dev *pDev =3D NULL;
>  	adpt_hba* pHba;
>
> -	adpt_init();
> -
>  	PINFO("Detecting Adaptec I2O RAID controllers...\n");
>
>          /* search for all Adatpec I2O RAID cards */
> @@ -248,7 +260,7 @@
>  	}
>
>  	for (pHba =3D hba_chain; pHba; pHba =3D pHba->next) {
> -		if( adpt_scsi_register(pHba,sht) < 0){
> +		if (adpt_scsi_host_alloc(pHba, sht) < 0){
>  			adpt_i2o_delete_hba(pHba);
>  			continue;
>  		}

This too.

> @@ -338,8 +354,16 @@
>
>  	/* Now fill in the SGList and command */
>  	*lenptr =3D len;
> -	*mptr++ =3D 0xD0000000|direction|len;
> -	*mptr++ =3D virt_to_bus(buf);
> +	if (dpt_dma64(pHba)) {
> +		*mptr++ =3D (0x7C<<24)+(2<<16)+0x02; /* Enable 64 bit */
> +		*mptr++ =3D 1 << PAGE_SHIFT;
> +		*mptr++ =3D 0xD0000000|direction|len;
> +		*mptr++ =3D dma_low(addr);
> +		*mptr++ =3D dma_high(addr);
> +	} else {
> +		*mptr++ =3D 0xD0000000|direction|len;
> +		*mptr++ =3D addr;
> +	}
>
>  	// Send it on it's way
>  	rcode =3D adpt_i2o_post_wait(pHba, msg, reqlen<<2, 120);

There are some spaces missing to get the equations readable.

> @@ -347,7 +371,7 @@
>  		sprintf(pHba->detail, "Adaptec I2O RAID");
>  		printk(KERN_INFO "%s: Inquiry Error (%d)\n",pHba->name,rcode);
>  		if (rcode !=3D -ETIME && rcode !=3D -EINTR)
> -			kfree(buf);
> +			pci_free_consistent(pHba->pDev, 80, buf, addr);
>  	} else {
>  		memset(pHba->detail, 0, sizeof(pHba->detail));
>  		memcpy(&(pHba->detail), "Vendor: Adaptec ", 16);
> @@ -356,7 +380,7 @@
>  		memcpy(&(pHba->detail[40]), " FW: ", 4);
>  		memcpy(&(pHba->detail[44]), (u8*) &buf[32], 4);
>  		pHba->detail[48] =3D '\0';	/* precautionary */
> -		kfree(buf);
> +		pci_free_consistent(pHba->pDev, 80, buf, addr);
>  	}
>  	adpt_i2o_status_get(pHba);
>  	return ;

Too many magic numbers. Please put the 80 (and 14 and 17 from above) into s=
ome=20
defines. Something like FOO_ADAPTER_MESSAGE_SIZE, describing roughly what=20
that number is actually meant for.

> +/*
> + *	Turn a pointer to ioctl reply data into an u32 'context'
> + */
> +static u32 adpt_ioctl_to_context(adpt_hba * pHba, void *reply)
> +{
> +#if BITS_PER_LONG =3D=3D 32
> +	return (u32)(unsigned long)reply;
> +#else
> +	ulong flags =3D 0;
> +	u32 nr, i;
> +
> +	spin_lock_irqsave(pHba->host->host_lock, flags);
> +	nr =3D  sizeof(pHba->ioctl_reply_context) /
> +		sizeof(pHba->ioctl_reply_context[0]);

ARRAY_SIZE(pHba->ioctl_reply_context)

> @@ -906,8 +1004,20 @@
>  	}
>
>  	pci_set_master(pDev);
> -	if (pci_set_dma_mask(pDev, DMA_32BIT_MASK))
> -		return -EINVAL;
> +	/*
> +	 *	Only try to enable DMA 64 bit mode mode if the dma_addr_t
> +	 *	type can hold 64 bit addresses.
> +	 */
> +	if (sizeof(dma_addr_t) =3D=3D 8 &&
> +	    pci_set_dma_mask(pDev, DMA_64BIT_MASK) =3D=3D 0) {

Identation with tabs?

> +		dma64 =3D 1;
> +	} else {
> +		if (pci_set_dma_mask(pDev, DMA_32BIT_MASK) !=3D 0)
> +			return -EINVAL;
> +	}
> +
> +	/* Make sure pci_alloc_consistent returns 32 bit addresses */
> +	pci_set_consistent_dma_mask(pDev, DMA_32BIT_MASK);
>
>  	base_addr0_phys =3D pci_resource_start(pDev,0);
>  	hba_map0_area_size =3D pci_resource_len(pDev,0);

I don't think that this comment is neccessary, it's the only purpose of thi=
s=20
function. If you want to comment something better write down something=20
like "adapter does only support message blocks below 4GB".

> @@ -929,6 +1039,19 @@
>  		raptorFlag =3D TRUE;
>  	}
>
> +#if BITS_PER_LONG =3D=3D 64
> +	/* x86_64 machines need more optimal mappings */
> +	if (raptorFlag =3D=3D TRUE) {
> +		if (hba_map0_area_size > 128)
> +			hba_map0_area_size =3D 128;
> +		if (hba_map1_area_size > 524288)
> +			hba_map1_area_size =3D 524288;
> +	} else {
> +		if (hba_map0_area_size > 524288)
> +			hba_map0_area_size =3D 524288;
> +	}
> +#endif
> +
>  	base_addr_virt =3D ioremap(base_addr0_phys,hba_map0_area_size);
>  	if (!base_addr_virt) {
>  		pci_release_regions(pDev);

This is very very personal taste, but I would write "512 * 1024" so it's=20
absolutely clear what this number is.

Eike

--nextPart2136109.NgPOTf46Ez
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBIEYxwXKSJPmm5/E4RAvNFAKCIMQlvAPIKYt4yFh1gcNLM/kHaLgCaA0Vl
F03smhZKowzM3dQG7awnuKQ=
=Yo48
-----END PGP SIGNATURE-----

--nextPart2136109.NgPOTf46Ez--
