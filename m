Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78CE3A7820;
	Mon,  6 Jul 2026 14:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347768; cv=none; b=A/3DEwuDPEcCr33aN/MGKfvy4AN/yAZE604p14TX2cP72XSzj0xf8OPj0C+kpfLCfwCbVFgyRF/mn++GgZtQvK/DoL481u28XYYQgBL3aMV3m44Nq3pS99zi1ZWkVo5/f9DNbiwFPyEsfhtght/5lKAf9Rx/6lBP6kuSfYjqsgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347768; c=relaxed/simple;
	bh=l+zxTiyfnQT0eysEB6of4dvMgiahZQ7ChlScDNv1Yiw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HnLxOXyk5Xrd5GoM7eBSmtS4CJwDK4Bb9SP1onZSj0w0jOppndhOOwB7MTybUtDQQRyVTQ/f/kWB/34HjRzCyKxO6z0UBTmQi2luYK09VpEjfGTy3M3nr/t8MzBWba42kegY5V2J7KNUSGETEvThebYoVaoR09g0KXK9BIr4nAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WjSeJ9OH; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WjSeJ9OH"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gv65L2C74zlh2rv;
	Mon,  6 Jul 2026 14:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783347760; x=1785939761; bh=nNBgelGx3mRHB1Sk5a7CnC2Z
	kQzCv7a96N3gJ4wVDB8=; b=WjSeJ9OHxdnhHGFWk9TUUbnt3jX8Ymc6r3jz9TJj
	ez/HdYwTjuedq4ro0I5QZ5x3xgfy22awka48jYZZG1zG19XVpNWJrG+jXrFSsh/T
	gTSCT31A9ErEsasllYzvPabk5wW4iCHMayq7P/RhjDx4HoBPuq2fTOdppotx00Sz
	+HG8GmFS9+At83m9++D/TgFQjyBduHKbpLIH4j1Av9Z4VSumPk3s4zMd5XsiB06W
	Eu4NcW3uBgxyEJw2hbbfJ2hCI0Tgj/HiK5A56GiLo+JxkfGYqNgWv06T9hqDOCvU
	Y9n65NK0RgepmzzIiaCeRC+NSAZsYQvEH1K55nb/+f8ADQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id y8tVbxUS7moB; Mon,  6 Jul 2026 14:22:40 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gv6585pJkzlgtd0;
	Mon,  6 Jul 2026 14:22:36 +0000 (UTC)
Message-ID: <a1621138-9051-4845-b74e-a3e9e895133d@acm.org>
Date: Mon, 6 Jul 2026 07:22:35 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: tracing: Do not dereference pointers in
 TP_printk()
To: Steven Rostedt <rostedt@goodmis.org>, LKML
 <linux-kernel@vger.kernel.org>,
 Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
 linux-scsi@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>
References: <20260630185412.283c26c5@gandalf.local.home>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260630185412.283c26c5@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/30/26 3:54 PM, Steven Rostedt wrote:
> The trace events in drivers/ufs/core/ufs_trace.h were converted to take a
> pointer to the hba structure as an argument for the tracepoint and then in
> TP_printk() the printing of the dev_name from the ring buffer was
> converted to using the dev dereferenced pointer from the hba saved
> pointer.
> 
> This is not allowed as the TP_printk() is executed at the time the trace
> event is read from /sys/kernel/tracing/trace file. That can happen
> literally, seconds, minutes, hours, weeks, days, or even months later!
> There is no guarantee that the hba pointer will still exist by the time it
> is dereferenced when the "trace" file is read.
> 
> Instead, save the device name from the hba pointer at the time the
> tracepoint is called and place it into the ring buffer event. Then the
> TP_printk() can read the name directly from the ring buffer and remove the
> possibility that it will read a freed pointer and crash the kernel.
> 
> This was detected when testing the trace event code that looks for
> TP_printk() parameters doing illegal derferences[1]
> 
> [1] https://lore.kernel.org/all/20260630184836.74d477b6@gandalf.local.home/

Thanks Steven!

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

