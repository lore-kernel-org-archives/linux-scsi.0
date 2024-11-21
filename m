Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0BB1BD03C;
	Thu, 21 Nov 2024 20:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732220700; cv=none; b=noV9fuIEQdYNd00DmXCuWTy3wY768eaADLYjSeKd0uUr5xWv7vR46sSP+egRjDWv8XFiDcaL4G2y6s1osBZKuT6NkNKuSP3jt4B05Z8uC9wRJbOJu5SZLHYr1KMmSCTjbNmFW9bc4knGh8iong07QbVTpn3l/3ebnzst4YmG8qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732220700; c=relaxed/simple;
	bh=Y/j4z8wFAn+eixX1q6K7wi4+AgPBCQ+0prB8uKHvyRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sRIDL38OWKFgJvSugixlqlYRA4RnGx8BzV1SAMSVZCKOTqDVWXX/KxmEW3gqjLh1aRlMjqWhrnKymc9zPzrl7FVPoCBgr0BYdlA/2CoXYBbfg9Dh3Soz8snzs1b7drqZju5u/vP1L+LIf+mXQwXmoMOcimMMiRfNfCvsJgMN0DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Uw1TnlV3; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Uw1TnlV3"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XvV8V4Btyz6CmQtD;
	Thu, 21 Nov 2024 20:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732220694; x=1734812695; bh=iqm2iy0lMDtYAHO0SUq9Ov4k
	KPKe1IsZCAFT77xxoqA=; b=Uw1TnlV3oUtwd/zAkzXt0m3Z3f5tqJ2xxyEmg1vw
	YyIhwpr+VJa5k2fLrGE2zijJ1n1Xk9qj/NaKy18wTIU+MU/SaRaTy4g6lIxsBmfc
	wdAJELCoLgcuXDRY7AZOddeQwze+bpd/qelzUSOM2Qm7tt/YSRUPoUZuR2m5clzd
	UxN8DtdDgr+tLmT8lecHL/8GbfWHowZHkZZ4UMlbj6ErGt0+sTA/Ak4HP3Qm2RYz
	V0pk/OrRrujs6YxRuYPGmfBWQIJ4oDioblDG89Ppi5ihiAT4pa371IdPFNhav1im
	AEzQH5iNzLPvk9EVE48EanXL/nxP6uK7Rs/g0NAWKFAIeA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rhhwMErpkPva; Thu, 21 Nov 2024 20:24:54 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XvV8P1CCgz6CmR09;
	Thu, 21 Nov 2024 20:24:52 +0000 (UTC)
Message-ID: <a487b02b-72c6-4bee-bfdf-4106cda96f36@acm.org>
Date: Thu, 21 Nov 2024 12:24:51 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: sysfs: Prevent div by zero
To: Gwendal Grignou <gwendal@chromium.org>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, quic_cang@quicinc.com, daejun7.park@samsung.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org
References: <20241120062522.917157-1-gwendal@chromium.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241120062522.917157-1-gwendal@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/24 10:25 PM, Gwendal Grignou wrote:
> Prevent a division by 0 when monitoring is not enabled.
> 
> Fixes: 1d8613a23f3c ("scsi: ufs: core: Introduce HBA performance monitor sysfs nodes")
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> ---
>   drivers/ufs/core/ufs-sysfs.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index c95906443d5f9..3692b39b35e78 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -485,6 +485,9 @@ static ssize_t read_req_latency_avg_show(struct device *dev,
>   	struct ufs_hba *hba = dev_get_drvdata(dev);
>   	struct ufs_hba_monitor *m = &hba->monitor;
>   
> +	if (!m->nr_req[READ])
> +		return sysfs_emit(buf, "0\n");
> +
>   	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[READ]),
>   						 m->nr_req[READ]));
>   }
> @@ -552,6 +555,9 @@ static ssize_t write_req_latency_avg_show(struct device *dev,
>   	struct ufs_hba *hba = dev_get_drvdata(dev);
>   	struct ufs_hba_monitor *m = &hba->monitor;
>   
> +	if (!m->nr_req[WRITE])
> +		return sysfs_emit(buf, "0\n");
> +
>   	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[WRITE]),
>   						 m->nr_req[WRITE]));
>   }

Is anyone using the UFS monitor infrastructure or can it perhaps be
removed?

Thanks,

Bart.
