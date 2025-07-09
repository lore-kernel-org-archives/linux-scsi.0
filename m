Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5A9216E1B
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 17:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752083101; cv=none; b=qxGCTvKDnpWeAid901YwTF0wNPI5wdsiPGHLw7v2PMJIvVECzJ4DGnrRXPyUITGrrm6xXxxDDjj4FWta6xIAL6vFzb1P7mJDAdfEVua6ivhxAHza4y0kaPqFsvlMp84lG8GaV0B/PMVpag1BTjGxwJAkpULqIft0PuG8zVOlNAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752083101; c=relaxed/simple;
	bh=RniVufa2pE8YY46mdsTlchodYtQefRbjokqqMsR7PBI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k3BrcY0qH2pITx8naj4vaZMz5vA+V3aWZ97sd5ynkOzI/8lXKyUcEVRctplwiWYMAPyqNUhuiY6J66VvpOi0CtNnDSXuWw00BSRMod/n0mHryDMU7+QsGfnE4maXJqGOBMLgbnh3z4TjEAYYevj4e+fqx9Du11AazxQWD22e+Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Q5s4zw1g; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dIsT4hXs; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Q5s4zw1g; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dIsT4hXs; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Q5s4zw1g";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dIsT4hXs";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Q5s4zw1g";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dIsT4hXs"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 40D891F385;
	Wed,  9 Jul 2025 17:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752083097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOYZkJtIk+P2+lJbA7NB/MDU1Hut/dDgApiPUUwCrDg=;
	b=Q5s4zw1g7GCcd6sYjtyMtStt3R+ApStu/3ILX2GQvkEm4AGx2nacA/jYOugD0rhkbmiYYb
	wmquwBSJwZVxl5zizFT0D8OK//vMLPnqSR81iICahST3af9wyI2lj8Iyddu+cbYF9K7+YF
	l3KOM1abfM+eze4U3yhMTmjQL2012dY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752083097;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOYZkJtIk+P2+lJbA7NB/MDU1Hut/dDgApiPUUwCrDg=;
	b=dIsT4hXsiOlx31ai+wZTXBBLX5dPVAEZsN761W/itIpJdeK34Cu3dalByGn91QGj9qV0+l
	1oJRrfVR69yUq3Dw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Q5s4zw1g;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dIsT4hXs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752083097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOYZkJtIk+P2+lJbA7NB/MDU1Hut/dDgApiPUUwCrDg=;
	b=Q5s4zw1g7GCcd6sYjtyMtStt3R+ApStu/3ILX2GQvkEm4AGx2nacA/jYOugD0rhkbmiYYb
	wmquwBSJwZVxl5zizFT0D8OK//vMLPnqSR81iICahST3af9wyI2lj8Iyddu+cbYF9K7+YF
	l3KOM1abfM+eze4U3yhMTmjQL2012dY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752083097;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOYZkJtIk+P2+lJbA7NB/MDU1Hut/dDgApiPUUwCrDg=;
	b=dIsT4hXsiOlx31ai+wZTXBBLX5dPVAEZsN761W/itIpJdeK34Cu3dalByGn91QGj9qV0+l
	1oJRrfVR69yUq3Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5501136DC;
	Wed,  9 Jul 2025 17:44:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uJgdNpiqbmixLQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 09 Jul 2025 17:44:56 +0000
Message-ID: <fb150df4-d235-455b-8394-55b816c0e6ad@suse.de>
Date: Wed, 9 Jul 2025 19:44:56 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] nvme-fc: FPIN link integrity handling
To: Bryan Gurney <bgurney@redhat.com>
Cc: John Meneghini <jmeneghi@redhat.com>, linux-nvme@lists.infradead.org,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, axboe@kernel.dk,
 james.smart@broadcom.com, dick.kennedy@broadcom.com,
 linux-scsi@vger.kernel.org, njavali@marvell.com, muneendra737@gmail.com
References: <20250624202020.42612-1-bgurney@redhat.com>
 <CAHhmqcTO_Q59aDr3DywC-tPF=9pe3gxbyn6J4ycdf+eYEOayHQ@mail.gmail.com>
 <19484829-0a7b-42ce-99fe-e74ccda67dce@suse.de>
 <b0817e2a-1c4e-4d7d-9a84-633913d9e0e4@redhat.com>
 <0db83ea3-83aa-45ef-bafd-6b37da541d22@suse.de>
 <CAHhmqcTNrfjj-ABjTfj7LUCQ_qRtcTrZCzhtaERViaAQut3TUw@mail.gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAHhmqcTNrfjj-ABjTfj7LUCQ_qRtcTrZCzhtaERViaAQut3TUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
	RCPT_COUNT_TWELVE(0.00)[12];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,lists.infradead.org,kernel.org,lst.de,grimberg.me,kernel.dk,broadcom.com,vger.kernel.org,marvell.com,gmail.com];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 40D891F385
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 7/9/25 15:42, Bryan Gurney wrote:
> On Wed, Jul 9, 2025 at 2:21 AM Hannes Reinecke <hare@suse.de> wrote:
>>
[ .. ]
>>> This may be true with FPIN Congestion Signal, but we are testing Link
>>> Integrity.  With FPIN LI I think we want to simply stop using the path.
>>> LI has nothing to do with latency.  So unless ALL paths are marginal,
>>> the IO scheduler should not be using any marginal path.
>>>
>> For FPIN LI the paths should be marked as 'faulty', true.
>>
>>> Do we need another state here?  There is an ask to support FPIN CS, so
>>> maybe using the term "marginal" to describe LI is wrong.
>>>
>>> Maybe we need something like "marginal_li" and "marginal_cs" to describe
>>> the difference.
>>>
>> Really not so sure. I really wonder how a FPIN LI event reflect back on
>> the actual I/O. Will the I/O be aborted with an error? Or does the I/O
>> continue at a slower pace?
>> I would think the latter, and that's the design assumption for this
>> patchset. If it's the former and I/O is aborted with an error we are in
>> a similar situation like we have with a faulty cable, and we need
>> to come up with a different solution.
>>
> 
> During my testing, I was watching the logs on the test host as I was
> about to run the command on the switch to generate the FPIN LI event.
> I didn't see any I/O errors, and the I/O continued at the normally
> expected throughput and latency.  But "if this had been an actual
> emergency..." as the saying goes, there would probably be some kind of
> disruption that the event itself would be expected to cause (e.g.:
> "loss sync", "loss signal", "link failure"), but
> 
> There was a Storage Developer Conference 21 presentation slide deck on
> the FPIN LI events that's hosted on the SNIA website [1]; slide 4
> shows the problem statements addressed by the notifications.
> 
> In my previous career as a system administrator, I remember seeing
> strange performance slowdowns on high-volume database servers, and on
> searching through the logs, I might find an event from the database
> engine about an I/O operating taking over 30 seconds to complete.
> Meanwhile, the application using the database was backlogged due to
> its queries taking longer, for what ended up being a faulty SFP.
> After replacing that, we could get the application running again, to
> process its replication and workload backlogs.  The link integrity
> events could help alert on these link problems before they turn into
> application disruptions.
> 
But that's precisely it, isn't it?
If it's a straight error the path/controller is being reset, and
really there's nothing for us to be done.
If it's an FPIN LI _without_ any performance impact, why shouldn't
we continue to use that path? Would there be any impact if we do?
And if it's an FPIN LI with _any_ sort of performance impact
(or a performance impact which might happen eventually) the
current approach of steering away I/O should be fine.
Am I missing something?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
