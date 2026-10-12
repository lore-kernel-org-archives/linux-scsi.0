Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9B6418353
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 14:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814796; cv=none; b=dQwgun9qBDgnkfaTukvAmxR4LrAzG4JFXlRhCrmujQUJ0XFeCvpjTHBj2ZytGSz2fyBxpZTjmzydzYjSvzAsQJnhigJfksB2KDHZGKLiB2dpe9bPf9R6SRNJgAoahj9q1wt+Aj6bU7V0s4VA9g5PfxPWPRQWty0KIJFzjHCb4lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814796; c=relaxed/simple;
	bh=DRpu7w4UOEQcG5lSLxscNWRs/jrX7XvFKPTyM5YHElQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KkIqSFivauf+4sz35qtIicBEpg0HLcvbtX0jqwdfRJrwehz7epylsYcSGcrLQwOYzFo3q4xIFG6iXF0OL1EQjV/g1vISWTJ4YMaRLfq0yECIyOyWu3xWPmXkGVUX9ezYm65slg+pEIBsYS62E1cKZvdrCt+vBbzNeFCrC6eePBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUjdk+TZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUjdk+TZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFDA1F0089B;
	Mon, 12 Oct 2026 14:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791814794;
	bh=dVFG7QdH87BZm8vrNgLsaRlm8hdP2/MJlckiS3ykPpE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EUjdk+TZQzQcR7h3LpczWX5OATH5YocBmdQMEZmp3xaqlY8BuaiXq1mNVW6qCMQ3C
	 ob59+c5hdz0E7fUv5O4R36GJmjNp5H4g3Stj0GhC8pklhHRKPG03OzGh6kX1ejUFq3
	 t8sLiuV6LAukzZRjUT/kkTlfOExVPR3gLlb8AIw7tjUt17BD9fOvRZtSAvRFjJOqQv
	 4jZ/tN7qj/o36EBjIrgEqhx5W6k050KCDwny8eJ8K+VaknxT2QZ7zrRmnai8p2Hss4
	 4df2LnZT0WjgPJnYtuK2cnVepUfzz3HIgvY2VoA9GaCer83kfXBoZQyKeyhO/bGSDZ
	 4xFUb68DBVexg==
Message-ID: <sashiko-outbox-168251@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 8/9] scsi: sd_zbc: always revalidate zones for disks
 supporting head depopulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261012130121.1902634-9-dlemoal@kernel.org>
References: <20261012130121.1902634-1-dlemoal@kernel.org>
 <20261012130121.1902634-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 14:19:54 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: data race on bitfield sdkp->modify_zones_supported vs sysf=
s updates
--

commit 008f16ea9959160e815da59ad94c230e5abd0803
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: sd_zbc: always revalidate zones for disks supporting head depopulation

This commit prevents the block layer from skipping blk_revalidate_disk_zone=
s()
for ZBC devices that support head depopulation. It introduces a new bitfiel=
d,
modify_zones_supported, to remember if the device supports the REMOVE ELEME=
NT
AND MODIFY ZONES command.

> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 574af82430169..6a72371fee786 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -156,6 +156,7 @@ struct scsi_disk {
>  	unsigned	ignore_medium_access_errors : 1;
>  	unsigned	rscs : 1; /* reduced stream control support */
>  	unsigned	use_atomic_write_boundary : 1;
> +	unsigned	modify_zones_supported : 1;
>  };
>  #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)

[Severity: Medium]
Is it safe to place this bitfield here? It shares the same machine word as
the sysfs-writable (WCE, cache_override) and EH-writable
(ignore_medium_access_errors) bitfields.

> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 8cbf171e6fabf..1bf5f7ea0d9c5 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
[ ... ]
> @@ -620,6 +641,9 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct =
queue_limits *lim,
>  	if (ret !=3D 0)
>  		goto err;
> =20
> +	/* Check if REMOVE ELEMENT AND MODIFY ZONES is supported. */
> +	sdkp->modify_zones_supported =3D sd_zbc_check_modify_zones(sdkp, buf);
> +
>  	nr_zones =3D round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks=
);
>  	if (nr_zones > INT_MAX) {
>  		sd_printk(KERN_ERR, sdkp, "Too many zones (%llu)\n",

[Severity: Medium]
Can this lockless update race with other bitfield updates, leading to a lost
write?

Because bitfield updates compile down to non-atomic read-modify-write
operations, and no locks synchronize sysfs stores like cache_type_store()
with disk revalidation, concurrent modifications to these bitfields could
result in a data race and lost updates.

If the modify_zones_supported update is lost, sd_zbc_revalidate_zones()
might skip blk_revalidate_disk_zones(), leading to a stale block-layer view
of offline/read-only zones.

Alternatively, if a sysfs update to cache_type (WCE or cache_override) is
lost, it could lead to an unsafe or unexpected write cache configuration.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012130121.1902=
634-1-dlemoal@kernel.org?part=3D8
