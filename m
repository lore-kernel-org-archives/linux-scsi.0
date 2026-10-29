Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793264106;
	b=MhOC0bYnLEBhARwRdvwV5v5uZhslt4KCKzPEYKO3jriwNavuJp/hGy4z/DFLg49EHffd
	 WmJNYHDlhTWAAHh5wYhjX5gd7l9lrCm0egK3/LJ4l+cI+/2/x/mPTCW9YOi4fjml9tlGe
	 mrmwK/lWavDU5KQlBuTg9krZbSDhYZ554+bmbnoCspkW6YW9Ld6ma6DKf14VuKFy/Ntdr
	 DWe6GTF+DXBh89zJp2xOAicJSNHAKNxlfJ6AkWce3+6di9iChKzMJ6gM2qw8xNfXGjKcy
	 vUffCH1OE0xf5HVnVGiUGegK/hl1cGJ0II/BxQdXhNS2XO5cKeqp0gN491IE6GLC74w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793264106;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=EdMtTwsajzBH7gU5HUpZa4PfhaTsUN8O9oAkqPuHMCQ=;
	b=3e85GRIK2/qgOSTbhUHXi0PPJIai9i4uB6Upu62yYj487roiGuOtoYiyFpX39ERylxIw
	 mZa3AfqwUbCOYB7REjRO3qUHxcAC6ULKynn2ZZ7MdnmbHpxufrzWNciQdzUkS1x8+Mbfo
	 9f3I3R5VzUxyCeuD9EV//EwJn+dJLzf893hb7yILbrkj6C6n+dJscqoJDpfq+8CAN0qS0
	 J/nesHia8QmSXxDLYC66g3NoAhOXF1hXmaN2YC+rL2tIThhxaUj2KCwaz8vEOscZhYdfb
	 BA1vUs6TK0O/I42upU30mLP0NqLSoNrJMtEmrKuR1yXTZiAqtKbGsCq5n4oHILn6axA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IvmGWFSc;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jG29vRRt;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IvmGWFSc;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jG29vRRt;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4338A606A324
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 08:55:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4338A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IvmGWFSc;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jG29vRRt;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IvmGWFSc;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jG29vRRt
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A3B4226B8;
	Thu, 29 Oct 2026 08:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793264104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EdMtTwsajzBH7gU5HUpZa4PfhaTsUN8O9oAkqPuHMCQ=;
	b=IvmGWFScMZeIaupz5+JoAbn3i/JbguLDapW9db/hRenD++UXa4biFifmX+u7/t4xxXWcjz
	C1kA5vYxX+K4jfDrnPEl61F33nmszOLrZL+wsA3kjrRVMm/Bhl/w7QmuUI6yUL8EgUtWud
	soUmb1+2yLgNJSE0nsDaBgRyRWkIOBs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793264104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EdMtTwsajzBH7gU5HUpZa4PfhaTsUN8O9oAkqPuHMCQ=;
	b=jG29vRRt+fIAa+elgICmAet+LrU2lDd5KfnTlbCFudEE/QobH6IhUqVb8XOUvDqpEDhCE+
	3wC684B09AvJg4Dg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IvmGWFSc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jG29vRRt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793264104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EdMtTwsajzBH7gU5HUpZa4PfhaTsUN8O9oAkqPuHMCQ=;
	b=IvmGWFScMZeIaupz5+JoAbn3i/JbguLDapW9db/hRenD++UXa4biFifmX+u7/t4xxXWcjz
	C1kA5vYxX+K4jfDrnPEl61F33nmszOLrZL+wsA3kjrRVMm/Bhl/w7QmuUI6yUL8EgUtWud
	soUmb1+2yLgNJSE0nsDaBgRyRWkIOBs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793264104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EdMtTwsajzBH7gU5HUpZa4PfhaTsUN8O9oAkqPuHMCQ=;
	b=jG29vRRt+fIAa+elgICmAet+LrU2lDd5KfnTlbCFudEE/QobH6IhUqVb8XOUvDqpEDhCE+
	3wC684B09AvJg4Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 482AA1339F;
	Thu, 29 Oct 2026 08:55:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pqmFB+gJ42r9YAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 29 Oct 2026 08:55:04 +0000
Message-ID: <999ae7ca-4914-4bcc-8d3f-23956880a4ed@suse.de>
Date: Thu, 29 Oct 2026 09:55:03 +0100
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
Subject: Re: [PATCH v3 2/3] scsi: core: Read the ALUA access state when a
 device is scanned
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Hannes Reinecke <hare@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
 Krishna Kant <krishna.kant@purestorage.com>
References: <20261029002531.82824-1-brian@purestorage.com>
 <20261029002531.82824-3-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261029002531.82824-3-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8A3B4226B8
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,purestorage.com:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -13.50

On 10/29/26 1:25 AM, Brian Bunker wrote:
> sdev->access_state is only set by a device handler, and the ALUA
> device handler reads the state with an RTPG that runs after the device
> has been registered and matched to a driver. The SCSI core therefore
> has no ALUA state for a device while it decides whether to bind an
> upper-level driver to it.
> 
> For a device that reports TPGS support, send REPORT TARGET PORT GROUPS
> from scsi_add_lun(), after the VPD pages have been read, and set
> sdev->access_state from the descriptor of the target port group of
> this path. UNIT ATTENTIONs, which a target typically reports first
> after a login or an ALUA state change, are retried, and the command is
> resent without the extended header if the target rejects it. If the
> command fails, e.g. with LOGICAL UNIT NOT SUPPORTED because no LU is
> mapped at the LUN, sdev->access_state is left as it is.
> 
> The command uses the same timeout as the INQUIRY of the scan. The ALUA
> device handler keeps updating sdev->access_state afterwards as before.
> 
> Suggested-by: Hannes Reinecke <hare@kernel.org>
> Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/scsi_scan.c | 94 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 94 insertions(+)
> 
Nice. Something I wanted to do for a long time.

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
