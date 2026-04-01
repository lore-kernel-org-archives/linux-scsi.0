Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB37D1A6828;
	Wed,  1 Apr 2026 12:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775047792; cv=none; b=qFWt9Ykxf55iPDgZXzPKQdX7oUeR1A33w4yBgnk4uOyq7BKDwDZ2Z5Cz/LdocvmPhKp8Z/a7pK7WPACkolY4ZrSHOHXZytug1/CVbvQFDnmMILdcCxA5CJu3/j6vHCN0YxJAH+7+KZwfN4Tnjw4JvdZwAf7VZao7psrUczBwUWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775047792; c=relaxed/simple;
	bh=XP9atdCCk8+U8bxPV2+5SWG4EjBA7tmxDzurusg8f6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bHoJTKlRDqlE/fVb4gfP+mlWZLAxLL6iRgF0LyHixTR4W8hxuQfeRFp0TTM+VfaT6dQTv8V/BtTw1AxlJa5YCDq9bLblcsSnUfvhQH8QrRc2syv4OAyDaIuYN7J9p0wjEAP+iQ528Rjlj8U/98WExDOgg19yooitVRwFKnQyJPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=tMGD0fM5; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=7XrOgOoK; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="tMGD0fM5";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="7XrOgOoK"
Date: Wed, 1 Apr 2026 14:49:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1775047789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=heh8sartkKNgZ+WLyImAeywZBZ6rowJ27Jlk2mhT55Q=;
	b=tMGD0fM5BtkS7s8cjOH47FMWF3KkLGze4xZtLaWbeCpXHa2kqwWKWYOpKMw//zUuD2iAT2
	83uUeOH9zdrB5jBgSZUCQUgvFA4RQ/ggm0Oal5gSLaVGzrROt/qZO9slTh7wl5IiVDrHIP
	pXAnhsEbkR9qNnrUF6G1CWHLtRWjDeDFjsSdSbyFJSuV4IMmfu6KHN8JvWfX2iRI/SOMIE
	qHq5RU5e/fLzWnuBYCqo1sQjYCTuowGyazTt/s9pER8G866XYw5QouLhjCWXsmpYHn7on5
	JikL7RxLG/Bfw6TWurpZVUlR8ZXlOD1PGFWzkwFcfqezJvWCrHWQubGn78Lkig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1775047789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=heh8sartkKNgZ+WLyImAeywZBZ6rowJ27Jlk2mhT55Q=;
	b=7XrOgOoKRW9yP/eZHYEGzv9pb+kR/oqptIdAFt5MegErsbxzrViWbc6gCXoT8o43/1PW4F
	/EY01dHq/YdviTAQ==
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
	kch@nvidia.com, ming.lei@redhat.com, steve@abita.co, sean@ashe.io,
	chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v9 09/13] isolation: Introduce io_queue isolcpus type
Message-ID: <20260401124947.-d4D5Cr-@linutronix.de>
References: <20260330221047.630206-1-atomlin@atomlin.com>
 <20260330221047.630206-10-atomlin@atomlin.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260330221047.630206-10-atomlin@atomlin.com>

On 2026-03-30 18:10:43 [-0400], Aaron Tomlin wrote:
> From: Daniel Wagner <wagi@kernel.org>
> 
> Multiqueue drivers spread I/O queues across all CPUs for optimal
> performance. However, these drivers are not aware of CPU isolation
> requirements and will distribute queues without considering the isolcpus
> configuration.
> 
> Introduce a new isolcpus mask that allows users to define which CPUs
> should have I/O queues assigned. This is similar to managed_irq, but
> intended for drivers that do not use the managed IRQ infrastructure

I set down and documented the behaviour of managed_irq at
	https://lore.kernel.org/all/20260401110232.ET5RxZfl@linutronix.de/

Could we please clarify whether we want to keep it and this
additionally or if managed_irq could be used instead. This adds another
bit. If networking folks jump in on managed_irqs, would they need to
duplicate this with their net sub flag?

> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
> Signed-off-by: Daniel Wagner <wagi@kernel.org>

Sebastian
