Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1EC84E1B;
	Thu, 23 May 2024 23:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716505522; cv=none; b=nG7CtYXI4i7bWz+k8diDt4B4IgnYW8MgukJpEg36NXOGwM5YobtcjiKB8umeKDTwN113phRfmGvGR0mxlbq027cnCgmFVKJJtmXfbf9B51jru2W+0TtZ0AAYSX4uODdMvVodSqCPb0VDdyihbdzIP3xOrexwmMsDlsiAjwXA+lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716505522; c=relaxed/simple;
	bh=ApocRwH2Vn9taDK8+OJBUVTJaclziFTi19+EROmkatI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KKrjTE+q+VaqDg9ndwmS/fga4gr12i6kRf3s+iMWix0cnV9aahyLrSz29OPONB8JF+mP5y7XK0SGa/UlXv9qFmKbQIjgIhbNXGP6jTXDuGkKOa9byDfOhslujs90fTDk1pFleBzVsviy58EG6kcQMpmHxrM0kWI2K9ymgdyQwi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=k+Zg+Euq; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="k+Zg+Euq"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VlkKX2zTSz6Cnk97;
	Thu, 23 May 2024 23:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1716505518; x=1719097519; bh=fFfOkCfkcI++0Am6bIxelOyN
	B0sFMViu10l+J0YzZbU=; b=k+Zg+EuqsDVyQxfqzDRMOPrDuR41py6+HTqIOL+L
	EPK491x+P3Lu/wP0BQq1FPdGY8roWC8zg3vzweroSDEa8FHhnjiHKsmawlaBIUvZ
	urJd8W5rjLfrFiOYQI8FzPYv+DxMmyeSBD3CpLkZkQh8N+JV05Cgu/KJXH2TapwF
	Tjvsjfb3kDz2HwjQNgHV5DopktCryJirb5WJo/nAxK+3uY5YyeYF4movXFOVRl2O
	FPt0sY17p/BunQcZ48F9Gb/1l5Q4ovBmQAM5yeBm+iWdRbHu78UvZnQTccj+O2rh
	TU5bNbIenJP7ShDAkxVyVxmRkqUPemqU8QyFXPjF0Aowqg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0ITViHZB_ZHR; Thu, 23 May 2024 23:05:18 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VlkKS4WDRz6Cnk95;
	Thu, 23 May 2024 23:05:16 +0000 (UTC)
Message-ID: <61984ab3-1bcf-44e4-8b2a-0760af3cefd9@acm.org>
Date: Thu, 23 May 2024 16:05:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] scsi: ufs: sysfs: Make max_number_of_rtt
 read-write
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240523125827.818-1-avri.altman@wdc.com>
 <20240523125827.818-4-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240523125827.818-4-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 05:58, Avri Altman wrote:
> +	/* make sure that there are no outstanding requests when rtt is set */
> +	ufshcd_scsi_block_requests(hba);
> +	blk_mq_wait_quiesce_done(&hba->host->tag_set);
> +
> +	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +		QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0, 0, &rtt);
> +
> +	ufshcd_scsi_unblock_requests(hba);

The above doesn't look correct to me. ufshcd_scsi_block_requests() does
not guarantee that all pending commands have finished by the time it
returns. Please blk_mq_freeze_queue() / blk_mq_unfreeze_queue() instead.

Thanks,

Bart.
