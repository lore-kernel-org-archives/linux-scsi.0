Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7154F2C158C
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jul 2025 09:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751965435; cv=none; b=FRKorQaWADx1IZMRrSHQ21EOO/3Qgn3vthayvDNSzGSRUnWy5+mpjwYcurGebELzaCuw1Sjv3t13E+/REHUlB8+UhHCEOPMvaju5F24afrk8KT1pez+oVYbobnMfWNr+sloNvba2MYHM9OWZdc6mTCWLnBWNMphFAVHvVD7p/Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751965435; c=relaxed/simple;
	bh=0VhMjdAc5BWgy6VKtS49JqjOTRORCegOKAUQAg6+f5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TrzT+g/zXlf4/nzFiDZ9z0ysN2rqJtmwWzRY/F7yA6g0gC10ub/CW0Ra82HhkAwWCONYvSEtQGwBZOhj0lFC4d8GNM4FwSrI/xOY/oEJfkHwvwZCCXcBXudVRz9Akdwm0C5YJWRFswiMER/rSWbDC2KTc6vmV+qEh8dBXtrqkm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fdtSnBqO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FGfHNlQV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Zbgsr3FC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Cp30S5FH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fdtSnBqO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FGfHNlQV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Zbgsr3FC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Cp30S5FH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B42791F458;
	Tue,  8 Jul 2025 09:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751965431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGmBMNHRD9l7XJGUWKE/LI//Xn/CqfF++O0jS/o3z4o=;
	b=fdtSnBqOYmhXVJEcxx3h9Sx3wzz+0Etgayp3/5m/WMBabKKLz2pGa9UJ49mX74CMEDCg5S
	gGRWLafIm0qQwn/hS9/HwuXv7sOZVlJcbCs01EhBBjP5xcAmUJB2N1tqosINXDtT/G0s4v
	v/+kZT42Xb7ID0P5FEIj5WEc/Gwd+lg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751965431;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGmBMNHRD9l7XJGUWKE/LI//Xn/CqfF++O0jS/o3z4o=;
	b=FGfHNlQVCDk1Fqa1COvyH7L3qHdKiBQ/acYIxbwTwOvIvTt3apGjtI2kO+/3we+VzjW4Cx
	n7N0o1Rd1P0rmGDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Zbgsr3FC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Cp30S5FH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751965429; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGmBMNHRD9l7XJGUWKE/LI//Xn/CqfF++O0jS/o3z4o=;
	b=Zbgsr3FCeZRBpKniqq5tjWDYeRY2VXHxxiUgS7pm+v0R762RtcuBTyJV//4DMJ1JCV4m+4
	vldEWbBTJd4Hy4I95ANqOEX/z2t959nPIf9/A0JNdwL0ymEUWUa99HM5jNMmK+wA0Nt77z
	aVWgbj0YL5WsB4oqcS3fdgv0yTpZuXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751965429;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGmBMNHRD9l7XJGUWKE/LI//Xn/CqfF++O0jS/o3z4o=;
	b=Cp30S5FH5kNus31ZKzo0Xs96St4CQS3lAG7QrQ75kc7iJfFTEUaDGoXxHxNbzr9aaU+ZW6
	NlJgn7jq1asN9tCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 79DBA13A70;
	Tue,  8 Jul 2025 09:03:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pwoiHfXebGgnYgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 08 Jul 2025 09:03:49 +0000
Message-ID: <08492c56-96f1-4515-b634-716c31768fc5@suse.de>
Date: Tue, 8 Jul 2025 11:03:49 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] scsi: fnic: Add and improve logs in FDMI and FDMI
 ABTS paths
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, jmeneghi@redhat.com, revers@redhat.com,
 dan.carpenter@linaro.org, stable@vger.kernel.org
References: <20250612002212.4144-1-kartilak@cisco.com>
 <20250612002212.4144-3-kartilak@cisco.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250612002212.4144-3-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_TWELVE(0.00)[16];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,cisco.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: B42791F458
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 6/12/25 02:22, Karan Tilak Kumar wrote:
> Add logs in FDMI and FDMI ABTS paths.
> Modify log text in these paths.
> 
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Reviewed-by: Arun Easi <aeasi@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
>   drivers/scsi/fnic/fdls_disc.c | 65 +++++++++++++++++++++++++++++++----
>   1 file changed, 58 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
