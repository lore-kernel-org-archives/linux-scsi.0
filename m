Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A8F4192F9
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 12:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791291383; cv=none; b=ZTCSr8LxMNCn/iBvApypwYnxopMfrkH3eknexTBtI3sMCbuA8+47KZp7eS4ifK9axb/zjCJ3DYNbDSYMdQNLGqfEvP4FUuSpb4Vhcc4OC9sj1i6/LyWubpP7TCUGGIdW4Fsx3OG7/mbz7f1Wj9VVGjaNuPJDt8nC3ZuMLbDIPsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791291383; c=relaxed/simple;
	bh=1Nfe3WWj74OUdNf4Sys7ZO2R+5doIBqfDpi+zF0LoFk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kvUI1vAFOKwxGKTS+ULU9l9ZVfA4+ccDQBHvxUfpnkxKgorDe2PmHg4CXgOwpyNmf/Z1+3bA10r3Pdtf5Bvb1b487RL6b0/zmIlhT4LYCnjCRsXTJK6p+129nCJaBIIotLHe3nNgdqUhAh9vPBp8isRWS+rsEqP3AGIfxpw8bFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FVmA+WfU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FVmA+WfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA4A1F000FF;
	Tue,  6 Oct 2026 12:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791291381;
	bh=Ny6OMgk0hqyc7hCBfp4YhfLWMShqnN36wXNRBDMwfS4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FVmA+WfUUnWDMb6rbKY/4ZQkDl5opKUrZt8c6RnFSZpjlIMt0JOAbNAzybkR5+CP4
	 /pryL5NL53VyhkSgYR6LwZ0gJD5WaYEHcEDwc+8D/0ttI7yPeRYwCpSxWd0UynBDAb
	 yNpFYXO9HLIfF8/uct6B1qyilOdh4jcUPB4e4PQBUxEyGqouPKRTpfuVMb5ofQYO+x
	 mw4NG2PQP0VMdNjemNhBNyxEeW2SYaWN2ztgad5KwoTz/0+iUA3oie2qzRtk0y2VCK
	 9C0XsR6yc4bwfwoHegZcu9gJRie5rgKXOKxdwM+6ePU4Kw2BKGbGyPYKcIV/FxAA1U
	 b3frYnQv3/6SA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/7] zloop: add storage element emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261006124510.882017-5-dlemoal@kernel.org>
References: <20261006124510.882017-1-dlemoal@kernel.org>
 <20261006124510.882017-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 12:56:20 +0000
Message-Id: <20261006125621.2DA4A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] block/zloop: restore_elements strays elements in RESTORE_ERROR s=
tate
- [Medium] block/zloop: zloop_report_zones overwrites OFFLINE/READONLY zone=
 conditions
--

commit 589ee9798dfa33f2ae7ed9bd47dc9d1e880a131f
Author: Damien Le Moal <dlemoal@kernel.org>
Subject: zloop: add storage element emulation

This commit introduces storage element emulation to the zloop driver,
providing ways to emulate SMR disk depopulation features. It defines new
options and states to handle fractional access storage elements and their
associated zone conditions.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 394dc2408ed73..d6a45f2148576 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
[ ... ]
> @@ -353,6 +389,19 @@ static int zloop_update_seq_zone(struct zloop_device=
 *zlo, unsigned int zone_no)
>  	return 0;
>  }
> =20
> +static bool zloop_zone_is_offline_or_readonly(struct zloop_device *zlo,
> +					      struct zloop_zone *zone)
> +{
> +	bool ret;
> +
> +	spin_lock(&zone->wp_lock);
> +	ret =3D zone->cond =3D=3D BLK_ZONE_COND_OFFLINE ||
> +		zone->cond =3D=3D BLK_ZONE_COND_READONLY;
> +	spin_unlock(&zone->wp_lock);
> +
> +	return ret;
> +}
> +
>  static int zloop_open_zone(struct zloop_device *zlo, unsigned int zone_n=
o)
>  {
>  	struct zloop_zone *zone =3D &zlo->zones[zone_no];
> @@ -363,6 +412,11 @@ static int zloop_open_zone(struct zloop_device *zlo,=
 unsigned int zone_no)
> =20
>  	mutex_lock(&zone->lock);
> =20
> +	if (zloop_zone_is_offline_or_readonly(zlo, zone)) {
> +		ret =3D -EIO;
> +		goto unlock;
> +	}
> +
>  	if (test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags)) {
>  		ret =3D zloop_update_seq_zone(zlo, zone_no);

[Severity: Medium]
Should we also be checking zloop_zone_is_offline_or_readonly() in
zloop_report_zones()?

Currently, if a user depopulates a storage element, the zone transitions
to BLK_ZONE_COND_OFFLINE or BLK_ZONE_COND_READONLY. But if a report zones
command is executed, zloop_report_zones() checks for the
ZLOOP_ZONE_SEQ_ERROR bit and invokes zloop_update_seq_zone():

drivers/block/zloop.c:zloop_report_zones() {
...
    if (test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags)) {
        ret =3D zloop_update_seq_zone(zlo, zone_no);
...
}

Since zloop_report_zones() does not check if the zone is offline or
readonly first, zloop_update_seq_zone() could unconditionally overwrite
zone->cond to EMPTY, FULL, or CLOSED. Could this incorrectly revive the
zone and erase the status imposed by the storage element depopulation?

[ ... ]
> @@ -1002,11 +1105,252 @@ static int zloop_report_zones(struct gendisk *di=
sk, sector_t sector,
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
Is it safe to unconditionally clear zlo->nr_removed_elements here when
elements might remain in the BLK_SE_STS_RESTORE_ERROR state?

If a zone reset fails (e.g. zloop_do_reset_zone() returns an error), the
affected elements transition to BLK_SE_STS_RESTORE_ERROR. However, the
code still sets zlo->nr_removed_elements =3D 0 despite these elements
remaining functionally disabled.

This breaks the accounting for the hardware limit check in
zloop_remove_element():

drivers/block/zloop.c:zloop_remove_element() {
...
    if (zlo->nr_removed_elements + nr_remove >
        zlo->max_nr_removed_elements) {
        ret =3D -EBUSY;
        goto unlock;
    }
...
}

This could allow a user to evade the zlo->max_nr_removed_elements limit
by deliberately failing restorations, potentially offlining all storage
elements.

Additionally, because nr_removed_elements becomes 0, elements in the
RESTORE_ERROR state might become stranded. In zloop_restore_elements():

> +static int zloop_restore_elements(struct gendisk *disk)
> +{
[ ... ]
> +	zlo->restore_in_progress =3D true;
> +	for (i =3D 0, se =3D zlo->elements; i < zlo->nr_elements; i++, se++) {
> +		if (se->status =3D=3D BLK_SE_STS_REMOVED)
> +			se->status =3D BLK_SE_STS_RESTORE_IN_PROGRESS;
> +	}
> +
> +	schedule_delayed_work(&zlo->restore_elements_work,
> +			      msecs_to_jiffies(5000));
[ ... ]
> +}

Since zloop_restore_elements() strictly checks for BLK_SE_STS_REMOVED, it
will ignore elements in the BLK_SE_STS_RESTORE_ERROR state. Does this mean
those elements can never be restored again, stranding them in a
permanently broken state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006124510.8820=
17-1-dlemoal@kernel.org?part=3D4
