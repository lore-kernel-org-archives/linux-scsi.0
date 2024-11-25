Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BE71E480;
	Mon, 25 Nov 2024 23:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732576133; cv=none; b=iR+AMezoJ/9pBoZHwJZ3Yjtae8T9yHJtxOXDN2/hASUQkX/BKE/K0yzZ08TlutJURdZAQD7LKBD6kFKB1nQp5eW2KVlSOfHFfhQEnGDOFCEkCnElMNPkBbluhY2HnV1/7b3yUMuFHOmfuPiB6JOot+16xvoWXXhkDozUcZG3hN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732576133; c=relaxed/simple;
	bh=31puhMulCD8/ppqyFC4AqChZoaOHyRWwGV6u2C/Uan0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FxBVcvWw84RyZ/WrIGmf6VF8+vDHe4NF2pPfBrGbAjrDQ/VJF8XQ94Avunu6gIvuzvWRNcBLvMwiOszbJYojJGI8FfP+gGR94OVjIDr+Sih3JB+5waaEGJNPZ4azLzsq4l18Ukm1e9Uz05r8np6MZ1FghAR9vNG1COrE7bhfjXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Zy/Ji6MV; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Zy/Ji6MV"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Xy1bl2vzFz6CmR09;
	Mon, 25 Nov 2024 23:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732576126; x=1735168127; bh=/cmwgtSr59y+MI+vq4ZEyLzw
	P+8DgR2lIEUKm5scq3w=; b=Zy/Ji6MVUg5ptLfsS0UqkXeW6iNl9Z+JHL/CyQ3w
	1F1SY54U++UOSaJlwF1vEvPInl//KBJQCE5qqQQhGeoq+BgmsPWfaWRjufRD7uFT
	XDIOMadBAH5WSNSUu37mp2nCBAqKbMJqzEesxHkoP3MeIND+jVg7h1sg5cPea1Tk
	j0bWJ5bUmUwQpW5FJg4GsYjJTxgpBll4/DNylpSc9D+NTTFf7KpdZzPs0sj5WA5u
	qQv7drPFHDXqMjrynzussVNyXrysDa5efzHHmxnzJZao0yif1R6DSw3y6nQLu3+g
	ITIqwD56Sqff68h7rjXSA+VGGivm1n+SpI7PaGa7xHErDQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ryrVr9otGqwg; Mon, 25 Nov 2024 23:08:46 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Xy1bc0jTGz6CmQyc;
	Mon, 25 Nov 2024 23:08:43 +0000 (UTC)
Message-ID: <4a8d584a-7a0e-4ce8-806e-d6aee65fc378@acm.org>
Date: Mon, 25 Nov 2024 15:08:41 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: sysfs: Prevent div by zero
To: Can Guo <quic_cang@quicinc.com>, Gwendal Grignou <gwendal@chromium.org>,
 alim.akhtar@samsung.com, avri.altman@wdc.com, daejun7.park@samsung.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org
References: <20241120062522.917157-1-gwendal@chromium.org>
 <a487b02b-72c6-4bee-bfdf-4106cda96f36@acm.org>
 <fd764f6f-8486-b4c9-26f9-2ff9d903ac7f@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <fd764f6f-8486-b4c9-26f9-2ff9d903ac7f@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/24 6:12 PM, Can Guo wrote:
> We are the user of the UFS monitor. And we are about to integrate UFS 
> queue depth monitoring in it.

Shouldn't such functionality be integrated in the block layer or SCSI 
core instead of in the UFS driver such that this functionality becomes
available to all block drivers?

Thanks,

Bart.

