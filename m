Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5F5178CEA
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 21:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724276398; cv=none; b=aipdVxQNGeLLJC0GdYJ4G4ttOmTG1p/59YVnom4ySKf+GZujSL/yhzQDJFlju3XuNVTJDaPb59Q6qD5eXnDuss8uSvNhKlqqzknGkM+UjSXYVkSPyKh2EXEpIEcNgCXgB9QJv6KQy+si6nipFt5/K2jsCp/q3jdwahsokTob1So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724276398; c=relaxed/simple;
	bh=o2DbpWauX+tRIzEkwWw9A3E6HYWvKtIM+1HD2P3wYlw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dmuGLMbhRbOywTtE83ljLt06xEXc7GaF08/1r6ll1VdAFUozABoT/Rq0hPOmcHI7hD+dPN/5RCldhIQ0IxS6k/3I4YhIV+SDFxRkR2MVIr4yHlIhwJYKkXE6BiY4eWO5qUWqRIAH76HG8GqteMyKE/haJ+zPbBbB0JKB4rGdDco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2BS3oDhk; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2BS3oDhk"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wq09K6KTNz6ClY9D;
	Wed, 21 Aug 2024 21:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724276385; x=1726868386; bh=o2DbpWauX+tRIzEkwWw9A3E6
	HYWvKtIM+1HD2P3wYlw=; b=2BS3oDhkQXql9+YZlUDBRBAPidyasTk8yBAK1UHr
	lD5lSNh+7/01/C6QprpCeg3KD0vj6Xu00H4xu0iATJe4hMtDH+uVJncjuGUcE+/B
	RSZ78/AnaMsj3HPlJwaAS36Qg/KL8kau6Edlum8C1l2HmO87Wvd/gqh6FILVj6RG
	ORg8gfiWbaIQBXe+N1/eZNeotIE++1LJhSM4JtppBlwX5PLVjTAr2hnCn9tMCIxK
	xVq5si82rXGZWdZPAbnsyG6vskE8pkxcMffDkF+/sfpviPFoLWiUO1d2Ij3G7S99
	/ny260CP4UpoSAEPZxWAaVtsz6xuo6ljMzxnD6cMWHfk7A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mZ_sAvqEq2-i; Wed, 21 Aug 2024 21:39:45 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wq09D3f8Jz6ClY97;
	Wed, 21 Aug 2024 21:39:44 +0000 (UTC)
Message-ID: <25ba6504-9a10-4c59-a180-620ddfd06622@acm.org>
Date: Wed, 21 Aug 2024 14:39:43 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
To: Bean Huo <huobean@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Avri Altman <avri.altman@wdc.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Eric Biggers <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <0e552232c1759ba1749acb9b606a03670bbe1ba1.camel@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0e552232c1759ba1749acb9b606a03670bbe1ba1.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/24 2:27 PM, Bean Huo wrote:
> My only concern is, removing disabling UIC completion IRQ, and keeping
> is.uccs 1, then we don't read its status in case of ufshcd_uic_pwr_ctrl
> path, whether this will affect the next UIC access result.

Hmm ... I think I need more context information. If the UIC completion
interrupt is left enabled then ufshcd_intr() will execute the code
"intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS)". This statement
reads all bits from the interrupt status register including the UCCS
bit, isn't it?

Thanks,

Bart.
