Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5F431B822;
	Wed, 19 Nov 2025 23:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763593760; cv=none; b=jcAnARb/T4BB7WaNtRTSEThJKycu1mKpOFBHCwz+5ghhzkTRz7/+7tmD5zef054EB9QuRyPzsqjXkv/+aUogt+lwAT8xZRiujjUup9lLDjlhDqrTtOAAB8lhfTDe4Dxyx5iM+BD/cZOMk/wGq+PFwDf3vhnRd58aAp/gCCr+yWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763593760; c=relaxed/simple;
	bh=48U3P296JngEYZDwTM1DjxIEBD3kVyCsdLXj322BcB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PRPWoBQWzEBi10a5h7Qp7iWbHh0CATYvZnlroLHy0kwKZI7T89Mhm48dsCoGIZpTnZslOk60P+Y6ynqkQNkD4f0WOTm62Bmzc0c1exJ/V7Zs9OWqLn5N37IGvwO9j6I32jV1GowY5/tQsy89txkKDENhEPQwei7wvRKxFTUhqXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3d1LRML4; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3d1LRML4"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4dBccQ2mDfzlvBxP;
	Wed, 19 Nov 2025 23:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763593749; x=1766185750; bh=koVPuGOvUsw69MMbphSKyma6
	aYRpMsCzH/YNtIFlZx8=; b=3d1LRML4gWV4OZjTJS9ug+nYzEi/2AnhGMQ5bSV2
	vHHQFDX4ssxLpNNkNEi/C13GRfpY5NAnRovfbFq9QCwlo2Hc5VUWWlHtBlDodHdD
	Tf6x0DpVM2wrzkRfXBPKLHZWHjZ87Xs1M9Z5YIlCKGAVb1QKzmNfD8SIBFPmt9cY
	WRHnwmUxQvCVmgimTITgmaphh2S31omjj6e85iWhTrb/fPXAb5YxVnd5HNbAnb8Q
	mVXN4PyJg3dXVZstt5YtBtRIRC9PkR8idP1LL0K4FWVZHxh7PK1xnbDClw5o0OXh
	4cRlVVX5lGU+XFuXAoNJqKldgz+IGmAaDIzLe2qGFCro4w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oATAiD0aMpiL; Wed, 19 Nov 2025 23:09:09 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4dBccJ02BpzlvDRD;
	Wed, 19 Nov 2025 23:09:03 +0000 (UTC)
Message-ID: <2a8c62e1-6e29-4ac6-b661-7b5ec1763288@acm.org>
Date: Wed, 19 Nov 2025 15:09:02 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 26/44] drivers/scsi: use min() instead of min_t()
To: david.laight.linux@gmail.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
 <20251119224140.8616-27-david.laight.linux@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251119224140.8616-27-david.laight.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/25 2:41 PM, david.laight.linux@gmail.com wrote:
> From: David Laight <david.laight.linux@gmail.com>
> 
> min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
> Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
> and so cannot discard significant bits.
> 
> In this case the 'unsigned long' value is small enough that the result
> is ok.
> 
> Detected by an extra check added to min_t().
> 
> Signed-off-by: David Laight <david.laight.linux@gmail.com>
> ---
>   drivers/scsi/hosts.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 17173239301e..b15896560cf6 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -247,7 +247,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	shost->dma_dev = dma_dev;
>   
>   	if (dma_dev->dma_mask) {
> -		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
> +		shost->max_sectors = min(shost->max_sectors,
>   				dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT);
>   	}

So instead of the type cast performed by min_t() potentially discarding
bits, the assignment potentially discards bits. I'm not sure this is an
improvement.

Thanks,

Bart.
