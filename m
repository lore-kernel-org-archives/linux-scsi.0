Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F229035963
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 09:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758878974; cv=none; b=b2u2eT0RS0FitiZ/l8kHZJmy4RIqF6BCoDuzMD7UXH6oVbdu8iXLzG/vEVwgleBcCzhaPCogHTjTMPt11j6LcBfGg3/rN6bisfWWRfP61zYUKXppTBwI2wtDiOuRR89ZElaaNrjFN0YGs5QC/sc5qRaq24CQ6ljI0tSboDZCYEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758878974; c=relaxed/simple;
	bh=xi17Hg4ATEoHUktl68BVPl8Fr/cpZuFtFZZ6y+FBIsY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UBU2uGQbP1tGCsVHxoufm2Nd2gy+XnhEPUJYFNs5/OIpH/GRkNUZHjqkLmcsGSCHHVrI8WlTKAMCTg5jBu9w0QaDb9SlrGtme3DcCvJaNqJd2vKjmGeomigWLCPUn1Dm9nFf4dk4ClmTUZ7mjj8Z7gkVc9mdlMRj/r5AadBcOgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2XkG+Cys; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Nd5xhmlG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2XkG+Cys; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Nd5xhmlG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2XkG+Cys";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Nd5xhmlG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2XkG+Cys";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Nd5xhmlG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AA838241AC;
	Fri, 26 Sep 2025 09:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758878970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xrMxuALUTMN/PgB+yc1lPB72ijrJJmIIX+l37DXoiyo=;
	b=2XkG+CysLT3oSOvR92YF4uiFanJESgUXOEWK91js4jDYTW4oKJ+0I27tPB3ZLfeTBJN09a
	b+Y4W/zTaAODSvY3hLrNkfrpWCoTOyZrtYT/yxFbCy0l5gKXCg7woc0FxtjLK3vDAsFb62
	rXG+sbGguG8RTP1FCt6j7SN0GeWKbtI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758878970;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xrMxuALUTMN/PgB+yc1lPB72ijrJJmIIX+l37DXoiyo=;
	b=Nd5xhmlGzHlvENX8YBg51CXcrbUtzEO7i5y8BMIcLetpHuL7+/VFym5nXa0a11PgocxmSj
	WLZ0cS7LYmqqIuCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2XkG+Cys;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Nd5xhmlG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758878970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xrMxuALUTMN/PgB+yc1lPB72ijrJJmIIX+l37DXoiyo=;
	b=2XkG+CysLT3oSOvR92YF4uiFanJESgUXOEWK91js4jDYTW4oKJ+0I27tPB3ZLfeTBJN09a
	b+Y4W/zTaAODSvY3hLrNkfrpWCoTOyZrtYT/yxFbCy0l5gKXCg7woc0FxtjLK3vDAsFb62
	rXG+sbGguG8RTP1FCt6j7SN0GeWKbtI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758878970;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xrMxuALUTMN/PgB+yc1lPB72ijrJJmIIX+l37DXoiyo=;
	b=Nd5xhmlGzHlvENX8YBg51CXcrbUtzEO7i5y8BMIcLetpHuL7+/VFym5nXa0a11PgocxmSj
	WLZ0cS7LYmqqIuCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 72FEA1386E;
	Fri, 26 Sep 2025 09:29:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yO5nGvpc1mh0CgAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 26 Sep 2025 09:29:30 +0000
Message-ID: <49b31606-29fc-43ea-973b-b317c53161db@suse.de>
Date: Fri, 26 Sep 2025 11:29:30 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 11/11] scsi: qla2xxx: Fix 2 memcpy field-spanning
 write issue
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
 John Meneghini <jmeneghi@redhat.com>, kbusch@kernel.org,
 martin.petersen@oracle.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org
Cc: bgurney@redhat.com, axboe@kernel.dk, emilne@redhat.com,
 gustavoars@kernel.org, hch@lst.de, james.smart@broadcom.com,
 kees@kernel.org, linux-hardening@vger.kernel.org, njavali@marvell.com,
 sagi@grimberg.me
References: <20250926000200.837025-1-jmeneghi@redhat.com>
 <20250926000200.837025-12-jmeneghi@redhat.com>
 <0af9cbc4-a410-44f3-affc-a09e5c41ccd4@embeddedor.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <0af9cbc4-a410-44f3-affc-a09e5c41ccd4@embeddedor.com>
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
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: AA838241AC
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 9/26/25 11:00, Gustavo A. R. Silva wrote:
> Hi,
> 
> Shouldn't this patch be removed from this series, since it's going to be
> reverted anyways?
> 
yes. To my understanding the FPIN patch series has been queued in
scsi-queue anyway, so it would be better to just send an incremental
patch on top of that.
Especially as Martin has already indicated that he will _not_ rebase
his tree.

Best to just send this patch as a stand-alone patch, and then rebase
any not-yet-upstreamed patchsets on top of that.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
