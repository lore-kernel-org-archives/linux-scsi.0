Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26B930DEA5
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 12:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755518937; cv=none; b=EgTj9oqU2lV8jXiS1SpO9bN0HyuoTgfunFMN32dEUMa4qvecxg7MDMCsqVyBcfuRrjgzScKeiVsGUowb/IRl87JxEnicrqJWxAT9atnNKT7qwDP8G7UyZHQSz8xSfObnJfViZ71+7PrPNR6QdKBJBDs+C3wZiGOAXrd7alHOBWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755518937; c=relaxed/simple;
	bh=jJN2uGn5MrFkuLS3KgZuxtiY7V+tisePw+Y8OAmWN5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SVXmgvHFlSHIP7FH8I3SxGm4WoT2ubwNeZQTrQRp86e55gso2d+H9oKRNsaCjJwirMwKlYLKH9uM8n6l6VGt2yYtrkakoJqeo5VLbEM9gWHzgTcV42RdH4iqgiRI+obbn9P56AGD4xaigBtPqKySSYowERQjFfiOUtlx1rw9O5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=r7PankZq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DNPq30xG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=B0EsDtP+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lyrUFTqo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="r7PankZq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DNPq30xG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="B0EsDtP+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lyrUFTqo"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DB0932128E;
	Mon, 18 Aug 2025 12:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755518933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kPTpstXK1uhHeiPUD0PwNG6zzyoQRgmjzQq+yDwQz3g=;
	b=r7PankZqONbsTJ6r4dGD63HBbooYFkHxQoit4T5vSuWucjmwwXg2Gf8gnhfKT3C67HbRkF
	leTw50l7JomMYlskZDdWvG+uIVKCuyftDdSPm7V58Eloc4uR8EPCxWkUdMidrOi2Kzd1Vm
	+nAuIm7U5VWMj2ZjkGWEHyDdAXdW6eM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755518933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kPTpstXK1uhHeiPUD0PwNG6zzyoQRgmjzQq+yDwQz3g=;
	b=DNPq30xGvZjYhP0a66hxKNakdBUitLLVPw3QNbG90zzKALlYm+d9xKEqaKsHTr1JgNc6Xt
	stqyc2g5GP2GZUCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=B0EsDtP+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lyrUFTqo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755518932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kPTpstXK1uhHeiPUD0PwNG6zzyoQRgmjzQq+yDwQz3g=;
	b=B0EsDtP+KaktcEy8fmYPtqzpJ8wkY/gY20s33l8smEBOTb+rlK9p29OFt2iTq6d/uqIUY4
	no+oasGvPch5+tI/rYPYd+0ChQedoEJGXw2jMluvvHhKX+jgluYalUccBsEruiu+aqJ4kh
	sE9XIQqgXaU8Y6zuoqUFe25CyliA7E8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755518932;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kPTpstXK1uhHeiPUD0PwNG6zzyoQRgmjzQq+yDwQz3g=;
	b=lyrUFTqo5/hb54kKiqR0NfkN0AZ0A2rJ9zobu7j1EpgYg6a9dBsBnQFFyw0l/D6l4OUrvW
	8lMoZnA24ygrwACw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C98E313A55;
	Mon, 18 Aug 2025 12:08:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eDBwLdMXo2gcbgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 18 Aug 2025 12:08:51 +0000
Message-ID: <0d4629ca-d448-49ec-81cb-56af569a081c@suse.de>
Date: Mon, 18 Aug 2025 14:08:51 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 8/9] nvme-multipath: queue-depth support for marginal
 paths
To: Bryan Gurney <bgurney@redhat.com>, linux-nvme@lists.infradead.org,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, axboe@kernel.dk
Cc: james.smart@broadcom.com, njavali@marvell.com,
 linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
 kees@kernel.org, gustavoars@kernel.org, jmeneghi@redhat.com,
 emilne@redhat.com
References: <20250813200744.17975-1-bgurney@redhat.com>
 <20250813200744.17975-9-bgurney@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250813200744.17975-9-bgurney@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: DB0932128E
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 8/13/25 22:07, Bryan Gurney wrote:
> From: John Meneghini <jmeneghi@redhat.com>
> 
> Exclude marginal paths from queue-depth io policy. In the case where all
> paths are marginal and no optimized or non-optimized path is found, we
> fall back to __nvme_find_path which selects the best marginal path.
> 
> Tested-by: Bryan Gurney <bgurney@redhat.com>
> Signed-off-by: John Meneghini <jmeneghi@redhat.com>
> ---
>   drivers/nvme/host/multipath.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
