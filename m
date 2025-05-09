Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D90A13E02D
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 02:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746756287; cv=none; b=EFR/ulNq9F+5WPo8Nkr6v5iqJrQ7e2Zet5SfioR2SuSq+5wI93a9YQodYeELNr+9ZJY3NxJj84SSfDykipvCBgFFagyw0X95jVdeIebBdfhK+kPccGgDkbZ3ZYP/Zqm798hGqhP2j3ZnE41PbEWHBdILGC3rPrHQ8r8Vx03olXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746756287; c=relaxed/simple;
	bh=+qfZDALLUhrJhLp9Y8tdMpOzOUBGedANZ5WjS6Kpy/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nuXPLUmPswC++VQnsnThAX6+cpvhWa6UQ3YE5THrVhayaJ0aTMd9ipdN5XQuTl+yQVwN8Kw05lV1yk/qI8xPmbG3JLeM+eSx3ts3BHuvvUektg2964eNAI0GpFZTbFEwYWIzF45vT2sqxHXLtBmj4b3HTSZfZc30KYkR2drfF6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A2nhecG5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A2nhecG5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746756284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xmiJGCWH2hP12TenpYZdFu2FrjT+vq7C54lLFOzY/dY=;
	b=A2nhecG53IxTMARtdqGYE/0p4nEGG+qrE0wkwSaDoxOKhezUZY9xQClcEYxiDQOJc6pN8J
	q/4qOloLhQZJC/98zG2htCsoqP7l6Z2g+KMTDiSlJ9G3q3Vn+9ABda4srDJGFKlkodNZdu
	GPtoihclY53nUozzjyTFp6OjUEWFXVw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-47-Zis-y8ssOV-_Ywxk8Qv7Cw-1; Thu,
 08 May 2025 22:04:40 -0400
X-MC-Unique: Zis-y8ssOV-_Ywxk8Qv7Cw-1
X-Mimecast-MFC-AGG-ID: Zis-y8ssOV-_Ywxk8Qv7Cw_1746756278
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D32241956080;
	Fri,  9 May 2025 02:04:37 +0000 (UTC)
Received: from fedora (unknown [10.72.116.120])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 24C4A180049D;
	Fri,  9 May 2025 02:04:23 +0000 (UTC)
Date: Fri, 9 May 2025 10:04:18 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Daniel Wagner <dwagner@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, Daniel Wagner <wagi@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Costa Shulyupin <costa.shul@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Waiman Long <llong@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org, storagedev@microchip.com,
	virtualization@lists.linux.dev,
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v6 6/9] isolation: introduce io_queue isolcpus type
Message-ID: <aB1iolILQcvvHDE9@fedora>
References: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
 <20250424-isolcpus-io-queues-v6-6-9a53a870ca1f@kernel.org>
 <2db989db-4849-46a9-9bad-0b67d85d1650@suse.de>
 <dd4719dc-5ac4-44d9-bccb-e867d322864e@flourine.local>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd4719dc-5ac4-44d9-bccb-e867d322864e@flourine.local>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Fri, Apr 25, 2025 at 09:32:16AM +0200, Daniel Wagner wrote:
> On Fri, Apr 25, 2025 at 08:26:22AM +0200, Hannes Reinecke wrote:
> > On 4/24/25 20:19, Daniel Wagner wrote:
> > > Multiqueue drivers spreading IO queues on all CPUs for optimal
> > > performance. The drivers are not aware of the CPU isolated requirement
> > > and will spread all queues ignoring the isolcpus configuration.
> > > 
> > > Introduce a new isolcpus mask which allows the user to define on which
> > > CPUs IO queues should be placed. This is similar to the managed_irq but
> > > for drivers which do not use the managed IRQ infrastructure.
> > > 
> > > Signed-off-by: Daniel Wagner <wagi@kernel.org>
> > > ---
> > >   include/linux/sched/isolation.h | 1 +
> > >   kernel/sched/isolation.c        | 7 +++++++
> > >   2 files changed, 8 insertions(+)
> > > 
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> 
> Just realized I forgot to also add some document on this new argument:
> 
> 			io_queue
> 			  Isolate from IO queue work caused by multiqueue
> 			  device drivers. Restrict the placement of
> 			  queues to housekeeping CPUs only, ensuring that
> 			  all IO work is processed by a housekeeping CPU.
> 
> 			  Note: When an isolated CPU issues an IO, it is
> 			  forwarded to a housekeeping CPU. This will
> 			  trigger a software interrupt on the completion
> 			  path.
> 
> 			  Note: It is not possible to offline housekeeping
> 			  CPUs that serve isolated CPUs.

This patch adds kernel parameter only, but not apply it at all, the above
words just confuses everyone, so I'd suggest to not expose the kernel
command line & document until the whole mechanism is supported.

Especially 'irqaffinity=0 isolcpus=io_queue' requires the application
to offline CPU in order, which has to be documented:

https://lore.kernel.org/all/cc5e44dd-e1dc-4f24-88d9-ce45a8b0794f@flourine.local/

Thanks,
Ming

