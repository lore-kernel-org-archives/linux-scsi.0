Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6BE14E2E8;
	Tue, 11 Jun 2024 06:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718086872; cv=none; b=EPiA25umQprIkp+IV1q0qEHJXI//WpRuB0Yvp9b/VOVG7B6EBuoL+jeGHf51Atb7KWP51H6Z4kQrDEMyG36T89wFxb89JkcB2mtcp95UDJYeesyhA7r+t+UyEqYDinu88l+RTj6Bf5Kxy8bs87CGSmWOovMjCrSjRBWxTEMrWA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718086872; c=relaxed/simple;
	bh=bYlESr7NAxJGTsxfcnhwofeEoamCNBinf2Ap8LaHhOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YEUIUZEqX7MYuFgSOkSxDfltXg4oTa8+m1Bf4ny9j5f8s31Zo3zzjRPcqgS/1h/1cK4FwdMXyn30rI4sHTxa6jOVt7t2TyBsdFTz7xgBorOlLGHFSr7DAt1m6elxliISKnrZWOcXNhkjgh+Rb78dv0HWJ13LRzEhQ3GyyBsTHCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gTTFlln4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=U0Y4yU7D; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gTTFlln4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=U0Y4yU7D; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gTTFlln4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="U0Y4yU7D";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gTTFlln4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="U0Y4yU7D"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3169522BED;
	Tue, 11 Jun 2024 06:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718086868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PDZYkb+FP2KV+wVc62w9KmO6xPmOW7tYKucglvP1hfc=;
	b=gTTFlln4onkivfLOlnvbRt8DOBwXqDjms+NEhc5OGHnmANrFPwOTbf5acoApnMvQxIXBs9
	jSAdpwy9G8+ucv6zfipB5goVvXInD6+ByZMJg4BICLlJQ3cvOIiYJ2x0gUZ+b3L5ZXjUG/
	Z/l3E7+vaA+LqhUOZlbSlFyKSEGDeeE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718086868;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PDZYkb+FP2KV+wVc62w9KmO6xPmOW7tYKucglvP1hfc=;
	b=U0Y4yU7Dj/tE4LfO2SKUSKw6cy9vZnxv9qK2o5Rf6DDYZjXeGUchlyIlC4iLc6gfuDSViy
	ppizFdMZIbl0NlAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gTTFlln4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=U0Y4yU7D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718086868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PDZYkb+FP2KV+wVc62w9KmO6xPmOW7tYKucglvP1hfc=;
	b=gTTFlln4onkivfLOlnvbRt8DOBwXqDjms+NEhc5OGHnmANrFPwOTbf5acoApnMvQxIXBs9
	jSAdpwy9G8+ucv6zfipB5goVvXInD6+ByZMJg4BICLlJQ3cvOIiYJ2x0gUZ+b3L5ZXjUG/
	Z/l3E7+vaA+LqhUOZlbSlFyKSEGDeeE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718086868;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PDZYkb+FP2KV+wVc62w9KmO6xPmOW7tYKucglvP1hfc=;
	b=U0Y4yU7Dj/tE4LfO2SKUSKw6cy9vZnxv9qK2o5Rf6DDYZjXeGUchlyIlC4iLc6gfuDSViy
	ppizFdMZIbl0NlAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71F34137DF;
	Tue, 11 Jun 2024 06:21:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Sb3nFNPsZ2ZmNwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 11 Jun 2024 06:21:07 +0000
Message-ID: <7913e2c2-e348-49bc-ad76-dffc4dc2acf7@suse.de>
Date: Tue, 11 Jun 2024 08:21:01 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: core: Pass sdev to blk_mq_alloc_queue()
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk,
 martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 himanshu.madhani@oracle.com
References: <20240524084829.2132555-1-john.g.garry@oracle.com>
 <20240524084829.2132555-2-john.g.garry@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240524084829.2132555-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 3169522BED
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-6.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]

On 5/24/24 10:48, John Garry wrote:
> When calling scsi_alloc_sdev() -> blk_mq_alloc_queue(), we don't pass
> the sdev as the queuedata, but rather manually set it afterwards. Just
> pass to blk_mq_alloc_queue() to have automatically set.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi_scan.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

