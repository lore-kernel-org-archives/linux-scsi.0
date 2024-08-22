Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9D115ACA
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 17:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724349085; cv=none; b=Ob+K42t9bR1SyTycjX2YbM33UjCFdN73SSQ7HhchfTRz6v2j92zCZB462AJQ8Uk6fZjRjmq2tMUwjpT6mFoxItd3Z7sYhehXntMEIIdNWxAy8ghXXjgXOlTeVf7iUttZAoH9In5SWjsj7tOPRi0gtKiC4cxjkteao2moG17FVm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724349085; c=relaxed/simple;
	bh=sK6VnKJ6LrjUnd0yWVGP8LGzSbNR1D9qTAGFjQBhb6w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZcP/GGhDPwEaQBQCTvXUpVwn1kO9yoYJAyCxMZP31z8NcNviGJPcKuLWySOi2uSQdYLP+KGQqz3JfdVxPrg36nlXRux9HsADcakTwyzVfikbjaU/jEOAJ7QWA39DN3yIQOW4N/6oziZGhN7vuC5IloPJZ7GLdB0nMu7QioxJ36A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=avaVsr5D; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="avaVsr5D"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqW3H0jRVz6ClY9J;
	Thu, 22 Aug 2024 17:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724349079; x=1726941080; bh=sK6VnKJ6LrjUnd0yWVGP8LGz
	SbNR1D9qTAGFjQBhb6w=; b=avaVsr5D+6YU5+5q7qtSC9ay47eNPb0XAriq0m6J
	jWOm996ha8EN03eE6wPu9A+FnIfpE+lGlgQ9nZY1wgJoy6O7Y7GsyqGW1ITeXM8t
	ksJOCyNhC0ox0txDZ6FBLBnmvPJ9NTieNUE+OiN9Ew7QrQSKonxSLzZ2LTFkM3vf
	pKJdgDQdwIroksbqndcJuPbdbNAotox4w2e0v/eqYv3Z8fuT8j/LoghFcU9jKwv3
	UhGvrgoVfqHmATcgGF/+y63R9KhrebtyRheQMEBgRbyG5HU+xUg4z3/rpVsKi7CP
	gR4rQP5j0BUUXCZ/M8816juaJ6VmxmIWR1pdl9E0KRQYUA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id n0XUcV8_tTyo; Thu, 22 Aug 2024 17:51:19 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqW396Wxjz6ClY9F;
	Thu, 22 Aug 2024 17:51:17 +0000 (UTC)
Message-ID: <4964ac76-abdd-4cdc-b8d0-3484b3286449@acm.org>
Date: Thu, 22 Aug 2024 10:51:17 -0700
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
 "Martin K . Petersen" <martin.petersen@oracle.com>
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bb2a1649ef94637f236dece7255d497f7fe03f19.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/24 7:17 AM, Bean Huo wrote:
> Do you mean re-enabling UIC complete interrupt will cause the problem?

That's correct. ufshcd_uic_hibern8_enter() calls ufshcd_uic_pwr_ctrl()
indirectly. For the test setup that is on my desk, the code in
ufshcd_uic_pwr_ctrl() that re-enables the UIC completion interrupt
causes the UFS host controller to exit hibernation.

Thanks,

Bart.

