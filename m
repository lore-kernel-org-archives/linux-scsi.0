Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9B631E826
	for <linux-scsi@vger.kernel.org>; Sat,  8 Aug 2026 10:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786183787; cv=none; b=IUMx3qsWZ8k6G8tLc5ucWqqlhoKvS9S0g2tSUxOHzxifYSdq6m2qL1vZpYamt9e1MllNbuafd3LoSq3GrTXZ4Ds/dn57Yg7SUKfyDq38aG5UOegbtEHZPJ3Bff8MF/cjgnKI2E2OWgGwix37ACwv0u44VSnvmELw7m9jjsq/jPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786183787; c=relaxed/simple;
	bh=RvTHEsQxHebvVjR0ertTVBJKnHSyHIW7evefC0i3fEI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GaMiEJiXDya83Z01U7ols4OS67NlyYGc2Vv6b8SwAPaC3rQ6E1Kzk85TGXWTGOp5sjAX+ejXwSN+SJiv9GTGiJCLTP5H/XiDsRIHJsKHgRzOn4/jkV3j9RhMXmATd4vM9zBP2fR3+Xa3IW2g2fHihDP0dVIxeb770nbUeOWYSJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HOv/jZBd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HOv/jZBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526F51F00A3A;
	Sat,  8 Aug 2026 10:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786183785;
	bh=EQO1HKdIB26NGPKPjJQJuK9Brw+aw479NnaZmdHGqk8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HOv/jZBdx/hdwxU4uCp0n4iA1nMSFvXoj6EQBw6XlMAw5TYYRUNruQTNxrz9/WE+6
	 +5LrkszGJLOmvG9e4WLcmUNG/QJqAD+/+r42xIBIQ3aZW4zI0UvpVzTuDvxKvbQ+sC
	 OpWzfHZpHz5RkBG7w3Nic8p+7ZBLi5e4eH3EkGVE7vO77+M6cptY9tdwhEJqUED6Zg
	 km7FqijHc9smb+e2d4yx2oO8J5XwYk/uPdEDA8D8phmkC+V4Hyf3DrApgw8Wgoy6vz
	 zXuLjiRpRRW64CozUSAvcw3qy0h9r934isjLBd83pJAfegqzEAVRh2RAh7GL9cPcwT
	 i/8kZfVbsc1gA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Avoid freeing unallocated PCIe SGL
 buffers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260808151010.185603-1-chandrakanth.patil@broadcom.com>
References: <20260808151010.185603-1-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 08 Aug 2026 10:09:44 +0000
Message-Id: <20260808100945.526F51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] _base_release_memory_pools() lacks idempotency, causing fatal Use-=
After-Free, double-frees, and NULL pointer dereferences when invoked consec=
utively on error paths.
- [High] Missing NULL check for `ioc->chain_lookup[i].chains_per_smid` duri=
ng partial allocation failure cleanup causes a guaranteed kernel panic due =
to invalid pointer arithmetic.
--

--- Patch [1]: [PATCH] scsi: mpt3sas: Avoid freeing unallocated PCIe SGL bu=
ffers ---
commit 74366255b6baaf468aaa8aa5ff843c58339a10f7
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

scsi: mpt3sas: Avoid freeing unallocated PCIe SGL buffers

_base_release_memory_pools() unconditionally frees every
ioc->pcie_sg_lookup[] entry, including ones the setup loop never
allocated after a partial failure, causing a "bad dma" warning on
debug kernels or a NULL pointer dereference otherwise.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index 791a3c5fbf442..fed7aeffec58d 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -5870,6 +5870,8 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *=
ioc)
> =20
>  	if (ioc->pcie_sgl_dma_pool) {
>  		for (i =3D 0; i < ioc->scsiio_depth; i++) {
> +			if (!ioc->pcie_sg_lookup[i].pcie_sgl)
> +				continue;

[Severity: High]
This is a pre-existing issue, but does adding the array lookup here make
the function unsafe if called twice?

If _base_release_memory_pools() is invoked a second time on an error path
(e.g., if a subsequent operation fails after a retry in
_base_allocate_memory_pools()), ioc->pcie_sgl_dma_pool is still non-NULL
because it was never cleared.

During the second call, the newly added check will attempt to access
ioc->pcie_sg_lookup[i].pcie_sgl. Since ioc->pcie_sg_lookup was set to NULL
at the end of the first call, will this trigger a NULL pointer dereference?

Additionally, variables like ioc->reply_post and ioc->config_page are
freed earlier in this function but never set to NULL. Would it make sense to
clear these pointers and ioc->pcie_sgl_dma_pool so the function is safely
idempotent and avoids double-frees?

>  			dma_pool_free(ioc->pcie_sgl_dma_pool,
>  					ioc->pcie_sg_lookup[i].pcie_sgl,
>  					ioc->pcie_sg_lookup[i].pcie_sgl_dma);
>  			ioc->pcie_sg_lookup[i].pcie_sgl =3D NULL;
>  		}
>  		dma_pool_destroy(ioc->pcie_sgl_dma_pool);
>  	}
>  	kfree(ioc->pcie_sg_lookup);
>  	ioc->pcie_sg_lookup =3D NULL;

[Severity: High]
This isn't a bug introduced by this patch, but while fixing the cleanup
logic in this function, is there a similar vulnerability for
ioc->chain_lookup[i].chains_per_smid?

If kzalloc() for ioc->chain_lookup[i].chains_per_smid partially fails in
_base_allocate_memory_pools(), the unallocated indices are NULL.

In the cleanup loop further down in this function, the code calculates the
pointer offset:

	ct =3D &ioc->chain_lookup[i].chains_per_smid[j];
	if (ct && ct->chain_buffer)
		dma_pool_free(ioc->chain_dma_pool, ...);

If chains_per_smid is NULL and j > 0, C pointer arithmetic will evaluate
this to a non-NULL address. The subsequent check if (ct && ct->chain_buffer)
will falsely pass, leading to an immediate page fault when trying to
dereference memory.

Should we also add a NULL check for ioc->chain_lookup[i].chains_per_smid
before evaluating the offset?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260808151010.1856=
03-1-chandrakanth.patil@broadcom.com?part=3D1
