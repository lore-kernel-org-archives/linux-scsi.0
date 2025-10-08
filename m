Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60BA246782
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 12:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759926827; cv=pass; b=YMB/ZYRMJyVIdRyUyf08nDb//iBQnnK+VPtw5JjCXRFy7uQoB+0880wDhFQw35eGwGjJo/WBwn2q1ifuEYRclv1JNacn3ltsD9kkZoK3t6rlLOCMkOoXTI998lRtPeTSQVJK9xd6DdnnQPLy/zlWFXi+zW4fVSboEUVHaNbjeYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759926827; c=relaxed/simple;
	bh=uqWLt/5e9UNaxnaNjG7py4y/kvst1/+AiWhbPm6ODtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FY8IjuLtD0FIG+sRDKg8n1BRq//YDG9TO3jEKDCoFRGSrq1azUDCAjCM4M/NCWLe2izlNikRGT0e+iI2INNhM3JWDMW48Mcv8TNU4hqDO9YNxT90EFeqsO67HUMiSzTeowKunI4bDNn0exSYnV1kN9RaLfZ1OS7106pH0S3HrtM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=sebastian.reichel@collabora.com header.b=RoTUWqq3; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=sebastian.reichel@collabora.com header.b="RoTUWqq3"
ARC-Seal: i=1; a=rsa-sha256; t=1759926808; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=F3nxMa8gkwOS3Tr+1rvS+NBfcl88L49EnODrCGis/2e/Y3toZpGd3PP3Fz2ngiXAo//fA4Y8UBZn/qTOF1n3PCgwsoIaYLJLB2iNQyHXIKlye23T4VMK4nBbS7oeIRVMmeqlrEWMmyLGhoJOlno8u3xqr8fo1IJy7+5FPMUqp5I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1759926808; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=xdaCiXZb8WZz+UCtepyABcHNesCF9quVseypjTYZY90=; 
	b=YPqv8Xa7J8MbeKwr0t3enTCNRLLzIOlqRvcfgLj2wLhfLg7QMoEFT3+3wytNcwUrpfjiAgFxzxzslmMTknVI1GkunRWBdQY2+UDrwruMm3c5f4FbZB1z6jfmguy0VQvKFqvZRQW9keW5xHZ0bMVGf+eUpytPSNKG8n7ys7WgVU4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=sebastian.reichel@collabora.com;
	dmarc=pass header.from=<sebastian.reichel@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1759926808;
	s=zohomail; d=collabora.com; i=sebastian.reichel@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
	bh=xdaCiXZb8WZz+UCtepyABcHNesCF9quVseypjTYZY90=;
	b=RoTUWqq3YkR6GXoB6zBrjEHLauMhLfFxNBqH6MIJZDesFs4yk04pBCaHT+7zIAjd
	FtZ+kCXYEx6QAvNIqKJTYFFMFD5si3xSRyug0hjcSLrfU7/Z4i4D2RHP0lgsXYNmoLW
	a52X8PvmqEl6PmWpo8vlqR33kVrxydzy3qwxCqb0=
Received: by mx.zohomail.com with SMTPS id 1759926805365927.5522618996117;
	Wed, 8 Oct 2025 05:33:25 -0700 (PDT)
Received: by venus (Postfix, from userid 1000)
	id A9A6D182747; Wed, 08 Oct 2025 14:33:21 +0200 (CEST)
Date: Wed, 8 Oct 2025 14:33:21 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
Message-ID: <vhnrjjp5oneqdt7uuecsrtdpswqwkvkwl67ieorcseyratjrtz@rydijawoeimv>
References: <20251007214800.1678255-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rue7sdx53v22dxzs"
Content-Disposition: inline
In-Reply-To: <20251007214800.1678255-1-bvanassche@acm.org>
X-Zoho-Virus-Status: 1
X-Zoho-Virus-Status: 1
X-Zoho-AV-Stamp: zmail-av-1.4.3/259.882.13
X-ZohoMailClient: External


--rue7sdx53v22dxzs
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
MIME-Version: 1.0

Hi,

On Tue, Oct 07, 2025 at 02:48:00PM -0700, Bart Van Assche wrote:
> Commit 995412e23bb2 ("blk-mq: Replace tags->lock with SRCU for tag
> iterators") introduced the following regression:
>=20
> Call trace:
>  __srcu_read_lock+0x30/0x80 (P)
>  blk_mq_tagset_busy_iter+0x44/0x300
>  scsi_host_busy+0x38/0x70
>  ufshcd_print_host_state+0x34/0x1bc
>  ufshcd_link_startup.constprop.0+0xe4/0x2e0
>  ufshcd_init+0x944/0xf80
>  ufshcd_pltfrm_init+0x504/0x820
>  ufs_rockchip_probe+0x2c/0x88
>  platform_probe+0x5c/0xa4
>  really_probe+0xc0/0x38c
>  __driver_probe_device+0x7c/0x150
>  driver_probe_device+0x40/0x120
>  __driver_attach+0xc8/0x1e0
>  bus_for_each_dev+0x7c/0xdc
>  driver_attach+0x24/0x30
>  bus_add_driver+0x110/0x230
>  driver_register+0x68/0x130
>  __platform_driver_register+0x20/0x2c
>  ufs_rockchip_pltform_init+0x1c/0x28
>  do_one_initcall+0x60/0x1e0
>  kernel_init_freeable+0x248/0x2c4
>  kernel_init+0x20/0x140
>  ret_from_fork+0x10/0x20
>=20
> Fix this regression by making scsi_host_busy() check whether the SCSI
> host tag set has already been initialized. tag_set->ops is set by
> scsi_mq_setup_tags() just before blk_mq_alloc_tag_set() is called. This
> fix is based on the assumption that scsi_host_busy() and
> scsi_mq_setup_tags() calls are serialized. This is the case in the UFS
> driver.
>=20
> Reported-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> Closes: https://lore.kernel.org/linux-block/pnezafputodmqlpumwfbn644ohjyb=
ouveehcjhz2hmhtcf2rka@sdhoiivync4y/
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Tested-by: Sebastian Reichel <sebastian.reichel@collabora.com>

-- Sebastian

>  drivers/scsi/hosts.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index cc5d05dc395c..17173239301e 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -611,8 +611,9 @@ int scsi_host_busy(struct Scsi_Host *shost)
>  {
>  	int cnt =3D 0;
> =20
> -	blk_mq_tagset_busy_iter(&shost->tag_set,
> -				scsi_host_check_in_flight, &cnt);
> +	if (shost->tag_set.ops)
> +		blk_mq_tagset_busy_iter(&shost->tag_set,
> +					scsi_host_check_in_flight, &cnt);
>  	return cnt;
>  }
>  EXPORT_SYMBOL(scsi_host_busy);

--rue7sdx53v22dxzs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmjmWg0ACgkQ2O7X88g7
+poq6g//aZhsrfGUUWyaJBvGioti7QeBicDfvbVkkRxlccygNMIf3AFuyszPj90d
gtCK2XKIF/bRFf4hc02urPHp0hUSjd42nSchAcz5jLm/0C38nEEbMsjZWhqkUR/4
BwXrN0mSzypNswUORK/hBNcthfHBdgwRwCFv5pfI6zT0ab38xPDgP8AnJYYdydEQ
IgMtjCvcwB6xy6uuqdbmw7wfBcaQ7xxOocgVrzw8Gzxco0X/CWv7TfQzD1AM1jq9
/twucU4szkY4HeNWOnfQOZASta+I+kfHYLuSG7TfUlTkApVIoBmXlO4YfR6RrXG5
0yfkDxHMCzJHcAfedmil7j1O9DWzHchmJ6wzIa+5iWm5it0xrX+GDHVXgENHOUMT
c3KGQouFzXHKa9FPdLj1OH4xrcBY26aGxZBvLUpBml2bmw2PMaVtAs6PLJTIOaCE
FdG7jhlPZEgXz2+1o4KZluuBbripcZnZocq2WlC3l+SyVU23UKLYB1LHivsftx1N
tw36y+UR2of/bUk/ayZa2yBI9jo/uwGo1qqTyqcGv+pYlnGS09fAlHlPadhx07xO
LteAdFTy1/rct9d1XwpdYDTdrrngYMZIykPCGf2Sa0bEigriAqPZWUrzwYwfkSUL
N3+Ymd+LACdTeRoJIDiJjJbqh3qZYu2/ztUfDsmCgyM7wtbiAKI=
=iZ+H
-----END PGP SIGNATURE-----

--rue7sdx53v22dxzs--
