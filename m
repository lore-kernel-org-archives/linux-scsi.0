Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B09431E0FE
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 12:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755693374; cv=none; b=jXMzInsNC0/OFsdasbHo4pp4m1IybQEXmMpEgZ8Svi8GuFtWjrQcJYCYu7Ce+Aly2NLTx5mW5LXGs2cpy7RahczTiy3wpCEa/3uBpMAhwk2Y1N2F5Si9lyrx+7EW9M+7D15gOe3bvgWBHnFRcpZgfw/h1XIq/z5m4hKj1YiSAUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755693374; c=relaxed/simple;
	bh=nW9zF19eM+UZPXhGPNJWm8JNNm2KRS3WZTLx0ySNRXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mJJo+QjLzIFIPM+XleaWOgjjfJ2oWgKgMQt5Dh9G4E+L9utCXPgTxvEKC5Oc55mqwwElXz9z63Lcd0dEMngSGDiFD+RalRL53A+Q2WYpigsP4ldGj/cV2wGkevr9uU+v+GiPnJ+YNDg+20izgCjl804J1/FwzCRcHk5nXjd9YTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TQVMuVpC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=t56Om1eR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TQVMuVpC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=t56Om1eR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TQVMuVpC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="t56Om1eR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TQVMuVpC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="t56Om1eR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 26C4D220DA;
	Wed, 20 Aug 2025 12:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755693371; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iLpLTpRvJaOxvEL+YZKwaaYSJzkfdyF2rtV0L9CdRX4=;
	b=TQVMuVpC/yUf/9lJ3ij5prP8mEseqzvaQR6MqSMGZnF84n6e22V4AWD5oRFpgbhWkYeYQp
	lwyiC8igxlBpVHyv8vNEDXFj2R8kRVNp2bUyaYRvmHvTUTReglAGcK4wmkkRdDZpcFo1WW
	z3mtyrGDAqdV/kYqEHWKPvuijU+gyf8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755693371;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iLpLTpRvJaOxvEL+YZKwaaYSJzkfdyF2rtV0L9CdRX4=;
	b=t56Om1eRc3hmzyioDn2MAMjlzePl/L0KrGf+TRlfhXQoAvVQg1uRFmL3ZGZmbsH3icNgun
	r1Q6yGagVeuNk8Cw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TQVMuVpC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t56Om1eR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755693371; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iLpLTpRvJaOxvEL+YZKwaaYSJzkfdyF2rtV0L9CdRX4=;
	b=TQVMuVpC/yUf/9lJ3ij5prP8mEseqzvaQR6MqSMGZnF84n6e22V4AWD5oRFpgbhWkYeYQp
	lwyiC8igxlBpVHyv8vNEDXFj2R8kRVNp2bUyaYRvmHvTUTReglAGcK4wmkkRdDZpcFo1WW
	z3mtyrGDAqdV/kYqEHWKPvuijU+gyf8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755693371;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iLpLTpRvJaOxvEL+YZKwaaYSJzkfdyF2rtV0L9CdRX4=;
	b=t56Om1eRc3hmzyioDn2MAMjlzePl/L0KrGf+TRlfhXQoAvVQg1uRFmL3ZGZmbsH3icNgun
	r1Q6yGagVeuNk8Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B004413867;
	Wed, 20 Aug 2025 12:36:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XW8LKjrBpWjaOAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 20 Aug 2025 12:36:10 +0000
Message-ID: <17230842-0a7a-403e-abc7-a15e3aa5d424@suse.de>
Date: Wed, 20 Aug 2025 14:36:10 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] scsi: scsi_error: Introduce new error handle
 mechanism
To: JiangJianJun <jiangjianjun3@huawei.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org,
 michael.christie@oracle.com, hch@infradead.org, haowenchao22@gmail.com,
 john.g.garry@oracle.com, hewenliang4@huawei.com, yangyun50@huawei.com,
 wuyifeng10@huawei.com, wubo40@huawei.com, yangxingui@h-partners.com
References: <20250816112417.3581253-1-jiangjianjun3@huawei.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250816112417.3581253-1-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,acm.org,oracle.com,infradead.org,gmail.com,huawei.com,h-partners.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 26C4D220DA
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 8/16/25 13:24, JiangJianJun wrote:
> It's unbearable for systems with large scale scsi devices share HBAs to
> block all devices' IOs when handle error commands, we need a new error
> handle mechanism to address this issue.
> 
> I consulted about this issue a year ago, the discuss link can be found in
> refenence. Hannes replied about why we have to block the SCSI host
> then perform error recovery kindly. I think it's unnecessary to block
> SCSI host for all drivers and can try a small level recovery(LUN based for
> example) first to avoid block the SCSI host.
> 
> The new error handle mechanism introduced in this patchset has been
> developed and tested with out self developed hardware since one year
> ago, now we want this mechanism can be used by more drivers.
> 
> Drivers can decide if using the new error handle mechanism and how to
> handle error commands when scsi_device are scanned,the new mechanism
> makes SCSI error handle more flexible.
> 
Hmm. Yes, and no.

I fully agree that SCSI EH is in need of reworking. But adding
another layer of complexity on top of the existing one ... not sure.

Additionally: TARGET RESET TMF is dead, and has been removed from SAM
since several years. It really is not worthwhile implementing.

Can't we take a simple step, and just try to have a non-blocking version
of device reset?
I think that should cover quite some issues already.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
