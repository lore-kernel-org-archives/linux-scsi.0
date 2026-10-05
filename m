Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2FC46C4B4;
	Mon,  5 Oct 2026 11:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791198606; cv=none; b=ARrYS3oIe/Gd6+7jyBKvs2UQHmfvTeqry2GamCRNzh+4UXwgUc7psq96RF3Izxmw7LvjKGblSwoOryoR0R9zJ5qDTp4PtkynDT5ciQiu9IRJaIPYfhiLWs3jjiqkRbgi4gcrFg1mqAIUbbGhfobMyimf2SRZPdEs1H1ozoHcTV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791198606; c=relaxed/simple;
	bh=UKoR5d4yfTlMUVd68p5y7VUYj5fGSpl8Tw5SZ8RHAi4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Vo4ByJ6rGUmwoHb22nKDQTbGsAmSeLc3LhXWTMpYYcgar8Q6ICVmEqN22JtO8gzlnkLrfccwAM4lFcKA75kr5sM/cTpDUdDiVBtx+TpjzhvSLt9T1DUXKoJPQqz76FxjvaDcSqd6ERyUwxkbGtQbNxGxkRVsQglwx+7DDqUQWFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FmJIqz7H; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0nxtW2YV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VTW1J3NP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SVSr1NWt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FmJIqz7H";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0nxtW2YV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VTW1J3NP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SVSr1NWt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CF81221D0D;
	Mon,  5 Oct 2026 11:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791198599; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XqblWCPFklnQJgFEWLypR27D3RJqzGXaBqRqZxynv/I=;
	b=FmJIqz7HiDEDLe6eESMC+1Se5KzB6cSAOnr6FhKbZTDs6pQE1LFGtI5g6gx1hPSdN14VLW
	ps5JPNZEQrCpV5l0TN/AfyK6jJDaDZaCdWdw1rwTgLj+yc8kUKmZqrsYtFjL3rUTGRHKf7
	WnE9Z0WKkqsiqM7YWAgTibEVm+ek0NU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791198599;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XqblWCPFklnQJgFEWLypR27D3RJqzGXaBqRqZxynv/I=;
	b=0nxtW2YV8RQL86fDitwIYEp+JGxYhCpgGjUfcJGiBI6q01GQu6m116ZDKvEUWbT42+spDk
	r9Isb56sLEYFfUDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VTW1J3NP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SVSr1NWt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791198594; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XqblWCPFklnQJgFEWLypR27D3RJqzGXaBqRqZxynv/I=;
	b=VTW1J3NPWirB3cX7Aw5Xns4NNEAmKJFJufMWGhpfELG8XldYFIfn4JbW6KVtp6B2xHKlBx
	RPtL/45SUjywWuwjIY1GUp++V7hkAMa1jRWKFp/ceJXdOhB5EDS1pVmMWPaQS9ZxD40UNh
	hRYCU/wImGhRgA3W5ZiJUSpIZO852uI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791198594;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XqblWCPFklnQJgFEWLypR27D3RJqzGXaBqRqZxynv/I=;
	b=SVSr1NWtt4My6o83ih7nVW3QXKij8ABdGZHLeHneKceEQpAX5+c3w3ECmDV9YzIsPfPot1
	hBGFGiyxu4vv/TCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9DF69139BF;
	Mon,  5 Oct 2026 11:09:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0v9vHYKFw2pUUwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 05 Oct 2026 11:09:54 +0000
Message-ID: <766d3409-4f39-4e45-af93-bea18c7bb580@suse.de>
Date: Mon, 5 Oct 2026 13:09:46 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] block: add storage element management ioctls
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261005094632.580753-1-dlemoal@kernel.org>
 <20261005094632.580753-4-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261005094632.580753-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CF81221D0D
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:email,suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 10/5/26 11:46 AM, Damien Le Moal wrote:
> Define the new ioctl commands BLKGETNRSTORELEMS, BLKREPORTSTORELEMS,
> BLKREMOVESTORELEM, and BLKRESTORESTORELEMS to provide users accessing
> zoned block devices directly with an interface to the storage elements
> management operations of the block layer.
> 
> The ioctls BLKGETNRSTORELEMS and BLKREPORTSTORELEMS are defined to
> respectively get the number of storage elements of a zoned device and to
> get an array of struct blk_storage_element describing the current state of
> the device storage elements.
> 
> The ioctl BLKREMOVESTORELEM can be used to remove (depopulate) a storage
> element that has a degraded status (i.e. BLK_SE_STS_DEGRADED).
> 
> Finally, the BLKRESTORESTORELEMS ioctl interfaces with
> bdev_restore_storage_elements() to restore the depopulated storage
> elements of a zoned device.
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
