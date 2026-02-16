Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568052DB7BA
	for <linux-scsi@vger.kernel.org>; Mon, 16 Feb 2026 16:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771259547; cv=none; b=n5mPk9ZDSWUVzqsF+L6tTYpCp1CIF6NJ3G/VkYX455V7UoMsIvyfsC5f798hu/dLktxCjWa4pZYMYZDosHC2NauzVokpeWrKwcoM5hDCO95qSM5HWi2Uu3rBp/f9iF32ZBdu2bFLUSTke2jtQkLegCtJcMCvLcdkYwT15+E4FOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771259547; c=relaxed/simple;
	bh=AvRD2J9IHtyHe0iyt1Pa0Aq7UxnwZUwQ4OhSsM5wRFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BsDiq5MF2DLuIq+feHUH7v4H8xu1mweTQEE8A6xYIGNvJytsuTsBK29ylaY+rF5dq7yGQrM+E8IgdU7MPKYPlQf/B4hQXeYsqSDiDhfmmECvbdHypMxv4W7VOWAXLxWdHlKXDdU0pVkG1j2niH65J3GN4Nw8ZZjdl2+BXdrvLUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jJq/b2C/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=me4ILhSV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jJq/b2C/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=me4ILhSV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jJq/b2C/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="me4ILhSV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jJq/b2C/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="me4ILhSV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC08B3E6D3;
	Mon, 16 Feb 2026 16:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771259544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5qZ+gncTo83Pa/tlAU8PPmKc8PzepOWLFBYa3C1pQmQ=;
	b=jJq/b2C/I2XPMvN3uIRDVQcRWqp9Dn73JK65HPxnaFT6II6+9LYOXgu1c/18fbsEemVvPM
	BPfeNDjesZ2D+O+J3m+75Ywl6bQbHCLHG8BGeVYfPbqk5ohm8o3qa8VMx+s7M//zlfA5jC
	sNwwXk/U0o3zpG5WqrvATVYTtWg/8io=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771259544;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5qZ+gncTo83Pa/tlAU8PPmKc8PzepOWLFBYa3C1pQmQ=;
	b=me4ILhSVIq1ZwTrHb2MFHngFrsbUsHKMXpVZAQ//BnKttEgrUxekf4/YKxyCbbCLZdW40B
	/Dv7cOMFGrPjD0DA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="jJq/b2C/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=me4ILhSV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771259544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5qZ+gncTo83Pa/tlAU8PPmKc8PzepOWLFBYa3C1pQmQ=;
	b=jJq/b2C/I2XPMvN3uIRDVQcRWqp9Dn73JK65HPxnaFT6II6+9LYOXgu1c/18fbsEemVvPM
	BPfeNDjesZ2D+O+J3m+75Ywl6bQbHCLHG8BGeVYfPbqk5ohm8o3qa8VMx+s7M//zlfA5jC
	sNwwXk/U0o3zpG5WqrvATVYTtWg/8io=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771259544;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5qZ+gncTo83Pa/tlAU8PPmKc8PzepOWLFBYa3C1pQmQ=;
	b=me4ILhSVIq1ZwTrHb2MFHngFrsbUsHKMXpVZAQ//BnKttEgrUxekf4/YKxyCbbCLZdW40B
	/Dv7cOMFGrPjD0DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 667BA3EA62;
	Mon, 16 Feb 2026 16:32:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zaAdFphGk2lEKwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 16 Feb 2026 16:32:24 +0000
Message-ID: <784d3f14-99a0-4661-afde-b412d44572ab@suse.de>
Date: Mon, 16 Feb 2026 08:26:45 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Native SCSI multipath support
To: John Garry <john.g.garry@oracle.com>, lsf-pc@lists.linux-foundation.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
 <b598c5c9-6732-4661-85b2-7ab10a0830d4@suse.de>
 <dbf5fbdd-8894-40b7-b574-0c6385995ec2@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
X-Mozilla-Draft-Info: internal/draft; vcard=0; receipt=0; DSN=0; uuencode=0;
 attachmentreminder=0; deliveryformat=0
X-Identity-Key: id3
Fcc: imap://hare%40Thunderbird_lenient@imap.suse.de/INBOX/Sent
In-Reply-To: <dbf5fbdd-8894-40b7-b574-0c6385995ec2@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	URIBL_BLOCKED(0.00)[lst.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: AC08B3E6D3
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

On 2/14/26 10:42, John Garry wrote:
> On 13/02/2026 17:21, Hannes Reinecke wrote:
>>> At ALPSS 25 I presented a proposal for Native SCSI multipath support. 
>>> Let's discuss this topic at LSFMM.
>>>
>>> The idea for this is that SCSI could natively support multipath, like 
>>> how NVMe host driver does today. It is intended as an alternative to 
>>> dm- multipath support.
>>>
>>> I have been working on the implementation and I plan to post patches 
>>> in the next cycle. I am looking at a 3-stage approach:
>>> a. create a driver-agnostic multipath library, very heavily based on 
>>> NVMe host multipath support.
>>> The library would support features such as path management, path 
>>> selection/iopolicy, failover recovery, PR, delayed removal, gendisk 
>>> management etc.
>>> b. switch NVMe over to use this library
>>> c. add native SCSI multipath support based on this common library
>>>
>> Go for it, John!
>>
>> I'd be very interested in that.
> 
> cheers, in the meantime, I have some comments:
> 
> - I need to test PRs for both NVMe and SCSI, any advice on that would be 
> good. I don't think that blktests covers it. I did see Christoph mention 
> a testsuite at: https://lore.kernel.org/linux-nvme/1438672271-11309-1- 
> git-send-email-hch@lst.de/ - I can check that.
> 
Well, you might have seen the discussion on the device-mapper list, 
where stefanha is implementing generic PRs for dm-multipathing.
Or rather, trying to. We might need to revisit that and see what we
could be doing on the SCSI side.
Maybe we should be having a session about PRs at LSF?

> - I am still not sure on whether we require a multipath version of sg. 
> We can still have per-path sg. NVMe does have a multipath nvme-generic 
> dev, but that just handles IOCTLs/uring cmd, and nothing like sg read/ 
> write fops
> 
'sg' is primarily for testing 'raw' SCSI commands. (And dastardly 
complex to boot). I really would keep it in it's current form, and not
try to mimick something with SCSI multipathing.

> - I have not tried to detangle ALUA support from SCSI DH, so no ALUA 
> support yet
> 
Ouch. But that is the key point of the implementation; ALUA provides
_all_ the information required for multipathing, so how can you _not_
have support for it?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
