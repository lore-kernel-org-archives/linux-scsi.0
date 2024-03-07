Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB0312C7EC
	for <linux-scsi@vger.kernel.org>; Thu,  7 Mar 2024 13:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709818268; cv=none; b=EqMG6D41djDH6OE6MUjQ3dXfkcIpHaZRKkv+sGv6o19PQONOe6tByqBohQjAJcUgV8L/v4Qt4OiQfMcbrIKQjLyaLthA2hwx0Z2Ry/Vz+8mEp7ru2FDg6JpsuPhKO/yQrvWXycYN/4J2w9oIqdSI6yyipn+iUwC1c9gv+Jw2MfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709818268; c=relaxed/simple;
	bh=kcHGXxaxmSOBJ2OCFh6zk22ZwzuRTWU4RDlWHOuNO4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TEGdxqSNKIXLFvyS+NtpB49mpraXsRo2gATyh8TZoS9APQDoqsMbnBRNsLroz8aFBwbIWFibYCDG3ZhhPDXmfuFsHqscxrk1h8oaRnj81Q4CyIuWWyJI6Nqozao0ba+TbuCCceadsZVKWYKlEv0zLpCw05qPUKONJLpLMC7Y3Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kIRa5GiF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Coch1DB8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kIRa5GiF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Coch1DB8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kIRa5GiF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Coch1DB8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kIRa5GiF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Coch1DB8"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2CE925F879;
	Thu,  7 Mar 2024 12:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709813589; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+X4RtqesHUgTo2LWHgZ07Y0OREFz8I4FH89i8xneP0=;
	b=kIRa5GiFWHUDenpr4fKPZgz7wiDQUhtexoBDfhPJej6bm54uzksQuij952y68cIDQgFpS0
	NBPRiQB1Vv1CJyP4GMkfcblfd7Hza8PX6yk+LG6krTAZgzdg8qXu1A35Ir1rkzrW7p85Pp
	qwpWi2uS/fX5bTuqlbWKJl08qiPOu3w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709813589;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+X4RtqesHUgTo2LWHgZ07Y0OREFz8I4FH89i8xneP0=;
	b=Coch1DB8k4lJtmOqVVL24phIdztmEm3qrY90r0RubQCc3BxN1N8Xa0Plwga/0g6K0sHFgP
	BPFd+KYqvIaeIXBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709813589; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+X4RtqesHUgTo2LWHgZ07Y0OREFz8I4FH89i8xneP0=;
	b=kIRa5GiFWHUDenpr4fKPZgz7wiDQUhtexoBDfhPJej6bm54uzksQuij952y68cIDQgFpS0
	NBPRiQB1Vv1CJyP4GMkfcblfd7Hza8PX6yk+LG6krTAZgzdg8qXu1A35Ir1rkzrW7p85Pp
	qwpWi2uS/fX5bTuqlbWKJl08qiPOu3w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709813589;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+X4RtqesHUgTo2LWHgZ07Y0OREFz8I4FH89i8xneP0=;
	b=Coch1DB8k4lJtmOqVVL24phIdztmEm3qrY90r0RubQCc3BxN1N8Xa0Plwga/0g6K0sHFgP
	BPFd+KYqvIaeIXBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1886D12FC5;
	Thu,  7 Mar 2024 12:13:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ilqQBVWv6WVEQwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 07 Mar 2024 12:13:09 +0000
Message-ID: <0b18f1f9-5011-46f4-a0a1-a69cd54bfc88@suse.de>
Date: Thu, 7 Mar 2024 13:13:08 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] nvme-fc: FPIN link integrity handling
Content-Language: en-US
To: Sagi Grimberg <sagi@grimberg.me>, hare@kernel.org,
 Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, James Smart <james.smart@broadcom.com>,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240219085929.31255-1-hare@kernel.org>
 <1dfa9a4e-e4a2-4d48-b569-85e48ce4311c@grimberg.me>
 <1c3eea31-b80f-4b95-ab15-ac42f7c45c16@suse.de>
 <7ff7c9cc-6b02-4adc-9b78-8bab26341049@grimberg.me>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <7ff7c9cc-6b02-4adc-9b78-8bab26341049@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	none
X-Spamd-Result: default: False [-3.09 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 URIBL_BLOCKED(0.00)[suse.de:email];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Score: -3.09
X-Spam-Flag: NO

On 3/7/24 13:01, Sagi Grimberg wrote:
> 
> 
> On 07/03/2024 13:29, Hannes Reinecke wrote:
>> On 3/7/24 11:10, Sagi Grimberg wrote:
>>>
>>>
>>> On 19/02/2024 10:59, hare@kernel.org wrote:
>>>> From: Hannes Reinecke <hare@suse.de>
>>>>
>>>> FPIN LI (link integrity) messages are received when the attached
>>>> fabric detects hardware errors. In response to these messages the
>>>> affected ports should not be used for I/O, and only put back into
>>>> service once the ports had been reset as then the hardware might
>>>> have been replaced.
>>>
>>> Does this mean it cannot service any type of communication over
>>> the wire?
>>>
>> It means that the service is impacted, and communication cannot be 
>> guaranteed (CRC errors, packet loss, you name it).
>> So the link should be taken out of service until it's been (manually)
>> replaced.
> 
> OK, that's what I assumed.
> 
>>
>>>> This patch adds a new controller flag 'NVME_CTRL_TRANSPORT_BLOCKED'
>>>> which will be checked during multipath path selection, causing the
>>>> path to be skipped.
>>>
>>> While this looks sensible to me, it also looks like this introduces a 
>>> ctrl state
>>> outside of ctrl->state... Wouldn't it make sense to move the 
>>> controller to
>>> NVME_CTRL_DEAD ? or is it not a terminal state?
>>>
>> Actually, I was trying to model it alongside the 
>> 'devloss_tmo'/'fast_io_fail' mechanism we have in SCSI.
>> Technically the controller is still present, it's just that we shouldn't
>> send I/O to it.
> 
> Sounds like a dead controller to me.
> 
Sort of, yes.

>> And I'd rather not disconnect here as we're trying to
>> do an autoconnect on FC, so manually disconnect would interfere with
>> that and we probably end in a death spiral doing disconnect/reconnect.
> 
> I suggested just transitioning the state to DEAD... Not sure how 
> keep-alives behave though...
> 
Hmm. The state machine has the transition LIVE->DELETING->DEAD,
ie a dead controller is on the way out, with all resources being
reclaimed.

A direct transition would pretty much violate that.
If we were going that way I'd prefer to have another state
('IMPACTED' ? 'LIVE_NOIO' ?) with the transitions
LIVE->IMPACTED->DELETING->DEAD

>>
>> We could 'elevate' it to a new controller state, but wasn't sure how big
>> an appetite there is. And we already have flags like 'stopped' which
>> seem to fall into the same category.
> 
> stopped is different because it is not used to determine if it is capable
> for IO (admin or io queues). Hence it is ok to be a flag.
> 
Okay.

So yeah, we could introduce a new state, but I guess a direct transition
to 'DEAD' is not really a good idea.

Cheers,

Hannes

