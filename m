Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0042230BFA
	for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2025 16:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741625060; cv=none; b=sdIxst6jT2efwcfIIWYjZraS5/6FJHkHQORwcCjS50w8n0OumYPRxPQkeMdSlr+9W8wsxeC+XhY9cDRFTS+AZXcDDsuw9spS//leRUQzpEXUEK8sdfu6F2FCEPCbHE0qBfpxMwjeM1JDBwp4lKlLYOR7yrMl+ZG5r57WqQ2cDas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741625060; c=relaxed/simple;
	bh=+C+nWV47gMnN+GmO6OhOJjYj8TMmHT7VYGOfjHzg+DA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XRm9/0fKQBbh/pZL0z/o6mE0bmiu0AnFa2+vSezUc3Co4bM6ahyoCbZKt4bShGKddH3RQ6+fpZb6uh/0/t42hKrp3e5BJcADZ2OHwkUSQVPqXhOgtuJv3JO07yOgcq6vlhYUyN0J4ZLpweG68obzcx5EUzAs0CBfzkai7prij6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XI2/wC6g; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dTDSWnul; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z+wxM9f7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7H/R14jO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XI2/wC6g";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dTDSWnul";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z+wxM9f7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7H/R14jO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D6B151F38A;
	Mon, 10 Mar 2025 16:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741625056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qSCxRdZILacPnUxsUkM58MBysD03sGEVGK+QPA3sU+k=;
	b=XI2/wC6gxqJe1ld22mOkpmyMRc2np3ZfPtWM+UyUzz+pC9ldsFvzyREwrTcZJYv0SkR3a5
	8bpzMNra9w3WfJE5sfqBEa2JxKfXpva3hhtV8vzcZ2Z1kwwRNnAsRFEm08B2iSDbyGZY6n
	e/+NA8j7HXeA9DV0qFhKGyJZnjOIoAM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741625056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qSCxRdZILacPnUxsUkM58MBysD03sGEVGK+QPA3sU+k=;
	b=dTDSWnulrYXnobksZGcj9EfaCDWuNDEisi8GbQKkIBgGUg5hIfc7WxRC/T2kLKoeU3aB/q
	b487Fztfue1WgOCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741625055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qSCxRdZILacPnUxsUkM58MBysD03sGEVGK+QPA3sU+k=;
	b=z+wxM9f7dmxRZ1VUdM18RG4yKF4M90YrTyowqcaCXnGag44Vp+Fp/aFire3ixpu6vv4ZRI
	DWTzBfioV2Ra0Ssme6Wf9AW6YZP7js4p6MLTCrIQEqyHmEJgFr66L6e8ZAHYJWpYgBiRxp
	vQf6S10SfxpzfFxqadwhRBgM0VL+OCg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741625055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qSCxRdZILacPnUxsUkM58MBysD03sGEVGK+QPA3sU+k=;
	b=7H/R14jO/G8rJRhcxytLDgT7ZRRLcbEeBsmKtAc0ge+kxEmrisL7V4oRv6P0K6Is407sb8
	IZ5Xd9MmgAsO4TCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D097139E7;
	Mon, 10 Mar 2025 16:44:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MOEIFd8Wz2fPYwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 10 Mar 2025 16:44:15 +0000
Message-ID: <84a87c16-0738-460d-b83f-55f8181d536e@suse.de>
Date: Mon, 10 Mar 2025 17:44:14 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
To: John Meneghini <jmeneghi@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 pheidologeton@protonmail.com, kernel@roadkil.net, maokaman@gmail.com
Cc: Sagar.Biradar@microchip.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, thenzl@redhat.com, mpatalan@redhat.com,
 Scott.Benesh@microchip.com, Don.Brace@microchip.com,
 Tom.White@microchip.com, Abhinav.Kuchibhotla@microchip.com
References: <20250130173314.608836-1-sagar.biradar@microchip.com>
 <yq1mseqwoaa.fsf@ca-mkp.ca.oracle.com>
 <PH7PR11MB757026166DDB8068830AE420FAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
 <8433b8b8-bb9a-43e0-a760-d8745d28d0d9@redhat.com>
 <yq1eczsjaaz.fsf@ca-mkp.ca.oracle.com>
 <2eca14e0-3978-440f-a4a4-32c9c61baad4@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <2eca14e0-3978-440f-a4a4-32c9c61baad4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[redhat.com,oracle.com,protonmail.com,roadkil.net,gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,protonmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 2/24/25 22:15, John Meneghini wrote:
> On 2/20/25 9:38 PM, Martin K. Petersen wrote:
>>
>> John,
>>
>>> However, I agree it would be better to just fix the driver,
>>> performance impact notwithstanding, and ship it. For my part I'd
>>> rather have a correctly functioning driver, that's slower, but doesn't
>>> panic.
>>
>> I prefer to have a driver that doesn't panic when the user performs a
>> reasonably normal administrative action.
> 
> Agreed. The only clarification I want to make is that users will
> not see a panic, they will see IO timeouts and Host bus resets.
> It was my mistake to report earlier that the host would panic.
> 
> When aac_cpu_offline_feature is disabled users will see higher performance
> but if they start off-lining CPUS they may see IO timeouts.  This is the
> state of the current driver and this is the problem which the original 
> patch:
> commit 9dc704dcc09e ("scsi: aacraid: Reply queue mapping to CPUs based 
> on IRQ affinity")
> was supposed to have fixed. The problem was the original patch didn't 
> fix the
> problem correctly and it resulted in the regression reported in Bugzilla 
> 217599[1].
> 
> This patch circles back and fixes the original problem correctly. The extra
> 'aac_cpu_offline_feature' modparam was added to disable the new code path
> because of concerns raised during our testing at Red Hat about reduced
> performance with this patch.
> 
>> If go-faster stripes are desired in specific configurations, then make
>> the performance mode an opt-in. Based on your benchmarks, however, I'm
>> not entirely convinced it's worth it...
> 
> I agree.  So how about if we can just take out the 
> aac_cpu_offline_feature modparam...?
> 
> Alternatively we can replace the modparam with a kConfig option. The 
> default setting for the new Kconfig option will be offline_cpu_support_on and 
> performance_mode_off. That way we can ship a default kernel configuration that
 > provides a working aacraid driver which safely supports off-lining
 > CPUS. If people are really unhappy with the performance, and they> 
don't care about offline cpu support, they can re-config their kernel.
> 
> Personally I prefer option 1, but we the thoughts of the upstream users.
> 
> I've added the original authors of Bugzilla 217599[1] to the cc list to
> get their attention and review.
> 
Do we have an idea what these 'specific use-cases' are?
And how much performance impact we have?
I could imagine a single-threaded workload driving just one blk-mq queue 
would benefit from spreading out onto several interrupts.

But then, this would be true for most of the multiqueue drivers; and 
indeed quite some drivers (eg megaraid_sas & mpt3sas 
'smp_affinity_enable') have the very same module option.
Wouldn't it be an idea to check if we can make this a generic / blk-mq
queue option instead of having each driver to implement the same 
functionality on it's own?

Topic for LSF?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
