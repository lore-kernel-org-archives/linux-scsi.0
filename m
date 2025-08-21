Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3862427057B
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 06:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755758531; cv=none; b=eaXtmI2Cmi7n4hhf7njyOtYxo+FxNvLAGx3Hm5SFYFivaW2iYITkABxpD76wbLk/N/1tXnTg1F0j7dGXcyP8TK+64bH7RyMHuujCZ8XS2DYc6zXY2EtY2GrlHSzbSXZImF6YKV/cpWtG6Rvv5LmfIZfZI1xos+6WW+0XRMNt4gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755758531; c=relaxed/simple;
	bh=O1dwfSUFJxf2/RljKQ3XI9UELcNJp30SUCWlQFoh/KM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nir9Yf7AAft03sTD2Q35a29BsN7C/2udk04P3486z5+3BK4A38qa0BeBoh7yUZMN+CHm0zJIpBAQVQKmuYWL3DN/Vc6Pod9XpUBbjH7kJos7a2MoPwwwsvUC2VuN2ptmwCAuq0PGt21KwfiAe/CUpd5G/b67QsmwByujRii963Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WepxEiN/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SqP0WeAJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WepxEiN/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SqP0WeAJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WepxEiN/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SqP0WeAJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WepxEiN/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SqP0WeAJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 427D61F7EE;
	Thu, 21 Aug 2025 06:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755758527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lD9dkxYvW2iTGhfTN3mGvg9dNiJVqaa/VIZguVvnSJM=;
	b=WepxEiN/sFJFDPQUqeYiniZkHET/wPRyvNdAA2/eEeIyNl5/AL37fyLAWYcchKK3S3EQYS
	UWDgDiapoQuUR0Vvy0rFOoZhrgKMjWGXdQEhl+jS5WQcF9ZVu8LOQwe+90XfBrelmu8DjS
	TCWhU/yAlq88RjUhrH2N+bSYpHedptA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755758527;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lD9dkxYvW2iTGhfTN3mGvg9dNiJVqaa/VIZguVvnSJM=;
	b=SqP0WeAJk7M4usOLiqRH0dM3/tkEhMx7znexY04730TQdVs7YeeDdq0oswoBPpWIzpXRlL
	yEb43s/02qhu0XBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755758527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lD9dkxYvW2iTGhfTN3mGvg9dNiJVqaa/VIZguVvnSJM=;
	b=WepxEiN/sFJFDPQUqeYiniZkHET/wPRyvNdAA2/eEeIyNl5/AL37fyLAWYcchKK3S3EQYS
	UWDgDiapoQuUR0Vvy0rFOoZhrgKMjWGXdQEhl+jS5WQcF9ZVu8LOQwe+90XfBrelmu8DjS
	TCWhU/yAlq88RjUhrH2N+bSYpHedptA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755758527;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lD9dkxYvW2iTGhfTN3mGvg9dNiJVqaa/VIZguVvnSJM=;
	b=SqP0WeAJk7M4usOLiqRH0dM3/tkEhMx7znexY04730TQdVs7YeeDdq0oswoBPpWIzpXRlL
	yEb43s/02qhu0XBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 06929139A8;
	Thu, 21 Aug 2025 06:42:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hkwnO76/pmjedQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 21 Aug 2025 06:42:06 +0000
Message-ID: <76de3bab-edf5-43eb-a5d6-28dcced2130a@suse.de>
Date: Thu, 21 Aug 2025 08:42:06 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/30] scsi: core: Do not allocate a budget token for
 reserved commands
To: Bart Van Assche <bvanassche@acm.org>, John Garry
 <john.g.garry@oracle.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-4-bvanassche@acm.org>
 <f2d65247-ad6b-44ea-a687-808d8c398afc@suse.de>
 <30b475dc-3287-4bcb-99be-f2b6649217a5@oracle.com>
 <004de5e3-ad51-4a49-b7c7-e418587d3ef7@suse.de>
 <3a1f6959-8d74-4bb9-8e4b-31b5105734f9@acm.org>
 <36c7bf20-7dd4-4e19-8bc0-461a9f8a4228@suse.de>
 <58622f7d-a075-40b8-a2ea-190058d2737e@acm.org>
 <66a096d7-8ed1-4a08-a207-533f945f6784@suse.de>
 <0acda254-32a6-405b-a2d0-eef2401dbd83@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <0acda254-32a6-405b-a2d0-eef2401dbd83@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
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
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 8/20/25 19:53, Bart Van Assche wrote:
> On 8/19/25 11:54 PM, Hannes Reinecke wrote:
>> On 8/19/25 21:49, Bart Van Assche wrote:
>>> On 8/18/25 11:34 PM, Hannes Reinecke wrote:
>>>> and if we move TMFs and all non-I/O commands to reserved commands
>>>> cmd_per_lun will only be applicable to I/O commands.
>  >>
>>> Whether or not reserved commands should be used for allocating TMFs
>>> depends on the SCSI transport. As an example, the approach mentioned
>>> above is not appropriate for the UFS driver. The UFS driver assigns
>>> integers in the range 0..31 to TMFs. These integers are passed directly
>>> to the UFS host controller. Hence, allocating TMFs as reserved commands
>>> from the same tag set as SCSI commands is not appropriate for the UFS
>>> host controller driver.
>>>
>> So TMFs use a separate tagset than normal commands?
>> IE can I submit TMF tag '3' when I/O tag '3' is currently
>> in flight?
> 
> Yes, that's correct. This follows directly from the UFSHCI
> specification. In legacy mode (which is easier to explain than MCQ
> mode), there is one bitwise doorbell register for regular commands
> (UTRLDBR = UTP Transfer Request List DoorBell Register) and another
> bitwise doorbell register for task management functions (UTMRLDBR = UTP
> Task Management Request List DoorBell Register). A command is submitted
> by setting the appropriate bit in the UTRLDBR register. A TMF is
> submitted by setting the appropriate bit in the UTMRLDBR register. This
> is why the UFS driver allocates two tag sets - one for regular commands
> and another for TMFs.
> 
> These registers are called REG_UTP_TRANSFER_REQ_DOOR_BELL and
> REG_UTP_TASK_REQ_DOOR_BELL in the UFS driver source code.
> 
Ah. But then you can allocate two separate queues & tagsets, one for
TMFs and one for 'normal' commands (like NVMe does it).
Then you wouldn't need reserved commands at all; they only make sense
if TMFs and commands share the same tagspace.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
