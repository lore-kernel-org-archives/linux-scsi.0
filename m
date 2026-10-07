Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31700450402
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 08:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791362161; cv=none; b=Lir8E8ia/fi/66Vr6gpNf8Zejg1gENxA+1JKRo839Qw5m1So1JwjQUOLxh3p95fJIKmjwyrbfsOlDN1Ewz/srzKva/9Nv5FHQjVyEmYOSqlQ/Ost7cFG+9bC7UToN+U5HlpDrlTIuLfdE7rQ0X/E3qFNOo8p2eEu7VhQU9AR5ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791362161; c=relaxed/simple;
	bh=R5pOmldq+wnH9VPpgXmxCh53rL1nr3xcvhCqNHUdQJc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=N4ZYpO4yF7w9Bs0IxiyIKArwEMa3pjKc9INB1jBsgA8yDQ93WwL8wMS/NA3+U1r2ubBTT2mjhNoF4cUc9WihlyMSUK4vonXxFoAcv1Fn/Ruev2ckkz+sxTikSWXTd8EeE19VB7JPt8CVJEPOSm9ZFhmeCRNt2i4hzp1JddU8UI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KUXpv0C/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KUXpv0C/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9143C1F0089B;
	Wed,  7 Oct 2026 08:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791362158;
	bh=AKwDRj9wZGVOs5OfBxChAmZzPSbVyZMhFStZ9wKdDwI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KUXpv0C/SurrkPIBEqjFziNXkp9BYFwtyk7GbJ0337rAnJsoxuC+SUUufsH+a2yuj
	 N3gIZtXiMjmF0YCXHGDYlOASCMlV5B9N9iKPFc+ckvGzngKqHz65ccEwaHTjNMuu1+
	 7FABwhjFOuXlddEZGq4ZL5i/XqGr1NwAWXEIYK5OW0SiSU2PyJlv1QkIjeQjjXhdXA
	 Fa5pKzdK4vv9tMgIQ99TlWN2tq0lvsHzpr30DgdcORl9hhn3kJz4kbYL/JmFtpci6d
	 CY7cqenkzv2z/yuL0yT7wO0GcvuRHtJiodCLDwv/aadi7y01Bvw6hm56ZEOTfxHu/j
	 xP2aekpHj1bAQ==
Message-ID: <sashiko-outbox-162750@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/7] zloop: add storage element emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007082344.1049179-5-dlemoal@kernel.org>
References: <20261007082344.1049179-1-dlemoal@kernel.org>
 <20261007082344.1049179-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 08:35:58 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] block: permanent device bricking due to uncleared restore_in_progr=
ess flag
- [High] block: restored storage elements' zones are permanently left offli=
ne or read-only
- [Medium] block: TOCTOU race allows I/O on OFFLINE/READONLY zones during r=
emoval
--

commit 20ddc2153af7f05d1115bfa8b2509e5c9f65e4f8
Author: Damien Le Moal <dlemoal@kernel.org>
Subject: zloop: add storage element emulation

This commit adds storage element emulation to the zloop driver,
allowing simulation of SMR disk fractional access storage elements.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 394dc2408ed73..e113ecd63c0b2 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c

[ ... ]

> @@ -430,20 +511,19 @@ static int zloop_reset_zone(struct zloop_device *zl=
o, unsigned int zone_no)
> =20
>  	mutex_lock(&zone->lock);
> =20
> +	if (zloop_zone_is_offline_or_readonly(zlo, zone)) {
> +		if (!all_zones)
> +			ret =3D -EIO;
> +		goto unlock;
> +	}
> +
>  	if (!test_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags) &&
>  	    zone->cond =3D=3D BLK_ZONE_COND_EMPTY)
>  		goto unlock;

[Severity: High]
In zloop_restore_elements_work(), the code calls zloop_reset_all_zones()
to reset the zones of restored elements, which in turn calls this function
as zloop_reset_zone(..., all_zones=3Dtrue).=20

Since zloop_zone_is_offline_or_readonly() evaluates to true for these
removed elements' zones, the function jumps to unlock and skips=20
zloop_do_reset_zone().=20

Does this permanently leave the restored elements' zones offline or
read-only, preventing the restoration from completing successfully?

[ ... ]

> +static bool zloop_prep_rq(struct zloop_device *zlo, struct request *rq)
> +{
> +	struct zloop_zone *zone =3D &zlo->zones[rq_zone_no(rq)];
> +	bool is_write =3D op_is_write(req_op(rq));
> +	bool ret =3D true;
> +
> +	spin_lock(&zone->wp_lock);
> +
> +	if (zlo->nr_elements) {
> +		if (zone->cond =3D=3D BLK_ZONE_COND_OFFLINE ||
> +		    (zone->cond =3D=3D BLK_ZONE_COND_READONLY && is_write)) {
> +			ret =3D false;
> +			goto unlock;
> +		}
> +	}

[Severity: Medium]
Is there a time-of-check to time-of-use race condition here?

This validates the zone condition against offline and read-only states
before adding the I/O request to the workqueue. If a concurrently
executing zloop_remove_element_work() transitions the zone condition to
offline while the request is pending in the queue, the request could still
be processed.

Once popped from the queue, zloop_handle_cmd() calls zloop_rw(), which
executes reads and conventional zone writes without re-acquiring the zone
lock or re-validating the zone condition. Could this allow reads and writes
to execute against offlined zones?

[ ... ]

> +static void zloop_restore_elements_work(struct work_struct *work)
> +{
> +	struct zloop_device *zlo =3D container_of(work, struct zloop_device,
> +						restore_elements_work.work);
> +	struct blk_storage_element *se;
> +	unsigned int i;
> +	int ret;
> +
> +	mutex_lock(&zlo->stor_elements_lock);
> +
> +	/* Reset all zones. */
> +	ret =3D zloop_reset_all_zones(zlo);
> +	if (ret)
> +		goto out_unlock;
> +
> +	/* Restore all removed elements. */
> +	for (i =3D 0, se =3D zlo->elements; i < zlo->nr_elements; i++, se++) {
> +		if (se->status =3D=3D BLK_SE_STS_RESTORE_IN_PROGRESS)
> +			se->status =3D BLK_SE_STS_OK;
> +	}
> +
> +	zlo->nr_removed_elements =3D 0;
> +	WRITE_ONCE(zlo->restore_in_progress, false);
> +
> +out_unlock:
> +	mutex_unlock(&zlo->stor_elements_lock);
> +}

[Severity: High]
If zloop_reset_all_zones() fails (for example, if vfs_truncate encounters
an I/O error), this code branches to out_unlock and skips clearing the
restore_in_progress flag.=20

Since zlo->restore_in_progress would remain true, zloop_queue_rq() appears
to unconditionally reject all incoming block I/O with BLK_STS_IOERR
afterward. Does this leave the device permanently bricked on a reset
failure?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007082344.1049=
179-1-dlemoal@kernel.org?part=3D4
