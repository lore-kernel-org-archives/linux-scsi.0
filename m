Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8BC101E6
	for <linux-scsi@vger.kernel.org>; Fri,  9 Aug 2024 19:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232166; cv=none; b=Ah4RlryAsuRsmnEzG0Pf7v7R4211p7XmhKS1fv/KRr8J/xzSe4VMZ2cb7NkbZZng0vASJHvy/RnTihdoN/6HJikIQT5EhZcx07QWY5TS7k635RUTwxrTBV2b0ENfWkWTLQu5l7G0okmHTa3LjUCtwtx7lXPHyyXHvBV7Nv6dU/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232166; c=relaxed/simple;
	bh=kkJXrKFt5oxZLzNCyrcakygxeAu6055jh9xbdi/Wmq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QWkWkihb1Wb07+wyN61WVeVAnJ0SGrmag1OQ8jtxlu6XG69RUmhRX+eo/zMLwja28y2NYs60gmdGBADPkMq78cImfiCgSVm6pMPu+RfMrrByDRIANdxjOu6MJXoHz6/uuxhruG4Vnw7IvJiG2zma8wsM1FNUM+Bu4mYFoQs1XhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3G+pnOK6; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3G+pnOK6"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WgZ002nfpzlgVnF;
	Fri,  9 Aug 2024 19:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723232158; x=1725824159; bh=E0giEuEpe7i8zK9IU7LLZaxJ
	Y4PfX6aR1R+zaYxONmA=; b=3G+pnOK6s+9LxokER83JXDYO+lIpvnQKvkyopHmV
	fBTB5jidSF6zXA1fbPzpREyJjUMB5vX+0psiXSnFhqo+f5cTrYYOXP1D8rrQSOri
	3d4SRwzmbp6ECaXg3I7u4sfnd2dtQjChx1Hld8zd7Rn/N2yb/exCYUCNgarSDPGo
	0hFTwQnvR30Wuo0yLytvGi0Q0HuFE3bpQ1nuwX5cIGcIIIExB51Hs4uL0PjtNm0V
	GvhysLA4cCdyv8eLLBPyul943geklXhh2dH5pBdbETdsQy1AGN3mVyBBfIz2Xxi4
	pFyBcxPqNOJRGa+vn/Cz+2GM9WHMKW6D2oWwtmRjOBPsmw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OW2X9pWjAXId; Fri,  9 Aug 2024 19:35:58 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WgYzy1X0FzlgTGW;
	Fri,  9 Aug 2024 19:35:57 +0000 (UTC)
Message-ID: <358d8cd4-20bd-4f99-954e-ce3afd626b94@acm.org>
Date: Fri, 9 Aug 2024 12:35:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: core: Retry passthrough commands if
 SCMD_RETRY_PASST_ON_UA is set
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michael.christie@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240807203215.2439244-1-bvanassche@acm.org>
 <20240807203215.2439244-2-bvanassche@acm.org>
 <cd94a0d4-6e6d-495c-aa17-d2d2c875604a@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cd94a0d4-6e6d-495c-aa17-d2d2c875604a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/24 8:40 AM, Damien Le Moal wrote:
> On 2024/08/07 13:32, Bart Van Assche wrote:
>> The SCSI core does not retry passthrough commands even if the SCSI device
>> reports a retryable unit attention condition. Support retrying in this case
>> by introducing the SCMD_RETRY_PASST_ON_UA flag.
> 
> This flag is badly named since nowhere it is checked that the retry happens on
> UNIT ATTENTION. The retry may happen with other sense key as well, no ?
> 
> So what about simply calling this: SCMD_RETRY_PASSTHROUGH ?

That sounds good to me. See also v2 of this patch series.

Thanks,

Bart.

