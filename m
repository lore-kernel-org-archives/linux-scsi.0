Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1BF535FA7;
	Fri, 16 Oct 2026 16:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792169752; cv=none; b=R4vliFwH/VBWGEjSyEiffNvnyagvs8q/kGpGC+z1r42O+TcpyVsnFPgAG8SeEejTOh2pfzao/Zh/kwgDc38WeIdegJCeXqYJqDhlvmiajnWAsZWs/BwLtGAZ4u4aTHH7GWBXqAhOX7vng4CJwt4YywzJ1FlV3KWKNoOLFAoWVCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792169752; c=relaxed/simple;
	bh=WdVTmqhBYC4t9n1b9l4GQNldtQOStvXosyzwEd76Gy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kFrX8VKOYUT+ndRMkFWpsumwNLGEq6U2yPJDPH4tyI75COwgF3eWgfccDzKmHTSZdi36uf3NRaQSSm3XV4gJ3q4q1eoHPsnbJPdmbWsBtcOiAECZCFXiLAXq9Kl1S5smvDPq+5u7Qm94daJ79Pf/y3Q2fasCPzSFfVgarVe4X+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=i8ALknZK; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="i8ALknZK"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j5rft32yrzlfvpN;
	Fri, 16 Oct 2026 16:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792169746; x=1794761747; bh=y/2NJaVkhwoOKchO7UYsTKHz
	BXwFe1IAXZbHOgIJVkc=; b=i8ALknZK6kTeQIodRg8trwffXFVXnOC/o1UcHkuR
	4buhqRzvrXhy/1Srt6cFWwdfXoRMZqHan+mhSgIHvIENUZSnYkG8ErAfOHYUrM+s
	RMia1BvdHIE9/KUsqo+v/cBpoibCJZ8x7bMYe6bI2vsr9LpoeDuzzQYPBAv7+nrw
	ZqNXbvYi7Jv42ogg34YOl8tsLmiEKK9gufoBRIOcSMwvIj0VCCZxJtXslJWxflLA
	tjxhbcly3bBbbwuk3uFsMusSNidZ6W096j2yMciqPu8HKhALCpNHwoXbf3iap+aB
	8BvLMGOk7YFAWuo9noSBRYdMrPmM+D3EOJt9uXwO1Y3ShQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WKmg-u42vpim; Fri, 16 Oct 2026 16:55:46 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j5rfn4cv6zlfvpH;
	Fri, 16 Oct 2026 16:55:45 +0000 (UTC)
Message-ID: <3779e125-9acc-42c8-9489-51b9e3c6716d@acm.org>
Date: Fri, 16 Oct 2026 09:55:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Fix double completion in
 ufshcd_clear_lu_cmds()
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
 <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261016085403.1711740-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261016085403.1711740-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/26 1:54 AM, Stanley Jhu wrote:
> +	spin_lock_irqsave(&hba->outstanding_lock, flags);
> +	outstanding = __test_and_clear_bit(tag, &hba->outstanding_reqs);
> +	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> +
> +	if (outstanding)
> +		ufshcd_compl_one_cqe(hba, tag, NULL);
The above code is identical to a code block in ufshcd_abort().
Additionally, a more generic version of this code is present in
ufshcd_poll(). Maybe this is a good time to move the code below into
a new helper function such that code duplication is avoided?

	spin_lock_irqsave(&hba->outstanding_lock, flags);
	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
		  hba->outstanding_reqs);
	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
		/* Do not complete polled requests from interrupt context. */
		ufshcd_clear_polled(hba, &completed_reqs);
	}
	hba->outstanding_reqs &= ~completed_reqs;
	spin_unlock_irqrestore(&hba->outstanding_lock, flags);

Thanks,

Bart.


