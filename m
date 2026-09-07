Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBA24B04B9;
	Mon,  7 Sep 2026 12:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784859; cv=none; b=ergmgStlSm9zRR9TTg65uBawrwKNFicL8JRDIggYkjJI0QLSqF3yrIO60TabQvXN9EBReqyC9JMISqwkUmUToJAZU9KxtEu41wB4iecL6idoAbESQ+1rqHwnG9yaXPmggbxJjNrswO+xxm9S1Vcrs+7ZOJxbjL3qkIiNnrAxrIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784859; c=relaxed/simple;
	bh=nsb9lwr7OkMBfXu7iDmvfdFcs4wDWkTBEJnRTnPqvx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=S1BPhKqN/96doDyDVd24dB3UdgX8PFnDu2IOqW14ZhdzjgwdC10uaZilHJBvAQS/SUXNzy7mouW5E2kAoG+3EyVgOS2EmYNMVo1hIQ0iG9vRXQNKcfz04VJYg/tydRPPISXAdjGZOjcwuRDtQsQJbRoB070d0IKyDTSWZLact6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Rdd9HcAI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ciSAdel3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=p5tgnNVO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IXra2oHl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Rdd9HcAI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ciSAdel3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="p5tgnNVO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IXra2oHl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A541C1F7A2;
	Mon,  7 Sep 2026 12:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5kGGKE8tb4xkWVeJKaWI8+bYW27uNC9aoNmmtnYBgw=;
	b=Rdd9HcAIOuKEGAGTSbnyNHy53hZxmVhCFuM8JAWKbjevAjM3+KbaJLt+sUReBEVJNmPUPI
	He2+fYGqQw17kDiUHW/WilIjwHjbh5RJ6JvzBz/J0n56W0re5lR0WMPNWbUedfewj+ZYBD
	jXT29oIdOjxeEKGQKrR3dUuW1GT5rD0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5kGGKE8tb4xkWVeJKaWI8+bYW27uNC9aoNmmtnYBgw=;
	b=ciSAdel3zy/g1drb7WsiM4+filiKcoV7CDbFDHXMkiUmd4GoLkJbvS3vR4orvxCJDHG4JD
	KwP+bC9ay+DzKNBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=p5tgnNVO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IXra2oHl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784846; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5kGGKE8tb4xkWVeJKaWI8+bYW27uNC9aoNmmtnYBgw=;
	b=p5tgnNVOJu48AC0RUW17xVRx+Yo1oStBiUCar8gXw0wGWnWZw6soRDDzujaG/qXQwrQtI2
	RlchLRo7QnV5rzB8l/td29+xiWUGC+G+QDu/NbrQiCqsxEhx+myEQCftDM/TKwu9r+VYR9
	TiIL+ZW2nqjboPb08iTQuOOLm65KyXw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784846;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5kGGKE8tb4xkWVeJKaWI8+bYW27uNC9aoNmmtnYBgw=;
	b=IXra2oHlbP6V759QnhOOBVSK/63/ltPkRQ5mJ2WMc17xbsJePhzlEIyn86tsMm6OIDGTQe
	VeCmeKLjcpqiZkAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B80A1339B;
	Mon,  7 Sep 2026 12:40:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Xs5dDc6wnmpYOwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:40:46 +0000
Message-ID: <b7aecaeb-2e27-4eb4-b5aa-01d7b301b834@suse.de>
Date: Mon, 7 Sep 2026 14:40:45 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 30/40] scsi: ibmvscsi_tgt: use 16-bits defined sense
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
 <20260903034201.112211-31-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-31-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: A541C1F7A2
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
> Refactor the IBM virtual SCSI target driver to use scsi_set_sense_buffer()
> and replace all hard-coded additional sense codes and additional sense
> code qualifiers with the enum values defined in include/scsi/scsi_sense.h.
> This helps with code clarity as the sense codes being processed are easier
> to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
