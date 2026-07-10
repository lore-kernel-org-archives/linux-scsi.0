Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F400349CC4;
	Fri, 10 Jul 2026 14:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783695405; cv=none; b=O+lAvChEm6+9CjMTUj0ceSckQb3mCsGn+YrSaBh1kCmDtol4yF5CK7zrmF9aahKJBZ17jeoCgibpbS3O8X0HnY6o6BGPoOdI9mYxo/bX4znHCFXzQhz8M+KFxtHST+i0uxiTE55cLZOn/G7TqJ1mOGr+KvlJ9NgnLSsXv/T/mRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783695405; c=relaxed/simple;
	bh=95rDyyH8uLVV8MUfCUmqcc0G6oFkhuuh2+NqEXmebOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ndd6HnCnF8+rtBD68uJvza9DKH1Vtea36AXYIWLtAHROENCrwv6e7ChgL/vcpegweWjBSLA3CVfnRKGfDqJuTON5wC856i3WzZnZ1FZfbFNhzrABmubsIPn7HDxGTLfMMIestaNeV3z4gAiQhjj0GQl1xYr4wqhqsxv+6NrBuFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WtG9+2WW; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WtG9+2WW"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gxZff6qcTz1XM5kW;
	Fri, 10 Jul 2026 14:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783695393; x=1786287394; bh=k+M2661nw/s4/8gpr7YATI9W
	2QztJaegEdr1VWFAcig=; b=WtG9+2WWuTWnl1hM8ijfcbogrIGQPobTLsJxKkYJ
	4P86UqywYQyqXFK2bwWkAM9cWHanRVQVKpJ1AzQecBCQX2zMhqVYxysIfmLoVS/2
	41kaysIpIZPY6Ur8+rXqbwnuA5pm9VAc+38RjTmky28/PhIP7OnwsFuZjSCHuJxT
	p8aGZPCyessyN2OafZZNOYh9cjODfsLFgx0pTBqDJwMd2RWkmGd0y1oBbovrkDu4
	hs+tIxX6nCdkUzDqELXIm4xZYCPWeCC/9dA+2ruLA8p5NuGdPgMs+NnxZY4qIQYo
	1KmccJxly0KKY/LbkJkAM0BOU4vjjqPnimXN/ZmdVpN76A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HPIJqu_hWt31; Fri, 10 Jul 2026 14:56:33 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gxZfK2PMKz1XM5jn;
	Fri, 10 Jul 2026 14:56:24 +0000 (UTC)
Message-ID: <d426b4d5-cdf5-4090-8e94-62e652f712dc@acm.org>
Date: Fri, 10 Jul 2026 07:56:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Significant Random I/O Performance Regression in Linux
 Kernel 6.18 (Up to 27.7%) Likely Caused by Commit 3c7ac40d7322
To: =?UTF-8?B?5a2Z6a2BIChLdWkgU3VuKQ==?= <kui.sun@unisoc.com>,
 Neil Armstrong <neil.armstrong@linaro.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "andre.draszik@linaro.org" <andre.draszik@linaro.org>
Cc: Peter Griffin <peter.griffin@linaro.org>,
 Tudor Ambarus <tudor.ambarus@linaro.org>,
 Will McVicker <willmcvicker@google.com>,
 Manivannan Sadhasivam <mani@kernel.org>,
 "kernel-team@android.com" <kernel-team@android.com>,
 "linux-samsung-soc@vger.kernel.org" <linux-samsung-soc@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
 =?UTF-8?B?5byg5aaC5rOJIChSYWluIFpoYW5nKQ==?= <Rain.Zhang@unisoc.com>,
 "cixi.geng@linux.dev" <cixi.geng@linux.dev>,
 =?UTF-8?B?5ZSQ5pyI5p6XIChZdWVsaW4gVGFuZyk=?= <yuelin.tang@unisoc.com>,
 =?UTF-8?B?6ZmI5paH6LaFIChXZW5jaGFvIENoZW4p?= <Wenchao.Chen@unisoc.com>,
 =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
References: <12a8417dc8644a71b9cb25c53c93805a@zeshmbx08.spreadtrum.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <12a8417dc8644a71b9cb25c53c93805a@zeshmbx08.spreadtrum.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 7/10/26 12:17 AM, =E5=AD=99=E9=AD=81 (Kui Sun) wrote:
> Through investigation, we identified that upstream commit
> 3c7ac40d732232fec0ba31d0a5e3cc9c112fc2e7, merged in April 2025, is
> likely responsible for this performance drop.
Two fixes for that commit are present in the upstream kernel. Are these
fixes present in your kernel tree?

commit eabcac808ca3ee9878223d4b49b750979029016b
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Fri Aug 15 08:58:23 2025 -0700

     scsi: ufs: core: Fix IRQ lock inversion for the SCSI host lock

commit 034d319c8899e8c5c0a35c6692c7fc7e8c12c374
Author: Nitin Rawat <quic_nitirawa@quicinc.com>
Date:   Tue Jul 29 04:27:11 2025 +0530

     scsi: ufs: core: Fix interrupt handling for MCQ Mode

Thanks,

Bart.
