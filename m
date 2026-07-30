Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA69044D014;
	Thu, 30 Jul 2026 18:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785435146; cv=none; b=tBAJnR+V9/NSyQZgCxCyNq5uMPho5jPJ7gBnbNfCqx3Bs8Wh+B+la/UAh3zG+jzI9mLbcodu5TjdYADAsY0fbGO6h+c9mAISMICXVI7bsTh7e+HjVn20ED9NiOoZbaQ5qqg9rvIiGQCTqrv0AOzomdgYMYWpDaTCt6/BvNqeMrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785435146; c=relaxed/simple;
	bh=VqIBzMlq6g/GF90hWklXyVwZdMG3V9O90Aa4LNPkUKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RsW86uA6Cf4HdH7iw/pIYlVP6OcvIpsiD7WtKw7Wr0iR9BzkXlLTIZhi9BOgH9KZU8Weka4SoI6kvhWPNo6f8K05rF0Vn4VOKhVL3S+hxE6WP1Q4Wk/gMvo6HxbfzGQALBIOXh/lS7Qk66QiVddJ92tO9GlgsItb3Tg0ENWik7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1ln0goUR; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1ln0goUR"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h9y2w55M1z1XM30r;
	Thu, 30 Jul 2026 18:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785435123; x=1788027124; bh=VgOPnCn0QfsKXXm/BbAFOkYo
	OJ9TBZV9wxb2GZjzcNg=; b=1ln0goURqEoiSjiIrBXgTptQuPHYZruBVoPtrczb
	ZXpDmWZoJbXH8576L/wwRx+ljaV+RkY5ygEK5WCCqeyjTueglCrQYVP0TS2tvOto
	qgv/TgZMz/AqTyOh/KAmTq63UC/lQxHfeGot8pqqpKyq697MrjZTLmoiIFIc2xpI
	0U9ico5jqQjyhv4LnciJVJ18xjnsRxbmzz/f07cYtOXS94aIuDKnviXctbqB3EWu
	vJppC7aF5KpKKjw2vbICg0TaDKlEsS3q6s3lOOeem8/0KSy40/VMiOOKHeP1rSPk
	i4i4pyprTkk6ox84sWkjZk+6LQt+X/QfrljlFtzIniJY9g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ikeQ2MZlq-9C; Thu, 30 Jul 2026 18:12:03 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h9y2n2Ftzz1XM4TB;
	Thu, 30 Jul 2026 18:12:00 +0000 (UTC)
Message-ID: <2b168ec3-a5c5-43c0-88fd-048ac80bfbe9@acm.org>
Date: Thu, 30 Jul 2026 11:12:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: do not block on tag allocation in
 scsi_eh_lock_door()
To: Zizhi Wo <wozizhi@huaweicloud.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 yangerkun@huawei.com, chengzhihao1@huawei.com, yukuai@fygo.io,
 wozizhi@huawei.com, zhousiqi5@huawei.com
References: <20260723041238.1584632-1-wozizhi@huaweicloud.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260723041238.1584632-1-wozizhi@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/26 9:12 PM, Zizhi Wo wrote:
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 147127fb4db9..3d42fe7701b7 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2139,11 +2139,11 @@ static enum rq_end_io_ret eh_lock_door_done(struct request *req,
>   static void scsi_eh_lock_door(struct scsi_device *sdev)
>   {
>   	struct scsi_cmnd *scmd;
>   	struct request *req;
>   
> -	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, 0);
> +	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, BLK_MQ_REQ_NOWAIT);
>   	if (IS_ERR(req))
>   		return;
>   	scmd = blk_mq_rq_to_pdu(req);
>   
>   	scmd->cmnd[0] = ALLOW_MEDIUM_REMOVAL;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

