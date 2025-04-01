Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E8F20CCD9;
	Tue,  1 Apr 2025 16:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523213; cv=none; b=pMz8Js99KwkJYCGh7BkhnrP1FADm6B7LDD/XEzjnOFPgpJPAyYVx0DCWrokhsAuFjpaYUqeSND+rpUlD7RAO86sl6bQShhaW4ZIKPyoLNmBp/Tq/klXOxDcWdAVr5zwxJtcyGcWi7S5AXfDb/BG9e7u07zbhGvozYhWQQ+kJsJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523213; c=relaxed/simple;
	bh=lc6jSF/+ZIEk/mYgKrG6A83DJ0xS4vT6C5P13lbv1R8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fNE0pBQj+ISQafjwdievohRTD7VnC8Vd0GUHsmvwZApbknThcv+7Pn26mzLv2BvwItSFD+OkVCVSnfMnPrt4nA4fgVZ3XSydpJG8E2hERsUCAAw/WoBoylG6i6gvLnDIQHVEFbfUqfEWp82JpcvLNXtHDHccKpbZUAhohika5LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=D8FypTYp; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="D8FypTYp"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZRt4M6J2Zzm1vc5;
	Tue,  1 Apr 2025 16:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1743523202; x=1746115203; bh=tWRoujeYC9/c2Ji8LnKtFcJY
	2iV/XlepEshuTed+HgQ=; b=D8FypTYpJfiLLwAPMurg+zgX6qvC8FQk+CI8Y5XT
	2liRCYdImHPRxtVll7yDtaHqby6gM+AvPFzjM3ywWAlFCK6quFmevEven0tHTmpc
	6CuGv6Lby9cDFhirV136SHdUfss1IdPHvTagVzt+AQW8mwLuzaoiinU5TC7xdHe4
	r/FfYivcu5N+EXJGl6QKOIY/iaukFZQglj45INmXPj35J9hTCv0Mupeb7MakjBix
	7JGRV6pvCamYyVcvAXhwi4ZNm4ho1fH8J0wEZIWLfjN3hdTDZ20miuRaARb9t/M9
	cKPa7K5crcXwczLDf85Q5o98x3zSN1AuJ/xFsAKM2DLh3w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mipLsTmRhWb4; Tue,  1 Apr 2025 16:00:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZRt4B0LLSzm0yVQ;
	Tue,  1 Apr 2025 15:59:52 +0000 (UTC)
Message-ID: <93e62d17-81df-454f-9e35-7cede36bc162@acm.org>
Date: Tue, 1 Apr 2025 08:59:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_transport_srp: replace min/max nesting with
 clamp()
To: shao.mingyin@zte.com.cn, james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, yang.yang29@zte.com.cn, xu.xin16@zte.com.cn,
 ye.xingchen@zte.com.cn, li.haoran7@zte.com.cn
References: <202503311555115618U8Md16mKpRYOIy2TOmB6@zte.com.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <202503311555115618U8Md16mKpRYOIy2TOmB6@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/31/25 12:55 AM, shao.mingyin@zte.com.cn wrote:
> From: Li Haoran <li.haoran7@zte.com.cn>
> 
> This patch replaces min(a, max(b, c)) by clamp(val, lo, hi) in the SRP
> transport layer. The clamp() macro explicitly expresses the intent of
> constraining a value within bounds, improving code readability.
> 
> Signed-off-by: Li Haoran <li.haoran7@zte.com.cn>
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
> ---
>   drivers/scsi/scsi_transport_srp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index 64f6b22e8cc0..aeb58a9e6b7f 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -388,7 +388,7 @@ static void srp_reconnect_work(struct work_struct *work)
>   			     "reconnect attempt %d failed (%d)\n",
>   			     ++rport->failed_reconnects, res);
>   		delay = rport->reconnect_delay *
> -			min(100, max(1, rport->failed_reconnects - 10));
> +			clamp(rport->failed_reconnects - 10, 1, 100);
>   		if (delay > 0)
>   			queue_delayed_work(system_long_wq,
>   					   &rport->reconnect_work, delay * HZ);

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

