Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793778858;
	b=gsNzk4U8asO3DtJx0j1jlzR7DH6g5jfc8pexAGSsQxbH8u04i9JxxFqCEapArQW3/WGs
	 1+F9e0ZHN29F/DYSJjJzvdKYfj9I1ik2lZcZw5zt3Gh/r9S6zwZw1qUC+Cftvobcmygr/
	 Y/mV4rp4h2PZsSnbLzidQcS+Pl8/KPMeyeYaFe79J3B2PkaWayO1PjhTpuqCgIiOqicU4
	 MsN0GLb1EEVgE+GKhuX0n+bhwHNz4sTZYtMlW9r7rHFvqKwgTQXxR8UDvj9JmJhV0Tawf
	 A5J4YrkCkOehxV4V1ERcV2Gt92+jVWMXor1mb7IOUdXpmvGNW7UVXJBiqNY+xEV8uRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793778858;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=Rg9aAIu7FhuRa6Kpy4JuF4wN/YRyRuW/Q+hnaS20ifI=;
	b=bgjoD9uWg7gcN6QQ6wzvWn6oHkdRKDsJEMUD4cHEuuXcTrozjyzPId8smF+BMDikjML8
	 ZuV7zWQQxqShYBo2pFt395jvvkIEmDOmJNWCOj9vZF+jvDzAZgeMmLLvxJaY/dY2/4or3
	 qnR3QGi1GaZElrq6ic6YIAoz0WKtOJ/tNERQIk7O/s4tHMvZw97gDscX9W+Z6qD5pBJwe
	 ggYWo4Mu1qRlZMRKnvuycvQ9UfdYzwMKQHi/rAwhYTjDWyjsw5P6wN9dnOYWdaa6Zf8RL
	 azhHdpxSrAz4ICzvP3+w50RwenYuLrnZKDaJPmIucDkow2Wgr5wTN8jNxTMiCfz4ldQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=AvH9HUq9;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1mxo8ZPH;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=AvH9HUq9;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1mxo8ZPH;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCA4606A329
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 07:54:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BCA4606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=AvH9HUq9;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1mxo8ZPH;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=AvH9HUq9;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1mxo8ZPH
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7723D21F26;
	Wed,  4 Nov 2026 07:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793778856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rg9aAIu7FhuRa6Kpy4JuF4wN/YRyRuW/Q+hnaS20ifI=;
	b=AvH9HUq9+BHSMfL2y72LwuylmstfrwDXpFBKJol5uvGnii1G7psKbl+VXvmDW+2p7rHGRI
	GaAWCdUaQkLYEm4LfUO81kquYgU3YvNIFFVuvElQ1v3wEbTHjejFKpHMLw4ayqffxyuc0q
	6bvcMlLkSKTxDx+CS8sIVW0RNqmpWhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793778856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rg9aAIu7FhuRa6Kpy4JuF4wN/YRyRuW/Q+hnaS20ifI=;
	b=1mxo8ZPHGM/0fWt1qle+2QgN3q69+f4nU1TP+ycrM/YOHc5bzmhxlS/fJ9vcp29g+8OKBW
	ihSTYyLi3LouEhDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AvH9HUq9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1mxo8ZPH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793778856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rg9aAIu7FhuRa6Kpy4JuF4wN/YRyRuW/Q+hnaS20ifI=;
	b=AvH9HUq9+BHSMfL2y72LwuylmstfrwDXpFBKJol5uvGnii1G7psKbl+VXvmDW+2p7rHGRI
	GaAWCdUaQkLYEm4LfUO81kquYgU3YvNIFFVuvElQ1v3wEbTHjejFKpHMLw4ayqffxyuc0q
	6bvcMlLkSKTxDx+CS8sIVW0RNqmpWhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793778856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rg9aAIu7FhuRa6Kpy4JuF4wN/YRyRuW/Q+hnaS20ifI=;
	b=1mxo8ZPHGM/0fWt1qle+2QgN3q69+f4nU1TP+ycrM/YOHc5bzmhxlS/fJ9vcp29g+8OKBW
	ihSTYyLi3LouEhDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0FBE9134A5;
	Wed,  4 Nov 2026 07:54:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OF5SNafk6mouVAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 04 Nov 2026 07:54:16 +0000
Message-ID: <cb17860c-5388-431a-8734-b66dd1efffc4@suse.de>
Date: Wed, 4 Nov 2026 08:54:15 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: myrb: unregister the SCSI host on remove
To: Wentao Liang <vulab@iscas.ac.cn>, Hannes Reinecke <hare@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
References: <20261104021419.1468133-1-vulab@iscas.ac.cn>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261104021419.1468133-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7723D21F26
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[iscas.ac.cn:email,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -13.50

On 11/4/26 3:14 AM, Wentao Liang wrote:
> scsi_add_host() takes a reference on the host device that is only
> dropped by scsi_remove_host() when the host and its children are
> unregistered.  myrb_remove() goes straight to myrb_cleanup(), which only
> drops the reference taken by scsi_host_alloc(), so the host stays
> registered after the PCI device is removed and the memory behind it is
> leaked.
> 
> Call scsi_remove_host() before tearing the controller down so that no
> new commands are queued and the host is unregistered.
> 
> Fixes: 081ff398c56c ("scsi: myrb: Add Mylex RAID controller (block interface)")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>   drivers/scsi/myrb.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index 95df6e5345f7..e43d86f139c1 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c
> @@ -3496,6 +3496,7 @@ static void myrb_remove(struct pci_dev *pdev)
>   {
>   	struct myrb_hba *cb = pci_get_drvdata(pdev);
>   
> +	scsi_remove_host(cb->host);
>   	shost_printk(KERN_NOTICE, cb->host, "Flushing Cache...");
>   	myrb_exec_type3(cb, MYRB_CMD_FLUSH, 0);
>   	myrb_cleanup(cb);

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
