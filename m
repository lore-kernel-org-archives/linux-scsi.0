Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18B21F09A8
	for <linux-scsi@vger.kernel.org>; Fri,  1 Aug 2025 06:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754030058; cv=none; b=YvF/wtJdbIInqh8KnDQJ3rcWfVJnOf6CuG3WpR7zVAIuGochyT3noG+iuuqW6cLSZO34h3/OVKxh1tJ4oM/4/f/hdM9lAEGya3vmHMF29X4HM3SWW2DF/HXRZ2CIWXgqschyGKRoNHwotJKY7TzO7kOmqulhGKsCcy+H/b5TZI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754030058; c=relaxed/simple;
	bh=AO9c/3rN64XZ6em2613tmeRzLlImspJg5wQeITZlvD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=okHyqVwMi/DxtydQVV8kP3JYpuFkOQjizVTGVvXU0wiAPEEB1D3pNOGubpEfYywbeUJDzY1cRzWBwnB1Ikwiq9jB9oW1INhOkFV3LcKTSzshPYv7N79s0t92Nyx5M1DcPJcZWxzPNe5Fvp++WUbykUrxb/L582ZcygG8yZngtng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aCEDvv+Y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9iXBdgOQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=m1uSbJzz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9PfCj9AG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aCEDvv+Y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9iXBdgOQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="m1uSbJzz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9PfCj9AG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D1B5521B8D;
	Fri,  1 Aug 2025 06:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754030055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YOrV/J2iFbeWmKl+Akmq1mHCAOYDVYboBWdqH597K0o=;
	b=aCEDvv+YMrM9wLq97IOBIVk/ZgrkSfO+Cnq8b/GuCCjvweL9Sf0JHaXxL0VgghmWCmNJHe
	SzgmyQy2bjxcgRkbb/0m2W2jq/dmbDST5b41zh/gpDKBOjAKbgu7GhrmOb2xtS5sB4OnzA
	vYVQR76GuOQ4uRr3/pO1D2fvkfqUhtI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754030055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YOrV/J2iFbeWmKl+Akmq1mHCAOYDVYboBWdqH597K0o=;
	b=9iXBdgOQbpLKjlHhQ1AvEuHNH+MQYFtopfETLCB04N3M60ykoW3a9rt9i0eqmXslUKjbBg
	AmsnCyQ3EkBcbmDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754030054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YOrV/J2iFbeWmKl+Akmq1mHCAOYDVYboBWdqH597K0o=;
	b=m1uSbJzzgAxwV0JVuVek8xHPGwmU7FehtdWrFmWbzD0OeYzBmRS+KU1yNx0XchOvo31Ojs
	sMYhYwnW8tTlS6H9m3OWdnE+8XwsRVZYTSzBvh+5BSoh7khFr4E5AT6wSofFr855eedTh5
	RuA/3MROPlJm7ZH+EUyHM1mfkaR+A/U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754030054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YOrV/J2iFbeWmKl+Akmq1mHCAOYDVYboBWdqH597K0o=;
	b=9PfCj9AG3tZ58+TKydQTA7dOdwZUR1XwEQC2x1NL026aXHAKlYg04iVmRdUj7CsW5Agvny
	1uOQwUlM23WqqPAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A7E6613876;
	Fri,  1 Aug 2025 06:34:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cAJoJ+ZfjGjufwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 01 Aug 2025 06:34:14 +0000
Message-ID: <581f624d-18d2-4e34-ab4b-a4c275b988c7@suse.de>
Date: Fri, 1 Aug 2025 08:34:14 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] scsi: libsas: Use a bool for sas_deform_port()
 second argument
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 John Garry <john.g.garry@oracle.com>
References: <20250724000235.143460-1-dlemoal@kernel.org>
 <20250724000235.143460-6-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250724000235.143460-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
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
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,oracle.com:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 7/24/25 02:02, Damien Le Moal wrote:
> Change the type of the "gone" argument of sas_deform_port() from int to
> bool. Simliarly, to be consistent, do the same change to the function
> sas_unregister_domain_devices().
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/libsas/sas_discover.c |  2 +-
>   drivers/scsi/libsas/sas_internal.h |  4 ++--
>   drivers/scsi/libsas/sas_phy.c      |  6 +++---
>   drivers/scsi/libsas/sas_port.c     | 13 ++++++-------
>   4 files changed, 12 insertions(+), 13 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
