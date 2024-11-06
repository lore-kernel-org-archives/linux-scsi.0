Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49517207A0D
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 17:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730915476; cv=none; b=Snpa7z2KZWNjWyjpM6zEROJuTlbNtIcaaoAkgWQ81EcrxwU55eu+GZ1wh4/EeIg/XCcn7uswLNra1ylkp4sgXj/6MM0v6dJf1dwCD+3g7alWDMcFkocCMQjw6jL6wSFHd7VFqPsZNTq2QrohpuMtgvMKECs632BIYvrPFrngukw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730915476; c=relaxed/simple;
	bh=eU9CcdnZYLPOhHyiyLkC8SfWxWblgI3/coY3qkKqCvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oiOUFsBUgIyscekH3htJd40eqHPOMNgokddsJMJdQNu2rx8ZAcOZkUZ9TrHrpJ8HZ6cHPk6SNjepO9Fz0VxOz48MJnTuaSckWH47Fv4o855iToVtKUb4Y577WMFv3BUwSX2FqNl/aLe4+kSqK4jf2+t5QfUsVMp6FwrcYHFLqYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rFvPumZ0; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rFvPumZ0"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XkCS14SGkz6CmM6N;
	Wed,  6 Nov 2024 17:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730915470; x=1733507471; bh=sG/VtnInJhA77R9bGSdZyqv5
	W8A9NCkwWQogfWWnFIs=; b=rFvPumZ0rWgNne4xmS3Mx37+CJCvKOlwhg8+ArDo
	qBcGQAfey0UDKhdcy1YmEYkTN+lIZIv0j0WGBCt4Zra10AuxBedRkB/dGIiRzc6u
	a5AepbpkG8tVskUE63W5nkiXgQoA3dx9enW0mzep2jJGXHOz22hYQBDrXxGcOFEa
	tkM0Vi1ldy0mt+DE72XvBhqHIZkqKntdszB8Vvsi/lglIQev4ck/4MvnRJWIV/Hn
	KgqXAeYAq7Xn4UAF4Sv/tg9TC+4n3aBpn2yIv7HFM0BYr8x/zP7sTT/MTlWv3OnS
	WgMMPH+teTY41ODoX4JTVv91Vt+DhCqKRcGhpmjRL4n0Kg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id O8Fp9N36jAgL; Wed,  6 Nov 2024 17:51:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XkCRw56s3z6CmM6M;
	Wed,  6 Nov 2024 17:51:08 +0000 (UTC)
Message-ID: <79516d73-7ca1-4af7-87cb-d8d87d4dc6ac@acm.org>
Date: Wed, 6 Nov 2024 09:51:06 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/11] scsi: ufs: core: Move code out of an
 if-statement
To: neil.armstrong@linaro.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: linux-scsi@vger.kernel.org, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20241016201249.2256266-1-bvanassche@acm.org>
 <20241016201249.2256266-12-bvanassche@acm.org>
 <0c0bc528-fdc2-4106-bc99-f23ae377f6f5@linaro.org>
 <afaca557-6b7f-4f48-a38a-19eca725282f@acm.org>
 <19b75e1d-bc36-494d-a33a-d36a1646bcc7@linaro.org>
 <6b20595d-c7f6-42aa-922e-3671abd7917c@acm.org>
 <1c9acc01-7b1d-41ac-a0da-4e50dc8f0319@acm.org>
 <6b37ac2c-e3bd-48d0-bc50-4fa2e5789d3d@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6b37ac2c-e3bd-48d0-bc50-4fa2e5789d3d@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 1:57 AM, Neil Armstrong wrote:
> Thanks, it does fix the issue. But it won't scale since the next 
> platforms will probably need the same tweak in the future.
> 
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD

Hi Neil,

Thanks for testing!

The comment about future platforms is not clear to me. This patch fixes
support for a non-standard controller (reports UFSHCI version 4 but
supports UFSHCI 3 register set). Shouldn't all future platforms support
the UFSHCI 4 register set?

Thanks,

Bart.

