Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723E9235C01;
	Thu,  2 Apr 2026 07:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775116695; cv=none; b=XcFU43zjnPlDoL63xUsTxEAOe0K/LfEuyGfbMYBp68skpgQ7boWbhtU29KJURvjEnxqz8/3CgOKperW3ubbs9XtUJsG6K9a28yvB26O/Pblv6hEu8fIGwGOQWDXEBqc3l0GWWGvgAp9v955SpNnl8c9Qz9dyaAqT76c2bF6Sowg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775116695; c=relaxed/simple;
	bh=vHibcFiXOv8GrYg6f/bqFV+bVmQHYs2HrK6rxD8gKiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJJDPIsoQj65HEVmkL+LVgNjlYH8/sMdDQmV9M8Q6UtHmD+JYJMN6UgBL5MZ7U6v4I6qDGZGKeuSYp9adp6rZsoI/ZoTRvhZZPsyReN+JZPqSea66cKiim7iM7/Ie5dpf/+ppOAyIe1cIesrKjf7bO3WM2KrGp58J2WGwohtrMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=2VGbfWPi; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=RCSzIAOv; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="2VGbfWPi";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="RCSzIAOv"
Date: Thu, 2 Apr 2026 09:58:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1775116692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ds3u4+6LAQIo5JXRSrJAOTU+FbNVAjarQWEAuaA6KI=;
	b=2VGbfWPiuvIl7w8Nm7Vgl/McrfOt8PG119L5zLfE6KMnhE2hHWKESbQsFDcFTHLjuYKwQS
	Wi1quhUFsXmA4k/me9cksXxi4JcuROmE6HgQDaBYkaqnq0Wb1wJZsxYt4qjmJ1hGTZJ8I7
	8jpOs1/qSDlEVPLNCtXPo3bEM33sh4phWlQMT44Hcq3W6TyjRH5pOpeWOTdLYAhOK0zcNy
	k+1v8X7OjaUweZYskkitoDEBSEPqj52PBfX6Xlh1DV1LziwRpHiyHBa8uWdfkyXvjb4/fJ
	e0RUpvyouMdKCc93cNwUHYKHlGIgHDtjMpicuVtsTfY1BIxq8Y97/kuZAonMrw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1775116692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ds3u4+6LAQIo5JXRSrJAOTU+FbNVAjarQWEAuaA6KI=;
	b=RCSzIAOvGwKMDpOL3oHmxXQbRFkbngSE2GOk9Z6lL7gUflAeNOI03DkohbZb4f4Y/KLJvz
	vCwwY7N6gwweLsDw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Waiman Long <longman@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>, axboe@kernel.dk, kbusch@kernel.org,
	hch@lst.de, sagi@grimberg.me, mst@redhat.com, aacraid@microsemi.com,
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
	chenridong@huawei.com, hare@suse.de, kch@nvidia.com,
	ming.lei@redhat.com, steve@abita.co, sean@ashe.io,
	chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v9 09/13] isolation: Introduce io_queue isolcpus type
Message-ID: <20260402075810.w0GVbX0Z@linutronix.de>
References: <20260330221047.630206-1-atomlin@atomlin.com>
 <20260330221047.630206-10-atomlin@atomlin.com>
 <20260401124947.-d4D5Cr-@linutronix.de>
 <5e6aa61e-0ad0-4027-bba9-cd906ab0d7e8@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5e6aa61e-0ad0-4027-bba9-cd906ab0d7e8@redhat.com>

On 2026-04-01 15:05:21 [-0400], Waiman Long wrote:
> > Could we please clarify whether we want to keep it and this
> > additionally or if managed_irq could be used instead. This adds another
> > bit. If networking folks jump in on managed_irqs, would they need to
> > duplicate this with their net sub flag?
> 
> Yes, I will very much prefer to reuse an existing HK cpumask like
> managed_irqs for this purpose, if possible, rather than adding another
> cpumask that we need to manage. Note that we are in the process of making
> these housekeeping cpumasks modifiable at run time in the near future.

Now if you want to change it at run time, it would mean to reconfigure
the interrupts, device and so on. Not sure if this useful _or_ if it
would be "easier" to just the tell upper layer (block in case of I/O)
not to perform any request on this CPU. Then we would have an interrupt
on that CPU but it wouldn't do anything.
It would only become a problem if you would have less queues than CPUs
and you would like to migrate things.

> Cheers,
> Longman

Sebastian
