Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BEC16D33F;
	Mon, 12 Aug 2024 09:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723453518; cv=none; b=AvjmdTlhTVnWX5ILvRILsB8SGpunkcBejQ3ot/nbo4KBAu44VP/ZUjjal9SH70zyNMUceUYwZXHT5TXVTMfpJqijpuojS37EKOX6meXoa/jZnDZiJP6xRpxYgZiHkVmpS+TFK+tx1o1/8klx4JB4Wx2pZa/MhsaENym87mFscP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723453518; c=relaxed/simple;
	bh=smsY6YIY5/W5JLemMMuuRNZly91dsiAUB+xm8Jk2U+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mjOXS4N3tAEKcaa+ZnlyGNVt7GfMmejxmlIiVoKJCaBHp6LIwVtJFujky1U8U7zifGWJYR48dXRRoO60H2+4sP3ShJiRW0SEeB2GRifTA1ulrf+bd60jqaZNpBTI0r/l+yKP5LsGm/aCizjupxsdLK8BmvVvnTsHlc/F1jUKAb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 57D9A227A8E; Mon, 12 Aug 2024 11:05:13 +0200 (CEST)
Date: Mon, 12 Aug 2024 11:05:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Daniel Wagner <dwagner@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Jonathan Corbet <corbet@lwn.net>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
	Sridhar Balaraman <sbalaraman@parallelwireless.com>,
	"brookxu.cn" <brookxu.cn@gmail.com>, Ming Lei <ming.lei@redhat.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com,
	storagedev@microchip.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 03/15] blk-mq: introduce blk_mq_dev_map_queues
Message-ID: <20240812090513.GD5497@lst.de>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de> <20240806-isolcpus-io-queues-v3-3-da0eecfeaf8b@suse.de> <20240806132645.GC13883@lst.de> <8468546d-adae-4477-9306-ca08f32b19ca@flourine.local>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8468546d-adae-4477-9306-ca08f32b19ca@flourine.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 07, 2024 at 02:49:58PM +0200, Daniel Wagner wrote:
> On Tue, Aug 06, 2024 at 03:26:45PM GMT, Christoph Hellwig wrote:
> > > +
> > > +/**
> > > + * blk_mq_virtio_get_queue_affinity - get affinity mask queue mapping for virtio device
> > 
> > Please avoid the overly long line here.
> 
> I thought for some reason the brief description needs to be on one
> line. It can be multiple lines:
> 
> https://www.kernel.org/doc/html/v6.10/doc-guide/kernel-doc.html#structure-union-and-enumeration-documentation

I'm pretty sure I've see line wraps there.  But if it wraps that's
probably and argument it is too lone as it isn't single line at that
point for a reasonable definition of line.
