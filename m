Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A7220B04;
	Wed, 27 Mar 2024 07:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711524787; cv=none; b=kuIINBGehoDA94JfWeZdCQ3JswgbiYJw9eu8gr1lhhZ6QeXAfM9zIFucemK5ZyPjYtLuzlXYqiBbqluDoPhb2a76FLHn7oMmTiTI8B2sDXumc4uws8AKLSgSBYLrkpRJja77dtoYhYnyOLAMaOXiTKOiUo2Sb4q7l+S7tb54jpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711524787; c=relaxed/simple;
	bh=JK3p4J57aqXJYO88/FikNreooE8VQitzNxJi/6A23wk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZQAeHdJtGd//6TdOYOAFK0KL/Ph8f+glJaeq+14fglXLTgM1Q1l+VixhZwb/YOYPVontrSVym4QyTGcH+KrBiI6EbZj27QO4ZBsAeV+Ymo2YYOvk8AIgMT5lw0wuJCiWDzvhHWLufRXoRSlbLSMWhY3Dh1unPT1KYAT3i15aITk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sEtvniPA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0f9EwBI3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sEtvniPA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0f9EwBI3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sEtvniPA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0f9EwBI3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sEtvniPA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0f9EwBI3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1E9485FAAF;
	Wed, 27 Mar 2024 07:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711524781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qGfK7/s/ZI9R2hpHto34S9brkysQqVRsKkoZ7EZnj8I=;
	b=sEtvniPAA1SnC3A7G0Jyd+qp+pky6Jz8Fj6F4Y+AF0X1+wNgw8C7v1eGABcaULhRJeOdev
	j7Pp+RT+mYSvLduwmZ4+vNo1o1vwSqIYTZwNNzVnXNPXUOs6gV9k5qaMkKv+RJeuffjqOB
	+SeCzmzKt1IEr5I6jpx7SeXCO6jXwtg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711524781;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qGfK7/s/ZI9R2hpHto34S9brkysQqVRsKkoZ7EZnj8I=;
	b=0f9EwBI3Kbq6h8kIvLA4Ax4uMPhcf9zCDO9QqEWqLQrfXXT3V5qhqj4/B85eZquwcLcqDu
	VLMSbkvA7FJYWYAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711524781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qGfK7/s/ZI9R2hpHto34S9brkysQqVRsKkoZ7EZnj8I=;
	b=sEtvniPAA1SnC3A7G0Jyd+qp+pky6Jz8Fj6F4Y+AF0X1+wNgw8C7v1eGABcaULhRJeOdev
	j7Pp+RT+mYSvLduwmZ4+vNo1o1vwSqIYTZwNNzVnXNPXUOs6gV9k5qaMkKv+RJeuffjqOB
	+SeCzmzKt1IEr5I6jpx7SeXCO6jXwtg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711524781;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qGfK7/s/ZI9R2hpHto34S9brkysQqVRsKkoZ7EZnj8I=;
	b=0f9EwBI3Kbq6h8kIvLA4Ax4uMPhcf9zCDO9QqEWqLQrfXXT3V5qhqj4/B85eZquwcLcqDu
	VLMSbkvA7FJYWYAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F4B21369F;
	Wed, 27 Mar 2024 07:32:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IMYDEavLA2ZKewAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 Mar 2024 07:32:59 +0000
Message-ID: <3ddab2f0-f10e-4ec1-a40a-8662cb6f3a56@suse.de>
Date: Wed, 27 Mar 2024 08:32:57 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/28] block: Remove zone write locking
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-27-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240325044452.3125418-27-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sEtvniPA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0f9EwBI3
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-5.50 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
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
X-Spam-Score: -5.50
X-Rspamd-Queue-Id: 1E9485FAAF
X-Spam-Flag: NO

On 3/25/24 05:44, Damien Le Moal wrote:
> Zone write locking is now unused and replaced with zone write plugging.
> Remove all code that was implementing zone write locking, that is, the
> various helper functions controlling request zone write locking and
> the gendisk attached zone bitmaps.
> 
> The "zone_wlock" mq-debugfs entry that was listing zones that are
> write-locked is replaced with the zone_wplugs entry which lists
> the zones that currently have a write plug allocated. The information
> provided is: the zone number, the zone write plug flags, the zone write
> plug write pointer offset and the number of BIOs currently waiting for
> execution in the zone write plug BIO list.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-mq-debugfs.c    |  3 +-
>   block/blk-mq-debugfs.h    |  4 +-
>   block/blk-zoned.c         | 92 ++++++++++-----------------------------
>   include/linux/blk-mq.h    | 83 -----------------------------------
>   include/linux/blk_types.h |  1 -
>   include/linux/blkdev.h    | 35 ++-------------
>   6 files changed, 29 insertions(+), 189 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

