Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD2B14006;
	Wed,  3 Apr 2024 06:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712126511; cv=none; b=VfTDfROjvbpYSvcjzR0Qe0rSAVG/sra1WWejrRYWl0eGVfaFes4cknq/rK6wKdZa7AFGU72UlHJTS114FWWnZhvl5FB0FsEljfHLucmCqqm7tljG/UCrpe9/1rtccpeXLxlH7AOYfLkiPT49UtAvY4KxdXsGcWuuzwcOk8E+NvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712126511; c=relaxed/simple;
	bh=E9Ecl6XQRBm/yMMBLrmo4Gtab8qfD2drajpLDGTn/qw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OBtIsVbpLFaxko6NMwBLiBROrciHay0ChvQpwGxZD6teXQ6kYG7qUN2XrzG0tH3CWvP4ZBLLCohlasY7Hao9IW2j1HkL4uFJHVwX7ES/2JqroSrlET7LCaUnohzZSCI2cONNdAaq+E50mYxkSePPXxTZCxlO1RdhUSW6oXZyft4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=abrfw6Bg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2c0sKg+S; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="abrfw6Bg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2c0sKg+S"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 18E4B5C8E2;
	Wed,  3 Apr 2024 06:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712126508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=++gI3BgNddEsJjDazUZFQ5dNULCqFbKr3X7lMwf1zaU=;
	b=abrfw6BgsiZS0ga4vzE0rHZt5HLtv6VSaVEXArK7UJwJsBJleuBnAFJU4uNbJuOlWAEm9/
	5h7QXFUEJpvHBhH0w1dTRHHXESMEh3GAOHLe1uCQ6ZqLBfm29Xt0sOqRebXt8+9QK8ZRx+
	GvulbFynxhG38t+Th5aQe4Qrpw2EWgY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712126508;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=++gI3BgNddEsJjDazUZFQ5dNULCqFbKr3X7lMwf1zaU=;
	b=2c0sKg+Srs9LbwVsDTiIm7jRYG4JaKgrR0ueLfW3sWRnUFnDnGaSHqYJpjZsPI5g7zVcqq
	fMuGeSYv5q9sU3BA==
Authentication-Results: smtp-out2.suse.de;
	dkim=none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 6985A13357;
	Wed,  3 Apr 2024 06:41:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id 9ufkFSr6DGb8CAAAn2gu4w
	(envelope-from <hare@suse.de>); Wed, 03 Apr 2024 06:41:46 +0000
Message-ID: <174cb0ad-7a03-4148-a9c8-23d25b890fd1@suse.de>
Date: Wed, 3 Apr 2024 08:41:45 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/28] block: Allow BIO-based drivers to use
 blk_revalidate_disk_zones()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240402123907.512027-1-dlemoal@kernel.org>
 <20240402123907.512027-12-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240402123907.512027-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.13
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.13 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	 MIME_GOOD(-0.10)[text/plain];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	 NEURAL_HAM_LONG(-0.03)[-0.028];
	 BAYES_HAM(-3.00)[100.00%];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 MX_GOOD(-0.01)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[10];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:98:from]
X-Spam-Level: 
X-Rspamd-Queue-Id: 18E4B5C8E2

On 4/2/24 14:38, Damien Le Moal wrote:
> In preparation for allowing BIO based device drivers to use zone write
> plugging and its zone append emulation, allow these drivers to call
> blk_revalidate_disk_zones() so that all zone resources necessary to zone
> write plugging can be initialized.
> 
> To do so, remove the check in blk_revalidate_disk_zones() restricting
> the use of this function to mq request-based drivers to allow also
> BIO-based drivers to use it. This is safe to do as long as the
> BIO-based block device queue is already setup and usable, as it should,
> and can be safely frozen.
> 
> The helper function disk_need_zone_resources() is added to control the
> allocation and initialization of the zone write plug hash table and
> of the conventional zone bitmap only for mq devices and for BIO-based
> devices that require zone append emulation.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-zoned.c | 30 ++++++++++++++++++++++++------
>   1 file changed, 24 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

