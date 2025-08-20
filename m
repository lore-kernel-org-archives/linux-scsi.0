Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C212E2678
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 11:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755690271; cv=none; b=DZ/jHyFmBbCQGVowamewbxQeDLrWxPTET5dQ8A+vzyczBjIT4lAjVmbAYJJYtcqggDu2oBJvPHxgz42gOimkqKdiwpftMCPFtvN6L20UZQXJ8hDphzap6nsfTfkcG61YeGmUC8edleS8xsBapt8QYdAQcxYTsv/cLTa1cX+Ntkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755690271; c=relaxed/simple;
	bh=RLit+JAS9oIlgky0s9B0b7LN7U/Y1/x2tiXB1vFAi+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pU426DxqQeCTuyefFTsFUasVdburHI/ra9ziEZRuNUspfj/RMm1N3ZiEIcXaFqeh9zEqUVkEpG1SRiwwCGotr0Jp0XledJu19qKCMqBxKoira3plwUW7I1mRjkq7nXregg2i/EMXYkvwFnb1zbeESNHYi9um8+ijyJTEeXQS4D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xXdMSmX5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SNWV9Cfz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xXdMSmX5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SNWV9Cfz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xXdMSmX5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SNWV9Cfz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xXdMSmX5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SNWV9Cfz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2D56E2117D;
	Wed, 20 Aug 2025 11:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755690268; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fU9rAsa/t9RNKTtbC8upyaRlPZKTE1/Kx84IxxvlQsE=;
	b=xXdMSmX5u8SleuHx68dJguOBPpcNiso6N6kJjzcDbtmI3EHH8PsCKzj2/M1JcE0lCbXBuG
	/qOElhCvgwy0aKMI3ZcBZfPwlOyq3DRCCCz9m1pbfd6JBfAZHRrVEnYZl4hzPqmU0piuPC
	nI30sH74IingF0fjgzZU13t/NC2YRcA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755690268;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fU9rAsa/t9RNKTtbC8upyaRlPZKTE1/Kx84IxxvlQsE=;
	b=SNWV9Cfzd2sVLFht0A9KEx+mcTkmcIZXIdfzgZNTXDpjhum4rTukJ+ElvXSdMgj9Z9aUhA
	2ZXqH5Kug0K12zCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755690268; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fU9rAsa/t9RNKTtbC8upyaRlPZKTE1/Kx84IxxvlQsE=;
	b=xXdMSmX5u8SleuHx68dJguOBPpcNiso6N6kJjzcDbtmI3EHH8PsCKzj2/M1JcE0lCbXBuG
	/qOElhCvgwy0aKMI3ZcBZfPwlOyq3DRCCCz9m1pbfd6JBfAZHRrVEnYZl4hzPqmU0piuPC
	nI30sH74IingF0fjgzZU13t/NC2YRcA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755690268;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fU9rAsa/t9RNKTtbC8upyaRlPZKTE1/Kx84IxxvlQsE=;
	b=SNWV9Cfzd2sVLFht0A9KEx+mcTkmcIZXIdfzgZNTXDpjhum4rTukJ+ElvXSdMgj9Z9aUhA
	2ZXqH5Kug0K12zCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 18D251368B;
	Wed, 20 Aug 2025 11:44:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uQqeBRy1pWiAKAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 20 Aug 2025 11:44:28 +0000
Message-ID: <9870ad90-6200-43b8-bc8d-eab93459108a@suse.de>
Date: Wed, 20 Aug 2025 13:44:27 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/8] scsi: Simplify nested if conditional in
 scsi_probe_lun()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-8-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250815211525.1524254-8-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 8/15/25 23:15, Ewan D. Milne wrote:
> Make code congruent with similar code in read_capacity_16()/read_capacity_10().
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/scsi_scan.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
