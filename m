Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818E2157465
	for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2025 09:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741942905; cv=none; b=lJq3HNaGGvz8LlJJlqI/71OvSJtS5t63lJeTCpAgrV739QQLZ9yWp130pvBDkhem7S2lBXr8CAEbZwbHRyXqOtEolrd+26gJfDeaMUZHklFg2uyX/2hjIGEbLvnKSffGpDCzj9eDDhWVE+qfvS+BTt+kcZmgzfjLdM+fa5eWWT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741942905; c=relaxed/simple;
	bh=/ad7NsJbHkcd9Hsr04s5eOcz9qcMt2lwtG44QnjLLI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lROz3k/tpu2eGtFRLcCOKYwz7KZxYbanhOcZH388zTYHLRT6qvw6xRpFOmczMPWIz0/XpKcPnJTqMsYyzH0vjSZ07+r/xgC73EtRrmcaDzhif5COW5h2watMptIGkGE1r/KxzxJTsI97tVP198Cvs4Gq8DfQueX7FcVW/PgITXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AtlCHXzU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8opNuZn0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AtlCHXzU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8opNuZn0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AtlCHXzU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8opNuZn0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AtlCHXzU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8opNuZn0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ACFAC1F388;
	Fri, 14 Mar 2025 09:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741942901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ES78FbcTxFxjRITyD7gRjRRm+Ay/hrpDNlAF66dpso=;
	b=AtlCHXzUB9nxJzkAE8kwey6w62WEaOtzRGgxf0mbhfyUcY9nJluDyuq+IVbm/1GDTxPZWc
	nv+4oG6s7FhXbQ72nyVx0xJUeTGRxxjFrddDdl6HV3D42j5MPlSo0MCJOyJv1w392Ta5dm
	0+8MPpUOg4YCbyWYNHadRROyfHtwLJ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741942901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ES78FbcTxFxjRITyD7gRjRRm+Ay/hrpDNlAF66dpso=;
	b=8opNuZn0pKfBOo2pJlT22mHu5gTWU43oXr9oDQ2BKFgG69SQYn7x3nA++cdAl8p/I2ADyu
	FZWQeV95Ntivh/Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741942901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ES78FbcTxFxjRITyD7gRjRRm+Ay/hrpDNlAF66dpso=;
	b=AtlCHXzUB9nxJzkAE8kwey6w62WEaOtzRGgxf0mbhfyUcY9nJluDyuq+IVbm/1GDTxPZWc
	nv+4oG6s7FhXbQ72nyVx0xJUeTGRxxjFrddDdl6HV3D42j5MPlSo0MCJOyJv1w392Ta5dm
	0+8MPpUOg4YCbyWYNHadRROyfHtwLJ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741942901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ES78FbcTxFxjRITyD7gRjRRm+Ay/hrpDNlAF66dpso=;
	b=8opNuZn0pKfBOo2pJlT22mHu5gTWU43oXr9oDQ2BKFgG69SQYn7x3nA++cdAl8p/I2ADyu
	FZWQeV95Ntivh/Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B02F132DD;
	Fri, 14 Mar 2025 09:01:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QlJEFHXw02evSQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 14 Mar 2025 09:01:41 +0000
Message-ID: <f35b2485-588b-40c4-a2e7-1bb65fb7a9fc@suse.de>
Date: Fri, 14 Mar 2025 10:01:40 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 00/19] scsi: scsi_error: Introduce new error handle
 mechanism
To: JiangJianJun <jiangjianjun3@huawei.com>, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lixiaokeng@huawei.com,
 hewenliang4@huawei.com, yangkunlin7@huawei.com
References: <20250314012927.150860-1-jiangjianjun3@huawei.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250314012927.150860-1-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On 3/14/25 02:29, JiangJianJun wrote:
> It's unbearable for systems with large scale scsi devices share HBAs to
> block all devices' IOs when handle error commands, we need a new error
> handle mechanism to address this issue.
> 
> I consulted about this issue a year ago, the discuss link can be found in
> refenence. Hannes replied about why we have to block the SCSI host
> then perform error recovery kindly. I think it's unnecessary to block
> SCSI host for all drivers and can try a small level recovery(LUN based for
> example) first to avoid block the SCSI host.
> 
Technically, yes.
There are, however, some issues which would need to be addressed if 
someone would design a new error handler.

1. The 'LUN Reset' TMF (as it's currently being used) is badly scoped; 
it will reset the LUN itself, affecting all ports to that LUN.
So in a multipathed/multiported environment all initiators will be 
affected, even if they haven't experienced an error.
Is that what we want?
Shouldn't we rather use the 'Reset IT Nexus' TMF here?
And, of course, the 'Target Reset' TMF has been dropped from SAM,
so I really don't see the point in spending time here ...

2. Irrespective of the EH granularity, any error handing requires
that all activity on the level has to be stopped. If you need to
issue a LUN reset, you need to stop I/O for that LUN.

3. The current EH framework is designed around 'struct scsi_cmnd'.
Which means that the command _initiating_ the error handling can
only be returned once the _entire_ error handling (with all
escalations) is finished. And more often than not, the application
is waiting on that command to be completed before the next I/O
is sent. And that really limits the effectiveness of any improved
error handler; the application ultimatively has to wait for a
host reset before it can contine.

But anyway.
We already have a mechanism for asynchronous command aborts;
have you checked if you can adapt if for LUN reset, too?
That would be the easiest solution, I guess ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
