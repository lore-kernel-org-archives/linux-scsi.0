Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB3B4519B8
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 12:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791291362; cv=none; b=gizG0+SiQ5Ez1AaUEjBrxgzPvMd3A98/4xT3XoE4o3hZOCaZDsHHf5lg77Q7ZLfWwqqNz58MdZSJ+d04YOgmQgJCh2qdpF44J08iU2o8FnARHyGBU1MPXMS1KuM0yroWjz22UD71puvCjtMtXHdPLVu+55dORra48ELrQEfgctk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791291362; c=relaxed/simple;
	bh=CkSvtHu9CAD9wiDqDMQB7koeHHYWHwT+LW0txjbqhWA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LvzC1CykN0K377+Qjb6c+P5hYsli0AO32SOF/Nu36uq4DWrMKOlsce4C3w5LKkG/dV9Zt0ODYFSDNM8IJ/j3KVr4fOdDZCcYY/jWsXElvj6Q3rYPKVZyV3RBnAJwScXHz1dHblxtGtrh+PW9IGwHy0kMgfeAgPnMEmKIp8Wd2hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2KsttYP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2KsttYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F72C1F000FF;
	Tue,  6 Oct 2026 12:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791291360;
	bh=KVXFV2ubWLnoBBwo0mEed0Fhkvz3qZcu6bT72YmRXaM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L2KsttYPSgz28pePK1dbvgq3G3WxsMQ3upJ/hN/EjWM/l+LOO1JSF6ZOPA46MudHc
	 diTkz3XeHBvOYZko+7FA10j+mIMnwmxihuOM+aW48dxHoIRk+9CWjwe8vu2zqmi+vb
	 NXdpwwT81BpytgaT6RRjxyfJKQ8JyxNoqHc9coU1luKmxHVU/97pnVclwnFPb92PA1
	 Hbpbf6+XzUI/uWcepukyQQNrc2VhztDsBWhIiERDmdCGYATgi7g/5ET+ezSb+19UAQ
	 23dezKNq4Ygh7w4kmYaKD4KZ9DJdohX82wJutRyrKUppULicEveNhM1qRWXIKEZ8ev
	 4209C0PTjJAmQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/7] zloop: add degrade_element control command
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261006124510.882017-6-dlemoal@kernel.org>
References: <20261006124510.882017-1-dlemoal@kernel.org>
 <20261006124510.882017-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 12:56:00 +0000
Message-Id: <20261006125600.7F72C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] block/zloop: removing degraded element re-enables I/O during tra=
nsition
- [Low] block/zloop: format string arguments swapped in degrade_element
- [Low] block/zloop: missing validation for ZLOOP_OPT_ELEMENT_ID
--

commit a9552af0fb1bf978fc86a4c32f3c9541477e5165
Author: Damien Le Moal <dlemoal@kernel.org>
Subject: zloop: add degrade_element control command

This commit introduces a new degrade_element control command for zloop=20
devices to simulate degraded storage elements. Read and write operations=20
to zones served by a degraded element are failed based on element type.=20
The patch also updates storage element status accesses to use READ_ONCE()=20
and WRITE_ONCE() for safe lockless checks in the I/O path.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index d6a45f2148576..3913bd2299108 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c

[ ... ]

> @@ -982,11 +986,26 @@ static bool zloop_prep_rq(struct zloop_device *zlo,=
 struct request *rq)
>  	spin_lock(&zone->wp_lock);
> =20
>  	if (zlo->nr_elements) {
> +		struct blk_storage_element *se;
> +
>  		if (zone->cond =3D=3D BLK_ZONE_COND_OFFLINE ||
>  		    (zone->cond =3D=3D BLK_ZONE_COND_READONLY && is_write)) {
>  			ret =3D false;
>  			goto unlock;
>  		}
> +
> +		/*
> +		 * Check the health state of the storage element serving the
> +		 * zone.
> +		 */
> +		if (is_write)
> +			se =3D &zlo->elements[zone->wr_se_id - 1];
> +		else
> +			se =3D &zlo->elements[zone->rd_se_id - 1];
> +		if (READ_ONCE(se->status) =3D=3D BLK_SE_STS_DEGRADED) {
> +			ret =3D false;
> +			goto unlock;
> +		}
>  	}

[ ... ]

> @@ -1249,9 +1293,9 @@ static int zloop_remove_element(struct gendisk *dis=
k, unsigned int element_id)
>  	 * modify the zones.
>  	 */
>  	zlo->remove_element_id =3D element_id;
> -	se->status =3D BLK_SE_STS_REMOVE_IN_PROGRESS;
> -	if (paired_se && paired_se->status !=3D BLK_SE_STS_REMOVED)
> -		paired_se->status =3D BLK_SE_STS_REMOVE_IN_PROGRESS;
> +	WRITE_ONCE(se->status, BLK_SE_STS_REMOVE_IN_PROGRESS);
> +	if (paired_se && READ_ONCE(paired_se->status) !=3D BLK_SE_STS_REMOVED)
> +		WRITE_ONCE(paired_se->status, BLK_SE_STS_REMOVE_IN_PROGRESS);

[Severity: Medium]
When zloop_remove_element() is called on an element that was previously mar=
ked
as degraded, won't this unconditionally overwrite the status to
BLK_SE_STS_REMOVE_IN_PROGRESS?

If the status changes to BLK_SE_STS_REMOVE_IN_PROGRESS, the check in
zloop_prep_rq() for BLK_SE_STS_DEGRADED will no longer match. Does this
mean that I/O will unexpectedly succeed on the degraded element until the
2-second delayed removal work actually offlines the zones?

[ ... ]

> @@ -1944,6 +1988,42 @@ static int zloop_ctl_remove(struct zloop_options *=
opts)
>  	return 0;
>  }
> =20
> +static int zloop_ctl_degrade_element(struct zloop_options *opts)
> +{
> +	struct zloop_device *zlo;
> +	int ret =3D 0;
> +
> +	if (!(opts->mask & ZLOOP_OPT_ID)) {
> +		pr_err("No ID specified for degrade_element\n");
> +		return -EINVAL;
> +	}
> +
> +	if (opts->mask & ~(ZLOOP_OPT_ID | ZLOOP_OPT_ELEMENT_ID)) {
> +		pr_err("Invalid option specified for degrade_element\n");
> +		return -EINVAL;
> +	}

[Severity: Low]
Does this code silently fail if the user omits the element_id option?

The check above ensures no invalid options are provided, but it lacks a
validation to ensure ZLOOP_OPT_ELEMENT_ID is actually present in opts->mask.
If omitted, opts->element_id defaults to 0, which gets rejected silently in=
side
zloop_degrade_element() without any error message to the user.

> +
> +	mutex_lock(&zloop_ctl_mutex);
> +
> +	zlo =3D idr_find(&zloop_index_idr, opts->id);
> +	if (!zlo || zlo->state =3D=3D Zlo_creating)
> +		ret =3D -ENODEV;
> +	else if (zlo->state =3D=3D Zlo_deleting)
> +		ret =3D -EINVAL;
> +	if (ret)
> +		goto unlock;
> +
> +	ret =3D zloop_degrade_element(zlo, opts->element_id);
> +	if (!ret)
> +		pr_info("Degraded element %u of device %u\n",
> +			opts->id, opts->element_id);

[Severity: Low]
Are the arguments to pr_info() swapped here?

The format string specifies "element %u of device %u", but the variables are
passed as opts->id (the device ID) followed by opts->element_id (the element
ID). This will display the values in the reverse order of the text.

> +
> +unlock:
> +	mutex_unlock(&zloop_ctl_mutex);
> +
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006124510.8820=
17-1-dlemoal@kernel.org?part=3D5
