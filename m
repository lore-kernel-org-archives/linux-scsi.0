Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033398;
	b=ZH+It+VOvKOp6btF4ZQev3YEsuw3SphTcqkiAZvgVHSCQGsmiKFPSWPK2UjAcquKMrsQ
	 63wpQ7GUe7LKSL4ncyrD0BC+KxANnK1Hc8ox7a/R9urMjm0HmKfazIo1vEB6j2YyRn+pb
	 2g9ybdMjxbvy5g+2lRkbhZ2gZAsHuSRDC6zir4in9buV6YgAlZVKM3RfkE8SGtNjJ7fWe
	 MbFseOt0yciKUt3Wmp5fcsHEJcXwBRCh9pZHyeSDkoL4JvNbS6WX0VRAA2fD0TPp6eJA6
	 j0A+3T9ntImUMWefNlptQ9dhdEJzuiFAwjeNFYDc2WVstOewUjI5unBPcciC1NaEIrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033398;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gzaW36GUGoZA0ogcJPtc4nDtXtsC9MsC3FeqHBWyE7o=;
	b=qIjGwdwt20UzcUsmyHiA+8Yx9KWwrPiUE/oY/6Ib4Dhegw8bldbj2S6gMW7+Rh8YRhsD
	 onFFHZoELuvBvPYl3LbjDi+EpNqalIlpiLTCNqnqtbIsh0t1k/DL64xdDGG5Uf3DmH/XT
	 r65K03s0s28Z2J48Mw+shsnFV3Oii63VlArXkzWnd5u475ouLZgYkgSJ1pSz7d6CUVh5J
	 6v1zHmI6TxR5X3csQ+1wc77CKrFWs2qTRPPLlJIviMtbxemznsowATaQ/blSXPZ4jw8tU
	 8tZNRTmv4mhoILyn/7I8X7fSltyHIFRGdxf5pVTJUONw1kzMHGJYDQLbEqXFMM3djug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fiqw33DS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC137606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 20:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fiqw33DS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788C41F000C5;
	Wed, 18 Nov 2026 20:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795033398;
	bh=gzaW36GUGoZA0ogcJPtc4nDtXtsC9MsC3FeqHBWyE7o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fiqw33DSisYZlEU5KHAQ9ckyV8gD2XRyMERb7KL5Vwnkhw/nxmpTgcm+p2BAL3/gG
	 PCTL/H/LjCvKpHJcxXSk9yE1rAqRA7CF87hkJTCPxJb6n1Nue/Ab/gwK0BRSe9Qe0l
	 OaY/VjFsWa/lFoQyZ3WG7AIODgtItQjW92GcwSTtHo+RIpGKTtStX1I5A7AoX1bBai
	 4AdMOtDtxJnsaf5NsQt2uNOp9QWTBI0zc4gjdnNWN+gdP9fy85Q7lBlkvwcJcyZeSQ
	 /p/3SfGM3959uY3eRSPWhRHHC0HVLCtQQlr1/HM7vO/WSlLwICIEH+qFmbCjyRdPSg
	 +OaKy8tHa4VHA==
Message-ID: <sashiko-outbox-221931@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Fix out-of-bounds cpu_msix_table read on
 CPU hotplug
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis Sautier" <sautier.louis@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261118201316.326943-1-sautier.louis@gmail.com>
References: <20261118201316.326943-1-sautier.louis@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 20:23:18 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] scsi: mpt3sas: ignored non-EAGAIN error in
  mpt3sas_base_attach() [1]
--

commit 68d13dcfec52a6dc8ae0711092e3869b07e277ea
Author: Louis Sautier <sautier.louis@gmail.com>

scsi: mpt3sas: Fix out-of-bounds cpu_msix_table read on CPU hotplug

This commit allocates cpu_msix_table with nr_cpu_ids entries instead of
sizing it from the highest online CPU at probe time, and maps all CPUs in
each reply queue's affinity mask so CPUs onlined after probe do not cause
out-of-bounds reads in _base_get_msix_index().

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index 5c957044eded1..b33a3e49608dd 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c

[ ... ]

> @@ -8409,15 +8406,18 @@ int
>  mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
>  {
>  	int r, i, rc;
> -	int cpu_id, last_cpu_id =3D 0;
> =20
>  	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
> =20
>  	/* setup cpu_msix_table */
>  	ioc->cpu_count =3D num_online_cpus();
> -	for_each_online_cpu(cpu_id)
> -		last_cpu_id =3D cpu_id;
> -	ioc->cpu_msix_table_sz =3D last_cpu_id + 1;
> +	/*
> +	 * Allocate an entry for every possible CPU, because
> +	 * _base_get_msix_index() indexes the table with
> +	 * raw_smp_processor_id(), which can be a CPU brought online after
> +	 * the adapter was attached.
> +	 */
> +	ioc->cpu_msix_table_sz =3D nr_cpu_ids;
>  	ioc->cpu_msix_table =3D kzalloc(ioc->cpu_msix_table_sz, GFP_KERNEL);
>  	ioc->reply_queue_count =3D 1;
>  	if (!ioc->cpu_msix_table) {

[Severity: High]
This problem wasn't introduced by this patch, but later in
mpt3sas_base_attach() [1], does a failure from the first
_base_make_ioc_operational() call get ignored when it returns an error
other than -EAGAIN?

drivers/scsi/mpt3sas/mpt3sas_base.c:mpt3sas_base_attach() {
    ...
	r =3D _base_make_ioc_operational(ioc);
	if (r =3D=3D -EAGAIN) {
		r =3D _base_make_ioc_operational(ioc);
		if (r)
			goto out_free_resources;
	}
    ...
	return 0;
}

If _base_make_ioc_operational() fails in _base_static_config_pages() or
_base_event_notification() with an error such as -EFAULT,
mpt3sas_base_attach() falls through and returns 0 instead of jumping to
out_free_resources, leaving _scsih_probe() with a partially initialized
adapter.

[1] https://sashiko.dev/#/bug/linux-864ab92c-c52e-45ab-b16b-b4499e83a698

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118201316.3269=
43-1-sautier.louis@gmail.com?part=3D1
