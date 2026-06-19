Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5021E4AF
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2026 06:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781848903; cv=none; b=kQ9VHZCzWf3V6wVaQyLiIN7Ov/G8kjI4QBLl0UO9tZyFQMwXw4XNjlwhO+RIct0DmRz/2l+MvzXFqyxrHQj8J+EJEoa4AOvsykpEP5ga4LKQK70EfbGNlejC1Dsnh7qOr/qmaaxzd4ECKKNvWSKKs/c2l/EOyc9Ztc9gApqSzbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781848903; c=relaxed/simple;
	bh=bSev8Ho6wXz1oDAR97voFjVx3LTRc7AQTSi4KYorbnU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lvQkUXoIpVJwLPsQe8m7IHMAxxIedxbEbmc4fi9mVf3DxWfGhoFCNPpefVNapunEZFvNhHqTHtQnQrGBwwp+Hp8qJr69GodnJnWLcujHKw1nD05igRnhPtbVubu909ZwN07ewUOw6jnigY0RZnfdtUbtGstkgm36Q4pvFgLBmIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yWRtBJto; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=24eIJs2e; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yWRtBJto; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=24eIJs2e; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yWRtBJto";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="24eIJs2e";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yWRtBJto";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="24eIJs2e"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 65DFC76099;
	Fri, 19 Jun 2026 06:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781848900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AlkgWw1+S3GWQ34axZ/hy1O9oQlycY9Q7+uBSMBu15w=;
	b=yWRtBJtonD1py4w2LQaEgzwN4h8Q5+TC4UR857KTMAiIPhzNeEZF+gpjFxYKamsgvkwdOf
	+TI0qGKwErfpY3RPeYQfLX9TqJdXCtptFS3SFKgJNsE8cRXTWcrUFpB4jwEp6jD+6xSPrs
	fqewVa0ghymSy/bnrItRuP7Tiw4cJXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781848900;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AlkgWw1+S3GWQ34axZ/hy1O9oQlycY9Q7+uBSMBu15w=;
	b=24eIJs2egWsX1TDAY0cAMpZoRg5M3S7o7o8yfizUFd76NH5i+WRRAdpwjg57eEgZGf9WTz
	4RBkcP8vwbUwG2DQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781848900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AlkgWw1+S3GWQ34axZ/hy1O9oQlycY9Q7+uBSMBu15w=;
	b=yWRtBJtonD1py4w2LQaEgzwN4h8Q5+TC4UR857KTMAiIPhzNeEZF+gpjFxYKamsgvkwdOf
	+TI0qGKwErfpY3RPeYQfLX9TqJdXCtptFS3SFKgJNsE8cRXTWcrUFpB4jwEp6jD+6xSPrs
	fqewVa0ghymSy/bnrItRuP7Tiw4cJXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781848900;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AlkgWw1+S3GWQ34axZ/hy1O9oQlycY9Q7+uBSMBu15w=;
	b=24eIJs2egWsX1TDAY0cAMpZoRg5M3S7o7o8yfizUFd76NH5i+WRRAdpwjg57eEgZGf9WTz
	4RBkcP8vwbUwG2DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32A1D779A8;
	Fri, 19 Jun 2026 06:01:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KvbfCkTbNGqqFwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 19 Jun 2026 06:01:40 +0000
Message-ID: <0adf2cae-d9a3-4ac1-b794-d850c77bf67b@suse.de>
Date: Fri, 19 Jun 2026 08:01:39 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] scsi: core: Handle reprobe for existing devices
 during SCSI scan
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org, krishna.kant@purestorage.com
References: <20260618233508.97960-1-brian@purestorage.com>
 <20260618233508.97960-6-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260618233508.97960-6-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
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
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:email,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 

On 6/19/26 01:35, Brian Bunker wrote:
> Complement scsi_rescan_device() reprobe by handling the scan path.
> Update INQUIRY data and reprobe existing devices when standard INQUIRY
> data changed.
> 
> Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/scsi_scan.c | 91 ++++++++++++++++++++++++++++++++++++----
>   1 file changed, 83 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
