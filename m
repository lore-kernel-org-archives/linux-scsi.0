Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A62E165F0E;
	Thu,  5 Sep 2024 21:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725570420; cv=none; b=ISNln0kW5tU8ZiCFQAGsbvUA9Ppgk8XSPRSkPn1VMxNhnAMxTZugfj0L2YDGyNZlWqbBIOYI6Xcvwe/xk4t5jU27RbfHBMzHWjYjJnDc0jIiU9ksCAyPkP6uZTD2kj/XTPhf20vO+a2mHHy/06LJfPdGelFKYiHauHyx6kg6il8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725570420; c=relaxed/simple;
	bh=0Lr4YqLk7DnP63YVFRDtANsb05n6cAkLN88Ax3sUs9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oIAQayFNJ5aCusYjqUYPXINTlx22xtAM6h3ALrwf3oEnnVqWIJXVa5s3cvSlefroJNrVez0ZUAWGNTg0SBQywBrrhRb52Pmd4PodaPuObgd7/vE1C4S4SASfOW4Jpw3k1l5zAuVkL1czhMlkKq71kEwz5axF8Y3fQWQ9cnZIxlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WOP1uGqR; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WOP1uGqR"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X0BkN38PDz6ClY8w;
	Thu,  5 Sep 2024 21:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725570404; x=1728162405; bh=/ms+6UcbvTIwIRzvwY9hIW9x
	1xlszuFEBvaySzIyYSw=; b=WOP1uGqRQIX8qFxmTDEkjFRgZWF5Muc7eSPjLalH
	fCfwNBVqhLIvi96ab+YJ2BGdE/ZSIVS/9Wks/spCRrvZsg8k8LbIKmQX7yD+NdRC
	/h6HtPTUSYApHzPN+t1nBQ+zNQjCNGHhT2OX8/dwnqQIUxNOI+HOFWq+Y15eqxAy
	a4tHbcBlmyIEW60yNNT8mtqWCnWZbxa2OKevCujWvQKipO86y74fK9qkJ/iZnYVx
	o4qb/YdVzoJSpkHvMMS0nD+ueWmyzd014O9Dw2vuWWToB2/XWeyel8/bTUXEtMHD
	5RXUcI6Yj4Ue20cySLF2iSz3huveA7idDCEFKSptAk3odQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aKsyXEyfVD2T; Thu,  5 Sep 2024 21:06:44 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X0BkB0DR9z6ClY8t;
	Thu,  5 Sep 2024 21:06:41 +0000 (UTC)
Message-ID: <f5274603-3687-4386-b785-129183d84f4c@acm.org>
Date: Thu, 5 Sep 2024 14:06:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ufs: core: fix the issue of ICU failure
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
 quic_nguyenb@quicinc.com, stable@vger.kernel.org
References: <20240902021805.1125-1-peter.wang@mediatek.com>
 <20240902021805.1125-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240902021805.1125-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/24 7:18 PM, peter.wang@mediatek.com wrote:
>   	/* SQRTCy.ICU = 1 */

Feel free to leave out the above comment since it duplicates the code
below this comment. A comment that explains that "ICU = Initiate
Cleanup" probably would be appropriate.

> -	writel(SQ_ICU, opr_sqd_base + REG_SQRTC);
> +	writel(readl(opr_sqd_base + REG_SQRTC) | SQ_ICU,
> +		opr_sqd_base + REG_SQRTC);

Is this perhaps an open-coded version of ufshcd_rmwl()?

>   
>   	/* Poll SQRTSy.CUS = 1. Return result from SQRTSy.RTC */
>   	reg = opr_sqd_base + REG_SQRTS;
>   	err = read_poll_timeout(readl, val, val & SQ_CUS, 20,
>   				MCQ_POLL_US, false, reg);
> -	if (err)
> -		dev_err(hba->dev, "%s: failed. hwq=%d, tag=%d err=%ld\n",
> -			__func__, id, task_tag,
> +	if (err || FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)))
> +		dev_err(hba->dev, "%s: failed. hwq=%d, tag=%d err=%d RTC=%ld\n",
> +			__func__, id, task_tag, err,
>   			FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));

In the above code the expression "FIELD_GET(SQ_ICU_ERR_CODE_MASK, 
readl(reg))" occurs twice. Please consider storing that expression in
a variable such that this expression only occurs once.

Thanks,

Bart.

