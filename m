Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9978F2E3F7;
	Mon, 12 Aug 2024 09:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723453575; cv=none; b=Cml73JW67KlG03GEx8PV5ccGnd7OVgKaRFO+Bit81UqCX6jOamiUeIGW03A49x4L1dhpJdrvHAgjUxiNMjfexSb5U5eoK5XfCghcLBJDjoYvMJ2pa238maQPEG6eLlDZU3PKkOKRs1rTXWia21V/7JBCO5bsvRV5dgy3uWqqA5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723453575; c=relaxed/simple;
	bh=frMY/c+1cmQS37UwoRdV5LwtPs0AiqATOhwdSf/yJNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UTST8k5zkKnRw5ulyNSS+mQatnOvfuHiQysQlHhRsQEGqACJmciwyE64+wn5/jWE0xsNv6FtEslW64/6VOvZu6HgXpzekpGv+5mSuqCn3XmOjelAIGf3DBj6HAJhGrRNqYKF5Ghm1p71qRSrXrQl0BYeBZ+nBzxVcBCPcQBWq5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A77A0227A8E; Mon, 12 Aug 2024 11:06:11 +0200 (CEST)
Date: Mon, 12 Aug 2024 11:06:11 +0200
From: Christoph Hellwig <hch@lst.de>
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
	"brookxu.cn" <brookxu.cn@gmail.com>, Ming Lei <ming.lei@redhat.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com,
	storagedev@microchip.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 04/15] scsi: replace blk_mq_pci_map_queues with
 blk_mq_dev_map_queues
Message-ID: <20240812090611.GE5497@lst.de>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de> <20240806-isolcpus-io-queues-v3-4-da0eecfeaf8b@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806-isolcpus-io-queues-v3-4-da0eecfeaf8b@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 06, 2024 at 02:06:36PM +0200, Daniel Wagner wrote:
> Replace all users of blk_mq_pci_map_queues with the more generic
> blk_mq_dev_map_queues. This in preparation to retire
> blk_mq_pci_map_queues.

The hisi_sas one doesn't look like a trivial scripted conversion.
Can you split that one out and better document what is done?

