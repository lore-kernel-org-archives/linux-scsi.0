Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7E92C08D0
	for <linux-scsi@vger.kernel.org>; Fri,  9 Jan 2026 20:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767992268; cv=none; b=Q4GdyW7DIl+vsBMPixAQVL2aMsC1Ye+72HOaScRqoorKGnNCfGrM0NbKkwo/JSDHM1IaNkpQHjYLRbq4h3AHqk2IxFkiq/fVeAfYrPCUx6bRPBIzUuC0l2hOXcP5GORmDKS4RpHyrWPNLYvrW1aJ3D0a5kfyEte2kolwkMeQmew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767992268; c=relaxed/simple;
	bh=pwb7b9dm2f1M4mlJBu1PB6sBUIKQA7hRqO3RWQ3AIz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=V7sZSIbGGbPdyCXts/+eh6lTM+I2FEO/yEOwpW96eafk3MqxI7t0P0jnxMVADDcEU8bCYO0cCA7bvLQgE8L8vRfGxBfUL/6WZQthQzExg96/xahwuZauRMDxE41xBekEMzbwqPeX9WCJ2zrvcfNZ5Sa15PZ/fHtIH10VAAK4aRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=i5AkXYhG; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="i5AkXYhG"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dnvHG2mD9z1XMlXJ;
	Fri,  9 Jan 2026 20:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1767992265; x=1770584266; bh=o2xNzS34FUUB6uQOKd65IYzU
	bM6aXB+Z39vOCsDOxYI=; b=i5AkXYhGtIwqFxidt+BgeCDRY3S5sOHPEgpgzijB
	8BdTk1hfyhIo1y/KCwhmkn9o1oK/85tohpw4bx1gYCtYw9A8Q88dWwyKIXTn5+Hz
	fkwYX7P0XZ3nHSQIoOHbMcpIIXaR1iuOvHdH0I9YfZ8DAZervsNHU73jWX//eaDs
	7nhqVmTEFXLUNcGHss3h0hQIoHPF8RxRkwciwnzWbjXRKC51uzmjtKVH2w3HZFiK
	ot5jTN8z1I0FLE9dtCkzpNPZh3pVSjfN7BYqfsEtX4LL+RJmIoJ8skC854spjSMp
	uwqSFEsHPywCbkzIrCeaz2mkhVT9fzZd8tpftM0oiTnSPQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Q1fwdkLndqN4; Fri,  9 Jan 2026 20:57:45 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dnvHF0ZpQz1XM6Jh;
	Fri,  9 Jan 2026 20:57:44 +0000 (UTC)
Message-ID: <fe070d43-f9b2-45b2-95d8-477154b28dea@acm.org>
Date: Fri, 9 Jan 2026 12:57:44 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Sd card race on resume with filesystem errors (possible data
 loss?)
To: Sergio Callegari <sergio.callegari@gmail.com>, linux-scsi@vger.kernel.org
References: <3bb03946-eb11-4e28-a72b-e958833bb5cc@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3bb03946-eb11-4e28-a72b-e958833bb5cc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/2/26 2:15 AM, Sergio Callegari wrote:
> 5. Purism developers have a kernel patch for it at https:// 
> source.puri.sm/Librem5/linux/-/merge_requests/788. From my understandig, 
> this is not in linux mainline or stable. Would it make sense to consider 
> that patch?

Please post the patch on the linux-scsi mailing list if you want it
included in the upstream kernel.

Thanks,

Bart.
