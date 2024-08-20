Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12BC154C10;
	Tue, 20 Aug 2024 21:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724190672; cv=none; b=FOXXQoeSg41zir0RPjUdLzNQIC/A+P762ThXE6rfKcqjOAEQAZzMzpOoaVnVUPg21dPIPzRc5Oxyl4CsIpNa15pRyiqKNqmgjkwbYz8hi/qHLH+VmuQhfahw8MGbWKKEPa8ZGs36dF6OS+c7xbo/nE7MY1iJEgntwEH/R+95m5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724190672; c=relaxed/simple;
	bh=0L1O6nBUPkZMSJQzJolFrr8G13WOrW0A8rifEKPyduo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dhC8SEcXGTybMgWhYPmNMcKMv0A/wVOr33Sf6m/SwEwryuajJLiDThstCl8Xw8m57L8SzVOnn3D+MahTn5HGS1h/bFj1mOkZJRYfMYLQ31mPiqypnkzTkrxLMqAqOyoRs/fDgh6WQB0UOvtDw/rM3tNFDooURtgEJS4jHW88wU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Bhuv1MK4; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Bhuv1MK4"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WpNSr6DKXz6ClY99;
	Tue, 20 Aug 2024 21:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724190664; x=1726782665; bh=4M6UtsDH6zbj+49hMxxCaCbS
	KNGOOv9L0xXRKC/ySD4=; b=Bhuv1MK4CAVH2Y2LzWSMJTqH6vk6d/n7jD9Rbcch
	vBXEDaioWZhEeTxAkdYmbfY07/TB0hnMSXOgXs0MdJHfhJ0aPZfdZ+14msVONmrP
	yBbCheZQG0ttbkq7N7fXRNCeE0KD48w+oPpVVuzeOJV70H3f+GwD/u+JGgfQdzL3
	UieuaXaaXTo5pAc623SDuvk9ew2hSCPdFDWI7G27LTDJTDgWZgxNUUIqzVpZzRtA
	T5cX/EIPgDbRK/m3laWw+Qrh/mNVQWDZkuFkyFOTKA52/k4AUunWlx+xmq0uB5A/
	gF92Yl5+jPQSRsvexVHkPb7cnVxnc9O1kVEdkSqDaShTsg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PX60NJXrcjlA; Tue, 20 Aug 2024 21:51:04 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WpNSj1KYHz6ClY98;
	Tue, 20 Aug 2024 21:51:00 +0000 (UTC)
Message-ID: <223cc3ca-9214-4ba1-a3c8-2d672aef52f9@acm.org>
Date: Tue, 20 Aug 2024 14:50:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: ufs-mediatek: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP
To: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
 Mary Guillemard <mary@mary.zone>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
References: <20240818222442.44990-2-mary@mary.zone>
 <20240818222442.44990-3-mary@mary.zone>
 <20240819120852.tdxlebj7pjcxjbou@thinkpad>
 <ZsOJKMg8xlpdgoi5@kuroko.kudu-justice.ts.net>
 <20240820060946.ktiysu7sn7qgbwx4@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240820060946.ktiysu7sn7qgbwx4@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 11:09 PM, Manivannan Sadhasivam wrote:
> On Mon, Aug 19, 2024 at 08:17:10PM +0200, Mary Guillemard wrote:
>> On Mon, Aug 19, 2024 at 05:38:52PM +0530, Manivannan Sadhasivam wrote:
>>> On Mon, Aug 19, 2024 at 12:24:42AM +0200, Mary Guillemard wrote:
>>>> +	if (host->caps & UFS_MTK_CAP_DISABLE_MCQ)
>>>
>>> How can this be the deciding factor? You said above that the issue is with
>>> MT8183 SoC. So why not just use the quirk only for that platform?
>>
>> So my current assumption is that it also affect other Mediatek SoCs
>> that are also based on UFS 2.1 spec but I cannot check this.
>>
>> Instead, we know that if MCQ isn't supported, we must fallback to LSDB
>> as there is no other ways to drive the device.
>>
>> UFS_MTK_CAP_DISABLE_MCQ (mediatek,ufs-disable-mcq) being unused upstream,
>> I think that's an acceptable fix.
>>
> 
> If you use this quirk, then you need to use the corresponding DT property. But
> using the 'mediatek,ufs-disable-mcq' property for 2.1 controller doesn't make
> sense as MCQ is for controllers >= 4.0.
> 
>> Another way to handle this would be to add a new dt property and add it
>> to ufs_mtk_host_caps but I feel that my approach should be enough.
>>
> 
> No need to add a DT property. Just use the SoC specific compatible as I did for
> SM8550 SoC.

Mary, do you plan to implement Manivannan's feedback?

Thanks,

Bart.

