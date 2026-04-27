Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF73262FF8
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 08:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777277949; cv=none; b=oP/JQ+aA27atsefVzD+tcw56qAs+NhqucFjzVqhbWCDTW9c+zgd56x4UID6P7eVhXNFb55zFpZZjfYQ836J8PagNf1VbpH9cR87yMV9U0mU2/qyMHsQDFUVX32HhRQsjJr+NjPdwURsw6zfzD5oXZDsWAy6sogrsGtGKNDcHjY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777277949; c=relaxed/simple;
	bh=VxJIui09AJ6oHOHuA4RadQdqgIHcwg/3HugUUCvdsd4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sc3yzdmGPSqC/Cdz6ahJgMaEQ9WXRDgReaI7vtnk6pVG3jmFlz4nWWevBYAxxCnmnlU3seglXve6Yv3LF4i5tc6cf1xUhqEjrqO3bRHusRqX6CnDZAEVzc45ffRKYAF9ha2QlAiZX2OxDhkmQfn0zO64nth5tgKfxt7mnmg0Q0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0catHv1l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bTvFrtAf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0catHv1l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bTvFrtAf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0catHv1l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bTvFrtAf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0catHv1l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bTvFrtAf"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 059D95BCD5;
	Mon, 27 Apr 2026 08:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777277946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=svVhm3i6xXXCN6yHkhm6dbJoPdLVwFnqiMe6Xx5svqU=;
	b=0catHv1lzmhRGuxqbs7cq1xraI1KAiPHVT7Cp7C8LJcYonuvDyLSIMYBW40ZK+MOtZwHsF
	BsgBJfdvDNa/C8E6cgzyeR2uC4rxyxoxJpppcYvHtCtCgU0r3m4GrV8LDe/KLRu/VtMw0F
	+Pjg5LF4dwLza1I7YM+ffTJN68LjH24=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777277946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=svVhm3i6xXXCN6yHkhm6dbJoPdLVwFnqiMe6Xx5svqU=;
	b=bTvFrtAf2np6u2Xi0e2pQRzihMyt8I9akvzEo6Z9KsTyDBM8TN5cG8SJuoEBxEIyqOi/lo
	oLGIiM1SnanAfwAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0catHv1l;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bTvFrtAf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777277946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=svVhm3i6xXXCN6yHkhm6dbJoPdLVwFnqiMe6Xx5svqU=;
	b=0catHv1lzmhRGuxqbs7cq1xraI1KAiPHVT7Cp7C8LJcYonuvDyLSIMYBW40ZK+MOtZwHsF
	BsgBJfdvDNa/C8E6cgzyeR2uC4rxyxoxJpppcYvHtCtCgU0r3m4GrV8LDe/KLRu/VtMw0F
	+Pjg5LF4dwLza1I7YM+ffTJN68LjH24=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777277946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=svVhm3i6xXXCN6yHkhm6dbJoPdLVwFnqiMe6Xx5svqU=;
	b=bTvFrtAf2np6u2Xi0e2pQRzihMyt8I9akvzEo6Z9KsTyDBM8TN5cG8SJuoEBxEIyqOi/lo
	oLGIiM1SnanAfwAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D35A1593B0;
	Mon, 27 Apr 2026 08:19:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LU93MPkb72kQDgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 27 Apr 2026 08:19:05 +0000
Message-ID: <f258d6d3-813a-480c-a94b-4ed97c344994@suse.de>
Date: Mon, 27 Apr 2026 10:19:05 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] scsi: Add INQUIRY data field definitions and accessor
 helpers
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: Krishna Kant <krishna.kant@purestorage.com>
References: <20260424215324.99045-1-brian@purestorage.com>
 <20260424215324.99045-2-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260424215324.99045-2-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email,purestorage.com:email];
	FROM_HAS_DN(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 059D95BCD5

On 4/24/26 23:53, Brian Bunker wrote:
> Add well-documented inline functions and macros to parse INQUIRY data
> fields according to SPC-6 section 6.7.2. These helpers provide a
> consistent interface for extracting:
> 
> - Peripheral qualifier and device type from byte 0
> - Removable media bit from byte 1
> - Response data format from byte 3
> - Capability flags (WBUS16, SYNC, CMDQUE, SFTRE) from byte 7
> - Vendor, product, and revision strings
> 
> This is preparatory work for adding INQUIRY data update support during
> device rescan operations.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> ---
>   include/scsi/scsi.h | 171 ++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 171 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
