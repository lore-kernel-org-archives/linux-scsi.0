Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFB143991C
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 08:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791362161; cv=none; b=tn3sbtV6j0BlISmLgIWX9rV7gotqb3eJF8dAQgDJLKLGhaCpPqypoo7j+SBShjSf4mZEXJnO8358JT4yDGQVRBeb27D0lwg57OKK+ZETNTA+YQ2BTgmA8OtLHrGeBtePXXtM8jwqV+AimCXv1YuVvEOycxYWm1r5AwlNnJ6sBFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791362161; c=relaxed/simple;
	bh=ORaCBiAhY+bMBWViN6bfzHx9HjRJkKCVTaGHuIVpKCI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=N5kasu3niOJ6U0WxYgbGmGg1Af34WJivEB1OYtdBoj+ASZOPinfth9MFBOIMenWa83P5ORORxGYqcFvlG2zsc5Nf69t7oHGl7DffKxDR7l/Eaff/+s9b0uWye4pqk+OoJVwQIsM4oZak3ce5s0ruReZFLiROKIzpprOLPc+gs5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E24NAgA1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E24NAgA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299161F0089D;
	Wed,  7 Oct 2026 08:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791362159;
	bh=9rZTTedJBdOy6WHP1HHofsxl34lGGmZmjLfAhFMvn1A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E24NAgA1bqL+TZDJCjyI9GvumJKWkfyLI197TiSpF6HZYMjCFDQOMxl10G1PG+b5P
	 R3l6vLjCm7qsfxIlJXin3A5P+/de7IxnHQkF5fZPqPWhmx8vInNzlKYQYSYNDT68IA
	 a/FKP/hURLYZ/VmNXaJAkB/bVJ7dNXJFgXiOqZiypgLQmDBlEXV0JX4zu+iODBIK9l
	 pVfB3ZsrpHiUAJR3vsQrDXcGAWXGxLTWPWawD5D8RPx8Z/v919zjYZNL7R26G3e7Uw
	 IC62LHmPoYVRSEikrISS+Vr+5AFyhtr0x2IsbSmltCSAgOUI5K9itUUTQcS/yNsIGb
	 sJna7BXgHEevQ==
Message-ID: <sashiko-outbox-162751@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 6/7] scsi: sd_zbc: always revalidate zones for disks
 supporting head depopulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007082344.1049179-7-dlemoal@kernel.org>
References: <20261007082344.1049179-1-dlemoal@kernel.org>
 <20261007082344.1049179-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 08:35:58 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: sd: Data race on struct scsi_disk bitfields including modify=
_zones_supported
--

commit 38d051c5f929d7e01fbe804c20673174398bee9b
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: sd_zbc: always revalidate zones for disks supporting head depopulation

This commit ensures that zone revalidation is always performed for ZBC disks
that support head depopulation, even if the zone size and number of zones
have not changed. It adds a new bitfield to track the disk's support for
the REMOVE ELEMENT AND MODIFY ZONES command.

> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 574af82430169..6a72371fee786 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -156,6 +156,7 @@ struct scsi_disk {
>  	unsigned	ignore_medium_access_errors : 1;
>  	unsigned	rscs : 1; /* reduced stream control support */
>  	unsigned	use_atomic_write_boundary : 1;
> +	unsigned	modify_zones_supported : 1;

[Severity: High]
Does adding this bitfield here introduce a data race with other concurrently
accessed bitfields?

C compilers implement bitfield assignments as non-atomic read-modify-write
(RMW) operations on the underlying memory word. This bitfield shares a
memory word with WCE, cache_override, and ignore_medium_access_errors.

>  };
>  #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
> =20

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

[Severity: High]
Can this assignment silently overwrite concurrent updates to other bitfield=
s?

This assignment is executed in sd_zbc_read_zones() during disk revalidation.
Concurrently, a sysfs store via cache_type_store() can modify cache_overrid=
e,
WCE, and RCD before acquiring queue_limits_start_update(), meaning it does
not synchronize with disk revalidation. Additionally, sd_eh_action() can
modify ignore_medium_access_errors from the asynchronous SCSI error handler.

If sd_revalidate_disk() runs concurrently with the sysfs cache updates or
SCSI EH, their non-atomic RMW operations on the shared bitfield word will
race.

Losing the WCE bit update could result in skipped cache flushes and
subsequent data corruption on power loss. Losing the modify_zones_supported
update could cause the block layer to skip necessary zone revalidation on Z=
BC
disks.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007082344.1049=
179-1-dlemoal@kernel.org?part=3D6
