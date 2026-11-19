Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795108799;
	b=xQMtXn/I9Ib+1qXYzpcT2JyTDRCEsJ06Lm7ZiuATRBLef/7xj6lBXcxR7/SUOD54HiuX
	 0XCLnggKqHfK1gp35pKhYQrlRLjmAo2DejbbUC21J2RydWj4q0Lu9ng176nSMrvqPcIw3
	 IhTfJlDtKxEyVhxzes1slBQ6LsWxH1SQLZelB/qSMVQ1towcYImPeMpNKdlfsQ+5xdahS
	 oHllh+RU27iXgpHHj3MX73oU3IDNkz2RaWbGfET4dferEKjk4GRPH3pMWaCz5X8iJwQbU
	 JHEMKYJybRc+rDyiLUrj/tJMpzZ/nLfxVqZaBcqfcfxtj4KZIbO1TqMfBVgMHkvnWhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795108799;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xD+xyH7Du3+rWz1q1FYt2vWqfNt3lYTluEZnoV4hhec=;
	b=e8A8xZVwOcvU2qtp4ExTrphp/UWB5xazKezP2vs/nPJYoNmZo/sEZsKQOdbkxlfieVZm
	 su/1urvcTtT+5JtW3H4kpAULPX2Fzp07wmDoRj17gkKAE6bGRgXM1M3S3Zcx5/u8PLbow
	 fLzseqzkhJkZ5DYBuHP6DseJbaJN1r/AE3YoEIQ4isAne64nYzdXPwFk5IKr3rNhn1O71
	 N474ENdS9OmnCSDiIctPzpVp9Z3zsRTM0LFKNB3VhMRaA9CFAB/DgFWyZa21SeqnGV9RW
	 uU0wr1e0WYDnEZRGU4Txqrkx1jTB3+UnpaqX5jiZ0ke0yZLRu3hDm2p+8djbPJahyuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dvGSvnN3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B93E606A325
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 17:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dvGSvnN3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25931F000C5;
	Thu, 19 Nov 2026 17:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795108799;
	bh=xD+xyH7Du3+rWz1q1FYt2vWqfNt3lYTluEZnoV4hhec=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dvGSvnN3CSmikSt9HfFCjfhLhJNE6boB1sUslneLb1qfpYKJ0e5yAXiYcaY+MBsK+
	 Z9hcz5kdn77vPBnLxuifIba+i/psoUrudNM6/nvzpql6C253EL6UfPaoX2oA4rO0ft
	 qAKnUwkIlPzhsRohJMMqlHhD30ye6+dD7l1tkSUKS1ox9TOZwqu7DAUnw4lwLRhubo
	 feZFXg4xHwtSk1El8umjH3AMSgoTvoWIedTJ+tEMY23MZw9x4aPYqQGK39m5PvOhpJ
	 Wj7PWKThLsMCB2ffKZ9XMg7nyocbpc8uBu1GlAcLmcU56FBCOVar/NGJ2sfO7qPxfG
	 YtyAerKiOJL/w==
Message-ID: <sashiko-outbox-223682@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Check ahc->flags instead of
 ahc->features for AHC_SCB_BTT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Rogers" <irogers@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261119170605.1518761-1-irogers@google.com>
References: <20261119170605.1518761-1-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 17:19:58 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] scsi: aic7xxx: missing per-LUN untagged limit in
  ahc_linux_run_command()
--

commit ec21efc91528b4a71de5b706f48c1434b9f8f837
Author: Ian Rogers <irogers@google.com>

scsi: aic7xxx: Check ahc->flags instead of ahc->features for AHC_SCB_BTT

This commit changes the untagged queue throttling check in
ahc_linux_run_command() to test ahc->flags instead of ahc->features for
AHC_SCB_BTT.

> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/ai=
c7xxx_osm.c
> index d93b522695eba..e12ee18a18d5f 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1432,7 +1432,7 @@ ahc_linux_run_command(struct ahc_softc *ahc, struct=
 ahc_linux_device *dev,
>  	 * table in SCB space.
>  	 */
>  	if (!(cmd->flags & SCMD_TAGGED)
> -	    && (ahc->features & AHC_SCB_BTT) =3D=3D 0) {
> +	    && (ahc->flags & AHC_SCB_BTT) =3D=3D 0) {
>  		int target_offset;
> =20
>  		target_offset =3D cmd->device->id + cmd->device->channel * 8;

[Severity: High]
Can this dispatch two concurrent untagged commands to the same target and
LUN when AHC_SCB_BTT is set?

ahc_platform_set_tags() sets queue_depth to 2 for untagged devices:

drivers/scsi/aic7xxx/aic7xxx_osm.c:ahc_platform_set_tags() {
    ...
	default:
		/*
		 * We allow the OS to queue 2 untagged transactions to
		 * us at any time even though we can only execute them
		 * serially on the controller/device.  This should
		 * remove some latency.
		 */
		scsi_change_queue_depth(sdev, 2);
		break;
}

When e4e360c325c9 ("[SCSI] remove aic7xxx busyq") removed the per-device
busyq, it also dropped the dev->openings check that serialized untagged
commands per LUN; ahc_linux_run_command() decrements dev->openings and
increments dev->active without checking either first.  Until now that was
masked because (ahc->features & AHC_SCB_BTT) =3D=3D 0 was always true, so
ahc->untagged_queues serialized untagged commands across the whole target.

The SCB-space busy target table (SCB_64_BTT) only holds one SCB tag per
(target, LUN) slot to allow concurrent untagged commands across different
LUNs of a target.  Without a per-LUN check (such as returning
SCSI_MLQUEUE_DEVICE_BUSY when dev->active !=3D 0 for an untagged command, or
limiting untagged queue_depth to 1), bypassing untagged_queues sends a
second untagged SCB for the same (target, LUN) to ahc_queue_scb(),
overlapping untagged commands on the bus and overwriting the SCB_64_BTT
slot on disconnect.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119170605.1518=
761-1-irogers@google.com?part=3D1
