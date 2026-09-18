Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEE12BCF46
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 19:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789760245; cv=none; b=FEtwOPLoqFDQh6O/qYdEgD4Gf9sw6tIsXIqBrg7MgJF3FAG5ZOVrb+uN7o/+uSsTdQ0cc7tlUCTj78RxslkoZd4oOYn0eCUs3Gs0YS7BqEkx/yvZZe2idttcTDy9p2PR3JQHnbZ7eCHn1r8ccwscPwHD2Yxz0eBlUPRT/37xj1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789760245; c=relaxed/simple;
	bh=A/KhCGua5eJ0FwK7fyHsKkAqWRcXDU8kv/s3Y8scgiQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aOndLfD5QaqFU6uKQA8nW+5vk6Jqw0gj98/oCgRINe11h9jVGpYg7H9ehHOqp7J5jXThS0xjsJwWsT73nphsZhA2pJDO2NTYI8boOztu43iWilCmO7vICn10qlPRSXn7jsUPWNiI8R5iI36o5Yupw425XW1fK5cXHuZTXDgKLTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kT/PPD+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kT/PPD+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34ACE1F000FF;
	Fri, 18 Sep 2026 19:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789760244;
	bh=k21PVATF/WZG2x7v5ugTA28aASYKYkV6BBaWW2SI8es=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kT/PPD+5VGnSSUVL5EHkcYbpT838WzgJu5c9tWjs/K9t0Ta0SiVhxQpO7vqvGm0GM
	 sBraNJB1e1PQ+Q7UO9HnV+wPUw/4ZZn3X0Mv+Gkb/TfGfTK9rl7zaddPpCETjUHsLk
	 g79hO73BnHenUsNAiqVN9CEPl2sWr6u5uFS5ozS64Em0xlIP2E6YMKHiqTAuYfQiNh
	 WZrIbOyQP1g8jedyBo2RIfbgqL9PFv/7rjb539AiO3mX+bxVCXKNJYqI+jEa9ZE9DF
	 F+CbuJohcdGcg6qmOcI0KhSaQbWl9pA3KPt1eE4xWC2MUjYk6cDWVPuDQtzo7i0lu+
	 bbDSGNnHzvZXQ==
From: sashiko-bot@kernel.org
Subject: Re: [GIT PULL] SCSI fixes for 7.3-rc3+
Reply-To: sashiko-reviews@lists.linux.dev
To: "James Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <71da251528b9af2948fb5a4c8bcd045e65b3e42e.camel@HansenPartnership.com>
References: <71da251528b9af2948fb5a4c8bcd045e65b3e42e.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 19:37:23 +0000
Message-Id: <20260918193724.34ACE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] block: hardcoded index 0 ignores queue_offset in fnic_mq_init_queue=
_map()
--

commit fb10ad8a27ba0b6671190a2c5e8966d7c784afce
Author: James Bottomley <James.Bottomley@HansenPartnership.com>

SCSI fixes for 7.3-rc3+

This commit pulls in four driver fixes and one core fix. It includes a fix =
in
the fnic driver to add logic avoiding ineffective MSI-X when hyperthreading=
 is
disabled, as well as a core fix validating mode sense buffer sizes.

> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
> index 9b3025007075e..f13c381a66d7f 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -744,8 +744,19 @@ static int fnic_nvme_drv_init(struct fnic *fnic)
>  	return ret;
>  }
> =20
> +static void fnic_mq_init_queue_map(struct fnic *fnic,
> +		struct blk_mq_queue_map *qmap)
> +{
> +	unsigned int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		qmap->mq_map[cpu] =3D 0;

[Severity: Low]
Does this hardcoded index 0 in fnic_mq_init_queue_map() ignore the
queue_offset field provided by the block layer?

If multiple queue maps (like READ/POLL) were ever used, hardcoding 0 instead
of using qmap->queue_offset would violate the block layer API for hardware
queue mapping, routing unassigned CPUs to the tagset's absolute 0th queue
instead of the 0th queue of the correct map.

Because the fnic driver currently sets up only a single default tagset map
(HCTX_TYPE_DEFAULT) where queue_offset is always 0, this doesn't trigger
a functional bug today. But should this be updated to use qmap->queue_offset
for API correctness and future-proofing?

> +}
> +
>  void fnic_mq_map_queues_cpus(struct Scsi_Host *host)
>  {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/71da251528b9af2948f=
b5a4c8bcd045e65b3e42e.camel@HansenPartnership.com?part=3D1
