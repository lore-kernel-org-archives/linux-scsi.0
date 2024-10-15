Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D008614E;
	Tue, 15 Oct 2024 18:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729016215; cv=none; b=fw6fTuIGBfBxrUZYPG9sX7L++wh9S7RKTo8fUFPmGlKEzzKtdzezws2MT1BkS2diWWZCstfnV9Dcm4k+lrgmcwfbi/1mvhpKrQpEQoWgACSxrhCxUVMraTA8EbH+1moW8XeG25uyY2FP8NpQ0VHcNGiUX3CXvDAqA/scooh/rrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729016215; c=relaxed/simple;
	bh=UPYQEi39O7n1RlY2fUa1rXC16boKO0PKQmbjptWDnSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MuL7THKR/WATiIuxKKkzmpDS1eR3Civ/hHc5QO2y7RzyVrBL0k/Fb4/VtnOPdY9vjiSd9OKSVJn73tfo0KPCZfeKAuGbYGQyVhLlNyg8ZbMfV9Y9MsHxzdEzs+iAXhvlsST7zRBy4L781fEkn8hSItahT4xL6yy/yOUyP0UyUbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MTLejUmc; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MTLejUmc"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XSj3n08R1z6ClL9d;
	Tue, 15 Oct 2024 18:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729016205; x=1731608206; bh=E3MMNf1RZvt1M3ItDSx4hSUM
	ikDt0uuawP9q/SHmA/Q=; b=MTLejUmcXhUf5wX/5DOl7noqgtBWGUsdDuf2Oqf5
	S8dICVX7Sqf/Vpkap7FusefxPNSdYz1YBCV6jBVMBARcsGTbTLy0Zgp4IqLAamHn
	duuiwe5Wr7RilWUVpYiVEMeNBKY3npDFODJaGESGRFojRvnmybkZCytp8JYLn7l8
	QYtO5VqpX5QWo+jG2ldWZzbOOAqFpnbxZSriB6vBk9IS/bnGhDLD733zjEjlEzuy
	IW8j8ufGx7Q9152K35iyyBJwPmff7ZqGlr4mO8hagFN8vEv4uHsgBzkcmTFelWai
	mw7amTfRonccnsN/gU+/CAfRMpeFExdTdO6B1+YimnUG6A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FcrvsbSU_Rgo; Tue, 15 Oct 2024 18:16:45 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XSj3Y44M8z6ClSqC;
	Tue, 15 Oct 2024 18:16:41 +0000 (UTC)
Message-ID: <52ed0795-c493-414c-b22b-86c90b8d89c8@acm.org>
Date: Tue, 15 Oct 2024 11:16:39 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] scsi: ufs: core: check asymmetric connected lanes
To: SEO HOYOUNG <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
 jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
 kwangwon.min@samsung.com, kwmad.kim@samsung.com, sh425.lee@samsung.com,
 quic_nguyenb@quicinc.com, cpgs@samsung.com, h10.kim@samsung.com,
 grant.jung@samsung.com, junwoo80.lee@samsung.com, wkon.kim@samsung.com
References: <cover.1728544727.git.hy50.seo@samsung.com>
 <CGME20241010074229epcas2p31ecc33731a96be7958cdd93908a1ce86@epcas2p3.samsung.com>
 <e82b4b65b5f6501a687c624dd06e5c362e160f32.1728544727.git.hy50.seo@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e82b4b65b5f6501a687c624dd06e5c362e160f32.1728544727.git.hy50.seo@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/24 12:52 AM, SEO HOYOUNG wrote:
> Performance problems may occur if there is a problem with the
> asymmetric connected lane such as h/w failure.
> Currently, only check connected lane for rx/tx is checked if it is not 0.
> But it should also be checked if it is asymmetrically connected.
> 
> Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
> ---
>   drivers/ufs/core/ufshcd.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 24a32e2fd75e..387eec6f19ef 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4540,6 +4540,14 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
>   		return -EINVAL;
>   	}
>   
> +	if (pwr_info->lane_rx != pwr_info->lane_tx) {
> +		dev_err(hba->dev, "%s: asymmetric connected lanes. rx=%d, tx=%d\n",
> +			__func__,
> +				pwr_info->lane_rx,
> +				pwr_info->lane_tx);
> +		return -EINVAL;
> +	}
> +
>   	/*
>   	 * First, get the maximum gears of HS speed.
>   	 * If a zero value, it means there is no HSGEAR capability.

It seems to me that symmetry of the number of lanes is required by the
UFS standard? From the UFS standard: "An equal number of downstream and
upstream lanes shall be provided in each link." Hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
