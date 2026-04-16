Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ADF248F73
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 06:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776320741; cv=none; b=YJiODd7uwgoYU5ZUVvTYdle5a86pLV+Xqdz78vW7h3tGEABQ79TzXGys/NOeeWuuQ/K1kLyCNaALHFyecprRDzARu8WJlt/mmn61qPQ3guu9LxxStF0iXd9S+FuzVm9RhkVXT/yvV1jN5HHFCkCDniRueUpfw3e3DkYNeQYpXZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776320741; c=relaxed/simple;
	bh=uL8pXLxqHOfdW0/zFuD4h4xrVMsv53pczrqAkVPPFXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZAwBan3cvGsyw2Q0Gbu6/TrgwxPqpBktUH2rKp2w3+PxoEGtB15zeGgIzg13cn6ZBwa8o3vPIEEyydwTqcJwcHPgOuwPWd+lEw7VYtwDQRS3JZ0eduW+7pMaUh/INu8RJ59h0LFASuIzzS+Gc6dvkxSy7DziW9S6Tmh96ILPG5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=krmuhEW8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZAKgUhN9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=krmuhEW8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZAKgUhN9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="krmuhEW8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZAKgUhN9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="krmuhEW8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZAKgUhN9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DF38F6A7EC;
	Thu, 16 Apr 2026 06:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776320738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R8+DrIgT3dsPnD5EYXcDOrsa7cNVKvqNZ9Bblqk19c0=;
	b=krmuhEW8QZ3PgY4+17Q0RVcmdgvWK/5Npejsy1GY1AWnq1om2dn75mj3Hc/LX3RFj9qhvR
	rQSwxrfnoBQSncedSxZCu0nptxAL+x/I7aVR0/wkLbgzw9crk5N/N0Es44ee/BcRtzV2zD
	qz7SesoTpJlf/D+hIVmbhp6MnkGC/lI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776320738;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R8+DrIgT3dsPnD5EYXcDOrsa7cNVKvqNZ9Bblqk19c0=;
	b=ZAKgUhN96tvosz0sh9TuhWHyNLknoVSXsHaDUqeN8aFEH4L/Vny+blpZtCwt9O4ZcBxZSr
	xlKZgkNaTOLTN6DQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=krmuhEW8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZAKgUhN9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776320738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R8+DrIgT3dsPnD5EYXcDOrsa7cNVKvqNZ9Bblqk19c0=;
	b=krmuhEW8QZ3PgY4+17Q0RVcmdgvWK/5Npejsy1GY1AWnq1om2dn75mj3Hc/LX3RFj9qhvR
	rQSwxrfnoBQSncedSxZCu0nptxAL+x/I7aVR0/wkLbgzw9crk5N/N0Es44ee/BcRtzV2zD
	qz7SesoTpJlf/D+hIVmbhp6MnkGC/lI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776320738;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R8+DrIgT3dsPnD5EYXcDOrsa7cNVKvqNZ9Bblqk19c0=;
	b=ZAKgUhN96tvosz0sh9TuhWHyNLknoVSXsHaDUqeN8aFEH4L/Vny+blpZtCwt9O4ZcBxZSr
	xlKZgkNaTOLTN6DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 89FB14BDFF;
	Thu, 16 Apr 2026 06:25:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SlvnH+GA4GkHMgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 16 Apr 2026 06:25:37 +0000
Message-ID: <dd40b0e9-b7fe-47c0-a7c7-fdbd3f6f6726@suse.de>
Date: Thu, 16 Apr 2026 08:25:36 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] sg: don't use GFP_ATOMIC in sg_start_req
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Doug Gilbert <dgilbert@interlog.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260415060813.807659-1-hch@lst.de>
 <20260415060813.807659-2-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260415060813.807659-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN_FAIL(0.00)[7.9.0.0.4.6.0.0.0.5.1.0.0.1.0.0.4.0.1.0.1.8.2.b.0.4.e.d.7.0.a.2.asn6.rspamd.com:server fail];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[wdc.com:email,suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	URIBL_BLOCKED(0.00)[wdc.com:email,lst.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: DF38F6A7EC
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 4/15/26 08:08, Christoph Hellwig wrote:
> sg_start_req is called from normal user context and can sleep when
> waiting for memory.  Switch it to use GFP_KERNEL, which fixes allocation
> failures seend with the bio_alloc rework.
> 
> Fixes: b520c4eef83d ("block: split bio_alloc_bioset more clearly into a fast and slowpath")
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>   drivers/scsi/sg.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 37bac49f30f0..43265f012ce9 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1811,7 +1811,7 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
>   	}
>   
>   	res = blk_rq_map_user_io(rq, md, hp->dxferp, hp->dxfer_len,
> -			GFP_ATOMIC, iov_count, iov_count, 1, rw);
> +			GFP_KERNEL, iov_count, iov_count, 1, rw);
>   	if (!res) {
>   		srp->bio = rq->bio;
>   
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
