Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F40315D26
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 17:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761585294; cv=none; b=gNTrJxGR9fkroQbRHk22++U9EEKxuwLK3wLv44KpEzG2a9fvfDFaLX864RB2h5JTmwYzm8bQ5reDKdJJy20ne5Dgi3bRSINRxPzjSXZPtqNGm/QzmqogGL2fyEnWV4EIJRMs4IP44FagdHUqX12ufysuf4sEyVi7rXJXCdUdjAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761585294; c=relaxed/simple;
	bh=avxuDASd6iUzGg84OyeE3MVqAUin7Xwk56L7tHLFLHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rMiKHL0P/c8pUCxdC2HRC1dIAFXmnih+UNo6h/YCJ7WiGQU2IJYoVIYPL1M99PGnwtlYo7T3CyUO3fzpdt2F6Tv2Y28XMDwBl05ogOMTtzwIUvbXvLCaQnN33AbAcSI1YCzaprDMmlxPsctB3N0vxLnnCsfNPDdfs0q3iwu/Zso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=N3dQMaIi; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="N3dQMaIi"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cwKnn64RVzlgqTx;
	Mon, 27 Oct 2025 17:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761585163; x=1764177164; bh=4ckVXU9BEF/ZhGkG42hrfAbb
	oGGXj9ndQedxdyimhHg=; b=N3dQMaIiJJ/RIFm8o58F6FRJWGzKU0jA9hRl6dg/
	aR08mRR/i4ZL/TiYASLpvgwoT9uiaNJuyvZU2vsL61OatPYyh3UcoHNNKTvN4X3o
	zAYl6PiT9ZZ/cfiZrJf0b/jCRq4+30/aDXkNVRfBbkqWM80WMtt+iFU14GwEBsgF
	VUAVFXRiS8jseGrXfmgjOFHZjeoFaX8D6ONcO2CPiWnkFYgC+UPTn64Nr9tzQ2m1
	b9Ly2LpLQqUPP+U+1qf7bmZcVtrqmz/3K8FujIQA4LWL2yTpP+e8NSwI1faWXlpU
	+Nh2W+u7kOT3wU9diD0Dn3g6yjVroXA4L1ftAeYYS8zFog==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iJFPRQfyjdJV; Mon, 27 Oct 2025 17:12:43 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cwKnd4zFTzlgqV5;
	Mon, 27 Oct 2025 17:12:36 +0000 (UTC)
Message-ID: <0c933ef7-e09a-419b-a1e2-836eb2d8d9e1@acm.org>
Date: Mon, 27 Oct 2025 10:12:35 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] ufs: core: Fix a race condition related to the "hid"
 attribute group
To: Neil Armstrong <neil.armstrong@linaro.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Daniel Lee <chullee@google.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
 <20251014200118.3390839-2-bvanassche@acm.org>
 <22566543-7e70-4586-9c7f-22e9f9dbebcd@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <22566543-7e70-4586-9c7f-22e9f9dbebcd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 7:04 AM, Neil Armstrong wrote:
> I've applied this change on top of v6.18-rc3, but I still get the same 
> warning: [ ... ]

Hi Neil,

Please take a look at this patch series:
https://lore.kernel.org/linux-scsi/20251027170950.2919594-1-bvanassche@acm.org/

Thanks,

Bart.
