Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DE84F30FD;
	Mon,  7 Sep 2026 13:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788920; cv=none; b=egQ+Pn3JssKfOgs3thJXyeVuQjujP48wo4GtfwH4Pro38NhZGIlC3H8WJOfid7MRpI2xUXzobJHD0HhXPrnssoim0Zic/c1fn5+TsnUKHS9BBpUlxfAYOUIMVT34ZPmyI7al6sEf6gX3yayx+y08z+PUMZFx/i5lyil6M9vkXSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788920; c=relaxed/simple;
	bh=xH2oofSASDYkWf/MBbt4+dDYs8RJrMbqSGYsAg73Mv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QHN4/PY8WoystR4UUB/KKgZ+0PdhljFRoJQk13xLyOjp+LItthuxHJpcJctW6jBXRW28opIcMQVltJEIpxe/2NwCau6r3Q7sDR88kBBr8khVuLqKRkilb6AGCAqVAe32XhPOOCl9q4ldUovoH8F7bA81IWWS3VD7ePQpolOGf2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UKsOtNtk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3tD2KMyV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oRl2Wll1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eUckCtaF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UKsOtNtk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3tD2KMyV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oRl2Wll1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eUckCtaF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F23D21F794;
	Mon,  7 Sep 2026 13:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788788904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ip1SQj41EsOiNaCYSkO5MeiL8vRJCQXOtGWd/Dv1zOk=;
	b=UKsOtNtkBV4lNNwY65KUCXBAGGB5O/g1/p7kGG+lOmiVjSRAt/IIhVGlgMYDB9MHiQajOk
	TxizyMw3aeqxV7oKSJfOCqUWBU6Wn61Qz0v6c0IFYchrFqDRTu0sBxm1DIJwBa7Q4TrwnE
	Y4pcUJHygcnPYrWHToxjcmXngeXe6oA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788788904;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ip1SQj41EsOiNaCYSkO5MeiL8vRJCQXOtGWd/Dv1zOk=;
	b=3tD2KMyVJdxiMVEYGq+HkuYRSlGMYWVkqSw+09bsr/354Zp5i2LUQdVCD+s3dtmCUl8Mft
	Lu0+0Jglo1LhnsBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oRl2Wll1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eUckCtaF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788788900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ip1SQj41EsOiNaCYSkO5MeiL8vRJCQXOtGWd/Dv1zOk=;
	b=oRl2Wll16l4QwAXgkIQqHgEWLwHXmZQE8f/n7W5nHeGcp3sQZXebKtq9mrsq6gFl879THs
	AX2SuYOa8P9H3GUQo7SOJBNKlLZIkEO7QH0+awVd2KqmRp8Y4i/adCKrtBwYvNRsGWt+aA
	XdIgR/vZGVOPWZhFjVcRKYM62WJz4EE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788788900;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ip1SQj41EsOiNaCYSkO5MeiL8vRJCQXOtGWd/Dv1zOk=;
	b=eUckCtaFmqd7eoP1m564YSIIRmkrw/J8LXZL9Wunk7gUFIWD2ooHw5tmqtWWnIIH8jA3Zh
	QnWkDEgUrBhmolCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D51A13432;
	Mon,  7 Sep 2026 13:48:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kb4vJaPAnmpAfgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 13:48:19 +0000
Message-ID: <1b5a6d1f-ae0d-430d-b7de-1176c66572d4@suse.de>
Date: Mon, 7 Sep 2026 15:48:19 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/40] scsi: ch: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-12-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: F23D21F794
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
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email,suse.de:mid];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the SCSI media changer driver to use the 16-bits sense_code field
> of struct scsi_sense_hdr and struct scsi_failure and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/ch.c | 53 ++++++++++++++++++++---------------------------
>   1 file changed, 22 insertions(+), 31 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
