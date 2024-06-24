Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB16182B2;
	Mon, 24 Jun 2024 18:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719252129; cv=none; b=oJqYS7Sv2zNzBzKhyMWA8F6hHbaSD2s7cknhaSgdB+EPTZXsu92KRTl90WAZ/KTCyr5bjY/nY3/IVfpSNYBSIRg1OLz0S0qdMab85jA9HMSuMCPwCce8dmxpzRD0Kmq0brSXa6jrlL35uQ9uA4UwhQMUhR8HcXOrE7YFDPhgaTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719252129; c=relaxed/simple;
	bh=C9WJ6rQ+55EKYuT5tmVXl8opahoZ5GZQP9W4Sty0IYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bTo8FeOThuo21HSo/JHn4U7lYhsExsxvCBdIeg8FfnmIyHCtGvXSGoSA1P9f5FCNjQdEYgzr3kAqox9u6nhlV6z29BmAtuhyB8jhh1TLpkre3qLvxlCKEsQZhatEZ7+0JdY/IcU0sSZy5D77IJ2k70W3AQoBlt4WvM4shVZXNUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ce/EeXgv; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ce/EeXgv"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W7G4v208Jz6Cnk8y;
	Mon, 24 Jun 2024 18:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719252117; x=1721844118; bh=BlHsZBG0ubyVPIWpEZLCYm37
	S4hYQYc13Mho9GhdGSQ=; b=Ce/EeXgveArhIBuWatIbDFKbvMh2nLuAHE97TUfi
	o8tlrOjTqhJXjH0D00qXh638iWW92PZznoyHr2pvsh1hcUX8yANtT9PmI8K+Ll5A
	lWmmwje2qbVYT3ygZUSHZJuN7FcxWd0hh34LJybHyMKqw+bonDVaaGExMM9cPvte
	Oe1QUTvebyGkJEUa7q9W1oVsVd454N6U7g7+xUPv5jG1XIthK6bCqzhzWMYAD6Zb
	oEt0c4Q+O9qDQmP/auCUa6QkmG/w1hNSaRPIwC34g+r1jeW3cAouF39hx1V/MHbF
	j6qgdSdICLy99IIbynbkOVrde9aKC5IL/mg3Nj4EZaIH+Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aDG0ypCUIWgA; Mon, 24 Jun 2024 18:01:57 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W7G4b5xckz6Cnk8t;
	Mon, 24 Jun 2024 18:01:51 +0000 (UTC)
Message-ID: <eec48c95-aa1c-4f07-a1f3-fdc3e124f30e@acm.org>
Date: Mon, 24 Jun 2024 11:01:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: fix ufshcd_abort_all racing issue
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, quic_nguyenb@quicinc.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com,
 stable@vger.kernel.org
References: <20240624121158.21354-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240624121158.21354-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/24/24 5:11 AM, peter.wang@mediatek.com wrote:
 > [ ... ]
In this patch there are two call traces, two fixes tags and two code
changes. Please split this patch into two patches with each one call
trace, one Fixes: tag and one code change. Additionally, please include
a changelog when posting a second or later version.

> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 8944548c30fa..3b2e5bcb08a7 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -512,8 +512,9 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
>   		return -ETIMEDOUT;
>   
>   	if (task_tag != hba->nutrs - UFSHCD_NUM_RESERVED) {
> -		if (!cmd)
> -			return -EINVAL;
> +		/* Should return 0 if cmd is already complete by irq */
> +		if (!cmd || !ufshcd_cmd_inflight(cmd))
> +			return 0;
>   		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
>   	} else {
>   		hwq = hba->dev_cmd_queue;

Does the call trace show that blk_mq_unique_tag() tries to dereference 
address 0x194? If so, how is this possible? There are
only two lrbp->cmd assignments in the UFS driver. These assignments
either assign a valid SCSI command pointer or NULL. Even after a SCSI
command has been completed, the SCSI command pointer remains valid. So
how can an invalid pointer be passed to blk_mq_unique_tag()? Please
root-cause this issue instead of posting a code change that reduces a
race window without closing the race window completely.

Thanks,

Bart.

