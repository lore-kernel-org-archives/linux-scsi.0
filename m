Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4DD2D2389
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 06:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755672891; cv=none; b=oQ3ncDS5XP0+1fUcqc/GiLO1QT07hure2pFD5X+MGQl8YiBy8/FwEqMFGRoc77m6f7yhV2sUqkNGUTJ8eUMUApPrZ1Khd53PeAkJH/x1jNu4TMeVU5C+BJtSYttKNf7lDZ29766jWjPtciwJrXZiSyCy3PdOa3n49YD+qQSVYgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755672891; c=relaxed/simple;
	bh=kYgdq0vapV0btQjkiN7fDZgp/v8Eajh7Id6D9TM/hf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F2/ioAsedByHlI1I20j6whyZX8p/iNN+Z+xALxOnguC5FCr+AEGeCn4X7Pnu5GPHpjZkIHFejWbk/4Xua/esuJ4AaGiXgoIBJC+DYpSKHjllooyG4ue5sITJ/Sijsc/AyDnO1syTy1HI17bZyt1y7LAUkaVBh4wkRLwGVH7dTZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LPqyDyHm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9cY+j7IJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LPqyDyHm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9cY+j7IJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LPqyDyHm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9cY+j7IJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LPqyDyHm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9cY+j7IJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 469EF1F7A9;
	Wed, 20 Aug 2025 06:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755672882; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E8X3jtLVFzJEzEyPeertAdvkSUGqohtPfikDq9tfVas=;
	b=LPqyDyHmH1uUjrj/clEUNcjTuCcC9mip6WlmNQr1W1IxutUaLr9xy+i6uU82UOvBD57c+Z
	3BG5Zn4PVatWAcvLzCkOTe6emgcSyqABhZMFjUz2SA3d7jTKR7kpuQh/b/jJvUwXUp6gJ/
	35iYbBsHhYmb9v7D4pCCXW/VQRpC8to=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755672882;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E8X3jtLVFzJEzEyPeertAdvkSUGqohtPfikDq9tfVas=;
	b=9cY+j7IJVrdTheW2NzmwtUuSBIi91BvfHeueOiwXiwGCKTOI51wOjZk6HLyDGs6y+MLeL6
	RNZvzXfBp2pErjBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755672882; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E8X3jtLVFzJEzEyPeertAdvkSUGqohtPfikDq9tfVas=;
	b=LPqyDyHmH1uUjrj/clEUNcjTuCcC9mip6WlmNQr1W1IxutUaLr9xy+i6uU82UOvBD57c+Z
	3BG5Zn4PVatWAcvLzCkOTe6emgcSyqABhZMFjUz2SA3d7jTKR7kpuQh/b/jJvUwXUp6gJ/
	35iYbBsHhYmb9v7D4pCCXW/VQRpC8to=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755672882;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E8X3jtLVFzJEzEyPeertAdvkSUGqohtPfikDq9tfVas=;
	b=9cY+j7IJVrdTheW2NzmwtUuSBIi91BvfHeueOiwXiwGCKTOI51wOjZk6HLyDGs6y+MLeL6
	RNZvzXfBp2pErjBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EFC221368B;
	Wed, 20 Aug 2025 06:54:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RCBkODFxpWibTQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 20 Aug 2025 06:54:41 +0000
Message-ID: <66a096d7-8ed1-4a08-a207-533f945f6784@suse.de>
Date: Wed, 20 Aug 2025 08:54:41 +0200
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
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <58622f7d-a075-40b8-a2ea-190058d2737e@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 8/19/25 21:49, Bart Van Assche wrote:
> On 8/18/25 11:34 PM, Hannes Reinecke wrote:
>> and if we move TMFs and all non-I/O commands to reserved commands
>> cmd_per_lun will only be applicable to I/O commands.
> Whether or not reserved commands should be used for allocating TMFs
> depends on the SCSI transport. As an example, the approach mentioned
> above is not appropriate for the UFS driver. The UFS driver assigns
> integers in the range 0..31 to TMFs. These integers are passed directly
> to the UFS host controller. Hence, allocating TMFs as reserved commands
> from the same tag set as SCSI commands is not appropriate for the UFS
> host controller driver.
> 
So TMFs use a separate tagset than normal commands?
IE can I submit TMF tag '3' when I/O tag '3' is currently
in flight?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
