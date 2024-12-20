Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31F31AAA1C
	for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2024 08:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734684900; cv=none; b=NZDtNkE+Z0uUQ+zt9hGqvmjsix7ELOCjlLejfCi2GrZEAuQ94uH5iA88yWHJI5f7Bl+Xng0p1cJos64Hffkp5iRgokujPOTTs/AUCEV+2fg3Fnb98/1NeeieJo3KzpXlhv2hwmOLcbdKgUkqzepwhHg3bZIz/xCmkeA1dqW0L10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734684900; c=relaxed/simple;
	bh=AOTV0eBOsnWPs4GbHqW3cxDrn0aK+yS9J9TWDDc/C+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FdJxzbyxfxw+3fum9jU/caBFHEBUJo2Y8XAYV09Mjr8rBhjHmY6H0Cfe3SFf7mZcfbArn6p+pclb4nJvvDkUMZM+TxrRctg/tU9DEQ7wwqW+DoEn0E4KyIrlUDNopVo4QvT+okPm6FwXLiXk3n5eUcBzwJfICO5rdxsgYVN+GGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e9C+spFe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e9C+spFe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734684897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QzjzcdcjxJq94HHw+ivm1Rh4H1wHHh3+V1gm+dCRqaY=;
	b=e9C+spFe3IrhC0L606a+USkBw7Inf6Ix8QLDRL4N56SO+RBdrhUAGq4DB2wsVY93YJtrfJ
	PJ/3JmbWthZXOXO8nmCJmVt8eTGP4fjkHnj+OdrImT067/pzvZ3iCuBgKRCZzxU6N/WCR8
	SC2S+fzSGWmPfBU2IG9FzATtQgHg0/E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-284-AQ6ceaTROi2gD8kt32fNWQ-1; Fri,
 20 Dec 2024 03:54:54 -0500
X-MC-Unique: AQ6ceaTROi2gD8kt32fNWQ-1
X-Mimecast-MFC-AGG-ID: AQ6ceaTROi2gD8kt32fNWQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C293B19560B1;
	Fri, 20 Dec 2024 08:54:48 +0000 (UTC)
Received: from fedora (unknown [10.72.116.29])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 85E3F19560AD;
	Fri, 20 Dec 2024 08:54:26 +0000 (UTC)
Date: Fri, 20 Dec 2024 16:54:21 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Daniel Wagner <dwagner@suse.de>
Cc: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Don Brace <don.brace@microchip.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Costa Shulyupin <costa.shul@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Waiman Long <llong@redhat.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
	Sridhar Balaraman <sbalaraman@parallelwireless.com>,
	"brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	storagedev@microchip.com, virtualization@lists.linux.dev
Subject: Re: [PATCH v4 8/9] blk-mq: use hk cpus only when
 isolcpus=managed_irq is enabled
Message-ID: <Z2UwvQoDM3f4zAxG@fedora>
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
 <20241217-isolcpus-io-queues-v4-8-5d355fbb1e14@kernel.org>
 <Z2PlbL0XYTQ_LxTw@fedora>
 <cc5e44dd-e1dc-4f24-88d9-ce45a8b0794f@flourine.local>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc5e44dd-e1dc-4f24-88d9-ce45a8b0794f@flourine.local>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Dec 19, 2024 at 04:38:43PM +0100, Daniel Wagner wrote:

> When isolcpus=managed_irq is enabled all hardware queues should run on
> the housekeeping CPUs only. Thus ignore the affinity mask provided by
> the driver.

Compared with in-tree code, the above words are misleading.

- irq core code respects isolated CPUs by trying to exclude isolated
CPUs from effective masks

- blk-mq won't schedule blockd on isolated CPUs

If application aren't run on isolated CPUs, IO interrupt usually won't
be triggered on isolated CPUs, so isolated CPUs are _not_ ignored.

> On Thu, Dec 19, 2024 at 05:20:44PM +0800, Ming Lei wrote:
> > > +	cpumask_andnot(isol_mask,
> > > +		       cpu_possible_mask,
> > > +		       housekeeping_cpumask(HK_TYPE_MANAGED_IRQ));
> > > +
> > > +	for_each_cpu(cpu, isol_mask) {
> > > +		qmap->mq_map[cpu] = qmap->queue_offset + queue;
> > > +		queue = (queue + 1) % qmap->nr_queues;
> > > +	}
> > 
> > Looks the IO hang issue in V3 isn't addressed yet, is it?
> > 
> > https://lore.kernel.org/linux-block/ZrtX4pzqwVUEgIPS@fedora/
> 
> I've added an explanation in the cover letter why this is not
> addressed. From the cover letter:
> 
> I've experimented for a while and all solutions I came up were horrible
> hacks (the hotpath needs to be touched) and I don't want to slow down all
> other users (which are almost everyone). IMO, it's just not worth trying

IMO, this patchset is one improvement on existed best-effort approach, which
works fine most of times, so why you do think it slows down everyone?

> to fix this corner case. If the user is using isolcpus and does CPU
> hotplug, we can expect that the user can also first offline the isolated
> CPUs. I've discussed this topic during ALPSS and the room came to the
> same conclusion. Thus I just added a patch which issues a warning that
> IOs are likely to hang.

If the change need userspace cooperation for using 'managed_irq', the exact
behavior need to be documented in both this commit and Documentation/admin-guide/kernel-parameters.txt,
instead of cover-letter only.

But this patch does cause regression for old applications which can't
follow the new introduced rule:

	```
	If the user is using isolcpus and does CPU hotplug, we can expect that the
	user can also first offline the isolated CPUs.
	```

Thanks,
Ming

