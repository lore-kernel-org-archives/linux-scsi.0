Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019F0238C1A
	for <linux-scsi@vger.kernel.org>; Fri,  2 May 2025 07:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746170874; cv=none; b=aqOe0Eu/zRt19wWyf++aKjF+uQByxk6xa19gZbSO4dZkMfovCkQ3/itAQzp4bqMu73kmG5uhXp74Z8FvoC8mLTmbH1D8ubvYjHRbf98hbFdzeDCmY60pXXo/D7yOMm8mdX7uW27SwYKbA4dU6ALFHWiRcm+Utq9njLAAoV8ZubM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746170874; c=relaxed/simple;
	bh=gy2an+r/Y9vT+IQNPlA7x2mBv+BmleYUZ2j8XhBorj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OoeHnvfxY9rwIexHRU3UI0cO0h4wNTUi4Q4mYlzFpQf76GiPPruCsnMfJegVwfNfoPcSaMSMxTYqFN6/fcbUu0S2QNHMrNXSpDco/BiUAVnmVGIbrMx2kT9WZAXuybSrXN9QBC6WBdO9aKRj6SjAGgQL/Q6T2gMFlYyE9qLtg6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ShzLkQ8v; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SQnRgcpb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ShzLkQ8v; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SQnRgcpb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ShzLkQ8v";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SQnRgcpb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ShzLkQ8v";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SQnRgcpb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 28A471F385;
	Fri,  2 May 2025 07:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746170870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W2PGwf5whLEVyVOCQc+zLst5fgDgN/UZfYnFj0npqnM=;
	b=ShzLkQ8vCp5/mDOevaN2ImEIsPbkuaGdBD9e4BpAg+rZhOrh/8TqkVTVtDHxTC8RxR77hJ
	VeFVGEaMU62qKQDPyoxEwEvRwyADyMmBOkxtKmjJByn3ysHVnaf7w54BA0QfohDllbc9uD
	W5Zl7N2Rlysc5ticjATR6CxmldLwVyo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746170870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W2PGwf5whLEVyVOCQc+zLst5fgDgN/UZfYnFj0npqnM=;
	b=SQnRgcpbIZt4h8l0GR4TcD/YvZqhEX/AteOt4+xgso0xKBqvCOJtJ0qu7pS0dlD6Gnx8TH
	jvFa4EHso+x/ryAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746170870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W2PGwf5whLEVyVOCQc+zLst5fgDgN/UZfYnFj0npqnM=;
	b=ShzLkQ8vCp5/mDOevaN2ImEIsPbkuaGdBD9e4BpAg+rZhOrh/8TqkVTVtDHxTC8RxR77hJ
	VeFVGEaMU62qKQDPyoxEwEvRwyADyMmBOkxtKmjJByn3ysHVnaf7w54BA0QfohDllbc9uD
	W5Zl7N2Rlysc5ticjATR6CxmldLwVyo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746170870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W2PGwf5whLEVyVOCQc+zLst5fgDgN/UZfYnFj0npqnM=;
	b=SQnRgcpbIZt4h8l0GR4TcD/YvZqhEX/AteOt4+xgso0xKBqvCOJtJ0qu7pS0dlD6Gnx8TH
	jvFa4EHso+x/ryAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE80B13687;
	Fri,  2 May 2025 07:27:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V7+qKPVzFGjpOAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 02 May 2025 07:27:49 +0000
Message-ID: <72655fa4-104c-4dd1-be55-090f50089f0f@suse.de>
Date: Fri, 2 May 2025 09:27:49 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] mm: remove NR_BOUNCE zone stat
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Alan Stern <stern@rowland.harvard.edu>,
 Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net, linux-mm@kvack.org
References: <20250502064930.2981820-1-hch@lst.de>
 <20250502064930.2981820-8-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250502064930.2981820-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,lst.de:email,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 5/2/25 08:49, Christoph Hellwig wrote:
> The stat is always 0 now, so remove it and hardwire the user visible
> output to 0.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/base/node.c    | 2 +-
>   fs/proc/meminfo.c      | 3 +--
>   include/linux/mmzone.h | 1 -
>   mm/show_mem.c          | 4 ++--
>   4 files changed, 4 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
