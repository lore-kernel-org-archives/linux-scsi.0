Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FEDCA6F
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 00:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791504237; cv=none; b=fXg00V5iyZ8LHCi1X/FsAj77/fby77uOZGo+q4WQLpjpazCFQvZ8xeCapoWDWZhPDeSvkxkR2eOSV8LA1eevZHwfp73h3ner87FQBVRfjQXdIoOaTE+Oxany0eVxRwv58wrRzMHkIg2WpvkXgJDaUWPsvsZgDBC7hHywvDNtJwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791504237; c=relaxed/simple;
	bh=tw5gOpw0UlMWRR43e+st8Jbe9EB+voCWucGP+rDM6g4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=eFTps6xi35EvTYsFtrvdPoFtyQjuqJAsUY6QvaZMz4JsN7opLv6kfw2rYFDvm7/APj7IMF263rY6ehwHnawVEMV74QAp8WYodma/SWVMmOVhVdNSLe/1LtyVcHpZ6eBf/UIg+TMUCXTuHnbstXvJY/RqUTES0mBgK4s6jAPYTBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZE5xen9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZE5xen9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6AC1F000FF;
	Fri,  9 Oct 2026 00:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791504236;
	bh=XSKMaZCsZhErrKDE5TEE5rx1KR6Zms4snn8LP0tjkNA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aZE5xen9ZG0r5SCdPDvLRtiXXnqHxWmfXJEyDG9UI9MmBozWjLLkH7qFbhdzZZm1O
	 K717W5Wvezy+kNILfZIif7F5WQ7F2ySXQUIjodOTovuUYuYPRozWXipp+6Pzj/x8vZ
	 5FuMdIFNf9FAN2PK4ZZQgJBVbYQtukkFXeaTOsAb4wxkES9732Yd7GKtgDh0JsIA+I
	 3SmbRauVjnQQy/N1FZ78bD1EU3WprBkwKeHFy7USvESgnVhwx1MxQBPj4mLIAhZ6JT
	 D/YK2+67sDONRTCO1/8i9/kWqZA5zZC8Hxt8YvgNzteijf4HI0IqmvtY1h6NPY3lVa
	 q2MGdhoAQJQEQ==
Message-ID: <sashiko-outbox-164668@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/3] scsi: target: rd: Fix oversized sg table array
 allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sanan Hasanov" <sanan.hasanou@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261008235411.56641-2-sanan.hasanou@gmail.com>
References: <20261008235411.56641-1-sanan.hasanou@gmail.com>
 <20261008235411.56641-2-sanan.hasanou@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 00:03:55 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] target: 32-bit overflow in rd_build_prot_space() truncates protect=
ion array causing NULL dereference
--

commit 4c2aa7a4051244bd60d2a5f1cbee54dc66220984
Author: Sanan Hasanov <sanan.hasanov@ucf.edu>

scsi: target: rd: Fix oversized sg table array allocation

This commit fixes an issue where an unbounded rd_pages parameter could trig=
ger
an oversized allocation attempt. It restricts the maximum page count to
totalram_pages() and transitions sg table arrays to use kvzalloc_objs() to
allow large allocations to fall back to vmalloc.

Link: https://syzkaller.appspot.com/bug?extid=3Dfa495e1497c48a6ed885

> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core=
_rd.c
> index 092d9fe0d4e31..97c63b12266fb 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c

[ ... ]

> @@ -248,7 +255,7 @@ static int rd_build_prot_space(struct rd_dev *rd_dev,=
 int prot_length, int block
>  	total_sg_needed =3D (rd_dev->rd_page_count * prot_length / block_size) =
+ 1;

[Severity: High]
Does this calculation silently overflow for large page counts?

Both rd_page_count (u32) and prot_length (int) undergo 32-bit arithmetic. S=
ince
the new upper bound allows rd_page_count to reach totalram_pages(), a system
with over 2TB of RAM can configure a ramdisk with more than 536 million pag=
es.

Multiplying 536,870,912 by 8 (a common prot_length) overflows a 32-bit inte=
ger,
truncating total_sg_needed to a small value and resulting in an undersized
protection array.

Later, during I/O processing, if a request spans past the end of this trunc=
ated
array, sbc_dif_copy_prot() can exhaust the scatterlist. When sg_next() retu=
rns
NULL, it causes a kernel panic by dereferencing sg->length:

drivers/target/target_core_sbc.c:sbc_dif_copy_prot() {
        ...
        while (psg_len) {
                ...
                len =3D min(psg_len, sg->length - offset);
                ...
        }
        ...
}

Could this calculation be cast to a 64-bit type to prevent the overflow?

>  	sg_tables =3D (total_sg_needed / max_sg_per_table) + 1;
> -	sg_table =3D kzalloc_objs(*sg_table, sg_tables);
> +	sg_table =3D kvzalloc_objs(*sg_table, sg_tables);
>  	if (!sg_table)
>  		return -ENOMEM;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008235411.5664=
1-1-sanan.hasanou@gmail.com?part=3D1
