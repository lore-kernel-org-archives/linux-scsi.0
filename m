Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAA1195811
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 09:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778664804; cv=none; b=Cql/3EQ14JFWEdJkm2ziZ0Axmpw32TewBh0f0JjRJ5lM7X4Lx/RRtrgX/3krgr+aj3KNHsJGwJN6F2BPxm0Q0ZssaJZhm43ie7dN/yj2dyT1YJh81B1bwIedLn+uMoGyTy9EjTe54hfcJfLJPiFkCyMfsVXG5pf84Pc4KOcHRdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778664804; c=relaxed/simple;
	bh=KCczcFCjmBVah/yS92g0+cg0d++Ut96MkboRr+1smns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kcjt5LAQpkkVBg0LA2eupZWtT2ai163fRXlG5fvmTiMd1c3FDoOlhsU4SCdvctf8aajdpG8rdBqp3nNKwf+8eJh8fMI474fKBpuVQnZJcAxF0DCalTn3Ad2riTC98nb6D2I4bfBs9SE5+uDzErV8LoFna/bki9ryNUzH9eN+6/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lAgoYuTl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=njCJsir+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lAgoYuTl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=njCJsir+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lAgoYuTl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="njCJsir+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lAgoYuTl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="njCJsir+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5625F762A7;
	Wed, 13 May 2026 09:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778664801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xPJgvyrjAJ3c7KyA/gZhs5GsWCx9BwOBQLFMGatGHQ=;
	b=lAgoYuTlpPiB8XhM5yqfA03bCAWzCUUdxd/uDdXkXQCNilQM9TAp/ibul7M/AT8CFmFEJC
	VnpAABWz9wkWSjBNuyBWhzW9vmYrtT4L/SPZ9UqV8dMVzCVah0RnzBe+PkqRP6V31LOyk/
	ObqakOzG5KWlNfNByUeNsxjs46t8wP0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778664801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xPJgvyrjAJ3c7KyA/gZhs5GsWCx9BwOBQLFMGatGHQ=;
	b=njCJsir+MzRHS3jciAIHbTVarCS6QxSz3+u/C9O2L8PnenBE5zmRqwXNkO7pDteRgG9peg
	wdGgJY1fyytxF3Bg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778664801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xPJgvyrjAJ3c7KyA/gZhs5GsWCx9BwOBQLFMGatGHQ=;
	b=lAgoYuTlpPiB8XhM5yqfA03bCAWzCUUdxd/uDdXkXQCNilQM9TAp/ibul7M/AT8CFmFEJC
	VnpAABWz9wkWSjBNuyBWhzW9vmYrtT4L/SPZ9UqV8dMVzCVah0RnzBe+PkqRP6V31LOyk/
	ObqakOzG5KWlNfNByUeNsxjs46t8wP0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778664801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xPJgvyrjAJ3c7KyA/gZhs5GsWCx9BwOBQLFMGatGHQ=;
	b=njCJsir+MzRHS3jciAIHbTVarCS6QxSz3+u/C9O2L8PnenBE5zmRqwXNkO7pDteRgG9peg
	wdGgJY1fyytxF3Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 421C1593A9;
	Wed, 13 May 2026 09:33:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UD5lD2FFBGrpbQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 13 May 2026 09:33:21 +0000
Message-ID: <dc50e8ba-9c5b-41e9-8549-bde33a05f64a@suse.de>
Date: Wed, 13 May 2026 11:33:20 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: core: Convert inquiry information
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
 Damien Le Moal <dlemoal@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260512194634.58145-1-bvanassche@acm.org>
 <20260512194634.58145-3-bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260512194634.58145-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email,acm.org:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 5/12/26 21:46, Bart Van Assche wrote:
> Currently the vendor, model, and revision members of struct scsi_device
> are pointers to fixed-length strings that are not NUL-terminated.
> Fixed-precision format specifiers (e.g., "%.8s") are required whenever
> they are printed and strncmp() must be used to compare these fields.
> This is error-prone.
> 
> Convert these fields to fixed-size character arrays within struct
> scsi_device. Remove an !sdev->model check because sdev->model is now
> guaranteed not to be NULL.
> 
> This patch fixes a bug in the qla2xxx driver. It makes the following
> code safe:
> 
> 		if (state_flags & BIT_4)
> 			scmd_printk(KERN_WARNING, cp,
> 			    "Unsupported device '%s' found.\n",
> 			    cp->device->vendor);
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/hwmon/drivetemp.c  |  5 +----
>   drivers/scsi/scsi_scan.c   | 12 ++++++------
>   include/scsi/scsi_device.h |  7 ++++---
>   3 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
> index 002e0660a0b8..efe8b229bdbe 100644
> --- a/drivers/hwmon/drivetemp.c
> +++ b/drivers/hwmon/drivetemp.c
> @@ -306,13 +306,10 @@ static bool drivetemp_sct_avoid(struct drivetemp_data *st)
>   	struct scsi_device *sdev = st->sdev;
>   	unsigned int ctr;
>   
> -	if (!sdev->model)
> -		return false;
> -
>   	/*
>   	 * The "model" field contains just the raw SCSI INQUIRY response
>   	 * "product identification" field, which has a width of 16 bytes.
> -	 * This field is space-filled, but is NOT NULL-terminated.
> +	 * This field is space-filled and NUL-terminated.
>   	 */
>   	for (ctr = 0; ctr < ARRAY_SIZE(sct_avoid_models); ctr++)
>   		if (!strncmp(sdev->model, sct_avoid_models[ctr],
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index ef22a4228b85..6c3a5d451c1d 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -292,9 +292,9 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   	if (!sdev)
>   		goto out;
>   
> -	sdev->vendor = scsi_null_device_strs;
> -	sdev->model = scsi_null_device_strs;
> -	sdev->rev = scsi_null_device_strs;
> +	strscpy(sdev->vendor, scsi_null_device_strs);
> +	strscpy(sdev->model, scsi_null_device_strs);
> +	strscpy(sdev->rev, scsi_null_device_strs);
>   	sdev->host = shost;
>   	sdev->queue_ramp_up_period = SCSI_DEFAULT_RAMP_UP_PERIOD;
>   	sdev->id = starget->id;
> @@ -905,9 +905,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   	if (sdev->inquiry == NULL)
>   		return SCSI_SCAN_NO_RESPONSE;
>   
> -	sdev->vendor = (char *) (sdev->inquiry + 8);
> -	sdev->model = (char *) (sdev->inquiry + 16);
> -	sdev->rev = (char *) (sdev->inquiry + 32);
> +	strscpy(sdev->vendor, sdev->inquiry + 8);
> +	strscpy(sdev->model, sdev->inquiry + 16);
> +	strscpy(sdev->rev, sdev->inquiry + 32);
>   
>   	sdev->is_ata = strncmp(sdev->vendor, "ATA     ", 8) == 0;
>   	if (sdev->is_ata) {


Question is whether we shouldn't make this generic, ie treat 'inquiry'
as a temporary blob, copy things over to fields in 'sdev', and then
free the 'inquiry' blob again.
There are soo many things tacked onto the standard inquiry data 
(especially for storage array trying to mimic SCSI-2 inquiry data),
that we're better of copying over only fields which we _know_.
_And_ it'll save us a permanent data allocation for the scsi device...

Hmm?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
