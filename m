Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4F845FFD7;
	Tue, 18 Aug 2026 10:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787049204; cv=none; b=Z0M/IWoblAqMENG5YNKhTgQuDFvIgAi7Gt5hRNB2zlerWv3oIgggl4SCzV3/wDhFuO2qHIHEPrBxFeEAUtl3Y9AyWhNCCiOGKui1uN0yrQXqVOLz6ZjegSxrqCcFlQqHzkcFVQBVOc04orfPXY4PaFXqsAXekYnP4zzVTSp81PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787049204; c=relaxed/simple;
	bh=eeVjAgqewkozAiBbtgX+TsMljaZehV6cIUZV2YLQW+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n3DLbcMjwHoh1eI2s2gXc6kIF8lWi9e8ydMTdWgFfRrNIcJt7y+yFd0q7lLU2/apIVE4FuTezrjXZzJuyMxTfzM5AAyPAkIt8BhkqNRrANCORwip2UunD7fxEGXVO6pXNE6OLBNDgCf46zxlOng0qd4NcMv3Al06+lpRmzUtkeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uxW0jaCw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Q+7zrDZw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sAB2Te+o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2jJxqJ5b; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uxW0jaCw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Q+7zrDZw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sAB2Te+o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2jJxqJ5b"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 22DE33E43;
	Tue, 18 Aug 2026 10:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787049196; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hajFIrQyCHqzUS+imbiKOjxd+SjzPOZ/FjaQYcoIJZc=;
	b=uxW0jaCwDeghPDckED3gDJmXBF2L1KXNvWQwNQcvkpCYUTSIJFfHZQD8NmX7526XdRWgp2
	q8qPhbmESwKShUSdmrQ7CYIxy1mXW8FK52yLzlB/+cCdeKBLD4zbl8pEvJBs+zMLAtSW+U
	d62o1Qy70uDPutY4EMinPeCcfk/UTi0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787049196;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hajFIrQyCHqzUS+imbiKOjxd+SjzPOZ/FjaQYcoIJZc=;
	b=Q+7zrDZwmusR/vv2cEVcf6RWUVwCIgC/jZB9QMCaAsd79PR3XpcaW0N8AQ11UsFU3dNnNi
	U3HxtHUAPzl54uDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sAB2Te+o;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2jJxqJ5b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787049192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hajFIrQyCHqzUS+imbiKOjxd+SjzPOZ/FjaQYcoIJZc=;
	b=sAB2Te+o2xnRETmTLvuIvnoZ20uJWHJ0TYPNSy1AhUNh2dULDv0jJx0cyr241PulZOWYkV
	t0i/It3wY+89PVMQZoJzWYNsEtcMV6VQEsZyzEntXOWaJ+hOtzUOBK4b3hUZJZiHf0vAbF
	COtWvP6HXK5jzeY4nuU1s31K1XBQ8QQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787049192;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hajFIrQyCHqzUS+imbiKOjxd+SjzPOZ/FjaQYcoIJZc=;
	b=2jJxqJ5b8IzXrfXBYYTRsoDvh8gVFCNz3zZPXOA8ts03GUipyAT2CRMybaXRFNckIVx1nD
	PkuUtCZu61m+GwAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5AEE22BA;
	Tue, 18 Aug 2026 10:33:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Cp0EN+c0hGqKGQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 18 Aug 2026 10:33:11 +0000
Message-ID: <ef23cb9e-f358-40a2-b494-a78f4983d0ad@suse.de>
Date: Tue, 18 Aug 2026 12:33:11 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: core: Drop Scsi_Host.default_lock
To: John Garry <john.g.garry@oracle.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org,
 linux-s390@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-usb@vger.kernel.org, John Garry <john.garry@linux.dev>,
 Damien Le Moal <dlemoal@kernel.org>
References: <20260817075324.2737619-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260817075324.2737619-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,acm.org:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,linux.dev:email,suse.de:email,suse.de:mid,suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 22DE33E43
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On 8/17/26 9:53 AM, John Garry wrote:
> From: John Garry <john.garry@linux.dev>
> 
> Back in the 2.6.xx days, it was possible to for low-level drivers to set
> the shost lock pointer. That is why there is a default lock and a pointer
> to the shost lock.
> 
> However, support for this has long been removed, so drop
> Scsi_Host.default_lock and make Scsi_Host.host_lock as the actual lock.
> 
> Getting the address of embedded host_lock structure just requires adding
> a fixed offset value to the shost pointer. However, getting the value of
> the host_lock pointer requires loading from a fixed offset to the shost
> pointer. The latter should be very slightly slower, which is relevant as
> this lock is used a lot throughout the core code and drivers.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> Acked-by: Damien Le Moal <dlemoal@kernel.org> # ata parts
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
> Difference to v3:
> - Rebase and update some annotations
> 
> Differences to v2:
> - Add tags from Bart and Damien (Thanks!)
> - Update Documentation reference to default_lock (Bart)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
