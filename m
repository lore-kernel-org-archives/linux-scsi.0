Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705592231F;
	Sun,  4 Feb 2024 12:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707050140; cv=none; b=aDlxAY56DaWmGS38cI+kQEyWc2c+OM163mshDdvZlpIjEGtG6GTwICpuy6C36PJ84IC8S0Z1H2D7a6nYtytR8T+axLvDCjlRPkIzmIVNLgdM6myfESmkFVrXEBilWQwt4bKWSOG+JtWfdp2m7DMippfVfmb2PUrDwjoHbpad3Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707050140; c=relaxed/simple;
	bh=yfCBrxr3QbfstzcEmTKhXWKbOYEbFPwXV4v8P4BC7Go=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dskMbYqPOu7dqONG6g1vbht882cJpunkqyRmiAdb6smGw14pZWXO2jO+nWkGmvOmpU2SvQi7KLmn3tJXheQfXmXgEiikvtGouK3kBPABXdeEOIyTwxFaGqYnR6o6XF0tSZrih+ILthIZH4N5DcQ+kb+2+Wm6VM7ZMTzUG7N/j7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Iyxtlylv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zsUUsOpC; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FDrKXHeX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QG36RcTz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Iyxtlylv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zsUUsOpC";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FDrKXHeX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QG36RcTz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BAF921F810;
	Sun,  4 Feb 2024 12:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050136; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FNVrpIJnq2TUfZByhK9rYfVDWE2BdHGKJZhj9lqtve8=;
	b=IyxtlylvNvFv9tF3hUPjF1jjsAO1TPiVQdvzorQLt22ndA+pUxtEQH+NemgeaFohde/i+x
	1Q+drR7WMVRDyNYXx36PcVzBXKDj8/WIhA/GOkwTAYvJjcJl5V+8MdTZL1We5c0cX2HLXj
	rXrNihd7yTdtrMy+cIx2YAikS+JkcRM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050136;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FNVrpIJnq2TUfZByhK9rYfVDWE2BdHGKJZhj9lqtve8=;
	b=zsUUsOpCqQQXiNBCy6Y4p/69P9AgiyYYkB8BL8TNPR1q/5DJFHYf/s+XhkL96HIHGzDf1J
	25Qna1g2UBTLEvAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050135; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FNVrpIJnq2TUfZByhK9rYfVDWE2BdHGKJZhj9lqtve8=;
	b=FDrKXHeX10fNpjXUkI0rLHSVokGUi/1ZHRcGuktndeQb8XOaTEHbVPx6F1D7BSh9bKz8l2
	3yTzI47Czwj87fQfOlXjG5m4SR2g4iE32Z/a7VSv+modnamgtWkz2qvSHISTNXoXShTJyr
	mkTafJCjcSU0PKmjkxIwN0CWhk+rKSg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050135;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FNVrpIJnq2TUfZByhK9rYfVDWE2BdHGKJZhj9lqtve8=;
	b=QG36RcTzJekpOnwLrGQHfatx73Kw+hnsDw9OFepvc2TqbTYagLcRjgx7xxV2b7nUJzM6W6
	wxVHA0eOK/GWlkBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C70B0132DD;
	Sun,  4 Feb 2024 12:35:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WGfyG5SEv2U8JwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:35:32 +0000
Message-ID: <39c7b6c5-8d09-49e9-8dfa-95dd0d846c91@suse.de>
Date: Sun, 4 Feb 2024 20:35:32 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/26] block: Simplify blk_revalidate_disk_zones()
 interface
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-19-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-19-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FDrKXHeX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QG36RcTz
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.46 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-1.96)[94.78%];
	 MIME_GOOD(-0.10)[text/plain];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Score: -3.46
X-Rspamd-Queue-Id: BAF921F810
X-Spam-Flag: NO

On 2/2/24 15:30, Damien Le Moal wrote:
> The only user of blk_revalidate_disk_zones() second argument was the
> SCSI disk driver (sd). Now that this driver does not require this
> update_driver_data argument, remove it to simplify the interface of
> blk_revalidate_disk_zones(). Also update the function kdoc comment to
> be more accurate (i.e. there is no gendisk ->revalidate method).
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c              | 16 +++++-----------
>   drivers/block/null_blk/zoned.c |  2 +-
>   drivers/block/ublk_drv.c       |  2 +-
>   drivers/block/virtio_blk.c     |  2 +-
>   drivers/md/dm-zone.c           |  2 +-
>   drivers/nvme/host/zns.c        |  2 +-
>   drivers/scsi/sd_zbc.c          |  2 +-
>   include/linux/blkdev.h         |  3 +--
>   8 files changed, 12 insertions(+), 19 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

