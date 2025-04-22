Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBACA35893
	for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2025 06:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745304870; cv=none; b=H1GlmNDGcLG7wb6h1bY36aGd6mN3bjfdH8JFlsWVvmBi5m8YJncwsyOFG//lh56KG++IVj/6jmapNX8gQWm/ZV9qi+DmXh9IoOS4a9fc1Gzn1F/u8VkWb9vm9/YaanQsbfeMNJzytwVMlrB6NNNuWzfoIsMkTr/THiIAY++fi70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745304870; c=relaxed/simple;
	bh=gzCocZrO44MmvDwucXTVh4RonMn1RDyiG92ksxIUFvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AOsmdSOTU2nVktrtaSNjizyPShVL6XrufUzkmbsxZM69kH5nJ10U37Z4sDEHOsHRAF1Nmppaqi2Rl6Fs+Xw1e3Vg2mYnG/9X0kmfluseG/yu3jSkYihKaDYtb6or2cFHCT2rrxSGTvWIw+DocOWM43npM1WzEcoCIw2gJ9376OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NZDjKPR7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jXcFbeDQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NZDjKPR7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jXcFbeDQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NZDjKPR7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jXcFbeDQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NZDjKPR7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jXcFbeDQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F3E641F7C1;
	Tue, 22 Apr 2025 06:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745304867; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=os+g4Vf02+g1J+zUe7A1oLIPsHzf+3Cd95/FI/obw+o=;
	b=NZDjKPR7h+5h407CpZg3Jfm/aEn/+uEe0Qxoktf9/GGISm+PFTmwrHRdvCRRn5RFCHSQDh
	YlClHlgjp8KUGOcqg3/Hs1vkqfGRUcZtxvPocCwdt3BC1OSHzaSOAfSSy+4rKhpz/pbb7B
	L95NaXn7ysansDAbK8YZPdfftE3ggUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745304867;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=os+g4Vf02+g1J+zUe7A1oLIPsHzf+3Cd95/FI/obw+o=;
	b=jXcFbeDQAESdg9pjecIaBwh52Y+XpruZyqW9yTP4N74J0gsGuu2X+D5thmfZe4LvC5ehS0
	LD8jBuGq3hWxhBCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745304867; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=os+g4Vf02+g1J+zUe7A1oLIPsHzf+3Cd95/FI/obw+o=;
	b=NZDjKPR7h+5h407CpZg3Jfm/aEn/+uEe0Qxoktf9/GGISm+PFTmwrHRdvCRRn5RFCHSQDh
	YlClHlgjp8KUGOcqg3/Hs1vkqfGRUcZtxvPocCwdt3BC1OSHzaSOAfSSy+4rKhpz/pbb7B
	L95NaXn7ysansDAbK8YZPdfftE3ggUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745304867;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=os+g4Vf02+g1J+zUe7A1oLIPsHzf+3Cd95/FI/obw+o=;
	b=jXcFbeDQAESdg9pjecIaBwh52Y+XpruZyqW9yTP4N74J0gsGuu2X+D5thmfZe4LvC5ehS0
	LD8jBuGq3hWxhBCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4B14137CF;
	Tue, 22 Apr 2025 06:54:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id L1M9KiI9B2gFMAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 22 Apr 2025 06:54:26 +0000
Message-ID: <24c8a2a3-2d90-42fb-a662-fff349410101@suse.de>
Date: Tue, 22 Apr 2025 08:54:26 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi: core: Implement reserved command handling
To: Bart Van Assche <bvanassche@acm.org>, John Garry
 <john.g.garry@oracle.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-5-bvanassche@acm.org>
 <3c2fe290-5e24-4985-833c-24d8b80b98b7@oracle.com>
 <e1cc3f08-e7e0-4eea-82a8-c5d2e7618238@acm.org>
 <bff407bb-ed99-42b1-bfc8-05b8aa76957c@oracle.com>
 <27e5c0e9-a042-45e3-9852-31adb966b781@acm.org>
 <d6b35769-e5f7-4174-b581-f6555aec1d4e@oracle.com>
 <959ed10a-27e4-4c63-b9bd-58fefc5c4775@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <959ed10a-27e4-4c63-b9bd-58fefc5c4775@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 4/17/25 23:25, Bart Van Assche wrote:
> On 4/16/25 12:16 AM, John Garry wrote:
>> I'm not sure how that will look, but my preference is to fully 
>> implement reserved tags support which can be used by all SCSI LLDs.
> 
> Hi John,
> 
> I'm working on an implementation of this approach but it will take until
> next month until I will have the time to post a patch series that
> implements this approach.
> 
If it helps I can revisit and rebase my original patchset.
It had been shelved as there have been issues with the 'fnic' driver,
but as I now have a test system I can restart work on that series.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
