Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F2B415F2A
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 08:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791362493; cv=none; b=koIrZX35A6zVl4AIG3fKU8RSlHRW33Joa5ndZgT1dw27RueFEhJr3NZ7oSS5va30e6S3epUG8oDs5rl4wnc3jltEEe+R/iyAMSDkDyeeZgkcGe/Xe0zpOCMk6AmkVn1p4L3HRnoCwLXSFbWPvBoFqkduyVqo4whqamwwgtGF2v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791362493; c=relaxed/simple;
	bh=ODUU6a4ke4hg4n+BtgvAHTVn59mQ9Q+xJMFVxI8N9AU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=slIepirJMEF+pTG5MCgnil008Y6DLLWyHYGEJDgMs1rbo64XB5/+dFpPfxws7xrfRoGQcKZXRaSRvLkNT9kBjbd3jqzrJ1YXngFgI3L9KvcuLbpE+rPg/4syJf5d/VmvmSbTvZ3f7z+wV7NxB3k8/Z2y9BaSod5yjaumOgpoZY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZ17NCA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZ17NCA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B751F0089B;
	Wed,  7 Oct 2026 08:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791362488;
	bh=9PHJiUEJeFNkp7z3/cwgyjVse39+q2Z6Ruv0a8WfkhY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AZ17NCA3PUOeWwkvyL0ADAOh619bJfMGhp4MYY08NjKHJQZT607tvjNzJ+riPjh8f
	 xqJRcsWhi16pB2EcFfYyNbaHFk49700X9oIfmYL7aRJjv9EiOc6bEj75oB4K3WaRoX
	 lERz8x3PwOWM81zauMtk6EbPCEdUv6e+F+E/8hcfSsimeBDxxmqdvBTHfylo3ePUSN
	 maVqYm26tkHW4W8xKrFFrF6oay//W9fknGeMsiWc09RqD/rzh25uyHRTPurUIB50u+
	 W8ChIGUXQKZK1WDtKR6TfrmSBgbOyiP6/xdyJ2IsqHinbUX46YUoyFPsC8FhR0wukZ
	 Chn2TRd7UFBEw==
Message-ID: <sashiko-outbox-162755@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/7] block: fail reads to offline zones early
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007082344.1049179-2-dlemoal@kernel.org>
References: <20261007082344.1049179-1-dlemoal@kernel.org>
 <20261007082344.1049179-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 08:41:28 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] block: slab-out-of-bounds read in disk_zone_get_state() due to rac=
e with capacity expansion
--

commit 891363eb78b3eced11718bdb36c5d62832506870
Author: Damien Le Moal <dlemoal@kernel.org>

block: fail reads to offline zones early

Any BIO targeting an offline zone of a zoned block device will fail,
including read commands. This commit fails these read operations early if we
ever see one.

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 8836c7028568b..5c6be90e5d7f6 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -867,6 +867,9 @@ void submit_bio_noacct(struct bio *bio)
> =20
>  	switch (bio_op(bio)) {
>  	case REQ_OP_READ:
> +		if (bdev_is_zoned(bdev) &&
> +		    bdev_zone_is_offline(bdev, bio->bi_iter.bi_sector))

[Severity: High]
Could this introduce a data race leading to a slab-out-of-bounds read?

Looking at the fast path in submit_bio_noacct(), this evaluates
bdev_zone_is_offline() locklessly before blk_queue_enter() is called to
freeze the queue.=20

Concurrently, disk_revalidate_zone_resources() can expand the zone capacity
and update disk->nr_zones before replacing the RCU-protected zones_state=20
array:

block/blk-zoned.c:disk_revalidate_zone_resources() {
    ...
    disk->nr_zones =3D args->nr_zones;
    ...
    disk_set_zones_state_array(disk, args->zones_state);
}

Because disk->nr_zones is updated independently of the disk->zones_state
array replacement, a reader in disk_zone_get_state() might fetch the new,
larger nr_zones value but still dereference the old, smaller zones_state
array pointer.

If a read bio targets a sector in the newly expanded region, the bounds
check in disk_zone_get_state() would pass incorrectly:

block/blk-zoned.c:disk_zone_get_state() {
    ...
    zones_state =3D rcu_dereference(disk->zones_state);
    if (likely(zones_state && zno < disk->nr_zones))
        zs =3D zones_state[zno];
    ...
}

This would lead to an out-of-bounds read on the old array allocation. Should
we ensure the queue is entered or otherwise protect against concurrent zone
revalidation before checking the offline status?

> +			goto end_io;
>  		break;
>  	case REQ_OP_WRITE:

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007082344.1049=
179-1-dlemoal@kernel.org?part=3D1
