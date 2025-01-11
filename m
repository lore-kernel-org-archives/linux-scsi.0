Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06EC54F8C
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jan 2025 03:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736566310; cv=none; b=C4E/2XlomGKAbdKT0SpbaT1hC+yffDW19gbM19m0MbcnVF3XEZytwRCT1/wzbG7lUxILAQzL8bE06fWXM7nRLptpmZm/2GPyJmKzrb5kr3zWvQ7barr6aQq1s02WvVprvY6hd8Ne2bHjVKYSCpvpgqrtmO+l+AsTzPNzR8JECIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736566310; c=relaxed/simple;
	bh=5xh5jozQ32aeRFicEnr0DHa8DqBRNILOyWAPo2iTSi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ocwXV2Sj5FIt4OrNC3JKxqZzDMxCfYuYCYwuBYG7nJ9mmmX1f0ZyG95vTFZUJQZ55UJg45xnl8KyovCZixnE8hI5bHBX0ytGr28lwUIKFirGNZWYA5ieBbqQhokXExBs2zfneWDb+pa8c74yXqa8tm3PSOo+iPqjt1YvSkWrj8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h9owafDh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h9owafDh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736566307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0W+82H/K+CNzaGAr5/RSFb2EWf4KvzDMQXmpvJfy+Ec=;
	b=h9owafDhjx4TYPLhEjBQ4qlMpgpsgX5xHjroz+UWUPDtccBlZzHrYflzQ/PsEWyWWIJviY
	kxJ+wICs0qX4Ac+oxgW2UMUk29VLeB42p1X/W2fewO9H3lB3tKAV/rYIvCY6aIl+0fqExw
	4kksx2HcLKqyqhVePYxB6HBEAK8z5+U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-LKBUZ1EeMP2vAeGKv4Vuyg-1; Fri,
 10 Jan 2025 22:31:43 -0500
X-MC-Unique: LKBUZ1EeMP2vAeGKv4Vuyg-1
X-Mimecast-MFC-AGG-ID: LKBUZ1EeMP2vAeGKv4Vuyg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 339E719560B2;
	Sat, 11 Jan 2025 03:31:39 +0000 (UTC)
Received: from fedora (unknown [10.72.116.10])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E20D195E3D9;
	Sat, 11 Jan 2025 03:31:16 +0000 (UTC)
Date: Sat, 11 Jan 2025 11:31:10 +0800
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
Message-ID: <Z4Hl_oQhJ2u6g2B3@fedora>
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
 <20241217-isolcpus-io-queues-v4-8-5d355fbb1e14@kernel.org>
 <Z2PlbL0XYTQ_LxTw@fedora>
 <cc5e44dd-e1dc-4f24-88d9-ce45a8b0794f@flourine.local>
 <Z2UwvQoDM3f4zAxG@fedora>
 <ae9abe4c-010a-41ff-be44-1d52a331eb11@flourine.local>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae9abe4c-010a-41ff-be44-1d52a331eb11@flourine.local>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Jan 10, 2025 at 10:21:49AM +0100, Daniel Wagner wrote:
> Hi Ming,
> 
> On Fri, Dec 20, 2024 at 04:54:21PM +0800, Ming Lei wrote:
> > On Thu, Dec 19, 2024 at 04:38:43PM +0100, Daniel Wagner wrote:
> > 
> > > When isolcpus=managed_irq is enabled all hardware queues should run on
> > > the housekeeping CPUs only. Thus ignore the affinity mask provided by
> > > the driver.
> > 
> > Compared with in-tree code, the above words are misleading.
> > 
> > - irq core code respects isolated CPUs by trying to exclude isolated
> > CPUs from effective masks
> > 
> > - blk-mq won't schedule blockd on isolated CPUs
> 
> I see your point, the commit should highlight the fact when an
> application is issuing an I/O, this can lead to stalls.
> 
> What about a commit message like:
> 
>   When isolcpus=managed_irq is enabled, and the last housekeeping CPU for
>   a given hardware context goes offline, there is no CPU left which
>   handles the IOs anymore. If isolated CPUs mapped to this hardware
>   context are online and an application running on these isolated CPUs
>   issue an IO this will lead to stalls.

It isn't correct, the in-tree code doesn't have such stall, no matter if
IO is issued from HK or isolated CPUs since the managed irq is guaranteed to
live if any mapped CPU is online.

> 
>   The kernel will not schedule IO to isolated CPUS thus this avoids IO
>   stalls.
> 
>   Thus issue a warning when housekeeping CPUs are offlined for a hardware
>   context while there are still isolated CPUs online.
> 
> > If application aren't run on isolated CPUs, IO interrupt usually won't
> > be triggered on isolated CPUs, so isolated CPUs are _not_ ignored.
> 
> FWIW, the 'usually' part is what made our customers nervous. They saw
> some IRQ noise on the isolated CPUs with their workload and reported
> with these changes all was good. Unfortunately, we never got the hands
> on the workload, hard to say what was causing it.

Please see irq_do_set_affinity():

        if (irqd_affinity_is_managed(data) &&
              housekeeping_enabled(HK_TYPE_MANAGED_IRQ)) {
                  const struct cpumask *hk_mask;

                  hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);

                  cpumask_and(&tmp_mask, mask, hk_mask);
                  if (!cpumask_intersects(&tmp_mask, cpu_online_mask))
                          prog_mask = mask;
                  else
                          prog_mask = &tmp_mask;
          } else {
                  prog_mask = mask;

The whole mask which may include isolated CPUs is only programmed to
hardware if there isn't any online CPU in `irq_mask & hk_mask`.

> 
> > > On Thu, Dec 19, 2024 at 05:20:44PM +0800, Ming Lei wrote:
> > > > > +	cpumask_andnot(isol_mask,
> > > > > +		       cpu_possible_mask,
> > > > > +		       housekeeping_cpumask(HK_TYPE_MANAGED_IRQ));
> > > > > +
> > > > > +	for_each_cpu(cpu, isol_mask) {
> > > > > +		qmap->mq_map[cpu] = qmap->queue_offset + queue;
> > > > > +		queue = (queue + 1) % qmap->nr_queues;
> > > > > +	}
> > > > 
> > > > Looks the IO hang issue in V3 isn't addressed yet, is it?
> > > > 
> > > > https://lore.kernel.org/linux-block/ZrtX4pzqwVUEgIPS@fedora/
> > > 
> > > I've added an explanation in the cover letter why this is not
> > > addressed. From the cover letter:
> > > 
> > > I've experimented for a while and all solutions I came up were horrible
> > > hacks (the hotpath needs to be touched) and I don't want to slow down all
> > > other users (which are almost everyone). IMO, it's just not worth trying
> > 
> > IMO, this patchset is one improvement on existed best-effort approach, which
> > works fine most of times, so why you do think it slows down everyone?
> 
> I was talking about implementing the feature which would remap the
> isolated CPUs to online hardware context when the current hardware
> context goes offline. I didn't find a solution which I think would be
> worth presenting. All involved some sort of locking/refcounting in the
> hotpath, which I think we should just avoid.

I understand the trouble, but it is still one improvement from user
viewpoint instead of feature since the interface of 'isolcpus=manage_irq'
isn't changed.

> 
> > > to fix this corner case. If the user is using isolcpus and does CPU
> > > hotplug, we can expect that the user can also first offline the isolated
> > > CPUs. I've discussed this topic during ALPSS and the room came to the
> > > same conclusion. Thus I just added a patch which issues a warning that
> > > IOs are likely to hang.
> > 
> > If the change need userspace cooperation for using 'managed_irq', the exact
> > behavior need to be documented in both this commit and Documentation/admin-guide/kernel-parameters.txt,
> > instead of cover-letter only.
> > 
> > But this patch does cause regression for old applications which can't
> > follow the new introduced rule:
> > 
> > 	```
> > 	If the user is using isolcpus and does CPU hotplug, we can expect that the
> > 	user can also first offline the isolated CPUs.
> > 	```
> 
> Indeed, I forgot to update the documentation. I'll update it accordingly.

It isn't documentation thing, it breaks the no-regression policy, which crosses
our red-line.

If you really want to move on, please add one new kernel command
line with documenting the new usage which requires applications to
offline CPU in order.


thanks,
Ming

