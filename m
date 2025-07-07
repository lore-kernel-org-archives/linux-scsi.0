Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F4013AF2;
	Mon,  7 Jul 2025 05:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751866956; cv=none; b=PqnPkpdAmJvbFOx4AKkulbMeapxwPaQDSaUyJSqPwubERzkWKUyFjUfgi7B/0jlHIR8kaK6/7CxZnPPBPGA2mYjExE3XbuSDBb/+H49GCLXPUsxwZo4didk5mQTBnqNWvZn/UdvM6D6lktCZCHEDoJ13asIIXZM4Nn42emODnYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751866956; c=relaxed/simple;
	bh=kuw5IbnV7fi6rLoKY/KXvSEqEshcimO+A5gdlD8ZJyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gcACazluDlHLkZ/qbycavwkPBSxPyp+uhbPFZHEy8niWQw1b8Rk2ydLro5GEtDJ6rGE4CbKKgS854dm//ga3WRI6kFDEAn1ZcOSQQWDfgWjKKMBwccRbs6HgEewi/sgJ9lbzQne0Eg+F6Pl7OnQME+jp28uEWWUBEYbzDuobXMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 07766227A87; Mon,  7 Jul 2025 07:42:28 +0200 (CEST)
Date: Mon, 7 Jul 2025 07:42:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Daniel Wagner <dwagner@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Daniel Wagner <wagi@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Costa Shulyupin <costa.shul@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org, storagedev@microchip.com,
	virtualization@lists.linux.dev,
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v7 08/10] blk-mq: use hk cpus only when
 isolcpus=io_queue is enabled
Message-ID: <20250707054227.GB28625@lst.de>
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org> <20250702-isolcpus-io-queues-v7-8-557aa7eacce4@kernel.org> <20250703090158.GA4757@lst.de> <75aafd33-0aff-4cf7-872f-f110ed896213@flourine.local>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75aafd33-0aff-4cf7-872f-f110ed896213@flourine.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 04, 2025 at 11:00:56AM +0200, Daniel Wagner wrote:
> > I'm no expert on the housekeeping stuff, but why isn't the
> > housekeeping_enabled check done in housekeeping_cpumask directly so
> > that the drivers could use housekeeping_cpumask without a blk-mq
> > wrapper?
> 
> Yes, housekeeping_cpumask will return cpu_possible_mask when housekeping
> is disabled. Though some drivers want cpu_online_mask instead. If all
> drivers would agree on one version of the mask it should allow to drop
> to these helpers (maybe we the houskeeping API needs to be extended then
> though)

Drivers don't get cpu hotplug notifications, so cpu_possible_mask is
the only valid answer right now.  That could change if we ever implement
notifications to the drivers.

> This is also what Hannes brought up. If the number of supported hardware
> queues for a device is less than cpu_possible_mask, it really makes
> sense to distribute the hardware queues only between the online cpus. I
> think the only two drivers which are interested in the cpu_possible_mask
> are nvme-pci and virtio.

That's the only two drivers that get it right :(
