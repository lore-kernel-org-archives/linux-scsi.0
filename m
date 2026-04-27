Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396BB33F8AD;
	Mon, 27 Apr 2026 15:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777304061; cv=none; b=jRWPcqBbY5BuVNu6j1t1BVaR383NaFcTlIGnaN/XywZv8pUGoHkp7hdsfepht4YaKUj955gYMYD3hroSVDNIFCm4qhRDbCGsxNCtzsN8KOk0ZfGpCQqe/gRFOyeFSqiWQyJ5mXwDxt121FMWmAJNcSHejMcg82i/aOeq774fUQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777304061; c=relaxed/simple;
	bh=DBrzjD58zwiSSp3rrazy1da2LaxjT8/v/qQOT7QVvCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXaoJGi6YN4/yTDBLoRqyiLU/0pdz2ALix3AAsvhTAbYK8I+oPqu4Jy71eDWZmbqyfa4anNNc+62ri0NaxKHOZsY4wwtD3sHpC33CweNTJ7Yb9AcdOO33wu/Wx9gZr3O0InH8YdUKH9SSdlnuubzwpOw8nn9s7qRKwMvZMPRdKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=RRNMynj1; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=aUDQhXJ3; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="RRNMynj1";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="aUDQhXJ3"
Date: Mon, 27 Apr 2026 17:34:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1777304058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FLa6eYHbGlETXhdKZQov353z3h7xOJzxZI3VwyPyfVI=;
	b=RRNMynj1Qa0/ZFxqoprrF+lV+59v57PURMlHWXd5zVKQ/++xbkIPxKBPjeEs8yH6/38KK3
	t9BTF92ohu2bpe7aiZh7Y02xPEG8gBZtQsTNa95rtMtb9z1rGNWO4RNTOmBfqDrmP4RbS7
	F4gucu6e/dQh0V3DJWL0rg1aP1taN51+lmDOG+CaWQp+io9qKXLZ7Zxk4AGZVvW3XvfMzk
	wYKkbHSGRljgM5sXqXCUCQv5DYoBhATNtlDCupF/OVXjX9f18HkkaEGSKAh2NgGAvuOXgD
	ANAb4BjEBVZMhG/LsmITYW7vyL4LxHaLjROA+oF/LBESKOQIGCp3jMeRb8QFUQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1777304058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FLa6eYHbGlETXhdKZQov353z3h7xOJzxZI3VwyPyfVI=;
	b=aUDQhXJ3cDmA67FdQhP07NpAltG1Pvtpl4MeIYhK8VnCGsvxRPIVhTmJ/QINy4t75BK9B4
	OwA4EIuBM99DVGAQ==
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
Subject: Re: [PATCH v12 05/13] blk-mq: add
 blk_mq_{online|possible}_queue_affinity
Message-ID: <20260427153416.MeVS8yxF@linutronix.de>
References: <20260422185215.100929-1-atomlin@atomlin.com>
 <20260422185215.100929-6-atomlin@atomlin.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260422185215.100929-6-atomlin@atomlin.com>

On 2026-04-22 14:52:07 [-0400], Aaron Tomlin wrote:
> From: Daniel Wagner <wagi@kernel.org>
> 
> Introduce blk_mq_{online|possible}_queue_affinity, which returns the
> queue-to-CPU mapping constraints defined by the block layer. This allows
> other subsystems (e.g., IRQ affinity setup) to respect block layer
> requirements.
> 
> It is necessary to provide versions for both the online and possible CPU
> masks because some drivers want to spread their I/O queues only across
> online CPUs, while others prefer to use all possible CPUs. And the mask
> used needs to match with the number of queues requested
> (see blk_num_{online|possible}_queues).

Which driver uses cpu_possible_mask? This mask is assigned at boot time
once the kernel figured how many CPUs are possible based on ACPI or
whatever the system uses. This mask does not change.

I only see drivers/scsi/lpfc/lpfc_init.c using it. Looking at
cpu_possible_mask might not be the right thing. It is usually the same
thing as "online" except on system where ACPI thinks that something
could be added via hotplug _or_ if the admin shuts down a CPU via
cpuhotplug _or_ boots with less (there a command line option for that). 

In case cpu_possible_mask != cpu_online_mask the intention is to
allocate memory and setup irqs for the offline CPUs?

> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>

Sebastian
