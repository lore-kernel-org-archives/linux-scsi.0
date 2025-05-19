Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE4F219A9E;
	Mon, 19 May 2025 21:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747688610; cv=none; b=ZKzK3MKtxdxLM7iTmwGVXACvYLEDmr0XsLXMxEyzQ54ZoMhL0QvzEU7ixwNjYjGWOyh7/R9lEdaxFDq5OvN5dI4Ewo/oTMX7iKnBvcGYazaUcPWRmM/uv/dF2u9RebbquUmCfO8VSu748J2XAgBq6xpNSgO8nHJI1iKNPTPjbUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747688610; c=relaxed/simple;
	bh=JLKoB74dcFkHptIj/08cElE1QKlxBReI5PeimRY0MQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sPx0EdQPdKdLx8BLsaFRmSVIMf0xPByp70U/9/F4jCL0/e7e1zLq4sFQICxLP1NwbnJRpDVTqUOrvVKthcl8bHF2uBiLQxikLSDMvO4BJPSFRMRZiNmpvN+tUcznIStyUNJAouDWOVtL8/7smnLIumYis7bvTP3NzYW8bBY1ayk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sLrpg+DW; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sLrpg+DW"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4b1VXH3r92zm0pKx;
	Mon, 19 May 2025 21:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1747688604; x=1750280605; bh=MMBT+V9o0qR/FVPOfBmiNgMP
	YySbpU4lED071DTsg50=; b=sLrpg+DW6DeHOfpali6kPhH43pz8X1Ov5MLN+Vr7
	XudUZnw13dM59VWz6tgILhqJKt91cWWbttCU19XkhHucdH067o4cPaPaDCxdoleB
	qLi7epQ4FGCqRn02Y+XTGfS1cOHyW/p7H00AD/14fnG7MMIjTRuH/ImHJcURS923
	vOoITsxnFZYOYIDiSq94Jk87I73ww63L2nEKBHEmieN4gXthnG4Zyf4DlFfMc/V5
	7zQo29tyIe4tBOH2YMNMQ4NaNWfX2JkixJnz55qT/ePYOYyuqPzesC8Kb7Q7KjBv
	lSFBTiv+B8eaamwbb6FYMDIxXvZjNaCzk5V2tTwPa1Qevw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WLu-68mGKtPE; Mon, 19 May 2025 21:03:24 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4b1VX40gTlzm0dj5;
	Mon, 19 May 2025 21:03:15 +0000 (UTC)
Message-ID: <a355b7da-fb1c-479d-8612-94255e5aedc7@acm.org>
Date: Mon, 19 May 2025 14:03:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: mcq: delete ufshcd_release_scsi_cmd in
 ufshcd_mcq_abort
To: "ping.gao" <ping.gao@samsung.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, minwoo.im@samsung.com,
 manivannan.sadhasivam@linaro.org, chenyuan0y@gmail.com,
 cw9316.lee@samsung.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CGME20250519025509epcas5p2bdc884392dafa224289b337c1232daf3@epcas5p2.samsung.com>
 <20250519025559.1263821-1-ping.gao@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250519025559.1263821-1-ping.gao@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/18/25 7:55 PM, ping.gao wrote:
> after ufs UFS_ABORT_TASK process successfully , host will generate
> mcq irq for abort tag with response OCS_ABORTED
> ufshcd_compl_one_cqe ->
>      ufshcd_release_scsi_cmd

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
