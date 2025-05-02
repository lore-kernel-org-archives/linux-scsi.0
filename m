Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE0F22ACCE
	for <linux-scsi@vger.kernel.org>; Fri,  2 May 2025 07:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746170720; cv=none; b=q/RuEnvbJKsWuP9vNwWPO3CBSUriUH33Gk1Jqg19PYMyI4s7l4pm/ZR6E0XGzhnezY0lAMX6B37xELxFENKS8/5o585IUpktyHnE5Q1CIaxxMZGsEIkDmqlbKU9Uzk4NwfzCcZD1WHzP6nmbg7VhYFwmqL9FpJq1pXdoFBvSHRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746170720; c=relaxed/simple;
	bh=CMHqWuk7RZ+quQhyNesPYm5K7Rr3nlPAqgJCj3eoq04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pPaS136HS8xLe20xg4/EPsdOqsc9jyxzi0mQjD7rkY8aEH3JTwMnB5K9NTPwf8Bj2+WNRD62cI0vbdYvjMCesi4rdmn2Gfqy+hxXD29RKCOxX1ULQHuZV088EGreewck4oCV9h1Rgqcch6dCaMQO3/ADC6o9jKzQoLavdcZpPrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iIF9ViaZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=M12xu8BU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iIF9ViaZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=M12xu8BU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iIF9ViaZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="M12xu8BU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iIF9ViaZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="M12xu8BU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0697121A0B;
	Fri,  2 May 2025 07:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746170717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xtJbcL426DKNGAr2FtIavadp4OKGW5CpxmJtMoRNYhc=;
	b=iIF9ViaZ2L8ANKaxFuOnbuWZG6MjUZ7MfGBYbDXVFlXbV33HNJQXf1/wSVWz/JVob22A4t
	5s0vP8iiW38cTvy/1YCJfcCRfLmJDGJoRTNCEtrvN+5/zwFYeYWvk4izqs/b26Fq6IMrSG
	YoJgGmaNA2aVGsWRSLhMvKRwoWugZgU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746170717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xtJbcL426DKNGAr2FtIavadp4OKGW5CpxmJtMoRNYhc=;
	b=M12xu8BUv53uOtmRiIUmfTljL5g7+pENmwQL39jld0mi8Kd7budtwvTfAsewG+TBVX34iV
	Uesbj/K4+QHgwlCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iIF9ViaZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=M12xu8BU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746170717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xtJbcL426DKNGAr2FtIavadp4OKGW5CpxmJtMoRNYhc=;
	b=iIF9ViaZ2L8ANKaxFuOnbuWZG6MjUZ7MfGBYbDXVFlXbV33HNJQXf1/wSVWz/JVob22A4t
	5s0vP8iiW38cTvy/1YCJfcCRfLmJDGJoRTNCEtrvN+5/zwFYeYWvk4izqs/b26Fq6IMrSG
	YoJgGmaNA2aVGsWRSLhMvKRwoWugZgU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746170717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xtJbcL426DKNGAr2FtIavadp4OKGW5CpxmJtMoRNYhc=;
	b=M12xu8BUv53uOtmRiIUmfTljL5g7+pENmwQL39jld0mi8Kd7budtwvTfAsewG+TBVX34iV
	Uesbj/K4+QHgwlCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A776913687;
	Fri,  2 May 2025 07:25:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fOz2JlxzFGguOAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 02 May 2025 07:25:16 +0000
Message-ID: <708230df-0480-4ccc-a900-68e121ceb07f@suse.de>
Date: Fri, 2 May 2025 09:25:16 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] scsi: make ppa depend on !HIGHMEM
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Alan Stern <stern@rowland.harvard.edu>,
 Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net, linux-mm@kvack.org
References: <20250502064930.2981820-1-hch@lst.de>
 <20250502064930.2981820-4-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250502064930.2981820-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0697121A0B
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	SUBJECT_HAS_EXCLAIM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,lst.de:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 5/2/25 08:49, Christoph Hellwig wrote:
> This is one of the last drivers depending on the block layer bounce
> buffering code.  Restrict it to run on non-highmem configs so that the
> bounce buffering code can be removed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/Kconfig | 1 +
>   drivers/scsi/ppa.c   | 1 -
>   2 files changed, 1 insertion(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
