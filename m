Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BEC2119;
	Mon, 25 Nov 2024 07:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732520223; cv=none; b=LqCKn0PCn0tdy/Pw9ouuLEjcwXmX+t+bZc0CQ0ujSZ1M6VsjZ9DLZY5A29wj7/+rB525hafL/1Nr6vPo43HBviBwFBkEagBNITG3K/jfmSEWkEcgQxZfBdw1+Bbit5Z5EmuUqnGARI9pCOSLLHdIILtDfgOkk4EdjPE+vNVfLMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732520223; c=relaxed/simple;
	bh=ykyCCKl8gtxzVQHKbbY6Y3XWba4Xq2lT14Me0ZDDDvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ORtjvUlpj17uaKOCBob12m1sPIQthj4BhyWKKOTMBQSj21D3lqNUQu6oCis6cTi0UxUavfGlbPAUH7zgK7dkSya+n6RH6PkXEg+EZmJz+3whE9+uRDYJAdSvx6ZwYt+zuyOB4exTVafq3ARfYUTytm5HJFBH9NRo5Ck+anb+uis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 703A768D09; Mon, 25 Nov 2024 08:36:58 +0100 (CET)
Date: Mon, 25 Nov 2024 08:36:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] block: remove the ioprio field from struct request
Message-ID: <20241125073658.GA15834@lst.de>
References: <20241112170050.1612998-3-hch@lst.de> <20241122050419.21973-1-semen.protsenko@linaro.org> <20241122120444.GA25679@lst.de> <CAPLW+4==a515TCD93Kp-8zC8iYyYdh92U=j_emnG5sT_d7z64w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPLW+4==a515TCD93Kp-8zC8iYyYdh92U=j_emnG5sT_d7z64w@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 22, 2024 at 03:55:23PM -0600, Sam Protsenko wrote:
> It's an Exynos based board with eMMC, so it uses DW MMC driver, with
> Exynos glue layer on top of it, so:
> 
>     drivers/mmc/host/dw_mmc.c
>     drivers/mmc/host/dw_mmc-exynos.c
> 
> I'm using the regular ARM64 defconfig. Nothing fancy about this setup
> neither, the device tree with eMMC definition (mmc_0) is here:
> 
>     arch/arm64/boot/dts/exynos/exynos850-e850-96.dts

Thanks.  eMMC itself never looks at the ioprio field.

> FWIW, I was able to narrow down the issue to dd_insert_request()
> function. With this hack the freeze is gone:

Sounds like it isn't the driver that matters here, but the scheduler.

> 
> 8<-------------------------------------------------------------------->8
> diff --git a/block/mq-deadline.c b/block/mq-deadline.c
> index acdc28756d9d..83d272b66e71 100644
> --- a/block/mq-deadline.c
> +++ b/block/mq-deadline.c
> @@ -676,7 +676,7 @@ static void dd_insert_request(struct blk_mq_hw_ctx
> *hctx, struct request *rq,
>         struct request_queue *q = hctx->queue;
>         struct deadline_data *dd = q->elevator->elevator_data;
>         const enum dd_data_dir data_dir = rq_data_dir(rq);
> -       u16 ioprio = req_get_ioprio(rq);
> +       u16 ioprio = 0; /* the same as old req->ioprio */
>         u8 ioprio_class = IOPRIO_PRIO_CLASS(ioprio);
>         struct dd_per_prio *per_prio;
>         enum dd_prio prio;
> 8<-------------------------------------------------------------------->8
> 
> Does it tell you anything about where the possible issue can be?

Can you dump the ioprities you see here with and without the reverted
patch?

