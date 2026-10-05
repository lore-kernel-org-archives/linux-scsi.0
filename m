Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6F046AA6B
	for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2026 09:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194298; cv=none; b=jCHhg1MCvMUSNiwcgr7/430Y4tqMHXrsMDwewrXt7h6Nm8t7XQELOkYYq+sWR0bjfe61SFKbbelnCj1Lwa/fiWUF9/YjWXs7PbJ3TJ80MTtBRkYvkXJGdHQNMaAgGKxHRUUAp+g/6wve/zLZQH8RQO4sdedPf4QXijosspwYNs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194298; c=relaxed/simple;
	bh=VI2s2nId+rfDR28kNO+GQYAto4sRr1VJ79Uj3D06NJQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZCJAQiXHWrzk9aCw5JiAvStpbscdg31HHYeZv1H4WQU4eejqxnaLaC/NJhn+syOyiCzeBlbNqtEMOm6s4yE8BHcwu3tu3VjS+YVOdy/+EINfNQcH9bID/7N2kcMxcXyuYmZndc35Ujx+U341IxrrW67QvyQonxpPOxAI44drzjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aj2Cs/9D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aj2Cs/9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98531F000FF;
	Mon,  5 Oct 2026 09:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791194297;
	bh=bnl+MX8qROJC/l2ahqj4MubKk4FZ7cBxXCC5NumE9fc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aj2Cs/9Do0MgR+xhfVuX2w1qus6SyA/8mLl6lC1o2MWHw3dnF+gPHI9v0aF5SFPpo
	 0Eibt3XOAXZbErbEaXArDukiizlbaF+6MBswMxsyZc8bLYEna5uQwm7mO9gCjFa+LK
	 opG8EH1U7s14ZQkuwB2u38JmF6XmWQXJzJ3QXbj9Q6MK3cac7bOIPYRExII0oAEdBr
	 eWc7/xNfkg5srbHzZ+t7g/DW+6LgJkBFyMrZuPqsym1SzyBITalBJSf9k26O8LfJdn
	 iMT5Ns1da8gmQwHAXU7hd/l3hdQSoB9L2Ply0NrjR0RZH+I87YwRVSbW8vmO7TlkFZ
	 4Q78OhfBQPJUg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/7] zloop: add storage element emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261005094632.580753-5-dlemoal@kernel.org>
References: <20261005094632.580753-1-dlemoal@kernel.org>
 <20261005094632.580753-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 09:58:16 +0000
Message-Id: <20261005095816.C98531F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] block/zloop: integer overflow in ordered zone append causes wp cor=
ruption on OFFLINE zones
- [Medium] block/zloop: failed storage element restore permanently bricks d=
evice
- [Medium] block/zloop: storage element emulation reports incorrect zone co=
unts due to division truncation
- [Medium] block/zloop: lockless TOCTOU race allows I/O on OFFLINE and READ=
ONLY storage elements
- [Low] block/zloop: double counting of nr_removed_elements when removing R=
EAD elements
- [Low] block/zloop: misleading error message for invalid stor_elements opt=
ion
--

commit 2ec54a3b571357c5ded6a5a4c9a7aea473cb335d
Author: Damien Le Moal <dlemoal@kernel.org>

zloop: add storage element emulation

This commit introduces storage element emulation to the zloop driver. It
allows for emulating SMR disks' storage element depopulation feature,
controlled by a new stor_elements option. The operations to manage storage
elements are specified via zloop_se_ops.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index f0ca221524db6..7e6b5cc8017d2 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
> @@ -664,6 +733,11 @@ static void zloop_rw(struct zloop_cmd *cmd)
>  			 zone->start + zlo->zone_size))
>  		goto out;
> =20
> +	if (zone->cond =3D=3D BLK_ZONE_COND_OFFLINE)
> +		goto out;
> +	if (zone->cond =3D=3D BLK_ZONE_COND_READONLY && is_write)
> +		goto out;
> +

[Severity: Medium]
Could this lockless check introduce a TOCTOU race window?

Concurrently, zloop_remove_element_work() can acquire zone->lock and change
the state to OFFLINE or READONLY.

If the work function runs between this lockless check and the dispatch of t=
he
I/O, zloop_do_rw() could be executed on a disabled storage element, as it
bypasses taking zone->lock for reads and conventional zone writes.

[ ... ]

> @@ -877,7 +951,7 @@ static bool zloop_set_zone_append_sector(struct reque=
st *rq)
>  	rq->__sector =3D zone->wp;
>  	zone->wp +=3D blk_rq_sectors(rq);
>  	if (zone->wp >=3D zone_end)
> -		zloop_mark_full(zlo, zone);
> +		zloop_set_zone_full(zlo, zone);
> =20
>  	spin_unlock(&zone->wp_lock);

[Severity: High]
Does this bounds check properly handle OFFLINE/READONLY zones?

When a zone becomes OFFLINE or READONLY, its zone->wp is set to ULLONG_MAX.

If an ordered ZONE_APPEND arrives for this zone, the bounds check in
zloop_set_zone_append_sector():

	if (zone->cond =3D=3D BLK_ZONE_COND_FULL ||
	    zone->wp + nr_sectors > zone_end) {

could evaluate to false because ULLONG_MAX + nr_sectors can overflow to a
small sector number. This would bypass the bounds check and update zone->wp
to the overflowed value, corrupting the write pointer state.

[ ... ]

> @@ -985,11 +1059,251 @@ static int zloop_report_zones(struct gendisk *dis=
k, sector_t sector,
[ ... ]
> +static int zloop_remove_element(struct gendisk *disk, unsigned int eleme=
nt_id)
> +{
[ ... ]
> +	/*
> +	 * If the element to remove is a read element, the associated write
> +	 * element must also be removed.
> +	 */
> +	if (se->type =3D=3D BLK_SE_TYPE_READ) {
> +		paired_se =3D &zlo->elements[se->paired_id - 1];
> +		nr_remove =3D 2;
> +	}

[Severity: Low]
Does this code double-count nr_removed_elements if the paired WRITE element
was already manually removed?

zloop_remove_element() allows targeting a paired WRITE element and overwrit=
ing
paired_se->status to BLK_SE_STS_REMOVE_IN_PROGRESS without validating if it
was already removed.

Then zloop_remove_element_work() unconditionally increments
zlo->nr_removed_elements for both elements:

	zlo->nr_removed_elements++;
	if (paired_se) {
		paired_se->status =3D BLK_SE_STS_REMOVED;
		zlo->nr_removed_elements++;
	}

This could artificially inflate nr_removed_elements and prematurely trigger
the max_nr_removed_elements limit.

[ ... ]

> +static void zloop_restore_elements_work(struct work_struct *work)
> +{
[ ... ]
> +	/* Restore all removed elements. */
> +	for (i =3D 0, se =3D zlo->elements; i < zlo->nr_elements; i++, se++) {
> +		if (se->status !=3D BLK_SE_STS_RESTORE_IN_PROGRESS)
> +			continue;
> +		if (!ret)
> +			se->status =3D BLK_SE_STS_OK;
> +		else
> +			se->status =3D BLK_SE_STS_RESTORE_ERROR;
> +	}
> +
> +	zlo->nr_removed_elements =3D 0;
> +	zlo->restore_in_progress =3D false;
> +
> +	mutex_unlock(&zlo->stor_elements_lock);
> +}

[Severity: Medium]
Will this permanently brick the device if a restore fails?

If zloop_do_reset_zone() fails, elements are put into
BLK_SE_STS_RESTORE_ERROR, but the code still unconditionally clears
zlo->nr_removed_elements.

A subsequent call to zloop_restore_elements() checks:

	if (!zlo->nr_removed_elements)
		goto unlock;

This prevents retrying the restore operation. Even if the check is bypassed,
the loop only targets BLK_SE_STS_REMOVED elements, leaving RESTORE_ERROR
elements permanently stuck.

[ ... ]

> +static int zloop_create_storage_elements(struct zloop_device *zlo)
> +{
[ ... ]
> +	nr_zones_per_element =3D zlo->nr_zones / nr_elements;
> +	capacity_per_element =3D
> +		(sector_t)nr_zones_per_element << zlo->zone_shift;
[ ... ]
> +	for (i =3D 0, se =3D zlo->elements; i < nr_elements; i++, se++) {
> +		se->id =3D i + 1;
> +		if (nrz + nr_zones_per_element > zlo->nr_zones)
> +			se->nr_zones =3D zlo->nr_zones - nrz;
> +		else
> +			se->nr_zones =3D nr_zones_per_element;

[Severity: Medium]
Does this code lose the remainder zones in its calculation?

Because nr_zones_per_element is the integer floor of
zlo->nr_zones / nr_elements, the condition
(nrz + nr_zones_per_element > zlo->nr_zones) will never evaluate to true.

Furthermore, elements are assigned to zones in a round-robin fashion (e.g.,
zone_no % nr_elems), meaning the number of zones per element should be
computed based on modulo arithmetic, not simple contiguous division. This
causes se->nr_zones to under-report the actual zones managed by the element.

[ ... ]

> @@ -1619,6 +2058,23 @@ static int zloop_parse_options(struct zloop_option=
s *opts, const char *buf)
[ ... ]
> +		case ZLOOP_OPT_STOR_ELEMENTS:
> +			if (match_uint(args, &token)) {
> +				ret =3D -EINVAL;
> +				goto out;
> +			}
> +			switch (token) {
> +			case ZLOOP_STOR_ELEMENTS_NONE:
> +			case ZLOOP_STOR_ELEMENTS_RDWR:
> +			case ZLOOP_STOR_ELEMENTS_PAIRS:
> +				break;
> +			default:
> +				pr_err("Invalid zone_append value\n");
> +				ret =3D -EINVAL;
> +				goto out;
> +			}
> +			opts->stor_elements =3D token;
> +			break;

[Severity: Low]
This isn't a bug, but the error message here says "Invalid zone_append valu=
e\n"
for the stor_elements option. This looks like a copy-paste error.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261005094632.5807=
53-1-dlemoal@kernel.org?part=3D4
