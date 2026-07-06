Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D77E3B71D9;
	Mon,  6 Jul 2026 14:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783348264; cv=none; b=k5kwK+JrxcVf/azpGWFQtyuHGv6btVL9J78rdgJZPnoMy8ehcl7BJ5h0vx/kl8bWlki68RLK7jcSTh12Idgf1PUJhsGWbgVrOqf3h82Xjb1SFWH349pqLuulkn3c0ScZ/EX1H9URrXjE2d2fLLkfIb/W/rWUjyz/YQzz9NIAteo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783348264; c=relaxed/simple;
	bh=q9GK6bYnXn+9vYNx5TDT5YEMb+vEmZpe052l3zrdCc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r8ej0E4T9J94RkZjhihHbfboT0jDE/GI7AaUXqe3ZRX0bh5NuA9ECWjKvEsF4Ljp/LiSVLxtD5rfudMBXEuO4aJgESv5z1mkO72BAoJlycqJps9USx1FoAIuQS7sdnweqcjAaaJ7v7xoG6X57VJdBU9zCKVqbAJ67Nzg4XusQUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0c3KThoN; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0c3KThoN"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gv6Gt5t7sz1XM6JQ;
	Mon,  6 Jul 2026 14:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783348255; x=1785940256; bh=5WDgo9lmNh3Xyf9j8EEI0vRR
	XaSVdYjT506xHbEN1fA=; b=0c3KThoNK4z9G0ehbqg4LxOhOidVljxVhjg8BBRX
	u+ByfWi1C/h2X6eRONtbbRed9JGhhmzMhEplWkL3DUdzUbvwk11RQ/yfNPN9uKo6
	WGGBZN6KJ1CEUp5GuagxdDo/X128o1E3PjTOLkWTNmWgHcsotFsSMWAYGyPBhL3s
	6sUpi3PGH3d404G+urNN67HnhARvzNPnVtjvowUQmbPcIlvky/IBACHXdTvpqVk4
	1Q5cypi9NuC4B9/koyySzcOOz8jAwXEXZVFs3SmK3jwUmeVbetyk84bEd1W5ngyb
	YfxKWBePAW7StoBDr0DDUO35XkhtlGA5nzPWa+Ico1RYsg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GHaJqUMP8Wa0; Mon,  6 Jul 2026 14:30:55 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gv6Gd4cp3z1XM6J4;
	Mon,  6 Jul 2026 14:30:49 +0000 (UTC)
Message-ID: <4244935a-8a49-42b0-ac27-234d2367e3e3@acm.org>
Date: Mon, 6 Jul 2026 07:30:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Avoid sleeping in hard interrupt context
 when PREEMP_RT is enabled.
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Gregory CLEMENT <gregory.clement@bootlin.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>,
 =?UTF-8?Q?Beno=C3=AEt_Monin?= <benoit.monin@bootlin.com>,
 =?UTF-8?Q?Th=C3=A9o_Lebrun?= <theo.lebrun@bootlin.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260630-ufshcd-spinlock-sleep-fix-v1-1-339b05a1c6f4@bootlin.com>
 <20260630141513.ujz0Ef-O@linutronix.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260630141513.ujz0Ef-O@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/30/26 7:15 AM, Sebastian Andrzej Siewior wrote:
>  From ufshcd_intr():
> |         intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
> |         enabled_intr_status = intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
> |
> |         ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
> 
> What does this do? Does it disable the IRQ source? If so then
> IRQF_ONESHOT should be removed.

Writing into the REG_INTERRUPT_STATUS register clears the bits that are
set in the first argument of writel().

> |         /* Directly handle interrupts since MCQ ESI handlers does the hard job */
> |         return ufshcd_sl_intr(hba, enabled_intr_status);
> 
> If not, why is this not part of the threaded handler?
If MCQ is disabled, ufshcd_sl_intr() processes all types of interrupts.
If MCQ is enabled, the ESI interrupt handlers process I/O completions
and ufshcd_sl_intr() processes the remaining interrupt types.

Bart.
