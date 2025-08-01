Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D67BA27
	for <linux-scsi@vger.kernel.org>; Fri,  1 Aug 2025 06:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754030031; cv=none; b=eeyHYD3x5jkljFYzanXUckqm5SI4c1L/PL2uyJb9v5k64Sh9H795nBAaw6crbEwkV7OxdBNcPcMwE5X1CbJ9mPzm1oCoyy4HLgjHfCXX0NHeJtUerRkpTiQMKByOuOh1QodILdghN+7WGrpQlssBV69CK4fP0KPsv7OnNekNpYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754030031; c=relaxed/simple;
	bh=bE6E7fiJPfD9sqhoO/cK3fzGSKFcJALpGTwBbH34bNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XxZDXax4gQmrSGIWloKTPgGN5HT6DjsRz+v6ghBfuy5bc/kd1z2hn7wXfFSSANhLPlT7rKHxmRL8qU8xHTJ0K043vZ+9RgPGC43CnZPSooNMDNWOKA649S/Z77hfyw47Z9ecDd+UhWbY3hKutP9N/vLjQj8UqLipprEBNYltDkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VyuOxX82; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=msVM0sAN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VyuOxX82; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=msVM0sAN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VyuOxX82";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="msVM0sAN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VyuOxX82";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="msVM0sAN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A04C121B8D;
	Fri,  1 Aug 2025 06:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754030027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RCuitl0g2ojk1TtMucHNQITkCUuAbV3RNqyWZ4vlUU8=;
	b=VyuOxX82Zv8MMznnjRwJnTz/a8Pr2ZQz32aV92hYk1ryRuhmnRiKM1jeFutvMb0TqjPG7S
	Hid5dyFbhuDRT6GGu8XOzZO9fG3Us5gNwjbOiu6NCNs/ZOjS6HdIwdRtdN+X9iQaAJ3r25
	h1sp+UM1KJqRgcwCxAq5bDsopA6pg0U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754030027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RCuitl0g2ojk1TtMucHNQITkCUuAbV3RNqyWZ4vlUU8=;
	b=msVM0sAN/U3eNcEdmT+L5K9iYV+WI8Rcq8HJuTnSp9DvFAvWM56+ZWZnaiaXPAb673hn3y
	e0l3fSBr14yDmWDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VyuOxX82;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=msVM0sAN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754030027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RCuitl0g2ojk1TtMucHNQITkCUuAbV3RNqyWZ4vlUU8=;
	b=VyuOxX82Zv8MMznnjRwJnTz/a8Pr2ZQz32aV92hYk1ryRuhmnRiKM1jeFutvMb0TqjPG7S
	Hid5dyFbhuDRT6GGu8XOzZO9fG3Us5gNwjbOiu6NCNs/ZOjS6HdIwdRtdN+X9iQaAJ3r25
	h1sp+UM1KJqRgcwCxAq5bDsopA6pg0U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754030027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RCuitl0g2ojk1TtMucHNQITkCUuAbV3RNqyWZ4vlUU8=;
	b=msVM0sAN/U3eNcEdmT+L5K9iYV+WI8Rcq8HJuTnSp9DvFAvWM56+ZWZnaiaXPAb673hn3y
	e0l3fSBr14yDmWDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 74DBF138A5;
	Fri,  1 Aug 2025 06:33:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l8VxGstfjGjYfwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 01 Aug 2025 06:33:47 +0000
Message-ID: <ad3a2fa8-ca7d-447b-90c1-aa1c2bda6751@suse.de>
Date: Fri, 1 Aug 2025 08:33:47 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/5] scsi: libsas: Move declarations of internal
 functions to sas_internal.h
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 John Garry <john.g.garry@oracle.com>
References: <20250724000235.143460-1-dlemoal@kernel.org>
 <20250724000235.143460-5-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250724000235.143460-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,oracle.com:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: A04C121B8D
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 7/24/25 02:02, Damien Le Moal wrote:
> Move the declaration of all functions used only within libsas from
> include/scsi/sas_ata.h to drivers/scsi/libsas/sas_internal.h.
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/libsas/sas_internal.h | 74 ++++++++++++++++++++++++++++++
>   include/scsi/sas_ata.h             | 68 +--------------------------
>   2 files changed, 75 insertions(+), 67 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
