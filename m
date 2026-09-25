Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0BB3F7AAB;
	Fri, 25 Sep 2026 05:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313006; cv=none; b=rJvEXjU6yB+G0S6jRAjrPKZfzM9wvzvaYdYUfOPKEYQulWcQ4m7ZzAoJpNaEaJ/N4Dz762Zfz3gfWjRK3qQ6kvYbTlR49UTRnVRYn6CrEMdwZSbptxtqjS79TgNuH/wg3nRVaiifCOTzLv5KdzjgdQP9OkYMtAmQj14rUf6uDV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313006; c=relaxed/simple;
	bh=v64y7N95oMg6Ru5wJOHoWnwLhn0lEqJ9B7e7jl8MkvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F4Sm+ocI8PK+FmiLx82rwPiIDq2qMQg8lz/Z/DzwECVZsnqCVuH31G29uTvPC2/K/yo3A3lDSwmJ6QTdLYIBIY4bFr9x/n5UyyqrxksBspWzWJr+9+QN3xSr7dgZwVDWlbL2n+qZolcHAG0Rv1EMIJuu2p/bgLdLPFgmVKRwe/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JwW8oDJf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HGIU1Czn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Hd6qNjaJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+AAfL/Lm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JwW8oDJf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HGIU1Czn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Hd6qNjaJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+AAfL/Lm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3C5B91FFE6;
	Fri, 25 Sep 2026 05:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790312998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D0JZfVv9Tl9PjTrtkqmBRz5s6KPc27+JXH6tHdZHZWM=;
	b=JwW8oDJfti+pnwyHBiaSGR2i9WEMTlMCPgUBJPEtQRmn98TFYJkP9QHY3axB5igt/nc6cU
	QNzq/BXKm1oXbisMy52S0F1We+V/GNBTeI8Iprhw2ss2pa1qKioxDgSfP/FTJU6fhUa8eA
	cgTTPjA8jJQTsscRIVgQbjd5rAAjiAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790312998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D0JZfVv9Tl9PjTrtkqmBRz5s6KPc27+JXH6tHdZHZWM=;
	b=HGIU1CznmJQAKQX6+atRx85T/TOA2c4IsX4xZcfB0KUp3MvPUxBTojBuTzXFhN/xdKc3yI
	j1a1yzOQ/OG4KRAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Hd6qNjaJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="+AAfL/Lm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790312994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D0JZfVv9Tl9PjTrtkqmBRz5s6KPc27+JXH6tHdZHZWM=;
	b=Hd6qNjaJKmc+6UAmoTxECGTheOO76ZwWUYZ4HFrJWd0587kQ6fyKdlmm3FLxCYt1Fx/XJc
	kjMerftAaJu4nmy/xaYSf06eNXzketD43kxtzyGIemw5Qt2Alh0AGBnb1NsC1t49q42Mp5
	S7uQSXJ7bzhSzcsF1DThg6Vm51G4BSI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790312994;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D0JZfVv9Tl9PjTrtkqmBRz5s6KPc27+JXH6tHdZHZWM=;
	b=+AAfL/LmruMK41qlVoULgHUAU3gUxuJHtOPPJqLntUGI/EDUvvRBUc2XTGRJgcI6IyP/Dl
	6ckMS71us+i9gDCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6205213432;
	Fri, 25 Sep 2026 05:09:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aDteBSECtmqTfgAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 25 Sep 2026 05:09:53 +0000
Message-ID: <a7a60b61-24b4-429b-8ccb-ee5b6f06a5ed@suse.de>
Date: Fri, 25 Sep 2026 07:09:52 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] nvme: fcloop: Add set_marginal_rport to sysfs
To: Jesse Taube <jtaubepe@redhat.com>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Justin Tee <justin.tee@broadcom.com>,
 Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
 Paul Ely <paul.ely@broadcom.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 John Meneghini <jmeneghi@redhat.com>, Bryan Gurney <bgurney@redhat.com>,
 Chris Leech <cleech@redhat.com>, "Ewan D . Milne" <emilne@redhat.com>,
 shinichiro.kawasaki@wdc.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
References: <20260902200547.184734-1-jtaubepe@redhat.com>
 <20260902200547.184734-8-jtaubepe@redhat.com>
 <ab97f32b-31dd-4975-a8b2-b445110ae3a9@suse.de>
 <CADRr4bePoiDnWX_XrMWtQe=1g4Yrw1_dK86EV2k9XZR0HnL+UQ@mail.gmail.com>
 <d4879e78-2735-4f86-beab-8aa319e9162c@suse.de>
 <CADRr4bcSvLwzfSiV0LTxnhZR7oo3F1b2XEo+wwqi668Gr2BBQA@mail.gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <CADRr4bcSvLwzfSiV0LTxnhZR7oo3F1b2XEo+wwqi668Gr2BBQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3C5B91FFE6
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[lists.infradead.org,vger.kernel.org,lwn.net,linuxfoundation.org,kernel.org,kernel.dk,lst.de,grimberg.me,broadcom.com,gmail.com,nvidia.com,hansenpartnership.com,oracle.com,marvell.com,redhat.com,wdc.com];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 9/23/26 6:16 PM, Jesse Taube wrote:
> On Wed, Sep 23, 2026 at 11:34 AM Hannes Reinecke <hare@suse.de> wrote:
>>
>> On 9/23/26 4:56 PM, Jesse Taube wrote:
>>> On Mon, Sep 21, 2026 at 10:03 AM Hannes Reinecke <hare@suse.de> wrote:
>>>>
[ .. ]
>>>>> @@ -1671,6 +1719,7 @@ static DEVICE_ATTR(del_remote_port, 0200, NULL, fcloop_delete_remote_port);
>>>>>     static DEVICE_ATTR(add_target_port, 0200, NULL, fcloop_create_target_port);
>>>>>     static DEVICE_ATTR(del_target_port, 0200, NULL, fcloop_delete_target_port);
>>>>>     static DEVICE_ATTR(set_cmd_drop, 0200, NULL, fcloop_set_cmd_drop);
>>>>> +static DEVICE_ATTR(set_marginal_rport, 0200, NULL, fcloop_set_marginal_rport);
>>>>>
>>>>>     static struct attribute *fcloop_dev_attrs[] = {
>>>>>         &dev_attr_add_local_port.attr,
>>>>> @@ -1680,6 +1729,7 @@ static struct attribute *fcloop_dev_attrs[] = {
>>>>>         &dev_attr_add_target_port.attr,
>>>>>         &dev_attr_del_target_port.attr,
>>>>>         &dev_attr_set_cmd_drop.attr,
>>>>> +     &dev_attr_set_marginal_rport.attr,
>>>>>         NULL
>>>>>     };
>>>>>
>>>> Please don't make it a fabrics option.
>>>
>>> What do you mean by fabrics option? How should I fix this?
>>>
>> Your patch does two things; one is to modify the parser in
>> fcloop_parse_options, and the other is to implement a new
>> sysfs rport attribute 'set_marginal_rport()'.
>> My suggestion is to drop the first part;
> 
> You want to drop the parser?
> 
Yes. 'set_marginal_rport()' sets a boolean value.
You don't really need a parser for that.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
