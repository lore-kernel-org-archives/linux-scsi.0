Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794811208;
	b=WZG6Seo+vgr73QF9Z1w6wHcq8ARaxhzRlCTAr74kmySCv/4YUJociyR3yNMFjsclyhaM
	 mmGZTKgDb6kXd0MQd2UsY7oS9NHU9IUm7OLuHG9kIQ2e/s4IkYu+qoRRfQ0d9LHccLIJ6
	 oAdMjLnMB8c1s6jttk7nnttrby1h4qdqmGefHJxuGgfN9yuwjhKKnIFJNjv52N0AyLpJp
	 tV8bEWpoMvcFljcHB8HhoaSAaVvm3meASedfmdr0GdYseqH3v/fTNv4wb3IxMqLjPL+0f
	 IdQh2eFV5E+YWJ/c2tjQwWw2br7X2gOgXVn7yKgkQoE6AH+FmphDuitas+QT/b5cD2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794811208;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=JSbIlCq5ANRSMQPG28kkfakfzcr+1for/u9aylHp7cI=;
	b=Vysq6/4nglC9YyZ0Wwe1zyYzoz0FV+V2zLzb45aVXeBDglsj3iyAMVtZIqmSrF0Zauje
	 FqEv2nsgIIsPelU4zZ+boqqAE3SI7ctROOiwAIlEsKMCNaPiw2XQc6LjwOI5am0KAI8fT
	 CDRVN5DqkRQpmuD4/IMkwxZgbVx8OpC14eFku6wh/1QxoGspnNYGSAz5tN9/qUDfIt/MV
	 94hxRABXiAnicZyMBIzdVEROv9iabP8dOeYOy9A8pEOj/GPRE4cxaQskni32Gg7XpThj5
	 FWvBQUQyWSXBreMPPvW7GybF6CUGtCt2pLTTl/mY+uX6XYV9zBk2ZlRBuvhjKd4AEhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB1A606A31C;
	Mon, 16 Nov 2026 06:40:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EBB1A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 73CE768B05; Mon, 16 Nov 2026 07:39:56 +0100 (CET)
Date: Mon, 16 Nov 2026 07:39:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v10 06/13] zloop: fix ordered zone append handling
Message-ID: <20261116063956.GA2896@lst.de>
References: <20261115233327.941586-1-dlemoal@kernel.org> <20261115233327.941586-7-dlemoal@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115233327.941586-7-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 16, 2026 at 08:33:20AM +0900, Damien Le Moal wrote:
>  	INIT_WORK(&cmd->work, zloop_cmd_workfn);
> -	queue_work(zlo->workqueue, &cmd->work);
> +	if (zlo->ordered_zone_append && req_op(rq) == REQ_OP_ZONE_APPEND)
> +		wq = zlo->append_workqueue;
> +	else
> +		wq = zlo->workqueue;
> +	queue_work(wq, &cmd->work);

I'd do away with the wq variable here and just have separate queue_work
calls, which would be a bit simpler.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

