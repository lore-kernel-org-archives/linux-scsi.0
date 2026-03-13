Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402BE34C9A3
	for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2026 07:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773386848; cv=none; b=soG62VVKSz+ZSVmcsEWydA7UcRRVFQawkBUoytPfLuNnDbMtEJqhi9ILAhCOHbkJbOdLNr4+TU9kg0l4q7qMxfdIKTwx6isgnS92vR2BJU56BfvBFsBDfnluUuQnRfW3+MGr6flRxLYsnYpeQHurolz8yEpckOkupLz1R9w0hxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773386848; c=relaxed/simple;
	bh=nZPUejzNrAkefoVwg6LcRK0u9rv96Cs2afDeNZj3ZXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ol/GHbpBJat1ypgtqPN5/9r+Edzw9AaTCtEPaLe+sTXPANsI5OHkGfWLBOCzqYF0nJhiPUn8e/HHXK416L9sSL9UgjZ4b8RHN2s3SrH7/aIjrI2Yrjc7SwqdPFYll/b2QJki0TxTb9q0jkO7niCeEyRT2a8jTWTKMyyqX0+z4ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=13rCpoGf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=razSU0PI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=13rCpoGf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=razSU0PI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="13rCpoGf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="razSU0PI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="13rCpoGf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="razSU0PI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7A5D74DAF5;
	Fri, 13 Mar 2026 07:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773386843; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIRG0Q/yVpHyaLAU9pL+Vyg4xtL6PGs8lb8PXQchdt0=;
	b=13rCpoGfAnjoME3eGB25p0kS8h+Ltq37cq5tW9tNbkG4AI3znzcB+OzAVAxgCBZaYyltTY
	lAvNuOckjZogaBoUZc/UjD7VvXTNTgvaxG3E2+U/6DUVL7hYbbt9KFK/O2MNrx+3UjOVa/
	aGP+yW3r5kck3P9TsoKOST3gXuZ9aqY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773386843;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIRG0Q/yVpHyaLAU9pL+Vyg4xtL6PGs8lb8PXQchdt0=;
	b=razSU0PISaW+d4P9HQ6Oa63i45jRZGfuIx8k0Ytrp3u65tjAZC03LZZdzAZb8mEI0kIHD+
	oA3vsYhuajOMk+BA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773386843; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIRG0Q/yVpHyaLAU9pL+Vyg4xtL6PGs8lb8PXQchdt0=;
	b=13rCpoGfAnjoME3eGB25p0kS8h+Ltq37cq5tW9tNbkG4AI3znzcB+OzAVAxgCBZaYyltTY
	lAvNuOckjZogaBoUZc/UjD7VvXTNTgvaxG3E2+U/6DUVL7hYbbt9KFK/O2MNrx+3UjOVa/
	aGP+yW3r5kck3P9TsoKOST3gXuZ9aqY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773386843;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIRG0Q/yVpHyaLAU9pL+Vyg4xtL6PGs8lb8PXQchdt0=;
	b=razSU0PISaW+d4P9HQ6Oa63i45jRZGfuIx8k0Ytrp3u65tjAZC03LZZdzAZb8mEI0kIHD+
	oA3vsYhuajOMk+BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4FF13403E1;
	Fri, 13 Mar 2026 07:27:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WtNjElu8s2kEAwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 13 Mar 2026 07:27:23 +0000
Message-ID: <99dd055b-c3ec-4235-b959-2869f5eacaf7@suse.de>
Date: Fri, 13 Mar 2026 08:27:18 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ses: Handle positive SCSI error from
 ses_recv_diag()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, stable <stable@kernel.org>
References: <2026022301-bony-overstock-a07f@gregkh>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <2026022301-bony-overstock-a07f@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 2/23/26 16:44, Greg Kroah-Hartman wrote:
> ses_recv_diag() can return a positive value, which also means that an
> error happened, so do not only test for negative values.
> 
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: stable <stable@kernel.org>
> Assisted-by: gkh_clanker_2000
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/scsi/ses.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 35101e9b7ba7..128042c734cc 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -215,7 +215,7 @@ static unsigned char *ses_get_page2_descriptor(struct enclosure_device *edev,
>   	unsigned char *type_ptr = ses_dev->page1_types;
>   	unsigned char *desc_ptr = ses_dev->page2 + 8;
>   
> -	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len) < 0)
> +	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len))
>   		return NULL;
>   
>   	for (i = 0; i < ses_dev->page1_num_types; i++, type_ptr += 4) {

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
