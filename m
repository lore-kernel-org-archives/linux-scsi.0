Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761EB183079
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2024 11:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004837; cv=none; b=TZjFJzcnALP7gGG2gIG8f3CtfUAgbXO3+ZiXZptP3O3DLgsvI29kd19qjoiahwtw0t6QGwSBD5jhMIHuXqugx2kw7eYaobmIKRmgpJ/GKq8QrA9qtvQ96jD8iXX9wMDCXXXxJWrmuRyxp2V5MuZA74eaGa4ZLAojf8OtpgJeWKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004837; c=relaxed/simple;
	bh=Z9tSMA8977WUpjh7l7gH2MHerdrNJ1GkULPtezmZJZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bMD6GEmyebSszEvkZNl1+B3OMCpmpGEgX7YQkXDSwlISZWlVKMEU4hhJQlaLDnfmAhJdfesKvf1Z0wVdYUnoXH0xo7mBJL4HBjZD1DGZjj341mhaEFYPQUQIYeuFS4uMrRyCqvBYs6P3WjyMQK77swV5TU7rZ48z0GbKoESqrCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A8VZ2I+g; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=x8k6GGEb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A8VZ2I+g; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=x8k6GGEb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A8VZ2I+g";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="x8k6GGEb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A8VZ2I+g";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="x8k6GGEb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 874DE1FCE1;
	Wed,  3 Jul 2024 11:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1720004833; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25HUywLnl43dWYr+Fm5tuRI/QNfdX8Ogwi/J4uSbmXQ=;
	b=A8VZ2I+g2FmANJpNah44ntfJ9IK/T0g1yd/V19rFP0UPiMA3GdlvL9JMDmNarRAGFrnjfg
	W5wdStxbA7fNhPcrFa59ELQ+4Bv8CPH+qfhQsmCwWKtuA0veN9xJ+Qt32HUg6+bN2qFY7y
	ihX5p7xDInbYplOiWrbD7dRQhfs9WPA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1720004833;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25HUywLnl43dWYr+Fm5tuRI/QNfdX8Ogwi/J4uSbmXQ=;
	b=x8k6GGEb0MKg6cr44CJxM6zpE88EAU2yOBfFEN1ay8nfkdGqmY35C3ULzNotwHoQGoQBlU
	SY/3+9F6AlBfZhAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=A8VZ2I+g;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x8k6GGEb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1720004833; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25HUywLnl43dWYr+Fm5tuRI/QNfdX8Ogwi/J4uSbmXQ=;
	b=A8VZ2I+g2FmANJpNah44ntfJ9IK/T0g1yd/V19rFP0UPiMA3GdlvL9JMDmNarRAGFrnjfg
	W5wdStxbA7fNhPcrFa59ELQ+4Bv8CPH+qfhQsmCwWKtuA0veN9xJ+Qt32HUg6+bN2qFY7y
	ihX5p7xDInbYplOiWrbD7dRQhfs9WPA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1720004833;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25HUywLnl43dWYr+Fm5tuRI/QNfdX8Ogwi/J4uSbmXQ=;
	b=x8k6GGEb0MKg6cr44CJxM6zpE88EAU2yOBfFEN1ay8nfkdGqmY35C3ULzNotwHoQGoQBlU
	SY/3+9F6AlBfZhAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D83213974;
	Wed,  3 Jul 2024 11:07:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iDs8GuEwhWbDcgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 03 Jul 2024 11:07:13 +0000
Message-ID: <09d664c5-fb60-4aa0-bec3-62db327c5b61@suse.de>
Date: Wed, 3 Jul 2024 13:07:13 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/18] scsi: fcoe: Simplify alloc_ordered_workqueue()
 invocations
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240702215228.2743420-1-bvanassche@acm.org>
 <20240702215228.2743420-7-bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240702215228.2743420-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-5.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 874DE1FCE1
X-Spam-Flag: NO
X-Spam-Score: -5.50
X-Spam-Level: 

On 7/2/24 23:51, Bart Van Assche wrote:
> Let alloc_ordered_workqueue() format the workqueue name instead of calling
> snprintf() explicitly.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/fcoe/fcoe_sysfs.c | 18 +++++-------------
>   include/scsi/fcoe_sysfs.h      |  2 --
>   2 files changed, 5 insertions(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

