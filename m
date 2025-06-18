Received: from mail-4323.protonmail.ch (mail-4323.protonmail.ch [185.70.43.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658E42ECD3C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 15:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750262010; cv=none; b=SCeK7usWfJgp42r1gyZAwM3cu6XD63vRpRPcFxUFg1fY91jVoOVPNKIvu4rULI3GNB5tZl0NuWSBIo6myfa7LHdy521u9eKzAlY4kBc2Q8nH8OKKcE//IgyGVpXnBD0ty/QBjIL8ONTraQFtSRFw2cwUEjD1mUueiaJcxd5RZKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750262010; c=relaxed/simple;
	bh=Q4ysobOWzq7SWoKTpz/A+Q8dxWKH9jgcSDv/9owfVEY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WPbMiLhxgiJDjON1IvUPV1HjVNXgAimc6xqaMU0/YQXpV47elggZIjrFUvJKULr/Z3Z7XFKejLx/O5wdqdFAkWzNsy+laseThHMyh9mecYZMSc22PYXU11KLIhWu4yC4cf6qVB7kQlEwUOwM3p0veh4JZLfgfjFJrRni1JVG2oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ashe.io; spf=pass smtp.mailfrom=ashe.io; dkim=pass (2048-bit key) header.d=ashe.io header.i=@ashe.io header.b=dzbdvzLc; arc=none smtp.client-ip=185.70.43.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ashe.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ashe.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ashe.io header.i=@ashe.io header.b="dzbdvzLc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ashe.io;
	s=protonmail2; t=1750261998; x=1750521198;
	bh=Q4ysobOWzq7SWoKTpz/A+Q8dxWKH9jgcSDv/9owfVEY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=dzbdvzLcMNeaiQatOkOV86hrhGQN8D+Fu3kYgCWmjEX87gjo1ulsoLjgDOycuJdwY
	 KUbCng5/WE12J4j42ljNFo8WTIMFFBJB/Jc3i0a3/Emp00vZRomoYDnn3ewHcn0fBx
	 jtjIl7wxiS2lgZVvmPRIcnGjaktXQ4iMHk9SR5676P+BZKZGP8P49KJR4zU7C1KZfV
	 0Madmqa0l3/uoVnMEHr9yTf//jtTit9Xh/StR3ttS0piMTmrY3B9t8ut6gVNKY4tbb
	 QxWBqZBDPd/i22oX/hyioFl9balk6v9vBuxgEs0Vqjhu3EUv5GtsKMksOj3lsXy41U
	 JfwI2FL1Z05Aw==
Date: Wed, 18 Jun 2025 15:53:12 +0000
To: John Garry <john.g.garry@oracle.com>
From: "Sean A." <sean@ashe.io>
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>, "atomlin@atomlin.com" <atomlin@atomlin.com>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>, "sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>
Subject: Re: [RFC PATCH v2 1/1] scsi: mpi3mr: Introduce smp_affinity_enable module parameter
Message-ID: <mEiqrmv9bhO2K6CATsFiUM9mMKO22lOoCxD6l8knZlI2J_qqWeTsHfNvNHW136tO0kY2fdPvGHTNL3Mu58mzS1rahajdiyvP6d2btDPLJxc=@ashe.io>
In-Reply-To: <077ffc15-f949-41d4-a13b-4949990ba830@oracle.com>
References: <1xjYfSjJndOlG0Uro2jPuAmIrfqi5AVbfpFeWh7RfLfzqqH9u8ePoqgaP32ElXrGyOB47UvesV_Y2ypmM3cZtWit2EPnV3aj6i9w_DMo1eI=@ashe.io> <077ffc15-f949-41d4-a13b-4949990ba830@oracle.com>
Feedback-ID: 119619660:user:proton
X-Pm-Message-ID: 95dd3edeab06a8c3d3f3fd986d54b984fdb78e59
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Thank you, we'll certainly look into rq_affinity. We do isolate with manage=
d_irq, so I did not expect to see these spanning the isolated core set.

Every other driver we use honors isolation+managed_irq, or exposes tunables=
 (as proposed in parent) to afford some control over these behaviors for pe=
ople like us. I realize we are in the minority here; there is tangible impa=
ct to our sort of business from an increase in interrupt rates on critical =
cores across a population of machines at scale. It would be good to know if=
 this was a conscious decision by the maintainers to prioritize their contr=
oller's performance or a simple omission so that we can decide whether to c=
ontinue pursuing this vs researching other [vendor] options.
SA

On Wednesday, June 18th, 2025 at 2:49 AM, John Garry <john.g.garry@oracle.c=
om> wrote:

>=20
>=20
> On 17/06/2025 17:34, Sean A. wrote:
>=20
> > Le 17 Jun 2025, John Garry a =C3=A9crit :
> >=20
> > > You have given no substantial motivation for this change
> >=20
> > From my perspective, workloads exist (defense, telecom, finance, RT etc=
) that prefer not to be interrupted and developers may opt to utilize CPU i=
solation and other mechanisms to reduce the likelihood of being pre-empted,=
 evicted, etc. This includes steering interrupts away from an isolated set =
of cores. Also while this doesn't result from any actual benchmarking, it w=
ould seem that forcing your way on to every core in a 192 core system and r=
efusing to move might be needlessly greedy or even detrimental to performan=
ce if most of the core set is NUMA-foreign to the storage controller. One s=
hould be able to make placement decisions to protect app threads from inter=
ruption and to ensure the interrupt handler has a sleepy, local core to pla=
y with without lighting up a bunch of interconnect paths on the way.
> >=20
> > Generically, I believe interfaces like /proc/$pid/smp_affinity[_list] s=
hould be allowed to work as expected, and things like irqbalance should als=
o be able to do their jobs unless there's a good (documented) reason they s=
hould not.
>=20
>=20
> There is a good reason. Some of these storage controllers have hundreds
> of MSI-Xs - typically one per CPU. If you offline CPUs, those interrupts
> need to be migrated to target other CPUs. And for architectures like
> x86, CPUs can only handle a finite and relatively modest amount of
> interrupts (being targeted). That is why managed interrupts are used
> (which this module parameter would disable for this controller).
>=20
> BTW, if you use taskset to set the affinity of a process and ensure that
> /sys/block/xxx/queue/rq_affinity is set so that we complete on same CPU
> as submitted, then I thought that this would ensure that interrupts are
> not bothering other CPUs.
