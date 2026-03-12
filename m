Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BDA38D690;
	Thu, 12 Mar 2026 19:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773344512; cv=none; b=cd7hWFwI4Tf8V2qhxiDvpY8InnyH6t90BOEtO6TCUVKYUB7DmFprHr1Vl4G1qd1nAuuTFNgBafQp4HxlnymgX4eXX1MbAF8Xa34sgw8Peb5GuUXyiDHWVo+CnrhaRG+TmMuwKKGaDBRLYwoXd2TGMbyOtvPSyBlj7tc+x+LqTxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773344512; c=relaxed/simple;
	bh=OGAEmeGHIL9eZf2akW4AqFCYKzgonLb++ag85Acwi5k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hZ36F2BWFcohycffNTX/rYladff2SOwbvLBYy7NPkz3PlsJ7+hk/f171pqAw3r2XWR/0HnwgUOZ8oYMwcMX0H/ViJUNLYHBhZVSvFodYpRiQM3j0H7j3KbzByPtQ1JUau4gcl2tChS91YY/SNCpjWVF1jGSKtZwifBukkA2620k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IPlFneW/; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IPlFneW/"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fWyg03xT9z1XLyhK;
	Thu, 12 Mar 2026 19:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773344504; x=1775936505; bh=TRPRSoj7XGjlCwJVmQKqfy4p
	weWzylLFBG/ocmFU5Mc=; b=IPlFneW/e8zUyACNkzvamvTFj7DU1hDUxvtN1iHp
	rgYP4cO5fjtE5VyqiTG5dias/er7l32w38jig6AjcCSsbO1/t1k1+lzkYu6KZRyI
	LWMnd82foC2WpgJfw5IpwGt63z2ItDyEc66i0wOjxlSr7qXTroBd2j+imFLCmJsU
	JR2Scd5qNUQlQOueK+0iGMh1yxyJSCGPIt1iLuJVO1MKi1cV2c+Jb8oMruMwVQYA
	RvY+iwVCwt0R/R3Dm53ndA8R2BUGPv0vTAbWuAPRCwQIYIDraczfado8EOyzrNbZ
	o99uy6I5AFosXS9o90nlSnomRTsXqy8Cf3+7c956WuEA8w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FKubJJEF-M-X; Thu, 12 Mar 2026 19:41:44 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fWyfv1fCsz1XM0ns;
	Thu, 12 Mar 2026 19:41:42 +0000 (UTC)
Message-ID: <e6167003-82e4-4814-9e11-d1609681b5a9@acm.org>
Date: Thu, 12 Mar 2026 12:41:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/3] scsi: bsg: add io_uring passthrough handler
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, axboe@kernel.dk,
 fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260312092237.2464560-1-yangxiuwei@kylinos.cn>
 <20260312092237.2464560-4-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260312092237.2464560-4-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/26 2:22 AM, Yang Xiuwei wrote:
> +/*
> + * Per-command BSG SCSI PDU stored in io_uring_cmd.pdu[32].
> + * Holds temporary state between submission, completion and task_work.
> + */
> +struct scsi_bsg_uring_cmd_pdu {
> +	struct bio *bio;		/* mapped user buffer, unmap in task work */
> +	struct request *req;		/* block request, freed in task work */
> +	u64 response_addr;		/* user space response buffer address */
> +};

A static_assert() that verifies that sizeof(struct
scsi_bsg_uring_cmd_pdu) is less than or equal to the size of
((struct io_uring_cmd *)NULL)->pdu seems appropriate here.

> +/* Task work: build res2 (layout in uapi/linux/bsg.h) and copy sense to user. */
> +static void scsi_bsg_uring_task_cb(struct io_tw_req tw_req, io_tw_token_t tw)
> +{
> +	struct scsi_bsg_uring_cmd_pdu *pdu;
> +	struct io_uring_cmd *ioucmd = io_uring_cmd_from_tw(tw_req);
> +	struct scsi_cmnd *scmd;
> +	struct request *rq;
> +	u64 res2;
> +	int ret = 0;
> +	u8 driver_status = 0;
> +	u8 sense_len_wr = 0;
> +
> +	pdu = scsi_bsg_uring_cmd_pdu(ioucmd);
> +	rq = pdu->req;
> +	scmd = blk_mq_rq_to_pdu(rq);

Please combine the above three assignments with the above declarations
since that is the style followed by most kernel code.

Otherwise this patch series looks good to me.

Thanks,

Bart.
