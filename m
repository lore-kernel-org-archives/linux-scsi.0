Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F75428000F
	for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2025 08:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758012255; cv=none; b=Cj0nFikCAmMSaVdAQ8Nujsp7Nn5FeG2yMRG1MtACL3dP7uwWfAO2kxLvbxSjo1PCVQ8VvoTKVsGaMt33Ug2UHoCo0VmO5V/Ekqux3+r3u96Zduh3CrlPWJ6AbAEJgN7Ip6iWgLgoZtu20KKJci6D7Px9ypVcuQCxoZvJ8zK6SL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758012255; c=relaxed/simple;
	bh=9Mfj0F9IVQoXjM2ffyNuCv3j31kAlWRwNE0d8TWPmEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DBuc5BDP8oHAYTbO/hEfpgwh8+KWpjSe3Sd1r8XelWChm4p5gMNhRCD2rcLaxXV1BeXWO4NhEYT44HcZbYz6uyLGQfT71pUG5Df2ol2tQVMdbx6VyMZjXy2usBz8kzoeLqPtPs3Gy4kOHEFZZaLZyTsQh9sH+IxyPEB6DULmGUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yrxl+eKY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LBbao/IX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hAJHyLIq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1z6vK7uD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yrxl+eKY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LBbao/IX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hAJHyLIq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1z6vK7uD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8D7241F8BA;
	Tue, 16 Sep 2025 08:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758012252; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2F6UZGv8la/fCVVIlz7Q/qm3/97HbyZTDskslq+FpyI=;
	b=yrxl+eKYH59mExmf4DZk4IgPaaCW+ggczDlWAmEUAltzguHIYyH2SLtRF+OMNl2UJhb+Pw
	sfprv7psF5O7WVuXHeHRIyCpB0hZERaVd8l1pNhg8QU4ojifwMNthusnPrJyQZ9haoNTAj
	6Mqx3qclQz1lnVEeNBvBWkML2FZK2hA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758012252;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2F6UZGv8la/fCVVIlz7Q/qm3/97HbyZTDskslq+FpyI=;
	b=LBbao/IXxnxljQNE4Ix4Z14n/7Dvt/wYOHdEB1ZpotnJGkNt/UNDylyTf/GvYBMD93hMHo
	bkmWXcTXoDc5HNCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hAJHyLIq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1z6vK7uD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758012250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2F6UZGv8la/fCVVIlz7Q/qm3/97HbyZTDskslq+FpyI=;
	b=hAJHyLIqAUdlg/lipg/WQDwrq4RtM2LrXh6ZKeKC18HzdBWjQppbYdXTA19iSmBYSjltrW
	FoQRd/Cuisqq7bBB0vAl0KH3HSKyw97d07QZONX5eB7IUpfHGj+D0ULfOPjjXQ1VdddJ6X
	nxklGINMvFvhd31EkDiv8yfuqUxOYMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758012250;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2F6UZGv8la/fCVVIlz7Q/qm3/97HbyZTDskslq+FpyI=;
	b=1z6vK7uDkKpyBScMPF0Zz+/7VRVewoi8oicHKzNNxB2QbA1vB/2Sv6AlKhzjbDtqIcqvvW
	zu6BBdKa+okeaoCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6B4EF13A63;
	Tue, 16 Sep 2025 08:44:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KseFGVojyWhCJQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 16 Sep 2025 08:44:10 +0000
Message-ID: <3de95224-8704-4843-a5dc-7705faff532c@suse.de>
Date: Tue, 16 Sep 2025 10:44:10 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/29] scsi: core: Support allocating a pseudo SCSI
 device
To: John Garry <john.g.garry@oracle.com>, Bart Van Assche
 <bvanassche@acm.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-5-bvanassche@acm.org>
 <4c865666-a2d9-4037-9762-4bed3490a4ea@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <4c865666-a2d9-4037-9762-4bed3490a4ea@oracle.com>
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
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 8D7241F8BA
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 9/16/25 10:21, John Garry wrote:
> On 12/09/2025 19:21, Bart Van Assche wrote:
>> From: Hannes Reinecke <hare@suse.de>
>>
>> Allocate a pseudo SCSI device if 'nr_reserved_cmds' has been set. Pseudo
>> SCSI devices have the SCSI ID <max_id>:U64_MAX so they won't clash with
>> any devices the LLD might create. Pseudo SCSI devices are excluded from
>> scanning and will not show up in sysfs. Additionally, pseudo SCSI
>> devices are skipped by shost_for_each_device(). This prevents that the
>> SCSI error handler tries to submit a reset to a non-existent logical 
>> unit.
>>
>> Do not allocate a budget map for pseudo SCSI devices since the
>> cmd_per_lun limit does not apply to pseudo SCSI devices.
> 
> IDGI, in v3 series you said that you would allocate the budget map 
> https://lore.kernel.org/linux-scsi/20250827000816.2370150-1- 
> bvanassche@acm.org/T/#m13c361e081b886b9318238b6dc05b571840b9698
> 
> FWIW, I still think that it is worth allocating the budget map for the 
> psuedo sdev and making the queue depth the same as nr_reserved_commands 
> via a scsi_change_queue_depth() call.
> 
No. budget map is only for resource arbitration between several devices
sharing the same underlying bitmap. Which doesn't apply for the pseudo
device; that is a virtual device pointing to the HBA itself, of which
we only every will have _one_.

> If we want to optimise budget code handling, then I think that it is 
> worth doing later. The whole budget map and cmd_per_lun handling is 
> murky IMHO.
> 
Oh, most definitely. budget map / cmd_per_lun was okay for single queue
devices where we couldn't really tell how many commands we should send.
But for multiqueue we know exactly how many commands should be possible,
so for _real_ multiqueue devices cmd_per_lun is pretty pointless if not
downright detrimental.
_Unless_ we have a multiqueue device with a shared host tagset, then it
sort of would make sense. But then one wonders why sbitmap doesn't do
that internally.

Sounds like a fun topic for ALPSS.

>>
>> Do not perform queue depth ramp up / ramp down for pseudo SCSI devices.
> 
> Are we even ever going to try ramp up or down for the pseudo sdev?
> 
No. Why would you want to restrict the number of eg TMFs you could send?

> I suppose we could see it if there is some internal reserved command 
> error, right?
> 
That would be equivalent to the HBA rejecting TMFs with 'out of 
resources'. At which point I would declare the HBA hosed and do
a full host/PCI reset.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
