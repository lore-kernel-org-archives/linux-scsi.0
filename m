Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F35219E5;
	Mon, 25 Mar 2024 19:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711396366; cv=none; b=soozggVAzXTWmn54VFtIHGd3AB2zrTmo0Th9lAxtKuRt6RgZoeMDFuRIHsHbicygGs8xC3s8rc86xgLtJtBmvvdK8I7CFECdKHt1VDQC59LXZw759T1rq+0r100xMuz5dYwPTdwdnoGKkgWONcYvcwc0EjvpGpXiHQ2+VUrKlFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711396366; c=relaxed/simple;
	bh=/XTQ9M4CmszItDuZmv5xRlgv4tYd4200t7nVAYuJxkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z+3p3hFkYlc8qhS4G7/uSqvUdfnFMHfO9nKtS+UkcMrtX19bKPqEp3FNoXVDXt3yHM6AODz46tzrpvEL6OX8ebs+/P4ECx0OrW4dEVekFIuKKLUOcgm//glYFhvColbe1I7c6rWQ04+Ak/q1k/PFtYE4ssy2S2GFqVG10KrPQvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lO19YMqA; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lO19YMqA"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V3NrX29qdz6Cnk9J;
	Mon, 25 Mar 2024 19:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711396361; x=1713988362; bh=NUFKIL9na2llYb0G+09EY53b
	2jiWjVxPnyEC6DWVij4=; b=lO19YMqAFBA3jgSHSAXI6l6h5BfW27LN/HuOZ0h9
	6heFZdz3+fAU6GNP3RqpWaIbSTbh6giFz6LBsMrfelnkOjkMqZmqX6ll2XgLYHh3
	LEeOsqgXcxywZlqlh5LlGadOoPNYH4XSApdc/8NS/jyDYRdFsw86Cef84RFTi40s
	Fq9FGrA2kwoKxtrDiMutuvEra4U3EzCWlz9mVg9sTfFgmBlmKbw9uR42GUU+U5oC
	xiGgN8twb5IlVx0duyf1Jyp7MRVAAnDaS/rqpe9uxF94adNRD9hgUsSNbvV6EydL
	G3vvphvskkeT/v1fCG3bp0BrKDlXtVSE/5AVY2ueoJkodw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 81hb702HiYYO; Mon, 25 Mar 2024 19:52:41 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V3NrS4zyLz6Cnk9G;
	Mon, 25 Mar 2024 19:52:40 +0000 (UTC)
Message-ID: <20a3af4a-3075-4abc-8378-d55ea84a5893@acm.org>
Date: Mon, 25 Mar 2024 12:52:39 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/28] block: Introduce blk_zone_update_request_bio()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-4-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325044452.3125418-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 21:44, Damien Le Moal wrote:
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 8aeb8e96f1a7..9e6e2a9a147c 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -820,11 +820,11 @@ static void blk_complete_request(struct request *req)
>   		/* Completion has already been traced */
>   		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
>   
> -		if (req_op(req) == REQ_OP_ZONE_APPEND)
> -			bio->bi_iter.bi_sector = req->__sector;
> -
> -		if (!is_flush)
> +		if (!is_flush) {
> +			blk_zone_update_request_bio(req, bio);
>   			bio_endio(bio);
> +		}

The above change includes a behavior change. It seems wrong to me not
to call blk_zone_update_request_bio() for REQ_OP_ZONE_APPEND requests if
RQF_FLUSH_SEQ has been set.

Thanks,

Bart.
