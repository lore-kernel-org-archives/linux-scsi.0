Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5054218593A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 16:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724429357; cv=none; b=dWIqvCHgXEN4Zv5Q1eE3trbycO2KWjncjzvbne0Lakmd+iH8DBnds2M+CyoY4WEB3Wvkq0QFqw6II106hYkssckagh0NQgPrnonoueGxFnzgjKDbm5aDidZX/QdoO/wPyI2bQFjF9aApv6T4nB7IBZLHVVxr7iEMtYSDGKE+XX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724429357; c=relaxed/simple;
	bh=XWvTHvdkbhkpUoDskdY8tsbH1c3OPecfhIWDB5Un5/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W9Nf6KvDZY5BRyiiIq6K4X/1r4MGM3FZZu7vEmTLfzARp+GBbjQsDfDo2NMbSurNqNZACSTnELNRCQMGbOnFX2LOqJCBtZwGjYhF2pMz9Y3+BlyzcsKUpvOy7xGMg6Ogzi9ZenAzVg3E0uyE5ZnWLZ4/Fv0q2xzmQfkA+K6kpSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=R6wzdMnu; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="R6wzdMnu"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wr4kz4fXTz6ClY9W;
	Fri, 23 Aug 2024 16:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724429351; x=1727021352; bh=LKBcscqHLY7pGfSwT8BdNeI4
	HGET1BiTvnp09HTFvyg=; b=R6wzdMnuRejUIVFWJQaUTR2CkTNqrZhdhwHI/X0l
	JXxmNHdbfWfPr2A0Xmiqh5AYqwUxCrMma/uNy9OBUtvMu8/piUBCjSzvMNSabeyt
	f3KvTIl1Eammjt9818BDbq9x3qmMonUi4K/CLCadCiO353Ag25Zl2MjsJVJIrUSH
	z9p6lLpLifqb4bJUffdz8K/T5GWjlO4fRoWtE9CKDKQCaBLO2hT70+jGwhAO4vkN
	5OdBc+7MqyFAOt+tZCrxM3ALE79vphk3L1LnKvj+tNaQaIn5lcmwC6e0Vjsa2Ih6
	XoxWXclitaFlpa9r7NZ9WDbySA5UyIhekaS7wdx3TsS4fA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mFrMN1mFVr8h; Fri, 23 Aug 2024 16:09:11 +0000 (UTC)
Received: from [172.20.20.20] (unknown [98.51.0.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wr4kp4Bwgz6ClY9R;
	Fri, 23 Aug 2024 16:09:06 +0000 (UTC)
Message-ID: <93530204-a89b-44f5-8134-06319ed6435a@acm.org>
Date: Fri, 23 Aug 2024 09:09:02 -0700
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
 "Martin K . Petersen" <martin.petersen@oracle.com>, quic_cang@quicinc.com
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
 <25ba6504-9a10-4c59-a180-620ddfd06622@acm.org>
 <bb2a1649ef94637f236dece7255d497f7fe03f19.camel@gmail.com>
 <4964ac76-abdd-4cdc-b8d0-3484b3286449@acm.org>
 <8a81431a90c9c0c5bb0c90deba825284bff55d83.camel@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8a81431a90c9c0c5bb0c90deba825284bff55d83.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/23/24 3:54 AM, Bean Huo wrote:
> On Thu, 2024-08-22 at 10:51 -0700, Bart Van Assche wrote:
>> That's correct. ufshcd_uic_hibern8_enter() calls
>> ufshcd_uic_pwr_ctrl()
>> indirectly. For the test setup that is on my desk, the code in
>> ufshcd_uic_pwr_ctrl() that re-enables the UIC completion interrupt
>> causes the UFS host controller to exit hibernation.
> 
> Do you think this is only true in your case or for a specific UFS
> controller vendor? and this doesnnot mean that all UFS controller
> vendors have this problem? Maybe MTK has confirmed this.

Hi Bean,

I'm only aware of one UFS controller type that shows this behavior.

Thanks,

Bart.

