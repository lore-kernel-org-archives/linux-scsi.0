Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2D420ED;
	Tue, 29 Jul 2025 16:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753804946; cv=none; b=G7/aQ0PLaBMMqgeUkIqBLKEHGDMi2ZKP6HcQ5uFseNo1ByU2nsLJGPefGt+RZAi188QMxQFudV/bEDG4zkn5FEh8awerS1nB2b4pTaMw/Dopj5kW3Dsa4uFTCz5qNJ74J3aubKRsbZn3kqsZ0x6BmoyUXh/SEJHNMIYVjpd1ac4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753804946; c=relaxed/simple;
	bh=DgOOyW4bnQ1fsfxtNFV0vK/zBqC5/IWaRvqjVw7oaKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SZY4PM7hkN3aY99koQUGP5KRNi2LXGBmeNHLw+eEzwaUFoj83Vs7AW11LydlGxUl87Z6Z/aMnmdk01HVnboVLIGcynbpN/JtuqOwRn46/kl0iQoMC9Wwrc4a/+nnHKT+N+bM6efx1azzDt53I61QjKpCEktIqqgbkubN2TRDh2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IoAm2fx7; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IoAm2fx7"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bs0V210qwzlgqTt;
	Tue, 29 Jul 2025 16:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753804936; x=1756396937; bh=DgOOyW4bnQ1fsfxtNFV0vK/z
	BqC5/IWaRvqjVw7oaKU=; b=IoAm2fx7IGKBJ+/B+kVLOyRQA0b11mRbVYTc+0vU
	qTdliOFH+U9Md4XrpJuZsfQ+YO+90yZj0ULXvGJ+v7PHHmRKnzvFrYd+e9nKEBbF
	SKqaTxyUwxMB2y7RlMnIRO8rAQg7SiWLcQ2UfJ/WmGP7tqxwf6vBe0N+ZrMUq2YT
	NvR6pJeEpMjdTlU6a1/2Nuj/V3BQZsAniOnMFH3hi0LMNIw8Qc4NTidQ8e84KJEh
	0vd9X7QQuvREyIEXSQgsk1w2B+b3jrMhAMnk659CuZ/at9TeTHz8pPGMMvD049ys
	RjgvEn4mTldTDKXxTlgo7SNCImw0tM7XO+iU15yiETN7vw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IakzHzLVHy8P; Tue, 29 Jul 2025 16:02:16 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bs0Tw4vh8zlgqTs;
	Tue, 29 Jul 2025 16:02:11 +0000 (UTC)
Message-ID: <b08bc755-e70d-41a4-8323-30958aa7df86@acm.org>
Date: Tue, 29 Jul 2025 09:02:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: scsi_debug: make read-only arrays static
 const
To: Colin Ian King <colin.i.king@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250729064930.1659007-1-colin.i.king@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250729064930.1659007-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/28/25 11:49 PM, Colin Ian King wrote:
> Don't populate the read-only arrays on the stack at run time, instead
> make them static const. Also reduces overall size.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
