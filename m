Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D791D13C8EA;
	Fri, 29 Aug 2025 15:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756480530; cv=none; b=k8kxExJXwPuE7jsgSG8jpnGnuxTOOwAiKUsNIpZEhwyV5sX7YzVdkBiqdoCrBfT7UgG42qJ67g+YBbt1swRI5CjFcGNCp5+5d6D+4ufVn+BAuq7R9kQrNADnK4qgXn727U4IEinY/+SJYxXYMhs/RVTiXY/NHIv1XwHUF+HGlqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756480530; c=relaxed/simple;
	bh=DkTTUCQ5mKPKXERrUjKsr7Vof4mxcrY104yn+CqxTQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gZnUwwPq8XncZQBYqsiv3/REx8zRPMHo9uHFGSeW9s3s6K5SrFgxtRO+bCjvPgDGWMDCmryVs1PPImmlavyL9XA33o2XppkfDtlrTXtrUsFHJRYQmE30q4uYvjqFHVIveA9jzQr87pTl/EcdOKuOSrHIvcEKP8HngaeffyIRamk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dQL7D6BD; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dQL7D6BD"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cD1zZ26GdzlgqVs;
	Fri, 29 Aug 2025 15:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1756480519; x=1759072520; bh=BJcJeYK2xsZM4v+x5T0x9ijz
	Ft3fa1SdvzwK9zgscKc=; b=dQL7D6BDV7oYiLrEa8AGGUn83+5hsA6FUuXevgcS
	q9e2PJlWYgRHtD1IgqRfPnRUS+xHKbo2hM7RmCnHZb/b7NidprGjatAil0lX/E3l
	eSCsLy4zrFhwMUiElHE+V/PGlV6O8x4sA03xWVDeulHltWCR4Ool0ftDcJMFwyFx
	MzqbU5VzWP2WkIlMlaliFsOhwQenmsV1RqDys5CpDZAH58JQnwnqYuhVssNTq6h2
	exh103o3/mIVxefiKJY1305jtVZbspsIOg6wDYok21gLMlXoVd7kehuYdlmEpVOS
	DKtlzbuRTZhjm16KFObFJ/R4mwl5/muDUrLrHPZC3TKmJg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DXVxrfMPUqgG; Fri, 29 Aug 2025 15:15:19 +0000 (UTC)
Received: from [10.20.142.160] (unknown [204.239.251.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cD1zG64zdzlgqyc;
	Fri, 29 Aug 2025 15:15:05 +0000 (UTC)
Message-ID: <239ea120-841f-478d-b6b4-9627aa453795@acm.org>
Date: Fri, 29 Aug 2025 08:15:04 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: Add an enum for ufs_trace to check ufs cmd
 error
To: DooHyun Hwang <dh0421.hwang@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 peter.wang@mediatek.com, manivannan.sadhasivam@linaro.org,
 quic_mnaresh@quicinc.com
Cc: grant.jung@samsung.com, jt77.jang@samsung.com, junwoo80.lee@samsung.com,
 jangsub.yi@samsung.com, sh043.lee@samsung.com, cw9316.lee@samsung.com,
 sh8267.baek@samsung.com, wkon.kim@samsung.com
References: <20250417023405.6954-1-dh0421.hwang@samsung.com>
 <CGME20250417023417epcas1p31338c05e70e61b0a5e96d0ac0910713d@epcas1p3.samsung.com>
 <20250417023405.6954-2-dh0421.hwang@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250417023405.6954-2-dh0421.hwang@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 7:34 PM, DooHyun Hwang wrote:
> +	EM(UFS_CMD_ERR,		"req_complete_err")		\

Does UFS_CMD_ERR stand for "command error" or "completion error"? Please
make the enum label and the text that is displayed in error messages
consistent.

Bart.
