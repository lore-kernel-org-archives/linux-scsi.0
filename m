Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE432F39B5
	for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2026 02:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775789077; cv=none; b=O+LoWeshLoKUsYXd/I32Z41haO63JhNDW4Le0TlZE5sTDLog35UEZI73v0JJItl8c2MwLjt6dTJIi04CZ5AKjY8ESMXkhaDU1yU4vFV4GxXXY4D4tbfwPuA4DtSkyeRLkZelntbgGrSX0eAyx5pOQDYI7VLpeVUH6voZnd9kJyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775789077; c=relaxed/simple;
	bh=TPe+unbB39v2p3g34Bl3H0+CW+J9BRBNX3aGbJ25L2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mnwYeAsW+JWBz9Uf6abYPHeyIxgilQfzaGubnMbxM3F/hbcs8RqSClDNiUWvrfWgjurh/arhez6MBR0ik7SB/ep59yKF2IEItJAqSFREgtlc0uPUtzHta9XbxxW7HaOUjL1IaKK3tdcDHlC17zeKWWFHHY+uWymILWD3d3HYhLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g0XP0+bz; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0XP0+bz"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35d9c7bf9a1so1584501a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Apr 2026 19:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775789076; x=1776393876; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Y42v4l6XRa4Mc3bL0tysYnB0VcDZSP2r5rXfsoOeKc=;
        b=g0XP0+bzuy61RG2po8R5vKlOVHv0clDoj+/ZwgrwwhS5pTdXq7pp4VzEgx3zXuVbe7
         U8PvcoAAZen6o/8ywrK92mvNm9ZXBxsYkJxLrDnPeU6rZ4ChWa3PiZcFdatcBIsibaY1
         E33AdtHTG7ymxjzMmM0VscfhAsYirikwyqWue0nkjnYzPmILu6M9EOUuLqbE82pVPqOB
         aCuLOv2ya6ht1QllIPYGLwLiby/g6mOvgj2+/hCnKLh+P0hy0gdgKRWJ+FDnidAPWNBO
         yP+cHdKsRRX558uHciNLl/hMrkZXGA345cRxxOOx+H89FixUOwmXgQqeK8x6bsm2v8Oh
         l/2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775789076; x=1776393876;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Y42v4l6XRa4Mc3bL0tysYnB0VcDZSP2r5rXfsoOeKc=;
        b=iz/2j8UaFzp1I0/ff+Vd2pYgKLgD8AvgKBI66qvtMYY5FZ/JnJfO1VaCs+boM7j2Nm
         CkZsoeLRuXz/f0mD1J9PnbxWo3INg5W1uJjthP4JD+T75dJa+5YemSD3/CFTGlG2MS9y
         2LaxZaAEwENVM69UCidgQZfOUlNWyWb4PaVdrcxEatsK5Nq9t2qH8q4vim0fXbutI3np
         F1oq/t/cRjYs3SQGh4lyIJLnTdj7/PWdspWQdrs/xhkxW1RKmIhJ4hIZhZi9YmXWErEx
         QTk7oz76KUREDgZMeCmxwaEcNkfAX0PRkvnbb3Ezz0Pisj7agesRRhs/8ZDsdK326hzJ
         s02g==
X-Forwarded-Encrypted: i=1; AJvYcCWF2Xp8C90qfRx8Y1j7g9GRJswd6SiNUVArBoUf5ktk+e6DmJgWu7nLFTOzYHAJkue9YXcx39sj/QVP@vger.kernel.org
X-Gm-Message-State: AOJu0YzJwSlYmuJcBCIb8SfLnTD3gsPlBtjTJhLDBllUvNqJihiAdYil
	ZAV0se1Wfh0PYhNVfoOk6i+oDzeA2YMvDtiBQzCG7dWVlZx2lnb+4awU
X-Gm-Gg: AeBDieum0qn+nh+1iFGrqICUxgx9t4yLPS1qNu4KO0Bx6X1zYC0cpuNMqakN3wgSSPV
	uX5q1M0r8V04XLwOXmFbD4cX3beoi5XbNyA/LtH5a9AQGlOA99s0fg4TMSLhaMltQPIF7V/YXPZ
	MDVpts4Y4h7+5jo9ELLFMbAz+PsMdG4VT4iboNuTQoUNMppPuq3p86XmymwLx7Iyhk5TKpS+/nG
	yKgNTsvpl+GPNByXL3hQxiaTgWHp9K0Ez8MKvS77NHvPwSjLVvG4e1H79+MCqb2qYQpplXqR45t
	Q4ZwgnNxa2WrQZBpujyRlYYimQlWAO414gXKtiJl7Ao+M4NC8yyCJ7uOCuybKrfMb5plEDDvQHs
	mmZoRMmVbKHTdHop4v4t0AhEWxuoGf61l21rjzJKKxCxFFjUssPQXzxbyw+D07lZGRFieTZI/cP
	zLmmkGQmLbROVcpTRhC/A0fG4bVP3v6DIDCZKE3b2fki3CMYvJtZFm
X-Received: by 2002:a17:90a:e7ca:b0:359:974a:3d65 with SMTP id 98e67ed59e1d1-35e4285280dmr1485690a91.16.1775789075530;
        Thu, 09 Apr 2026 19:44:35 -0700 (PDT)
Received: from fedora ([2001:250:3c1e:503:ffff:ffff:74aa:4903])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e35156445sm4526177a91.14.2026.04.09.19.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 19:44:34 -0700 (PDT)
Date: Fri, 10 Apr 2026 10:44:15 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: Ming Lei <ming.lei@redhat.com>, axboe@kernel.dk, kbusch@kernel.org,
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
	bigeasy@linutronix.de, yphbchou0911@gmail.com, wagi@kernel.org,
	frederic@kernel.org, longman@redhat.com, chenridong@huawei.com,
	hare@suse.de, kch@nvidia.com, steve@abita.co, sean@ashe.io,
	chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
Message-ID: <adhj_w11cpMfeEgN@fedora>
References: <20260401222312.772334-1-atomlin@atomlin.com>
 <20260401222312.772334-14-atomlin@atomlin.com>
 <ac8l-w8ERG1YN2Wm@fedora>
 <nxe24ixebb4lm2d5w4aubhtwr23df6mumqd663axj35oswdiyv@amtqhtsidyr4>
 <adMoon3Zf6gO-UbA@fedora>
 <zawhqvn53mcp4wf7axsmuq4cg73upxs5h2zgrfta5dpat3sfy4@zctfbz2ttz5m>
 <CAFj5m9JE5e4DRGbzQFxDdZWU76ZPQ3G+C9JpLu0mhTB6aesZ9g@mail.gmail.com>
 <a566smu6morqeefqal23eek4ibezfuiwhs774xtxhyyclpbtsx@uzzwgbzmwdjd>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a566smu6morqeefqal23eek4ibezfuiwhs774xtxhyyclpbtsx@uzzwgbzmwdjd>

On Thu, Apr 09, 2026 at 09:45:04PM -0400, Aaron Tomlin wrote:
> On Thu, Apr 09, 2026 at 11:00:09PM +0800, Ming Lei wrote:
> > How can the isolated core be scheduled for running polling task?
> > 
> > Who triggered it?
> > 
> > > loop waiting for the hardware completion. This would completely monopolise
> > > the core and destroy any real time isolation guarantees without the user
> > > space application ever having requested it.
> > 
> > No.
> > 
> > IOPOLL queue doesn't have interrupt, and the ->poll() is only run from
> > the submission context.  So if you don't submitted polled IO on isolated
> > CPU cores, everything is just fine.  This is simpler than irq IO actually.
> 
> Yes, you are entirely correct. The ->iopoll() is indeed executed strictly
> within the submission context. In the example below, the file operations
> iopoll callback is iocb_bio_iopoll():
> 
>       // file->f_op->iopoll(&rw->kiocb, iob, poll_flags)
>       iocb_bio_iopoll(&rw->kiocb, iob, poll_flags)
>       {
>         struct bio *bio
> 
>         bio = READ_ONCE(kiocb->private)
>         if (bio)
>           bio_poll(bio, iob, flags)
>             if (queue_is_mq(q))
>               blk_mq_poll(q, cookie, iob, flags)
>               {
>                 if (!blk_mq_can_poll(q))
>                   return 0
> 
>                 blk_hctx_poll(q, q->queue_hw_ctx[cookie], iob, flags)
>                 {
>                     int ret
> 
>                     do {
>                         ret = q->mq_ops->poll(hctx, iob)
>                         if (ret > 0)
>                             return ret
>                         if (task_sigpending(current))
>                             return 1
>                         if (ret < 0 || (flags & BLK_POLL_ONESHOT))
>                             break
>                         cpu_relax()
>                     } while (!need_resched())
> 
>                     return 0
>                 }
>               }
> 
> If an application on an isolated CPU does not explicitly submit a polled
> I/O request, it will not poll. Thank you for correcting me on this.

Great, you finally get the point.

> 
> > Can you share one example in which managed irq can't address?
> 
> Without io_queue, the block layer maps isolated CPUs to these queues, and
> the device will fire unmanaged interrupts that can freely land on isolated

For unmanaged interrupts, user can set irq affinity on housekeeping cpus
from /proc or kernel command line.

Why is unmanaged interrupts involved with this patchset?

> CPUs, thereby breaking isolation. By applying the constraint via io_queue
> at the block layer, we restrict the hardware queue count and map the
> isolated CPUs to the housekeeping queues, ensuring isolation is maintained
> regardless of whether the driver uses managed interrupts.
> 
> Does the above help?

As I mentioned, managed irq already covers it:

- typically application submits IO from housekeeping CPUs, which is mapped
  to one hardware, which effective interrupt affinity excludes isolated
  CPUs if possible.

I'd suggest to share some real problems you found instead of something
imaginary.

> 
> > > >
> > > > IMO, only two differences from this viewpoint:
> > > >
> > > > 1) `io_queue` may reduce nr_hw_queues
> > > >
> > > > 2) when application submits IO from isolated CPUs, `io_queue` can complete
> > > > IO from housekeeping CPUs.
> > >
> > > Acknowledged.
> > 
> > Are there other major differences besides the two mentioned above?
> 
> I believe the above is sufficient. Please let me know your thoughts.

Both two are small improvement, not bug fixes. However the user has to pay
the cost of potential failing of offlining CPU. Not mention the little 
complicated change: `19 files changed, 378 insertions(+), 48 deletions(-)`

But I won't object if you can update the commit log/kernel command line
doc and fix the issue found in review.

Thanks,
Ming
