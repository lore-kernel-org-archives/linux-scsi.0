Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B280531AA94;
	Wed,  4 Mar 2026 15:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772636657; cv=none; b=aQE28mG6iCI2K6LhFOaFtcWTIR2oIg1cFUhCHuwT4bm5ypq4RNpqHUE/gReWxpTyI1PyYTNRxVCVUWA/6e9F+sM92nKqn3aqMxRe9wTZHM9PwLoNcdo/eIHyaEgiG8KZWyd9UGxLh/SD18rjAOtOTwuofbN+k9cRwvm0ExXrEa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772636657; c=relaxed/simple;
	bh=V0gXXchXzJn96rPUl5KRhqZHXbewb+z+hkViG+D+dn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=meyPkhAKyzH6ZpLEJwVtVNdTmBcA98B/wifm+29tGZYDa+pnU80/7PFBs8euRDyt6bE0x6KHrArhZ0mEpmiGz53Xb7fqArvI6srprPW4Vautp0/JRtUyneaHbozAe99JEnPeFWDsJi8p1LO+RiKTerQgKJbCGwrKxg5YuAizhpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=K4J+KfIT; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="K4J+KfIT"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fQwtL4V2gz1XMFjh;
	Wed,  4 Mar 2026 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772636628; x=1775228629; bh=xxIHjs/9JK3ex8VVUcl4y7WB
	o/WfKZPWuuVHAXHeKO4=; b=K4J+KfIT5iKm1Hsx5TXmR/bqK6riI2a4zc8KATe0
	TH0gPOWZbaKukcOiGWhoucDIUoEEjdlVL7bbPxn/Xc69zkSuoph4rXQYE0ylBKel
	Ovk2wmAyb13sizTltYUaaHFhSwun1BSv9IATr2BtlRICtddtKo0LqHUfFCxkI8+R
	7gpeqc1NRWa/jjAinSxFBHjMzTF9DAwre885xYjGjPcG4DnkHdIn/RifyaSh61Fh
	mer3m84T6FlAlSwB/4BPZWT39AfonIFKxB9/t48y88oNLkVYo1nOYl04MzfnhtTh
	GjLdFs7au+O594Z6rKtn66xTxzqR4SmJv7riHsTExYlfGw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cUyeV7L3oQFC; Wed,  4 Mar 2026 15:03:48 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fQwsn5yVsz1XM6Ht;
	Wed,  4 Mar 2026 15:03:41 +0000 (UTC)
Message-ID: <1dff34c7-a642-45ec-8a98-6d57b5b67b4e@acm.org>
Date: Wed, 4 Mar 2026 09:03:33 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Handle MCQ IAG events
To: vamshi gajjela <vamshigajjela@google.com>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com, avri.altman@wdc.com,
 alim.akhtar@samsung.com
Cc: peter.wang@mediatek.com, quic_nguyenb@quicinc.com,
 adrian.hunter@intel.com, beanhuo@micron.com, arthur.simchaev@sandisk.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260302180117.2797184-1-vamshigajjela@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260302180117.2797184-1-vamshigajjela@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/26 12:01 PM, vamshi gajjela wrote:
> -static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba)
> +static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba, bool iag)

Please change the name of the "iag" argument into "reset_iag" to make
the purpose of this argument more clear.

> +		/* Clear MCQ IAG counter and timer of the CQ */

Please remove the above comment since it duplicates the explanation of
the "iag" argument.

Otherwise this patch looks good to me.

Thanks,

Bart.
