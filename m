Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29623271E7;
	Wed, 10 Dec 2025 17:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765388699; cv=none; b=Qf+CZXdqc2t/Vg37fkQuJ6JfQRyO3USClB2gB/WYMnwPhxNRoiJl1LRRMOuGOoUErUan2KEbV92NMJYwrwGN6+IpPPfN7UcTNHhUur69Z5UIfA6yOlzZ9IB4cmUJ9VV7hEXfjXrxueF4w/loKc1U1TYUkSgrGYW/Ebe1a+SVCyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765388699; c=relaxed/simple;
	bh=3TbvOcKYbrQOkAyrI5wr/zvMRYgyEI3+w/3lwgBvo5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gPyRqX1An79DAZkIF9ID10tWvn8/5UQx7IUU/3i1UB8ZcE+SME5Dh9WHWTEi8lFh8Q/m4FwcRYBpzX5FXC+ipdHNLuSSImM4SiVWtXVkD8+qW0rk586Sa16I0+2koFq9u9TTSugzrqktkivQ7fPt4JmVCPUZOgDAyZHxLDLpHYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qqq39O0Y; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qqq39O0Y"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dRNQd2jR8z1XLyhR;
	Wed, 10 Dec 2025 17:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1765388695; x=1767980696; bh=M+yVkJxPYmkZRcQFEkK44bYy
	oAXMqMhb+QSnamdvBpM=; b=qqq39O0YYC95C5SAk6+soB00p43KAyG72AAOIjfA
	hM7SK954r0cwxoLH55KgKNq3ihJw6PbM3FXFwbEA8ADBk8yELm+jLiEuwbcU2z9N
	7OpgU/F6EFm7PVZFty0QlbDfaJM1MRaQ82YAH8fkxcudCzUhaUm5ONKtf1aJUFTW
	jiM00ysmhdIJvPMrJC43CyPsw6R2LWJD9gCUU68t563UsXNXHu729UpnM+bKXyaJ
	rez5lrzjTMJUIC8Ubxo7Bri6m9SZv31accQJ0PKlglZNsRHJ3LEDyWDT5j7Hypr3
	VayaRc7IrJvxSx76LzXjz20sf6DOBnE4z4bI3al5aXmXlw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FAifLdFUWijM; Wed, 10 Dec 2025 17:44:55 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dRNQY0ttbz1XM0pg;
	Wed, 10 Dec 2025 17:44:52 +0000 (UTC)
Message-ID: <955ba65e-424b-4968-9541-ab235a7bafd3@acm.org>
Date: Wed, 10 Dec 2025 09:44:52 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix error handler encryption support
To: Christoph Hellwig <hch@infradead.org>, Po-Wen Kao <powenkao@google.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER"
 <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20251208025232.4068621-1-powenkao@google.com>
 <aTkXqslvwMOz2TUG@infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aTkXqslvwMOz2TUG@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/25 10:48 PM, Christoph Hellwig wrote:
> As mentioned last round, why are you even calling into the crypto
> code here?  Calling that for a request without a crypt context,
> which includes all of them that do not transfer any data makes no
> sense to start with.

ufshcd_prepare_lrbp_crypto() only has one caller. Moving the new test
from inside ufshcd_prepare_lrbp_crypto() into its caller should be easy.

Thanks,

Bart.
