Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BC236B063
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 07:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773819885; cv=none; b=SwiW11cGau0vPNGbhk1gvCiBmMIH/qzfueKGDFih0SZDb+0VR6u+bIIEf3HPsiepKIxFMTpAbusZdmvZAeqpAaEYTntrldBnYKdu40En0rV0xsxi2WeyLo3C6IXrkCbLEdbv1Qakl6VdkxrHB4nEHZs+7jyuFxIBASJ7RkmaxOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773819885; c=relaxed/simple;
	bh=QWYBxxNE1vXMl8ZIePHZKA2UUDkpcYWqTjXqfDWlOCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hq9GH+4T3F8DBdZ7lgwEhZLtRA0y9roOnWdsEeZcl3XHoQSxUdP03/0yfycelr1lnuaTHaEUBPT5Uzsgvt6B7Xmg4CRGZBAGKipdA4Q2aXUkmAB7J7QUWRjp5lB54Q3v06wChW/0W+bujoHSa4m0d1k+Nu22JwUehxicxvpyOdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eVCuPZcT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1AVVT/u3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eVCuPZcT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1AVVT/u3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eVCuPZcT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1AVVT/u3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eVCuPZcT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1AVVT/u3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1D3795BDD0;
	Wed, 18 Mar 2026 07:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773819882; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/1/XXelhbZ1SqmZrdAIhjj/NeUuz4/R8SXcQi/1GJI=;
	b=eVCuPZcTip/an7m/kX2Cj1XczOYTXGWeRFfSOqilsTlvmU7ZA7x1jMbY8vLS5lmsVBma8y
	dOe7F9CaKXhQmkHJK8UaQiSHgw81Krz7R4H5RoSwuq1o6Ydon9FaGYnwH22eaGt3SJIMX3
	sqY4tdkl/BrrTJXj409UVz4ehAqaTxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773819882;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/1/XXelhbZ1SqmZrdAIhjj/NeUuz4/R8SXcQi/1GJI=;
	b=1AVVT/u3DE/YqUmalYOKon0Rzklmav8M+LJWzk2dP4oDzQeqrqsvXFfO0A6/yAY+XdstSX
	aNnib1HgES+iBEDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eVCuPZcT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="1AVVT/u3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773819882; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/1/XXelhbZ1SqmZrdAIhjj/NeUuz4/R8SXcQi/1GJI=;
	b=eVCuPZcTip/an7m/kX2Cj1XczOYTXGWeRFfSOqilsTlvmU7ZA7x1jMbY8vLS5lmsVBma8y
	dOe7F9CaKXhQmkHJK8UaQiSHgw81Krz7R4H5RoSwuq1o6Ydon9FaGYnwH22eaGt3SJIMX3
	sqY4tdkl/BrrTJXj409UVz4ehAqaTxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773819882;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/1/XXelhbZ1SqmZrdAIhjj/NeUuz4/R8SXcQi/1GJI=;
	b=1AVVT/u3DE/YqUmalYOKon0Rzklmav8M+LJWzk2dP4oDzQeqrqsvXFfO0A6/yAY+XdstSX
	aNnib1HgES+iBEDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BBC8C4273B;
	Wed, 18 Mar 2026 07:44:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WePVK+lXummAQAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 18 Mar 2026 07:44:41 +0000
Message-ID: <ad49619a-6773-42ce-9658-6e96bede2bfd@suse.de>
Date: Wed, 18 Mar 2026 08:44:37 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/13] scsi: scsi_dh_alua: Delete alua_port_group
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-2-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260317120703.3702387-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1D3795BDD0

On 3/17/26 13:06, John Garry wrote:
> Delete the alua_port_group usage, as it is more accurate to manage the
> port group info per-scsi device - see [0]
> 
> [0] https://lore.kernel.org/linux-scsi/20260310114925.1222263-1-john.g.garry@oracle.com/T/#m4ffc0d07f169b70b8fd2407bae9632aa0f8c1f9a
> 
> For now, the handler data will be used to hold the ALUA-related info.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/device_handler/scsi_dh_alua.c | 663 ++++++---------------
>   1 file changed, 180 insertions(+), 483 deletions(-)
> 
In principle, yes, but I would put this at the end after the patches to
move the alua functionality to the scsi core.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
