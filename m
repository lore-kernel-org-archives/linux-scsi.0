Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7B5EAC6;
	Mon, 23 Jun 2025 15:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750694357; cv=none; b=IHBxYver+PKSJgRlb0po7GHV+6UNLQLWu/03Fg1ncF8AxYvLpEPWMLI4ajqsXx0wt2NmKEf+WxE6rRx9D1Qlck75rB9SU+bJNjAVCvyNgM4kEOyOg5/URl6cmxTBAai1Nxq3vClyYSNW5UJ5nwYvvUSUKpRGVq8LPzW4lRleFq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750694357; c=relaxed/simple;
	bh=5SNzJG34BaNHLNojkHzQMSWdy62ROpkWI/bAj3LGaNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cziOfDbnfOx4lgx9AiuRQbgE2cAo6NUXy7QBhoh2FGPeh8jH+3UZFhjAfbuwuf+3D7XXrkFDtLV4hPTuaJ8UEaI8iNcIqzbOmhNLsOt/GJJin2e5M1G3ey8Mx4nAW8Sj49laad68+eI7kNU0UiQPUad5f9r3UgIR7isr665zUIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=F2WccYM9; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="F2WccYM9"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bQt7655b9zm0yQh;
	Mon, 23 Jun 2025 15:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750694353; x=1753286354; bh=cbVOYUXSPTzoe7vacJFqcLVK
	J0SLk5Eu0pKoTubhiBY=; b=F2WccYM9LmTeP2k0Z0w2XDnB7cpL69LkjZMkl9wX
	yGN8+V9fDrUXIjMIj9uLk/Wf3fxM61hm0vidTq+oV7dxnHlfPzeGSt7O4JkoZLgz
	8X4X9OdVhJ+yB5dTLmbvq9h39SfSiNwGMoH+bQd6etHKsxoO2w0HEnwx9DyFocD/
	pL0/qJN3jA598mmusewlpUFJORHeHj0PibGbMfSaKiCy5/FHRiw1yUHkJ1LEZJBI
	KmbZqQKP0qaBs7xNfSR3o4mLqQWP7neYPNoosdYFOGk1rRIHfrSUpR9AcY6BYDFF
	7nmzngznJxwSX/ppZmFHHdcw9vqMnMjK9ml/v5LsWVY9HQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pphezMWeszEu; Mon, 23 Jun 2025 15:59:13 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bQt6z4zdPzm0yt2;
	Mon, 23 Jun 2025 15:59:06 +0000 (UTC)
Message-ID: <57435584-b04e-4de6-908c-018fe48ad0ac@acm.org>
Date: Mon, 23 Jun 2025 08:59:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: scsi_devinfo: remove redundant 'found'
To: mrigendrachaubey <mrigendra.chaubey@gmail.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250622055709.7893-1-mrigendra.chaubey@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250622055709.7893-1-mrigendra.chaubey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/21/25 10:57 PM, mrigendrachaubey wrote:
> Remove the unnecessary 'found' flag in scsi_devinfo_lookup_by_key().
> The loop can return the matching entry directly when found, and fall
> through to return ERR_PTR(-EINVAL) otherwise.
> 
> Signed-off-by: mrigendrachaubey <mrigendra.chaubey@gmail.com>
> ---
>   drivers/scsi/scsi_devinfo.c | 11 +++--------
>   1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index a348df895dca..e364829b6079 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -269,17 +269,12 @@ static struct {
>   static struct scsi_dev_info_list_table *scsi_devinfo_lookup_by_key(int key)
>   {
>   	struct scsi_dev_info_list_table *devinfo_table;
> -	int found = 0;
>   
>   	list_for_each_entry(devinfo_table, &scsi_dev_info_list, node)
> -		if (devinfo_table->key == key) {
> -			found = 1;
> -			break;
> -		}
> -	if (!found)
> -		return ERR_PTR(-EINVAL);
> +		if (devinfo_table->key == key)
> +			return devinfo_table;
>   
> -	return devinfo_table;
> +	return ERR_PTR(-EINVAL);
>   }

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

