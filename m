Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579FC356A0D
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2026 06:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781848835; cv=none; b=Af97yRfXVmh1pzUSzHN9Iyo83C50Oxxehq3d0aowI9ElUzqV30R72+5EuVM7ixxNjD3a2YKh4501AiMY3ERr0DEXmOKNw2OPpRlEbTbVRXDusijvpbzcu+u0ATQd31EbQ4IZBbTLV1MxNhvEb0u17gnF9S4Kq0s2aCJMJ+JpG10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781848835; c=relaxed/simple;
	bh=NHsH/HSqkCVemAteb0x/9nQ+kXKMrF4FzatVasvKa8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SJ5O8NgZQN6UTEIBTP4u1rbGnjC4pakF52qQLvVEcWZtdmVrKYAlu834yGp1Y3z+hG464ALpEeB57rP/2WJolHca98jmyvYovgUh192qI2V7lK0ttQpgL7URGPMLgF4OQ6tyZuok37qCjtnbNA5wkCzD65Ke4MOZv/jmYhNE8hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RNBRsSEC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IdMTRN/8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RNBRsSEC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IdMTRN/8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RNBRsSEC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IdMTRN/8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RNBRsSEC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IdMTRN/8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 779906D895;
	Fri, 19 Jun 2026 06:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781848831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhFMBwSW+YbQtu2Kkz1YKO+NZqZQWZfjxNGZuwd0z7c=;
	b=RNBRsSECXfr/dwIuwhuDLlXbCM6M7X8z0YwlTPCRqioYgG0Yx2TiX9RZzMnAyZi5YSsVNT
	xKsNZ4EcTOOwIHpPfhLKh+v6yR2ap2f96rApUOPWFN4/u3dK8fgpGFeHxmM82VgXjoqBh4
	CfqZrlVe+W2CDjKEb+z0WwSWSZTnX0A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781848831;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhFMBwSW+YbQtu2Kkz1YKO+NZqZQWZfjxNGZuwd0z7c=;
	b=IdMTRN/8zYAdpu0wIa5iMZq/bQiF3+hIsQHFKtg2Qrki1nU7MCBfoHGNg+/92fe9eKjKpC
	H4dbtDOSfRJdP5Dg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781848831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhFMBwSW+YbQtu2Kkz1YKO+NZqZQWZfjxNGZuwd0z7c=;
	b=RNBRsSECXfr/dwIuwhuDLlXbCM6M7X8z0YwlTPCRqioYgG0Yx2TiX9RZzMnAyZi5YSsVNT
	xKsNZ4EcTOOwIHpPfhLKh+v6yR2ap2f96rApUOPWFN4/u3dK8fgpGFeHxmM82VgXjoqBh4
	CfqZrlVe+W2CDjKEb+z0WwSWSZTnX0A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781848831;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhFMBwSW+YbQtu2Kkz1YKO+NZqZQWZfjxNGZuwd0z7c=;
	b=IdMTRN/8zYAdpu0wIa5iMZq/bQiF3+hIsQHFKtg2Qrki1nU7MCBfoHGNg+/92fe9eKjKpC
	H4dbtDOSfRJdP5Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3E093779A8;
	Fri, 19 Jun 2026 06:00:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XhBXDf/aNGonFgAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 19 Jun 2026 06:00:31 +0000
Message-ID: <94839d90-805d-413c-890f-bcbdff89af8e@suse.de>
Date: Fri, 19 Jun 2026 08:00:30 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] scsi: core: Refactor scsi_add_lun() to use
 scsi_update_inquiry_data()
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org, krishna.kant@purestorage.com
References: <20260618233508.97960-1-brian@purestorage.com>
 <20260618233508.97960-4-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260618233508.97960-4-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 
X-Spam-Score: -4.30

On 6/19/26 01:35, Brian Bunker wrote:
> Refactor scsi_add_lun() to use the new scsi_update_inquiry_data()
> function instead of inline INQUIRY parsing code. This consolidates
> INQUIRY data handling in one place and ensures consistent behavior
> between initial device setup and device rescan operations.
> 
> The following fields are now set by scsi_update_inquiry_data():
> - inquiry buffer, vendor, model, rev pointers
> - type, removable, lockable
> - inq_periph_qual
> - soft_reset, ppr, wdtr, sdtr
> - tagged_supported, simple_tags
> - is_ata, allow_restart
> 
> Also update scsi_probe_lun() to compute scsi_level into a local
> variable rather than writing directly to sdev->scsi_level.
> scsi_update_inquiry_data() is now the authoritative setter of
> sdev->scsi_level under inquiry_mutex; scsi_probe_lun() needs the
> level early for lun_in_cdb and sdev_target->scsi_level before
> scsi_update_inquiry_data() is called.
> 
> scsi_add_lun() is only ever called for freshly allocated sdev instances
> where sdev->inquiry is NULL, so the redundant !sdev->inquiry guard is
> dropped along with the now-unreachable sanity check that followed it.
> 
> This patch maintains identical behavior to the previous code.
> scsi_add_lun() continues to handle the remaining BLIST flags and
> device-specific setup that doesn't come directly from INQUIRY data.
> 
> Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/scsi_scan.c | 127 +++++++++------------------------------
>   1 file changed, 29 insertions(+), 98 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
