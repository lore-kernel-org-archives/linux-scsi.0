Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01147212B05
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 11:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743076680; cv=none; b=ohn3aCTvlFmzNvpgR2zy7/d3ArXmOIsariG7wcEeBJBaYqY5IBWXqnk/iv9ik5JT8xMB6uFNmjI/VHqpeRm1V7BcxNRSzk6g91lShgl3Z7r6LG3ozKaTkCFMa6rPcmWfp9ba0uvhJAC6hkB9VPknKeEQbwjFzVnrxqftbbhWlm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743076680; c=relaxed/simple;
	bh=TFNpw+N/QoBXa8lDmUulEcnAUYwwylquqPjt0EwIllo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LEJsZ4x+PBPqq4tMCfy06JZkmxizSvOuhFEVuN4wDQgYsWTQK3wDhbIr7Xl9OORftZLrKOdjgqa78PZeVED9+KN+AXS8v7TlZdjeuoKQv01bRUOqIY+iD03gtqfTByxDw5XavVU9Lj6Pg9A0vlSn8wpaj3FhOWHgBIpvYBYoLIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BeNgKFaR; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BeNgKFaR"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZNhxK6xqPzlvWhN;
	Thu, 27 Mar 2025 11:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1743076676; x=1745668677; bh=PIFGnxX0l9DiWan5EFRO6w3N
	aBEwptC444gd0+rDHeo=; b=BeNgKFaRA6wsnhdum3vEvvveCaNHUXpasSU5vJtf
	ehCO20p0HH++o26tZshcB4y16TSNwabXGK/MslxQc7XuXH+1niCoxQ692Bn4cXzw
	TvaEXyAQYzsHGXWuQxt3WWhUIHrtDZKQ0r+oDJ6RT4PHCR9hMf+KgpE3Y5FXeo/a
	qY3nbc5jsUmEoa4Wa16BhvvfxkR7NZ1Nw+fIVvFAADvthFOSD+sthCfPD1hIrfpN
	mlVf3jFTkGVcbxVQuehQNrgzfzGq7hzRDMwdAz4CIuApDrXfqtSuoMSTCXoKZqC1
	X1StiTIThu1ntpNHmiqo/6IB6kNClDt3xRMtG2vH3YxgjA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7EnV20rPoYje; Thu, 27 Mar 2025 11:57:56 +0000 (UTC)
Received: from [10.47.187.167] (unknown [91.223.100.87])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZNhx508kRzm0Q5R;
	Thu, 27 Mar 2025 11:57:43 +0000 (UTC)
Message-ID: <9c791cf0-1853-415f-a037-0578d6573e45@acm.org>
Date: Thu, 27 Mar 2025 07:57:38 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] ufs: core: Export interface for sending raw UPIU
 commands
To: Selvakumar Kalimuthu <selvakumar.kalimuthu@in.bosch.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manjunatha Madana <quic_c_mamanj@quicinc.com>
Cc: Antony A <Antony.Ambrose@in.bosch.com>, linux-scsi@vger.kernel.org
References: <20250327114604.118030-1-selvakumar.kalimuthu@in.bosch.com>
 <20250327114604.118030-2-selvakumar.kalimuthu@in.bosch.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250327114604.118030-2-selvakumar.kalimuthu@in.bosch.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/25 7:46 AM, Selvakumar Kalimuthu wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 78b57e946cdf..226cc90c74b0 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7360,6 +7360,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
>   
>   	return err;
>   }
> +EXPORT_SYMBOL_GPL(ufshcd_exec_raw_upiu_cmd);

As I already mentioned off-list, please do not export functions without
adding a caller that needs the export.

Thanks,

Bart.
