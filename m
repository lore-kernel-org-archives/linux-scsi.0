Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8D143D515
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790581192; cv=none; b=X2PKhaemLRz6ZqkvVhPV4W86xVo5cSgMEFIjixe78TZPgDvdYW3o0/9JfXj5ZIvjG6+B+RcF/kWR8rVeogZW4gkPVS9eQtlHjLYNHlrYG/jQhKJLEuHby5oVZ2MGh+VPTfqOBWpiUGSqWyieDGpab446D0ZbYxBPHQUYVtn0kDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790581192; c=relaxed/simple;
	bh=fzk8t6I1MVby/pk5FD1h63DcIh64+PkRj0r7sVhSsvQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Yp+C0f0qS0H/3U9OXEhgDh/vtM6EZcrQkI1JJHQLJXowGwbAbxGMOyTL682G+Jj2Jk6qHY7rfNezsS/j0Tsb7Yl0Jb/XfLZ0Orr4Hhi4ccIMOb2XgaoEOAU98X/TiZp1TzvSTK2QxVHQm1UyYoyZoupMNbO8IRGqHTtz7201Y9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ztmxg8Nt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ztmxg8Nt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF0D1F000FF;
	Mon, 28 Sep 2026 07:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790581190;
	bh=FR8eKW/CeZngfxrNWRv4NqrqfjCLgKpuwscPbj7sc+o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ztmxg8NtBJkkiCQidUeq8hSVu9fsn6tu8rCE5x2poTldoq5cPzxNcQk4aoY50DK6X
	 emtLNApi+kpwmsOor6e0kBooI54K4hju0JCcjLFEQjLPJx9ZLXDGFhFVQWUAhrcJtQ
	 VZC3QQHQ4tG23iqEMoEghEaVtXHbfVk7NrL6PjJmMwrfpVOusOqR3wjuzjvAVMcWi0
	 COJQtbWOCVFGPMPSAGFi2Sj1zXdJgHOsSRaY3CkyL7nMSN8TtzJdc1FIFGhf1zfN+8
	 Wu1WUPSpLLHPw3VtTDhhjoTUCqPtil7cOR4aHp7WfkueX7QNnca5ADQKxnrjsOAflT
	 IJD82FFk4pcXg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 05/12] scsi: scsi_debug: Avoid 32-bit overflow in
 WRITE SCATTERED offsets
Reply-To: sashiko-reviews@lists.linux.dev
To: "Niklas Cassel" <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260928072102.725566-19-cassel@kernel.org>
References: <20260928072102.725566-14-cassel@kernel.org>
 <20260928072102.725566-19-cassel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 07:39:49 +0000
Message-Id: <20260928073950.4BF0D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: scsi_debug: out-of-bounds read in sg_copy_buffer via off_t u=
nderflow
--

commit 84b5a3ba9d6d206750a298cdc52cd60cfbdeb0a6
Author: Niklas Cassel <cassel@kernel.org>

scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets

This commit changes num_by and sg_off to 64-bit to avoid 32-bit overflow
issues in resp_write_scat() when handling large LBA ranges. When calling
do_device_access(), it caps sg_off at U32_MAX.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index b64ae3ad300d8..8f9d54269dcec 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
[ ... ]
> @@ -5311,7 +5312,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
>  		 * Write ranges atomically to keep as close to pre-atomic
>  		 * writes behaviour as possible.
>  		 */
> -		ret =3D do_device_access(sip, scp, sg_off, lba, num, group, true, true=
);
> +		ret =3D do_device_access(sip, scp, min_t(u64, sg_off, U32_MAX), lba,
> +				       num, group, true, true);

[Severity: High]
Does capping the offset to U32_MAX here lead to an out-of-bounds memory read
on 32-bit systems when processing descriptors beyond 4 GiB?

do_device_access() takes the capped value as a u32 (sg_skip), and then
passes it down to sg_copy_buffer() which expects an off_t:

lib/scatterlist.c:sg_copy_buffer() {
    size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
                          void *buf, size_t buflen, off_t skip,
                          bool to_buffer)
}

On 32-bit platforms, off_t is a signed 32-bit integer, so the unsigned
U32_MAX (0xFFFFFFFF) is implicitly converted into -1.

When sg_copy_buffer() calls sg_miter_skip(), it uses this negative skip
value:

lib/scatterlist.c:sg_miter_skip() {
    ...
    consumed =3D min_t(off_t, offset, miter->__remaining);
    ...
}

Because offset is -1 and off_t is signed, min_t() selects -1 as the
consumed amount. This bypasses the skip loop and offsets the iterator
backwards, setting its internal byte offset to 0xFFFFFFFF.

Could this cause subsequent pointer arithmetic to point one byte before the
mapped page, resulting in an out-of-bounds memory copy?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928072102.7255=
66-14-cassel@kernel.org?part=3D5
