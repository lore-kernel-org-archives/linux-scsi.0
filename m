Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852ED3C8C55
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2026 08:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783326559; cv=none; b=hRQi8MRhJmElQCHp3HC3WjFhpgCD0fRP2qM1Q8t/6R+SHNHFvzjozDvpJuXxTnTmnIERtbMVBQFdkJFHGNKa2kS+UCFmFIym7uWJUlfl4AvcIth3KUwBjdNx7gRKssBWOZH8QDOpaAUXg9ah9evlqSPklr+Y8/BjiQn+kfCNlgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783326559; c=relaxed/simple;
	bh=2awkX1q7mp1CcX+3BhdFibP3lIlnAwl0b66ajyixOJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=r5fm1q79MjBK8DtKMw1UnXVJIfr6rxY5/ZgDR4Z/ebVC3RHThfp6WedeLiC8beFTJwMDeSYwO7dhcMffdSKJC4W0w52ggdq2UX+fHP/zHCZp/W7qw9VYfY60PrLfC5FmJJ7bczT9Jyf8gqwYTVZvRU7hFnkjJkWaRaOWnPbaDWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bpsH5h3O; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JPNqH09F; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bpsH5h3O; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JPNqH09F; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bpsH5h3O";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JPNqH09F";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bpsH5h3O";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JPNqH09F"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CF2E475723;
	Mon,  6 Jul 2026 08:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783326548; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3eoihf6cWzRNoQU8n9m1EV4Fk8Q4D4WWmlUI54uAyro=;
	b=bpsH5h3OCNRRaxrEilvY+Jmycn8bEe/26AUb5OxIjDZXLpNZQQv/WRUEn4KuUY7SjM/XYv
	w+8uUjIbW1838h61JnwX65pP4VeIa1m3G3UjwVhcjPXIRaPTDYz2V9u7W9uXVUzfDZ71BJ
	xw8uvAtSc8E7bbKl8g+liQKXHmx7+yU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783326548;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3eoihf6cWzRNoQU8n9m1EV4Fk8Q4D4WWmlUI54uAyro=;
	b=JPNqH09FoJLqNQSFFjeSd7LJxfKZQRIHIOmOyoEibWcMjnOQcAAxP7S2sefwNHmPqtzSw8
	tJZ6gArjlH5F0sDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bpsH5h3O;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JPNqH09F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783326548; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3eoihf6cWzRNoQU8n9m1EV4Fk8Q4D4WWmlUI54uAyro=;
	b=bpsH5h3OCNRRaxrEilvY+Jmycn8bEe/26AUb5OxIjDZXLpNZQQv/WRUEn4KuUY7SjM/XYv
	w+8uUjIbW1838h61JnwX65pP4VeIa1m3G3UjwVhcjPXIRaPTDYz2V9u7W9uXVUzfDZ71BJ
	xw8uvAtSc8E7bbKl8g+liQKXHmx7+yU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783326548;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3eoihf6cWzRNoQU8n9m1EV4Fk8Q4D4WWmlUI54uAyro=;
	b=JPNqH09FoJLqNQSFFjeSd7LJxfKZQRIHIOmOyoEibWcMjnOQcAAxP7S2sefwNHmPqtzSw8
	tJZ6gArjlH5F0sDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD81D779AA;
	Mon,  6 Jul 2026 08:29:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id c8LELVRnS2rlLQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 06 Jul 2026 08:29:08 +0000
Message-ID: <b7971067-1025-48ca-8ba4-d76714c283d5@suse.de>
Date: Mon, 6 Jul 2026 10:29:08 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/9] scsi: scsi_debug: move ASC and ASCQ definitions to
 scsi_proto.h
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260706065610.3559692-1-dlemoal@kernel.org>
 <20260706065610.3559692-2-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260706065610.3559692-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CF2E475723
X-Spam-Score: -4.51

On 7/6/26 8:56 AM, Damien Le Moal wrote:
> The scsi_debug driver internally defines lots of SCSI additional sense
> codes (ASC) and additional sense code qualifiers (ASCQ). Move these
> definitions to include/scsi/scsi_proto.h so that they can be reused
> elsewhere in the SCSI and ATA code. This also makes the scsi_debug.c file
> a little smaller.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/scsi_debug.c | 46 -----------------------------------
>   include/scsi/scsi_proto.h | 51 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 51 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 9d1c9c41d0f9..4a95e6bae38b 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -67,52 +67,6 @@ static const char *sdebug_version_date = "20210520";
>   
>   #define MY_NAME "scsi_debug"
>   
> -/* Additional Sense Code (ASC) */
> -#define NO_ADDITIONAL_SENSE 0x0
> -#define OVERLAP_ATOMIC_COMMAND_ASC 0x0
> -#define OVERLAP_ATOMIC_COMMAND_ASCQ 0x23
> -#define FILEMARK_DETECTED_ASCQ 0x1
> -#define EOP_EOM_DETECTED_ASCQ 0x2
> -#define BEGINNING_OF_P_M_DETECTED_ASCQ 0x4
> -#define EOD_DETECTED_ASCQ 0x5
> -#define LOGICAL_UNIT_NOT_READY 0x4
> -#define LOGICAL_UNIT_COMMUNICATION_FAILURE 0x8
> -#define UNRECOVERED_READ_ERR 0x11
> -#define PARAMETER_LIST_LENGTH_ERR 0x1a
> -#define INVALID_OPCODE 0x20
> -#define LBA_OUT_OF_RANGE 0x21
> -#define INVALID_FIELD_IN_CDB 0x24
> -#define INVALID_FIELD_IN_PARAM_LIST 0x26
> -#define WRITE_PROTECTED 0x27
> -#define UA_READY_ASC 0x28
> -#define UA_RESET_ASC 0x29
> -#define UA_CHANGED_ASC 0x2a
> -#define TOO_MANY_IN_PARTITION_ASC 0x3b
> -#define TARGET_CHANGED_ASC 0x3f
> -#define LUNS_CHANGED_ASCQ 0x0e
> -#define INSUFF_RES_ASC 0x55
> -#define INSUFF_RES_ASCQ 0x3
> -#define POWER_ON_RESET_ASCQ 0x0
> -#define POWER_ON_OCCURRED_ASCQ 0x1
> -#define BUS_RESET_ASCQ 0x2	/* scsi bus reset occurred */
> -#define MODE_CHANGED_ASCQ 0x1	/* mode parameters changed */
> -#define CAPACITY_CHANGED_ASCQ 0x9
> -#define SAVING_PARAMS_UNSUP 0x39
> -#define TRANSPORT_PROBLEM 0x4b
> -#define THRESHOLD_EXCEEDED 0x5d
> -#define LOW_POWER_COND_ON 0x5e
> -#define MISCOMPARE_VERIFY_ASC 0x1d
> -#define MICROCODE_CHANGED_ASCQ 0x1	/* with TARGET_CHANGED_ASC */
> -#define MICROCODE_CHANGED_WO_RESET_ASCQ 0x16
> -#define WRITE_ERROR_ASC 0xc
> -#define UNALIGNED_WRITE_ASCQ 0x4
> -#define WRITE_BOUNDARY_ASCQ 0x5
> -#define READ_INVDATA_ASCQ 0x6
> -#define READ_BOUNDARY_ASCQ 0x7
> -#define ATTEMPT_ACCESS_GAP 0x9
> -#define INSUFF_ZONE_ASCQ 0xe
> -/* see drivers/scsi/sense_codes.h */
> -
>   /* Additional Sense Code Qualifier (ASCQ) */
>   #define ACK_NAK_TO 0x3
>   
> diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
> index f64385cde5b9..965cde7ebc5b 100644
> --- a/include/scsi/scsi_proto.h
> +++ b/include/scsi/scsi_proto.h
> @@ -233,6 +233,57 @@ enum sam_status {
>   #define MISCOMPARE          0x0e
>   #define COMPLETED	    0x0f
>   
> +/*
> + * Additional Sense Codes (ASC).
> + */
> +#define NO_ADDITIONAL_SENSE		0x00
> +#define OVERLAP_ATOMIC_COMMAND_ASC	0x00
> +#define LOGICAL_UNIT_NOT_READY		0x04
> +#define LOGICAL_UNIT_COMMUNICATION_FAILURE 0x8
> +#define WRITE_ERROR_ASC			0x0c
> +#define UNRECOVERED_READ_ERR		0x11
> +#define PARAMETER_LIST_LENGTH_ERR	0x1a
> +#define MISCOMPARE_VERIFY_ASC		0x1d
> +#define INVALID_OPCODE			0x20
> +#define LBA_OUT_OF_RANGE		0x21
> +#define INVALID_FIELD_IN_CDB		0x24
> +#define INVALID_FIELD_IN_PARAM_LIST	0x26
> +#define WRITE_PROTECTED			0x27
> +#define UA_READY_ASC			0x28
> +#define UA_RESET_ASC			0x29
> +#define UA_CHANGED_ASC			0x2a
> +#define TOO_MANY_IN_PARTITION_ASC	0x3b
> +#define TARGET_CHANGED_ASC		0x3f
> +#define SAVING_PARAMS_UNSUP		0x39
> +#define TRANSPORT_PROBLEM		0x4b
> +#define INSUFF_RES_ASC			0x55
> +#define LOW_POWER_COND_ON		0x5e
> +#define THRESHOLD_EXCEEDED		0x5d
> +
> +/*
> + * Additional Sense Code Qualifiers (ASCQ).
> + */
> +#define POWER_ON_RESET_ASCQ		0x00
> +#define MODE_CHANGED_ASCQ		0x01	/* mode parameters changed */
> +#define FILEMARK_DETECTED_ASCQ		0x01
> +#define POWER_ON_OCCURRED_ASCQ		0x01
> +#define MICROCODE_CHANGED_ASCQ		0x01	/* with TARGET_CHANGED_ASC */
> +#define BUS_RESET_ASCQ			0x02	/* scsi bus reset occurred */
> +#define EOP_EOM_DETECTED_ASCQ		0x02
> +#define INSUFF_RES_ASCQ			0x03
> +#define BEGINNING_OF_P_M_DETECTED_ASCQ	0x04
> +#define UNALIGNED_WRITE_ASCQ		0x04
> +#define EOD_DETECTED_ASCQ		0x05
> +#define WRITE_BOUNDARY_ASCQ		0x05
> +#define READ_INVDATA_ASCQ		0x06
> +#define READ_BOUNDARY_ASCQ		0x07
> +#define CAPACITY_CHANGED_ASCQ		0x09
> +#define ATTEMPT_ACCESS_GAP		0x09
> +#define LUNS_CHANGED_ASCQ		0x0e
> +#define INSUFF_ZONE_ASCQ		0x0e
> +#define MICROCODE_CHANGED_WO_RESET_ASCQ 0x16
> +#define OVERLAP_ATOMIC_COMMAND_ASCQ	0x23
> +
>   /*
>    *  DEVICE TYPES
>    *  Please keep them in 0x%02x format for $MODALIAS to work

While at it, would you mind converting the raw asc/ascq numbers
in drivers/scsi/scsi_lib.c to use these definitions?
That will make the code in there _so much_ more readable ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
