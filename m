Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587D249D5A3
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 09:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791538354; cv=none; b=nL3YeRchdn5D5ioK9CnBAT7DADn0nCXK3IqMHP+9ixewv0rjlbGADRpSxO7D6INZZLppt2gbp2M/Vm9yQI28hkt20zObeUL4+4sJKWtdig/4CM/D2g5d6Mo9Q/RLcM+0qCvw+f4fzz5TmBH5agcf2tnOzl3tnnZgS/Rxzmpvte0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791538354; c=relaxed/simple;
	bh=Cq/3PSiOImzGHc4+kwq6CpWtfX80JVz575GO2X0DY1k=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=RrWQigR0NMWaaSB1flOMF1mNsqbR+IQ1+1VSCyJIXrEA2MYjnTKwZUeNfT1oybo7GfxHt3TD4eEFgQPlhCo7s2OBpdPZoN8DoHYACzirioKrbxFx3M9VrX1VW/l218R9tMIDe9W/R6ueUvlI/QkKRT6T9yFC7jIt9ZbKla/0Z1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYuAmiaa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYuAmiaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859BF1F000FF;
	Fri,  9 Oct 2026 09:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791538349;
	bh=02+XnG/juQTlXzhiVX6XEVI8wBS/hKZMUHRHiwp4pX8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jYuAmiaabpUuXHK5Nfvtu+q/1s4uxQGw6LlC9uXc7Acj5rZzdnt4jKnb39j98cNJ3
	 1J8SPX8n8dG9NJYFiOzaRVEreb0ufIqUG8jkHsbekCMicMnkSlgew8Ips/0YAXOnAu
	 Pm041dVBxSw28TcZjTaBkE5/+Kw6g3BAZ2rGq1kgqQEmeyCVwzK36vui8Z096xFgd3
	 OXwC0mBngy9X6Erm6BYV9a7pqrryZZGhL0wW9JskZbRukAy0GsYNwy6aHs62LfWgkK
	 7elRWdFge/r7eDRgdXDNJU4FLKEiat+yrXQfR8Yk29AXF9lAmP1jojEv5AlemyRvXp
	 idMmeRKOWj6xw==
Message-ID: <sashiko-outbox-165171@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 8/9] scsi: sd_zbc: always revalidate zones for disks
 supporting head depopulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261009090945.1504194-9-dlemoal@kernel.org>
References: <20261009090945.1504194-1-dlemoal@kernel.org>
 <20261009090945.1504194-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 09:32:29 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: sd: data race on struct scsi_disk bitfields can clobber WCE =
or modify_zones_supported
--

commit a445da75935ac3ec4cee9fc525679769cf828446
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: sd_zbc: always revalidate zones for disks supporting head depopulation

This commit introduces a new check for ZBC devices that support data preser=
ving
head depopulation to ensure zone conditions are properly revalidated. It ad=
ds
a new modify_zones_supported bitfield to struct scsi_disk and sets it during
sd_zbc_read_zones(). The flag is then used to skip or perform zone revalida=
tion
depending on the disk's support for this feature.

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

[ ... ]

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
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
Does this bitfield assignment introduce a data race that can silently corru=
pt
neighboring bitfields like WCE?

Since C compilers implement bitfield assignments as non-atomic
read-modify-write operations on the underlying machine word, updating
modify_zones_supported here in sd_zbc_read_zones() during disk
revalidation might race with sysfs stores.

For example, if a user or udev script writes to
/sys/class/block/*/device/cache_type concurrently with a disk
revalidation event, cache_type_store() in drivers/scsi/sd.c updates
neighboring bits:

drivers/scsi/sd.c:cache_type_store() {
    ...
    sdkp->WCE =3D wce;
    sdkp->RCD =3D rcd;
    ...
}

If these operations interleave without holding a lock that synchronizes
the revalidation paths and sysfs writes, one update could silently
overwrite the other. This could potentially disable or enable write
caching unexpectedly or lose the modify_zones_supported flag.

> +
>  	nr_zones =3D round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks=
);
>  	if (nr_zones > INT_MAX) {
>  		sd_printk(KERN_ERR, sdkp, "Too many zones (%llu)\n",

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009090945.1504=
194-1-dlemoal@kernel.org?part=3D8
