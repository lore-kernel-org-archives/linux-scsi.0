Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6FB3DB630
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 08:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779177968; cv=none; b=mFY0VIdumesTX8fXEMrw8c7toWvWYiJaZsmzjT0j/GI63OhHoeuYxkvqEKS/NRb1HOouD2Rj/o+2xGhb4JTUbFBv9dA30IJg08zDk35moUYfGXGkDjbERZj/XS0lsrIA71SlaxfFg6ma/Pjt2faXMrQTJsG7V2OgOS/KbEuX3aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779177968; c=relaxed/simple;
	bh=5LIaieF+EdqI6zDSqITe7YONVkEKj4uPdw0XUVdszKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R33T5y/mSpMjb6w3jm96oesYKl9LHYRZL9MxvPRQ9Qn1Gi96E9tGAGuCQU1iQqHV6P7sqUIh0dtnNAyoFnDLI6z2JaPW64Z8wd5xElcu3EPlPqMiP88uLZ1J2hb/voxFO1GjwIqjzUMLxLLq5Qq8E2QsUy9cuw8HcblGpbOvR70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=w+6eptGL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CnkURakL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=w+6eptGL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CnkURakL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w+6eptGL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CnkURakL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w+6eptGL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CnkURakL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 495F96B099;
	Tue, 19 May 2026 08:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779177965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KRE5LwvV3NapoCdQWRczjHApUkyTo0LW3GAE75V2UlA=;
	b=w+6eptGLmi1FtPGx5K7xQFSa5ew9fQDl1qwXXUMbkpEeTqvtu1gArj8euYXEVQB8/tTMd9
	6pxtMQx9hyyABUHXP/HuQi4cmmXvXhVdLSjYzNG2/Jn5m6wSV7/cQ61+3OTbj5P8vcYq93
	+UnJM6lfJUFB6UyFEuqwmRxzNBl6dQM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779177965;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KRE5LwvV3NapoCdQWRczjHApUkyTo0LW3GAE75V2UlA=;
	b=CnkURakLcKdkBcGL0K0YyouTqaUFAXWdQS+GSpW+qiZ70T2UpbEGsowqEv9D8rrmkg8GFZ
	RknJq5TEA2ngKaAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w+6eptGL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CnkURakL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779177965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KRE5LwvV3NapoCdQWRczjHApUkyTo0LW3GAE75V2UlA=;
	b=w+6eptGLmi1FtPGx5K7xQFSa5ew9fQDl1qwXXUMbkpEeTqvtu1gArj8euYXEVQB8/tTMd9
	6pxtMQx9hyyABUHXP/HuQi4cmmXvXhVdLSjYzNG2/Jn5m6wSV7/cQ61+3OTbj5P8vcYq93
	+UnJM6lfJUFB6UyFEuqwmRxzNBl6dQM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779177965;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KRE5LwvV3NapoCdQWRczjHApUkyTo0LW3GAE75V2UlA=;
	b=CnkURakLcKdkBcGL0K0YyouTqaUFAXWdQS+GSpW+qiZ70T2UpbEGsowqEv9D8rrmkg8GFZ
	RknJq5TEA2ngKaAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2BF8A593A8;
	Tue, 19 May 2026 08:06:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tAiICe0ZDGqvdQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 19 May 2026 08:06:05 +0000
Message-ID: <044fe652-0d28-43e1-9f4a-7f9f3c2fde8d@suse.de>
Date: Tue, 19 May 2026 10:06:00 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: core: Convert inquiry information
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
 Damien Le Moal <dlemoal@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260512194634.58145-1-bvanassche@acm.org>
 <20260512194634.58145-3-bvanassche@acm.org>
 <dc50e8ba-9c5b-41e9-8549-bde33a05f64a@suse.de>
 <1a68681a-3080-4279-9406-96838bba4345@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <1a68681a-3080-4279-9406-96838bba4345@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 495F96B099
X-Spam-Level: 

On 5/13/26 19:40, Bart Van Assche wrote:
> On 5/13/26 2:33 AM, Hannes Reinecke wrote:
>> Question is whether we shouldn't make this generic, ie treat 'inquiry'
>> as a temporary blob, copy things over to fields in 'sdev', and then
>> free the 'inquiry' blob again.
>> There are soo many things tacked onto the standard inquiry data 
>> (especially for storage array trying to mimic SCSI-2 inquiry data),
>> that we're better of copying over only fields which we _know_.
>> _And_ it'll save us a permanent data allocation for the scsi device...
>>
>> Hmm?
> 
> Are you perhaps suggesting to remove the inquiry sysfs attribute? From
> scsi_sysfs.c:
> 
> static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
>                  const struct bin_attribute *bin_attr,
>                  char *buf, loff_t off, size_t count)
> {
>      struct device *dev = kobj_to_dev(kobj);
>      struct scsi_device *sdev = to_scsi_device(dev);
> 
>      if (!sdev->inquiry)
>          return -EINVAL;
> 
>      return memory_read_from_buffer(buf, count, &off, sdev->inquiry,
>                         sdev->inquiry_len);
> }
> 
Ah. no. Emphatically not; we need that for the udev rules.

So ignore my comment.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
