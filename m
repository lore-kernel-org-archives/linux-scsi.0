Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54933391513
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 14:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788792257; cv=none; b=KOGd3vyA41zl8mhHSd26CppiLXo58PG++5RDwiFFmQ2XFDqJ+8h9cOYrWk5oZT6AUlQShkIk1CJHfkx4WReWNAkpS9B52GWMCa0TArztH1CfhrIRKC9K5mycSTMfhti5qWMkGuSXn6v+XTCQhlYyfVtAX3oQ2fRJuDI4vKq4C3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788792257; c=relaxed/simple;
	bh=wSQ1BZSgi/JbIGg4lXW5OB3Xu/M7ypNK2qEMEacel7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jfo7ytWLY3HXuf4wBFGNWd9PLvTD0Rp3XF5tik6tV/KEuHWNFIewpef3YfB4AMBUfT4IrMVPg+cet08HcYeu4Uxkw4rCO6cbtn03fHNVoKpuB7h/Ddskhe7lPggx6ARRuZk2hfqb6PmBKWt6nBy9E2v1DRLGLdbNCDA5G+drVMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nFTsugav; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=H7UgEPSB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Jhv6wExU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NHg4RmS1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nFTsugav";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="H7UgEPSB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Jhv6wExU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NHg4RmS1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1B364219EE;
	Mon,  7 Sep 2026 14:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788792250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x6YPbeNUNHQJB/V3BBMjLt2GMhlZEPeCU/Lt7NHJYgI=;
	b=nFTsugavCYYvR9EqwjWVsEvCPsxlsQAUpBRdq+seoG4yadkspKZU8PowX2szbmb/b1x2Kd
	fH/VUhNoKmBnhEIwTVBA2cCfcXMp01Msgf0efDj3p55dB2kGvMZqXrjiD/k82BrT4NyQfv
	brPLfqGHyE28FW8fP/7QcWNGWaDJAo8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788792250;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x6YPbeNUNHQJB/V3BBMjLt2GMhlZEPeCU/Lt7NHJYgI=;
	b=H7UgEPSBKCgiOes1ncyScy3ouFZQx0qEa52HOJglCQgMdRlQskBYpDxmAS/wnj5hU0O+7l
	H4Kt4gFtggP9lqCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Jhv6wExU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NHg4RmS1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788792246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x6YPbeNUNHQJB/V3BBMjLt2GMhlZEPeCU/Lt7NHJYgI=;
	b=Jhv6wExUOjwJjYpT7HWB9/ZHE2ktR3PjQCPfbC9I5FRkoiSD6g28Pss/7HgMJsefJnS9tE
	fCMbmJ1XCZ9vK3P1ZTkYyWyhckROdLdFYQJ6OI6RCDIcv0Zr7ugt3L7pvFOS1bvOQpq81X
	+1prJBaqpJLUCBqu5m2ZGVqegRqw5sg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788792246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x6YPbeNUNHQJB/V3BBMjLt2GMhlZEPeCU/Lt7NHJYgI=;
	b=NHg4RmS18P0f6K+Q/JGX5nWfU3fT0Dx/J7ojrhlzODezgO4ywfxZmhTxwKZWLzwzk+dVu7
	pThcMEWvVFArLUDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C67271339B;
	Mon,  7 Sep 2026 14:44:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VHH5LrXNnmqaNgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 14:44:05 +0000
Message-ID: <f53edf7b-fc80-4815-a884-f03a25ab0527@suse.de>
Date: Mon, 7 Sep 2026 16:44:04 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: core: Eliminate
 scsi_log_{reserve,release}_buffer()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <cover.1788198780.git.bvanassche@acm.org>
 <c575754856db35fe70aa7a09f1c75b7efdf118fd.1788198780.git.bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <c575754856db35fe70aa7a09f1c75b7efdf118fd.1788198780.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 1B364219EE
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email,suse.de:mid];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

On 8/31/26 7:58 PM, Bart Van Assche wrote:
> The SCSI logging functions allocate a temporary buffer. This approach has
> multiple disadvantages:
>   - Runtime overhead.
>   - Truncation of log messages to 127 characters.
>   - Messages are discarded if buffer allocation fails.
> 
> Hence this patch that eliminates temporary buffer allocations. Instead,
> use struct va_format (%pV) and format directly with dev_printk().
> 
> Introduce sdev_tag_prefix_vprintk() and sdev_tag_prefix_printk() helper
> functions that emit dev_printk() messages with optional device name
> ([<name>]) and request tag (tag#<tag>) prefixes.
> 
> Convert sdev_prefix_printk(), scmd_printk(), scsi_print_command(),
> scsi_log_dump_sense(), scsi_log_print_sense_hdr(), and scsi_print_result()
> to use these helpers. Use the %*ph format specifier to format CDB and
> sense hex buffers directly.
> 
> Remove scsi_log_reserve_buffer(), scsi_log_release_buffer(), and
> sdev_format_header().
> 
> This patch has been generated by asking Gemini 3.7 to eliminate the
> scsi_log_*_buffer() functions from the scsi_logging.c file, followed by
> some minor manual improvements.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_logging.c | 263 ++++++++++++------------------------
>   1 file changed, 90 insertions(+), 173 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
> index 3bff4dea4c6a..0991e5cb305a 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -41,17 +41,6 @@ static void scsi_logging_dev_printk(const char *level, const struct device *dev,
>   	scsi_logging_dev_printk(level, dev, fmt, ##__VA_ARGS__)
>   #endif
>   
> -static char *scsi_log_reserve_buffer(size_t *len)
> -{
> -	*len = 128;
> -	return kmalloc(*len, GFP_ATOMIC);
> -}
> -
> -static void scsi_log_release_buffer(char *bufptr)
> -{
> -	kfree(bufptr);
> -}
> -
>   static inline const char *scmd_name(struct scsi_cmnd *scmd)
>   {
>   	const struct request *rq = scsi_cmd_to_rq(scmd);
> @@ -61,48 +50,57 @@ static inline const char *scmd_name(struct scsi_cmnd *scmd)
>   	return rq->q->disk->disk_name;
>   }
>   
> -static size_t sdev_format_header(char *logbuf, size_t logbuf_len,
> -				 const char *name, int tag)
> +static void __printf(5, 0)
> +sdev_tag_prefix_vprintk(const char *level, const struct scsi_device *sdev,
> +			const char *name, int tag, const char *fmt,
> +			va_list *args)
>   {
> -	size_t off = 0;
> +	const struct device *dev;
> +	struct va_format vaf = {
> +		.fmt = fmt,
> +		.va = args,
> +	};
>   
> -	if (name)
> -		off += scnprintf(logbuf + off, logbuf_len - off,
> -				 "[%s] ", name);
> +	if (!sdev)
> +		return;
>   
> -	if (WARN_ON(off >= logbuf_len))
> -		return off;
> +	dev = &sdev->sdev_gendev;
> +	if (name) {
> +		if (tag >= 0)
> +			dev_printk(level, dev, "[%s] tag#%d %pV", name, tag,
> +				   &vaf);
> +		else
> +			dev_printk(level, dev, "[%s] %pV", name, &vaf);
> +	} else {
> +		if (tag >= 0)
> +			dev_printk(level, dev, "tag#%d %pV", tag, &vaf);
> +		else
> +			dev_printk(level, dev, "%pV", &vaf);
> +	}
> +}
>   
But that would completely revert the idea of this patch; 'dev_printk' 
will always insert a newline after the string argument, and the whole 
point of this patch was that do _not_ want to have a newline here as we
want to print out several things before terminating the log message.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
