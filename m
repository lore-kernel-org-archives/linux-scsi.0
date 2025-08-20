Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC942E6103
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 11:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755689985; cv=none; b=PcdfLhkfe6M4hzGy7H/63jR9GdYUY2u/251fNEBdjw0/7jGMTaJoy3n4yO01VtLG9MG3pcsrVr2Oi0vYOmBpqTupLzkyjsa/L1zyxwwN527gHsXIw9F90CD/3Cp6IlKtwIMtwKzhxd2fNvOOZof0VI2TomS+JgBB8otDizsY9ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755689985; c=relaxed/simple;
	bh=gnJw1EW0pZDsKctvqjjCxWu+QAPqsd807aaNVjCBQYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VcF1BL5UGmMZfxrOWrk7O193Mk6W7vkIEuaLiyHE5npNKlkon5vs8VU9cBhnpXoDlRIOJeJiZZenj3XIfIKvR2wDuymqPL6xrLbyWD038trQqFOK0VDXGJXXSZhxoEkEJ7ywHz1lOv1+uU2XX0SupX6RF6ExIfDDzFNWySNCjhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0xUGMYJe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=k5NTMjMv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0xUGMYJe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=k5NTMjMv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0xUGMYJe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="k5NTMjMv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0xUGMYJe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="k5NTMjMv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0A00B21C1E;
	Wed, 20 Aug 2025 11:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755689982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NDx74ZRFjFT4xLo495+41ohxX4YGo8zAT28oRu/6hIc=;
	b=0xUGMYJelT0DMTCLa/QpplYpoFzvTaRu01OD8l8Q3SV5F3/rE+lcTLCV92JVQXh1Tm7wO6
	7VCsuQmfDZoSrckPdcJmQoBqFkTs+bJ00POWzErh+mCIo2dKxIbIi7L6IURAY53wAcv24W
	BWWY9U104XrE+/L7746E4p1AHp73lYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755689982;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NDx74ZRFjFT4xLo495+41ohxX4YGo8zAT28oRu/6hIc=;
	b=k5NTMjMvXn83KG6bIxfsOhzl8QnkOv6ALtwf8wurNRREQbkr2ss0bV1BbPgbvw5YDYIMS6
	46XSoaj7qo4vOKDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0xUGMYJe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=k5NTMjMv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755689982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NDx74ZRFjFT4xLo495+41ohxX4YGo8zAT28oRu/6hIc=;
	b=0xUGMYJelT0DMTCLa/QpplYpoFzvTaRu01OD8l8Q3SV5F3/rE+lcTLCV92JVQXh1Tm7wO6
	7VCsuQmfDZoSrckPdcJmQoBqFkTs+bJ00POWzErh+mCIo2dKxIbIi7L6IURAY53wAcv24W
	BWWY9U104XrE+/L7746E4p1AHp73lYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755689982;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NDx74ZRFjFT4xLo495+41ohxX4YGo8zAT28oRu/6hIc=;
	b=k5NTMjMvXn83KG6bIxfsOhzl8QnkOv6ALtwf8wurNRREQbkr2ss0bV1BbPgbvw5YDYIMS6
	46XSoaj7qo4vOKDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CBEC51368B;
	Wed, 20 Aug 2025 11:39:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aG35MP2zpWgQJwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 20 Aug 2025 11:39:41 +0000
Message-ID: <371b8797-25d8-48a4-97f0-ed354957085b@suse.de>
Date: Wed, 20 Aug 2025 13:39:41 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/8] scsi: sd: Explicitly specify .ascq =
 SCMD_FAILURE_ASCQ_ANY for ASC 0x3a
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-3-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250815211525.1524254-3-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 0A00B21C1E
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 8/15/25 23:15, Ewan D. Milne wrote:
> This makes the handling in read_capacity_10() consistent with other
> cases, e.g. sd_spinup_disk().  Omitting .ascq in scsi_failure did not
> result in wildcard matching, it only handled ASCQ 0x00.  This patch
> changes the retry behavior, we no longer retry 3 times on ASC 0x3a
> if a nonzero ASCQ is ever returned.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/sd.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
