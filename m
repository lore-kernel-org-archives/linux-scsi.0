Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30421D6DDB
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 14:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722956149; cv=none; b=U/SPimCb8odn1bm7wLmy2meEv1PFrUerCkxoKmQsNo9TqrjOC9hx9xa5w/HDnmBvHVT/lbb/WW2fNpumwBT6mf0X/BpaiiLHlMkKpUPgBpQKounWBwZ9+S+c7B25GUijtM3AkPs1Lz/tzy/NNLqY/lIWV5DMdyxO57T0A7he+Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722956149; c=relaxed/simple;
	bh=5W/f9Go6KqLTcoO7AGO4U5RXIhiU1JoC/JlTAULsf7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fFCDqqmJnhYthuPoTvlAq7a521zYuu3Byhul4vF2nx+sH349QH8KTiQpQIyBxoDy7aiumzXKtTiCNGf5cZ6+ZlDuXglk1oT9JtHcpxndYkJZOtVQc1iFi0kLsIAVaItTJGxY/sMB4knS5AptNRLeeCr+CIbtIR3D8DWg46LUBbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fhPqhi6I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fhPqhi6I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722956146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5W/f9Go6KqLTcoO7AGO4U5RXIhiU1JoC/JlTAULsf7o=;
	b=fhPqhi6IpW0RT4tJXUa90RzDI3AT2XToUJuTdoLwRZJli1LHovXR1q1iI4v7oAjj6XGd9l
	941KwWpVXm891Nsw4OLcTqJ3Gjnb6sLGn9ja5wK4YCrs79vY+B7szjnpRvj58ugD7/sspW
	l6IIsyv6Xrx6eCRbL8wjaGKMjoOhvdI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-HwAq-aLEOvWa8u616gwxEQ-1; Tue,
 06 Aug 2024 10:55:39 -0400
X-MC-Unique: HwAq-aLEOvWa8u616gwxEQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A54CF1955BEE;
	Tue,  6 Aug 2024 14:55:33 +0000 (UTC)
Received: from fedora (unknown [10.72.116.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A49C91956046;
	Tue,  6 Aug 2024 14:55:15 +0000 (UTC)
Date: Tue, 6 Aug 2024 22:55:09 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Daniel Wagner <dwagner@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christoph Hellwig <hch@lst.de>,
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
	"brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com, storagedev@microchip.com,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 15/15] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <ZrI5TcaAU82avPZn@fedora>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
 <20240806-isolcpus-io-queues-v3-15-da0eecfeaf8b@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806-isolcpus-io-queues-v3-15-da0eecfeaf8b@suse.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Aug 06, 2024 at 02:06:47PM +0200, Daniel Wagner wrote:
> When isolcpus=io_queue is enabled all hardware queues should run on the
> housekeeping CPUs only. Thus ignore the affinity mask provided by the
> driver. Also we can't use blk_mq_map_queues because it will map all CPUs
> to first hctx unless, the CPU is the same as the hctx has the affinity
> set to, e.g. 8 CPUs with isolcpus=io_queue,2-3,6-7 config

What is the expected behavior if someone still tries to submit IO on isolated
CPUs?

BTW, I don't see any change in blk_mq_get_ctx()/blk_mq_map_queue() in this
patchset, that means one random hctx(or even NULL) may be used for submitting
IO from isolated CPUs, then there can be io hang risk during cpu hotplug, or
kernel panic when submitting bio.

Thanks,
Ming

