Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA326EB7C;
	Thu, 13 Mar 2025 16:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883171; cv=none; b=sZawzQtfEqVmJ+fSWDs3nlO+5DGl3bOLEitlCs3G74bTkRuCgQ6p9GU2oZnyI1qo1Kg53DudxUvVnJCr/1leO8QzKQ+tB3s0oHJ4hjTGyhGjcA1oliIe4/39W+poSWRjPGuCraC2gmWiSdfySfI0UQFWv+SSDUvymx63ZVQ6/Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883171; c=relaxed/simple;
	bh=Em0Ui5F8PigPtoLnGoEikbRI2LK/Ufx47iv1gTsb/y4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HjVd2Ta0FpGY8JHU9Q+cenwg+5R6LTl7ISgMPR9v85a6sBt/0cR6eIkl9vLQPrG4IUEM72DnHl0UqjMI3upO0wkcDHe3SGDNjWxCMTqkUaWv6wRDqFtoOHwlLPct63Xu7hMuOs4eA2/GFrW+NJVwuGMcn5Jj4wSgT93P6LhAitI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Bcwj2BdS; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Bcwj2BdS"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZDCY62kH5zm0yQ3;
	Thu, 13 Mar 2025 16:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741883161; x=1744475162; bh=aloQSshe1s4DovGaYGE8z8w8
	FVdmU5aZgsOdkm3NNI0=; b=Bcwj2BdSgsFagXaTwYduhlTi+94tuwL2yBBJO3MW
	rcwag972om/wGL0K7XmuYtrwixuREsMqnVDlNzpF5roZQEbr95299xZHTnwnBT3T
	9UXeUBYf/A+FwZ4/iFsjQA9SlCL8bs5WP62/2AU3KacHBsdwWmeWZnT3a+rw8PIF
	eKNsrQPeSABOb4YLUbEPkVhQSs2Y+tXg6kTM64+aO2NkiAa14dYWt5eQrMg6nG+K
	Is/s2makgU+QmoboFd6qE5+yNTeTYFWiHi1m5y6PuZRd+FY5JT84zVw/rgivpucY
	g1mc007CJM5cYXR2+rWH/akg6KK9Oc67V68B8EoJegHKhQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZHJII6V09ldW; Thu, 13 Mar 2025 16:26:01 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZDCY23XbNzm1vbV;
	Thu, 13 Mar 2025 16:25:57 +0000 (UTC)
Message-ID: <3c32eb12-6879-48cf-9ef6-bd04e759025f@acm.org>
Date: Thu, 13 Mar 2025 09:25:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH] scsi: sd: Use str_on_off() helper in
 sd_read_write_protect_flag()
To: Thorsten Blum <thorsten.blum@linux.dev>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250313142557.36936-2-thorsten.blum@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250313142557.36936-2-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/25 7:25 AM, Thorsten Blum wrote:
> Remove hard-coded strings by using the str_on_off() helper function.

Shouldn't a patch description explain two things: what has been changed
and also why a change has been made? I don't see an explanation of why
this change has been made.

> @@ -3004,7 +3005,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
>   		set_disk_ro(sdkp->disk, sdkp->write_prot);
>   		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
>   			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
> -				  sdkp->write_prot ? "on" : "off");
> +				  str_on_off(sdkp->write_prot));
>   			sd_printk(KERN_DEBUG, sdkp, "Mode Sense: %4ph\n", buffer);
>   		}
>   	}

I prefer the current code (without this patch). Others may have another
opinion.

Thanks,

Bart.
