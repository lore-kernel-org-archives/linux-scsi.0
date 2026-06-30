Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A5A3FFFB8
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 11:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782819469; cv=none; b=g3EptFZBLCpdi/LiIRibfiMQDdhxUoIKkTa5hTLYM+LlIfMzhEH8RJjFs2bH4reUql3fu3cNm6CoKYMNxCW2JqhANNgx3BVJ1WRT7yC0bTRp04tQ/z4DMWJj0QZq41qiFrh8rI/D+lFMASame261H6QWBUBChcij1rzKuTn+Gek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782819469; c=relaxed/simple;
	bh=HMdAOtdZ/5N0CGcxT4f4emwIitPjenN5yrISIN7/sa4=;
	h=From:Subject:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BZEMZyaP+ltMpPK1BmFNf4YrBQF+B7qdGV/Y4Ty9TnZGS2y2aPOjWYbwWO8rrxEvd1U/+MbvzwFGS2N/Nxb6eBroHxPZ6r7cBcbOBMSHJHoYKG5tnr0UA6FKQ2WYuV5cmhVz6bSsA6eViQoGQVL/evaT8n460qtgpBpPq0JEi8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P1wgsVmb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P1wgsVmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6173E1F00A3A
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 11:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782819468;
	bh=T/oEVxLW0rMOhGmJccQpF3in9WMTX8b6mxf7AjzH1Dg=;
	h=From:Subject:Reply-To:Cc:In-Reply-To:References:Date;
	b=P1wgsVmbhmJ4khZvthHQ5NEQf26bzomFJvRXIje8qsxMKiz1NXytRAqqWB/RQOfIb
	 R4JfFe4HpEC07khrb96HqsbHakoQVNZS088em1Bb0HvAJ5Gemox828bV+GmIBheV7H
	 4fGJq5jgH1Ntqw6im0o6J5kGOubmvc1Q5cDiNFLNxKhdE4dmIFJJN8CRSZ4CeHiGtH
	 3NiVXWTG8TaF/ri9k+OnAPY6uxp8RkQ7Q9RL1bUNpqf5cRw8Qii4jjNEv4Kq3fC2fo
	 7k4xs7lN8R6oTEcsWUvj308UXdhHqZi9GAa3tw3cn+o0FbH2MB6z0M2YqzqYxQLdNw
	 RYlKpMRgNQJnA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] scsi: sym53c8xx_2: replace __get_free_pages() with
 kmalloc()
Reply-To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260630-b4-scsi-v1-4-494fb37ebe7b@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-4-494fb37ebe7b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 11:37:48 +0000
Message-Id: <20260630113748.6173E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Replacing `__get_free_pages()` with `kmalloc()` breaks the driver'=
s custom buddy allocator due to lost page-alignment guarantees, leading to =
memory leaks, free-list corruption, and kernel panics on `kfree()`.
--

commit 62e084c005e487c40de6e3803058c9fb57c50b32
Author: Mike Rapoport (Microsoft) <rppt@kernel.org>

scsi: sym53c8xx_2: replace __get_free_pages() with kmalloc()

This commit replaces __get_free_pages() with kmalloc() and free_pages() with
kfree() for the internal memory allocator in the sym53c8xx_2 driver.

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redh=
at.com

> diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx=
_2/sym_hipd.h
> index 9231a28990643..aa365e8ba66fc 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
> +++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
> @@ -1110,9 +1110,9 @@ sym_build_sge(struct sym_hcb *np, struct sym_tblmov=
e *data, u64 badd, int len)
>   */
> =20
>  #define sym_get_mem_cluster()	\
> -	(void *) __get_free_pages(GFP_ATOMIC, SYM_MEM_PAGE_ORDER)
> +	kmalloc(PAGE_SIZE << SYM_MEM_PAGE_ORDER, GFP_ATOMIC)

[Severity: High]
Does this change break the driver's custom buddy allocator?

The custom allocator in drivers/scsi/sym53c8xx_2/sym_malloc.c relies strict=
ly
on the page-alignment guarantees provided by __get_free_pages().

When ___sym_mfree() is called, it computes buddy addresses using bitwise
operations:

drivers/scsi/sym53c8xx_2/sym_malloc.c:___sym_mfree() {
    ...
		b =3D a ^ s;
    ...
		a =3D a & b;
    ...
			M_FREE_MEM_CLUSTER((void *)a);
    ...
}

If kmalloc() returns an unaligned pointer (which can happen when
CONFIG_SLUB_DEBUG or KASAN is enabled), the XOR computation will yield an
incorrect buddy address.

Furthermore, the bitwise AND rounds the address down, losing any unaligned
offset provided by kmalloc(). When this rounded address is later passed to
kfree(), it can trigger a SLUB BUG or kernel panic because the pointer is
invalid.

Should this allocation remain page-aligned to satisfy the buddy allocator's
requirements?

>  #define sym_free_mem_cluster(p)	\
> -	free_pages((unsigned long)p, SYM_MEM_PAGE_ORDER)
> +	kfree(p)
> =20
>  /*
>   *  Link between free memory chunks of a given size.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630-b4-scsi-v1=
-0-494fb37ebe7b@kernel.org?part=3D4
