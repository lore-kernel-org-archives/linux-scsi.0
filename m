Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3096E190676;
	Thu, 29 Aug 2024 11:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724929648; cv=none; b=e1qgyvOiWjvQjxu2oHAGlEy8dz6vxr1oDH8PBZSgsMLYyuQJN08zJYZ66iK6XytRzU3/UoMGWutdrwczF3JzSMj8VhvbhJED4FrKelVD/ZN5N68A/neZbplIjXse+zCbz9bLflHkgrowapduHy/XzzCeTMbBBrS0+DRPTYHLobY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724929648; c=relaxed/simple;
	bh=2HeHQnF7SElFuz7l+ywrYBx5xpVl/BSNeKxvVbqJnKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DQzVhSbh3R3t21KJZxIgWFoUPQWosm08gAVYKQwI+TPOcnT66iPBp8Lmabs2PdxnEfegRrmYPbz4y2aOY4mNGTw5Ct0AmzOcgIbgAVb+0tnJoqhyPnsKPeYgi3tTqqSnwnvdMoq1Ag0BbFuItg26SWthqrD+xSLmZhEfTG9G4ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UU3RmhNv; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UU3RmhNv"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wvdlr01LhzlgVXv;
	Thu, 29 Aug 2024 11:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724929637; x=1727521638; bh=1cOV3qIKgGMZO+Ek677yhd7s
	c4CK2leQAuNXorxpInY=; b=UU3RmhNvBml5Vun0dNnSqGVKICzTllUXm9YaeTcA
	DG0TTkaCYAvL/DzY4EAqnQHFudkGvVnAunEhgtTC/pjg5+di+Uv4+t+4PUPXs6/B
	yXVHqsYO/62R2a/63//pQsaTKPRvF6A12yHSv+ivuG7Hj68J/aS9XFN/tV6XLKJc
	6sI8BdOQiVE45D6q4aotCkvA+lx2aKAtEG78A1/V9m2Ut5qJxXpS9ROi8Wqoxhj9
	8WwPsklxmxaRG5HvfQiC/IaKbZIu+00MEsFpDKbFr0HMnynLPTGyxxvGHRvFZhtW
	fKxeBSMN9dFNkmEbPDECuWlkva+aFY3q9mYURzCKNEamRA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9FRKrkVUzr1b; Thu, 29 Aug 2024 11:07:17 +0000 (UTC)
Received: from [172.16.58.82] (modemcable170.180-37-24.static.videotron.ca [24.37.180.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wvdlm0f1hzlgTWP;
	Thu, 29 Aug 2024 11:07:15 +0000 (UTC)
Message-ID: <f1bab04f-6e7c-4213-a1ac-ecba95f26b23@acm.org>
Date: Thu, 29 Aug 2024 07:07:14 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: BUG: corrupted list in dst_init
To: Juefei Pu <juefei.pu@email.ucr.edu>,
 James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yu Hao <yhao016@ucr.edu>
References: <CANikGpfDVGGA+gpRqik5NATXsXUqDa2JAFiVRGCLkPthtq4=Qw@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CANikGpfDVGGA+gpRqik5NATXsXUqDa2JAFiVRGCLkPthtq4=Qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/29/24 2:31 AM, Juefei Pu wrote:
> Call Trace:
>   <IRQ>
>   __list_add_valid include/linux/list.h:88 [inline]
>   __list_add include/linux/list.h:150 [inline]
>   list_add include/linux/list.h:169 [inline]
>   ref_tracker_alloc+0x1ef/0x480 lib/ref_tracker.c:213
>   __netdev_tracker_alloc include/linux/netdevice.h:4038 [inline]
>   netdev_hold include/linux/netdevice.h:4067 [inline]
>   dst_init+0xea/0x480 net/core/dst.c:52
>   dst_alloc+0x157/0x190 net/core/dst.c:93
>   ip6_dst_alloc net/ipv6/route.c:344 [inline]
>   icmp6_dst_alloc+0x73/0x410 net/ipv6/route.c:3277
>   ndisc_send_skb+0x31b/0x11e0 net/ipv6/ndisc.c:489
>   addrconf_rs_timer+0x3a3/0x650 net/ipv6/addrconf.c:4039
>   call_timer_fn+0xff/0x240 kernel/time/timer.c:1792
>   expire_timers kernel/time/timer.c:1843 [inline]
>   __run_timers kernel/time/timer.c:2417 [inline]
>   __run_timer_base+0x734/0x9a0 kernel/time/timer.c:2428
>   run_timer_base kernel/time/timer.c:2437 [inline]
>   run_timer_softirq+0xb3/0x160 kernel/time/timer.c:2447
>   handle_softirqs+0x272/0x750 kernel/softirq.c:554
>   __do_softirq kernel/softirq.c:588 [inline]
>   invoke_softirq kernel/softirq.c:428 [inline]
>   __irq_exit_rcu+0xf0/0x1b0 kernel/softirq.c:637
>   irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
>   instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1043 [inline]
>   sysvec_apic_timer_interrupt+0xa0/0xc0 arch/x86/kernel/apic/apic.c:1043
>   </IRQ>

I see networking functions in the above call stack. Why has this report
been sent to the SCSI maintainers?

Thanks,

Bart.

