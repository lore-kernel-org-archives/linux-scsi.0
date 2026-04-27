Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F532857C1;
	Mon, 27 Apr 2026 15:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777303271; cv=none; b=egSvH8ZvIzwjTJ/xASPnK0D8yAgbaJVpsgkJx5F4EnfmOpH8OFWft6XdqcDNLbE09YmK0OCLBbOyZ4zr8WPsrLFywI4wkN9qee/YUOnmVancE10a6G83dqLLPx91d7gATQBnXZNyJmeNCeCCnzPqdO04dgBy9q3545beQaKHh34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777303271; c=relaxed/simple;
	bh=IM0L7Li42Io9EO72Qgi+hTcf6CviEJZMT8JzJOnRHac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uqUoy1fWUTpJpIGo71llRid4OSsKE8Wneu2jqFpytOg8CUn/QeZ5OkWH+7BO26R57zlOWovDC3VYY1v6YizbN2mv6pzQjQ/bZu+5R0YWESlsxXF9vEewBylD0mWWcCPw8k83tYg6NenYONBF4wTyu+2B8NrRCNS4V6Vdk74Uhtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=d2odqkFT; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ddMw9PoH; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="d2odqkFT";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ddMw9PoH"
Date: Mon, 27 Apr 2026 17:21:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1777303266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HLQrFz5Io0HWrBbPfgkDM3Mh0/GOTFIXHrUB8jjZJ7o=;
	b=d2odqkFTtOfYMHI6l11Y5qQhA/SgclKDt28mdbZOL4QKwSBMCsVWgOaXpb+D3OD1S8sCMl
	gp67+l5XCzoRpQ/3oTRyD21Y36dD3Ub7qcGdki+5UEcfdd62f9B02S/9uDFtQdFWWSGZWN
	m4B9082FAFULSmXJfIGO4UYhh3NWiLHCIjdx2zNx9eCwuuXgUxx0gol0tfTWFMJuxsM78X
	g1PWOd8cwwJy/dtYhZ9H5KOuEKSu+8d/Eeg6qig54XYbdQXI+ISOcg+7AeXpaIos6slIIq
	Z0El3jx8p/AjP60KN5+rLkoBMz0Qn8ba3qWJhW0QGjK2ez776mOM8enhTVEQmg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1777303266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HLQrFz5Io0HWrBbPfgkDM3Mh0/GOTFIXHrUB8jjZJ7o=;
	b=ddMw9PoHj38WUcP0Ahe1qRnWtNk7mF4VE4gCD/um/VTkXCw0TKFpzNLUdzZPWOOEnsfhdo
	qsix0uECSoYIa/Bg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	mst@redhat.com, aacraid@microsemi.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	liyihang9@h-partners.com, kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com,
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com,
	yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org,
	longman@redhat.com, chenridong@huawei.com, hare@suse.de,
	kch@nvidia.com, ming.lei@redhat.com, tom.leiming@gmail.com,
	steve@abita.co, sean@ashe.io, chjohnst@gmail.com, neelx@suse.com,
	mproche@gmail.com, nick.lange@gmail.com, marco.crivellari@suse.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v12 02/13] lib/group_cpus: remove dead !SMP code
Message-ID: <20260427152104.WTGAesGs@linutronix.de>
References: <20260422185215.100929-1-atomlin@atomlin.com>
 <20260422185215.100929-3-atomlin@atomlin.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260422185215.100929-3-atomlin@atomlin.com>

On 2026-04-22 14:52:04 [-0400], Aaron Tomlin wrote:
> From: Daniel Wagner <wagi@kernel.org>
> 
> The support for the !SMP configuration has been removed from the core by
> commit cac5cefbade9 ("sched/smp: Make SMP unconditional").
> 
> While one can technically still compile a uniprocessor kernel, the core
> scheduler now mandates SMP unconditionally, rendering this particular
> !SMP fallback handling redundant. Therefore, remove the #ifdef CONFIG_SMP
> guards and the fallback logic.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> [atomlin: Updated commit message to clarify !SMP removal context]

This look unchanged vs previous submission. You could explain why you
want to remove the !SMP case. It looks like the !SMP makes things
easier ;) I don't know how much of this gets removed because of !SMP
code elsewhere.

The description still does not make sense/ is accurate.

> Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
> ---
>  lib/group_cpus.c | 20 --------------------
>  1 file changed, 20 deletions(-)
> 
> diff --git a/lib/group_cpus.c b/lib/group_cpus.c
> index e6e18d7a49bb..b8d54398f88a 100644
> --- a/lib/group_cpus.c
> +++ b/lib/group_cpus.c
> @@ -9,8 +9,6 @@
>  #include <linux/sort.h>
>  #include <linux/group_cpus.h>
>  
> -#ifdef CONFIG_SMP
> -
>  static void grp_spread_init_one(struct cpumask *irqmsk, struct cpumask *nmsk,
>  				unsigned int cpus_per_grp)
>  {
> @@ -564,22 +562,4 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
>  	*nummasks = min(nr_present + nr_others, numgrps);
>  	return masks;
>  }
> -#else /* CONFIG_SMP */
> -struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
> -{
> -	struct cpumask *masks;
> -
> -	if (numgrps == 0)
> -		return NULL;
> -
> -	masks = kzalloc_objs(*masks, numgrps);
> -	if (!masks)
> -		return NULL;
> -
> -	/* assign all CPUs(cpu 0) to the 1st group only */
> -	cpumask_copy(&masks[0], cpu_possible_mask);
> -	*nummasks = 1;
> -	return masks;
> -}
> -#endif /* CONFIG_SMP */
>  EXPORT_SYMBOL_GPL(group_cpus_evenly);

Sebastian
