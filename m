Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729B333985
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 05:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777009535; cv=none; b=TtT3a3Q8uaaz6Q73z3IwL0d0WBqKWsd7K+U3wPzolOVTsvBhKxUuE+6kc5VYe4V1bxY5x8pGatuwDgXydy4YV0OIEYrLD0B+uGpAgLru/z0D/+ycGJ/P3+t88TNQ/JrgIn9NaQEEvP2cTXbIh7cIDy56evCNuZqdLjKAJwHKQ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777009535; c=relaxed/simple;
	bh=HgQKvX/MQiImjdres3zV+GZ6STzueo6KF1Knoj4qF+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d+CyL79uU7iFo6cUkOaVzYZO8USDIq03F7G036w7M3BK0eNnWw6UOtD316mO6VNiJR8kt8CEBBmLWHw0JExrc6noyJ9XmA9Y+8zl4UbmMLqpZkFfE267EqOrAMKfYU3NrhSqMgHS+AvXE+PCcuctvVwCJ/a4YtEGciYjwIDqA8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FGNwJbQE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=i1JgatN3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FGNwJbQE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=i1JgatN3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FGNwJbQE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="i1JgatN3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FGNwJbQE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="i1JgatN3"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC5916A864;
	Fri, 24 Apr 2026 05:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777009532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CQhgHGnANf2ouu43yT8/qCH+4ivxi8mRrhInrUB9nCw=;
	b=FGNwJbQEUnSZN4qWY5opFLLCTFE9t498f3qPtgcRzZE1duOl9d95UKwglTUXmUp6FdlXKW
	SwPAiBgxlI2oJMBGLc/31vTxhQME+epQKlKfY+UXvAKHQ8ujHKn2mLKZbI8YitE9EFX/pY
	TJHqlzvLbk2IuTCN5MQMKelDgEja3e0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777009532;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CQhgHGnANf2ouu43yT8/qCH+4ivxi8mRrhInrUB9nCw=;
	b=i1JgatN3a084/kua+VsTDEwrbzadmNNcs+5EfXFziFeVnKqVGtig4Db1S4rpEJK83sVOXK
	WKRavIzZQ3Z3THBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777009532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CQhgHGnANf2ouu43yT8/qCH+4ivxi8mRrhInrUB9nCw=;
	b=FGNwJbQEUnSZN4qWY5opFLLCTFE9t498f3qPtgcRzZE1duOl9d95UKwglTUXmUp6FdlXKW
	SwPAiBgxlI2oJMBGLc/31vTxhQME+epQKlKfY+UXvAKHQ8ujHKn2mLKZbI8YitE9EFX/pY
	TJHqlzvLbk2IuTCN5MQMKelDgEja3e0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777009532;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CQhgHGnANf2ouu43yT8/qCH+4ivxi8mRrhInrUB9nCw=;
	b=i1JgatN3a084/kua+VsTDEwrbzadmNNcs+5EfXFziFeVnKqVGtig4Db1S4rpEJK83sVOXK
	WKRavIzZQ3Z3THBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 47677593AE;
	Fri, 24 Apr 2026 05:45:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cvVAEHwD62mFYwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 24 Apr 2026 05:45:32 +0000
Message-ID: <ba82106e-ee68-43e2-93da-bb215fc26acc@suse.de>
Date: Fri, 24 Apr 2026 07:45:31 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] scsi: Support devices that don't have a cmd_per_lun
 limit
To: Bart Van Assche <bvanassche@acm.org>,
 Mike Christie <michael.christie@oracle.com>,
 Stefan Hajnoczi <stefanha@redhat.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, virtualization@lists.linux.dev,
 mst@redhat.com, pbonzini@redhat.com, eperezma@redhat.com
References: <20260417230751.117836-1-michael.christie@oracle.com>
 <20260420173352.GB405461@fedora>
 <603eee86-9914-4ac8-b937-a38922e69a45@oracle.com>
 <9ce439b8-4e56-4a8c-8ef9-d8d9e93ab77a@suse.de>
 <39585b28-64d8-42a4-afab-a88ca1eb83b6@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <39585b28-64d8-42a4-afab-a88ca1eb83b6@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On 4/23/26 18:40, Bart Van Assche wrote:
> On 4/23/26 2:45 AM, Hannes Reinecke wrote:
>> Ideally I would kill cmd_per_lun.
>> This really is a poor man's fairness algorithm (sole purpose is to
>> avoid starvation with many luns), and we really should look at if
>> we cannot replace it with tagsets.
> 
> Hmm ... isn't cmd_per_lun essential since the introduction of scsi-mq?
> Without a host-wide tagset, and with n hardware queues,
> blk_mq_alloc_tag_set() allocates (number of hardware queues) *
> (shost->can_queue + shost->nr_reserved_cmds) requests. Each request
> maps to one SCSI command. Setting cmd_per_lun to shost->can_queue may
> be essential to avoid BUSY responses from a SCSI device. Here is an
> example from the ib_srp driver (there are many more SCSI LLDs that
> follow this pattern):
> * During connection establishment, the SCSI target reports the
>    maximum queue depth it supports. This response is used to initialize
>    can_queue and cmd_per_lun.
> * Multiple hardware queues are allocated, all supporting can_queue
>    commands.
> * cmd_per_lun is set to can_queue to avoid BUSY responses from the SCSI
>    target. My experience is that for high performance SCSI targets even
>    1% BUSY responses cause a significant performance drop.
> 
My point being that cmd_per_lun is a single setting, and is extremely
imprecise. At the same time we already have fine-grained request QoS
available by virtue of tagsets.
Seems like we need to have a 'device_tagset' setting, too.
Hmm.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
