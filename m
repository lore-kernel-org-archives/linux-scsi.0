Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F1F35337C
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 11:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755689961; cv=none; b=TVxBYE8o09s/qDURk8FzBwLbwKS/cAXCVhxsG8L1OtLDVStozuL0qq9r7haZvQhhzZa5cx+DoiWs+X1GBxxR8P15yoUzw365CFejKmrti7SpaG0Z7yaQTcfYY6IsDDpfWazGfILSV+C0fJ7hhWPgyICJLyMZsATMymrDg/1Gsas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755689961; c=relaxed/simple;
	bh=MqthQJpyYUY9uAdcVdvMWKUMMQSNEfV+U5NKfX9Z/6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K7rx+s1s/CRHKSU9tvQZeffT3Xr4xfUc926JwpYIqJ5P5xReVy8fH/iKAjHB3rPlugfzp5qQQbDCmZund/kCFmZUdszlMtc9p8va1tKBohnQcSuMkMQHGIGcbBH1ED7Tqxr1BeUuDiqz8P49VhTI9AlkO/Ztzmb/Y3FaWsq3ymI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=t6Z3ioPd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uoBHQa5U; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NvrekBLX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0NDdybLz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="t6Z3ioPd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uoBHQa5U";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NvrekBLX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0NDdybLz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2A7BD1FE00;
	Wed, 20 Aug 2025 11:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755689954; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cjfncnZ3SkbcXhAb6e1WfowU9DSVxm1t11m8HVYJmgk=;
	b=t6Z3ioPd49Hd3H48o5r7s8YHa/EjIM85CT2UAB2NdR/8esAhY1fP34fN6/FX9V7aY1vQz4
	hVFZXpSJcEOkFVlIhWyMaszBpfQF+uy4BXEepHKih17WoeAip5IfECexU4aek8Xk4JYpAG
	eVmZ63WiJj3z1WUP3IviDQWjZgSX8X4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755689954;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cjfncnZ3SkbcXhAb6e1WfowU9DSVxm1t11m8HVYJmgk=;
	b=uoBHQa5U4wFx0El2I2KjtzqFS38lfHjF+7KuhjlhkFeo8zuOXnT3HZbnYYKZnGYzunP0gT
	fwljeTnGvFLSP+Dw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755689953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cjfncnZ3SkbcXhAb6e1WfowU9DSVxm1t11m8HVYJmgk=;
	b=NvrekBLXv1LqPjKW9RsXKmMjx2SQCG1S1621shx+gAzlTt7D/+4LUREUiRhNQn9dV2Ecv8
	F74454+H2yzVsJhJ0o/Gd+nfG55K1w0u374wvuqaKbzAv2AgTZF6e6XhTyIAEoJidfrtFh
	pjBIOKLMQIiPjvZDrmvhkAVXHgavYII=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755689953;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cjfncnZ3SkbcXhAb6e1WfowU9DSVxm1t11m8HVYJmgk=;
	b=0NDdybLzNRvOijYI/TrEd325vm9/wSCNDaA/zGUmn/adjUN9URVtb8RX0kLaZSrE6cPNh1
	9kB/xcdL3QWH14Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C83A1368B;
	Wed, 20 Aug 2025 11:39:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Sh+ZAuGzpWjpJgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 20 Aug 2025 11:39:13 +0000
Message-ID: <452a0435-7710-4af6-84f3-6296d5ea8b0c@suse.de>
Date: Wed, 20 Aug 2025 13:39:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/8] scsi: Explicitly specify .ascq = 0x00 for ASC
 0x28/0x29 scsi_failures
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-2-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250815211525.1524254-2-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 8/15/25 23:15, Ewan D. Milne wrote:
> This does not change any behavior (since .ascq was initialized to 0 by
> the compiler) but makes explicit that the entry in the scsi_failures
> array does not handle cases where ASCQ is nonzero, consistent with other
> usage.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/scsi_scan.c | 2 ++
>   drivers/scsi/sd.c        | 1 +
>   2 files changed, 3 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
