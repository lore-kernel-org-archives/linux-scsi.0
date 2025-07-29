Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40380256C87
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2025 06:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753769616; cv=none; b=aumeG72gn6SFYMxtVoTAmDO/2Mb+K4P+eSymLTSQU62pRZeizL5kDDr2UEEvGjhPtQK0hJkA9RQzB/Z+JyUueNRV8Ebner127Ll5nH5aomRRFEBjtyCpgnL+4bCWV/EThzZKxSdc4MNscJgbiWZ0aJD2S8nyjG21BPbMyTCbWTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753769616; c=relaxed/simple;
	bh=Za6avbG/kTSnuR3LozRWPpCYhBnr74YBEpeRjHvSUYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sfVCxIIUf6vvx1qfQJpeXq+6r1BGC63dnd5bzKzl4n4DEeOz2Mj16mO+Xu9kfcYNM0XZjzkjHnRLgnSqn5OyMtqvlS94xkLmSz16eExM9+eXBEw/v3L2P7BqRaIsXAF/E3IRmS+cW6VbXBWznYUcqy2z5YuDSMJm1y9iF1hygZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LAlgUlU3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OIFH+agL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LAlgUlU3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OIFH+agL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LAlgUlU3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OIFH+agL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LAlgUlU3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OIFH+agL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 60CBC21275;
	Tue, 29 Jul 2025 06:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753769612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I70hZQZVJ/i2Ijczo/FBOLW5wrJGgJWLRk0bf2YcPl8=;
	b=LAlgUlU30l/sBT3yleHzqXULr3gNFKljjZYk6n8lOW+NGtLFh8lAIAxAzvTqCrzgVO2y/m
	wmZOmw9T+ERyls5Z1TUuohl1ZgqG5xvHohkGIsaCEJbMWjWrjOUi8IJb+no20MFgylmEUk
	dMRg/44EnSQEQtU0wBqhAbNpagEdzsw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753769612;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I70hZQZVJ/i2Ijczo/FBOLW5wrJGgJWLRk0bf2YcPl8=;
	b=OIFH+agLBT/oczuSTK7TMsvpv8LWZUjd0mFlq1RMKs0IJp+khg3RYuLNF1VxKdrRNUq/Z5
	fBvqOe1rwyJX2OCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LAlgUlU3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OIFH+agL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753769612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I70hZQZVJ/i2Ijczo/FBOLW5wrJGgJWLRk0bf2YcPl8=;
	b=LAlgUlU30l/sBT3yleHzqXULr3gNFKljjZYk6n8lOW+NGtLFh8lAIAxAzvTqCrzgVO2y/m
	wmZOmw9T+ERyls5Z1TUuohl1ZgqG5xvHohkGIsaCEJbMWjWrjOUi8IJb+no20MFgylmEUk
	dMRg/44EnSQEQtU0wBqhAbNpagEdzsw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753769612;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I70hZQZVJ/i2Ijczo/FBOLW5wrJGgJWLRk0bf2YcPl8=;
	b=OIFH+agLBT/oczuSTK7TMsvpv8LWZUjd0mFlq1RMKs0IJp+khg3RYuLNF1VxKdrRNUq/Z5
	fBvqOe1rwyJX2OCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC6CD13876;
	Tue, 29 Jul 2025 06:13:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Zi0YOItmiGj5EQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 29 Jul 2025 06:13:31 +0000
Message-ID: <9e85c424-6722-4315-b125-d0d26fc4574b@suse.de>
Date: Tue, 29 Jul 2025 08:13:31 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Improper io_opt setting for md raid5
To: Yu Kuai <yukuai1@huaweicloud.com>, Damien Le Moal <dlemoal@kernel.org>,
 =?UTF-8?Q?Csord=C3=A1s_Hunor?= <csordas.hunor@gmail.com>,
 Coly Li <colyli@kernel.org>, hch@lst.de
Cc: linux-block@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
 <bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
 <2b22f745-bbd5-4071-be9b-de9e4536f2d5@kernel.org>
 <6ab1be6e-380b-d4aa-dd71-f53373a66e29@huaweicloud.com>
 <655cb7e6-897a-4fab-a8ce-8832f2bc7274@kernel.org>
 <4767823c-2332-b3e1-67a6-2d7f55b48156@huaweicloud.com>
 <a1626eef-9846-4824-a899-2fbd8e369fac@kernel.org>
 <9c6f300a-f78f-de6e-4b99-453df377c7ba@huaweicloud.com>
 <fa2f9406-4ee8-45f9-a784-b5042e9f4411@kernel.org>
 <c8c4d140-4ca4-9998-dea3-62341a28c7c5@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <c8c4d140-4ca4-9998-dea3-62341a28c7c5@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[huaweicloud.com,kernel.org,gmail.com,lst.de];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 60CBC21275
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01

On 7/28/25 11:02, Yu Kuai wrote:
> Hi,
> 
> 在 2025/07/28 15:44, Damien Le Moal 写道:
>> On 7/28/25 4:14 PM, Yu Kuai wrote:
>>>>> With git log, start from commit 7e5f5fb09e6f ("block: Update topology
>>>>> documentation"), the documentation start contain specail 
>>>>> explanation for
>>>>> raid array, and the optimal_io_size says:
>>>>>
>>>>> For RAID arrays it is usually the
>>>>> stripe width or the internal track size.  A properly aligned
>>>>> multiple of optimal_io_size is the preferred request size for
>>>>> workloads where sustained throughput is desired.
>>>>>
>>>>> And this explanation is exactly what raid5 did, it's important that
>>>>> io size is aligned multiple of io_opt.
>>>>
>>>> Looking at the sysfs doc for the above fields, they are described as 
>>>> follows:
>>>>
>>>> * /sys/block/<disk>/queue/minimum_io_size
>>>>
>>>> [RO] Storage devices may report a granularity or preferred
>>>> minimum I/O size which is the smallest request the device can
>>>> perform without incurring a performance penalty.  For disk
>>>> drives this is often the physical block size.  For RAID arrays
>>>> it is often the stripe chunk size.  A properly aligned multiple
>>>> of minimum_io_size is the preferred request size for workloads
>>>> where a high number of I/O operations is desired.
>>>>
>>>> So this matches the SCSI limit OPTIMAL TRANSFER LENGTH GRANULARITY 
>>>> and for a
>>>> RAID array, this indeed should be the stride x number of data disks.
>>>
>>> Do you mean stripe here? io_min for raid array is always just one
>>> chunksize.
>>
>> My bad, yes, that is the definition in sysfs. So io_min is the stride 
>> size, where:
>>
>> stride size x number of data disks == stripe_size.
>>
> Yes.
> 
>> Note that chunk_sectors limit is the *stripe* size, not per drive stride.
>> Beware of the wording here to avoid confusion (this is all already super
>> confusing !).
> 
> This is something we're not in the same page :( For example, 8 disks
> raid5, with default chunk size. Then the above calculation is:
> 
> 64k * 7 = 448k
> 
> The chunksize I said is 64k...

Hmm. I always thought that the 'chunksize' is the limit which I/O must
not cross to avoid being split.
So for RAID 4/5/6 I would have thought this to be the stride size,
as MD must split larger I/O onto two disks.
Sure, one could argue that the stripe size is the chunk size, but then
MD will have to split that I/O...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
