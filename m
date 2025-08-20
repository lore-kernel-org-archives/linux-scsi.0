Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950EC242D72
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 11:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755690101; cv=none; b=QeFL6oIrwoSyuJa6X2FzGA/7Tb1/S8gR90+RrKsAhyQiwoipH0YhA9y3g8x4Njce2D6ZIJlUto8MQWb90wXuxJ9NtesYvHUA/cg+GVeXmJsakwFsPb0YGzA0xnwt1IEQUXAScuZAzLGPrGN1N6iTDWmtkXZ1HaZOL0gCoXnulpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755690101; c=relaxed/simple;
	bh=llrHxdhNK5d7M85DNFsGYy2Insdkrh6QdWjr+kMu4Fo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DpWfbQPizmiJVywdWAWv0gSQf4E7xMlOo9qbHuDQk5wrNFkF1rvr0ddXt3mDDRRyBh2Rc0nh3m+P7mldxJ8LqF9M3Gx1zgHbFErxx1dNRcThwBXKtIFlcPFnnA9neiCUJL6CxNSBSk/DRZxnaNfdm4hdMUNEyKbwcbcK70S89PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VrRYW36Q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vPnquYwd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VrRYW36Q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vPnquYwd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VrRYW36Q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vPnquYwd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VrRYW36Q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vPnquYwd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6AB8D21C24;
	Wed, 20 Aug 2025 11:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755690097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ttL49rU2eLt6zRkb9hcKNet23Jy9jsqNLl0t6jWajG4=;
	b=VrRYW36Q1yg83rY13qdcBk4Queg6YAoNeMYzWSA2U4Npf3u5mkNAguHy3CeGqU6s6jDcpx
	O7CEsmglGPaEIQKP8KNOgf+CxNUptZdyPFM0NGl3OpTRF46TnNbOF+M8TDMX2850p0lo3c
	+Iovdbw4DOHkZQ+hfTwZvoKkLtNi5Bg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755690097;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ttL49rU2eLt6zRkb9hcKNet23Jy9jsqNLl0t6jWajG4=;
	b=vPnquYwdlwi0nO0hhoK8bDK6cmpKEgNecZuvL0+bvfHTujI4Pxt3cY5Q2294+U3ZZs52cF
	30AEpW10YkJt/qAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VrRYW36Q;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vPnquYwd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755690097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ttL49rU2eLt6zRkb9hcKNet23Jy9jsqNLl0t6jWajG4=;
	b=VrRYW36Q1yg83rY13qdcBk4Queg6YAoNeMYzWSA2U4Npf3u5mkNAguHy3CeGqU6s6jDcpx
	O7CEsmglGPaEIQKP8KNOgf+CxNUptZdyPFM0NGl3OpTRF46TnNbOF+M8TDMX2850p0lo3c
	+Iovdbw4DOHkZQ+hfTwZvoKkLtNi5Bg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755690097;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ttL49rU2eLt6zRkb9hcKNet23Jy9jsqNLl0t6jWajG4=;
	b=vPnquYwdlwi0nO0hhoK8bDK6cmpKEgNecZuvL0+bvfHTujI4Pxt3cY5Q2294+U3ZZs52cF
	30AEpW10YkJt/qAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4A04B1368B;
	Wed, 20 Aug 2025 11:41:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IOekEXG0pWjAJwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 20 Aug 2025 11:41:37 +0000
Message-ID: <17c37336-da41-4976-af54-406cc55259a4@suse.de>
Date: Wed, 20 Aug 2025 13:41:37 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/8] scsi: sd: Remove checks for -EOVERFLOW in
 sd_read_capacity()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-6-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250815211525.1524254-6-emilne@redhat.com>
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
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 6AB8D21C24
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 8/15/25 23:15, Ewan D. Milne wrote:
> Remove checks for -EOVERFLOW in sd_read_capacity() because this value has not
> been returned to it since commit 72deb455b5ec ("block: remove CONFIG_LBDAF").
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/sd.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
