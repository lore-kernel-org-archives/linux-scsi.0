Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66238483807;
	Mon,  7 Sep 2026 12:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784601; cv=none; b=Y6qhVrXFmbqwt4a06FISNek4pjmfwkMuhJ2klY9LL0JL9EfgWWN0IQvpL5C8bzn5UFRyA9GwXy0eNQ9JzRxhfEbv/kuHWIWywTpdQ4uzPJhtn2L4ezpUdxKNAn1Ckd4NedXnvy6OMGi8Yah94thk6QvEHj3GFb4ndmdJ4a+EyOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784601; c=relaxed/simple;
	bh=FcL5nQBvGDd7mAxBy2gEvRsfE9Cxlm5VdxJuZLv2X6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MrmYTnx2OLcb+FpPp45VdU0L3LrR4pMlnJ94GzLXuKXRNv1YIa6xuhOaOFNuqxaxEFMGOjwnt+xiJre8wJ5oOcjAvi3sM8/EfPwnI+vN5GdNnok2KMcuKnwBU34oeMNpStnZCd2q0ZWaDqD3AxTv3WYbJBNBHMQQAWOay1I0ReA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KCC1Jkmd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4YGUIKJL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uulmKFbs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MsPp8ZTr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KCC1Jkmd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4YGUIKJL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uulmKFbs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MsPp8ZTr"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3E65B219C2;
	Mon,  7 Sep 2026 12:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784594; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A4rHycctEEv3dOh3nCwNYqjefhWMdU8tkOsMgrWm608=;
	b=KCC1JkmdI90dNMtUjMW1P6K1c2EM2DBoHF0e82qf34VLpkC6tSKO+p0CUJLN3YfEjBBDWh
	eh81N/qtu5m7J+9/q3Yoo/PbZspVuScgQsPU845/fox7hKMht020TZRN56/vVBfrNC1gLU
	cGYd/2r9CkFjkM4FuMyDWiPvvjNQrow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784594;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A4rHycctEEv3dOh3nCwNYqjefhWMdU8tkOsMgrWm608=;
	b=4YGUIKJLl0Kea3igv2Eb0Y1U6DFps04qQtCSGShjkygtr3XfM96z0A4tdPNTwRY7jfb/p/
	d8v1UgxmkyMZbQDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uulmKFbs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MsPp8ZTr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A4rHycctEEv3dOh3nCwNYqjefhWMdU8tkOsMgrWm608=;
	b=uulmKFbs/S4v4SmLOM8FmtjAQGt9Txuo+Iml9Wz4XWYH1CXFHn2g8qNNbxrwk9ATPiLWdA
	UEqzIuVXHZPRna17260ngPVpG2KL2zCrdce2nXty9bGmgtNJoksEVyV1p05YnUCCLiDzSB
	OtjGRAd8rMY3hf3HcDdTfLZemTagsiw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784590;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A4rHycctEEv3dOh3nCwNYqjefhWMdU8tkOsMgrWm608=;
	b=MsPp8ZTrIyylNAsLHTc8LChW8BUc3ueU+4cwJ8PAs6hAZKy4GmO6lYpfARaIFv4tZcslm/
	mSFDAnBtj6GaobCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DBE4E1339B;
	Mon,  7 Sep 2026 12:36:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jKtXNM2vnmp2NgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:36:29 +0000
Message-ID: <1ecb9e46-31f5-4742-8d1b-fb60ae3922d6@suse.de>
Date: Mon, 7 Sep 2026 14:36:29 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 25/40] scsi: ps3rom: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-26-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-26-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3E65B219C2
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the PS3 DVD driver to use scsi_set_sense() and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/ps3rom.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
