Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B42C1EC01B;
	Fri, 13 Mar 2026 21:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773438988; cv=none; b=j3UxvGnvQpM6tMRM7CXU4Kt2tSeoySBMpOWW5dgw30X3oq3VNJHCTOoX4kVPYdJhq5myDLuZPoxg1/eukglvYQaQwmp3BQDXg8UQpOIUOtx0vnz7kwaF9H+WNjW/n7apmaJ/oegpVF33XrPdf9cM5AV10Hs52V8qUTEHPHgwVB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773438988; c=relaxed/simple;
	bh=V4oZSkQu6T/a0BfmXwdgdm6hzaytdJTtyyvou5AvV8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ICEeSipduyl5YN4xHiUF3jK/gIh3jxxYp7G39D2VKzinG5uTlD8Vw0o6WoOFH0u5Dqp1+OHWrNGyN8uHrWYWIS6a5ePKn5ygVIF64hnvcKwhL0PFZq0tVueiAI6Vw4X/IXr/9bwTPkfKy3FXsgGWJps3eiZrbUAHoHapOMRDMCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zUbDJSr5; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zUbDJSr5"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fXdbv0371zlgqw4;
	Fri, 13 Mar 2026 21:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773438982; x=1776030983; bh=V4oZSkQu6T/a0BfmXwdgdm6h
	zaytdJTtyyvou5AvV8o=; b=zUbDJSr5v0j8Kv1asu7xXLMF3lDZvqSWJW36+5sw
	P9O00VBGURLzMj2hysAuyYr0vqIkJbhOaf904Lj+dQSc0Ipk7LwohmsmmFIPLsyU
	y4Dab3KMDtj55xPpdi9q3B4GO8Kdyi8fcpGTBPZA1g4kHBfQdjw8yX8w3C5uY7qd
	O0zD4yuob+FM6zrYDS9YL/4HpuomE3/0X7Xks6+Gcqrx1YWXejiJAic1e7wjaqWl
	DVfNAbeY7YuvDmGr7MPlaj2qFXPv8ThWpfI3RHgfZnESkCTB6hIQ++BqI40iFSx5
	UPznAjzbBOYripOKvip0Tkeq3NZ/ZRZYRTv2gmRbTp5KRQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6gERkaWR6Y9l; Fri, 13 Mar 2026 21:56:22 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fXdbl444Kzlgd7G;
	Fri, 13 Mar 2026 21:56:19 +0000 (UTC)
Message-ID: <d4b09db7-db5c-4d99-afb2-47deffc0cd17@acm.org>
Date: Fri, 13 Mar 2026 14:56:17 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/12] scsi: ufs: Add TX Equalization support for UFS
 5.0
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "open list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-kernel@vger.kernel.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-arm-kernel@lists.infradead.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/26 8:13 AM, Can Guo wrote:
> The UFS v5.0 and UFSHCI v5.0 standards have published, introducing support

have -> have been?

> for HS-G6 (23.2 Gbps per lane)

Hmm ... my version of the M-PHY version 6 standard says 46.6 Gbps for
rate B or about the double of the rate mentioned above (table 11 /
page 45).

Thanks,

Bart.
