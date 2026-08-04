Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196303242D4
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 11:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785843048; cv=none; b=ehToBlgxmLgz/KMpz2eZjyQT8CCDulZQ7b6E7zU5LIRCQk5tm+bvKcE69aeG8bUGKyw2zfiY9DaIvMco/uYhJLpC4jxeHg7ED7rfomrSxPdNXG34ojSIfSXY3XUsr+BK/MMZFoIRp18zTksHbdLEzgpyEq9H0NxTXLhq8XR8WOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785843048; c=relaxed/simple;
	bh=0fnsUJb0XxVwJQixXIWQ5m1Odg0+86jDCovdXHzbqFg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J6UqYKWikbLWOZXyW78OXAWgjDLWDJy9IzTRPkPK+Kla5aykoCSOf6Z05ipTL75E+d5gpmXCx5P6Ww/ZYd2YzvC6ZaSQIheuyUpbFlcVIYk/a6LvNO90Pd5DhzLk4fZn3NIE+z0gOxLaKPckCI98WprlmlCPKSgl9Ayw3QAh5Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJ2x/nda; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJ2x/nda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6121F000E9;
	Tue,  4 Aug 2026 11:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785843046;
	bh=7HdyvYiH4Fy1/YUFYwwob8N74MaHY9WSB1MLSkJUQPg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LJ2x/ndastyG6h2SnoxW9dYqf516E4JQji2Q9wSbNYA0YeDbKlB9ZklN+9Zf0fUb9
	 tR42R2NIYENgoA41MXqvhCVr+BzTZn2O82vyV29wygN23+mNCEG1xgX8th/jVHbhGD
	 YFVAHWQdS4iOtq25DOYvdEba8/LrLGIH7CCqe0mDV9Zzc7wBuplAbN1q61WWLcuRa2
	 pKXMkFL2X+Pl4Qy3UnPzjOQu7jO6Y4Ww9My+cLumO/P/Zk1PgmnNJcL0PXQa+1iqdX
	 hvn+BKmEW0WIYNsimQsCPUco8CfCLGgBkF1te3RES5J4iftaCs7SqtOYJomKqSHbbf
	 E/2orES7kWHkg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: alua: Use access state macros
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260804111615.2368927-1-john.g.garry@oracle.com>
References: <20260804111615.2368927-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 04 Aug 2026 11:30:45 +0000
Message-Id: <20260804113046.AA6121F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Uninitialized kernel heap memory parsing due to missing zero-initi=
alization on reallocation.
- [High] Heap out-of-bounds read in the ALUA RTPG descriptor parsing loop d=
ue to missing bounds check.
--

--- Patch [1]: [PATCH] scsi: alua: Use access state macros ---
commit 2dc602acd70bdca60f3657da1a036b1c0fed56d1
Author: John Garry <john.garry@linux.dev>

scsi: alua: Use access state macros

Use the SCSI access state macros in alua_rtpg(), which is better than
hardcoding.

> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/de=
vice_handler/scsi_dh_alua.c
> index 80ab0ff921d43..4258c48d93339 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -693,8 +693,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct=
 alua_port_group *pg)

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing alua_rtpg(),
I noticed a potential issue with the buffer reallocation earlier in the
function:

    buff =3D kmalloc(bufflen, GFP_KERNEL);

If the subsequent submit_rtpg() succeeds but transfers fewer bytes than
requested (a short read), wouldn't the trailing portion of the buffer remain
uninitialized? Since the function parses up to the reported len, could this
cause it to parse uninitialized kernel heap memory if a malicious device
advertises a large length but returns a short response?

[Severity: High]
This is also a pre-existing issue, but looking at the descriptor parsing lo=
op
just before the modified lines:

    for (k =3D tpg_desc_tbl_off, desc =3D buff + tpg_desc_tbl_off;
         k < len;
         k +=3D off, desc +=3D off) {
        ...
        off =3D 8 + (desc[7] * 4);
    }

Does the loop condition k < len ensure that a full 8-byte descriptor header
is available? If a device returns a truncated response where len - k < 8,
wouldn't the accesses to desc[0] through desc[7] read past the end of the h=
eap
allocation?

>  				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
>  					struct alua_dh_data *h;
> =20
> -					tmp_pg->state =3D desc[0] & 0x0f;
> -					tmp_pg->pref =3D desc[0] >> 7;
> +					tmp_pg->state =3D desc[0] & SCSI_ACCESS_STATE_MASK;
> +					tmp_pg->pref =3D desc[0] >> __fls(SCSI_ACCESS_STATE_PREFERRED);
>  					rcu_read_lock();
>  					list_for_each_entry_rcu(h,
>  						&tmp_pg->dh_list, node) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260804111615.2368=
927-1-john.g.garry@oracle.com?part=3D1
