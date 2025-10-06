Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0034419DF6A
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 07:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759734641; cv=none; b=b+yJmRjEHY84RK2hl3zNDlWXxMbAK2aHJ+3dbhnX/lX357MGlaYp+SLz13PtvoFZeZxxbDcLGwgRQZ/JzBra+mYxij9v27QYo0L/OkHkq//+X7bIM5K2O/TvayarMxXZ3EnKfd635tFjOllbDWSb1djmZY5JT2uSOFpR+qG3dQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759734641; c=relaxed/simple;
	bh=cD5Kku7TtIbRFrM+oBM8SZg4AOqBxPN0c1aJ1tEHM+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tl99I2g++ltBxwxQTNlbPuFvdjTPRTdMw6gRycOfLVDlL0gFCfuQyslyPC/wx4GekoWTtQaDWM15jesI01gAaT7BB6UWla6nAI0NLdCsVz/zaG3w2PiPnT4vQMlYeUo1dAET4Y6q2exr6ZsdNVWqCEcx4XcO8miE7WRSA15e3p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mrhfGbS1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=J2guy6XE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mrhfGbS1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=J2guy6XE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mrhfGbS1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="J2guy6XE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mrhfGbS1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="J2guy6XE"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 14369336CB;
	Mon,  6 Oct 2025 07:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759734638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=exn3pIDRTW0hYTCRhMDn6iKk1ZpPF/8hzJCW4kaeOvI=;
	b=mrhfGbS1bGMD85+dAEYAaiRHNwkuUelMVfsGICQbE59Q5wC55MwE3bZo33R3eihBi08+Fj
	r+FzRR1rS52Pq9D+ZVKUvKpjNK0H1E/tNjlef6si4VWyHCKid6bfHwZs3liqUEmTgYvyqV
	XJ3DrbIheVO113ZOEmtf3XLZX9thj5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759734638;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=exn3pIDRTW0hYTCRhMDn6iKk1ZpPF/8hzJCW4kaeOvI=;
	b=J2guy6XE+W7VpEMzQhb1clKgfO/Gu2YltkdfKT0OUA6u4AiEs2vBXs7qC4SiSi8CezazET
	5Em/XknMO/Qs0jDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mrhfGbS1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=J2guy6XE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759734638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=exn3pIDRTW0hYTCRhMDn6iKk1ZpPF/8hzJCW4kaeOvI=;
	b=mrhfGbS1bGMD85+dAEYAaiRHNwkuUelMVfsGICQbE59Q5wC55MwE3bZo33R3eihBi08+Fj
	r+FzRR1rS52Pq9D+ZVKUvKpjNK0H1E/tNjlef6si4VWyHCKid6bfHwZs3liqUEmTgYvyqV
	XJ3DrbIheVO113ZOEmtf3XLZX9thj5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759734638;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=exn3pIDRTW0hYTCRhMDn6iKk1ZpPF/8hzJCW4kaeOvI=;
	b=J2guy6XE+W7VpEMzQhb1clKgfO/Gu2YltkdfKT0OUA6u4AiEs2vBXs7qC4SiSi8CezazET
	5Em/XknMO/Qs0jDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C55E313700;
	Mon,  6 Oct 2025 07:10:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XwfrLW1r42h/FAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 06 Oct 2025 07:10:37 +0000
Message-ID: <915d81dc-eb77-4b8d-aca8-636f1a41a1e7@suse.de>
Date: Mon, 6 Oct 2025 09:10:37 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/9] scsi: sd: Check for and retry in case of
 READ_CAPCITY(10)/(16) returning no data
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-7-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251002192510.1922731-7-emilne@redhat.com>
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
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 14369336CB
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 10/2/25 21:25, Ewan D. Milne wrote:
> sd_read_capacity_10() and sd_read_capacity_16() do not check for underflow
> and can extract invalid (e.g. zero) data when a malfunctioning device does
> not actually transfer any data, but returns a good status otherwise.
> Check for this and retry the command.  Log a message and return -EINVAL if
> we can't get the capacity information.
> 
> We encountered a device that did this once but returned good data afterwards.
> 
> See similar commit 5cd3bbfad088 ("[SCSI] retry with missing data for INQUIRY")
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/sd.c | 59 ++++++++++++++++++++++++++++++++++++++++-------
>   1 file changed, 51 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index acd79e9a0d82..d1a366c9c99e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2638,6 +2638,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   		[13] = RC16_LEN,
>   	};
>   	struct scsi_sense_hdr sshdr;
> +	int count, resid;
>   	struct scsi_failure failure_defs[] = {
>   		/*
>   		 * Do not retry Invalid Command Operation Code or Invalid
> @@ -2688,6 +2689,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   	};
>   	const struct scsi_exec_args exec_args = {
>   		.sshdr = &sshdr,
> +		.resid = &resid,
>   		.failures = &failures,
>   	};
>   	int sense_valid = 0;
> @@ -2699,11 +2701,22 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   	if (sdp->no_read_capacity_16)
>   		return -EINVAL;
>   
> -	memset(buffer, 0, RC16_LEN);
> +	for (count = 0; count < 3; ++count) {
> +		memset(buffer, 0, RC16_LEN);
>   
> -	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
> -				      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,
> -				      &exec_args);
> +		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
> +					      buffer, RC16_LEN, SD_TIMEOUT,
> +					      sdkp->max_retries, &exec_args);
> +
> +		if (the_result || resid != RC16_LEN)
> +			break;
> +
> +		/*
> +		 * If the status was good but nothing was transferred,
> +		 * we retry. It is a workaround for some buggy devices
> +		 * or SAT which sometimes do not return any data.
> +		 */
> +	}
>   
>   	if (the_result > 0) {
>   		if (media_not_present(sdkp, &sshdr))
> @@ -2727,6 +2740,12 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   		return -EINVAL;
>   	}
>   
> +	if (resid == RC16_LEN) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "Read Capacity(16) returned good status but no data");
> +		return -EINVAL;
> +	}
> +
>   	sector_size = get_unaligned_be32(&buffer[8]);
>   	lba = get_unaligned_be64(&buffer[0]);
>   
> @@ -2759,11 +2778,17 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   	return sector_size;
>   }
>   
> +#define RC10_LEN 8
> +#if RC10_LEN > SD_BUF_SIZE
> +#error RC10_LEN must not be more than SD_BUF_SIZE
> +#endif
> +
>   static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   						unsigned char *buffer)
>   {
>   	static const u8 cmd[10] = { READ_CAPACITY };
>   	struct scsi_sense_hdr sshdr;
> +	int count, resid;
>   	struct scsi_failure failure_defs[] = {
>   		/* Do not retry Medium Not Present */
>   		{
> @@ -2798,17 +2823,29 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   	};
>   	const struct scsi_exec_args exec_args = {
>   		.sshdr = &sshdr,
> +		.resid = &resid,
>   		.failures = &failures,
>   	};
>   	int the_result;
>   	sector_t lba;
>   	unsigned sector_size;
>   
> -	memset(buffer, 0, 8);
> +	for (count = 0; count < 3; ++count) {
> +		memset(buffer, 0, RC10_LEN);
> +
> +		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
> +					      buffer, RC10_LEN, SD_TIMEOUT,
> +					      sdkp->max_retries, &exec_args);
> +
> +		if (the_result || resid != RC10_LEN)
> +			break;
>   
Hmm. What would happen if some data is returned, but less than the
expected amount?
We'd be having a hard time parsing that, wouldn't we?

So I guess we should check if we had received _all_ data, no?

> -	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
> -				      8, SD_TIMEOUT, sdkp->max_retries,
> -				      &exec_args);
> +		/*
> +		 * If the status was good but nothing was transferred,
> +		 * we retry. It is a workaround for some buggy devices
> +		 * or SAT which sometimes do not return any data.
> +		 */
> +	}
>   
>   	if (the_result > 0) {
>   		if (media_not_present(sdkp, &sshdr))
> @@ -2821,6 +2858,12 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   		return -EINVAL;
>   	}
>   
> +	if (resid == RC10_LEN) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "Read Capacity(10) returned good status but no data");
> +		return -EINVAL;
> +	}
> +
>   	sector_size = get_unaligned_be32(&buffer[4]);
>   	lba = get_unaligned_be32(&buffer[0]);
>   

Similar here. I would assume that _any_ resid value larger than zero 
would render thecapacity value unreliable...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
