Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47582285C9F
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2025 16:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750868762; cv=none; b=ulxFVL0a8aCyuj7skFrzS8yiZwEwo+Go5AK1Wc8UwNcU3FDihApVzKiKt6eXixZX+HtaHd54xOed6QuZHibQqqKEKr915fzUn8VDOU4XO/wq9BDd+43jbGBz0lbbCmApnFdsWyvbgLTEC2Mk9M8Vx+wvAx/P4eGQQ0GvEJ8JRu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750868762; c=relaxed/simple;
	bh=tohoq3Akr9PfWJJu3GBflvEivwXHfzc3aI5sZDkQ9zw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FC074lY1fPYd1nZAPLQFDdtpLFj+uPcEQrt3vaEfziqMkrOMqbxKBmt+mcUnTCDE7B8ipj7+wGQ2oNwehSIr/Hgr0ZIk/qXba08o3Bh7AAPQ6FFOivC0yV43eRLRQAQUJB/pfw0htKlLkvEHy0YnYa9R2MVWD2JiPA543bCjqEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kyFAr1Sv; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kyFAr1Sv"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bS6cy4l5Nzm10fx;
	Wed, 25 Jun 2025 16:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750868753; x=1753460754; bh=JSK6ggqszwofTVHdTzOm5/yi
	hdTgCH+85CuMKidBgM4=; b=kyFAr1Svh/2ykqTQ2mYDGFoz+bwIbcObFPV53ZZg
	iHs8+/2+s7neVw9wV/UiPQIQZzeIn6n9xiLFo5W7jEvtNXVzS5razcc0dQi9zmwn
	oTexOQm1Q07lgiIWweXAO9fpmG7F9GQVJ4Y5moDI3WN+M+tCQJTYK/1j+7/bzRJq
	6fqyyum3Q5KZZubT7XvYSWxl9Y2DkofUNCLKDooiWRDewziqntz8rWjZfOatPwxz
	4AvERPYSzBBifWn90ljoLymUB03c3cqNH8igm+z/aX35PSvynY01fmRnC2R2nv95
	mf++JxKokBLZBvo3goXte0IADnUBa+096vrKRJGfYwW3Dg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LEuqNG5TfMvb; Wed, 25 Jun 2025 16:25:53 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bS6cv3szrzm1HbT;
	Wed, 25 Jun 2025 16:25:50 +0000 (UTC)
Message-ID: <41c2cdfd-d6ed-4c89-9c44-0be10b870292@acm.org>
Date: Wed, 25 Jun 2025 09:25:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Improve const and reserved command handling
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250624210541.512910-1-bvanassche@acm.org>
 <ee6cc070-fb9c-43d4-9c43-827424e6adce@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ee6cc070-fb9c-43d4-9c43-827424e6adce@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/25 9:06 AM, John Garry wrote:
> I seem to remember seeing some of these patches before. Am I right?
> 
> If so, what's the history? Has anything changed (in this series)? Were 
> RB tags dropped or not picked up?

Hi John,

Yes, these patches have been posted before. Last time nobody replied 
with "Reviewed-by:" on any of the patches in this series, hence no
Reviewed-by tags in this patch series either. I'm splitting this patch
series because 24 patches is a bit much for a single patch series:
https://lore.kernel.org/linux-scsi/20250403211937.2225615-1-bvanassche@acm.org/

Other than rebasing on top of Martin's latest for-next branch, no
changes have been made in any of the three patches in this patch series.

Thanks,

Bart.
