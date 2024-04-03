Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D282286A6;
	Wed,  3 Apr 2024 06:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712126638; cv=none; b=dk2C0wWgJluNvz0h27LdYNXlLJ6p0MC0lB6zOY0MNgOmWGkd3g2qtx9R/erxRkuGeqUchIimkKgCpbea0o5LRyIJkqUG82hTBPSdvbh+KvVLXLt33g4vdwyu9gt+ewXlzLCOtm7Irzy7noJPhs++GMaoPkcKckr82dTPRqghaho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712126638; c=relaxed/simple;
	bh=hu9QtLjyK6wVJ3/hEWWz9bv0OUTJqk87uTvKN3pUXQU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gWZ+QML8VqwDk2wuI/bli+zYVSE79HmhyoZiogwstTFFOmTreLMcWUh1AehnQh5VHQ9TAki0Av05otoccupeiDJMY+sTRjolJgnX7lSavAar8ztrOS+sFt1MEtMKnmx8hnDHmlORN2PvLEOyAsbUizOMG+EyrkeZM5fwQzO633o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LzAyYI5W; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Kw+IIckA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LzAyYI5W";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Kw+IIckA"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8CA9134A5D;
	Wed,  3 Apr 2024 06:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712126634; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=izq0l1gzPKeK2FgY7V9j6yta5A0KmRZtEWYVCHCjvGY=;
	b=LzAyYI5WmNtWxNUULmQUslBaFeoCyvSc+LXpgmnpahQXK9m9r0bLVRECZYzl84LXy/xN/1
	Js8YZRoqbbhVfOb+GQqilhBsF9oCtUdo2Qmyf9bpz9WWFz/uDjcE5/Ku2DuL3+s4Z2g24H
	3FSIaS8Hcxg3tcl5iFEwAG0ME7j8NTE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712126634;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=izq0l1gzPKeK2FgY7V9j6yta5A0KmRZtEWYVCHCjvGY=;
	b=Kw+IIckAfYT4bdCFq/KFfyWtznQcyy7Jeu08iBuV6Ls4+6+8r38UmDYwbnzIPzqYxELMoq
	3use7UzIv+Pj6tAQ==
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id E164713357;
	Wed,  3 Apr 2024 06:43:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id WF+NM6n6DGb8CAAAn2gu4w
	(envelope-from <hare@suse.de>); Wed, 03 Apr 2024 06:43:53 +0000
Message-ID: <d70a3815-6d78-4761-a4df-a11a4d0034e3@suse.de>
Date: Wed, 3 Apr 2024 08:43:53 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 26/28] block: Remove zone write locking
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240402123907.512027-1-dlemoal@kernel.org>
 <20240402123907.512027-27-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240402123907.512027-27-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.29
X-Spamd-Result: default: False [-4.29 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[10];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On 4/2/24 14:39, Damien Le Moal wrote:
> Zone write locking is now unused and replaced with zone write plugging.
> Remove all code that was implementing zone write locking, that is, the
> various helper functions controlling request zone write locking and
> the gendisk attached zone bitmaps.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   block/blk-mq-debugfs.c    |  1 -
>   block/blk-zoned.c         | 66 ++-----------------------------
>   include/linux/blk-mq.h    | 83 ---------------------------------------
>   include/linux/blk_types.h |  1 -
>   include/linux/blkdev.h    | 35 ++---------------
>   5 files changed, 7 insertions(+), 179 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

