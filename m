Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AB53587D7;
	Wed, 18 Mar 2026 17:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773856196; cv=none; b=FeLH/S8WbkSjs4hpzYDl3uHRnI+iv9VuIqpXuwXpGPZ8QFVGJkMmQvLIhABF5kzMZneAh+yisaGfcIxZ9LJzfPJMryEJbWgMmUI54VRo8pM9wPXsXE+4YbPRy2aP5wxm97y/6tfGF9XjexxfRoJRnOPoiyxF/uCu0shQTb1ngNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773856196; c=relaxed/simple;
	bh=ZA1ncH987c8Np+jN1DlvSABXRC/iBzs19nI28TuoEfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wjwet+64Bzod/mJqdWsBsDArNO83d0RKzCoiLz9e6RsxTgk6IH4KTgSn6DnSSZ/SmpJynIa3kC7EGFrd8TenCEsRH/bfHvZjamhN0G+lAF53dY/7eVe+8ERAV9Of+Qn/9k+wQ3ObkI58EreeOC+pP1YqiIYVGLYkmSU/ZyzPEQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JBKCQ+IX; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JBKCQ+IX"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fbbv62zcNz1XMFkQ;
	Wed, 18 Mar 2026 17:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773856182; x=1776448183; bh=4h0N8je/sz5bGwtAWF3aYW9e
	v7ftX3/0RxXE553oLWc=; b=JBKCQ+IXQy5HdmncVg3SxjIpbRowkyoIVr5bWrrq
	MY14kmD9Xhta4+EEd371vszocgYZjEdVZMo1FMN9A4g7BVlBXI0n8D7XTCJp/nI4
	s0vj+koMgBdngF+AtNlCVuJYtWbF0rpljRohxLjwIhWEtRZlc/RoF3VmBcxvgFXU
	XpBZHjLk6ICbfHyUmxx682279kXLfSdeLVC/KjMrTg+CxU/dLxS/F+sltw2H++dz
	6cF29ToTz5wui2BqdWTRbpvvuzNLJFeI3a8gCIsHqrt2GabZzLqdj6zW5gC02g9o
	MYfypqP6A1/nNxNQu3RqnPFiRFLlQ5f6VtqwMXXHL58DhA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fzVt-KjtLjDN; Wed, 18 Mar 2026 17:49:42 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fbbtn00zMz1XM31H;
	Wed, 18 Mar 2026 17:49:35 +0000 (UTC)
Message-ID: <f0e6452b-868f-4d57-b2cc-98daf16cdecd@acm.org>
Date: Wed, 18 Mar 2026 10:49:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Regression: scsi: ufs: core: Avoid IRQ thread wakeup during
 active UIC command
To: Tj <tj.iam.tj@proton.me>, Peter Wang <peter.wang@mediatek.com>,
 linux-next@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <abmMptgPR581bPUS@mail.iam.tj>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <abmMptgPR581bPUS@mail.iam.tj>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/26 10:17 AM, Tj wrote:
> #regzbot ^introduced: 6475cfb81fc4f6175b6d15d1c205a5168dc10b46
> 
> I've had to revert this commit because it breaks UFS on Samsung Book2
> W737 sdm850. Below is transcribed from a blurry video so apologies if it
> is not exact:
> 
> | BUG: Invalid wait context |
> ufshcd-qcom 1d84000.ufshc: uic cmd 0x1 with arg3 0x0 completion timeout
> 7.0.0-rc3-next-202603110sdm845 #103 Not tainted
> -----------------------------
> ufshcd-qcom 1d84000.ufshc: dme-get: attr-id 0x41 failed 0 retries
> swapper/0/0 is trying to lock:
> ffff000087ba4048 (shost->host_lock)(....)-(3:3). at: ufshcd_sl_intr+0x3dc/0x7a0

Thanks for having reported this. Is this perhaps the same issue as what
has been reported by Marek in
https://lore.kernel.org/linux-scsi/1f88b91c-59e6-4347-84c2-50b7cf106c47@samsung.com/?

I propose to revert commit 6475cfb81fc4 ("scsi: ufs: core: Avoid IRQ
thread wakeup during active UIC command") if a fix is not found before
the end of this week.

Bart.
