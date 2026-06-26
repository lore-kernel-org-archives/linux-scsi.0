Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA673F8224
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 14:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782484292; cv=none; b=hld3uCTSRwIREGa2gv50kIPsCDFaIMf3G12X7Ay4PlY8We6TxiB3k9W3tMfQ2uX/CHQXP2I1UdEmgeJxpKOUwEXH3cv3jzNK89vgr5CQUJeegvZYHiwwLK3Ebs3cSXCd4yfiwb7NnnwpKEEssUiehmwRaKPvKIStmzgLUN4prRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782484292; c=relaxed/simple;
	bh=Jjhtt4Civ5mxm/q8IHc5Tn/SkYOo4+KodbBoTOhmnzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZH6IoKrFAmNJOkhSkj1fMASwrGWIhVHGVLNMV1cMJsRPJ4lyIp3/pyfFCZHrzhlmmhJNxoQHERg2cF4F9XB/uV2YIY+neAiWaP2E2ffqWkYebJCVW/dJl3aD3YrgvFO4Y/jIndPGthpQgIHOreGA990FvNX4Lez+aVzvtvNgeZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cCgWErvm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Tz0EClAt; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cCgWErvm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Tz0EClAt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cCgWErvm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Tz0EClAt";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cCgWErvm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Tz0EClAt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 234F571D2D;
	Fri, 26 Jun 2026 14:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782484284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wMP52Xk5ziVxy1QmjIxQbaxuNEmK6lipIV5YgB5F6L8=;
	b=cCgWErvmTb+K8EcEwcojbUquo4AMk/voHRyOA/N3lBCDFawNkYCqfZZglzIS128iDk6PM8
	ksiT0s0zHpKxSdmcvRSH4kvKYQTd2Wd4evSCK+cwO4wcMakwyCTqH4lcj9Hpt9q3uojJEY
	3PcaW2DEdn98ZoKWZiWCFiu6ebqSnTE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782484284;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wMP52Xk5ziVxy1QmjIxQbaxuNEmK6lipIV5YgB5F6L8=;
	b=Tz0EClAtIYlNEvYHWEBHIguKckZ3u7MXCrQOlSli+qd++k1W/ptOHLF+Lrk71w5HZOcJ9l
	PbP6gP5/fI3+r6BA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cCgWErvm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Tz0EClAt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782484284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wMP52Xk5ziVxy1QmjIxQbaxuNEmK6lipIV5YgB5F6L8=;
	b=cCgWErvmTb+K8EcEwcojbUquo4AMk/voHRyOA/N3lBCDFawNkYCqfZZglzIS128iDk6PM8
	ksiT0s0zHpKxSdmcvRSH4kvKYQTd2Wd4evSCK+cwO4wcMakwyCTqH4lcj9Hpt9q3uojJEY
	3PcaW2DEdn98ZoKWZiWCFiu6ebqSnTE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782484284;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wMP52Xk5ziVxy1QmjIxQbaxuNEmK6lipIV5YgB5F6L8=;
	b=Tz0EClAtIYlNEvYHWEBHIguKckZ3u7MXCrQOlSli+qd++k1W/ptOHLF+Lrk71w5HZOcJ9l
	PbP6gP5/fI3+r6BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC5BC779A8;
	Fri, 26 Jun 2026 14:31:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Qh3zNzuNPmq+agAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 26 Jun 2026 14:31:23 +0000
Message-ID: <72571248-e1a4-4350-b1f8-f8123d627f99@suse.de>
Date: Fri, 26 Jun 2026 16:31:23 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
To: Bart Van Assche <bvanassche@acm.org>, Brian Bunker <brian@purestorage.com>
Cc: linux-scsi@vger.kernel.org, krishna.kant@purestorage.com
References: <cc6d3238-5574-4a0a-ba3a-2660687ec292@acm.org>
 <20260501221153.90440-1-brian@purestorage.com>
 <5de0e746-1a90-4a41-a36b-e56a4fcfeee6@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <5de0e746-1a90-4a41-a36b-e56a4fcfeee6@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 234F571D2D
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 5/2/26 18:37, Bart Van Assche wrote:
> On 5/1/26 3:11 PM, Brian Bunker wrote:
>>> +    sdev->vendor = (char *)(sdev->inquiry + 8);
>>> +    sdev->model = (char *)(sdev->inquiry + 16);
>>> +    sdev->rev = (char *)(sdev->inquiry + 32);
>>>
>>> I really hate these.
>>> Can't we replace them with accessor functions and drop the pointers?
> 
> Hannes, what type of accessor functions do you have in mind? I don't
> like accessor functions that only do half of the job (returning the
> start pointer but not the length). Or are you perhaps suggesting to
> define accessor functions that return a struct with both the start
> pointer and the length, something that is uncommon in the Linux kernel?
> 
> Another possibility is to change sdev->vendor, sdev->model and
> sdev->rev from pointers to fixed size strings into '\0'-terminated char
> arrays.
> 
Well, the strings in the INQUIRY are pretty well defined, and we know 
exactly which fields they cover in the inquiry data.
Copying them them out leads to quite some churn (and additional 
allocations for storing them) with no real gain.
So for sysfs we can define accesors which copy the data out into the
sysfs buffer, and for comparison we can have accessors 
'scsi_inq_model_cmp()' or something which compare the input string
against the data in the inquiry via memcmp().

No need in copying out data methinks.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
