Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15819CA6B
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 17:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771003267; cv=none; b=TZQ2OurSpWEZiZsPPrkFf1dnk+CT4wFeZuZyOEOqBYHEPnbyTyc2tE0fNn5b/cCCIMSR4NLRSYn80W2/AD+YSafGTyk2Ld4xilNxkuBr98jzRqX9mif5s4vD7K622t7qcqxUfdjPEAc+pYxe/GYOGVJnOdXh1jFDhkpUtRjeg1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771003267; c=relaxed/simple;
	bh=RhMoub6YJ3K417FL7QaGlOXlza3hFgtEdmaO25rEm50=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=r/ociNoI7jeyi96ybMUOCSyOi1cy6DDVZIOTvjyKm4CluQWq2DhkqIpYfgc958vGCjDvTExmuNLb75lVsL1PS4ZPX3uREWYnRbITmvRMN1AfwwKgScFLSvRtJ/5g/s2nOVj+NArqLVi1auIO2xNiW+DscO3+szBIELA7+YQECDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0KCgaabQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nNqqbns5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0KCgaabQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nNqqbns5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0KCgaabQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nNqqbns5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0KCgaabQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nNqqbns5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 624F95BCD2;
	Fri, 13 Feb 2026 17:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771003264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+0Qcgov1CiqxYvgChe7cFxxzlsm1LzCXVb+M9TkPGdw=;
	b=0KCgaabQvazj0dTodPdCxJR+FoHaOg8WIdH1wMf4ZqXrPfcYbJtjitBTSwnjKQGdQ7ogFP
	9Wyabwc/wtuEZRjdmcfZ1MbMJnbpiP0Q+pEH7OUxxQnucx4S9v6sesRB6eyPvo0I5BtoOg
	d0aHdGJwEfTsvl7vYVZR50Gs4SpJ+d0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771003264;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+0Qcgov1CiqxYvgChe7cFxxzlsm1LzCXVb+M9TkPGdw=;
	b=nNqqbns5vRjWFPaSku5PXp9VvniVGqNwW74Hd1gwYYnayihgkyFsIyhoML7tcllXMPKZVb
	3+XhXmigFZgL2dBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771003264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+0Qcgov1CiqxYvgChe7cFxxzlsm1LzCXVb+M9TkPGdw=;
	b=0KCgaabQvazj0dTodPdCxJR+FoHaOg8WIdH1wMf4ZqXrPfcYbJtjitBTSwnjKQGdQ7ogFP
	9Wyabwc/wtuEZRjdmcfZ1MbMJnbpiP0Q+pEH7OUxxQnucx4S9v6sesRB6eyPvo0I5BtoOg
	d0aHdGJwEfTsvl7vYVZR50Gs4SpJ+d0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771003264;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+0Qcgov1CiqxYvgChe7cFxxzlsm1LzCXVb+M9TkPGdw=;
	b=nNqqbns5vRjWFPaSku5PXp9VvniVGqNwW74Hd1gwYYnayihgkyFsIyhoML7tcllXMPKZVb
	3+XhXmigFZgL2dBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 318B63EA62;
	Fri, 13 Feb 2026 17:21:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yxXCCoBdj2kgCwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 13 Feb 2026 17:21:04 +0000
Message-ID: <b598c5c9-6732-4661-85b2-7ab10a0830d4@suse.de>
Date: Fri, 13 Feb 2026 18:21:03 +0100
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
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Level: 
X-Spam-Flag: NO

On 2/13/26 15:19, John Garry wrote:
> At ALPSS 25 I presented a proposal for Native SCSI multipath support. 
> Let's discuss this topic at LSFMM.
> 
> The idea for this is that SCSI could natively support multipath, like 
> how NVMe host driver does today. It is intended as an alternative to dm- 
> multipath support.
> 
> I have been working on the implementation and I plan to post patches in 
> the next cycle. I am looking at a 3-stage approach:
> a. create a driver-agnostic multipath library, very heavily based on 
> NVMe host multipath support.
> The library would support features such as path management, path 
> selection/iopolicy, failover recovery, PR, delayed removal, gendisk 
> management etc.
> b. switch NVMe over to use this library
> c. add native SCSI multipath support based on this common library
> 
Go for it, John!

I'd be very interested in that.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
