Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BF047987C
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 15:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785943125; cv=none; b=Amsbzxf70oC8KQrRJ+DwgBpDlqKUBXoEbVxpxnaYQWQWKqeafCEeUo2KkXoZmjjLgX46xLs8MpcyIOLqnZRZLzJkNDleOsHDwg3u8Hz+LXfDrvfMsIVD7NZw9Atbb5x0ONUypaXM3//5V9Hpl7vRpUEOeIRqy34Nc0gUUNK5d4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785943125; c=relaxed/simple;
	bh=mXqHTye38JqTstf1Cd++hSDwqCEokDAw+uBVqC4tcPU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tKMaulV5ncCVFqZFcly5ClLssJF9AJDthzQYTBl9d0EAE8CjvjfeIscEkUOkqVkmasXG3K1DjAPkEyYjqzc4kaPeBT+sxt7QN+8+H3GtFC9spUMy4dkMjIya8IGzbFhVrAIxyr6T664CTPCD2UWsnwyDFWvfT4qa/cCncQmEVbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E+zQW7d+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E+zQW7d+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB761F000E9;
	Wed,  5 Aug 2026 15:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785943120;
	bh=TiTVRK8aymWSEknf10cRwNTnnaU8vdUF/Q6fwu5jhKw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E+zQW7d+3aqX7S+h6qFxEav+S9KjZOhw8ms6xv+fieg+FNesLYQ9JjBMLoXHsZWlA
	 BhJVVLexl5rNR4VZiMFHyI7iSiYsOfwqp2wr62Zf9uuEkac3wBmqlAx6nvNysixQAa
	 8/q/kb5eGpQV2XG3FOGiJS5oCtwm47kRoqhRM5vCBxhDJAPNpYS5i3HFBEC3lQ0pmx
	 d6YDbojATS2bF1e0wvJQpA6C1t0mQGuPj78hq3vQZjYO22mxwza+xcv4PwiHgMzQTj
	 O4R0cbW3b1WgFHXg7wcOfnxSWm9lpKMfCt36/HKrBr6UJOF1rtqErV5GHbYPp+ZWiJ
	 bay4NbhFGKJvw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: alua: Use access state macros
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260805145906.2825553-1-john.g.garry@oracle.com>
References: <20260805145906.2825553-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 05 Aug 2026 15:18:39 +0000
Message-Id: <20260805151840.7CB761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Out-of-bounds heap read when parsing Target Port Group descriptors=
 from a malformed RTPG response.
--

--- Patch [1]: [PATCH v2] scsi: alua: Use access state macros ---
commit 6e972b4dac6a9789e1cd5b0e5ccd315a61ef1227
Author: John Garry <john.garry@linux.dev>

scsi: alua: Use access state macros

This commit replaces hardcoded bitwise operations with SCSI access state
macros when parsing Target Port Group descriptors in alua_rtpg().

> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/de=
vice_handler/scsi_dh_alua.c
> index 80ab0ff921d43..d81ec47a71402 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c

[ ... ]

> @@ -693,8 +694,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct=
 alua_port_group *pg)
>  				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
>  					struct alua_dh_data *h;
> =20
> -					tmp_pg->state =3D desc[0] & 0x0f;
> -					tmp_pg->pref =3D desc[0] >> 7;
> +					tmp_pg->state =3D FIELD_GET(SCSI_ACCESS_STATE_MASK, desc[0]);
> +					tmp_pg->pref =3D FIELD_GET(SCSI_ACCESS_STATE_PREFERRED, desc[0]);

[Severity: High]
This is a pre-existing issue, but is there a risk of an out-of-bounds heap
read on the desc pointer here?

Looking at alua_rtpg() in drivers/scsi/device_handler/scsi_dh_alua.c, the
loop iterating over the descriptors evaluates the length returned by the
target:

for (k =3D tpg_desc_tbl_off, desc =3D buff + tpg_desc_tbl_off;
     k < len;
     k +=3D off, desc +=3D off) {
        u16 group_id =3D get_unaligned_be16(&desc[2]);

If the target returns a malformed REPORT TARGET PORT GROUPS response where
len indicates a truncated final descriptor (for example, fewer than 8 bytes
remain), the loop condition k < len still evaluates to true.

Could this cause the reads of desc[0], desc[2], and desc[7] to access
memory past the end of the kmalloc buffer if a target provides a crafted
response length?

>  					rcu_read_lock();
>  					list_for_each_entry_rcu(h,
>  						&tmp_pg->dh_list, node) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260805145906.2825=
553-1-john.g.garry@oracle.com?part=3D1
