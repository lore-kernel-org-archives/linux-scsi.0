Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002993859F8
	for <linux-scsi@vger.kernel.org>; Tue,  3 Mar 2026 07:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772521512; cv=none; b=BVHvSGWOtaSWwakeJ58ZBc9SW6nn0KGf11DvyNYrKbcEKz/IBkDfusfXfKGDukhPGMC5Lzt+eaLdWI4Lx+LYq986Fjj4669+F7cFjhC2j7V4jiW33vHRAbv1tTBh+x9PVaqZ2cnSu4i9V7fJtwNqr/ZId6iJ7VrvnWTRp7Om2f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772521512; c=relaxed/simple;
	bh=OK85ODcXSI14pHW0qavR2jzAcmcSAt2oan2mNZv/Brs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Kg0Wx4a2VrlgJ6h2BEFe89gd5uLKzxdEA8PC7mdV+lPHwmNys2YTbuWrfVFSm2997wZOgvLH7CyJ2LFQfxWdCGZ8rp0mXRF7gwNqC8ugGyLVtYhbfaddpIon6zhnfyvzqYnQUNIhEUD+xxcLOpO1W/08FnrpGmOjrJvC8u512Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b7bGWMoL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hCBv1slS; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cdiT0o1t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=G6vp1Oyj; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b7bGWMoL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hCBv1slS";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cdiT0o1t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="G6vp1Oyj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D9CBC3F82F;
	Tue,  3 Mar 2026 07:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772521508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbqtGQb2uRnaIeW2MpYChMLVJcwORfI33Kj45iR5gD8=;
	b=b7bGWMoLOoDCZ26WjcpqihlrGzrArS2YeOhAXLEKm5snTwFGoZVqkZ8XCkQJIk3VleLja6
	dSO/ktVRHj1VHBGHNtaNsBi2SSmGDZ0FfpDJOPspMRsmvBDDTFcjgPko5UmfEEkO1kH/YO
	q3FO9HHRDUYRrnRqpo/x3UhrspaowLY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772521508;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbqtGQb2uRnaIeW2MpYChMLVJcwORfI33Kj45iR5gD8=;
	b=hCBv1slS+nbBHnG32l+Y5Nc/BsLk9YqcZV5QF+5TH+iyedtJVK7fAYvYHU3F5XuLmVW6Hg
	5ggeAEQdM+3JuAAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772521507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbqtGQb2uRnaIeW2MpYChMLVJcwORfI33Kj45iR5gD8=;
	b=cdiT0o1tQF4nCZN2lEtBxgukeo3434zDN8hmYw3dTOybk1kMrAwbpBUOzRGkpkCa29Y5IZ
	7SqnSzwY6tYvFD3Xrcro3bFLKXNykay6t5c22n2TNsPIy+2/w/unLaur3sxrquFoltJArI
	gSBLP6Sersr4fFGye5MSSvzSLNi9d9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772521507;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbqtGQb2uRnaIeW2MpYChMLVJcwORfI33Kj45iR5gD8=;
	b=G6vp1Oyj0nd2IqH6dGlJSzy0/UfhTeBd3Uk6Lgm58EZK1e+QazOV8G3wPnzDf1PSSDt+Ro
	N4M+SeFm945QbBDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2BF7D3EA69;
	Tue,  3 Mar 2026 07:05:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id toBfCCOIpmmDLwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Mar 2026 07:05:07 +0000
Message-ID: <a8851c28-bd31-47e3-9af9-e299ed0780cb@suse.de>
Date: Tue, 3 Mar 2026 08:05:06 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: remove bdev_nonrot()
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
References: <20260226075448.2229655-1-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260226075448.2229655-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 2/26/26 08:54, Damien Le Moal wrote:
> bdev_nonrot() is simply the negative return value of bdev_rot().
> So replace all call sites of bdev_nonrot() with calls to bdev_rot()
> and remove bdev_nonrot().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/md/raid1.c                  | 2 +-
>   drivers/md/raid10.c                 | 2 +-
>   drivers/md/raid5.c                  | 2 +-
>   drivers/target/target_core_file.c   | 2 +-
>   drivers/target/target_core_iblock.c | 2 +-
>   fs/btrfs/volumes.c                  | 4 ++--
>   fs/ext4/mballoc-test.c              | 2 +-
>   fs/ext4/mballoc.c                   | 2 +-
>   include/linux/blkdev.h              | 5 -----
>   mm/swapfile.c                       | 2 +-
>   10 files changed, 10 insertions(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
