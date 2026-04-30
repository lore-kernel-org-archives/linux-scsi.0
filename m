Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F0A6FC5
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 06:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777529033; cv=none; b=o2Zdl6akRaQ8jfxHF6e8BkC3iQmpYDHA51O3EiXcRRIRWgeIiEXCWYfo16oPIkXw0zxiMf49mgOOh/jJYL1x6JBIxT/IscDSI6MV3OryM0iG/UHrjdGbf9HAV18TxtR35UZTp4lVgfiNSnFBR4SENvp+sN79IcLhmzNszsCtx24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777529033; c=relaxed/simple;
	bh=NjZOvUVQaFV6JGASrP0RHlWe+htX6LeEnb3j8rv3ScU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RxGeqnKyN+Vuug7nX7LD1VriINrbiSyVOo/5q9Yp7NfHfDud+vscF7F2/xtuXrx88nFNygAcazNOboaChT8V8V3rLX4mgWOHhz+aqnfuYNbBnwGL7Tt0PvGfRAWmQMsFAMZI1eq05UBhHwF1irMC3naF/2vQU9fqcu6+vUPcwu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qa5UOzKg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kASyvY/7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qa5UOzKg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kASyvY/7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qa5UOzKg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kASyvY/7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qa5UOzKg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kASyvY/7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1B5495BD62;
	Thu, 30 Apr 2026 06:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777529030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mb/QJT0q/fRhZHEem7JKhx1qS0CV1CZ/AGXR8bC3rmQ=;
	b=Qa5UOzKgoLCQF+n7xIuUloqXX0svhAIllryXUdyq2oXZbrVxnNENiL4x/lUYo+qNuBVcak
	ELeDNVdod5YAYt196qL1RwmAK4ZP4uBAJO/jeTBbrxj9r/alz4tL29fuhyPQ+dgBZRcwHw
	MaNAG4jY/I1S2xUEA7MRSqBReLZr2tI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777529030;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mb/QJT0q/fRhZHEem7JKhx1qS0CV1CZ/AGXR8bC3rmQ=;
	b=kASyvY/78bZwBzwI+I3sZ2XKw0p/wQUXk9E0hTyGVaRXOB2MXdwd++I7cABCLGBWhRHjg1
	5zHxqBs38U5DqQDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Qa5UOzKg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="kASyvY/7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777529030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mb/QJT0q/fRhZHEem7JKhx1qS0CV1CZ/AGXR8bC3rmQ=;
	b=Qa5UOzKgoLCQF+n7xIuUloqXX0svhAIllryXUdyq2oXZbrVxnNENiL4x/lUYo+qNuBVcak
	ELeDNVdod5YAYt196qL1RwmAK4ZP4uBAJO/jeTBbrxj9r/alz4tL29fuhyPQ+dgBZRcwHw
	MaNAG4jY/I1S2xUEA7MRSqBReLZr2tI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777529030;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mb/QJT0q/fRhZHEem7JKhx1qS0CV1CZ/AGXR8bC3rmQ=;
	b=kASyvY/78bZwBzwI+I3sZ2XKw0p/wQUXk9E0hTyGVaRXOB2MXdwd++I7cABCLGBWhRHjg1
	5zHxqBs38U5DqQDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E7FF6593B0;
	Thu, 30 Apr 2026 06:03:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /Po0N8Xw8mmjdAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 30 Apr 2026 06:03:49 +0000
Message-ID: <ec3f30b2-74ed-4896-98b9-29ee527f9c0d@suse.de>
Date: Thu, 30 Apr 2026 08:03:49 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: dlemoal@kernel.org, bvanassche@acm.org,
 Krishna Kant <krishna.kant@purestorage.com>
References: <20260429012733.40855-1-brian@purestorage.com>
 <20260429224939.77082-1-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260429224939.77082-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,purestorage.com:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1B5495BD62

On 4/30/26 00:49, Brian Bunker wrote:
> All INQUIRY-derived sysfs attributes (type, scsi_level, vendor, model,
> rev, cdl_supported, and the binary inquiry attribute) read data that
> can be updated during device rescan. These reads must be protected
> against concurrent updates.
> 
> Use the existing inquiry_mutex to protect access to these sysfs
> attributes. This ensures that userspace always sees consistent INQUIRY
> data, even if a rescan is updating the buffer concurrently.
> 
> Replace the sdev_rd_attr macro with two new helpers,
> sdev_rd_inquiry_attr_int and sdev_rd_inquiry_attr_str, which generate
> the show functions for INQUIRY-derived integer and string fields and
> take the inquiry_mutex around the field access.
> 
> This is preparatory work for adding INQUIRY data update support during
> device rescan operations.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> ---
> v3:
>    - Use sysfs_emit() instead of snprintf() in the new show functions.
>    - Use guard(mutex)() for scoped lock acquisition and drop the local
>      ret variable.
> 
> v2:
>    - Protect all INQUIRY-derived fields (type, scsi_level, cdl_supported),
>      not just the string fields (vendor, model, rev) and binary inquiry
>      attribute. If we accept that INQUIRY data can change, we cannot assume
>      which fields will change.
>    - Replace the sdev_rd_attr macro with sdev_rd_inquiry_attr_int and
>      sdev_rd_inquiry_attr_str helpers to avoid duplicating the lock/unlock
>      boilerplate across each show function.
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
