Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112DB482DD
	for <linux-scsi@vger.kernel.org>; Sat, 13 Apr 2024 14:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713017852; cv=none; b=LffnWbXTmdDhz75nmQhitwvvsnA1pbLL4vRMnL6VXArtpCA7R+YhQy1LI0SZN/geIlIRWqrndk4urN6RLzFSQlWLD5ceh6+gerum8tG4/CzZkI0+s5ChRRNa4QcZdNUUAVMSyPj9WLkCpHIkhQcD5/2yMzhvXooBRiqAdr1CAPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713017852; c=relaxed/simple;
	bh=lsPNwel7L8FKed5qpqyLcRnEoC9BavTRVC67Gb3eGW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JCiQ7oYltohwW/SJZTRecI3cVI8H31GTHg0RxwXhpQDbN/iak1L8be4mInL53n8dI++pjjCkxRajbthjHz3ghalhbXBqkRVWyzI5sKnl59zZN3JTB6KOYZx4kQsMuFv9WypxUIig+Mncki382/IO+SuCkTTUGJCxydEFRZa1ivQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IKjpgwSR; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IKjpgwSR"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VGwVx1wlBzlgVnF;
	Sat, 13 Apr 2024 14:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1713017844; x=1715609845; bh=NosZhB0b/qKngCZ6+32ZXqlH
	9B1m1rQ/KvjqDTU/VNw=; b=IKjpgwSRkwSkybwbj3jk378K8lYkyt+fe3E2e/86
	258jBy+70t7VNJz+NBT5W/w0KMgtZ0RmZP3wkcE5S763qCycCEicsWgm4NkFpAab
	lqo4rOo4hmFTSoxTSPXFSwd1W+V5thsmTuWYB2aOQL4KWv3N6UhzD6UUYi2sTE69
	b65vcamgoNkNdQ0OlsC9KMVkKgJIYoV28ku14jsAPmyq0DETs0h+zTp84UZJhGHD
	AzMjlMyS6RUr7e8ws3p1Xh3x2TZQchrbvRMYgBuXtredNjggWMOLWZR8QxLfUhJK
	6DbN80nM5+8RtBUjS4mXLPCFqmEjTKiw4BuWMsCWrywaEg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lRHog02gMzhE; Sat, 13 Apr 2024 14:17:24 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VGwVT2Xl9zlgTsK;
	Sat, 13 Apr 2024 14:17:04 +0000 (UTC)
Message-ID: <cc6ee1c4-8ce3-4016-a085-6bae84754690@acm.org>
Date: Sat, 13 Apr 2024 07:16:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Remove .get_hba_mac()
Content-Language: en-US
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Peter Wang <peter.wang@mediatek.com>, Bjorn Andersson
 <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Stanley Jhu <chu.stanley@gmail.com>, Can Guo <quic_cang@quicinc.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Po-Wen Kao <powen.kao@mediatek.com>, ChanWoo Lee <cw9316.lee@samsung.com>,
 Yang Li <yang.lee@linux.alibaba.com>,
 Keoseong Park <keosung.park@samsung.com>, zhanghui <zhanghui31@xiaomi.com>,
 Bean Huo <beanhuo@micron.com>, Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Akinobu Mita <akinobu.mita@gmail.com>
References: <20240412174158.3050361-1-bvanassche@acm.org>
 <DM6PR04MB657567B296717C428115D487FC0B2@DM6PR04MB6575.namprd04.prod.outlook.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB657567B296717C428115D487FC0B2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/24 04:48, Avri Altman wrote:
>> +       nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
> Isn't this already hba->nutrs?

Enabling MCQ causes the value of NUTRS to change.

>> +       WARN_ONCE(nutrs < 32, "nutrs: %d < 32\n", nutrs);
> redundant

Why is this considered redundant?

Thanks,

Bart.

