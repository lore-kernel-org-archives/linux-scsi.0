Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3044472559;
	Mon,  7 Sep 2026 12:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788783377; cv=none; b=JM3McZkAkUO0ARZEiaVs5zdDZzmUqMwClXTERMwb2IEzakpWBmDWm4/n15DWsytommlmOgw/5xq/sLpMAULiO4cRTi2e++RSbE1ZYIAJ3Z6HETAMWNWbXCbULBCUgpvKHwfPGEQhFMacRXkch5kwzYS9G6VX04BgBqfyOFA3G4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788783377; c=relaxed/simple;
	bh=O8tWzEFgoCl/ehZvklgum5NiaT70+RaWZq5/dY/SKto=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rbn9iKFygJXHAjRCxEsXjT1Qu6Qm0qa6fZx/24BzX3Smz/Di3ZiSZxxveeJ2n1HHMH0Hm63/eYxk2mpA5b//osGvr9yawMDZvxMLckBDZ4Djw4HOWByJ9qOJlYfKYPrnqj1Da5XkQRl2/rP//ngb/uIXwRsRYmY+b6afiy8iyUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Nw3rVugG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kW+GjAZR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hgKfXYmi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=k2AXIU2J; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Nw3rVugG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kW+GjAZR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hgKfXYmi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="k2AXIU2J"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5F314219E5;
	Mon,  7 Sep 2026 12:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788783369; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LC8fVDR9eGuYIXLQLBpJKPt9qmzdH8TaE7MZtrUgfWY=;
	b=Nw3rVugGKsDYSmuAAolI8amuAuNE4CY0+vVJMsKqc1vW7EBlnNua2SD43FBTgz5P5Jd0NI
	E+odcRpxiFIjvHUgIni0gZ9B2eq/av7SXWENt8wTLBEX7ZY7iOvdiaBkPoa2MjcU3fPMmi
	Cs6ihyB6KXJ+JUBrhnMf8BqlpuhcvIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788783369;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LC8fVDR9eGuYIXLQLBpJKPt9qmzdH8TaE7MZtrUgfWY=;
	b=kW+GjAZR5vfELzDcJbC7i/1HVLx31atwYtJvR55aHo5z5jHx39EqvSu8KUfMY1OWk+O9AX
	HNHy/fOUduVmyzAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hgKfXYmi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=k2AXIU2J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788783365; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LC8fVDR9eGuYIXLQLBpJKPt9qmzdH8TaE7MZtrUgfWY=;
	b=hgKfXYmi+S7MKlVQ6173DkfsLbYDaXoC/7L+4/XZvJqL7qDACDIDDhLaq5k7gWxgfeBNA4
	fLlORArcyqWU2EP++9MmP3DTLn1lGvLYAcVOAIjknCQS6d08r/HEkxcuY09rvhGpFomfcr
	NgOlDjIQHl1ZJYLP3N/HuLQfwD8c4zA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788783365;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LC8fVDR9eGuYIXLQLBpJKPt9qmzdH8TaE7MZtrUgfWY=;
	b=k2AXIU2Jf5Aq8G9NLCyOnkzS6XNUS+wdnF7BGdUDMvJuM7lQpQOU/JX9tfaN/zM1w3p0HW
	jaF9dHQ7dIKFRnBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E4CF31339B;
	Mon,  7 Sep 2026 12:16:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Y0UINgSrnmrUIgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:16:04 +0000
Message-ID: <cb08459f-ac72-4f37-b241-b4cc047f4890@suse.de>
Date: Mon, 7 Sep 2026 14:16:04 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/40] scsi: prepare for using 16-bits defined sense
 codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-6-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 5F314219E5
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> In preparation for handling sense codes and their qualifiers as a single
> 16-bits sense code field, with the values  defined as macros in
> include/scsi/scsi_sense.h, modify the definition of the structures
> scsi_failure and scsi_sense_hdr to introduce a 16-bits sense_code field
> as a union with the existing 8-bits asc and ascq fields.
> 
> This temporary modification allows accessing either the asc and ascq
> fields individually, or their combination as the 16-bits sense_code field.
> 
> The helper functions scsi_sense_asc(), scsi_sense_ascq() are defined to
> allow accessing the 8-bits ASC and ASCQ values from the sense_code filed
> of struct scsi_sense_hdr. The helper functions scsi_failure_asc() and
> scsi_failure_ascq() provide the same for the sense code field of struct
> scsi_failure.
> 
> The helper functions scsi_set_sense_buffer() and scsi_set_sense() are also
> added to wrap calls to scsi_build_sense_buffer() and scsi_build_sense()
> using a 16-bits sense code aregument instead of the 8-bits ASC and ASCQ
> arguments.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   include/scsi/scsi_cmnd.h   |  7 +++++++
>   include/scsi/scsi_common.h | 31 +++++++++++++++++++++++++++++--
>   include/scsi/scsi_device.h | 25 +++++++++++++++++++++++--
>   3 files changed, 59 insertions(+), 4 deletions(-)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 8ecfb94049db..bf6d69f0249f 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -394,6 +394,13 @@ static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
>   extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
>   			     u8 key, u8 asc, u8 ascq);
>   
> +static inline void scsi_set_sense(struct scsi_cmnd *scmd, int desc,
> +				  u8 key, u16 code)
> +{
> +	scsi_build_sense(scmd, desc, key, scsi_sense_code_asc(code),
> +			 scsi_sense_code_ascq(code));
> +}
> +
>   struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
>   				   blk_mq_req_flags_t flags);
>   
> diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
> index 00c8a16d3cd2..6fb2c290ba33 100644
> --- a/include/scsi/scsi_common.h
> +++ b/include/scsi/scsi_common.h
> @@ -71,8 +71,18 @@ extern u64 scsilun_to_int(struct scsi_lun *);
>   struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
>   	u8 response_code;	/* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
>   	u8 sense_key;
> -	u8 asc;
> -	u8 ascq;
> +	union {
> +		struct {
> +#if defined(__BIG_ENDIAN)
> +			u8 asc;
> +			u8 ascq;
> +#elif defined(__LITTLE_ENDIAN)
> +			u8 ascq;
> +			u8 asc;
> +#endif
> +		};
> +		u16 sense_code;
> +	};
>   	u8 byte4;
>   	u8 byte5;
>   	u8 byte6;
> @@ -87,10 +97,27 @@ static inline bool scsi_sense_valid(const struct scsi_sense_hdr *sshdr)
>   	return (sshdr->response_code & 0x70) == 0x70;
>   }
>   
> +static inline u8 scsi_sense_asc(const struct scsi_sense_hdr *sshdr)
> +{
> +	return scsi_sense_code_asc(sshdr->sense_code);
> +}
> +
> +static inline u8 scsi_sense_ascq(const struct scsi_sense_hdr *sshdr)
> +{
> +	return scsi_sense_code_ascq(sshdr->sense_code);
> +}
> +
>   extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
>   				 struct scsi_sense_hdr *sshdr);
>   
>   extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
> +
> +static inline void scsi_set_sense_buffer(int desc, u8 *buf, u8 key, u16 code)
> +{
> +	scsi_build_sense_buffer(desc, buf, key, scsi_sense_code_asc(code),
> +				scsi_sense_code_ascq(code));
> +}
> +
>   int scsi_set_sense_information(u8 *buf, int buf_len, u64 info);
>   int scsi_set_sense_field_pointer(u8 *buf, int buf_len, u16 fp, u8 bp, bool cd);
>   extern const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index e321471e8ca2..11910142ac50 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -518,6 +518,7 @@ extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
>    * to match any sense key, ASC, and ASCQ value.
>    */
>   #define SCMD_FAILURE_SENSE_KEY_ANY	0xff
> +#define SCMD_FAILURE_SENSE_CODE_ANY	0xffff
>   #define SCMD_FAILURE_ASC_ANY		0xff
>   #define SCMD_FAILURE_ASCQ_ANY		0xff
>   /* Always retry a matching failure. */
> @@ -526,8 +527,18 @@ extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
>   struct scsi_failure {
>   	int result;
>   	u8 sense_key;
> -	u8 asc;
> -	u8 ascq;
> +	union {
> +		struct {
> +#if defined(__BIG_ENDIAN)
> +			u8 asc;
> +			u8 ascq;
> +#elif defined(__LITTLE_ENDIAN)
> +			u8 ascq;
> +			u8 asc;
> +#endif
> +		};
> +		u16 sense_code;
> +	};
>   	/*
>   	 * Number of times scsi_execute_cmd will retry the failure. It does
>   	 * not count for the total_allowed.

Why do we have two definitions for the sense code header? Can't we 
combine it with the definitions in scsi_common.h ?

> @@ -537,6 +548,16 @@ struct scsi_failure {
>   	s8 retries;
>   };
>   
> +static inline u8 scsi_failure_asc(const struct scsi_failure *failure)
> +{
> +	return scsi_sense_code_asc(failure->sense_code);
> +}
> +
> +static inline u8 scsi_failure_ascq(const struct scsi_failure *failure)
> +{
> +	return scsi_sense_code_ascq(failure->sense_code);
> +}
> +
>   struct scsi_failures {
>   	/*
>   	 * If a scsi_failure does not have a retry limit setup this limit will

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
