Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AFD132103
	for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2024 18:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732213483; cv=none; b=StE7OJsXA9scCCN44WUgIBLh35B+n1CcwqteziDbu/JdGPCrIhzDaXbYTM9MrIZIulZhNyGwzLU73hMKt+64NsvJiokiSo1/tqqwby+MChomjODmMik53n1PqOdojGR5SSSVeE7zRyXWArp2pQUYXpab7U501I3PCcKjfsfbAyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732213483; c=relaxed/simple;
	bh=Zq5+yCXbofvyxcyklxYu6ub+Mq8JnjrMjAE+VJJdFNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BjXeMvOvRqteaoeXZUQVdfvGOPT5hiUI/0SWDs+3yWbifVVE1TN8U0MukO8WbtZ6vs+ne9lFdeD1gMeN8ynMVuQubmtMAFvSPCOgj5YbgNlElSPRjrN8y057C4pNp9WYghFasz2wK172BBs3F3i4lQlMJqL+4kTK0D+mBVCtG5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=G2YGQLZC; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="G2YGQLZC"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XvRTh5LMCzlgTWP;
	Thu, 21 Nov 2024 18:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732213478; x=1734805479; bh=Ux+fSFFVxtcL54xC7bKyG6Gs
	tCnPNrcGog1OlzlsdTo=; b=G2YGQLZCNz9IDfxF9H3vYZf/hnlbTjS0kKS5aLmb
	nqQf1QEaOlN73pz46UFptlJia+4fd2m2Rw1dkO4guWrk0a39lz583wwyvnBmKVM5
	tEmrTyVImjcuLZb+nbDNmQ9ZrGB2BCow6DCBUtDu13OOuMcZXQiH57VIe8afTTBh
	ZPcyRmtOOOVt+ECPSOzuBCmRoJsIDcNeH1Ig207fbuvX9dV+iWE0JlSwnRUBz7Wh
	OqDYQ6qf1uo1nE9ws6qw+dN5u8ICpLbmpGsDDN7BQb6Psy0finVaN7CHgyi1kF4h
	XSZILMhoDCS0krsA86U4lNHKPT3kG+9DN3hIGg1o/E4TrQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cays6lt0TwlB; Thu, 21 Nov 2024 18:24:38 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XvRTf2WPfzlgTWG;
	Thu, 21 Nov 2024 18:24:37 +0000 (UTC)
Message-ID: <c1fa87ed-ad87-4620-82b8-24541d3928db@acm.org>
Date: Thu, 21 Nov 2024 10:24:36 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: add missing post notify for power mode
 change
To: peter.wang@mediatek.com
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <20241120095518.23690-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241120095518.23690-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 1:55 AM, peter.wang@mediatek.com wrote:
> @@ -4682,6 +4679,10 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
>   
>   	ret = ufshcd_change_power_mode(hba, &final_params);
>   
> +	if (!ret)
> +		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, NULL,
> +					&final_params);
> +
>   	return ret;
>   }
>   EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);

This patch causes the wrong power parameters to be passed to the
POST_CHANGE callback. I think that &final_params should be changed into 
&hba->pwr_info above.

Additionally, this patch includes a subtle but important behavior 
change. Without  this patch, POST_CHANGE callback invocations can 
influence the power settings that are copied into hba->pwr_info. With 
this patch applied that is no longer possible. This behavior should not 
break any UFS host driver as far as I can tell.

Please explain in the comment block above struct ufs_hba_variant_ops
that PRE_CHANGE invocations of the pwr_change_notify callback are
allowed to modify the power attribute arguments while POST_CHANGE
invocations must not modify the power attribute arguments.

Thanks,

Bart.
