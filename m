Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9283BE152;
	Thu,  5 Mar 2026 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772723376; cv=none; b=QfwgvgRrVdsfs+EXQ0lmBEcdapObnaKOThGoSwwD6oGox4iMOllyREGrt5TL6eS8433NnpJdNNjo9LTDKHb5J4KfXAxjV37Z4kwmnA36UiqBxXFlw+LYrTROcjPEs+jxPlxgY+MfdRplne8HqYPoKSeOjtOX1u3UDypFUUmWpXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772723376; c=relaxed/simple;
	bh=AG27g/pYKkhHjykF6hoYrdKaNW7tQIlXDNEE528BQ74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aP/sEkMz0nTLDxBcojJcalSxpB/kzWyWG8/RVp9c6WcIsLi2Z07A0O69QbBU+Vqaa0qNzuFmAfhQe9hqKIhuXBIxztMYlYJmrzzDXNEPxwa8VcdsRlApLrSM9esJWHbprsbINbug4oLTW/GAcZVvkxiOistLWC+wactSDxMU+fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tLBmLqbp; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tLBmLqbp"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fRXy12k9cz1XLyhV;
	Thu,  5 Mar 2026 15:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772723365; x=1775315366; bh=2mcONpsihCbAmYppqWbdXkKp
	w85o35S8Fs8XYCgwWeI=; b=tLBmLqbpTYtogeZCu3c6+11T07pNiNhBBOWLmltv
	Dp22zmCKd5UQcGpWtLubDKS+2U9ikAajV26eC6VBXt9Mus8Dea93SgOSocalldc7
	GuSin0WHxupAth9TXO1lGKAs9OcNxpEfn9QoV/VLfoTLaymlG8FmpAqTqsz28lxl
	AXWStff21Lw73tC7jXzYu7GwsxxfG2ZA/DHuzvMDY7/4r5UcU2gEoMMFP92Bh5kX
	+Q5xPEIcHIdooCdCM33DOJQB6vw4bF71uanC+nqygE8YvPmSrzCHV2Bu6yn7LYBB
	O+0jgWvjtDlvMO3jffeeT4SBxeFcJW4NJpLl5my0Xt5jgA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zPLxizGFfs2e; Thu,  5 Mar 2026 15:09:25 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fRXxv2wfJz1XM0pg;
	Thu,  5 Mar 2026 15:09:23 +0000 (UTC)
Message-ID: <089ec667-4daf-4de0-b986-551f74d98208@acm.org>
Date: Thu, 5 Mar 2026 09:09:20 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] scsi: core: Drop using the host_lock to protect
 async_scan race condition
To: Chaohai Chen <wdhh6@aliyun.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, dlemoal@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260305025125.3649517-1-wdhh6@aliyun.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260305025125.3649517-1-wdhh6@aliyun.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/26 8:51 PM, Chaohai Chen wrote:
> +	/* Asynchronous scan in progress */
> +	bool async_scan __guarded_by(&scan_mutex);

The __guarded_by() is ignored because CONTEXT_ANALYSIS has not yet been
set in the drivers/scsi/Makefile. This is something I plan to do if
nobody else does it first. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

