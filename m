Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C6C5AEC56
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 21:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789161499; cv=none; b=AL0deLoNsuHyDGj4jP18yXFKQ+D0Wg1gzGdJFv2B+rhGzjSJCWQjJ7juTx7s6hQYEtCjBBTHe+gCBwSfhoUE4VdJ8nsLToZhvIUM8PX1YT5hyKk+R838VicHM9jTihIWCr4Ci5/4FHnaSrUkF+7UZnRYH3r76HVxHkmRZ4SwScs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789161499; c=relaxed/simple;
	bh=vw009+LyrBWFHEvbYXW+8ponNLTRgD6CaHD+B+lHo0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qzo1wAoDzSUGPUUw0Envmdy+Y19iTSWlxUXsmUMDFrT13ZyFRCdYTTvVGjvT4+lkvvqGeIQcjs+VKU7XpCC9skJYq5JuNhOUYcx0KTo6hKYPwMAWyMfBVF0kCl4XytNCi4eCIZ3FWcIUr4/1cR2bLg0uNyRuKwffYilO5IK/IZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sAkGN7By; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sAkGN7By"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hhS7p0Db3z1XM6JR;
	Fri, 11 Sep 2026 21:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789161492; x=1791753493; bh=VTkUJeqh5SkQTVbEgjVA46wJ
	1slLATaU7VAnIKraDKc=; b=sAkGN7ByCQeSQhKe/V1hoi0onECmo0v2MfKE8kXb
	VTN/kl2BN9fVJfY2cVzxtZrwe/Acc+KDf+yvp5O9opVncZQuC1ZEyQl4mZdWwrwD
	jc5Cu46I572RXgoqMbpQn7SletM75syYSw+LafCuPjEBpDXoxPnLlXIpOTQn4EfI
	KudUfCw3A49uWDXPpSMVh9WBEFL3IgDw+k2IM2pcr+oXycTloLz/Pr3KuFSiWZrf
	jJ+d18ZiaTkFF8xvtgtB+0VxXtdE+buWOST43oayIASYlp6+70cN/9xwcjZb/hYE
	4GqR/JD8xoIRY7CE4z1A2HOoXuWtI6FdrbCTq8lJHE/3WA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HIgIVeEbWuL4; Fri, 11 Sep 2026 21:18:12 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hhS7l4J9mz1XM6JN;
	Fri, 11 Sep 2026 21:18:10 +0000 (UTC)
Message-ID: <270c3910-c474-47c8-81c2-4d1404a2243a@acm.org>
Date: Fri, 11 Sep 2026 14:18:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Make SCSI host scan interruptible
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <74786683eadc0a32ab335373ead8dd76a9d5a342.1789157339.git.bvanassche@acm.org>
 <20260911202317.559491F000FF@smtp.kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260911202317.559491F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 1:23 PM, sashiko-bot@kernel.org wrote:
> [Severity: High]
> Can this silently abort LUN scanning on non-fatal signals?
> 
> If a non-fatal signal (like SIGCHLD) or TIF_NOTIFY_SIGNAL (used by
> io_uring or task work) is delivered to the thread performing the scan,
> signal_pending() returns true. This causes the loop in
> scsi_report_lun_scan() to break and return success, leaving devices
> undiscovered without reporting an error.

It doesn't make a difference how non-fatal signals are treated - if a
scan is interrupted, the scan will be incomplete.

> [Severity: High]
> This is a pre-existing issue, but transport-backed sysfs scans still seem
> vulnerable to the original hung task issue this patch addresses.
> 
> Concurrent sysfs scans initiated by transport layers (FC, iSCSI, SAS) bypass
> scsi_scan_host_selected() and block uninterruptibly in scsi_scan_target()
> and __scsi_add_device():
> 
> drivers/scsi/scsi_scan.c:scsi_scan_target() {
>      ...
>      mutex_lock(&shost->scan_mutex);
>      ...
> }
> 
> Will tasks initiating these scans still exceed the hung task timeout if
> fatal signals like SIGKILL are delivered while they wait on scan_mutex?

Transport layer scans not initiated from user space fall outside the
scope of this patch.

Bart.
