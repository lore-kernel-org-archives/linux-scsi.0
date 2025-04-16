Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5A2227E95
	for <linux-scsi@vger.kernel.org>; Wed, 16 Apr 2025 07:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744788845; cv=none; b=PdDQOad2K4578ojPz3ToC3mKRUT3qSYzAuhEJamIZB4VKklrAgIpsaC45vUhmQA35jux6HYlc6vJCK8vVelkTxyagG0xqSLntKULQmJ6bMnNOEpxvvX9xmgtrj1kSrxli6v8xPN54SwXrSei7lfEPcx7DE7Euc/iUunwyyuiME4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744788845; c=relaxed/simple;
	bh=vVzSi6Y8lv8AdbczLvEh4cd+SQttq8peY1cK3MWOajg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eujrIksQM3u31tH7ZbbCRF7A8C27YrcwLzI1+baCkiHYAD4rNnONZciDqMVZMc0qSgcEpqToQiYtcCNRjqfP1Yw6C/iiwDh1eu4wfdPoejqNtfzqi6PILSigVFc2fE+DQZyZVHfyZtiGZQy/fTNDXvz9/UNykhlqJLxDLl43nWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TVSkguqq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5E/5fws4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TVSkguqq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5E/5fws4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TVSkguqq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5E/5fws4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TVSkguqq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5E/5fws4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C82DD1F445;
	Wed, 16 Apr 2025 07:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1744788841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vchzjNmvNT5lEPN5O5/OVE9ZGDaCU3BLNGKUcUAkl/M=;
	b=TVSkguqqHTtHM7T7oCZV/uDyMukdlwNcnFfi7ljtF8pfnUDRToiASDvV7kjJA1RhNcBfBN
	pNe/SL9VBryr6iOeG0zN2KHeno+RDEZUg76+vUiaViXw2OeqhntPwoLu+C78piyUTVQahs
	vhX2mHkGaWfhWy09tTAaduUmS5ouQBM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1744788841;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vchzjNmvNT5lEPN5O5/OVE9ZGDaCU3BLNGKUcUAkl/M=;
	b=5E/5fws4XPmqV4Q7whLXguLdPAVT2lNW1KuDCmKZSYzKRqVUty4WF3hjqgZUKu4Xls1hLH
	rn8qegm+AHN1kQAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1744788841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vchzjNmvNT5lEPN5O5/OVE9ZGDaCU3BLNGKUcUAkl/M=;
	b=TVSkguqqHTtHM7T7oCZV/uDyMukdlwNcnFfi7ljtF8pfnUDRToiASDvV7kjJA1RhNcBfBN
	pNe/SL9VBryr6iOeG0zN2KHeno+RDEZUg76+vUiaViXw2OeqhntPwoLu+C78piyUTVQahs
	vhX2mHkGaWfhWy09tTAaduUmS5ouQBM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1744788841;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vchzjNmvNT5lEPN5O5/OVE9ZGDaCU3BLNGKUcUAkl/M=;
	b=5E/5fws4XPmqV4Q7whLXguLdPAVT2lNW1KuDCmKZSYzKRqVUty4WF3hjqgZUKu4Xls1hLH
	rn8qegm+AHN1kQAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7F4AB13976;
	Wed, 16 Apr 2025 07:34:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eQQSHWld/2ePTgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 16 Apr 2025 07:34:01 +0000
Message-ID: <74679b46-a823-426e-9406-29ce7b5807ed@suse.de>
Date: Wed, 16 Apr 2025 09:33:52 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi: core: Implement reserved command handling
To: Bart Van Assche <bvanassche@acm.org>, John Garry
 <john.g.garry@oracle.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-5-bvanassche@acm.org>
 <3c2fe290-5e24-4985-833c-24d8b80b98b7@oracle.com>
 <e1cc3f08-e7e0-4eea-82a8-c5d2e7618238@acm.org>
 <bff407bb-ed99-42b1-bfc8-05b8aa76957c@oracle.com>
 <27e5c0e9-a042-45e3-9852-31adb966b781@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <27e5c0e9-a042-45e3-9852-31adb966b781@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 4/15/25 19:21, Bart Van Assche wrote:
> 
> On 4/4/25 10:34 AM, John Garry wrote:
>> Now I see this in 23/24:
>>
>> +/*
>> + * Convert a block layer tag into a SCSI command pointer. This 
>> function is
>> + * called once per I/O completion path and is also called from error 
>> paths.
>> + */
>> +static inline struct scsi_cmnd *ufshcd_tag_to_cmd(struct ufs_hba 
>> *hba, u32 tag)
>> +{
>> +    struct blk_mq_tags *tags = hba->host->tag_set.tags[0];
>> +    struct request *rq;
>> +
>> +    /*
>> +     * Use .static_rqs[] for reserved commands because blk_mq_get_tag()
>> +     * is not called for reserved commands by the UFS driver.
>> +     */
>> +    rq = tag < UFSHCD_NUM_RESERVED ? tags->static_rqs[tag] :
>> +                     blk_mq_tag_to_rq(tags, tag);
>> +
>> +    if (WARN_ON_ONCE(!rq))
>> +        return NULL;
>> +
>> +    return blk_mq_rq_to_pdu(rq);
>> +}
>> +
>>
>> Do you really think that it is ok that anything outside the block 
>> layer should be referencing tags->static_rqs[] directly?
>>
>> Even using blk_mq_alloc_request() would seem better than that.
> 
> Hi John,
> 
> Using blk_mq_tag_to_rq() to translate a tag of a reserved
> request into a request pointer only works after the block layer has
> set tags->rqs[tag_of_reserved_request] first. That pointer is set by
> blk_mq_get_driver_tag(). blk_mq_get_driver_tag() is called by the
> block layer code that submits a request to a block driver. Hence, to
> ensure that blk_mq_get_driver_tag() is called for reserved requests
> the reserved requests would have to pass through scsi_queue_rq().
> For reserved requests sdev == NULL as explained in a previous email.
> There are many statements in the SCSI command submission and completion
> path in which it is assumed that sdev != NULL. I don't think that the
> SCSI maintainer (Martin) would agree with adding "if (sdev)" statements
> in many places in the SCSI core.
> 
> Letting UFS reserved requests being processed by another function than
> scsi_queue_rq() doesn't seem feasible to me either. Although it is easy
> to create an additional request queue for reserved requests, that
> request queue shares its tag set with the SCSI host and hence also the
> request submission function. From scsi_host.h:
> 

As rightly noted, we need an sdev to use the reserved command handling
trick. There are two choices:
-> use the existing sdev for per-LUN TMFs. If the driver only uses
    ABORT TASK/ABORT TASK_SET/RESET LUN we already know which sdev to
    use, so that is easy.
-> allocate a 'fake' scsi device for the host. Not pretty, but gives
    us a nice combined interface to deal with reserved commands.

Bart, from my reading the UFS driver only requires a TMF for command
abort and device reset, in both cases we should have a scsi device
available. Can't you use that?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
