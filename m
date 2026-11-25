Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.71.155.67
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795589967;
	b=icjxcGGHumylZd0rH7UStdmwiRsMYX8F+UyGNIRf+uSg/TEkJd4fFywJprzlZ1WUcgk+
	 MwtcqYor9pFXWR4Y6V4hCYdC2rRNBBWI8VYD+zydafcLHFxU4PDeSjoRMWN16JYVjXYDJ
	 yvmVa6FzrB/E69+i0PZ1+InSVJauTQOi5nETqLRgl42fObkskrKDPiOQrZH8VMvoxyTeV
	 ZAUY66y/SV7LVEHCs4kpdSsSLrCqi3p+faz6Fq9JkNnIcwB1OtydTlm6xuXjy18y2tj4r
	 witFWtSYHPHnkUF3IiH+izZJ+sRC/tTQF5GKp8+b5taHa8U4Ge43p6mT8HIa/Hq3yFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589967;
	h=DMARC-Filter:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:X-HM-Spam-Status:
	 DKIM-Signature;
	bh=zWgMaVlUK+pEGxYO/yLxMYqPp5g9P1N6B10aXl4L3pU=;
	b=Y0UdbCWVvkYQ78reMZeK6ehRKSowDKapomhthA/UyCpILsoTaBCpsbxeBqdwWaGMSuX9
	 sVNFd6Wt70ziN1ZlR7ad0ABtP3++Dnj18td/fzNSaf7ceV1HXC5PxtnsA6TZhlN8g5fvu
	 Yjdr3XOaJxleqncWC5Q+BJfYYIFi7NeT/tWz4dO5DkF8AFyWEf6vzneKBNorWmG1Qpjfc
	 2hD9cSRSpCioGfTXKnTM3nNVDvZlcgZGOkudT+YmzctznMwY8Oy+Dgvt7fXG0T65foYVl
	 EAm1f9g9wLzV0RN7U78mSh0GhLG7fmsPAb7HPTLOteg/csU8DaTYrT//05LXlZuLP6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=leap-io-kernel.com;
	spf=pass smtp.mailfrom=leap-io-kernel.com;
	dkim=pass header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.a=rsa-sha256 header.s=default header.b=QO4evdgi;
	arc=none smtp.remote-ip=101.71.155.67
Received: from mail-m15567.qiye.163.com (mail-m15567.qiye.163.com [101.71.155.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8CF606A31E
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 06:59:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C8CF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.a=rsa-sha256 header.s=default header.b=QO4evdgi
Received: from [10.0.66.4] (unknown [222.130.22.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 55edb2e26;
	Wed, 25 Nov 2026 14:59:14 +0800 (GMT+08:00)
Message-ID: <0af6c5dc-56af-4882-a3d9-609586925e9d@leap-io-kernel.com>
Date: Wed, 25 Nov 2026 14:59:13 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: leapraid: fix off-by-one in reply frame address
 validation
To: zhangchujun <zhangchujun@cmss.chinamobile.com>,
 "Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, Kees Cook <kees+treewide@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20261120083000.1961-1-zhangchujun@cmss.chinamobile.com>
From: Dongdong Hao <doubled@leap-io-kernel.com>
In-Reply-To: <20261120083000.1961-1-zhangchujun@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa211805d2a03aekunm0e00b83a9fab7b
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSktNVh4dGhkdHU9CGhpPHlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkhLVUlJVUlPSVlXWRYaDxIVHRRZQVlPS0hVQk
	JJTkpVSktLVUpCS0JZBg++
DKIM-Signature: a=rsa-sha256;
	b=QO4evdgiyMLO7V2Yrm0vs2dIizh1ZwHBmtOrnGo9O+1+1JRAHwqs0/PbxYJWuZplRx53Icer9H0aflZLN/WmAQXT3SzwaxYGN3817TnFmat3jNrpne2ENGky0SvZL65wfXt2HrIK9e2yGoZqZorVvf02zFuL0Epp7j2CXSFkdomdIu3cIkjgyE6YTOI+eC4QMERp8myFVRQ2/7EkToAN3jTcd4F74lh0MfZ46wa9RGul2gXzX8pmQIo2V6mWxxe9rD8A+z9Woax3kQRFdLfIadB17rw8tp+M+CAtZgdV4Nto8gLt/tKrEp5jORgTzU8SMNCUIWMa0LSkct4cSZQZMw==; s=default; c=relaxed/relaxed; d=leap-io-kernel.com; v=1;
	bh=zWgMaVlUK+pEGxYO/yLxMYqPp5g9P1N6B10aXl4L3pU=;
	h=date:mime-version:subject:message-id:from;

在 2026/11/20 16:30, zhangchujun 写道:
> The reply message buffer spans [rep_msg_dma, rep_msg_dma +
> rep_msg_qd * LEAPRAID_REPLY_SIZE).  The sanity check on the reply
> frame address returned by the firmware uses a strict "rep > end"
> comparison, so a reply address equal to the end of the buffer is
> still accepted.  leapraid_get_reply_vaddr() then computes
> rep_msg + rep_msg_qd * LEAPRAID_REPLY_SIZE, a pointer one past the
> end of the buffer, and the completion path dereferences it, reading
> outside the DMA allocation.  The out-of-range address is also
> written back to rep_msg_addr[] for firmware reuse, which would
> make firmware DMA into memory beyond the reply buffer.
> 
> This check is the only guard against an out-of-range reply address
> from a misbehaving adapter, so make the upper bound check
> inclusive-correct by using >=.
> 
> Fixes: 5597088c9e79 ("scsi: leapraid: Add new SCSI driver")
> Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>
> 
> diff --git a/drivers/scsi/leapraid/leapraid_func.c b/drivers/scsi/leapraid/leapraid_func.c
> index 573bccf1a4ce..c54797e22e74 100644
> --- a/drivers/scsi/leapraid/leapraid_func.c
> +++ b/drivers/scsi/leapraid/leapraid_func.c
> @@ -5667,7 +5667,7 @@ static void leapraid_request_descript_handler(
>  		break;
>  	case LEAPRAID_RPY_DESC_FLG_ADDRESS_REPLY:
>  		rep = le32_to_cpu(rpf->addr_rep.rep_frame_addr);
> -		if (rep > (u32)adapter->mem_desc.rep_msg_dma +
> +		if (rep >= (u32)adapter->mem_desc.rep_msg_dma +
>  			   adapter->adapter_attr.rep_msg_qd *
>  			   LEAPRAID_REPLY_SIZE ||
>  		    rep < (u32)adapter->mem_desc.rep_msg_dma)

Hi Chujun,

Thanks for spotting this issue.

Changing > to >= fixes the off-by-one error, but the address validation
is still incomplete. The upper bound should be the starting address of
the last reply frame, and we should also check whether the offset from
the base address is aligned to LEAPRAID_REPLY_SIZE.

Moreover, the current handling of invalid reply addresses is
insufficient. An invalid reply address from the firmware indicates a
potentially catastrophic failure and warrants more aggressive handling.

We have reviewed the driver and identified more than ten issues,
including this one. We plan to address them together in an upcoming
patch series and will include the following tag in the corresponding patch:

Reported-by: zhangchujun <zhangchujun@cmss.chinamobile.com>

Thanks,
Dongdong
