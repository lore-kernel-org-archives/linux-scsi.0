Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87EB15573A;
	Tue,  6 Aug 2024 20:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722977525; cv=none; b=POdlYszz2f8vmRmo16EFV+0EDpRWZVTs4ELjHX3jW7Vcd36GCrBTRJ7jgodZnmh5BQk0XX7oh0KTKflMZv8VLLDJxvAfIrGv538U4F/0kCH9/W0SWRAcY+G8byQ5VRbPfBNAGzxh8k+bXN3pQVrQFDP/tKcuB4/DEWOHAiexKfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722977525; c=relaxed/simple;
	bh=054adm5On1TcrOnzuiAosPaG16jV+lTzmrxWFBHnL1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f9ggAbWN1LKze+mb7tJbSxtwUAqFGyDu5wBQwuRosyRV8AQKNbqiUXPeJSuDFp3w6yy+aYbVboXaWsUpuH4j1SvwyGDHaHnfkM3I6K5bHbFACeaebahdWf+XOP7iy1Ujvhvqp/8pQto43wcQzWGFcAUyxk0/iSfAnKdHiUJgv8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=V+T3X5uX; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="V+T3X5uX"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wdlq11Y8Qz6CmLxY;
	Tue,  6 Aug 2024 20:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722977513; x=1725569514; bh=m7C0xSF3jS1w6upvBOrj0wW2
	HoCfsEi5eEfNVL4N+8Y=; b=V+T3X5uXuLfP9RSSRcaky3DmPV2YDHoNimWHyhwp
	hB2bi7766lEvHmgtwnTsrsvYY3WO+UMfjQfGM51ZLiNZZgU1+vnsT6vQ3/7P/ewz
	JK3acz3Ym1VKWln2IrkgvXGYlJy3SVNh7D8ipZ1NYCuf0zC6hosGJvFffrJLxrVc
	RU8FbK46hKw+vYMI0lcRbF7oERjVJ0krayfxhRCUx1v/GrCt7HLO3sofVsNDjGUn
	Q0BrRkRhlQ4Q5ieWYb2BCxDjCZ2AVJrtB+1hOOnb8IGkDPPA/j22xIButarwcJsd
	a8u09g9NQCzdaSVuykarvC8TPXkUr/S7Sak7+c1xL+Vfrw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ytJDuSmLeJFh; Tue,  6 Aug 2024 20:51:53 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wdlpt35cVz6CmM6X;
	Tue,  6 Aug 2024 20:51:49 +0000 (UTC)
Message-ID: <126b79d8-6451-4e86-9df5-189f19eb121e@acm.org>
Date: Tue, 6 Aug 2024 13:51:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: fix the return value of scsi_logical_block_count
To: Chaotian Jing <chaotian.jing@mediatek.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 srv_heupstream@mediatek.com
References: <20240806072714.29756-1-chaotian.jing@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240806072714.29756-1-chaotian.jing@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/6/24 12:26 AM, Chaotian Jing wrote:
> scsi_logical_block_count() should return the block count of scsi device,
> but the original code has a wrong implement.
> 
> Signed-off-by: Chaotian Jing <chaotian.jing@mediatek.com>
> ---
>   include/scsi/scsi_cmnd.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 45c40d200154..f0be0caa295a 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -236,7 +236,7 @@ static inline unsigned int scsi_logical_block_count(struct scsi_cmnd *scmd)
>   {
>   	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
>   
> -	return blk_rq_bytes(scsi_cmd_to_rq(scmd)) >> shift;
> +	return blk_rq_sectors(scsi_cmd_to_rq(scmd)) >> shift;
>   }
>   
>   /*

Please add the following to this patch:

Cc: stable@vger.kernel.org
Fixes: 6a20e21ae1e2 ("scsi: core: Add helper to return number of logical 
blocks in a request")

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
