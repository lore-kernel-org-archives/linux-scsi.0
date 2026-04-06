Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0791629405
	for <linux-scsi@vger.kernel.org>; Mon,  6 Apr 2026 03:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775446223; cv=none; b=cTbeEiqj/iCel/qVZvOJypZqclCdMHyo9KemPMpnXcwXBC950spMNcYXj76wP76zUb1e+KjK4OBb4Z9ZjL3vBb2mvTjHapY5eOnGxHXDqrSTnAvUR9bIWMmj10TNwGgQ9mtgSu+ENXN7C7Xr3Ue59MLJle5nuH2VW/IqnkJ39DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775446223; c=relaxed/simple;
	bh=NonUutwAo/zhYBxlpgdl1iESm3QtQQCqjHDdu1G1nYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T/fCZ0ZjhmN8ABN7bSASbYZEpC/6k3ma2Y8mi5i0dQvTCaQw5XxI6SL1iCtNIP8JlCOSIsiCOoihwmnW2C1EDuyySRMe8lFjY/Uqn0sasNk3bOhQUw92I96yUc5WIysoJHD4efzUPWMV4tNlwnPYTTXf+6Bl6w5tQntHHPgE8WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qu6Nh7Qp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qu6Nh7Qp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775446221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QMs4B+i4gWp0fPDDgUUvzkKR5xdCLJxCya7S4/Pg2oI=;
	b=Qu6Nh7QpJcin0R+KT+x5cUWX4OXVDChOY/XYTYse7cGudJ/uy8FXxW6azrtuC9yWw1zUac
	uXLcEJPUH1NCh6zPTrwnuzkFnxdgmNU50J5JF9l1vR3qmVxHv0W2OAcEqubE2aEJU1WcMH
	fcuG2q0vxfGFqxNi7tGgmnxcIS/bbFI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-WT4xYZ7RM_SDhcbZJXQjhA-1; Sun,
 05 Apr 2026 23:30:16 -0400
X-MC-Unique: WT4xYZ7RM_SDhcbZJXQjhA-1
X-Mimecast-MFC-AGG-ID: WT4xYZ7RM_SDhcbZJXQjhA_1775446212
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B3B11956080;
	Mon,  6 Apr 2026 03:30:09 +0000 (UTC)
Received: from fedora (unknown [10.72.116.2])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3FED1800576;
	Mon,  6 Apr 2026 03:29:43 +0000 (UTC)
Date: Mon, 6 Apr 2026 11:29:38 +0800
From: Ming Lei <ming.lei@redhat.com>
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
	bigeasy@linutronix.de, yphbchou0911@gmail.com, wagi@kernel.org,
	frederic@kernel.org, longman@redhat.com, chenridong@huawei.com,
	hare@suse.de, kch@nvidia.com, steve@abita.co, sean@ashe.io,
	chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
Message-ID: <adMoon3Zf6gO-UbA@fedora>
References: <20260401222312.772334-1-atomlin@atomlin.com>
 <20260401222312.772334-14-atomlin@atomlin.com>
 <ac8l-w8ERG1YN2Wm@fedora>
 <nxe24ixebb4lm2d5w4aubhtwr23df6mumqd663axj35oswdiyv@amtqhtsidyr4>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nxe24ixebb4lm2d5w4aubhtwr23df6mumqd663axj35oswdiyv@amtqhtsidyr4>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Sun, Apr 05, 2026 at 09:15:36PM -0400, Aaron Tomlin wrote:
> On Fri, Apr 03, 2026 at 10:30:26AM +0800, Ming Lei wrote:
> > On Wed, Apr 01, 2026 at 06:23:12PM -0400, Aaron Tomlin wrote:
> > 
> > All these can be supported by `managed_irq` already, please document the thing
> > which `io_queue` solves, and `managed_irq` can't cover, so user can know
> > how to choose between the two command lines.
> > 
> > `Restrict the placement of queues to housekeeping CPUs only` looks totally
> > stale, please see patch 10, in which isolated CPUs are spread too.
> 
> Dear Ming,
> 
> Thank you for your careful review of the documentation and for raising
> these excellent points. I completely agree that the administrator guide
> must be as unambiguous as possible.
> 
> Regarding your first point on the distinction between managed_irq and
> io_queue, you are entirely correct that the documentation must explicitly
> guide the user in their choice. I shall revise the text to clarify that
> where managed_irq solely restricts the affinity of hardware interrupts at
> the interrupt controller level, io_queue governs the block layer
> multi-queue mapping algorithm itself. I will add a clear explanation that
> io_queue is required for users who utilise polling queues, which do not
> rely on interrupts, or specific drivers that do not use the managed
> interrupt infrastructure. Without io_queue, the block layer would still
> assign these polling duties to isolated CPUs, thereby breaking the
> isolation.

I don't think there is such breaking isolation thing. For iopoll, if
applications won't submit polled IO on isolated CPUs, everything is just
fine. If they do it, IO may be reaped from isolated CPUs, that is just their
choice, anything is wrong?

> 
> Every logical CPU, including the isolated ones, must logically map to a
> hardware context in order to submit input and output requests, saying they
> are completely restricted is indeed stale and technically inaccurate. The
> isolation mechanism actually ensures that the hardware contexts themselves
> are serviced by the housekeeping CPUs, while the isolated CPUs are simply
> mapped onto these housekeeping queues for submission purposes. I will
> rewrite this paragraph to accurately reflect this topology, ensuring it
> aligns perfectly with the behaviour introduced in patch 10.

I am not sure if the above words is helpful from administrator viewpoint about
the two kernel parameters.

IMO, only two differences from this viewpoint:

1) `io_queue` may reduce nr_hw_queues

2) when application submits IO from isolated CPUs, `io_queue` can complete
IO from housekeeping CPUs.

> 
> > > +
> > > +			  The io_queue configuration takes precedence
> > > +			  over managed_irq. When io_queue is used,
> > > +			  managed_irq placement constrains have no
> > > +			  effect.
> > > +
> > > +			  Note: Offlining housekeeping CPUS which serve
> > > +			  isolated CPUs will be rejected. Isolated CPUs
> > > +			  need to be offlined before offlining the
> > > +			  housekeeping CPUs.
> > > +
> > > +			  Note: When an isolated CPU issues an I/O request,
> > > +			  it is forwarded to a housekeeping CPU. This will
> > > +			  trigger a software interrupt on the completion
> > > +			  path.
> > 
> > `io_queue` doesn't touch io completion code path, which is more
> > implementation details, so not sure if the above Note is needed.
> 
> Possibly the original author intended to suggest that the software
> interrupt is sent to the isolated CPU?

I meant this point can't be found in the patches.


Thanks, 
Ming

