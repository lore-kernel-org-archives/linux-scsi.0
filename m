Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA74C2206B3
	for <linux-scsi@vger.kernel.org>; Wed, 16 Apr 2025 07:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744789155; cv=none; b=q/PDCcpAK+SaHzq55qbqNY/rjZmUvPmq8pik0CmIq9Egc/pMQ0TUMTFmdu7iNuJRnMkDNezi1VZ7Ss/G7x4O0gflV9eXpZ10xQeEdcVObq+ImZsSt6flur2m/bEckjta/os4PelqVDFR8s3v5VGYzvQU5521fM/udYufMOtiEsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744789155; c=relaxed/simple;
	bh=P+bVINcqduQWLlQXjaRc2zTTHbdJz+zNPvGFH5HdwpY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=exW/Xn8AlsVB2wKIewQZaIvddgGz5I5ldxrVfzyccMbLth2ILdTB6vHN7SFqB1O3Unp/HCtlKyWrWQfYIROeqP/kTnW91l5M+rRJEy0qf4G7aSidk5Kj7omL7Qlq9Dc58HPGxne4vBOJM7g1kp+JaG/kfLZJHJLFGZ96E7vrPiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IzbCYsIX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gAPbgGe5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PBf/7pnD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mms74Du7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IzbCYsIX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gAPbgGe5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PBf/7pnD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mms74Du7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EA5191F452;
	Wed, 16 Apr 2025 07:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1744789152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DD5vzgyhhT72ybxh4thHEx2a8P/tKeYXtXs32sG2X/4=;
	b=IzbCYsIXSvz6FDIjIKq29dVfgRj7O1xvL1BvhTi2mM0ekb/cf5/ETO5inB/qXePOZMmDxn
	BmafQ9MqmkF+pkuDzOS4cqRhqx2kkDYsfLjnndmEcStrAOoctdxUniZYWkQE2To+6KvVwy
	fxtVrysulh1PrX3XR1KDlajpV0F7CS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1744789152;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DD5vzgyhhT72ybxh4thHEx2a8P/tKeYXtXs32sG2X/4=;
	b=gAPbgGe5trlCSWwjhMemFrepFiBMU3BgkJm8beL5CdXEmjpUtHWqvLa31hULixo+7l9t2R
	aeJIhZal0t64BJCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1744789151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DD5vzgyhhT72ybxh4thHEx2a8P/tKeYXtXs32sG2X/4=;
	b=PBf/7pnDI9kEMcHEQOrmp25DtGPp/uHua8O2vZoQDLLe+wFjlLvrsedU40ETobzk/TZh4b
	rZHQjLtE3r2PjzmMztcqf4fJV2hVCvMd5GBF0SJRLQq7ZfQ3eXWvzYGqiiFJeLROa58UtB
	I7sNftiUswVfOtZBPVcOFFSv2wbERPw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1744789151;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DD5vzgyhhT72ybxh4thHEx2a8P/tKeYXtXs32sG2X/4=;
	b=mms74Du7DZNBGJItX32laOut6wSEhfUv8ekA3piyoH/OqyzJZZ5iOWAhabg/EW7skvJHHd
	pC+qceCOpcd1mdBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8DB8B13976;
	Wed, 16 Apr 2025 07:39:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tGYaIZ9e/2cYUAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 16 Apr 2025 07:39:11 +0000
Message-ID: <7455bff3-97f6-4156-87e0-197f2d3d8350@suse.de>
Date: Wed, 16 Apr 2025 09:39:11 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi: core: Implement reserved command handling
To: John Garry <john.g.garry@oracle.com>, Bart Van Assche
 <bvanassche@acm.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-5-bvanassche@acm.org>
 <3c2fe290-5e24-4985-833c-24d8b80b98b7@oracle.com>
 <e1cc3f08-e7e0-4eea-82a8-c5d2e7618238@acm.org>
 <bff407bb-ed99-42b1-bfc8-05b8aa76957c@oracle.com>
 <27e5c0e9-a042-45e3-9852-31adb966b781@acm.org>
 <d6b35769-e5f7-4174-b581-f6555aec1d4e@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <d6b35769-e5f7-4174-b581-f6555aec1d4e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 4/16/25 09:16, John Garry wrote:
> On 15/04/2025 18:21, Bart Van Assche wrote:
>> Using blk_mq_tag_to_rq() to translate a tag of a reserved
>> request into a request pointer only works after the block layer has
>> set tags->rqs[tag_of_reserved_request] first. That pointer is set by
>> blk_mq_get_driver_tag(). blk_mq_get_driver_tag() is called by the
>> block layer code that submits a request to a block driver. Hence, to
>> ensure that blk_mq_get_driver_tag() is called for reserved requests
>> the reserved requests would have to pass through scsi_queue_rq().
> 
> Ah, yes, we had the same discussion when trying to implement SCSI 
> reserved commands previously.
> 
>> For reserved requests sdev == NULL as explained in a previous email.
> 
> which mail exactly? I could not see any specific mention in this thread.
> 
>> There are many statements in the SCSI command submission and completion
>> path in which it is assumed that sdev != NULL. I don't think that the
>> SCSI maintainer (Martin) would agree with adding "if (sdev)" statements
>> in many places in the SCSI core.
> 
> Sure, so, IIRC, Hannes solved this by using a shost sdev in https:// 
> lore.kernel.org/linux-scsi/20211125151048.103910-2-hare@suse.de/
> 
>>
>> Letting UFS reserved requests being processed by another function than
>> scsi_queue_rq() doesn't seem feasible to me either.
> 
> JFYI, I was working on another solution (different to Hannes') which 
> allows reserved requests pass through scsi_queue_rq(), but I stopped 
> that work when I changed employer.
> 
Oh, really?
Do you have the patchset still around?
I'd be very much interested in that...

>> Although it is easy
>> to create an additional request queue for reserved requests, that
>> request queue shares its tag set with the SCSI host and hence also the
>> request submission function. From scsi_host.h:
>>
>> struct Scsi_Host {
>>      struct blk_mq_tag_set    tag_set;
>>      [ ... ]
>> };
>>
>>  From blk-mq.h:
>>
>> struct blk_mq_tag_set {
>>      const struct blk_mq_ops    *ops;
>>      [ ... ]
>> };
>>
>> Unless someone comes up with an elegant proposal, I will keep the
>> approach where ufshcd_tag_to_cmd() handles reserved tags and regular
>> tags differently.
>>
>> It should be possible to do this without referencing tags->static_rqs[]
>> directly from the UFS driver.
> 
> I'm not sure how that will look, but my preference is to fully implement 
> reserved tags support which can be used by all SCSI LLDs.
> 
Sure, that was my goal, too.
But then I got stuck as some drivers (most notably aacraid) use internal
commands to detect the hardware and allocate SCSI devices, so with my
approach we need a 'fake' SCSI device for the host to handle that.
If you have other ideas I'd be very interested in thems.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
