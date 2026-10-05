Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40DC418365
	for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2026 09:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194319; cv=none; b=pSuVvmh298Ko8V20g6iHDBpSDX1rN6irTyBujQjSE22mo1/ql3lFThgv9sI/HIX9XjYZ9Rju66EdtO9SzvJxlB6bKPCAqBKsRQDtrzprEnF/KBlRYpZC7DF1HdWZ5mvcoeGAUbkp2/AccgrPu6W+ltZH2lL6wtF+mYTI6Djvz4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194319; c=relaxed/simple;
	bh=gjUxfDP9orBqZREajlKfItEAmkHDBENfWiD+eDfjJyg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AgMvnH3Yv93atc3zZ+DsRt7mra/0ROiCrFYlXeWHnJyKQ3hWp/lSWxhHRwwCiq8WyQgSjwn1Vy5fqEjlDS21M7FcHM/Dp5vDraFiJ6shi0r0AKP11tsSoQZc9rd09t9TLdRtofaHmIvBaPqs/DEiOK5uaV0UoG8HdJpCLPyoIRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHHNGZhV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHHNGZhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7627C1F000FF;
	Mon,  5 Oct 2026 09:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791194317;
	bh=fvP+RH7C5HDybgzE9yziPzcnTsHJ/Kfc3GLtQLkUlvc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QHHNGZhVZuOKt222jA4BvA9K6M/9BFuw8ZVb5zuqT3USNKHGMuZQVbwyTK4wbHl7e
	 8pCG845YOo/axm3DAxeKy7DynZr5ft0ZaSj11Cmp17VpSJTYmdKmH8WZHcEPo+WqMR
	 qoLs7et16QXZ3xlCMBogu+IC+e1yRYzWsXLwKOzAZpxgmIkWIIdFeJbqHEYvhms10H
	 Y1g8g3A1YeZLKyKGuSe0mzKkLq6++GrgXhfOwsjTYrYKl8TDPDbZGDocV79nYkfDEd
	 xjRBqwIGWb8Oby/O1YEuGltw7rjSz539CcZu3zVoO/hHWYt3xjYMXkSPxp6rH5ELZX
	 bag7fhflINNCA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/7] zloop: add degrade_element control command
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261005094632.580753-6-dlemoal@kernel.org>
References: <20261005094632.580753-1-dlemoal@kernel.org>
 <20261005094632.580753-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 09:58:37 +0000
Message-Id: <20261005095837.7627C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] block: logic inversion in zloop_zone_healthy() aborts I/O on healt=
hy zones
- [High] block: Use-After-Free in zloop_ctl_degrade_element() due to missin=
g refcount
- [Medium] block: data race on se->status without READ_ONCE/WRITE_ONCE wrap=
pers
--

commit 003661eebb0c9d5db84ec05ab948b11a2ca35348
Author: Damien Le Moal <dlemoal@kernel.org>

zloop: add degrade_element control command

This patch adds a "degrade_element" control command to zloop devices, allow=
ing
users to mark specific storage elements as degraded. Depending on the eleme=
nt's
access type, read or write operations targeting its zones will be failed.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 7e6b5cc8017d2..1d51060b832bc 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c

[ ... ]

> @@ -201,6 +205,29 @@ static unsigned int rq_zone_no(struct request *rq)
>  	return blk_rq_pos(rq) >> zlo->zone_shift;
>  }
> =20
> +static bool zloop_zone_healthy(struct zloop_device *zlo,
> +			       struct zloop_zone *zone, bool write)
> +{
> +	struct blk_storage_element *se;
> +
> +	if (!zlo->nr_elements)
> +		return true;
> +
> +	/* Check the zone condition first. */
> +	if (zone->cond =3D=3D BLK_ZONE_COND_OFFLINE)
> +		return false;
> +	if (zone->cond =3D=3D BLK_ZONE_COND_READONLY && write)
> +		return false;
> +
> +	/* Check the health state of the storage element serving the zone. */
> +	if (write)
> +		se =3D &zlo->elements[zone->wr_se_id - 1];
> +	else
> +		se =3D &zlo->elements[zone->rd_se_id - 1];
> +
> +	return se->status =3D=3D BLK_SE_STS_DEGRADED;

[Severity: Medium]
Since this status field is read locklessly in the fast I/O path while it can
be concurrently updated by zloop_degrade_element(), should this use
READ_ONCE() to prevent compiler optimizations from tearing the read or
caching the variable?

[Severity: High]
Does this evaluate the health condition inversely? It returns true when the
element is degraded and false when it is healthy.

> +}
> +

[ ... ]

> @@ -733,9 +760,7 @@ static void zloop_rw(struct zloop_cmd *cmd)
>  			 zone->start + zlo->zone_size))
>  		goto out;
> =20
> -	if (zone->cond =3D=3D BLK_ZONE_COND_OFFLINE)
> -		goto out;
> -	if (zone->cond =3D=3D BLK_ZONE_COND_READONLY && is_write)
> +	if (!zloop_zone_healthy(zlo, zone, is_write))
>  		goto out;

[Severity: High]
Because zloop_zone_healthy() returns false for healthy zones, does this
inverted check systematically abort valid I/Os to operating zones?

> =20
>  	if (test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags)) {

[ ... ]

> @@ -1095,6 +1120,31 @@ static int zloop_report_elements(struct gendisk *d=
isk,
>  	return 0;
>  }
> =20
> +static int zloop_degrade_element(struct zloop_device *zlo,
> +				 unsigned int element_id)
> +{
> +	struct blk_storage_element *se;
> +	int ret =3D 0;
> +
> +	if (zlo->stor_elements =3D=3D ZLOOP_STOR_ELEMENTS_NONE)
> +		return -EOPNOTSUPP;
> +
> +	if (!element_id || element_id > zlo->nr_elements)
> +		return -EINVAL;
> +
> +	mutex_lock(&zlo->stor_elements_lock);
> +
> +	se =3D &zlo->elements[element_id - 1];
> +	if (se->status =3D=3D BLK_SE_STS_OK)
> +		se->status =3D BLK_SE_STS_DEGRADED;

[Severity: Medium]
To match the lockless read in zloop_zone_healthy(), should this update be
wrapped in WRITE_ONCE() to ensure the memory access ordering?

> +	else
> +		ret =3D -EINVAL;
> +
> +	mutex_unlock(&zlo->stor_elements_lock);
> +
> +	return ret;
> +}
> +

[ ... ]

> @@ -1904,6 +1954,39 @@ static int zloop_ctl_remove(struct zloop_options *=
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
> +
> +	mutex_lock(&zloop_ctl_mutex);
> +	zlo =3D idr_find(&zloop_index_idr, opts->id);
> +	if (!zlo || zlo->state =3D=3D Zlo_creating)
> +		ret =3D -ENODEV;
> +	else if (zlo->state =3D=3D Zlo_deleting)
> +		ret =3D -EINVAL;
> +	mutex_unlock(&zloop_ctl_mutex);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D zloop_degrade_element(zlo, opts->element_id);

[Severity: High]
Is zlo exposed to a concurrent free here? The mutex is unlocked without hol=
ding
a reference to zlo->disk via get_disk().

This could allow a concurrent zloop_ctl_remove() operation to remove the IDR
entry, unlock the same mutex, drop the final disk reference, and free the
zlo structure right before it is used in zloop_degrade_element().

> +	if (!ret)
> +		pr_info("Degraded element %u of device %u\n",
> +			opts->id, opts->element_id);
> +
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261005094632.5807=
53-1-dlemoal@kernel.org?part=3D5
