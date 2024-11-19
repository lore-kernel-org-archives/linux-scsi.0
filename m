Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831901527B4;
	Tue, 19 Nov 2024 07:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732001924; cv=none; b=JOmPeq05SMoNDhgFClDRX9FSm5DlJbmMjBmJ30Kn4jhCy8zXZerYYcYEmyo7HLZI3r1Qf1S6Pr1RHzR2TQaiJ3nUi9cp3vLJP8RYgYPlJg+jcMNNvtuTQop1e7AgFFipvJ/l3oqQhzyfEMIXp/utFKdhoNA6ZsyB6EDHldGebyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732001924; c=relaxed/simple;
	bh=BgD/ItPj3+rM6ruPLsoXWunIgSfBeQn2STbx0s0fmhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ak9nhLDVeUoyMR9d1E1kKb0snXSxaVmmQNSJrbu5bwuZ6yaqfmoovS5uHLB48kvGT+PgAI1qKXIW0fiICGSSeE7iEW+PdZU9JjtudWyfo17adAhvg3IiC3kdIUKagD4Zue9SiG0fofphddKOo5ouapojEGHYHHHEbx6yd9ieScg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uZD6qfTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uZD6qfTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50038C4CECF;
	Tue, 19 Nov 2024 07:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732001924;
	bh=BgD/ItPj3+rM6ruPLsoXWunIgSfBeQn2STbx0s0fmhw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uZD6qfTjKlO9BriXRKb3qgRB+E3StHe36NAeP8EUZr5BsDTKdleYRTz493++l1FUD
	 y1jTjON2YgPXM1ADsgeQ1udwqlUTDeZrnng8vlAfLCMCOfDxJILRztjEGjEL4/DGiA
	 WXGxU60hZAovnx4LIy3cYhgxSMG+NmDhjOOgax/+Okh5p+61ADkUbqSq4+dhXCazEw
	 iqXmSD6k5nnD1LWi4PgoYJDXMq9C7cu2Y07CnXUcmPOrrkturYV+ZTbhLZUqfIRRLW
	 OKWwjJd9LUmIrMcgSM/xpKn6UfJ39dXhjLihBgbh3/265MEmgzMoSZ/Zy55vtLtJDc
	 d6xNSbmP0HbJQ==
Message-ID: <8b81c0df-bb29-4db8-99c1-8436c55106bc@kernel.org>
Date: Tue, 19 Nov 2024 16:38:42 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 09/26] mq-deadline: Remove a local variable
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-10-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-10-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 09:27, Bart Van Assche wrote:
> Since commit fde02699c242 ("block: mq-deadline: Remove support for zone
> write locking"), the local variable 'insert_before' is assigned once and
> is used once. Hence remove this local variable.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

This patch can be sent separately from this series I think. It does not really
belong here, no ?

> ---
>  block/mq-deadline.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/block/mq-deadline.c b/block/mq-deadline.c
> index acdc28756d9d..2edf84b1bc2a 100644
> --- a/block/mq-deadline.c
> +++ b/block/mq-deadline.c
> @@ -699,8 +699,6 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
>  		list_add(&rq->queuelist, &per_prio->dispatch);
>  		rq->fifo_time = jiffies;
>  	} else {
> -		struct list_head *insert_before;
> -
>  		deadline_add_rq_rb(per_prio, rq);
>  
>  		if (rq_mergeable(rq)) {
> @@ -713,8 +711,7 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
>  		 * set expire time and add to fifo list
>  		 */
>  		rq->fifo_time = jiffies + dd->fifo_expire[data_dir];
> -		insert_before = &per_prio->fifo_list[data_dir];
> -		list_add_tail(&rq->queuelist, insert_before);
> +		list_add_tail(&rq->queuelist, &per_prio->fifo_list[data_dir]);
>  	}
>  }
>  


-- 
Damien Le Moal
Western Digital Research
