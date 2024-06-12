Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBB5257D;
	Wed, 12 Jun 2024 03:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718162743; cv=none; b=PZ0FGeCkohoh6dGt0ImvrlVmmJDvhn8zM6hUVNLMCJBu1pXV049xXV1GTzjv2h82BdqxYhcF3X1q6unsldZdLncAVoFPOtdowpCm0tP1cmzSYEiCNyCAzOUm48I6hVWCcgA33xei7p33UC/l58iTHjJH+DnmuY/cRhmEIJrfvI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718162743; c=relaxed/simple;
	bh=iMWncPHYPydrux5rYRs6PnCrsN6oJs2odMDwiZPE62k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PqhtcQa4fBqznicVAF7D6MoU1zAWKj0RtGVLF9VC3oe/LhqMz7EDz8somGsLN73DOmv4Umguy4S/ZcwLs+/cl6zFr3Nb74/QUtiDXkeOOJxmNGh/flOJnM8NwE53GFkna/dmeOfL2k5spKyPqAzPE8HhrfbJV18ithqkHQgW980=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yHVivWEg; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yHVivWEg"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VzWC93YDzz6CmR5y;
	Wed, 12 Jun 2024 03:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718162737; x=1720754738; bh=iMWncPHYPydrux5rYRs6PnCr
	sN6oJs2odMDwiZPE62k=; b=yHVivWEgk+n0ns7Tj0DKA56ngNZAi9mgjq5zNKPy
	eaByYbLeHI8wutT5hOpZjH0/dACrLAV+IPwYSetTrgZZ096e6SmPEfLrmZ6xZsIE
	rfbqK7dzzeGYn/UYQ7B3DD1aXgQczuUsdTU65hnHEQJlYYJzz75XMjQs1n740Am3
	GMjg+T8mNcCEBp2jjWxSRMBcIS0SoMYXDZoEAv9ANj3/5wkP1DAIaYoSdPfvJyLi
	Hh0xDbgjREWFDtUWk5aaQ+edkADRdSYOYhGYy+81nJs5fgUsIQqdKtJ1rRglXJkI
	V2oR9TOetyGrAtDdBVSYIEGCsw8zIXgSZvF/OTXsY8DJeQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id J0-pcmOiW1ps; Wed, 12 Jun 2024 03:25:37 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VzWC16v69z6Cp2tZ;
	Wed, 12 Jun 2024 03:25:33 +0000 (UTC)
Message-ID: <7d404d79-7938-4a3e-9420-59db86dfaa83@acm.org>
Date: Tue, 11 Jun 2024 20:25:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] scsi: ufs: core: Support Updating UIC Command
 Timeout
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, quic_cang@quicinc.com,
 quic_nitirawa@quicinc.com, avri.altman@wdc.com, beanhuo@micron.com,
 adrian.hunter@intel.com, linux-scsi@vger.kernel.org,
 Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Stanley Chu <stanley.chu@mediatek.com>, Peter Wang
 <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 open list <linux-kernel@vger.kernel.org>
References: <cover.1717104518.git.quic_nguyenb@quicinc.com>
 <f3fded35cb250e16ee5aaa67d7a7288fe2799fd7.1717104518.git.quic_nguyenb@quicinc.com>
 <yq17cevym2d.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq17cevym2d.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/24 6:43 PM, Martin K. Petersen wrote:
> You requested changes which means you are on the hook for a review...

Thanks for the reminder - this patch got overlooked. I just posted a few
review comments.

Bart.

