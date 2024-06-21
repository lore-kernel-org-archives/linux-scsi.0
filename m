Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8945F3EA66
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2024 17:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718990172; cv=none; b=t6KjiRWcHUP6shuXPE+9yeJJDj1hxp+GsyrtzPvxvOljhucyNB/Sx3885xIX+rUJ4hRHF67rw+MBqKsc//2QnqJr6TcAWkk9gQAD0piSlI6ohQNcKDwgwk8NcckGuoiVlSRhL/judn8qxPgsrB+mIpaQzgAj7wRTtl+eJbNL4go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718990172; c=relaxed/simple;
	bh=udhCJ72xbSqsM7T4ZzDDguA69KTn0f7HsSyYNXvVzUw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uA7eYdBgMC1P1eC60foBqRh6qcZAJVb0sjkUqM/AYrm6EaUlJ7N7mDsGL84Gyi5kIE6rId+uW/Vx9Leo6vU+qB0YNlP8s5I2aySuw4OHLK/mZHeE0I5zxe8Cx0bScb31CfxbKYwvhzn8fkAMFlCpy4i9NeMGVy7hnhpwgtcN99E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KHjo8jDZ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KHjo8jDZ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W5PC76sHTz6CmR09;
	Fri, 21 Jun 2024 17:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718990156; x=1721582157; bh=YTSYU1kVl3DHsDxZJ1sFGUFl
	6eT3l25ACbywCEAlgjY=; b=KHjo8jDZvMKzGX650RHj4ZkZFQPqfylxn/Xkb4Uf
	K8SdxKMcfagBl+ZYpxcJR05QjnWJjOoEjklm2iD5E+r+qf+52ZrQTk3bPw/srhRn
	bOLLtdS1SqsF/DD8wIMfHDu6QIlzdCDv3uoRdhvbQef+pSgpMfKjFT6qIUz4oYyA
	jnK3FzkcB7x+aTWjWjEyCGbT0aTGUIIheFVgOaonujmAUHj8+NQoYKP6sRT38wrG
	sm18qeYcHivI9b3Y1PbJajmLo8EQoVknbmbVedCXNTKrxk8E0XnRHdCeL0+T5Q1w
	RfK629DFkBJXV0z8fwwatnQQlDy82ZtzB7bvj7pPAwPHjA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aXwJpsBMQqyY; Fri, 21 Jun 2024 17:15:56 +0000 (UTC)
Received: from [192.168.137.167] (29.sub-174-194-195.myvzw.com [174.194.195.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W5PBw6Dj9z6CmR07;
	Fri, 21 Jun 2024 17:15:52 +0000 (UTC)
Message-ID: <4ad91e15-f1f9-40cc-b45a-4eed2932a72c@acm.org>
Date: Fri, 21 Jun 2024 10:15:50 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: fix ufshcd_abort_all racing issue
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com
References: <20240621113051.29523-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240621113051.29523-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/21/24 4:30 AM, peter.wang@mediatek.com wrote:
 > [ ... ]

Fixes: and Cc: stable tags are missing from this patch. Please add
these.

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

This code change reduces the race window but does not eliminate it since
no locks are held around this code path.

Additionally, are you sure that this change is necessary? I don't think
that ufshcd_err_handler() calls ufshcd_mcq_sq_cleanup().

Thanks,

Bart.
