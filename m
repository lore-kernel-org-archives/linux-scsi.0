Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C55363B8
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 14:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709906978; cv=none; b=k68AyFEoQtbnEPJPUmn4RPIKsFigLhuugfK7zqfkOO1oj83ddslxJ3ERqXVvxwIxrW8Kn02IDiHhAAAqi9XGYtbi1xuN5ljntuKVOV8bmMrDWQ6FnzC+H4qQvwbjIANrFUYOpxSasIpdEpz5hemPzGdKjeKhmi80Trmp11Urt18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709906978; c=relaxed/simple;
	bh=ZLSivilCRa2woLGvUeNAJQVtCUtEQeMse+2zHt9HubE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h88A56ucMMjU0uB1MWfbGzgwkXE2H5FIV532cfmLYB+N2KoMi9t4b66GzvZTaP2gV855nkHCchn4mFOF7JYqHO6ALfkoLZ0TQ0Kuw5c3hiV8WzjKx8nmFBHDuwu5ymFJ9NYIB6rj7mJ0z9XQBVzbs9NbzuvaN4XD7ZlAwR7EURA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LdMNq9Vk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IaEfwZkH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LdMNq9Vk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IaEfwZkH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LdMNq9Vk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IaEfwZkH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LdMNq9Vk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IaEfwZkH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 30B4F20B3D;
	Fri,  8 Mar 2024 14:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709906974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y4uCvWz3Wy225W7/wbSZJRlf3ELP7rtGeXQ194o+g58=;
	b=LdMNq9Vk53GnG9IwC9ecyET/5PXz7mAJjJ+gnbYY8BPR9c0b7yNqTpG+DqWDpmFYHoVQfB
	618BZ7iaXEmI1SV3I9VaQA7cvYuyKpUi/d+hTG8uXCbm6Tw+m1jgZ3ah4K6te2ImmvPn7j
	kisnvTKK0k8ZEaLCId+4XNj0iJEDszw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709906974;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y4uCvWz3Wy225W7/wbSZJRlf3ELP7rtGeXQ194o+g58=;
	b=IaEfwZkHw+pQgoIW69W1H4SJ55T1itiwBXuTEQCUJYxabMQ6ALZHOkfwRnrj/mr4Cd1E+s
	BiNBNTpp9w5onaBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709906974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y4uCvWz3Wy225W7/wbSZJRlf3ELP7rtGeXQ194o+g58=;
	b=LdMNq9Vk53GnG9IwC9ecyET/5PXz7mAJjJ+gnbYY8BPR9c0b7yNqTpG+DqWDpmFYHoVQfB
	618BZ7iaXEmI1SV3I9VaQA7cvYuyKpUi/d+hTG8uXCbm6Tw+m1jgZ3ah4K6te2ImmvPn7j
	kisnvTKK0k8ZEaLCId+4XNj0iJEDszw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709906974;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y4uCvWz3Wy225W7/wbSZJRlf3ELP7rtGeXQ194o+g58=;
	b=IaEfwZkHw+pQgoIW69W1H4SJ55T1itiwBXuTEQCUJYxabMQ6ALZHOkfwRnrj/mr4Cd1E+s
	BiNBNTpp9w5onaBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CFDF713310;
	Fri,  8 Mar 2024 14:09:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 47nJMB0c62XbKgAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 08 Mar 2024 14:09:33 +0000
Message-ID: <4f3ee04a-daeb-4813-9f08-6450cffa1d70@suse.de>
Date: Fri, 8 Mar 2024 15:09:33 +0100
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
 <0b18f1f9-5011-46f4-a0a1-a69cd54bfc88@suse.de>
 <2b0bdbfb-1bff-405a-8f95-163a99022d94@grimberg.me>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <2b0bdbfb-1bff-405a-8f95-163a99022d94@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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

On 3/8/24 11:38, Sagi Grimberg wrote:
> 
> 
> On 07/03/2024 14:13, Hannes Reinecke wrote:
>> On 3/7/24 13:01, Sagi Grimberg wrote:
>>>
[ .. ]
>>>
>>> stopped is different because it is not used to determine if it is 
>>> capable for IO (admin or io queues). Hence it is ok to be a flag.
>>>
>> Okay.
>>
But wait, isn't that precisely what we're trying to achieve here?
IE can't we call nvme_quiesce_io_queues() when we detect a link 
integrity failure?

Lemme check how this would work out...

>> So yeah, we could introduce a new state, but I guess a direct transition
>> to 'DEAD' is not really a good idea.
> 
> How common do you think this state would be? On the one hand, having a 
> generic state that the transport is kept a live but simply refuses to
> accept I/O; sounds like a generic state, but I can't think of an
> equivalent in the other transports.
> 

Yeah, it's pretty FC specific for now. Authentication is similar, 
though, as the spec implies that we shouldn't sent I/O when 
authentication is in progress.

> If this is something that is private to FC, perhaps the right way is to 
> add a flag for it that only fc sets, and when a second usage of it appears,
> we promote it to a proper controller state. Thoughts?

But that's what I'm doing, no? Only FC sets the 'transport blocked'
flag, so I'm not sure how your idea would be different here...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

