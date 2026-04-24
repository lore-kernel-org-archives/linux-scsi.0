Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF5E284881;
	Fri, 24 Apr 2026 23:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777071654; cv=none; b=btWqJ+rhr7bCIRNQ4jm4/7vXbmX1ChmHfjiS5kHntXMGqVkED3s2M4UmTVkx67gSOyIW7hCmB5flH57Pg+oWNPmYjvPJxRG3a8GJiKdmTKqxiNQhJOCEZejnDzwcanrMUdebeobh2fkQbntxcgmiNtFB1dVjynD6KtzKEJ8cmp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777071654; c=relaxed/simple;
	bh=2FVldbnjbLLwNWb588FpRd8+kxe5NXG2mwO9mzTkwvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lgv311+R/sNuEfKOenlCTyiJr+lzS8kYWtQI90gQo7PL9OqN2gFxLVg2OUnAkHH7emtoD/bvg4FHZKREZPjE82sY/sWqj9qrZgZOZVbKTfGu+iTbFVfKL88ALUu58h0n0b9ji+bn359yhvbfr03PHuzbNHqIu7kB+YF0U4R6smc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XYIY5HTa; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XYIY5HTa"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g2T2r3C1zz1XM0nq;
	Fri, 24 Apr 2026 23:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777071647; x=1779663648; bh=VH7Ohw8D+uBpZ1B4tUOytXuG
	yf4UmPJOqaU6aLR0u5U=; b=XYIY5HTahotyeQWKiarNBqa6BmZYm4KiynHw99XS
	SBlOK6nCnRaSGyKoRzA5UdFlHyyWXgMNcuW1bWWiM5qqYVxZzRGW3K6MZ7hJ9lIQ
	FnNsXWQ5SZ6L+73LQ9vDQi0pqG7S8gna2pQUwcXMbpupiwn1k84VgVzaPAPwqW49
	cvMbttoPURFK5u2kJOQuh1xhI3OM6SOpTtgWMrO6hOPpvo48y0Btz4pIK5DN/d/3
	oTDCacmYQr3hheJ3lkCA67ayn1kxqmEqxuIMoAYVaT8/5NxSkXaNYus6oIHNckU7
	7c5AI4NvUvkNVcjvRWWV9YphWscba1XVK+cBMi/1A4b9Bw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8jSVt42OmUGc; Fri, 24 Apr 2026 23:00:47 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g2T2j2wyCz1XM2FN;
	Fri, 24 Apr 2026 23:00:44 +0000 (UTC)
Message-ID: <c4d34bff-a540-4a1e-94d3-c3b820524103@acm.org>
Date: Fri, 24 Apr 2026 16:00:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: call hibern8 notify when hibern8 cmd
 failed
To: Hongjie Fang <hongjiefang@asrmicro.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260422072102.1204886-1-hongjiefang@asrmicro.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260422072102.1204886-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/22/26 12:21 AM, Hongjie Fang wrote:
> The vendor hibern8 notify callback always can be executed in the
> PRE_CHANGE phase of hibern8 enter/exit. But it cannot be executed
> in the POST_CHANGE phase if the hibern8 cmd fails.
> 
> When the hibern8 cmd fails, the vendor hibern8 notify callback
> should still have the opportunity to execute.
> 
> Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
> ---
>   drivers/ufs/core/ufshcd.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 9ceb6d6d479d..02091e72f8db 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4500,9 +4500,8 @@ int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
>   	if (ret)
>   		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d\n",
>   			__func__, ret);
> -	else
> -		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER,
> -								POST_CHANGE);
> +
> +	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER, POST_CHANGE);
>   
>   	return ret;
>   }
> @@ -4526,12 +4525,12 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
>   		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d\n",
>   			__func__, ret);
>   	} else {
> -		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT,
> -								POST_CHANGE);
>   		hba->ufs_stats.last_hibern8_exit_tstamp = local_clock();
>   		hba->ufs_stats.hibern8_exit_cnt++;
>   	}
>   
> +	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT, POST_CHANGE);
> +
>   	return ret;
>   }
>   EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);

This change may break existing hibern8_notify() implementations. Please 
add a new argument to ufshcd_vops_hibern8_notify() that represents 
whether or not the operation succeeded for POST_CHANGE callbacks.

Thanks,

Bart.
