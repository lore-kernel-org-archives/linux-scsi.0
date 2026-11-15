Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755236;
	b=0MkiiUdq756xgZNWrit96R8sBUKT4cp5hPtbvFsHHSKnz3A7yk8m34qndGQxj4ZKUwt+
	 h05MI3i0+STcPzfLxDvvvdqyDkrsnhWRcxl2ycT5ZaM7dh9CXS3HIHVnv8u1bJQuLYosL
	 vPpav5eJQsC6wmqEJ2AzLndQYbvvjjQ3cXstwemugoVi1Juw6V49BP/e6QxN3+Ddg5bch
	 jb2zkTans/Bb4FkUlSYvt9gpcJ6UIkR/hFFXFOLmLnNDgRwY1l4jyX5b1pvhpCkGQzxY8
	 tTmnxmcq74dc91aywu6FXYjrx/0yAitDADTJP0CX2HQLRhoiK6F7TaCSZUmu75CQoyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755236;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Dd4GF/zTYfrxhrRpB/5Ws+dPYNlVVj1A9iO7l2XySR0=;
	b=5OrgH9yMCqaPSvMFsBID3euoadoew/kncMElPkOdMtP7HSI+W5F2ZW7hDsGj6fa51DJ1
	 +2J7sI0aLKUwIwU/9CgXg2IqmrNpin+BEGgWhXiAd+/jZ2IPBWnEUQWggaGaueql9uQiF
	 gUaWSNH5FQv0fohyG6v+nf+ylZwdCDNt+TmXoDRXZR5axYvuURC2/FVVzI2RdvUE2jxnR
	 iRHAhDufuhiTh3fuafiPieKTx9droe9GFNAjAPKscU206LLTBAlnYL0Bfnomqwfdw1keW
	 OK5hDDh8/NAYHZ4j4il3+0bDQmKzKZCGNhAHPAJGeCpo0ZTYIhboTpJ3gUq5lvTH2Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aSlMCVJk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7FF606A31E
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 15:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aSlMCVJk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB371F000C4;
	Sun, 15 Nov 2026 15:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755236;
	bh=Dd4GF/zTYfrxhrRpB/5Ws+dPYNlVVj1A9iO7l2XySR0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=aSlMCVJkh3UWzd0lxzewQ6hxA4PejUCikk+xw9CF8LqbOGTcxhdXAQOks7d49dOGm
	 V7ZiW6IYS+YUaqGdbyTwdFqvr5uBAdVGVD0EW0GHd7vPCWMR0aUw5cwQ+43Cgf/5Rt
	 8ksRfS/bep28HMUNFK1yABrcfG7YNGnLDK/PFd574dRQ73lm5zmig9W+e7JjVKeanq
	 mCzc0Bv6GwVJ9FiydXt3pBV3RVGPHbiVph+lgyXtCB+gcP9bMOZCtdARBpyCvQAKLn
	 XV3xvyZx5SvT2qHkiaqqzgzy6oG0Irg6bMr0SiCnLKFtxTHTodXKT8Djl5kJr0E6u/
	 kR8gj4phi1TmA==
Message-ID: <sashiko-outbox-215607@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 06/13] zloop: keep zone write pointer and condition
 consistent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20261115145015.938426-7-dlemoal@kernel.org>
References: <20261115145015.938426-1-dlemoal@kernel.org>
 <20261115145015.938426-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 15:07:15 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] zloop: static ret in zloop_set_zone_append_sector() causes
  sticky errors
- [High] zloop: redundant zloop_do_open_zone() in zloop_seq_write_prep()
  fails I/O
- [Medium] zloop: race on zone->cond between
  zloop_set_zone_append_sector() and open
--

commit f1c0873a72a5832aa13e65548e6e03362a25c8cb
Author: Damien Le Moal <dlemoal@kernel.org>

zloop: keep zone write pointer and condition consistent

This commit calls zloop_do_open_zone() in zloop_set_zone_append_sector()
and changes its return type to blk_status_t so ordered zone append commands
implicitly open the target zone when the write pointer is updated.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 65634a39b0bfc..7aba65d43b250 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
> @@ -885,20 +885,26 @@ static void zloop_complete_rq(struct request *rq)
>  	blk_mq_end_request(rq, sts);
>  }
> =20
> -static bool zloop_set_zone_append_sector(struct request *rq)
> +static blk_status_t zloop_set_zone_append_sector(struct request *rq)
>  {
>  	struct zloop_device *zlo =3D rq->q->queuedata;
>  	unsigned int zone_no =3D rq_zone_no(rq);
>  	struct zloop_zone *zone =3D &zlo->zones[zone_no];
>  	sector_t zone_end =3D zone->start + zlo->zone_capacity;
>  	sector_t nr_sectors =3D blk_rq_sectors(rq);
> +	static blk_status_t ret =3D BLK_STS_OK;

[Severity: High]
Should ret be a non-static local variable?

Because ret is declared static and is never reset to BLK_STS_OK on the
success path, once any call fails, every subsequent ordered zone append
opens the target zone, advances zone->wp, and still returns the stale error
to zloop_queue_rq(), aborting the request and leaving zone->wp out of sync
with the backing file.  Concurrent callers on different zones also race on
reading and writing ret.

A later patch in the series, commit "zloop: add storage element emulation",
refactors zloop_set_zone_append_sector() and removes this static variable,
but this commit carries a Fixes: tag and introduces the regression for
bisection and backports.

> =20
>  	spin_lock(&zone->wp_lock);
> =20
>  	if (zone->cond =3D=3D BLK_ZONE_COND_FULL ||
>  	    zone->wp + nr_sectors > zone_end) {
> -		spin_unlock(&zone->wp_lock);
> -		return false;
> +		ret =3D BLK_STS_IOERR;
> +		goto unlock;
> +	}
> +
> +	if (!zloop_do_open_zone(zlo, zone, false)) {
> +		ret =3D BLK_STS_ZONE_OPEN_RESOURCE;
> +		goto unlock;
>  	}

[Severity: Medium]
Can calling zloop_do_open_zone() under only zone->wp_lock race with
zloop_open_zone() on the same zone?

zloop_open_zone() calls zloop_do_open_zone() while holding only zone->lock,
without taking zone->wp_lock:

drivers/block/zloop.c:zloop_open_zone() {
	...
	mutex_lock(&zone->lock);
	...
	if (!zloop_do_open_zone(zlo, zone, true))
		ret =3D -EIO;
	...
}

When a zone is in BLK_ZONE_COND_EMPTY or BLK_ZONE_COND_CLOSED, an ordered
zone append and an explicit zone open can enter zloop_do_open_zone()
concurrently:

CPU0                                  CPU1
zloop_queue_rq()                      zloop_open_zone()
  zloop_set_zone_append_sector()        mutex_lock(&zone->lock)
    spin_lock(&zone->wp_lock)           zloop_do_open_zone()
    zloop_do_open_zone()                  switch (zone->cond)
      switch (zone->cond)                 zloop_open_closed_or_empty_zone()
      zloop_open_closed_or_empty_zone()     spin_lock(&zlo->open_zones_lock)
                                            zlo->nr_open_zones++;
                                            list_add_tail(&zone->open_zone_=
entry, ...)
                                            spin_unlock(&zlo->open_zones_lo=
ck)
        spin_lock(&zlo->open_zones_lock)
        zlo->nr_open_zones++;
        list_add_tail(&zone->open_zone_entry, ...)  <-- list corruption

Both paths add zone->open_zone_entry to zlo->open_zones_lru_list and
increment zlo->nr_open_zones, corrupting the LRU list and open zone
accounting.

> =20
>  	rq->__sector =3D zone->wp;
> @@ -906,9 +912,10 @@ static bool zloop_set_zone_append_sector(struct requ=
est *rq)
>  	if (zone->wp >=3D zone_end)
>  		zloop_mark_full(zlo, zone);

[Severity: High]
Does calling zloop_do_open_zone() again in zloop_seq_write_prep() fail
ordered zone appends that fill a zone?

When an ordered zone append reaches zone_end here, zloop_mark_full() sets
zone->cond to BLK_ZONE_COND_FULL before the command work item runs.  When
the work item later executes zloop_rw() -> zloop_seq_write_prep(), it
skips the capacity check and write pointer update for ordered_zone_append,
but still calls zloop_do_open_zone() unconditionally:

drivers/block/zloop.c:zloop_seq_write_prep() {
	...
	/* Implicitly open the target zone. */
	if (!zloop_do_open_zone(zlo, zone, false)) {
		ret =3D -EIO;
		goto out_unlock;
	}

	if (!is_append || !zlo->ordered_zone_append) {
		zone->wp +=3D nr_sectors;
		if (zone->wp =3D=3D zone_end)
			zloop_mark_full(zlo, zone);
	}
	...
}

Because zloop_do_open_zone() returns false when zone->cond is
BLK_ZONE_COND_FULL, the zone-filling append (and any earlier in-flight
ordered append to that zone whose work item runs after zloop_mark_full())
fails with -EIO and sets ZLOOP_ZONE_SEQ_ERROR.  Skipping
zloop_do_open_zone() in zloop_seq_write_prep() when is_append and
zlo->ordered_zone_append are set would avoid reopening a zone that was
already opened and possibly marked full at submission time.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115145015.9384=
26-1-dlemoal@kernel.org?part=3D6
