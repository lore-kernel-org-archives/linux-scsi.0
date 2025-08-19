Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F6E23E356
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2025 06:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755585276; cv=none; b=dNWx5XAkFjiWj6ILH78NX1JTc4bDIqghra75Ac62BesvEb7IQqp3Lp4VneToPzEZfqNdW/ya4szu3RGy1YWKADDbJ5UndW8sbRoZjSqSyRLzdCyvYVY0WC72qh4aaCw2b13rQjP59mV6ufHNsVCgcJ6wLiwliOGJ6DyaIfQmM5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755585276; c=relaxed/simple;
	bh=eZrISB3hHi7kxRkkzgrmvoPaiiDurwZRNAbBnbQQZuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ui4JmjYt1furFxBQGHquaNNser4OwHTP191+OWTplfZzTtRNWZWTp1OMVS/bo9YrI3TkAodU8CHYifeSBVvceL/lteQnUxh2Cdq7w2SsAIjtEycI0LqSGVBwK6QgAw/wpsdu4whWMrICWZxb8XMznVlXMQtXCX2od1aSKFng4ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZOuJYhSb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tbCOJiwx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZOuJYhSb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tbCOJiwx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZOuJYhSb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tbCOJiwx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZOuJYhSb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tbCOJiwx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 21D171F749;
	Tue, 19 Aug 2025 06:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755585272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ArrivmL3VgKDBCHdY+8xsquOaKkv+QG5wDtllayhOMY=;
	b=ZOuJYhSbnvXG+MpH6OOlMonXUanew3EeiTHczjlYkwLJb9zUlEmDKMhIYcuVNkpH0wdlXN
	HLZhkLOCXrhp6nWusLgc3q+qwafnV4fp+vXKI6Q84K4d8CDAFFWjTcDyDv6OwuB4WnW4rk
	TxlgU5ECxG6/oCfISbht4Vf4/CTRY7Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755585272;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ArrivmL3VgKDBCHdY+8xsquOaKkv+QG5wDtllayhOMY=;
	b=tbCOJiwxhOg94GbkQ9WNALDhkJCDSvbGMm0sQySsrLHLUr6Azy/dIjtcsZjHQUVAZi/13F
	9P3ACzPB/2j8CQDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755585272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ArrivmL3VgKDBCHdY+8xsquOaKkv+QG5wDtllayhOMY=;
	b=ZOuJYhSbnvXG+MpH6OOlMonXUanew3EeiTHczjlYkwLJb9zUlEmDKMhIYcuVNkpH0wdlXN
	HLZhkLOCXrhp6nWusLgc3q+qwafnV4fp+vXKI6Q84K4d8CDAFFWjTcDyDv6OwuB4WnW4rk
	TxlgU5ECxG6/oCfISbht4Vf4/CTRY7Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755585272;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ArrivmL3VgKDBCHdY+8xsquOaKkv+QG5wDtllayhOMY=;
	b=tbCOJiwxhOg94GbkQ9WNALDhkJCDSvbGMm0sQySsrLHLUr6Azy/dIjtcsZjHQUVAZi/13F
	9P3ACzPB/2j8CQDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB42A139B3;
	Tue, 19 Aug 2025 06:34:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BDhFJ/capGhwEgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 19 Aug 2025 06:34:31 +0000
Message-ID: <36c7bf20-7dd4-4e19-8bc0-461a9f8a4228@suse.de>
Date: Tue, 19 Aug 2025 08:34:31 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/30] scsi: core: Do not allocate a budget token for
 reserved commands
To: Bart Van Assche <bvanassche@acm.org>, John Garry
 <john.g.garry@oracle.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-4-bvanassche@acm.org>
 <f2d65247-ad6b-44ea-a687-808d8c398afc@suse.de>
 <30b475dc-3287-4bcb-99be-f2b6649217a5@oracle.com>
 <004de5e3-ad51-4a49-b7c7-e418587d3ef7@suse.de>
 <3a1f6959-8d74-4bb9-8e4b-31b5105734f9@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <3a1f6959-8d74-4bb9-8e4b-31b5105734f9@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,huawei.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 8/18/25 17:58, Bart Van Assche wrote:
> On 8/18/25 6:21 AM, Hannes Reinecke wrote:
>> On 8/18/25 15:16, John Garry wrote:
>>> JFYI, when I attempted this previously, I put the check in the blk-mq 
>>> code, like here https://lore.kernel.org/linux- 
>>> scsi/1666693096-180008-2- git-send-email-john.garry@huawei.com/
>>>
>>> Not needing budget for reserved tags seems a common blk-mq feature. 
>>> But then only SCSI implements the budget CBs ...
>>>
>> Yeah, that is a far better approach.
> I do not agree. Only the SCSI core can know whether or not a budget
> should be allocated for reserved requests. The block layer core can't
> know whether or not it should allocate a budget for reserved requests.
> The block layer core can't know whether the SCSI core is allocating a
> reserved request to guarantee forward progress or whether it is
> allocating a request that should not be counted against the cmd_per_lun
> limit. Hence, the decision whether or not to allocate a budget for a
> reserved request should be taken by the SCSI core.
> 
To my understanding reserved commands are _never_ included in
cmd_per_lun; and if we move TMFs and all non-I/O commands to
reserved commands cmd_per_lun will only be applicable to
I/O commands.
So yes, once we move to reserved commands the budget applies
only to normal requests, and never to reserved commands.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
