Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793264055;
	b=GHFKD8vbCGMX7+c1dncMd/w1b5/797vbuhpuMRDURv+xE6Ie5YK/6+1HIjqNVUfSVtnc
	 q/gaK4tJfn6dZLYX1HTLA9b4Yt9KD7y8Fh2/SHc2HUbovTy6VdHGuxM16QYqSgfQQAyeE
	 7eRUIfRFzapPZS/C6QfapLqFT8yJCZ/4pL8Fz/ZOYZ7kQWUvQDXTKLDezl0jEk4ghWIdg
	 GuZi1YbNF66X3HNIfYAbneUhskMSuyhV552G/QCuvlMoDUE0S6ZjeNEm2LgvNenYNHKs2
	 yf5xKAkHj5CdlLHgcZxN8EBqB2ZXpNKAHkhKfFBUtBOZUf91Rr4c+mBb4qfXIF6lBXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793264055;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=MZWjl4IDtrGxyEmOGVyKe8shE1SzFnQKi/23wyxVeJA=;
	b=PUBSfN/dG3dH5gP+T85aKMHGJSW8zQTL+JxtQo34Z54+MMPsUxCX5OeRN/+TcUSM48UP
	 IoN4r+90Dq8OYNLuGopuOkvzz6p7Bm/1ObP/tgKyuJ7k0vh+mDJWFgouZZlLreI47L7Q7
	 6e4sfbeCcT6CedVRPYJWnCmtJ4b8ayS8I1Mr6wWQamDx8edIYAMZoFPoGKxd4NHpN9QF1
	 YrHD3GlS1GJuY6V287f7KGLLs6A3eRMZ6ZQEwa2KVYBBWZjtP+bQ9YQ2/4LNWe+bPT6xl
	 F6s7syVaCHerJJTtxBOpktHTY1Ijl7gqMREeV/dhQkkG4PqIpk6YMswG1EgTPvYG64A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=cf0sb9EP;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QByszS9g;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=tehb8DMb;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=d99JzZvm;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E793606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 08:54:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E793606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=cf0sb9EP;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QByszS9g;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=tehb8DMb;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=d99JzZvm
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 59103226AA;
	Thu, 29 Oct 2026 08:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793264052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZWjl4IDtrGxyEmOGVyKe8shE1SzFnQKi/23wyxVeJA=;
	b=cf0sb9EPjYJdLsXXFuKwuB6XDeCCXPp9Dby1U1LWwdAVucRNFxIAPfcaL+5cwGZz7MLA2V
	ZE94IE+fSEA9YYCc5y+Z2D9UaTaPmQd5r2ag066/5NFqRFoStXIiOuwbIy9nz4JzAmG73J
	7M42Fu+HybOgyuIZD2H85hWXN0iW+7A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793264052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZWjl4IDtrGxyEmOGVyKe8shE1SzFnQKi/23wyxVeJA=;
	b=QByszS9gzTEXY/zr7hL0xmeKyz4EyRYRD+CrFgp+NMzLgad3VlGammE18IamalaEqgGC9p
	9FNZOrh2FiP2lOAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tehb8DMb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=d99JzZvm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793264051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZWjl4IDtrGxyEmOGVyKe8shE1SzFnQKi/23wyxVeJA=;
	b=tehb8DMbbdiecqXMFz8AzPcI7jsQKpHCQwxKhpGAXI38Pr7/xse4UTRCKde1yke54TZaoq
	/jjgVmTLP03gywYGEjY6o+ewV3KgTe0IonHQxbNveltIaqxhRDl1hro6veAV5SBY9crPod
	aPaKXvDVSnG3I4PyC3f7bGPc5LTL894=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793264051;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZWjl4IDtrGxyEmOGVyKe8shE1SzFnQKi/23wyxVeJA=;
	b=d99JzZvmcyisXlmReOt8vBAeIsvQ1hDKk0ZWaDh7OKoxvAMKLqqnEIFNALHzygql/JcdQ1
	i8B1F9cBkvzuROAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C0FF1339F;
	Thu, 29 Oct 2026 08:54:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ohKSNbIJ42qoXwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 29 Oct 2026 08:54:11 +0000
Message-ID: <6c553315-46f6-4b27-86c3-648450ba41ea@suse.de>
Date: Thu, 29 Oct 2026 09:54:10 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] scsi: core: Move REPORT TARGET PORT GROUPS into
 the SCSI core
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Hannes Reinecke <hare@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
 Krishna Kant <krishna.kant@purestorage.com>
References: <20261029002531.82824-1-brian@purestorage.com>
 <20261029002531.82824-2-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261029002531.82824-2-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 59103226AA
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,purestorage.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -13.50

On 10/29/26 1:25 AM, Brian Bunker wrote:
> ALUA is a standard SCSI feature, independent of multipathing, but only
> the ALUA device handler can currently send REPORT TARGET PORT GROUPS.
> Move submit_rtpg() into the SCSI core as scsi_report_tpgs(), together
> with the resubmission with a larger buffer that alua_rtpg() did when
> the parameter data did not fit, so that the core can read the ALUA
> state of a device itself. The parameter data format definitions move to
> scsi_proto.h with it.
> 
> scsi_dh_alua calls scsi_report_tpgs() with the same timeout, retries
> and parameter data format as before.
> 
> No functional change.
> 
> Suggested-by: Hannes Reinecke <hare@kernel.org>
> Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/device_handler/scsi_dh_alua.c | 63 ++++++----------------
>   drivers/scsi/scsi_lib.c                    | 52 ++++++++++++++++++
>   include/scsi/scsi_device.h                 |  3 ++
>   include/scsi/scsi_proto.h                  |  3 ++
>   4 files changed, 73 insertions(+), 48 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
