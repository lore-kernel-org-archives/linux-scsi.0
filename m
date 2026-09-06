Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5772EEE93
	for <linux-scsi@vger.kernel.org>; Sun,  6 Sep 2026 20:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788727176; cv=none; b=f1tiA6xbrm00EZHvYH7GiccN/Acsnz/8FydkeHjMkWyyT0tMNaubCAkoKG8fkTVVTEk3qDCIP6ccZb8uNxlkyqZ/tiNRgKU2jiBrAnVG8fmWij7iv32J9xR/Bw92VqNcUuM7N5fyGc6mgjmZQqP0phipjtURaRhSQxk4o3t16gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788727176; c=relaxed/simple;
	bh=K3r/ntSwmW53Mh5cnxS29zlWxZx1PBqmstRVAHfOtCU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oGuYvl6yrTzmfWQDXuUEhS6GiA1vNewV5mJpHgyV8zGdvJd8IOy8gSxXUYRa9OzTMMm/i/45hQVgXRLlIwmqlDcl2qyqOTT0IMwXxJRY9qqiC0Dnb+6Dbo6JkDX7zwdtWGBl810gDJf3RulI1g0kkeYrf2+lIYwtsD5OgcDejXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IuYcpd6r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IuYcpd6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9E21F00A3A;
	Sun,  6 Sep 2026 20:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788727174;
	bh=Pyw2f00IzuR/wdoHha0PCy8FB5rCb1mITkdaXoh+bAI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IuYcpd6r1TKBOcEgHltN49pA3NwxRnmx7qXJy4ahQoP0S49PFv9Pazk6vWir+p+1f
	 n696xQQLmHmGFS2HWGJheP+w7ifCT+QVYnlFKTJaydI91eGrrnGDfKSXrMX7EtgWec
	 qHV9t2XbiGznO2Fu2dbXiU4KzD/IiF0+V7qN33kGAPx/CWAXSUtPtEx4guocFJJ4MT
	 8jKRF+lV30GAWQ878JwyFuMTFP+QaZ1Sze5O2jt18yrrAN07GXtaWk6A1sUFzDS95R
	 rNcbyYn+5yX1Mq0pBJN4lbBw0IMQG5OC4IOtgBBN9uEgmSFzVbN3+Outk788AHFWQS
	 sDYFc1d4MBzsQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: fix nr_msix underflow in
 _base_assign_reply_queues()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ivy Lopez" <skunkolee@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260906202250.53653-1-skunkolee@gmail.com>
References: <20260906202250.53653-1-skunkolee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 06 Sep 2026 20:39:33 +0000
Message-Id: <20260906203934.5E9E21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The newly added safety check `if (!nr_msix)` mathematically fails =
to catch integer underflow, defeating the patch's intent to prevent `nr_msi=
x` wrap-around.

Pre-existing issues:
- [Critical] Missing bounds check and lack of CPU hotplug lock (`cpus_read_=
lock`) allows a TOCTOU race leading to an out-of-bounds array write into `i=
oc->cpu_msix_table`.
- [High] The fallback CPU assignment loop improperly compares a CPU hardwar=
e ID against the aggregate count of online CPUs, terminating assignments pr=
ematurely on sparse CPU topologies.
--

commit 3812fcce12802077745df437d166ca73a78055c3
Author: Ivy Lopez <skunkolee@gmail.com>

scsi: mpt3sas: fix nr_msix underflow in _base_assign_reply_queues()

The commit updates the fallback path to correctly reserve both high-iops and
iopoll queues from the round-robin pool. It also adds a check for zero to
prevent divide-by-zero or unsigned wrap-around when the available MSI-X
vectors are exhausted.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index 1af25a22611a1..df9d7affcd0d1 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -3275,7 +3275,11 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *=
ioc)
> =20
>  fall_back:
>  	cpu =3D cpumask_first(cpu_online_mask);
> -	nr_msix -=3D (ioc->high_iops_queues - iopoll_q_count);
> +	nr_msix -=3D (ioc->high_iops_queues + iopoll_q_count);
> +	if (!nr_msix) {

[Severity: High]
Since nr_msix is an unsigned int, will this subtraction underflow to a mass=
ive
unsigned value if ioc->high_iops_queues + iopoll_q_count is strictly greater
than nr_msix?

If the subtraction wraps around, this check for exactly zero is bypassed,
defeating the patch's intent. This allows the fallback loop to execute with=
 a
massive nr_msix value, which silently breaks CPU affinity grouping.

> +		ioc_warn(ioc, "high_iops_queues and iopoll_q_count exceed available MS=
I-X vectors\n");
> +		return;
> +	}
>  	index =3D 0;
> =20
>  	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {

[ ... ]

Later in drivers/scsi/mpt3sas/mpt3sas_base.c:_base_assign_reply_queues():

> 		if (cpu >=3D nr_cpus)
> 			break;

[Severity: High]
This is a pre-existing issue, but does this check improperly compare a CPU
hardware ID against the aggregate count of online CPUs?

On sparse topologies where CPU hotplugging or VM setups are used, nr_cpus
reflects the total count (e.g. 4), while cpu holds the physical hardware ID
obtained via cpumask_first() and cpumask_next().

If the physical ID reaches 8, this check would cause assignments to termina=
te
prematurely, leaving remaining CPUs defaulting to vector 0.

Further down in drivers/scsi/mpt3sas/mpt3sas_base.c:_base_assign_reply_queu=
es():

> 		for (i =3D 0 ; i < group ; i++) {
> 			ioc->cpu_msix_table[cpu] =3D reply_q->msix_index;
> 			cpu =3D cpumask_next(cpu, cpu_online_mask);
> 		}

[Severity: High]
This is a pre-existing issue, but is there a missing bounds check and lack =
of
CPU hotplug lock (cpus_read_lock) here?

During CPU hotplug, if a CPU is brought online concurrently, cpumask_next()
could return a CPU ID that equals or exceeds the snapshotted
ioc->cpu_msix_table_sz.

Because this inner loop lacks a bounds check, this allows a TOCTOU race that
results in an out-of-bounds array write into ioc->cpu_msix_table and memory
corruption.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260906202250.5365=
3-1-skunkolee@gmail.com?part=3D1
