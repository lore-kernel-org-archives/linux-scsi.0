Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B2F17B036;
	Tue,  9 Jul 2024 18:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720548640; cv=none; b=T2k7YQIHlhz5zhn8mU89DvcKbqIykr7X92xpdx59bNndvaxeMejUIuZqo8KpXHV5ZYiwgo9olmHWYTeNp0b1AFlZojgmV1NYUkYlEDymrIzKG2Hhf1F5fKvu16eUPirhUAON23hFCG3Vvvu06ifis15A2LNOMkcxMEvH4VIu0+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720548640; c=relaxed/simple;
	bh=SGq/ssHoslmFRarDDEhZmqPBLmYTYCxhmjr52bo8hj4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p3mx9APPPKST9L8xiCKbfwjJNXZELCJGsVfyrvg4mht46Hc5istiAjX48lay38nl0FT4hyMuRRLvpRd8g0myc5JnD7DHuPsqIGseoAsrlXCvyF1D1sj0gvF8eLAZeSqX1+yXtcHb9cyMWQRGdf/1mZKYzcoiVnaodne8iR9keAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=GgxuQPcS; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="GgxuQPcS"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WJTYh1vfnz6CmM6L;
	Tue,  9 Jul 2024 18:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720548626; x=1723140627; bh=r6xt0/4Qdrzv5f5FS/Gooqnt
	U2esThFOhUITG41SVE4=; b=GgxuQPcSCPpW1gpGm7/YlroBISYAj4bjVpKnaR3a
	xDGtIjvl8oErMmfR7Tvxf/NgXL3ULulcposNUI6vcPhe75elGM3h1eEUW7lS3he3
	F5PtlMRxZMYJ4CZfw4TFxDH37AXzVx9CvdxaoHEMB3syXQUqpqASEEQCRV4B3CkU
	hfdz403Y2+c+SYw8nstHsx/Ca2tsJw95qSS7Yu/aIlN3eqgRanqAcU6qi4GnQ532
	2dP3IY+qMDgxzXPcsfyga0vm47UxRpqrc2aWexu9zjaAkkDDaVsi20CBTy0PVw5g
	LrdvBqKDaYqw8nJusGbQ7n+jF6uymuPzWZZwxM4Rq8Tmmg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9yCWi2MEivee; Tue,  9 Jul 2024 18:10:26 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WJTYY4WL6z6CmR07;
	Tue,  9 Jul 2024 18:10:25 +0000 (UTC)
Message-ID: <a89910ad-da5b-42c2-8a0f-9f4908fa2c1a@acm.org>
Date: Tue, 9 Jul 2024 11:10:24 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] scsi: ufs: core: Support Updating UIC Command
 Timeout
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, quic_cang@quicinc.com,
 quic_nitirawa@quicinc.com, avri.altman@wdc.com, peter.wang@mediatek.com,
 manivannan.sadhasivam@linaro.org, minwoo.im@samsung.com,
 adrian.hunter@intel.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>, Bean Huo <beanhuo@micron.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>,
 open list <linux-kernel@vger.kernel.org>
References: <cover.1720503791.git.quic_nguyenb@quicinc.com>
 <6513429b6d3b10829263bf33ace5c5128f106e59.1720503791.git.quic_nguyenb@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6513429b6d3b10829263bf33ace5c5128f106e59.1720503791.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/24 11:06 PM, Bao D. Nguyen wrote:
> +static int uic_cmd_timeout_set(const char *val, const struct kernel_param *kp)
> +{
> +	unsigned int n;
> +	int ret;
> +
> +	ret = kstrtou32(val, 0, &n);
> +	if (ret != 0 || n < UIC_CMD_TIMEOUT_DEFAULT || n > UIC_CMD_TIMEOUT_MAX)
> +		return -EINVAL;
> +
> +	return param_set_int(val, kp);
> +}

The above code converts 'val' twice to an integer: a first time by
calling kstrtou32() and a second time by calling param_set_int().
Please remove one of the two string-to-integer conversions, e.g. by
changing "param_set_int(val, kp)" into "uic_cmd_timeout = n" or
*(unsigned int *)kp->arg = n".

Thanks,

Bart.
