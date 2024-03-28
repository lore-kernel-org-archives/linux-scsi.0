Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A391D1DFDE
	for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 17:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711647125; cv=none; b=Y1pWLhAlaAY6ejFnT6H/Zif+yrSxgWmMtwO9BuaXYeLk2HsaNo3GPxtAQyTm3Xsn2WJuapvxLNDJqn55yzi6Io7VXplpyglmG0H+ze8wX1dB4y0q3A+yrTdgLxEEN1ebhGhOSeTRcnd7tuPmN9I9xYCtbwFIMxMP5EWr1e9QFOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711647125; c=relaxed/simple;
	bh=YU9vjYv+eAgyDwJCQdxjLgc3+VqqR7F2gyDc2kNKX34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AEvgruWnDqJHH7YkTe4jPBlhsxWaCkaj6Wme63XWcIYSRhBnw+ca/xqjJFofIPXUswpxRMRHky7lKaHTCSI+nSqzNgxTCHlpAM4JpaMqP20mMWWFsVElVzifjTZ+/ivJy4Lcc8mcRuW5v92B11gqFZNT/3zzHzVGp6Q6jVtisS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UMdCXKw1; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UMdCXKw1"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V59Zp6sd8z6Cnk8t;
	Thu, 28 Mar 2024 17:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711647116; x=1714239117; bh=Mdxd4yA1iOItAik8lIBneAxW
	ZtJ8/8FIdec+MTmzTBo=; b=UMdCXKw1maU12bphPks3/jsKZXUrPr+Br64eq/In
	YlBgS1n+q5JfdFea9QKMK9JeLUcWypv2NBg7Q8g4x7Ftr2rzELCPAmcFHVlHZXkg
	m/5UBqaHZ/u9YKyog8gVdSVq3r7Q4GAAeDMRlyzPLg9PhGxAJIdkCdZZU6CHVz5P
	uFyeeJ0O5cv3LV4ubFqBQfY/j5fbnkYZZKHORrM9fFZXqiqK0zV6jGCQgam1UXOi
	mkzrtwaEsMyazeTpqZvZR7LCyPQ2hxXwUv/v/bxnNGQs6eypDcsETSBn0lNvg9zl
	HLVMFGaD7pF9yqJPIMJEQGviQ3f1b+0M+tWcdoX4hgiHDQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HE6PiFj-vzbY; Thu, 28 Mar 2024 17:31:56 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V59ZZ3TMSz6Cnk8m;
	Thu, 28 Mar 2024 17:31:50 +0000 (UTC)
Message-ID: <bd8ca5a8-2875-452b-ae99-26eeca15ce13@acm.org>
Date: Thu, 28 Mar 2024 10:31:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: wlun suspend dev/link state error recovery
Content-Language: en-US
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com
References: <20240328104707.1452-1-peter.wang@mediatek.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328104707.1452-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/24 03:47, peter.wang@mediatek.com wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index e30fd125988d..0a32f423f6a0 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9791,7 +9791,10 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   
>   	/* UFS device & link must be active before we enter in this function */
>   	if (!ufshcd_is_ufs_dev_active(hba) || !ufshcd_is_link_active(hba)) {
> -		ret = -EINVAL;
> +		/*  Wait err handler finish or tirgger err recovery in this case */
> +		if (!ufshcd_eh_in_progress(hba))
> +			ufshcd_force_error_recovery(hba);
> +		ret = -EBUSY;
>   		goto enable_scaling;
>   	}

Please fix the spelling in the above source code comment ("tirgger").

Thanks,

Bart.


