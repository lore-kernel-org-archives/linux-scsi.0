Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE621FC8
	for <linux-scsi@vger.kernel.org>; Thu,  5 Jun 2025 06:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749103304; cv=none; b=pFzv4aZq4fVVAJxnKw6g51ha5NN1Y9yzZZUyqp8u2heRv+i/CibObqBSc1v7WenOgQd4Gcvq+Z1eibfSGSExjU7HTijYMjx8NLpw2WtgfaI8c8kE1h4yvt/pdcCKeVb4CjXeFZs2Gh7CkWIwWE7B1Fui3UJND+HGgEYZr1CEbhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749103304; c=relaxed/simple;
	bh=M8QZmBD0ZPJrqhiSCNNbeJu51o5CaN/7G3c+Xl8U2Z4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tArJGxl9ZkYTFUaAx6MhLgcP+P4WiCJWZ9JFAalGAhi87Al2R8XK7hObiK9SOx/KFGmZWynpboZKA58RvCW7Qql4AsFd8odCxIhg+f4A6Sf8WePiey5PvYmYa7IAH7KSpZ/NNIvF/uPdGZy+b1Cso2WNfdrz4rVXPWU+Ku3ZHaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MjByNuoe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WzwLABCF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MjByNuoe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WzwLABCF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MjByNuoe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WzwLABCF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MjByNuoe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WzwLABCF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D25B23439D;
	Thu,  5 Jun 2025 06:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749103300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OT4buQt3ej32l9/4XvTTl1cX0WhBmPm7BItKSnIsM2o=;
	b=MjByNuoeusKBGJlxCeEtrBgj3YYWOIGDwhCT0U7EE5Zv0rgls1YlAcT4dfb23+Sl7JtJEo
	M2R77XXC1MwXC4HoKpelmVnHVig2a6CFPmCdj0LYCB8LZUuUUsxoJp8VKutPNuAnLOgsAn
	R+abXclUv6zEzLag9iNg7YYQxywomPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749103300;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OT4buQt3ej32l9/4XvTTl1cX0WhBmPm7BItKSnIsM2o=;
	b=WzwLABCFJ4h6cFprUossKHY+Gu8NppE9YkMzXfuHAFDnWMI/dX0B3OMSETUazIM88jPo/5
	fdw56EACvlUzddBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749103300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OT4buQt3ej32l9/4XvTTl1cX0WhBmPm7BItKSnIsM2o=;
	b=MjByNuoeusKBGJlxCeEtrBgj3YYWOIGDwhCT0U7EE5Zv0rgls1YlAcT4dfb23+Sl7JtJEo
	M2R77XXC1MwXC4HoKpelmVnHVig2a6CFPmCdj0LYCB8LZUuUUsxoJp8VKutPNuAnLOgsAn
	R+abXclUv6zEzLag9iNg7YYQxywomPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749103300;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OT4buQt3ej32l9/4XvTTl1cX0WhBmPm7BItKSnIsM2o=;
	b=WzwLABCFJ4h6cFprUossKHY+Gu8NppE9YkMzXfuHAFDnWMI/dX0B3OMSETUazIM88jPo/5
	fdw56EACvlUzddBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 812001373E;
	Thu,  5 Jun 2025 06:01:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id u+uNHcQyQWjsEQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 05 Jun 2025 06:01:40 +0000
Message-ID: <2455a292-5bba-4e6e-ab85-4fed0f917d7d@suse.de>
Date: Thu, 5 Jun 2025 08:01:40 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi/fcoe: simplify fcoe_select_cpu()
To: Yury Norov <yury.norov@gmail.com>, Bart Van Assche <bvanassche@acm.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>
References: <20250604234201.42509-1-yury.norov@gmail.com>
 <0959d3c2-b849-4826-8edf-d72a89fbadff@acm.org> <aEDmXvKAvJfjMrCk@yury>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aEDmXvKAvJfjMrCk@yury>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,acm.org];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[hansenpartnership.com,oracle.com,vger.kernel.org,kernel.org,gmail.com];
	RCPT_COUNT_SEVEN(0.00)[8];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On 6/5/25 02:35, Yury Norov wrote:
> + Tejun, Lai
> 
> On Thu, Jun 05, 2025 at 08:13:53AM +0800, Bart Van Assche wrote:
>> On 6/5/25 7:42 AM, Yury Norov wrote:
>>> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
>>> index b911fdb387f3..07eddafe52ff 100644
>>> --- a/drivers/scsi/fcoe/fcoe.c
>>> +++ b/drivers/scsi/fcoe/fcoe.c
>>> @@ -1312,10 +1312,7 @@ static inline unsigned int fcoe_select_cpu(void)
>>>    {
>>>    	static unsigned int selected_cpu;
>>> -	selected_cpu = cpumask_next(selected_cpu, cpu_online_mask);
>>> -	if (selected_cpu >= nr_cpu_ids)
>>> -		selected_cpu = cpumask_first(cpu_online_mask);
>>> -
>>> +	selected_cpu = cpumask_next_wrap(selected_cpu, cpu_online_mask);
>>>    	return selected_cpu;
>>>    }
>>
>> Why does this algorithm occur in the FCoE driver? Isn't
>> WORK_CPU_UNBOUND good enough for this driver? And if it isn't
>> good enough, shouldn't this kind of functionality be integrated in
>> kernel/workqueue.c rather than having the above algorithm in a
>> kernel driver?
> 
> (I'm obviously not an expert in this driver, and just wanted to cleanup
> the cpumask API usage.)
> 
> It looks like the intention is to distribute the workload among CPUs
> sequentially. If you move this function out of the driver, someone
> else may call the function, and sequential distribution may get
> broken.
> 
> If sequential distribution doesn't matter here, and the real
> intention is just to distribute workload more or less evenly,
> we already have cpumask_any_distribute() for this.
> 
This function is used to distribute incoming skbs onto a work
cpu. And it's actually quite pointless, as the skb already
has a field (skb->sk->sk_incoming_cpu) which tells you exactly
on which CPU this skb was received, so we should use that
here.

I'll send a patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
