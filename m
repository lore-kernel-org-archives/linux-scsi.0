Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13011DE8A6
	for <linux-scsi@vger.kernel.org>; Fri,  2 May 2025 07:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746170690; cv=none; b=KpXP38OHlCyj9ooNUk+shMQ2ERA+Ijzc1VupoDGAj+MGFl3wcSD1Jllw6y+i/Pl7cyietinfqu7sDvX1ylv8q/GIZUSe8C2gCLlIpl5Bk/vYZgF4PnsfAJHU4z3eUyyOqk9+cmHKWJD/ifnQmjrjLcMRrv1/rlUs9aRN6TLE2/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746170690; c=relaxed/simple;
	bh=Us6l4zs7NSaAA2nE0dsS2zl/IBRJfeoj1oXnz2vcieQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZSTV7d6g97n7TEdMIehKyuGbCH0dTSwA8I9hg1yWd+bVTnHDHVzxqNlpAHUv+st51zlRMVkrPjw0eNBWzUKv4f/x15mBArcpldUuD0il8Pucc+5B8FsMBus5yk2gxe52sb2/WRTP1O8GCDKOBKTCE09C0MesDFPEcsjHseqhlI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sj6YU9Z0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VFZBcNLz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sj6YU9Z0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VFZBcNLz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sj6YU9Z0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VFZBcNLz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sj6YU9Z0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VFZBcNLz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 36E3B1F385;
	Fri,  2 May 2025 07:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746170687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TenqFek5HQ49fljPNRwi23amJE9GPLf1ngzw8h6z5w0=;
	b=sj6YU9Z0PqZt2bJwc4/A0etLut3V5mZFBGosVo3GCpGmpwKzqp+lghM6XQDVBv7ItmpT2M
	es87LC0r+jfr6ltgKY/NcldsnW0kaMp8xFeqYsZ/HEKUis1fVBW89zd+qKmae2agA15pRj
	FDFLkESNm1Y3v8jNM2TspT9+vLi/G7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746170687;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TenqFek5HQ49fljPNRwi23amJE9GPLf1ngzw8h6z5w0=;
	b=VFZBcNLzU6Hwjm4eltbGYV0J2YRfZ+AGmbEnUWzTvouydE9SYoRK0S3LapTrN5eabraggv
	qFtnRWfJukm0iYBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sj6YU9Z0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VFZBcNLz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746170687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TenqFek5HQ49fljPNRwi23amJE9GPLf1ngzw8h6z5w0=;
	b=sj6YU9Z0PqZt2bJwc4/A0etLut3V5mZFBGosVo3GCpGmpwKzqp+lghM6XQDVBv7ItmpT2M
	es87LC0r+jfr6ltgKY/NcldsnW0kaMp8xFeqYsZ/HEKUis1fVBW89zd+qKmae2agA15pRj
	FDFLkESNm1Y3v8jNM2TspT9+vLi/G7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746170687;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TenqFek5HQ49fljPNRwi23amJE9GPLf1ngzw8h6z5w0=;
	b=VFZBcNLzU6Hwjm4eltbGYV0J2YRfZ+AGmbEnUWzTvouydE9SYoRK0S3LapTrN5eabraggv
	qFtnRWfJukm0iYBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CEFA313687;
	Fri,  2 May 2025 07:24:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RkgHMT5zFGgSOAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 02 May 2025 07:24:46 +0000
Message-ID: <8805f1c0-d1ed-4bf8-9751-5d137bb7e49c@suse.de>
Date: Fri, 2 May 2025 09:24:46 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] scsi: make imm depend on !HIGHMEM
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Alan Stern <stern@rowland.harvard.edu>,
 Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net, linux-mm@kvack.org
References: <20250502064930.2981820-1-hch@lst.de>
 <20250502064930.2981820-3-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250502064930.2981820-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 36E3B1F385
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	SUBJECT_HAS_EXCLAIM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,lst.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 5/2/25 08:49, Christoph Hellwig wrote:
> This is one of the last drivers depending on the block layer bounce
> buffering code.  Restrict it to run on non-highmem configs so that the
> bounce buffering code can be removed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/Kconfig | 1 +
>   drivers/scsi/imm.c   | 1 -
>   2 files changed, 1 insertion(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
