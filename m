Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193EA33E372
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2026 17:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769447096; cv=none; b=FsWEDE0SCcG7sTI0pO2aN+Fht7mpYgWAaUuqv3HBeZBd6WzpfBpGRWpGbrE8mNFXXGMHO98KpPXVAqfVsOWFrcHcZeSlNngHFz0lWM7PtxjwnZGoJYhINt5vsI9W1JVyo51OCLr7CbiwCzSBURDpulHZDQ1eQH4movlgdrfPzfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769447096; c=relaxed/simple;
	bh=DzH71sGLTHY/4umdgPz2Kx0QrBrLABDLct1KfBk3znQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ISrABUXsq11XPEhCVMN18sf9WINP2bx3xmCOUUMAhnuNnaCFcBJSwvjcFWK1+/Ub4ZSehcFZU9vsK9Shrj+FgWSEnEVHs/QAT1r6PLNu5sK853Baw9fAQo+g7gYi8oCsVbLQqCku/Igm35rV0upt3PStkabDkgn11M7yMs9gAmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aQq8HjPM; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aQq8HjPM"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4f0FJk56Xvz1XM6Jf;
	Mon, 26 Jan 2026 17:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1769447093; x=1772039094; bh=sdASKopwoGV8Tlli2UBc+oPt
	bWwSMfk3K/1cyNX5XMY=; b=aQq8HjPMqlBDgiFixDHNhub9ApJtHBS63dKSnOQ1
	8NIn34KW5BISpgdaZH1BDxAlCULW/zhujBi7tN7mWMu/aMdHxtT3M80u+ENHPrPm
	PRSV2WB5lDe5B6Br8AAJeHxEXcMCG6cZkyotuB+57CLiam12ouytJu8X3tT3BlUm
	wgD+RSytE3fGBeupKDQO3NgngoNSewSoAeTkg6vFkdlwBqQkJZpR2/jT6+uKy6zn
	ZtFJDNF0cid4P7xKI4fXUyedfhOLtB/PfomebhrV8bBCK46bpk71NBKMaZ5TfvSx
	LQ5+kf2lIJgNXVK1OV5RQ/HYWgUm0Q8km45Wn/9rZPhnoQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bl6d10Cmguzz; Mon, 26 Jan 2026 17:04:53 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4f0FJg59tQz1XM5kD;
	Mon, 26 Jan 2026 17:04:51 +0000 (UTC)
Message-ID: <1f5708a2-b00a-4be1-a005-c5137ce5863b@acm.org>
Date: Mon, 26 Jan 2026 09:04:50 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] scsi: sg: Resolve soft lockup issue when opening
 /dev/sgX
To: Yang Erkun <yangerkun@huawei.com>, dgilbert@interlog.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
Cc: yangerkun@huaweicloud.com
References: <20260126132745.1830629-1-yangerkun@huawei.com>
 <20260126132745.1830629-3-yangerkun@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260126132745.1830629-3-yangerkun@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/26/26 5:27 AM, Yang Erkun wrote:
> +	/* limit "big buff" to 1 MB */
> +	if (size < 0 || size > 1048576)
> +		return -ERANGE;

Why 1 MB? Please explain this in the patch description.

Thanks,

Bart.
