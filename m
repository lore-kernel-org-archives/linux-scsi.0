Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B024323C516
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 11:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755690245; cv=none; b=lozBQC0Lr1oL+S1Hfg4nhilzA4ImF7xsESnpNhmGqY/jnOUvf57eNZJfqnF/Mm/mBYKnDrJ0zRC/LCE516n+YfbqI4KZwpfE3UN44jwztCnX+V45wjTs6PkY4tIJ/9MKYeNJh+m9HCXWvGWGySLCwyFoUoPnQ7bGewCrZbANNU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755690245; c=relaxed/simple;
	bh=nroiMqU2YzFSnxIjkLdi+kTLiuiTFbS/bQ0jv1Smz34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=slQzfQ4RHCs0en417z9dtqlSJj8oLJivQ8uGQR9LJ3HQXwzuzjqWqpdL8DCnRYecHueBWqy6aEgfmRj6++AYQ54XuCvvyD2UuFddmRrrBam2jYTzWASJN5d6Ld/qbzhdc8aHduw4ZhMoodvtGND+IVqHpsG7H+93p2TXrme+4dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VoioTDDg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Zwq37t21; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VoioTDDg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Zwq37t21; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VoioTDDg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Zwq37t21";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VoioTDDg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Zwq37t21"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D47A41F834;
	Wed, 20 Aug 2025 11:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755690241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qp2HsK6gNMolMvGMBsSfurxYhfyonkVk7OP1hb+3+Q4=;
	b=VoioTDDg8RQMCA/5LL0mZR6o+g0Xirysf0boK2dlaw8bjqhpdcR/ZttQTdnawBSCKOG8aF
	+UzmafB4Dzfl2JFH7b6HPm/y9tk/0Mm9OLdDF/th4xnGEePeJUK+VHJJT/1/ml+phIlJc9
	dYjir+0/TEilvz1UX+hKWTplCggloFc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755690241;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qp2HsK6gNMolMvGMBsSfurxYhfyonkVk7OP1hb+3+Q4=;
	b=Zwq37t21/53xklASTw3IlAD67xRZYIqIv1lNm59jr/OX523k1bFlLIJ654yroA2XsK3O7e
	PKtWaPdSs62XcoCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755690241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qp2HsK6gNMolMvGMBsSfurxYhfyonkVk7OP1hb+3+Q4=;
	b=VoioTDDg8RQMCA/5LL0mZR6o+g0Xirysf0boK2dlaw8bjqhpdcR/ZttQTdnawBSCKOG8aF
	+UzmafB4Dzfl2JFH7b6HPm/y9tk/0Mm9OLdDF/th4xnGEePeJUK+VHJJT/1/ml+phIlJc9
	dYjir+0/TEilvz1UX+hKWTplCggloFc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755690241;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qp2HsK6gNMolMvGMBsSfurxYhfyonkVk7OP1hb+3+Q4=;
	b=Zwq37t21/53xklASTw3IlAD67xRZYIqIv1lNm59jr/OX523k1bFlLIJ654yroA2XsK3O7e
	PKtWaPdSs62XcoCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C06EB1368B;
	Wed, 20 Aug 2025 11:44:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nxeLLgG1pWhmKAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 20 Aug 2025 11:44:01 +0000
Message-ID: <235bf042-a790-4d5e-a504-3d499e29f6df@suse.de>
Date: Wed, 20 Aug 2025 13:44:01 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/8] scsi: sd: Check for and retry in case of
 READ_CAPCITY(10)/(16) returning no data
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-7-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250815211525.1524254-7-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 8/15/25 23:15, Ewan D. Milne wrote:
> sd_read_capacity_10() and sd_read_capacity_16() do not check for underflow
> and can extract invalid (e.g. zero) data when a malfunctioning device does
> not actually transfer any data, but returnes a good status otherwise.
> Check for this and retry, and log a message and return -EINVAL if we can't
> get the capacity information.
> 
> We encountered a device that did this once but returned good data afterwards.
> 
> See similar commit 5cd3bbfad088 ("[SCSI] retry with missing data for INQUIRY")
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/sd.c | 61 ++++++++++++++++++++++++++++++++++++++++-------
>   1 file changed, 53 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
