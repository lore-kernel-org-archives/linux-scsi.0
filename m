Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DAB48F85E
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 09:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791537718; cv=none; b=axN4kwiWuEHamV8rTBBrhR5fZRQvhaUnVIA37ALwsbgt4tZ69oXKXMWuLI3zEADgiPy+txe6AR8TKshTJmYPl5DuemQFGKHLNhJPgXN4azIcKF12ccfQLboNxJWL7tWLwjkkMdUPsh+OQJyRMZjr3fDFIGwEdr4dt+ldG/R8BIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791537718; c=relaxed/simple;
	bh=418CLMXWGnN2DvCbZUhk9EaY9eNQMbnSPupQBzLTYdY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=RVVR6dyMQL6EkKywgj0c9ZZdhKEAA5xrORSurgv/iHXU3JqWU7DMR/hzr7NYeNB/N3u64jItp0LexlUVxM3XaziS1lGyEEBBWNvMtb6QRQ/dNnM3xR8s8aRIY/d8mQtCumyDOqnbdB4X3s4suooTSKKYbiJHR6/u3T7njudtAQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdryXkyW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdryXkyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A191F000FF;
	Fri,  9 Oct 2026 09:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791537716;
	bh=rDXVjGoOdUaGxHbmLxjZWVzaos0ww2cj1H6pS7s014k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JdryXkyWfZcHByJR41r7akR4o1yQz5WfTnelReY/mwdcpALRgxQwqaJj3Gzp7Umy9
	 DntvYSMwxQIda4iJ+zv5Fp+uWqFMQXEteij3SB69QQoJRJ8wphXJ2ulsIn+DE6oubj
	 Z0ecp+e+myUNAr8kNPCfaeUU0HUdmz/DgTOKVsPnmRIKujtBej/tnfRZX1p8qCJJ5F
	 D4teOIYwfMYaHogSfMGk9bTv5jh0iia2B29/s/m9luHC8T6lKW+CcBdUNC341kC1kJ
	 pEYjNLq+0M0EtiVTMf2LkrKDbGeTehh6+ocfZSqqRF4Vi6FzoBTpupYziddj/mjPN/
	 tY+wqJjReqP+g==
Message-ID: <sashiko-outbox-165156@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 5/9] zloop: add storage element emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261009090945.1504194-6-dlemoal@kernel.org>
References: <20261009090945.1504194-1-dlemoal@kernel.org>
 <20261009090945.1504194-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 09:21:56 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] block: IDR and module leak on zloop_ctl_add error path
- [High] block: zone reset vfs_truncate races with in-flight IO
- [Medium] block/zloop: elements left in RESTORE_IN_PROGRESS on error
--

commit 2aa446d71ddca7634ded310055adccb68fd83788
Author: Damien Le Moal <dlemoal@kernel.org>
Subject: zloop: add storage element emulation

Emulate the storage element depopulation feature of SMR disks in the
zloop driver. This emulation is controlled using the new stor_elements
option.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
> @@ -420,7 +486,22 @@ static int zloop_close_zone(struct zloop_device *zlo=
, unsigned int zone_no)
>  	return ret;
>  }
> =20
> -static int zloop_reset_zone(struct zloop_device *zlo, unsigned int zone_=
no)
> +static int zloop_do_reset_zone(struct zloop_device *zlo,
> +			       struct zloop_zone *zone)
> +{
> +	if (vfs_truncate(&zone->file->f_path, 0))
> +		return -EIO;
> +

[Severity: High]
Is there a potential race between this background truncation and active I/O?

When zloop_restore_elements() sets zlo->restore_in_progress =3D true and
schedules the background restore work, it rejects new I/O but doesn't
appear to drain in-flight I/O (for example, by using blk_mq_freeze_queue()).

If an in-flight REQ_OP_WRITE in zloop_cmd_workfn() executes
zloop_seq_write_prep() (which acquires zone->wp_lock, but not zone->lock)
at the same time this worker calls vfs_truncate(), could the worker
truncate the file to 0 just before the write completes at the old write
pointer? This might desync zone->wp and create a massive sparse file.

[ ... ]

> +static void zloop_restore_elements_work(struct work_struct *work)
> +{
> +	struct zloop_device *zlo =3D container_of(work, struct zloop_device,
> +						restore_elements_work.work);
> +	struct zloop_zone *zone;
> +	struct blk_se *se;
> +	unsigned int i;
> +	int ret;
> +
> +	mutex_lock(&zlo->stor_elements_lock);
> +
> +	/* Reset all zones. */
> +	for (i =3D 0, zone =3D zlo->zones; i < zlo->nr_zones; i++, zone++) {
> +		if (test_bit(ZLOOP_ZONE_CONV, &zone->flags)) {
> +			zloop_restore_conv_zone(zlo, zone);
> +			continue;
> +		}
> +		ret =3D zloop_restore_seq_zone(zlo, zone);
> +		if (ret)
> +			goto out_unlock;

[Severity: Medium]
If a zone file truncation fails here, are the storage elements left
indefinitely in the BLK_SE_STS_RESTORE_IN_PROGRESS state?

The error path jumps to out_unlock, which clears zlo->restore_in_progress
but skips updating the se->status for individual elements. Should this error
path transition the elements to BLK_SE_STS_RESTORE_ERROR instead, so that
userspace queries (like zloop_report_elements()) return an accurate status?

> +	}
> +
> +	/* Restore all removed elements. */
> +	for (i =3D 0, se =3D zlo->elements; i < zlo->nr_elements; i++, se++) {
> +		if (READ_ONCE(se->status) =3D=3D BLK_SE_STS_RESTORE_IN_PROGRESS)
> +			WRITE_ONCE(se->status, BLK_SE_STS_OK);
> +	}
> +
> +	zlo->nr_removed_elements =3D 0;
> +
> +out_unlock:
> +	WRITE_ONCE(zlo->restore_in_progress, false);
> +	mutex_unlock(&zlo->stor_elements_lock);
> +}

[ ... ]

> @@ -1361,6 +1870,10 @@ static int zloop_ctl_add(struct zloop_options *opt=
s)
>  		zlo->id, zlo->nr_zones,
>  		((sector_t)zlo->zone_size << SECTOR_SHIFT) >> 20,
>  		zlo->block_size);
> +	if (zlo->nr_elements)
> +		pr_info("zloop%d: %d storage elements\n",
> +			zlo->id, zlo->nr_elements);
> +
>  	pr_info("zloop%d: using %s%s zone append\n",
>  		zlo->id,
>  		zlo->ordered_zone_append ? "ordered " : "",
> @@ -1370,6 +1883,8 @@ static int zloop_ctl_add(struct zloop_options *opts)
> =20
>  out_cleanup_disk:
>  	put_disk(zlo->disk);
> +	return ret;
> +

[Severity: High]
Does this early return bypass the IDR removal and module reference put?

If we return here, the out_free_idr label (which calls idr_remove()) and
the final out label (which calls module_put(THIS_MODULE)) are completely
skipped.

Since put_disk() ultimately triggers zloop_free_disk() which frees the
zlo structure via kvfree(zlo), does leaving the freed pointer in
zloop_index_idr create a dangling pointer for subsequent lookups? It also
appears the module reference would be leaked permanently.

>  out_cleanup_tags:
>  	blk_mq_free_tag_set(&zlo->tag_set);
>  out_close_files:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009090945.1504=
194-1-dlemoal@kernel.org?part=3D5
