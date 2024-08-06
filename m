Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F461EB2A;
	Tue,  6 Aug 2024 22:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722981674; cv=none; b=kbCgT8aRUzsjo6hc0FPYKwK+tTh/lLxzUvlvPZKbBYYPKIJDz77So0GEz99QlFhfOaeHrHU3+1wJbhTvM4fYemPRfW6B+CdQ2bTyIDyzCQjae/C3Ufn/O7pAp57EKph396SUFGJDtmy09BRNQzlvXeeaH6gEHPgQKN6Sw0T6XiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722981674; c=relaxed/simple;
	bh=YzGHFLSczEZof+ZrHCV6tpPAOXfsyKh+aK37V2+LBnI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wq45Pk1debAp+pwuVgfEbqpZIjsc27VPdF63r0S7vS9TUgof0dQgs5n5YFMl68AsNr1cTYmUkGRHY7/jPPqwDBhO1qPOguFReSdUAbYvih+dp3sD3nKko/x7iuZHE0Dde8GK4LzatpvA+f+jVAVL9gemXUT6vuGHvMH7rVdDy6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iSlVBouB; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iSlVBouB"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WdnLw0M1Kz6CmM6f;
	Tue,  6 Aug 2024 22:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722981670; x=1725573671; bh=TsqYDRgOLG1l9c2F+PH7EiGq
	6L+Bpl6dpeJ91CkPK8o=; b=iSlVBouBS63a+24K+kX12Z5kaMOC1ZNUd3kEpXyS
	IzGpgtXgQoUsqXgeLXjZqn65WhzgiqXMpiKCf4gFYgxzkBMMH0v81nW3zT62epIh
	Z/dWD2nKAh3yF+qeXQotLi7cLVS9sUOQX6p3q56H1ChPhWhTTm6D9EcqIhlUg0xQ
	2QvrMSJJyrUPuDrQ6Fv5wqpj/1Ad/AR1eWV9O1IxNaOfHejuR4wBaWHkyxb0cf2a
	Pu+uUHA2r/GJqQ3+b+H0xNJ45KwxUhaGDKFTbRg5EOBf3GU5Whvku6Sy87WI90Pt
	eFn8XFrsDixx5zBmkHs+g4+zCg5wtnCIegy9LC+9VMom5w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xDlo4fF5BZYc; Tue,  6 Aug 2024 22:01:10 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WdnLs52jfz6CmM6V;
	Tue,  6 Aug 2024 22:01:09 +0000 (UTC)
Message-ID: <8a8b93b8-45df-4aaa-95f3-fc2deadf65f1@acm.org>
Date: Tue, 6 Aug 2024 15:01:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] scsi: ufs: Prepare to add HCI capabilities sysfs
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240804072109.2330880-1-avri.altman@wdc.com>
 <20240804072109.2330880-2-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240804072109.2330880-2-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/4/24 12:21 AM, Avri Altman wrote:
> -	up(&hba->host_sem);
> -	return ret;
> +	return sysfs_emit(buf, "%d\n", ufshcd_ahit_to_us(ahit));
>   }

All ufshcd_read_hci_reg() callers call sysfs_emit(). How about renaming
ufshcd_read_hci_reg() into ufshcd_show_hci_reg(), adding an argument
that indicates how the result should be formatted and moving the
sysfs_emit() call into ufshcd_show_hci_reg()?

Thanks,

Bart.
