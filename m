Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D2F3A3E71
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 19:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774986300; cv=none; b=Hd9Mp2Wqpa7HD9HdBm1uB6rd9akfAvxxMsTo9Su+3XYTjBwH1U7hxTTYgqfYVn4/1Eod41s20haTQ0Je0FWJ0JIoOXDs4a5nGUItBBAitLSQiJSsOFx3HbRjq+kApxyxMeq7rYNOVtLmzjGEJ9CU+wcTmtpuoi+LyWw6uU7h95Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774986300; c=relaxed/simple;
	bh=yRhRs53LbUKcXwvZLHd/73j9M4X9i0y11N+O43E+pLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t3prqI/hLnHGu/ffUcfQrlRN1CbqFzxdz9n6LA90HyRPTWwjc4GOy/FhTtONv7UeICIJL5/mWUoGbUiFUlvA9+89zqgwO55XrUBP0GCzGE+jOg4XgHkwPI4FxEK9HPhzO1faygflXKaJRlkvPBYnJnP35/Y27nVrOwhPSHyUBlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wDGudiuq; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wDGudiuq"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fldqt1zj7zlh2gG;
	Tue, 31 Mar 2026 19:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1774986294; x=1777578295; bh=P9WxAQss2rM7VyMWnjFxDvEU
	rmeZZt9gGZdOxM4NHKY=; b=wDGudiuqDeQucEMHoqivrINXz/Ai51kMHmpTHA5R
	q8+BQo06IkbN4mcCEnjrYQVgCqQAQ04NQCqjEq7uqtXCJm3ds9w9Q5fOC5W1EYlN
	dfsRvxUpQr/GOoRBts7l/zJwvr3Ag10Wx/TRe/CRHY+8r+3QuNidsgUj8bfohyuq
	p8oPDfhbn67Dfj5dYskYDL25cYZLWnmRdwswANGC0nlQa5JF4FLufPquNzzNf0vb
	7YRmT98Bz5sjXf/mS6F8Ew9UlkowE21osH9yB3Mv6JPK4014dIFXG9xu7G4oN6mP
	SUY750SQvki4/Ve+MwVmRwEf8RZ8cfpKAwiOE8bGzRpjEw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oGIVVBd0-boz; Tue, 31 Mar 2026 19:44:54 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fldqn363MzlgwNJ;
	Tue, 31 Mar 2026 19:44:52 +0000 (UTC)
Message-ID: <99c8b626-4c06-411b-bc01-6324df5b3137@acm.org>
Date: Tue, 31 Mar 2026 12:44:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] ufs: qcom: Reduce interrupt latency
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 Nitin Rawat <quic_nitirawa@quicinc.com>, linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
References: <20260330183311.1941942-1-bvanassche@acm.org>
 <20260330183311.1941942-4-bvanassche@acm.org>
 <fg4i4d3fjpjvwp5xe5zvzwjlhq5dlmiauchh62fka5lujmolcm@pzzbd7h3se3e>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <fg4i4d3fjpjvwp5xe5zvzwjlhq5dlmiauchh62fka5lujmolcm@pzzbd7h3se3e>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/31/26 12:09 AM, Manivannan Sadhasivam wrote:
> + Nitin
> 
> On Mon, Mar 30, 2026 at 11:33:05AM -0700, Bart Van Assche wrote:
>> Defer completion processing to thread context on slower CPU cores to
>> prevent interrupt latency spikes. On the fastest CPU cores, keep
>> processing all completions in interrupt context.
> 
> By default, all interrupts are pinned to CPU0. So unless some userspace entity
> like irqbalance changes the CPU affinity, all the interrupts will be serviced
> in the threaded context on CPU0

That's an unusual approach. All other blk-mq drivers I know of spread 
completion interrupt over CPU cores. Pinning all completion interrupts
to a single CPU core is risky because it may cause that CPU core to
spend all of its time handling interrupts with no time left for running
kernel or user-space threads.

 > which will negatively impact performance with this patch.

Hmm ... the implementation of this patch is such that latency is not 
affected for queue depth 1. It will have a latency impact for queue
depths above 4 but I don't think that just by reading the code it can
be concluded whether or not IOPS will be affected. This patch could have
an impact similar to enabling interrupt coalescing. Interrupt coalescing
increases latency but typically also increases IOPS.
> I think from the kernel driver, we should just set the IRQ affinity hint as
> Nitin tried [1] and let the userspace to balance IRQ load based on the activity.
> 
> - Mani
> 
> [1] https://lore.kernel.org/all/20260122141331.239354-2-nitin.rawat@oss.qualcomm.com
  Thanks for the link. Please consider calling 
devm_platform_get_irqs_affinity() or one of its variants instead of
open-coding already existing code for spreading interrupts across CPU 
cores. As you may know there are two types of interrupts in the Linux
kernel: non-managed and managed. For non-managed interrupts, a default
CPU affinity is assigned when the interrupt is requested and the CPU
affinity can be modified from user space. If all CPUs in the affinity
mask of a non-managed interrupt go offline, the hotplug code changes the
affinity mask to the remaining online CPUs.

Managed interrupts are spread evenly across CPUs by the code that
requests these interrupts. User space code cannot modify the affinity
mask of managed interrupts. If the last CPU in the affinity mask of a
managed interrupt goes offline then the interrupt is shut down. If the
first CPU in the affinity mask becomes online again then the interrupt
is started up again.

I think the latter behavior is what is needed for UFS host controllers.

Thanks,

Bart.
