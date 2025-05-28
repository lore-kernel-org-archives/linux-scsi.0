Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA82028B51E
	for <linux-scsi@vger.kernel.org>; Wed, 28 May 2025 15:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748447008; cv=none; b=uYqP7uYOIUoC8jB8EVA9N0R2ELaqU9m3tj4KB/YRGILnD6GsiYPCPPkf8A8ru6betUGTAUEKMCnuqfOUgYhDFDwUem1/N6bRkBVwv51KBgDn/f1ElhhZaq53hEE0CYAoM9/pSYUp+FX7IlSpb5RFPY7tJbeT6WiChPzKrJTRcOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748447008; c=relaxed/simple;
	bh=0yaH2dMO/TCY7LYbG4iNuPYubcvdBxUCA+/KZk6/1+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=POjhXCWDfe/Qeqj+4vkJUQh/GU8/OpbKwz9iFCk1ZPVkAlXJ+nFiEZyA4WwK9SUTnIdxnX4sP08vz2UROjqbr6BO+lJcCH1BCtiVDqId3t/eVPGu/JoI19Qxf3bcjArNpmGITTlDUnkTxh7FUwYKmYJlwiaFHpZidHTWxvxgGhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=E9mg7DMr; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="E9mg7DMr"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4b6v0r2Tqtzm0yQ3;
	Wed, 28 May 2025 15:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1748447001; x=1751039002; bh=0yaH2dMO/TCY7LYbG4iNuPYu
	bcvdBxUCA+/KZk6/1+E=; b=E9mg7DMrdxUBqT/wZ3vqmlteWOyP+XjxEd6/lHd5
	Dnp6cc+sga6LohPKzSlEYxIdPqxfeIB9g9TPLBbKu4Osk0KEogHJHecJgUqa4kmG
	RXEaIDWFGzwrK7Gk02p+YIXjlB5oTZE6QPi5iOatR8R4KedWoPhhc1vS0wvTGn6l
	2D6An/2dpuG47Rg71E6KI8VaYtEVMad9Xd68mMjAYSxIz22LIwBuK781buprsbMP
	B7A5o6smFHU+PQajkB+M9gnNoKoC2ddFJiqB/alURlAC2y9NCWqAj/dLGocAwCLs
	IaqrkY6NiSOeZCLDoR3c4GN7eNnclCUJTBwucelUfMIZCg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ihxbsbtG6NGz; Wed, 28 May 2025 15:43:21 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4b6v0d5HWgzm0pKB;
	Wed, 28 May 2025 15:43:12 +0000 (UTC)
Message-ID: <6d82c9dd-b93d-4400-9500-a850b1ba0bb7@acm.org>
Date: Wed, 28 May 2025 08:43:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: ufs: Fix a hang in the error handler
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>, Sanjeev Y
 <Sanjeev.Y@mediatek.com>, "santoshsy@gmail.com" <santoshsy@gmail.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20250523201409.1676055-1-bvanassche@acm.org>
 <2ab0ae98fd101d893d4f20112771cdb623fbca67.camel@mediatek.com>
 <ecfd1748-d257-48ae-808e-c672ac2f1536@acm.org>
 <32f45a00d5c1cdf26f91bde4821fe73d5b06dadc.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <32f45a00d5c1cdf26f91bde4821fe73d5b06dadc.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/28/25 1:32 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> However, before we can identify the root cause, it seems there
> isn't a better solution for now. What do you think?

Hi Peter,

It seems to me that this patch doesn't have any adverse side effects and
also that it fixes a bug, namely that ufshcd_set_eh_in_progress() should
be called after ufshcd_err_handling_prepare() instead of before. Do you
agree with this and do you also agree that it would be good to have this
patch upstream?

Thank you,

Bart.
