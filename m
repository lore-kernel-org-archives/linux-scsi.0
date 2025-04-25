Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CC91E231E
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 07:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745566349; cv=none; b=UE83H3ue3CpS3jfPuX2A/hpbVsIt3z36DkXn0smo+SMAbSAF5AkJ+iTScCGaF/odizu6eekbFtxhK3pmX63/JBCnzhCNBsJkSlpqqjT71bO4rCpW0NAbFhekjYSPs0pJzkh65Jd8LEVV9YweZiY9Dn6+WeEMM3hzFUPRXHBmLzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745566349; c=relaxed/simple;
	bh=qh3+deB5RfXkp3djJ1R95fy9ZiJQodi7eJFwTJQylFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SUovvACHUpponIGR3W1CTY18axLo8Tw/Xfpb1rryww85ndLmv0pQM4IdYihwY2pqGwDW1gTmTaTx4Cxs0W/9DDLfWj4WOODwS6nW72eysx0P2bR0E4wAyl0uwBxFUuY9+XGIMadcjR6Hq3zJHNvnn8jlXdB8cBrjk9k0XkE+9H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CC7D8210F9;
	Fri, 25 Apr 2025 07:32:25 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A597113A79;
	Fri, 25 Apr 2025 07:32:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id i4FpKIk6C2iYbwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Fri, 25 Apr 2025 07:32:25 +0000
Date: Fri, 25 Apr 2025 09:32:16 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"Michael S. Tsirkin" <mst@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin <costa.shul@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, 
	Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	storagedev@microchip.com, virtualization@lists.linux.dev, 
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v6 6/9] isolation: introduce io_queue isolcpus type
Message-ID: <dd4719dc-5ac4-44d9-bccb-e867d322864e@flourine.local>
References: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
 <20250424-isolcpus-io-queues-v6-6-9a53a870ca1f@kernel.org>
 <2db989db-4849-46a9-9bad-0b67d85d1650@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2db989db-4849-46a9-9bad-0b67d85d1650@suse.de>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Score: -4.00
X-Spam-Flag: NO
X-Rspamd-Queue-Id: CC7D8210F9
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On Fri, Apr 25, 2025 at 08:26:22AM +0200, Hannes Reinecke wrote:
> On 4/24/25 20:19, Daniel Wagner wrote:
> > Multiqueue drivers spreading IO queues on all CPUs for optimal
> > performance. The drivers are not aware of the CPU isolated requirement
> > and will spread all queues ignoring the isolcpus configuration.
> > 
> > Introduce a new isolcpus mask which allows the user to define on which
> > CPUs IO queues should be placed. This is similar to the managed_irq but
> > for drivers which do not use the managed IRQ infrastructure.
> > 
> > Signed-off-by: Daniel Wagner <wagi@kernel.org>
> > ---
> >   include/linux/sched/isolation.h | 1 +
> >   kernel/sched/isolation.c        | 7 +++++++
> >   2 files changed, 8 insertions(+)
> > 
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Just realized I forgot to also add some document on this new argument:

			io_queue
			  Isolate from IO queue work caused by multiqueue
			  device drivers. Restrict the placement of
			  queues to housekeeping CPUs only, ensuring that
			  all IO work is processed by a housekeeping CPU.

			  Note: When an isolated CPU issues an IO, it is
			  forwarded to a housekeeping CPU. This will
			  trigger a software interrupt on the completion
			  path.

			  Note: It is not possible to offline housekeeping
			  CPUs that serve isolated CPUs.
