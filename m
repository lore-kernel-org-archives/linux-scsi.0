Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4423A6B67
	for <linux-scsi@vger.kernel.org>; Sun,  6 Sep 2026 21:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788730206; cv=none; b=HUA15dADWb20Br1kmRGkGMnWxEBTXrjIXCuHML4JHVcyTdDg7JnFnUS/BXFaD2idLtSDa+dzvtgzlDl91TCncUkT/9Girew49zI1c1EloidGpRw8tgcBPHy4/KyvMQ2ETZWvf8HgMz1QQPed4L/9LZbiC+UU5j1UdLag8CdyZ5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788730206; c=relaxed/simple;
	bh=SKz3MzpAFLqcBFbZt6Vr+m5qqTP3Le/U1ZcVqozUwpk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N+Vk7ohxKRE41KtaCe5WRDxj2kI3iNynFj0vqLFOE0gPN2H6x5WVGMTglsqGwAbD8l72v9dzZI+ypoBkwNrF4vqQ/tlbJhu9k4JhDL/U8xyJu11iQSwVnBm4rxSPHWoeyXwBy/4rD47YTOQuElPysBcLgQ891nB2+kote03nhLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OkvquIjv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OkvquIjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9631F00A3A;
	Sun,  6 Sep 2026 21:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788730205;
	bh=7HEahVYP1vb6HfrxCapngnjdx1JQFzGvhmBITccG1aQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OkvquIjvB6V4K9g0caJhIaHbDyssNRhNGurYm1nh6anNgsLKzsS6mrGiUCumffWpy
	 rqHY2Zp088dL1nLWD2+sroT5yajbmU9dXWflJQZR4qH49ilusb8NhkJ38WT2J6OzIQ
	 6fzt+D+7RZ5ubjBcvtBgHDJp88X9eAVUsTJ+h/msP0QT2THU1BbCtF9p3zFhGxmNTs
	 TlFzA/I+cSauoKGLStHWt/UgXhOWaoMX3RBQYcnytd2zSm4pC3diCjgeNNaC2po4Zb
	 xOX0LXMNDTsoFza8FB8ifzHPQXA4LPVJ68/7w9jrQVCkYML8dusimfGv6eIFZoVHwh
	 9llPF9Iszh6Yw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: mpt3sas: fix nr_msix underflow in
 _base_assign_reply_queues()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ivy Lopez" <skunkolee@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260906211454.71432-1-skunkolee@gmail.com>
References: <20260906202236.53346-1-skunkolee@gmail.com>
 <20260906211454.71432-1-skunkolee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 06 Sep 2026 21:30:04 +0000
Message-Id: <20260906213004.DD9631F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Clamping `ioc->reply_queue_count` to `MaxMSIxVectors` without adju=
sting `ioc->iopoll_q_start_index` or `ioc->high_iops_queues` causes severe =
integer underflows when setting up block multi-queue mappings.
- [High] Missing bounds check on `cpu` in `_base_assign_reply_queues` fallb=
ack path allows out-of-bounds heap write.
- [Medium] Incorrect loop termination condition `cpu >=3D nr_cpus` breaks M=
SI-X vector assignment on sparse CPU masks.
--

commit ae1909467e242e2fb7afde51ded872b5492ad061
Author: Ivy Lopez <skunkolee@gmail.com>

scsi: mpt3sas: fix nr_msix underflow in _base_assign_reply_queues()

This commit fixes a bug in the fallback path of _base_assign_reply_queues()
where iopoll_q_count was incorrectly subtracted from nr_msix. It ensures
that the reserved queue count is checked against nr_msix before performing
the subtraction to prevent underflows that could break affinity grouping or
cause a divide-by-zero.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index 1af25a22611a1..40888b07b5a26 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -3275,7 +3275,11 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *=
ioc)
> =20
>  fall_back:
>  	cpu =3D cpumask_first(cpu_online_mask);
> -	nr_msix -=3D (ioc->high_iops_queues - iopoll_q_count);
> +	if (ioc->high_iops_queues + iopoll_q_count >=3D nr_msix) {
> +		ioc_warn(ioc, "high_iops_queues and iopoll_q_count exceed available MS=
I-X vectors\n");
> +		return;
> +	}
> +	nr_msix -=3D (ioc->high_iops_queues + iopoll_q_count);
>  	index =3D 0;
> =20
>  	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {

[Severity: High]
This is a pre-existing issue, but does clamping ioc->reply_queue_count
to MaxMSIxVectors earlier in this function cause integer underflows in
the block layer mappings?

In _base_assign_reply_queues(), the driver initially clamps the count:

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_assign_reply_queues() {
    ...
	nr_msix =3D ioc->reply_queue_count =3D min(ioc->reply_queue_count,
					       ioc->facts.MaxMSIxVectors);
    ...
}

But it doesn't adjust ioc->iopoll_q_start_index or ioc->high_iops_queues.
Later, this clamped value is subtracted in scsih_map_queues():

drivers/scsi/mpt3sas/mpt3sas_scsih.c:scsih_map_queues() {
    ...
	int iopoll_q_count =3D ioc->reply_queue_count - nr_msix_vectors;
    ...
}

And in scsih_init():

drivers/scsi/mpt3sas/mpt3sas_scsih.c:scsih_init() {
    ...
		shost->nr_hw_queues =3D
		    ioc->reply_queue_count - ioc->high_iops_queues;
    ...
		iopoll_q_count =3D
		    ioc->reply_queue_count - ioc->iopoll_q_start_index;
    ...
}

If the firmware advertises fewer MSI-X vectors than initially reserved,
could these subtractions evaluate to negative integers that wrap around
to massive unsigned values, causing out-of-bounds loop iterations and
memory allocation failures?

[Severity: Medium]
This is a pre-existing issue, but does the fallback loop handle sparse CPU
masks correctly?

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_assign_reply_queues() {
    ...
	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
    ...
		if (cpu >=3D nr_cpus)
			break;
    ...
		for (i =3D 0 ; i < group ; i++) {
			ioc->cpu_msix_table[cpu] =3D reply_q->msix_index;
			cpu =3D cpumask_next(cpu, cpu_online_mask);
		}
    ...
}

If a system has a sparse CPU topology (e.g., CPU IDs 0 and 4, meaning
nr_cpus is 2), wouldn't the check cpu >=3D nr_cpus improperly compare a
discrete CPU ID against the aggregate online CPU count and terminate the
loop prematurely?

[Severity: High]
This isn't a bug introduced by this patch, but is there a missing bounds
check that could lead to an out-of-bounds heap write?

Earlier in _base_assign_reply_queues(), nr_cpus is sampled locklessly:

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_assign_reply_queues() {
    ...
	nr_cpus =3D num_online_cpus();
    ...
}

Later, the inner fallback loop assigns array elements using the CPU ID:

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_assign_reply_queues() {
    ...
		for (i =3D 0 ; i < group ; i++) {
			ioc->cpu_msix_table[cpu] =3D reply_q->msix_index;
			cpu =3D cpumask_next(cpu, cpu_online_mask);
		}
    ...
}

If a new CPU is hotplugged with a higher ID, or a concurrent hot-unplug
reduces the online count while this loop runs, could cpumask_next()
return a CPU ID that exceeds ioc->cpu_msix_table_sz?

Since this fallback loop lacks the bounds check present in the main
SMP affinity path (if (cpu >=3D ioc->cpu_msix_table_sz)), could this
write past the end of the dynamically allocated cpu_msix_table array?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260906211454.7143=
2-1-skunkolee@gmail.com?part=3D1
