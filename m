Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC9E1FA16B;
	Thu, 19 Dec 2024 06:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734589690; cv=none; b=WhPbtkHZBdkwZSPHhqua4sjffXoEf1/cCPjiyOfSVKFsnbWx71IXY+5uYj+JE4Fhyp10PcXu/mzsT1Oq9Z/MsBXiVAvsGu8OFBfzpnyT9Z+OGttzXj6hIT5lDqNFV3jK5fdzBAb5VZXGopqnAnkjJ7yzDUtRf50+EC3EaHtmTfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734589690; c=relaxed/simple;
	bh=SbDEvwy8SjHtDjAGRnEkD2vARoUHLK/qSGwhA36aWOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HQY24oVqLPGMYwTkRwlSQ/La8nNcPxoqhs5E7sj9ryR+ZLYNW6GtibKmY4GK8Yea3u8mLCju908LP5vce2O9innlDSX6/o6OTkiXpnkYY7HF2rcFb6OfoXPP1H2B5BUbWGZxXZrwyUofUg1m12wu+5Tnxr6u0o0crgQPXOt+Z5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9E31868BFE; Thu, 19 Dec 2024 07:28:02 +0100 (CET)
Date: Thu, 19 Dec 2024 07:28:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Daniel Wagner <wagi@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
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
	Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
	Sridhar Balaraman <sbalaraman@parallelwireless.com>,
	"brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	storagedev@microchip.com, virtualization@lists.linux.dev
Subject: Re: [PATCH v4 9/9] blk-mq: issue warning when offlining hctx with
 online isolcpus
Message-ID: <20241219062802.GC19782@lst.de>
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org> <20241217-isolcpus-io-queues-v4-9-5d355fbb1e14@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217-isolcpus-io-queues-v4-9-5d355fbb1e14@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 17, 2024 at 07:29:43PM +0100, Daniel Wagner wrote:
> When we offlining a hardware context which also serves isolcpus mapped
> to it, any IO issued by the isolcpus will stall as there is nothing
> which handles the interrupts etc.
> 
> This configuration/setup is not supported at this point thus just issue
> a warning.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>  block/blk-mq.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index de15c0c76f874a2a863b05a23e0f3dba20cb6488..f9af0f5dd6aac8da855777acf2ffc61128f15a74 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3619,6 +3619,45 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
>  	return data.has_rq;
>  }
>  
> +static void blk_mq_hctx_check_isolcpus_online(struct blk_mq_hw_ctx *hctx, unsigned int cpu)

Please avoid the overly long line here.

> +{
> +	const struct cpumask *hk_mask;
> +	int i;
> +
> +	if (!housekeeping_enabled(HK_TYPE_MANAGED_IRQ))
> +		return;
> +
> +	hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);
> +
> +	for (i = 0; i < hctx->nr_ctx; i++) {
> +		struct blk_mq_ctx *ctx = hctx->ctxs[i];
> +
> +		if (ctx->cpu == cpu)
> +			continue;
> +
> +		/*
> +		 * Check if this context has at least one online
> +		 * housekeeping CPU in this case the hardware context is
> +		 * usable.

But here you;re not even using up all 80 characters for the comment.

