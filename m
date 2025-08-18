Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD3D335BD8
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 13:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523285; cv=none; b=RdbBVfPPVnkHYK0rZuUf756nuZ5nsaGLYKoBAnJlYJSVp4IuBzhA70Bgjs+YY5jlYwrTUXX6F30bUqzyy2KIS1KaxLF/EhWGhvZT1RxS1Xy3lNLBkM52YJHIo7IriJlLGMvv+3J9n2UPXCyqDpWoHA57ykSDElxrvpLF2gwDIK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523285; c=relaxed/simple;
	bh=0pLAbp/s40G5LbNZkdFCYoOeLDGjp/UZwUDdOi4hMkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZqBKv0G2d9I9I5JH+qQZ0Shaccr1nqs9SrjMyfrTPvDnEJlU9mlPTa17BKGiLg9ISzSwQWT5p7T1utxejZ7bWf2lhre0TWyhsKmOs0xpUCjSwd63hYRDcl3XJOLfhpKAiZmLcup5hAkmP9krdW6qoz6Hcx9XOGzYNPtY11iOW4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kqTi+e+g; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=m142hiyO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kqTi+e+g; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=m142hiyO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kqTi+e+g";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="m142hiyO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kqTi+e+g";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="m142hiyO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 52C261F387;
	Mon, 18 Aug 2025 13:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755523280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YT4pSlz1ZkE+Bp8mb3GynF91445lFh8Nm+sXLpK7vcU=;
	b=kqTi+e+g8KbGFvLSm8ic1Y1pshngrmoMZHAUHv+fXLXdNOsbj9r0QrUYWk0YByacExQDQX
	xnCSsbTP7verQ0221TgLH20QCqidi9HnEWhvKicjk1xDTCS2U+kvowH/3o7r6xLt2Db+Zq
	Kl6RitQJZ/HMtRP+A7LeeyqaOEUz+aU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755523280;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YT4pSlz1ZkE+Bp8mb3GynF91445lFh8Nm+sXLpK7vcU=;
	b=m142hiyOSFUmrWSISYsoyY3s1GI2q7IA8ev5+TnmYdBAbf16aIpLZG0mV48MNJKxsKgOxt
	+3hExf5qYhRmHHDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kqTi+e+g;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m142hiyO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755523280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YT4pSlz1ZkE+Bp8mb3GynF91445lFh8Nm+sXLpK7vcU=;
	b=kqTi+e+g8KbGFvLSm8ic1Y1pshngrmoMZHAUHv+fXLXdNOsbj9r0QrUYWk0YByacExQDQX
	xnCSsbTP7verQ0221TgLH20QCqidi9HnEWhvKicjk1xDTCS2U+kvowH/3o7r6xLt2Db+Zq
	Kl6RitQJZ/HMtRP+A7LeeyqaOEUz+aU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755523280;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YT4pSlz1ZkE+Bp8mb3GynF91445lFh8Nm+sXLpK7vcU=;
	b=m142hiyOSFUmrWSISYsoyY3s1GI2q7IA8ev5+TnmYdBAbf16aIpLZG0mV48MNJKxsKgOxt
	+3hExf5qYhRmHHDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF0DE13A55;
	Mon, 18 Aug 2025 13:21:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S673NM8oo2g0BgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 18 Aug 2025 13:21:19 +0000
Message-ID: <004de5e3-ad51-4a49-b7c7-e418587d3ef7@suse.de>
Date: Mon, 18 Aug 2025 15:21:19 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/30] scsi: core: Do not allocate a budget token for
 reserved commands
To: John Garry <john.g.garry@oracle.com>, Bart Van Assche
 <bvanassche@acm.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-4-bvanassche@acm.org>
 <f2d65247-ad6b-44ea-a687-808d8c398afc@suse.de>
 <30b475dc-3287-4bcb-99be-f2b6649217a5@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <30b475dc-3287-4bcb-99be-f2b6649217a5@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 52C261F387
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 8/18/25 15:16, John Garry wrote:
> On 18/08/2025 13:23, Hannes Reinecke wrote:
>> On 8/11/25 19:34, Bart Van Assche wrote:
>>> The SCSI budget mechanism is used to implement the host->cmd_per_lun 
>>> limit.
>>> This limit does not apply to reserved commands. Hence, do not allocate a
>>> budget token for reserved commands.
>>>
>>> Cc: Hannes Reinecke <hare@suse.de>
>>> Cc: John Garry <john.g.garry@oracle.com>
>>> Cc: Ming Lei <ming.lei@redhat.com>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>> ---
>>>   drivers/scsi/scsi_lib.c | 14 ++++++++++++--
>>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index 9c67e04265ce..0112ad3859ff 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -396,7 +396,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, 
>>> struct scsi_cmnd *cmd)
>>>       if (starget->can_queue > 0)
>>>           atomic_dec(&starget->target_busy);
>>> -    sbitmap_put(&sdev->budget_map, cmd->budget_token);
>>> +    if (cmd->budget_token < INT_MAX)
>>> +        sbitmap_put(&sdev->budget_map, cmd->budget_token);
>>>       cmd->budget_token = -1;
>>>   }
>>> @@ -1360,6 +1361,14 @@ static inline int scsi_dev_queue_ready(struct 
>>> request_queue *q,
>>>   {
>>>       int token;
>>> +    /*
>>> +     * Do not allocate a budget token for reserved SCSI commands. 
>>> Budget
>>> +     * tokens are used to enforce the cmd_per_lun limit. That limit 
>>> does not
>>> +     * apply to reserved commands.
>>> +     */
>>> +    if (scsi_device_is_pseudo_dev(sdev))
>>> +        return INT_MAX;
>>> +
>>>       token = sbitmap_get(&sdev->budget_map);
>>>       if (token < 0)
>>>           return -1;
>>> @@ -1749,7 +1758,8 @@ static void scsi_mq_put_budget(struct 
>>> request_queue *q, int budget_token)
>>>   {
>>>       struct scsi_device *sdev = q->queuedata;
>>> -    sbitmap_put(&sdev->budget_map, budget_token);
>>> +    if (budget_token < INT_MAX)
>>> +        sbitmap_put(&sdev->budget_map, budget_token);
>>>   }
>>>   /*
>>
>> Good idea, but we should document that somewhere that 'INT_MAX' now has
>> a distinct meaning.
> 
> JFYI, when I attempted this previously, I put the check in the blk-mq 
> code, like here https://lore.kernel.org/linux-scsi/1666693096-180008-2- 
> git-send-email-john.garry@huawei.com/
> 
> Not needing budget for reserved tags seems a common blk-mq feature. But 
> then only SCSI implements the budget CBs ...
> 
Yeah, that is a far better approach.
Bart? Care to include it?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
