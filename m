Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF4F14AD20;
	Wed,  3 Dec 2025 00:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764721736; cv=none; b=GMGuVPKYmyMQtDHeN5+8/lc8bcUPk2vncL2t68N3upzAmhkJs7eW9Gz88jnzetHzlg5pLzJGNJZpVRmM96OkZ0NrSPusnVhGfkzvrX2UAFJAkdWljWSgLvX8Ja9Pbw2cmw8UPbuk3xwL7RGHTUim3rQPwazCRT2TxzniPuVIF9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764721736; c=relaxed/simple;
	bh=dW9x22prrDzH7Jgx3KMHnGbVA3Y56oPsWHWZORcaSqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fRw9wgqmGxcjVEjfKQ9XuGFSxmoWNRfuzjHQB8sCXEJGIITxmdscv8kWRC33RPNFJHTPZjDR09sxSsOWBMApQ1E6j0ACtllL0+i4PB9AdHEsPQV8wQNN9+pwtRjJgnHSSiqiekvLZ8POSp3qY0J3Y41Znx0Xdc3Ou8RXfIfvHL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qxjqehQc; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qxjqehQc"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dLdmQ0MjjzlgyZS;
	Wed,  3 Dec 2025 00:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764721732; x=1767313733; bh=NG2IBqtsflRmybShUkUV19JU
	bpmKOR6cD/r663R9MX0=; b=qxjqehQc9uki2sdxck5YezU4kYnN0qpmOktisiFb
	hFutn/lf5/nY7iHb7hcpsdSH13lwuEhnxJwn5rKZ7G/XKC4YA1ndp1eMFw/Owiqc
	4hx4r3sSojCXbC9X3jkn1U/smr2t4CRg0IHy3/9GP/A2tEWWd+3RP5EC2XHe404Y
	3Z7VyP0tE1gGFFTRwuughosSh3SMNctNHMh+KckjsKRCzT5Bf+H6FAhu8pI+yo0c
	DccMCPMLK91qBIgbmA7ZtCLhp+jH/jZvitKG1bz5nLG5oWyMdfXiS5gOhXLb2p3X
	0v5dahyjcg4M5uzDEfg2XXSJRm4a1vJNeezAnDlI3qPQcg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sVaBKuhK_ySp; Wed,  3 Dec 2025 00:28:52 +0000 (UTC)
Received: from [10.25.100.213] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dLdmK0z1DzllB6v;
	Wed,  3 Dec 2025 00:28:48 +0000 (UTC)
Message-ID: <5f04b355-769c-41b2-b3e4-32ca69429dc3@acm.org>
Date: Tue, 2 Dec 2025 14:28:47 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: fix write_same16 and write_same10 for sector
 size > PAGE_SIZE
To: sw.prabhu6@gmail.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org, kernel@pankajraghav.com,
 Swarna Prabhu <s.prabhu@samsung.com>, Pankaj Raghav <p.raghav@samsung.com>
References: <20251202021522.188419-1-sw.prabhu6@gmail.com>
 <20251202021522.188419-3-sw.prabhu6@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251202021522.188419-3-sw.prabhu6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/25 4:15 PM, sw.prabhu6@gmail.com wrote:
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 0252d3f6bed1..c3502fcba1bb 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -895,11 +895,20 @@ static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
>   static void *sd_set_special_bvec(struct request *rq, unsigned int data_len)
>   {
>   	struct page *page;
> +	struct scsi_device *sdp = scsi_disk(rq->q->disk)->device;
> +	unsigned sector_size = sdp->sector_size;
> +	unsigned int nr_pages = DIV_ROUND_UP(sector_size, PAGE_SIZE);
> +	int n = 0;
>   
>   	page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
>   	if (!page)
>   		return NULL;
> -	clear_highpage(page);
> +
> +	do {
> +		clear_highpage(page + n);
> +		n++;
> +	} while (n < nr_pages);
> +
>   	bvec_set_page(&rq->special_vec, page, data_len, 0);
>   	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
>   	return bvec_virt(&rq->special_vec);
> @@ -4368,7 +4377,7 @@ static int __init init_sd(void)
>   	if (err)
>   		goto err_out;
>   
> -	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
> +	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, get_order(BLK_MAX_BLOCK_SIZE));
>   	if (!sd_page_pool) {
>   		printk(KERN_ERR "sd: can't init discard page pool\n");
>   		err = -ENOMEM;

Have the above changes been tested? I don't see any changes for this
code from drivers/scsi/sd.c:

	if (sector_size != 512 &&
	    sector_size != 1024 &&
	    sector_size != 2048 &&
	    sector_size != 4096) {
		sd_printk(KERN_NOTICE, sdkp, "Unsupported sector size %d.\n",
			  sector_size);
		[ ... ]
	}

Thanks,

Bart.
