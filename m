Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C928A288530
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 15:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764690067; cv=none; b=nvLRVOKK5iSuQFo+PfdyxSKwiCxBYUXrpViaDf4yNd+jKI6DJB0KZQH/lSwBQ1PcjmDxhz/rZp6EQgJeNVru7+KwjbjApNlZScZaDpYKGZLf1dIJFg3ceJueFTO2+g698DCHmJ62oLUTxvGDN+UYZ0DOeLRXnFEgFzioBb7eoVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764690067; c=relaxed/simple;
	bh=JhvLhmkXZIhDKvqAB/J7W/TpoJQuwjvVfI5zohnQ8f4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GZey/4cKX6CYf6jo0G1EaY7UCflKTyra7HKVGWSjKhtNAH+2SlSC8rgVpQrLpHryHBycOVKy6shdj2vVI0VL3POa8BJwxKEkuEK8YXe5D53QKhpN3huaZFrOuBwpcEtwitI7/s8at3SX/m6cgMfiZe8iQBK5UFOkF7CkH3tNbPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dxnNfAyk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=R4zJDvOx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eKuvetb7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fhT5qMMD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dxnNfAyk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="R4zJDvOx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eKuvetb7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fhT5qMMD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BDA87336CB;
	Tue,  2 Dec 2025 15:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764690063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0Oa0J2pmDHoMuo3JLDHwxp1cEth3gfHurTM5QzeJLOA=;
	b=dxnNfAykiQdjH0Yddai6LhpWobHYBv3deZ5sc+2sPbPkrVKaaLNKC6kchi8occy6JEUXy+
	eiBisfwU5oq1vUni4omwXO6FJSvngX9aUev7RD4nIheXvoxH9bLO71W4DlZrYLkq1fcxvj
	xdNeVhItDyH76ZgKNHbc5U9jGbhl6lU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764690063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0Oa0J2pmDHoMuo3JLDHwxp1cEth3gfHurTM5QzeJLOA=;
	b=R4zJDvOxLiR2vD1Kf3Rq41WV3oWM88wV476bLe5G9hrMPygXwGmqYzzcW9p8+p04EQtIb+
	botgX/cCIbI+myBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eKuvetb7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fhT5qMMD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764690061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0Oa0J2pmDHoMuo3JLDHwxp1cEth3gfHurTM5QzeJLOA=;
	b=eKuvetb7qyNQaec5sdlxvWhThYXe/vU1TeOjpSiO3GaKiWyxGcU5QYJe0rbsqSxFfPBV4A
	vzsWDBP9v6q5vRueaWGCF/gcNqCVCvK46C5srkfK3DqADnizdJTw8YhFcyj4udcYtW0LJZ
	DBpDZBMYgkvYCMyJG/M0/w1OWpRZ+AA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764690061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0Oa0J2pmDHoMuo3JLDHwxp1cEth3gfHurTM5QzeJLOA=;
	b=fhT5qMMDZEwr/Zk1yItk5FdrdLscDqlZ/zhaGEAQXnGJrf2vLR0a3qMuj7nVAVoQRGDwf2
	gNaePOICWLXSsbCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 67A2F3EA63;
	Tue,  2 Dec 2025 15:41:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MNo4GI0IL2lVOQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 02 Dec 2025 15:41:01 +0000
Message-ID: <6bd50697-8cfb-40ba-94ed-45b5fc7d7bc7@suse.de>
Date: Tue, 2 Dec 2025 16:41:00 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] nvme: reject invalid pr_read_keys() num_keys
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
 <20251201214329.933945-3-stefanha@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251201214329.933945-3-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: BDA87336CB
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

On 12/1/25 22:43, Stefan Hajnoczi wrote:
> The pr_read_keys() interface has a u32 num_keys parameter. The NVMe
> Reservation Report command has a u32 maximum length. Reject num_keys
> values that are too large to fit.
> 
> This will become important when pr_read_keys() is exposed to untrusted
> userspace via an <linux/pr.h> ioctl.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   drivers/nvme/host/pr.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
