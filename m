Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853CF19D093
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 08:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762329947; cv=none; b=KR9PivfGv7c/ayHPrrdjA9CpLIRyYYcELQXka1YqbkJIPjkRGvG/c+M3U34jh3JmclYiYlI9/0tS+BvAYktNgbRRKEIbWqN9LWKyeNHR35uEjlEGr3W6wd/QRJdaMN7KBibI2b+PTZO0+MQaFjQlfR4NvHu/m1vBF99ppn8HysY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762329947; c=relaxed/simple;
	bh=LnwQpS+HrMJuJMPD5zFnsXbi8j7ASo4fgZOJyU2wcRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d4cAiyCl4cSFs+aA6t1ijLSoFxCoW2BZIGCjaItqGIYLQe+UfPyK/CyQYS57pk15up3opQCTDsPgNHER0cf6CS8oI/mIlHkiVDfRZe8+RXy8Mp18CCvcRCCbfyHjPpanc1fZdk08JcAgrxKJZUrwA8DsBI8MSl4R4q+lZui1JuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BHcSsfYs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=73b03fd9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BHcSsfYs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=73b03fd9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BHcSsfYs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="73b03fd9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BHcSsfYs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="73b03fd9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ABA201F441;
	Wed,  5 Nov 2025 08:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762329943; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=93NcHGYar2qak2M38FyxcBf/03ALML5fp0HGk5ZU+dI=;
	b=BHcSsfYsGnZKlZXij36JDfGwIy/CJ2GcXVtV2DBhHT3lFKQBfHA4KRPBQScUDW0DG8GTHG
	tU7GKErikcE5l0+CnZJMrTEIzXLKweEerZCLTy22+HwBw3JU1PdujEV8nRUyB5FfrgNfQa
	saXqj+pE5/4fpBz05cASLTDHa2ahRgk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762329943;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=93NcHGYar2qak2M38FyxcBf/03ALML5fp0HGk5ZU+dI=;
	b=73b03fd9sAZk82JBq4dBebweOvnhlNMdF8YPk9hEN5dqHpbcLRmxkz8TBZT5Vcr88lwipV
	u8f6rTX7OZDGucDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762329943; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=93NcHGYar2qak2M38FyxcBf/03ALML5fp0HGk5ZU+dI=;
	b=BHcSsfYsGnZKlZXij36JDfGwIy/CJ2GcXVtV2DBhHT3lFKQBfHA4KRPBQScUDW0DG8GTHG
	tU7GKErikcE5l0+CnZJMrTEIzXLKweEerZCLTy22+HwBw3JU1PdujEV8nRUyB5FfrgNfQa
	saXqj+pE5/4fpBz05cASLTDHa2ahRgk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762329943;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=93NcHGYar2qak2M38FyxcBf/03ALML5fp0HGk5ZU+dI=;
	b=73b03fd9sAZk82JBq4dBebweOvnhlNMdF8YPk9hEN5dqHpbcLRmxkz8TBZT5Vcr88lwipV
	u8f6rTX7OZDGucDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6EDAA13699;
	Wed,  5 Nov 2025 08:05:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bRClGFcFC2mkSAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 05 Nov 2025 08:05:43 +0000
Message-ID: <b02bcd74-7e2d-4431-bb37-a299567d6101@suse.de>
Date: Wed, 5 Nov 2025 09:05:42 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/28] scsi: core: Introduce .queue_reserved_command()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251014201707.3396650-1-bvanassche@acm.org>
 <20251014201707.3396650-6-bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251014201707.3396650-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
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
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,huawei.com:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 10/14/25 22:15, Bart Van Assche wrote:
> From: John Garry <john.garry@huawei.com>
> 
> Reserved commands will be used by SCSI LLDs for submitting internal
> commands. Since the SCSI host, target and device limits do not apply to
> the reserved command use cases, bypass the SCSI host limit checks for
> reserved commands. Introduce the .queue_reserved_command() callback for
> reserved commands. Additionally, do not activate the SCSI error handler
> if a reserved command fails such that reserved commands can be submitted
> from inside the SCSI error handler.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> [ bvanassche: modified patch title and patch description. Renamed
>    .reserved_queuecommand() into .queue_reserved_command(). Changed
>    the second argument of __blk_mq_end_request() from 0 into error
>    code in the completion path if cmd->result != 0. Rewrote the
>    scsi_queue_rq() changes. See also
>    https://lore.kernel.org/linux-scsi/1666693096-180008-5-git-send-email-john.garry@huawei.com/ ]
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/hosts.c     |  6 +++++
>   drivers/scsi/scsi_lib.c  | 54 ++++++++++++++++++++++++++++------------
>   include/scsi/scsi_host.h |  6 +++++
>   3 files changed, 50 insertions(+), 16 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
