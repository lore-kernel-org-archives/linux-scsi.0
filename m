From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: mpt3sas: memory allocation for firmware upgrade DMA memory
 question
Date: Thu, 26 May 2016 10:20:08 -0400
Message-ID: <2f1d5310-c6b5-db9a-6e62-4e5dc96a06a6@suse.com>
References: <20160525091853.psv6kml6oingj4fx@c203.arch.suse.de>
 <c2f16ce7d75be5869b5888fa5198c40a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="smgauGuN6RAlEFCCddQwnqTBWWkeq1oeo"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbcEZOUO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2016 10:20:14 -0400
In-Reply-To: <c2f16ce7d75be5869b5888fa5198c40a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chaitra Basappa <chaitra.basappa@broadcom.com>, Johannes Thumshirn <jthumshirn@suse.de>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--smgauGuN6RAlEFCCddQwnqTBWWkeq1oeo
Content-Type: multipart/mixed; boundary="4tsMpmqLMV8FerbFqf5kBcCT6Xrpok137"
From: Jeff Mahoney <jeffm@suse.com>
To: Chaitra Basappa <chaitra.basappa@broadcom.com>,
 Johannes Thumshirn <jthumshirn@suse.de>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Message-ID: <2f1d5310-c6b5-db9a-6e62-4e5dc96a06a6@suse.com>
Subject: Re: mpt3sas: memory allocation for firmware upgrade DMA memory
 question
References: <20160525091853.psv6kml6oingj4fx@c203.arch.suse.de>
 <c2f16ce7d75be5869b5888fa5198c40a@mail.gmail.com>
In-Reply-To: <c2f16ce7d75be5869b5888fa5198c40a@mail.gmail.com>

--4tsMpmqLMV8FerbFqf5kBcCT6Xrpok137
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 5/26/16 6:16 AM, Chaitra Basappa wrote:
> Johannes,
>  Could you please let us know which application is being used for firmw=
are
> upgrade ?? Whether it is your own customized application or LSI provide=
d
> applications?

It's the sas2flash app from the LSI web site.  Specifically, from
Installer_P20_for_Linux.zip.

> Also our application use single contiguous memory buffer for ioctls and=

> hence mpt3sas driver is using single contiguous memory for the DMA
> operation.
>=20
> If we use GFP_KERNEL flag then it may be possible that ioctl thread may=

> hang/wait for long,  if it doesn't get required memory from the system.=


I don't think that's a good justification for using GFP_ATOMIC.
GFP_ATOMIC is for "must not sleep" not "we'd like this to be relatively
low latency."  The mpt3sas code uses GFP_KERNEL in places that, at a
glance, are more sensitive to latency.  If there are uses of the ioctls
that are extremely sensitive to latency and can handle the failures that
may occur with use of GFP_ATOMIC, they should be documented and handled
as separate cases.  Transferring a firmware image isn't one of them.

> We may need to test below patch thoroughly , as I don=E2=80=99t see all=
ocation of
> several non-contiguous chunks of memory in below patch...,

The patch doesn't implement that part of it.  Johannes was asking if
having the memory be a contiguous chunk was a hardware requirement
before writing the code to do scatter gather with multiple discontiguous
ranges.

-Jeff

> Thanks,
>  Chaitra
>=20
> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Wednesday, May 25, 2016 2:49 PM
> To: Chaitra P B; Suganath Prabu Subramani
> Cc: Linux SCSI Mailinglist; Jeff Mahoney
> Subject: mpt3sas: memory allocation for firmware upgrade DMA memory
> question
>=20
> Hi Chaitra and Suganath,
>=20
> I've got a question regarding mpt3sas' memory allocation used when doin=
g a
> firmware upgrade. Currently you're doing a pci_alloc_consitent() which
> tries to allocate memory via GFP_ATOMIC. This memory then is passed as =
a
> single element on a sg_list.
>=20
> Jeff reported it returned -ENOMEM on his Server due to highly fragmente=
d
> memory.
>=20
> Is it required to have the memory for the DMA operation contiguous, or =
can
> I just allocate several non-contiguous junks of memory and map it to a
> sg_list?
>=20
> If not, is GFP_ATMOIC really needed? I've converted the driver to use
> GFP_KERNEL but I'm a bit reluctant to test below patch on real hardware=
 to
> not brick the HBA.
>=20
> Thanks,
> 	Johannes
>=20
> RFC patch for GFP_KERNEL allocation, though splitting into multiple sg
> mapped elements is the preferred fix here:
>=20
> From 06e63654d887df7f740dc5abcb40d441a8da7fa5 Mon Sep 17 00:00:00 2001
> From: Johannes Thumshirn <jthumshirn@suse.de>
> Date: Tue, 24 May 2016 17:25:59 +0200
> Subject: [RFC PATCH] mpt3sas: Don't do atomic memory allocations for
> firmware  update DMA
>=20
> Currently mpt3sas uses pci_alloc_consistent() to allocate memory for th=
e
> DMA used to do firmware updates. pci_alloc_consistent() in turn uses
> GFP_ATOMIC allocations. On a host with high memory fragmention this can=

> lead to page allocation failures, as the DMA buffer holds the complete
> firmware update and thus can need page allocations of higher orders.
>=20
> As the firmware update code path may sleep, convert allocation to a nor=
mal
> kzalloc() call with GFP_KERNEL and map it to the DMA buffers.
>=20
> Reported-by: Jeff Mahoney <jeffm@suse.com>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c | 39
> ++++++++++++++++++++++++++++----------
>  1 file changed, 29 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> index 7d00f09..14be3cf 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -751,8 +751,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc,
> struct mpt3_ioctl_command karg,
>=20
>  	/* obtain dma-able memory for data transfer */
>  	if (data_out_sz) /* WRITE */ {
> -		data_out =3D pci_alloc_consistent(ioc->pdev, data_out_sz,
> -		    &data_out_dma);
> +		data_out =3D kzalloc(data_out_sz, GFP_KERNEL);
>  		if (!data_out) {
>  			pr_err("failure at %s:%d/%s()!\n", __FILE__,
>  			    __LINE__, __func__);
> @@ -760,6 +759,14 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc,
> struct mpt3_ioctl_command karg,
>  			mpt3sas_base_free_smid(ioc, smid);
>  			goto out;
>  		}
> +		data_out_dma =3D pci_map_single(ioc->pdev, data_out,
> +					      data_out_sz,
> PCI_DMA_TODEVICE);
> +		if (dma_mapping_error(&ioc->pdev->dev, data_out_dma)) {
> +			ret =3D -EINVAL;
> +			mpt3sas_base_free_smid(ioc, smid);
> +			goto out_free_data_out;
> +		}
> +
>  		if (copy_from_user(data_out, karg.data_out_buf_ptr,
>  			data_out_sz)) {
>  			pr_err("failure at %s:%d/%s()!\n", __FILE__, @@
> -771,8 +778,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struc=
t
> mpt3_ioctl_command karg,
>  	}
>=20
>  	if (data_in_sz) /* READ */ {
> -		data_in =3D pci_alloc_consistent(ioc->pdev, data_in_sz,
> -		    &data_in_dma);
> +		data_in =3D kzalloc(data_in_sz, GFP_KERNEL);
>  		if (!data_in) {
>  			pr_err("failure at %s:%d/%s()!\n", __FILE__,
>  			    __LINE__, __func__);
> @@ -780,6 +786,13 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc,
> struct mpt3_ioctl_command karg,
>  			mpt3sas_base_free_smid(ioc, smid);
>  			goto out;
>  		}
> +		data_in_dma =3D pci_map_single(ioc->pdev, data_in,
> +					     data_in_sz,
> PCI_DMA_FROMDEVICE);
> +		if (dma_mapping_error(&ioc->pdev->dev, data_in_dma)) {
> +			ret =3D -EINVAL;
> +			mpt3sas_base_free_smid(ioc, smid);
> +			goto out_free_data_in;
> +		}
>  	}
>=20
>  	psge =3D (void *)request + (karg.data_sge_offset*4); @@ -1013,13
> +1026,19 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct
> mpt3_ioctl_command karg,
>   out:
>=20
>  	/* free memory associated with sg buffers */
> -	if (data_in)
> -		pci_free_consistent(ioc->pdev, data_in_sz, data_in,
> -		    data_in_dma);
> +	if (data_in) {
> +		pci_unmap_single(ioc->pdev, data_in_dma,
> +				 data_in_sz, PCI_DMA_TODEVICE);
> +out_free_data_in:
> +		kfree(data_in);
> +	}
>=20
> -	if (data_out)
> -		pci_free_consistent(ioc->pdev, data_out_sz, data_out,
> -		    data_out_dma);
> +	if (data_out) {
> +		pci_unmap_single(ioc->pdev, data_out_dma,
> +				 data_out_sz, PCI_DMA_FROMDEVICE);
> +out_free_data_out:
> +		kfree(data_out);
> +	}
>=20
>  	kfree(mpi_request);
>  	ioc->ctl_cmds.status =3D MPT3_CMD_NOT_USED;
> --
> 1.8.5.6
>=20
>=20
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
>=20


--=20
Jeff Mahoney
SUSE Labs


--4tsMpmqLMV8FerbFqf5kBcCT6Xrpok137--

--smgauGuN6RAlEFCCddQwnqTBWWkeq1oeo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXRwYYAAoJEB57S2MheeWyVXkQALcScWgf3wxxiOktw67y8GNv
GG8Awk37OZK+8ljg87tT/DpmQpS/UGm6iJ9EPhp2fVqTpTSXNl/209NefbX7bf8S
+Ya6UEC+R3KBacdOWOw/7yayMJDbUz3D1lhrZWhvLevsZvho/34xFNJzZ9yPVe3/
n0Pad6O9cmSalLvciZ6D+5wYDg6wPco6FcCRFRflc5JSGQlih+JsxyOT4eGH0XYk
iLy0bpy0AQ804wyuGjJ8E8Citfem89kti71LZl9ZxmX598/L/wPXXQrSpz83PGSN
Qk/NcxFnjlKMcjvo6e0nHfgS7E+RtkGyuYh3GNUppQcWp3E7oP0ACt7rn9x4B/Rv
1o6fUSanOgQ5JScBA9kiQpbK0jRe0EQb/v7ri3tZgY6ZSaxEOU01DlkAZLrGgX9m
KWBSV0ZAUzgR1GY2bQr8yK8mS24qIOJfnOwKOAp510mlpt0F9+QpEQ99Jbu8LVxD
Fv0S4WTp/E/lZJkVUJJrlgfs6aNqIic9PVIsTWC63bmt+qS4U75vVZCuFsiGUTng
achjwpZucZv9qs2DUkrO+Pitr/vb2g+kUyvcmH61w3EKEpV51DkdG4Cg0JVFL/LW
cFYsxyQrhuYSFWAZmPTPY4yOowTtz7rZoAPt/vrrDADacx7GaA/orAH6CjuBp5//
ydPN/4I9VcOK8+cC88EU
=Isz6
-----END PGP SIGNATURE-----

--smgauGuN6RAlEFCCddQwnqTBWWkeq1oeo--
