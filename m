Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F7E35947
	for <linux-scsi@vger.kernel.org>; Fri,  1 Aug 2025 06:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754029930; cv=none; b=Oai6mszfZHU/rUM9GxtpIfDr2HC88omw7JGHYlEA793nTsKwZo5t4wVGGqPRF6TBctE/2Gavl3M7IIkXZ4VCTifaj6kJZH/qV4eDulNUPxf/rZIVbv2V70g3LEB3FydqbKfc7Mg24EEdlohXThLarF+f8KNpqWiWfj2PbRNJlhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754029930; c=relaxed/simple;
	bh=qYfEsnHsYqyyufPgm3XCIWPjwwVl4nhfQizj7/kiJU0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=C2qIQaV96mWfrOhzlpzkkldK9ig2LQK2HFrsnAauv0aajiZIELdkgC67JjXVnKfy3VFBWVYZBmRbhWI440wC+fVNM+KUJ7AxeIUPax7knPcaCyV4zxFQhKmwHPJIDs2zMr3ZE8zxCJNjbAIsPjyz2h8gNjIF8lyeESOA9seEW3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kdfSnyvf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oJFuTwtH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kdfSnyvf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oJFuTwtH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kdfSnyvf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oJFuTwtH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kdfSnyvf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oJFuTwtH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EBB721F82D;
	Fri,  1 Aug 2025 06:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754029926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2arQc1Upxgf7RECc6u+h6dKDD/m7fziysFCTjK7l104=;
	b=kdfSnyvfytmTOrhbjRcc//qFx0VtJ4A6PbtZ6BfoK6p8qPB3CcLJKjO8Zeif3HNX9b8n2s
	6qCWrPlJQeO+w0cwLmbuspNGTDLcAbGGgjPcJke06kxcigtXGEgVQvoepTEDTZ5HFq6SqO
	3xrfErxQgKy0HetlFso4BN0+w+2gGsc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754029926;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2arQc1Upxgf7RECc6u+h6dKDD/m7fziysFCTjK7l104=;
	b=oJFuTwtHApV+3eAqGvE22eQOQ3Mfs8/SkBHUq2Sr/2zVb8oTCRqLGMj3MC/UPQbwQwHG6R
	T/UcOGL4c1IuohCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kdfSnyvf;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oJFuTwtH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754029926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2arQc1Upxgf7RECc6u+h6dKDD/m7fziysFCTjK7l104=;
	b=kdfSnyvfytmTOrhbjRcc//qFx0VtJ4A6PbtZ6BfoK6p8qPB3CcLJKjO8Zeif3HNX9b8n2s
	6qCWrPlJQeO+w0cwLmbuspNGTDLcAbGGgjPcJke06kxcigtXGEgVQvoepTEDTZ5HFq6SqO
	3xrfErxQgKy0HetlFso4BN0+w+2gGsc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754029926;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2arQc1Upxgf7RECc6u+h6dKDD/m7fziysFCTjK7l104=;
	b=oJFuTwtHApV+3eAqGvE22eQOQ3Mfs8/SkBHUq2Sr/2zVb8oTCRqLGMj3MC/UPQbwQwHG6R
	T/UcOGL4c1IuohCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4652138A5;
	Fri,  1 Aug 2025 06:32:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3tOzKWVfjGhgfwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 01 Aug 2025 06:32:05 +0000
Message-ID: <61d0b771-e602-4a14-b429-7d38113a1f99@suse.de>
Date: Fri, 1 Aug 2025 08:32:05 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] scsi: libsas: Refactor dev_is_sata()
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 John Garry <john.g.garry@oracle.com>
References: <20250724000235.143460-1-dlemoal@kernel.org>
 <20250724000235.143460-2-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250724000235.143460-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: EBB721F82D
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 7/24/25 02:02, Damien Le Moal wrote:
> Use a switch statement in dev_is_sata() to make the code more readable
> (and probably slightly better than a series of or conditions). Also have
> this inline function return a boolean instead of an integer.
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> ---
>   include/scsi/sas_ata.h | 17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
