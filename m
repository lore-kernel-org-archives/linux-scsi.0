Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565133ED5A6
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 06:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781591714; cv=none; b=g2DZcPK+XR1iSImGXK0AqlmUBjd2ec4tLIEVpSl49ll7eNQ/LBmRUB3PJMiMGmfRA+urWKr+O7RHCtBlpC3b5aIScAxozmvueTjsAK21fyocaShoh+bM+ckgv3s/KkIENVKqBldh1j8X52a6mTQao6nYlA3ZcnNnFCVJYnnJEY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781591714; c=relaxed/simple;
	bh=h5V+SCmh41SkWZ1T0iz55eTpdbnmmPgYEFzQJBVb0/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c12gkfYijCRCh+FmsuGOThIwpTsvF3LsTvmDi5Ww9NGS8HdrqwPZVqDDjXAZHwkAE/0/t2iXa+wtTTyclSoIpFBZnr7H89quwC4J18mpNGEBJd+nVEUBVBBoBW4aMjTX6Ejb3+6IGRBSDnvrZQuGiWQKr6rUjTKfh9aAEgZ+Gic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OIFm6QOm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=43mPn2lg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OIFm6QOm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=43mPn2lg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OIFm6QOm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="43mPn2lg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OIFm6QOm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="43mPn2lg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1A1856CAD2;
	Tue, 16 Jun 2026 06:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781591709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ss8Hg/Aue7pHVBH8k/kbDY7aRINSBEwMDZbP5djrYfE=;
	b=OIFm6QOmrB4HxvGbAKcQgMvLk6qAX7DELTvsMkHF/xDd+nnT2O084msYUax06x5JnkfQ9b
	Dhdrbk6Ph12qkp58W02XjF70CE0sK6oMZ59UQqHaDiqehVbw6br9cdIFQxm0uNXYFk/Me7
	PKplxrMcx3ERdov/FnSlETkPDcvuyaA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781591709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ss8Hg/Aue7pHVBH8k/kbDY7aRINSBEwMDZbP5djrYfE=;
	b=43mPn2lgPV6QN1F/+LwqAWe4s/uydnywoLMRkRCKz1HoMSc5xzVf5Fuaq22pP9o/JdPecM
	98y8XlCTWvfT0oDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OIFm6QOm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=43mPn2lg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781591709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ss8Hg/Aue7pHVBH8k/kbDY7aRINSBEwMDZbP5djrYfE=;
	b=OIFm6QOmrB4HxvGbAKcQgMvLk6qAX7DELTvsMkHF/xDd+nnT2O084msYUax06x5JnkfQ9b
	Dhdrbk6Ph12qkp58W02XjF70CE0sK6oMZ59UQqHaDiqehVbw6br9cdIFQxm0uNXYFk/Me7
	PKplxrMcx3ERdov/FnSlETkPDcvuyaA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781591709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ss8Hg/Aue7pHVBH8k/kbDY7aRINSBEwMDZbP5djrYfE=;
	b=43mPn2lgPV6QN1F/+LwqAWe4s/uydnywoLMRkRCKz1HoMSc5xzVf5Fuaq22pP9o/JdPecM
	98y8XlCTWvfT0oDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DAE43779A8;
	Tue, 16 Jun 2026 06:35:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bbsVM5zuMGr1CQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 16 Jun 2026 06:35:08 +0000
Message-ID: <2ea70ada-04d5-4137-93a7-f2c4972905c7@suse.de>
Date: Tue, 16 Jun 2026 08:35:08 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] scsi: core: Add scsi_update_inquiry_data() for
 updating INQUIRY data
To: Brian Bunker <brian@purestorage.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, bvanassche@acm.org, krishna.kant@purestorage.com
References: <f08a3641-3ff9-4a80-bd20-adc52d802de7@suse.de>
 <20260603011819.74466-1-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260603011819.74466-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1A1856CAD2
X-Spam-Score: -4.51

On 6/3/26 03:18, Brian Bunker wrote:
> On 6/1/26 08:44, Hannes Reinecke wrote:
>> Hmm. Wouldn't it be simpler to do a memcmp() on the standard inquiry
>> data? Surely we should reprobe if the model and/or vendor name changed, no?
> 
> The function already updates vendor, model, revision, and all other
> INQUIRY-derived fields unconditionally before the reprobe check -- so
> those values are always current regardless of what the reprobe decision
> is. The question the reprobe check answers is not "did any data change?"
> but "does the driver attachment need to be reconsidered?"
> 
> device_reprobe() tears down and rebinds the driver. The two things that
> determine driver binding are:
> 
>    - type (byte 0 bits 4:0): selects which upper-layer driver handles the
>      device -- sd for TYPE_DISK, st for TYPE_TAPE, sr for TYPE_ROM, etc.
> 
>    - peripheral qualifier (byte 0 bits 7:5): scsi_bus_match() only matches
>      PQ == 0, so a PQ change directly affects whether any driver attaches
>      at all. This is the key field for ALUA unavailable state handling.
> 
> A vendor or model string change does not affect either of these. Triggering
> device_reprobe() for such a change would mean dropping the device lock,
> calling device_reprobe(), and re-acquiring the lock -- for no reason, since
> the same driver would simply re-bind to the same device. That sequence
> should only be performed when the driver binding actually needs to change.
> 
> Checking only type and PQ triggers reprobe exactly when it is needed and
> not otherwise.
> 
Fair enough.

You can add

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
