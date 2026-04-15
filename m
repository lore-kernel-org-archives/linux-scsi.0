Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CF53B0AEF;
	Wed, 15 Apr 2026 08:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776242501; cv=none; b=DH2qGQd3k4SX/fmoaKnze38HgLuOIC5/taNM/V/+7LL4+wSHwFxxvOmV1uBJs1uj179xn4/NApI5zBDS3pXjF2/WkWIjHg4RlXovHdJ27PX+I7zJPxkjCc+L6XDPsGoWlKJX4Na66xoFkHWtXrg/NqDTHv+s823U14aRyw0JFdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776242501; c=relaxed/simple;
	bh=VpQXeMzIawrJLZl9CcFL7UYlf5uIJhmNB8PKgPDcGwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WoBvt0tdixTVhqxVrgMwymgQtFODD+cToaNVbOIZEY6skm6Eb2+cmSaYY9sxyYCb+CkSif/pLw/sZUx3K0Mu3CaS70CbVA5Gs9Wl/ZkqgQM0i/juHLPSaViL6J7E+nl5OYIQXrG17NwDybAKsdRzsT5nPBLzEc9Hqs/9V1uJFx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=07EG34Pd; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=5aK9zNFA; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="07EG34Pd";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="5aK9zNFA"
Date: Wed, 15 Apr 2026 10:34:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1776242100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lJvdUxUUPaebZ87OfEcbBiQ0Cb+WI4qRuhXO7Cgjo1w=;
	b=07EG34PdGxTG6ncahJqEGpSFi2vmyg11FXnNJb2fSf1QdcF62LbTQ5VRospF7lcKzVwfux
	e4mYk3YPz8FuePLL6dmn2/8irypzy+9t2fWJN8bWaqRqwd8hNWYAQT8jiL6s5ktoOUfq2/
	wFEnvWw9l3snNypme9XYruxUTinW2EXm14h2PMggUY4o0J9jw7JVcRI+NT3M8DIx85ixWq
	ZIETR2daLhGrPF5yPK9o8bmqXdQJbVLG57O75Us2n0TdiIvkcvmDmuyIqW4uG62eoNW9ww
	P8eGR3UeBYrsErhP+UwykZw2UvY/i/IMqN92LL6Rh9HKmmDi+DRNefdzLuNT/g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1776242100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lJvdUxUUPaebZ87OfEcbBiQ0Cb+WI4qRuhXO7Cgjo1w=;
	b=5aK9zNFAQwnRroDNDQ+XYuEPmdTdVkZP2V2Fgiw8ZMZ9rvNOr2JZaCkXfABWb0rlsw9ZqL
	v/+4GiC2syrrF5Aw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>, Ming Lei <ming.lei@redhat.com>,
	axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
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
	kch@nvidia.com, steve@abita.co, sean@ashe.io, chjohnst@gmail.com,
	neelx@suse.com, mproche@gmail.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
Message-ID: <20260415083458.UD3cF5IQ@linutronix.de>
References: <nxe24ixebb4lm2d5w4aubhtwr23df6mumqd663axj35oswdiyv@amtqhtsidyr4>
 <adMoon3Zf6gO-UbA@fedora>
 <zawhqvn53mcp4wf7axsmuq4cg73upxs5h2zgrfta5dpat3sfy4@zctfbz2ttz5m>
 <CAFj5m9JE5e4DRGbzQFxDdZWU76ZPQ3G+C9JpLu0mhTB6aesZ9g@mail.gmail.com>
 <a566smu6morqeefqal23eek4ibezfuiwhs774xtxhyyclpbtsx@uzzwgbzmwdjd>
 <adhj_w11cpMfeEgN@fedora>
 <dzpxscrhibmi5okkozf5jfull4dcajgpctldvdyfcjgmpeetk5@tkeyqouyabzy>
 <adpD8M8cNu3IZzEL@fedora>
 <6glgsbk2djsz4cqtbp2ht4274dw4rveq6fojlnpnuvx6zmpjxw@i43jo2l4qlz4>
 <ad0Hk48y5JEeMlFk@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ad0Hk48y5JEeMlFk@fedora>

On 2026-04-13 23:11:15 [+0800], Ming Lei wrote:
> > > What matters is that IO won't interrupt isolated CPU.
> > 
> > The isolcpus=managed_irq acts as a "best effort" avoidance algorithm rather
> > than a strict, unbreakable constraint. This is indicated in the proposed
> > changes to Documentation/core-api/irq/managed_irq.rst [1].
> 
> Yes, it is "best effort", but isolated cpu is only take as effective CPU
> for the hw queue's irq iff all others are offline. Which is just fine for typical
> use cases, in which IO isn't submitted from isolated CPU.

Couldn't we tackle this by limiting the number of managed interrupts the
device asks for and then limiting the CPUs it could be bound to?

So if have house keeping CPUs 0/1 and isolated 2-63 then managed_irq= is
futile since it use 64 interrupts and map each to one CPU. Even if the
device supports less it would map them evenly across available CPUs.

If the user wishes to initiate I/O from all CPUs but not be bother by
interrupts we could limit the device to ask for 2 interrupts instead of
64 (with the consequence of more queue sharing) and then limit those two
interrupts to CPU 0 and 1 instead to CPU 0-31 and 32-63 like it would be
now the case.

Wouldn't that be what the io_queue flag tries to do?

> Thanks, 
> Ming

Sebastian
