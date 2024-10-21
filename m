Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307691C8FDB;
	Mon, 21 Oct 2024 20:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729542310; cv=none; b=ikf5BGrT4Wu29NcoK1xX0Iw8aGpPH/ALmWqArU3uJlHVA27F3L/aDcaj2aK58ilm2NHmYAmSE4OS+k8jHCaz/0E/xIdbsULERC5J93LDYfkzedPX2OPIDcXcaPmsDPRHTKwiBdP79DrwT+qnWH0+NRUTeqdr6uTia0yVB9hBc+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729542310; c=relaxed/simple;
	bh=9/hEhE0kpn+mNE23bKhJr31F7hzllVC5kzkxxDHeOkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DJK/7w8WQ934FN707n3wJvWNgpOKBx/63YPeAGIYTcXuWaheLRdVUgUDHN+tbO55o6GgR7pzUTrYuuRT1lxiBP7cU7AAvKKcjOUXzLKlvHvHFzR6Hw+7RXVT+XDOLPQ3Q4E8+diHCon99NEWpY1X6lSNiqjJ0EKLQpxJJ6D8bdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=J40DCVFH; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="J40DCVFH"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XXRd03s4Vz6ClY9Z;
	Mon, 21 Oct 2024 20:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729542306; x=1732134307; bh=yFes3ZDx7SUNI0ZMXHxxaGR7
	tjfjuThQed+2gV7ibGE=; b=J40DCVFHfY8tZSkr/XiDUS67hpTySfz8PUe2JQ3j
	fqt/ViTQ1VDMMIqZDpXXne17IaT4WB4y6sheNRlYiuZaveIDbGxXic6DUfi19nn1
	mvFTLaqey/mVCtJ1F7Sd2agIbCwLguSbiYVAeKsV1SAnvZNuHYmvLD5yBz6dsNVI
	/6S/SzBoazWiAuH4YA03VDpmi1X6/2axhJIYzKh/zW9H4E/kiR8nrU9TglShwcQK
	gq1Sr/sOVp5MqtioquIgzoGfc3W7QxXS/PLNtW2HgFeKkNtgAeoqrdgp1HDg9VKd
	T2HiaQSuQmPsI/Z0LwQVgpNCpx2JHl/j3oTTOOLXcNBQwA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qCLuS9reAAgn; Mon, 21 Oct 2024 20:25:06 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XXRcx1fnQz6ClY9V;
	Mon, 21 Oct 2024 20:25:04 +0000 (UTC)
Message-ID: <a20841e9-4ec3-4965-8563-3b82673313c4@acm.org>
Date: Mon, 21 Oct 2024 13:25:03 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] scsi: ufs: core: Use reg_lock to protect UTMRLCLR
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241021120313.493371-1-avri.altman@wdc.com>
 <20241021120313.493371-3-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241021120313.493371-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 5:03 AM, Avri Altman wrote:
>   	if (!test_bit(tag, &hba->outstanding_tasks))
>   		goto out;
>   
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> +	spin_lock_irqsave(&hba->reg_lock, flags);
>   	ufshcd_utmrl_clear(hba, tag);
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	spin_unlock_irqrestore(&hba->reg_lock, flags);
>   
>   	/* poll for max. 1 sec to clear door bell register by h/w */
>   	err = ufshcd_wait_for_register(hba,

Hi Avri,

ufshcd_utmrl_clear() performs a single write so I assume that calls of
that function do not have to be serialized?

Thanks,

Bart.
