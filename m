Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6AF1FBC8E
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789094660; cv=none; b=rsoCIcRK1zpCIz5Ejq6QjYzDNFJd/pzP2O43/xCRDZEIl0bIvFLTPMsTlMPQXIcZloD+cdxHddToR+m0bGU4O46Ex3oC5d427NtDPp61ZY1EtdrzgVqIkBPUUCEvwNchgDQZDlvTL93AvYXQzKFV4A5cx4PS4kHeqszAvq4HAYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789094660; c=relaxed/simple;
	bh=5Te4NPC8k87HjjtaoYK7QmI0zePzU3RAMdVtn0A8vgk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=q/KW3zFMMweNn7TPLvP/6jWPn0rXtiNRjyFh3eAjA7oc9179YEWcURb5iHvqk3tRBCxfZ39a+yxtx8u6DSa2R2Touaenpn2HtMsmXNFSzJpz8fN5TbfnVzDyi225biPZlp5CpjjfCVaKt7isc6D3UN25OUe5r60mcYXROdqPda0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kLZskYex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kLZskYex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047191F000FF;
	Fri, 11 Sep 2026 02:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789094659;
	bh=Irsg7xaYwdmV6mrH6oOo/u1vPC0vPP30tHLlXVkgJfM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kLZskYexbF/PMnyAowvpVhhhR9pVckwEA8gFIz0ugp0mOtNROu+m39UFDzc36aLcA
	 GvBmNtE55FtFtDJLw/riLIOX+Ae56leylH4oT6TaDxFCcNYkWp0tzjW+2NKM8CfQ0T
	 +RDxekXionZOQxfGYYP/ASmdK2hV8VLqRnJ0d2uT/vqV8hYoAW2v1f/r8GZMvO9IMf
	 pzLLCHOsU5xQcuCnhqKen1YJgNJJ0hVBHeOmPjJi4smNJMgFd4FnVewRBSZxn9kzdu
	 EqWDrpULdQyB5m2Vi/d6jdecOASVj3xz0nkrN8kl6Gg5QU9/Qnp8ymCKcScl41zKNy
	 ySrcHBl3K+fqQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 5/9] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911021910.1038128-6-tyreld@linux.ibm.com>
References: <20260911021910.1038128-1-tyreld@linux.ibm.com>
 <20260911021910.1038128-6-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:44:18 +0000
Message-Id: <20260911024419.047191F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Missing address-of operator (`&`) when referencing `Scsi_Host`'s `h=
ost_lock`, causing a fatal compilation error.
--

commit af3cb177b633d7c7bd704888c846393f549edaef
Author: Dave Marquardt <davemarq@linux.ibm.com>
Date:   Fri Sep 11 02:19:05 2026 +0000

    scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ

This commit adds an interrupt routine and a draining function for asynchron=
ous
sub-CRQ events. It handles disabling and enabling IRQs to process entries
while holding the queue and host locks.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index daec81f48857d..553fca31cb3aa 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -4376,6 +4376,60 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct =
ibmvfc_queue *scrq)
>  	return crq;
>  }
> =20
> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
> +{
> +	struct ibmvfc_host *vhost =3D scrq->vhost;
> +	unsigned long flags;
> +	struct ibmvfc_crq *crq;
> +	int done =3D 0;
> +
> +	spin_lock_irqsave(vhost->host->host_lock, flags);

[Severity: Low]
Does this code need an address-of operator for host_lock?

Since kernel 5.14, the Scsi_Host's host_lock field is an embedded spinlock_t
struct, so passing it directly to spin_lock_irqsave causes it to be passed
by value. This regression will result in a compilation error because the
lock function expects a pointer to a spinlock_t.

Would it make sense to also update ibmvfc_process_async_work, as well as
ibmvfc_async_fpin_test and ibmvfc_full_fpin_test in the KUnit tests, which
appear to have this same pattern introduced earlier in the series?

> +	spin_lock(scrq->q_lock);
> +	while (!done) {

[ ... ]

> +		} else
> +			done =3D 1;
> +	}
> +	spin_unlock(scrq->q_lock);
> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);

[Severity: Low]
Similar to the lock acquisition above, does spin_unlock_irqrestore also
need an address-of operator to pass a pointer to host_lock?

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911021910.1038=
128-1-tyreld@linux.ibm.com?part=3D5
