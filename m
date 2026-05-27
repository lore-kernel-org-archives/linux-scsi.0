Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1782F423A80;
	Wed, 27 May 2026 16:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779898112; cv=none; b=UFRdZhwZKEUopb8zhKOeTEceWm7fZ5Y3RxbolCH1qj2dY960On3thEMs43KFgUUdr5KmRkh9ec5Mr0Iz0R/sPVz0Ve81jujZDC0Dax3XoelhBNWE+LW8wQSvoP3tRS5+FK+mgHPgT2TqwVcNHGyaljawxaeVzx0NyXTUjwdLMgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779898112; c=relaxed/simple;
	bh=n0ZF4oeAcPddi2yy7vo3URlo3mPGdJMnHGDJWsb//xE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KKINXp7Go7BukUQsveVEeDn2m9hlmOly2eiuiRF6DkT3VUkx2rssJ72WtUc81Z2Wt757Mfs43CYQ6FAljccDMOKaVx46YpAnUbrueZDhQDYg1XiH33k/GfGSjwDt37fX12aSDPp09+fWCoBOIhWux9ehz8zQ4PXrl8LLriFSGzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lIWE7cGH; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lIWE7cGH"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gQZKp1GHzz1XM5kt;
	Wed, 27 May 2026 16:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1779898103; x=1782490104; bh=RZx/H2c/4/xLYUKIF3YYER7Y
	DfCSEhf4jRFR40/W6AM=; b=lIWE7cGHvJ62InmF4lSaLdXWbJzga402jobT+uyz
	H/e75LtGB5RE+SjbjmSgSInL2e1dhqcT8+pTYbEZzev00lfUUOS8uK3RdOud6fij
	A+EuevPhJGrSLFuJ3jvMgnUcfM5vDSdZqgyxGAncVpz5fcdtFykNU6LxbD7BnqWp
	yGlir/j9E+jHTMJS3u93yj8J5loIhrZMUeXIg2OJM/AfjY7gUY92BQ0K2Ebg9XWn
	H0N6z0lhkX7HDOPivm/9zH2FF7s7T9ZVyB11YW3g/vgmqiYpBnt0GwxsBFxvEMAF
	larBPZCYxIcRb7XqUIfkd8NqHe21Z+2s+N1MktqeGvl4oA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QVkYSAqZIfij; Wed, 27 May 2026 16:08:23 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gQZKc4BfQz1XM0nk;
	Wed, 27 May 2026 16:08:20 +0000 (UTC)
Message-ID: <c1a6167c-6dd3-4274-943b-90bb9f79d6e8@acm.org>
Date: Wed, 27 May 2026 09:08:19 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Fix wrong value printed in unexpected UPIU
 response case
To: Chanwoo Lee <cw9316.lee@samsung.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com,
 can.guo@oss.qualcomm.com, adrian.hunter@intel.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20260527092151epcas1p125118deafc1caad64c4c2c9620124969@epcas1p1.samsung.com>
 <20260527092134.275887-1-cw9316.lee@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260527092134.275887-1-cw9316.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/27/26 2:21 AM, Chanwoo Lee wrote:
> In ufshcd_transfer_rsp_status(), the default case of the inner switch
> statement prints the UPIU response code when an unexpected response is
> received. However, the code was printing 'result' variable which is
> always 0 at that point, making the error message useless for debugging.
> 
> Fix this by printing the actual UPIU response code returned by
> ufshcd_get_req_rsp().
> 
> Fixes: 08108d31129a ("scsi: ufs: Improve type safety")
> Signed-off-by: Chanwoo Lee <cw9316.lee@samsung.com>
> ---
>   drivers/ufs/core/ufshcd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0371dea44887..d8f309db967e 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5706,7 +5706,7 @@ static inline int ufshcd_transfer_rsp_status(struct ufs_hba *hba,
>   		default:
>   			dev_err(hba->dev,
>   				"Unexpected request response code = %x\n",
> -				result);
> +				ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr));
>   			result = DID_ERROR << 16;
>   			break;
>   		}

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

