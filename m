Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0AA224CF;
	Sun,  4 Feb 2024 12:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707050564; cv=none; b=krFzKKebIp3iOEiFB4MhctYviFV7B/cf84YC2CLymTnQQ57xsQUwRc52/8+aKWuUIJ15kU6j6Xg4fU9tpFZrEecdZvM43+BjQ4e6G8YJEI272Xd9kTYrVbEbsuTuNNCOuGJZXDOE9j4x5AKefxSxU+FNj+BbPXheEXEu+K0JGVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707050564; c=relaxed/simple;
	bh=Q1XyrjZzGlitiqipAvAjCcCQ66PNa68ehlqSlVfXcBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=javwqstW1fYxlFAF3dP0vC6HzsTnfSqmFAX178kUnvPIKi4xGYBP0oLb/inYcbhhSQMqCbr0MoWJlGu1yd5LdbklCaHV09hFkrwWnhKAqUzZkrnWE8UYwdnME+4GLpiSEPkelH/pX1pLuw/yVMg3ItLo5hvw6XD8VNQhUqZ2HhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PFAb8VqK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7cWVsAjz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PFAb8VqK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7cWVsAjz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PFAb8VqK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7cWVsAjz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PFAb8VqK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7cWVsAjz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 151BC2200A;
	Sun,  4 Feb 2024 12:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GwAWViAYjJs70nR9dqAzlbrzbcCp3MOY2nyJBkdCYf4=;
	b=PFAb8VqKeMXfU+YPgQo7YUB7g/TmQYiWym7uogl0UBfOqBQDHw2AEU/OVx3RTcdhYxCM9F
	zwMq+tB0dH+QerLzkSaZKb7Hngrp6vBS+8DjMKS4cyHgA9Dx+X0h2IVYazd6SQBBbdAYvq
	1ULm+7ZWShDrdvUac8FHTGgnqpDwP5Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050561;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GwAWViAYjJs70nR9dqAzlbrzbcCp3MOY2nyJBkdCYf4=;
	b=7cWVsAjzl5hAey7sSAfhUGM1CbMI8gctDJOJjlN/KD9ZJY+BxX/yZ+xI1gKw4hq1KyUyKG
	veCqjjBdKvrKdgAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GwAWViAYjJs70nR9dqAzlbrzbcCp3MOY2nyJBkdCYf4=;
	b=PFAb8VqKeMXfU+YPgQo7YUB7g/TmQYiWym7uogl0UBfOqBQDHw2AEU/OVx3RTcdhYxCM9F
	zwMq+tB0dH+QerLzkSaZKb7Hngrp6vBS+8DjMKS4cyHgA9Dx+X0h2IVYazd6SQBBbdAYvq
	1ULm+7ZWShDrdvUac8FHTGgnqpDwP5Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050561;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GwAWViAYjJs70nR9dqAzlbrzbcCp3MOY2nyJBkdCYf4=;
	b=7cWVsAjzl5hAey7sSAfhUGM1CbMI8gctDJOJjlN/KD9ZJY+BxX/yZ+xI1gKw4hq1KyUyKG
	veCqjjBdKvrKdgAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1DF3A132DD;
	Sun,  4 Feb 2024 12:42:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CzJcLz2Gv2WuKQAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:42:37 +0000
Message-ID: <09d99780-8311-4ea9-8f48-cf84043d23f6@suse.de>
Date: Sun, 4 Feb 2024 20:42:35 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/26] block: Reduce zone write plugging memory usage
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-26-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-26-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spamd-Result: default: False [-3.09 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -3.09

On 2/2/24 15:31, Damien Le Moal wrote:
> With zone write plugging, each zone of a zoned block device has a
> 64B struct blk_zone_wplug. While this is not a problem for small
> capacity drives with few zones, this structure size result in large
> memory usage per device for large capacity block devices.
> E.g., for a 28 TB SMR disk with over 104,000 zones of 256 MB, the zone
> write plug array of the gendisk uses 6.6 MB of memory.
> 
> However, except for the zone write plug spinlock, flags, zone capacity
> and zone write pointer offset which all need to be always available
> (the later 2 to avoid having to do too many report zones), the remaining
> fields of struct blk_zone_wplug are needed only when a zone is being
> written to.
> 
> This commit introduces struct blk_zone_active_wplug to reduce the size
> of struct blk_zone_wplug from 64B down to 16B. This is done using an
> union of a pointer to a struct blk_zone_active_wplug and of the zone
> write pointer offset and zone capacity, with the zone write plug
> spinlock and flags left as the first fields of struct blk_zone_wplug.
> 
> The flag BLK_ZONE_WPLUG_ACTIVE is introduced to indicate if the pointer
> to struct blk_zone_active_wplug of a zone write plug is valid. For such
> case, the write pointer offset and zone capacity fields are accessible
> from struct blk_zone_active_wplug. Otherwise, they can be accessed from
> struct blk_zone_wplug.
> 
> This data structure organization allows tracking the write pointer
> offset of zones regardless of the zone write state (active or not).
> Handling of zone reset, reset all and finish operations are modified
> to update a zone write pointer offset according to its state.
> 
> A zone is activated in blk_zone_wplug_handle_write() with a call to
> blk_zone_activate_wplug(). Reclaiming of allocated active zone write
> plugs is done after a zone becomes full or is reset and
> becomes empty. Reclaiming (freeing) of a zone active write plug
> structure is done either directly when a plugged BIO completes and the
> zone is full, or when resetting or finishing zones. Freeing of active
> zone write plug is done using blk_zone_free_active_wplug().
> 
> For allocating struct blk_zone_active_wplug, a mempool is created and
> sized according to the disk zone resources (maximum number of open zones
> and maximum number of active zones). For devices with no zone resource
> limits, the default BLK_ZONE_DEFAULT_ACTIVE_WPLUG_NR (128) is used.
> 
> With this mechanism, the amount of memory used per block device for zone
> write plugs is roughly reduced by a factor of 4. E.g. for a 28 TB SMR
> hard disk, memory usage is reduce to about 1.6 MB.
> 
Hmm. Wouldn't it sufficient to tie the number of available plugs to the
number of open zones? Of course that doesn't help for drives not 
reporting that, but otherwise?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

