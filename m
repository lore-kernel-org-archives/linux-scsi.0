Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8F12BEC22
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 11:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755690066; cv=none; b=u4AZOUNyd7GP3gj64aQNSfo9SF4ywxeCHWvLjn017CmaQpgABeBtu/lrDcIMSR05PFqfz6HlTRbXbN5RWcxdCA8adfHIGkd59Pv4Ecrj+0z3F9mE1U3bS9I8aBfSLl5j+lwbNUMFbYNbXUrrFeHLhbQSsGcPyY2LNt7mOh/Rhx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755690066; c=relaxed/simple;
	bh=n78Qt6niGugsoWMU6OJjFCTSTr/iEBZlPe8KT5f6dJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=akEdjRFY87xSg30xyTAfQ9nZwA/FOT+NNN2qZ2uV2zBg6YGbFuf/zf35GJTsk2TnWO84w8fhUwpaUic2BlBj3hW/rJBEkMDZ0dQlRVx7rBTXPOvdznGQ3M45Bd9JGEDnXlSS5vR3Upc+WTOxvsH9tOs33FyvlZCUc3GPNpMvKJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TTqy7+9o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tLodCr7L; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TTqy7+9o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tLodCr7L; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TTqy7+9o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tLodCr7L";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TTqy7+9o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tLodCr7L"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 49ADB1FDFE;
	Wed, 20 Aug 2025 11:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755690063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWxJB0bvPFYroHVxVeatfbBKKRE0xbAgyFu2gmKAOCc=;
	b=TTqy7+9oWwAA2EcQ4S8zZ459l7m8AvOR9yDwKQAwq/50K8VDoYPnBZtDYZ/OYQJPMqv8US
	Pg/PEKNlrW3WavryHu7GSWQDWM2eKchEhxgQs++sFnW6ook0OhFdXC92t8OMzK+5C6zCYX
	lqnDmFGJa7CCMzAdembjitBNieww+9o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755690063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWxJB0bvPFYroHVxVeatfbBKKRE0xbAgyFu2gmKAOCc=;
	b=tLodCr7L6rlezeP1Yi+lpp8CYuxN9+xgg4ajnL6ZTOU8GZai1oSJLZ5czVrhHckPtdyLqd
	22dcO0ye2RF2SjAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TTqy7+9o;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tLodCr7L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755690063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWxJB0bvPFYroHVxVeatfbBKKRE0xbAgyFu2gmKAOCc=;
	b=TTqy7+9oWwAA2EcQ4S8zZ459l7m8AvOR9yDwKQAwq/50K8VDoYPnBZtDYZ/OYQJPMqv8US
	Pg/PEKNlrW3WavryHu7GSWQDWM2eKchEhxgQs++sFnW6ook0OhFdXC92t8OMzK+5C6zCYX
	lqnDmFGJa7CCMzAdembjitBNieww+9o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755690063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWxJB0bvPFYroHVxVeatfbBKKRE0xbAgyFu2gmKAOCc=;
	b=tLodCr7L6rlezeP1Yi+lpp8CYuxN9+xgg4ajnL6ZTOU8GZai1oSJLZ5czVrhHckPtdyLqd
	22dcO0ye2RF2SjAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 322C91368B;
	Wed, 20 Aug 2025 11:41:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lBLAC0+0pWiZJwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 20 Aug 2025 11:41:03 +0000
Message-ID: <c42bf1af-40f2-4cd9-8ecf-5b522debcf3f@suse.de>
Date: Wed, 20 Aug 2025 13:41:02 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/8] scsi: sd: Avoid passing potentially uninitialized
 "sense_valid" to read_capacity_error()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-5-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250815211525.1524254-5-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 49ADB1FDFE
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 8/15/25 23:15, Ewan D. Milne wrote:
> read_capacity_10() sets "sense_valid" in a different conditional statement prior to
> calling read_capacity_error(), and does not use this value otherwise.  Move the call
> to scsi_sense_valid() to read_capacity_error() instead of passing it as a parameter
> from read_capacity_16() and read_capacity_10().
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/sd.c | 12 +++++-------
>   1 file changed, 5 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
