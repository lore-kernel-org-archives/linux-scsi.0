Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A2E4334D1;
	Wed, 22 Jul 2026 18:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784743630; cv=none; b=f2Ad2mquUTfWsJegCKz1TMxROXmkHR9BW1S8qgd3HJ4bu6EW7ubKHIxDj/dBOig4qYhO8rc4zcV69YWIoKk2Cp1V2eJRGcaDqwrfsTIKbg/S0as624e32y6k83jlB4hxt2M/EajQl6wqjYL6LlpgLfEIZhnr6APZ1vauAD1CCOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784743630; c=relaxed/simple;
	bh=UYth8PK/x9aZbWFK73/hC5tT3yzXoV5NtjOf22B4Po8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EiUFmBjL1zxyqLa/2ywgX0X5oOltikGrZM6HPmSuHOTL3JhzgpMMXiKWDr4IEBbTudS7W9q7PK5UEQtO3EWfnbAMdp8YsE4fOfePXK3hNhlMPAEkpncDenocqTtxhnCuh6NJPaz05QR1dRFpMTaU1s0PxIHCshNFLuz0nHFj0Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=W1wWBqjV; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="W1wWBqjV"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h52Jj5kDqz1XM6JW;
	Wed, 22 Jul 2026 18:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784743616; x=1787335617; bh=UYth8PK/x9aZbWFK73/hC5tT
	3yzXoV5NtjOf22B4Po8=; b=W1wWBqjV9yxpfmnbw6k4DkaxvDI5RCcW9LVDiCPU
	mdbR6oJlkmlJP9rP34IlGxUGhBX6u3Py/igF3aYwoxiI0YvUARR4fy51py6dQUx7
	b6bwcShOjFndMT/auFe9tAXY9/ft24/yRCDNMVYmpxBnSTXTFcWfkYe1pVdSd1Qi
	Hx+RmESb5XQVCuCIidZE6ZLTLZMusk69iqV5qxF6sTQQmf7PgcNn6fW9hfwVEHfv
	RwZZouV0nbH4iwDfC6FXZoRKexrG7HRP4//4NlJmjbA2ZfMxmIXOlLQfQuJUO3EY
	aHLwQR8s7o/7xJ47c911Sd8b/52FBZdlYaVQEa3MAzBX9A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LvccFMuRZde0; Wed, 22 Jul 2026 18:06:56 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h52JY4shYz1XM5kD;
	Wed, 22 Jul 2026 18:06:53 +0000 (UTC)
Message-ID: <f6ec763f-f57c-4cd4-b78b-1615bc247227@acm.org>
Date: Wed, 22 Jul 2026 11:06:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] scsi: ufs: core: Validate string descriptors
To: Li Qiang <liqiang01@kylinos.cn>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com,
 can.guo@oss.qualcomm.com, adrian.hunter@intel.com, tomas.winkler@intel.com
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <20260717153914.26321-1-liqiang01@kylinos.cn>
 <20260717153914.26321-2-liqiang01@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260717153914.26321-2-liqiang01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/26 8:39 AM, Li Qiang wrote:
> Allocate a zeroed bLength-sized buffer and copy only the UTF-16
> payload. This preserves the raw buffer size consumed by the RPMB
> device-ID ABI while avoiding the overread.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
