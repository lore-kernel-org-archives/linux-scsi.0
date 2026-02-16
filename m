Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB64F310644
	for <linux-scsi@vger.kernel.org>; Mon, 16 Feb 2026 16:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771259530; cv=none; b=bDlgOAQkOHPVcIEZOAkY/Mm1wG2N2GQN13fM7QmkIG3t3frgVcqNfraYRgGwBFNJSxyaZMmDUHgTejDhSFdAOen3YZ0cAIQbgaz5SiKV4+1/xol6uQASQK9c282DvyAU5Fv9FMnpkoA9bLC3NffzVOo3sJcilImpw29LaBajxfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771259530; c=relaxed/simple;
	bh=AvRD2J9IHtyHe0iyt1Pa0Aq7UxnwZUwQ4OhSsM5wRFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ntTVKvGmVCeWFaznttRmsqTMYg+SQgLjdxpJN85zYnCq2pdMZde9ymHRvSi1gW3Pl90rRmJv8XxUNdC43i5JtDGdjDclBfjFbFRtX9zvjNwaPrdt6RaQr7Ly2z8rKZGajAGkTQn1eDLLnvxMVwCjZcRjr44RH7oEI73ANeksNLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fViQDg7Q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vYB6yA03; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fViQDg7Q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vYB6yA03; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fViQDg7Q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vYB6yA03";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fViQDg7Q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vYB6yA03"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 15C5A5BEAF;
	Mon, 16 Feb 2026 16:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771259527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5qZ+gncTo83Pa/tlAU8PPmKc8PzepOWLFBYa3C1pQmQ=;
	b=fViQDg7Qdz9huI0oulDTwoA0x6hHSJFIoyRdmeiLDYIBaik91tSR7FXJ9EpGuv3onDYThw
	br04eWdvnosi/gJ/6B0LujgPZXC45O6nwhiK0tsK8wRVvMNi2OFM9a7QNEPrz5R+Pm8+Sy
	F3bJF5SwDcXSfy2nFjXtdBWeKtv8CIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771259527;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5qZ+gncTo83Pa/tlAU8PPmKc8PzepOWLFBYa3C1pQmQ=;
	b=vYB6yA03PcbPIEDTwNCvsQH8ZZ8hFwkOhCBzN1sXpi8CQnnGCnVTMq8BHDY2/2ucwcGaSo
	KE5ytuzaPc4gPeAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771259527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5qZ+gncTo83Pa/tlAU8PPmKc8PzepOWLFBYa3C1pQmQ=;
	b=fViQDg7Qdz9huI0oulDTwoA0x6hHSJFIoyRdmeiLDYIBaik91tSR7FXJ9EpGuv3onDYThw
	br04eWdvnosi/gJ/6B0LujgPZXC45O6nwhiK0tsK8wRVvMNi2OFM9a7QNEPrz5R+Pm8+Sy
	F3bJF5SwDcXSfy2nFjXtdBWeKtv8CIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771259527;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5qZ+gncTo83Pa/tlAU8PPmKc8PzepOWLFBYa3C1pQmQ=;
	b=vYB6yA03PcbPIEDTwNCvsQH8ZZ8hFwkOhCBzN1sXpi8CQnnGCnVTMq8BHDY2/2ucwcGaSo
	KE5ytuzaPc4gPeAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C83E93EA62;
	Mon, 16 Feb 2026 16:32:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Km20IYZGk2kxKwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 16 Feb 2026 16:32:06 +0000
Message-ID: <a5a0aa42-33e4-401f-ad94-8104cff9368c@suse.de>
Date: Mon, 16 Feb 2026 17:32:04 +0100
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
In-Reply-To: <dbf5fbdd-8894-40b7-b574-0c6385995ec2@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
X-Spam-Level: 
X-Spam-Flag: NO

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
