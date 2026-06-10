Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CE336F90E
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 04:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781066242; cv=none; b=sC0bDAofThYjAfh6mdNQxCtwGbGVPpnefkMgkokE79n3T86tXQRh6fPR9WP3T+2OwumAgNFKVeIkclg+uee2+IFZ3yVcaCMxRKZg5pDoub5bP6tXtv/s9z0EoArzCDfZ6sNNP8QPV2Xv/brFVnwI+WIXjwBH6wmm0A5KG6JgfUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781066242; c=relaxed/simple;
	bh=zAgOA17/arBgPhp878pXi/Df93ceLefBL2YunyPsIXA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bsCyU4F/iPW7Ax9keQePi4k+LN8Bq+HZ7GKESfLxbE0IZuPsIbDlOE5J+6w7ihBJ5uDkAOGdp/GZ6zpEh9kK9xIKG6O7kK4S50vyOuBVxN0atV8bcD3MljZO1EHRGZx/YCq0zxminjuM0PwmNTaYGCvX2hoxcvXgLD9/6Lf/TSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XBtZQKVM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XBtZQKVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139661F00893;
	Wed, 10 Jun 2026 04:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781066241;
	bh=/NDc1NPZyiST8rtVk8BG4h82p29S+S6nZfiFovaad7Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XBtZQKVMU7QqHUK6Hf+ZKIKyUCg0qxAHzdD8C4CjZT/vKVCljju6MU0/Z9rhJZNVD
	 /zFwq03p9SjLK+nQZgMbOcX06CMbXp2Tyg1stMG+4DXuh/Hiuu5KN6OWEdyNF0L/fI
	 pvi202M58Fzhrv61hEyjz0AShOX+CoJ+pzCLRiuqFPQ82gRC0rxKuSpcotK0HxyXfl
	 PVBVv2w5IpSkw13oEIEwYVkLiG+lB4RMP/VqFmjsAbfkwp6wbOLZoHygrfMQM01Bam
	 sj+zAlrWHuJkS7KejN7laM8DLCqsCI7N66uerBWzPqH9A+wiv5QTMJ6Cq/n2yaTc4o
	 zZbssj/PZdTmA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] scsi: target: fix iSCSI ISID use-after-free in
 REGISTER AND MOVE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260610042245.35473-1-hexlabsecurity@proton.me>
References: <20260610042245.35473-1-hexlabsecurity@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 10 Jun 2026 04:37:20 +0000
Message-Id: <20260610043721.139661F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Missing length validation on the TransportID payload leads to =
out-of-bounds reads and potential kernel oops via `strstr()` and `get_unali=
gned_be64()`.
--

commit f95f1e5f1cdc7f67d3f1cb876ff0263d03032d49
Author: Bryam Vargas <hexlabsecurity@proton.me>

scsi: target: fix iSCSI ISID use-after-free in REGISTER AND MOVE

This commit fixes a use-after-free read of the iscsi isid pointer in
core_scsi3_emulate_pro_register_and_move(). The early unmap of the buffer
is dropped, keeping the parameter list mapped until the pointer is no
longer needed.

> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core=
_pr.c
> index 11790f2c5d80f..7c5bb7d679477 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -3293,9 +3293,6 @@ core_scsi3_emulate_pro_register_and_move(struct se_=
cmd *cmd, u64 res_key,
>  		goto out;
>  	}
> =20
> -	transport_kunmap_data_sg(cmd);
> -	buf =3D NULL;
> -

[Severity: Critical]
This is a pre-existing issue, but does this code properly validate the
payload length before parsing the buffer?

Earlier in core_scsi3_emulate_pro_register_and_move(), proto_ident is read
from buf[24] without verifying that tid_len > 0. If a command is sent with
tid_len =3D 0 and data_length =3D 24, would reading buf[24] result in an
out-of-bounds read?

Furthermore, iscsi_parse_pr_out_transport_id() calls:

    p =3D strstr(&buf[4], ",i,0x");

If a payload length is exactly aligned to a multiple of the page size with =
no
null terminator, could strstr() scan past the vmap buffer and hit a guard
page, causing a kernel oops?

Finally, if the parsed isid string is found but terminates quickly near a p=
age
boundary (for example, ",i,0x1\0"), __core_scsi3_do_alloc_registration()
executes:

    pr_reg->pr_reg_bin_isid =3D get_unaligned_be64(isid);

Since get_unaligned_be64() unconditionally reads 8 bytes from the potential=
ly
short ascii string, could this read cross into a guard page and cause an oo=
ps?

>  	pr_debug("SPC-3 PR [%s] Extracted initiator %s identifier: %s"
>  		" %s\n", dest_tf_ops->fabric_name, (iport_ptr !=3D NULL) ?
>  		"port" : "device", initiator_str, (iport_ptr !=3D NULL) ?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260610042245.3547=
3-1-hexlabsecurity@proton.me?part=3D1
