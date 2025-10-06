Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F378D1A9FA8
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 07:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759734425; cv=none; b=sV+xm+TyK9D32DyYdlu1CuLZ4OJ8Zd90CGzfrECDdAHso25sD9bNOFxV0MmQzTSj3DcXe6ByJTaEmiaQr4gykzvtoe/W4tETuGiVuhucBps4okhRaaMOfXKC1VPyY9iT4I8AReflZj/0cwlsArk4zuqa/oG2OC5Z5Q8c1zKYesg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759734425; c=relaxed/simple;
	bh=DVLXBfPO9lbYlVA2Bt5MKNghmpfzsZO0q/+OS9hm7K0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i1J57JGj4tlame/nKIOjDvpCmvgGKSDR11G/pPWpWopKDZBUKgOhSW0bZBRCsiP5oq+//JferUCWWEDEUD/YKF6exk9FLBkdsECJGD72T1+WO/RrADwdg4pp7e14KBFCtgm6yAjptaxsItBrJmwsjCuo8vEjJtgnSaD/w+TM8qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KOFqAT6d; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jq82I6oB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KOFqAT6d; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jq82I6oB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KOFqAT6d";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jq82I6oB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KOFqAT6d";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jq82I6oB"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 547681F452;
	Mon,  6 Oct 2025 07:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759734422; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oP3UsHdmvZZg2BnSoii0Bd2ao3x3KjJ/fBBje+gstLY=;
	b=KOFqAT6dgH5Y/JPsRtkpPDue7QonGFTvu9lUd7Nlvn3G2wLIftEfTUDInks6R1AOUM/XKn
	/FP9ZhvHkQCFpWi3VrIpoiUDd/73BQ9XcrFvktrQ74ihvMoStQlmzgC04rr5yXx94krdhw
	mlu78n4B2oDCxrYYSLi/pb1WjVfKw4A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759734422;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oP3UsHdmvZZg2BnSoii0Bd2ao3x3KjJ/fBBje+gstLY=;
	b=jq82I6oB1oqjSg/lQnFqlJwjeiI+AvJwUxsh8dhDfDtcM1y9AxcEIni53fkFk+pX7To8gp
	Aydi5kJNGQSphCBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KOFqAT6d;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jq82I6oB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759734422; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oP3UsHdmvZZg2BnSoii0Bd2ao3x3KjJ/fBBje+gstLY=;
	b=KOFqAT6dgH5Y/JPsRtkpPDue7QonGFTvu9lUd7Nlvn3G2wLIftEfTUDInks6R1AOUM/XKn
	/FP9ZhvHkQCFpWi3VrIpoiUDd/73BQ9XcrFvktrQ74ihvMoStQlmzgC04rr5yXx94krdhw
	mlu78n4B2oDCxrYYSLi/pb1WjVfKw4A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759734422;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oP3UsHdmvZZg2BnSoii0Bd2ao3x3KjJ/fBBje+gstLY=;
	b=jq82I6oB1oqjSg/lQnFqlJwjeiI+AvJwUxsh8dhDfDtcM1y9AxcEIni53fkFk+pX7To8gp
	Aydi5kJNGQSphCBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 23B5813995;
	Mon,  6 Oct 2025 07:07:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 03NDB5Zq42icEwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 06 Oct 2025 07:07:02 +0000
Message-ID: <8fe51d05-6d25-4419-86d5-ce383b044796@suse.de>
Date: Mon, 6 Oct 2025 09:07:01 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/9] scsi: sd: Remove checks for -EOVERFLOW in
 sd_read_capacity()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-6-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251002192510.1922731-6-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 547681F452
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.51

On 10/2/25 21:25, Ewan D. Milne wrote:
> Remove checks for -EOVERFLOW in sd_read_capacity() because this value has not
> been returned to it since commit 72deb455b5ec ("block: remove CONFIG_LBDAF").
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/sd.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
