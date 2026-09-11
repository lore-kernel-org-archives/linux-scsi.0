Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0653BED27
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789093868; cv=none; b=s63pSZgkxtU1MuPK27nb+P4M0HIDxamNeiPhX06UcmZw0layLquQn2PH7VTExr7qNQSZ1Gg/Y24300opApmMXufK61fuQAqs9LECdZJxoQM2ojxDsgdPskzUdw1DDu7AkBgE64otkZ2Jiude2p7qSZly9m5pbIwcJMwbU8oM8Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789093868; c=relaxed/simple;
	bh=I4jMBO7/g/eq4+OexJlZwMqPLdVeNl8/hT5xIg/OIns=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OOjEhFLszX2c5DAnkY53CH79xyEYfFDdjgp9sqbAce5YWIR8iF3HkoHAWjA3kYz41S19r79fFMmkK6TS1SVBHkTxBDI5IIlaWtQxBshVn4K/RczP7QVowZclyLyPWYaUcciQij0OvVcRRbqZvboTc0KDA1+Splb2qGceNEUpFbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NNrQf2LI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NNrQf2LI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EE71F00893;
	Fri, 11 Sep 2026 02:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789093867;
	bh=BbRZ5BOW3X6iDOYUMWLpX5Anna2VMce/4L4ub1XAQXA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NNrQf2LI8ATIe7rPC9J1VQSP3eMBcleNYc7L/thUvYp/iv8/NZLS1oxLtSWpsKvXu
	 HvXJIEz6LcLbSAeR1Qd+rnVIN/Ydazce8nVWpd4jYvcF6vsDfjDEYaAKVxNWXLviDd
	 rbHB3zwBYRJY/ITjnS0jydGyVUf0xe6V4XVO/WyC9J0IE/tyOpcR9BgP4sDT4tyF2/
	 Spm4nrFGtQuvlN6HvCa6QiR+L6CzWQ875WLrUon/sFICKnFhHSzT9xjOqlVRLWAXGb
	 mJHOPWyohz3e9wV+4FFcH6Zy+MP2QLSyzEPGfOUmcJKly6/B9EcC/KPMorsmqdRmRk
	 CTBYQRatQZKAQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 5/9] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911020817.1033789-5-tyreld@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260911020817.1033789-5-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:31:06 +0000
Message-Id: <20260911023107.12EE71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Missing ampersand (`&`) before `vhost->host->host_lock` in `spin_lo=
ck_irqsave` and `spin_unlock_irqrestore` calls.
--

commit cd128234f59fb01f2631d2a91579282cbf2d281b
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ

This commit introduces an interrupt handler and a draining routine for
asynchronous sub-CRQ events from the adapter. The handler consumes pending
entries before re-enabling interrupts and checks for newly arrived entries
to close any races.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index daec81f48857d..553fca31cb3aa 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -4376,6 +4376,60 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct =
ibmvfc_queue *scrq)
[ ... ]
> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
> +{
> +	struct ibmvfc_host *vhost =3D scrq->vhost;
> +	unsigned long flags;
> +	struct ibmvfc_crq *crq;
> +	int done =3D 0;
> +
> +	spin_lock_irqsave(vhost->host->host_lock, flags);

[Severity: Low]
Does this cause a compilation error? In modern kernels, host_lock within=20
Scsi_Host is embedded as a spinlock_t rather than a pointer. Passing it by=
=20
value to spin_lock_irqsave without the & address-of operator causes a stric=
t=20
type mismatch.

[ ... ]
> +			crq->valid =3D 0;
> +			wmb();	/* complete write */
> +		} else
> +			done =3D 1;
> +	}
> +	spin_unlock(scrq->q_lock);
> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);

[Severity: Low]
Is the & address-of operator also missing here before vhost->host->host_loc=
k=20
for spin_unlock_irqrestore?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-ibmvfc-fpi=
n-support-v8-0-b27183b055af@linux.ibm.com?part=3D5
