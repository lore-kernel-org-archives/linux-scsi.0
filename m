Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E58238171
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 15:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746803310; cv=none; b=qO1kHMFaaVeh706mYpqcqXZleK9rsTESdLK0o+uI8mxvQUldZEZnrMtg9kef2x+u9M0Pdg5RK+FvoyTat1Z6G0hqyuoZclm4qVDqJjfIj1xA39bxy5kDQkM6JCJ6eyAwwNVdLSRN0MpU1JgTISGgbkHC00H3zHLW8xXyNI9xGR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746803310; c=relaxed/simple;
	bh=vwZNnoGoV2GoDGknqrK90rdj60HtoVhDx/qDFfMs4WU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LtOrRF6VAdlFLrhsWM7IlCBkgx4mKcSFcSD1twSO3NVjqWA0bQ5i7Ey9eGjAAKOaS3EOVwHKh52d34nAP1ntnL8ez3dVKiS/SFg0+gK7uYvmceJXOHY/H2nsBrHO9L+wolcp9SLZmDlick1cqm0Pz2LwEmpZKrV60YQgLbUGEBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Q+SyY3Zj; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Q+SyY3Zj"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZvC7H1R2Tzlv760;
	Fri,  9 May 2025 15:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1746803303; x=1749395304; bh=nTTvMUk6mjdxRIBg6IGzB6CZ
	ACy3mVbN3OsARKoGjBc=; b=Q+SyY3ZjbucG/evkbgE9G/scOdYQDjRidyJGDOX6
	uituz5P3IGa8XDhWv8HIqoE0dcCocwczs4FNhN2CNYoPn/nRWRMe/QzdXmBANib7
	ugkNYeM7BZJFGK+peWNMrugtaMd8lfwl0rAFkf5NXOchHTi4/aw71q/1GYtlEVNp
	BUUNzDRoU9YvqX/Biafg+ZhAHOTkiITizrqq3DbQNevHEna02liL/+M7v3lwE+WR
	wPzBnsC7EOQ7l3tLOjCMLgRZDJCJUBJg6M1h/p5zWc3yAvm1rUn7vRP3k0fEYjM9
	dzxCi8Oe1CaUS7mPuFfAUAkytDLxrwp4DwDuwx80cvqcmQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id atU53Y_nnf9C; Fri,  9 May 2025 15:08:23 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZvC6p5BMQzlvj04;
	Fri,  9 May 2025 15:08:01 +0000 (UTC)
Message-ID: <946d62cd-b1a1-4ddb-8411-2060362f7d33@acm.org>
Date: Fri, 9 May 2025 08:07:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: support updating device command timeout
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250509071029.446697-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250509071029.446697-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/9/25 12:08 AM, peter.wang@mediatek.com wrote:
> Some UFS device commands may timeout due to being blocked
> by regular SCSI write commands. Therefore, the timeout
> needs to be extended to 30 seconds, matching the SCSI write
> command timeout.

Does this happen with all UFS devices or only with some UFS devices? Is
this behavior perhaps a firmware bug? Processing of device commands
shouldn't be postponed until SCSI command processing has finished.

> +enum {
> +	QUERY_REQ_TIMEOUT_DEFAULT = 1500,
> +	QUERY_REQ_TIMEOUT_MAX     = 30000
> +};

[ ... ]

> +static int dev_cmd_timeout_set(const char *val, const struct kernel_param *kp)
> +{
> +	return param_set_uint_minmax(val, kp, QUERY_REQ_TIMEOUT_DEFAULT,
> +				     QUERY_REQ_TIMEOUT_MAX);
> +}

This change makes it impossible to reduce the device command timeout
below 1.5 seconds. I think that setting lower values can be useful for
error injection purposes.

Thanks,

Bart.
