Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE6446AF2C
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 22:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499852; cv=none; b=pkvPDMcxbdGOTnhJSLiLxfV99FXnu+zgjfB+xETLT1rD8KoqS0Qm12o5Uqz6qpjGl5tqdeQBZXN6spsYQDAbXNQeQYERN3g4Xp9I2jBaLI3Y5zZiT2YyNa58QQzmXKLHTiQUc7rEoItggcfuVzPu6UBHJrpTKOh5vHuZa+bE/lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499852; c=relaxed/simple;
	bh=99IsG/vc/0Xq01Bghge+JU1FVzHQxq01YUiOMKRbguQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=C8WbJYP3qErWUPYk+Zd8RNRFmVaeuV8CftFkq1g7nVa8Jx9sRe0aJ5xNl9g7+x/YihLLTt+FT0SYh/aCzAOOP/rTjaBdQ9HqaC2HpTOcWniagPdg9wlT1iagDGbrquAL+v1Zw+3F1WXQFfdP3CbrzkI6Mf8Hxq5Vx7owFS+ZWko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RgtSubPB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RgtSubPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286B21F000FF;
	Thu,  8 Oct 2026 22:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791499851;
	bh=1QvP7XfihigVihLtiR+qI2TcTS3yPdVuXMY+ZH8Kky8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RgtSubPBXYjfiF1mRoqZgYVwLUMdsaTv1VNUPBgFKBiDZyAP2gqsuR/jx6w5UyjlN
	 KzhFzrRB6fXvzgS0XfbXdNvEz7n8lweejRUzrT3fc3igaDabL3KGCeQm35KSpdJcLX
	 aCdDBIO1kSM0oXHqabwMMrTqAaPwsd86b0xGvg5B440GGPSgQbbBSygYQyMdCo3CGN
	 sKDxvA1AuErm1DuC649InjEjV4FHqcWyHCW8fj2NM9dF5XPAA4qk8226iHFfBrCWo3
	 qqbNjYod/oYO7icKuGKf0re1gn7mXO+WH2Btr2AExnAd1Mo2vQFWQFIRY3VsRDCMpB
	 8CoMRiPK86K7A==
Message-ID: <sashiko-outbox-164646@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] scsi: target: rd: Fix oversized sg table array
 allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sanan Hasanov" <sanan.hasanou@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261008223712.49827-2-sanan.hasanou@gmail.com>
References: <20261008223712.49827-1-sanan.hasanou@gmail.com>
 <20261008223712.49827-2-sanan.hasanou@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 22:50:50 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] target: bypass of totalram_pages limit via configfs causes unbound=
ed allocation and leak
--

commit 080421786d44f31a44c204db4deacf32fd54462e
Author: Sanan Hasanov <sanan.hasanov@ucf.edu>
scsi: target: rd: Fix oversized sg table array allocation

This commit adds a limit check to ensure the ramdisk page count does not
exceed totalram_pages() during device configuration, avoiding large
out-of-bounds allocations. It also changes kzalloc_objs to kvzalloc_objs to
fallback to vmalloc for large valid page counts.

Closes: https://syzkaller.appspot.com/bug?extid=3Dfa495e1497c48a6ed885

> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core=
_rd.c
> index 092d9fe0d4e31..97c63b12266fb 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c

[ ... ]

> @@ -188,10 +189,16 @@ static int rd_build_device_space(struct rd_dev *rd_=
dev)
>  	if (rd_dev->rd_flags & RDF_NULLIO)
>  		return 0;
> =20
> +	if (rd_dev->rd_page_count > totalram_pages()) {
> +		pr_err("Page count: %u exceeds total RAM pages: %lu for Ramdisk device=
\n",
> +		       rd_dev->rd_page_count, totalram_pages());
> +		return -EINVAL;
> +	}
> +
>  	total_sg_needed =3D rd_dev->rd_page_count;
> =20
>  	sg_tables =3D (total_sg_needed / max_sg_per_table) + 1;
> -	sg_table =3D kzalloc_objs(*sg_table, sg_tables);
> +	sg_table =3D kvzalloc_objs(*sg_table, sg_tables);
>  	if (!sg_table)
>  		return -ENOMEM;
> =20

[ ... ]

> @@ -248,7 +255,7 @@ static int rd_build_prot_space(struct rd_dev *rd_dev,=
 int prot_length, int block
>  	total_sg_needed =3D (rd_dev->rd_page_count * prot_length / block_size) =
+ 1;
> =20
>  	sg_tables =3D (total_sg_needed / max_sg_per_table) + 1;
> -	sg_table =3D kzalloc_objs(*sg_table, sg_tables);
> +	sg_table =3D kvzalloc_objs(*sg_table, sg_tables);

[Severity: High]
Does this code still allow an unbounded memory allocation bypass and a
resource leak?

While a totalram_pages() limit check was added to rd_build_device_space()
above, the configfs control attribute can dynamically update
rd_dev->rd_page_count via rd_set_configfs_dev_params() after the device
is already configured:

drivers/target/target_core_rd.c:rd_set_configfs_dev_params() {
    ...
    rd_dev->rd_page_count =3D arg;
    ...
}

If a massive page count is set dynamically and then PI protection is enabled
by writing to the pi_prot_type attribute, rd_init_prot() calls
rd_build_prot_space(). The bypassed rd_page_count is used to calculate
total_sg_needed here, potentially re-triggering the memory exhaustion
without any limit checks.

Additionally, if the large allocation fails downstream in
rd_allocate_sgl_table(), rd_build_prot_space() returns the error but leaves
rd_dev->sg_prot_array pointing to the partially populated table without
freeing it. Since pi_prot_type transitions back to 0 on failure, can the us=
er
repeatedly trigger this path to leak system memory?

>  	if (!sg_table)
>  		return -ENOMEM;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008223712.4982=
7-1-sanan.hasanou@gmail.com?part=3D1
