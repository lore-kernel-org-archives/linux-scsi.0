Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F51823AB95
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 15:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764690026; cv=none; b=suI0Zx5emBi43pzrcOa1ahknK/4o6sD8bZvyXLsILnnCs+UVlzPvIqHyUaRyCyyicePYzMjQI8eH9SKIe07/n78M3MfqpS1cV8Qqbd3ayMJry8KMdmQXP0ppzwlJz+TUBNseF5RvC48dWCA43z50jdUoM89Aw9rPHa3LBATf70M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764690026; c=relaxed/simple;
	bh=tUitVCELaxbe01sGcW7kmjXwULpbL7nrf7e8Hi0lg3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hffxYASSsUaC5Am0uaXLuarZ4Zj+RAWoXC7FQ78idoYFa5tMC9DdwS50C1RZlwHKzCAtMkqsW0RckKMy5k+lQX1hu6m7KWVdFDXQ3/ctdLkZ160WLJ8rlxTNQ534NKMj/BzH646nvPfCN4jqk6H27ZzEP94gNjF7m0vQmPbKmH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=H8+1gVff; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IobqdJPG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=H8+1gVff; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IobqdJPG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="H8+1gVff";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IobqdJPG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="H8+1gVff";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IobqdJPG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 58EB4336A3;
	Tue,  2 Dec 2025 15:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764690022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VdJrFte6sugcjCs88ZzSMsjRA0CJMm30fnCS8voTy+4=;
	b=H8+1gVffEfCo2NTqvBwiSbJdlCO9CZcWjC59dvy31Vjvr7wwr1e7EqxbPnRXi6WQOvvBzp
	9VxSHIkaMzUppbu7ez8HJNVyRcwYUBzHJO6+wgg6sBsiy1oeXe2JOtJwLpuuCrLIA/N+UR
	h42SIYWhtl4c/GeBiptNPl2UcoSCmRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764690022;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VdJrFte6sugcjCs88ZzSMsjRA0CJMm30fnCS8voTy+4=;
	b=IobqdJPGMeqolLVKsCdMm504yxmghHmD7da6LEIomG2bs/JbpSNiQ6zmCYsraOnKGSUmCy
	LE2okwBQ6fjPOdBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764690022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VdJrFte6sugcjCs88ZzSMsjRA0CJMm30fnCS8voTy+4=;
	b=H8+1gVffEfCo2NTqvBwiSbJdlCO9CZcWjC59dvy31Vjvr7wwr1e7EqxbPnRXi6WQOvvBzp
	9VxSHIkaMzUppbu7ez8HJNVyRcwYUBzHJO6+wgg6sBsiy1oeXe2JOtJwLpuuCrLIA/N+UR
	h42SIYWhtl4c/GeBiptNPl2UcoSCmRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764690022;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VdJrFte6sugcjCs88ZzSMsjRA0CJMm30fnCS8voTy+4=;
	b=IobqdJPGMeqolLVKsCdMm504yxmghHmD7da6LEIomG2bs/JbpSNiQ6zmCYsraOnKGSUmCy
	LE2okwBQ6fjPOdBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E8CDE3EA63;
	Tue,  2 Dec 2025 15:40:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id T/4sNmUIL2mpOAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 02 Dec 2025 15:40:21 +0000
Message-ID: <b32a7120-d959-40ba-944f-ef9a758d2d7b@suse.de>
Date: Tue, 2 Dec 2025 16:40:21 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] scsi: sd: reject invalid pr_read_keys() num_keys
 values
To: Stefan Hajnoczi <stefanha@redhat.com>, linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Sagi Grimberg <sagi@grimberg.me>, Mike Christie
 <michael.christie@oracle.com>, Krzysztof Kozlowski <krzk@kernel.org>,
 linux-nvme@lists.infradead.org
References: <20251201214329.933945-1-stefanha@redhat.com>
 <20251201214329.933945-2-stefanha@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251201214329.933945-2-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.27 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.17)[-0.834];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.27

On 12/1/25 22:43, Stefan Hajnoczi wrote:
> The pr_read_keys() interface has a u32 num_keys parameter. The SCSI
> PERSISTENT RESERVE IN command has a maximum READ KEYS service action
> size of 65536 bytes. Reject num_keys values that are too large to fit
> into the SCSI command.
> 
> This will become important when pr_read_keys() is exposed to untrusted
> userspace via an <linux/pr.h> ioctl.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   drivers/scsi/sd.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
