Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D83199E89;
	Fri, 13 Mar 2026 15:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773416070; cv=none; b=jqOY9L9TJ7tOjz1LKvdX+27t0YE2ruhIJQXIO5flqOD3uCLgqkeC8N/lsOrOkBwokmakU+h9NLS8oDDQb5qqcVs+nAs+65liVOwl1c2vXxLK8zlf10/IPKSzc1rvyQxuNRN11stvLt/365Zqn0afFq1U2xV5StBG7a1omCn5I0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773416070; c=relaxed/simple;
	bh=2wKd1sNaYC7m/ZxufJJ7RxLHcjeH6oj3MOhyWumYy5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QYn+YlotOqk+frA2w+FYHui1zIdnu/SpeKdesXMnlYCFYC1zS36AwbjC9a5aQ8FBbovfJqhE+8hVKn8+RRrd1ZL+5FQsatrfjCArArjB3FKhx7PClim1qMrfwyRImNRMNBKRx7SxysZQWcaPZy9M60Y6wf9svxfctW3vYSj+DNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=W7DVqOUc; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="W7DVqOUc"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fXT782fGbz1XM6JH;
	Fri, 13 Mar 2026 15:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773416064; x=1776008065; bh=WQnbIMKyp5TiZs3eFTjZI2dY
	rCOP0Gx2eTdJ2zaGR3Y=; b=W7DVqOUcg137+H6v+KhZunKkim2ou+jySp8hUrl5
	1Jju9wW3F/AgviO5qnRgs8b7zye89bWQ3D34vwyyeyr3j+XlB5zeSgW9qw/BjfK+
	dhyj7QY4YCPaksUP8qye6XZyfE3VeKlDIrLHzjfpzFggsorEfG5iU5fnemgSUqMH
	9DLTxMm7bNQPtl38fDZl+RnHTv0sZiDrqYLFfH2T4C9B12xwNsKrKoct2SUDYqAF
	CH8DGmKs4NSrkaJGQRIvzoXaIvCC+DmLjG4eZa8htCLuzPOXFFv7dncsy7HC1/X1
	YSypBaK9EJ1kSrcP4CrLb63J9sNT1FSUeyjZ85je2rHGuA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 984WlDcOHD1F; Fri, 13 Mar 2026 15:34:24 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fXT732qGqz1XM6JB;
	Fri, 13 Mar 2026 15:34:23 +0000 (UTC)
Message-ID: <79039bac-3785-41cf-8277-c120e3e475fa@acm.org>
Date: Fri, 13 Mar 2026 08:34:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/3] bsg: add bsg_uring_cmd uapi structure
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260312092237.2464560-1-yangxiuwei@kylinos.cn>
 <20260312092237.2464560-2-yangxiuwei@kylinos.cn>
 <574620fd-903b-4fd3-8cbb-22a3cefda645@acm.org>
 <20260313073415.102437-1-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260313073415.102437-1-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/26 12:34 AM, Yang Xiuwei wrote:
> 	/* include/uapi/linux/bsg.h */
> 	#define BSG_URING_CMD_SIZE	80
> 
> 	/* drivers/scsi/scsi_bsg.c */
> 	static_assert(sizeof(struct bsg_uring_cmd) == BSG_URING_CMD_SIZE);
> 
> Does this arrangement look reasonable to you?

Wouldn't it be simpler to add the following statement just below the
struct bsg_uring_cmd definition, or in other words, not to introduce a
new #define?

	static_assert(sizeof(struct bsg_uring_cmd) == 80);

There are already static_assert() statements in uapi header files:

$ git grep -nH 'static_assert.*sizeof' include/uapi
include/uapi/cxl/features.h:22:static_assert(sizeof(__uapi_uuid_t) == 
sizeof(uuid_t));
include/uapi/linux/media/amlogic/c3-isp-config.h:516:static_assert((sizeof(struct 
c3_isp_params_cfg) - C3_ISP_PARAMS_MAX_SIZE) ==
include/uapi/linux/rkisp1-config.h:1617:static_assert((sizeof(struct 
rkisp1_ext_params_cfg) -

Thanks,

Bart.
