Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F974A64E1;
	Mon,  7 Sep 2026 12:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784535; cv=none; b=SxBDF+/9kmaXw4MuRoM8haT6FRcopFsajwKGTGZ+z9OuhMpXIcY2XQ+9m4HkXho6c+BphQmi2Zc70g3/kXnwJxn+xrXfrriqFtexs0h549mqI8qiRHoBkdxq9J+xFKI+yVIdaJ2UGIcWzu7ZRLPPbmHcuFSqAm+ZeHqkQtw0gGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784535; c=relaxed/simple;
	bh=8P86MllX60BY51Ee7bZ0QAkSwsphumFXsS8J7wXfGeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bjaJmGFWJxarMQEWxupI/Rv5fgNFSJMnKLLn7DkJx7rSzFRl67s0gVB2EI4Rbyvu+/A2rWecLISHOwkfntbwKz4UmY0LKfxlzF1mRuvlJPMMSS2pfeqhRLL8nQ1CRE+42yNGLqqTMxNCn+NehueT88BudSDDy96XIbQIuVfT5EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GDB3QsB2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ecok/au/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fEZlAn3G; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LsPhhnHU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GDB3QsB2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ecok/au/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fEZlAn3G";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LsPhhnHU"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 25DA421971;
	Mon,  7 Sep 2026 12:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w8iHrUZs4n7xFF72++HRepf5RaS34nbtf5o8oRPwlhc=;
	b=GDB3QsB2BIEIZNDwTlSqbsi6u2qSORFPSO6D6DChgZh4J540i5pbIdHhKPj87XyEb86TJW
	jPiSt5dM5nRy47Gwot7SQbLDzBYF1vRw6ugs0Ak2ksDK6p4uHcnDi2zK5vZBYHKm0PFrkn
	yuvrmAMgXYcXlfuNZcEUV8NnlBWAIaU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784528;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w8iHrUZs4n7xFF72++HRepf5RaS34nbtf5o8oRPwlhc=;
	b=Ecok/au/r6kVoRpgak3q6W3o83Txup43BpTTGuspOPh2kreuIPRU4eyQk4rG3BPlaodqnn
	a8TBk4cYDyn4zuCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w8iHrUZs4n7xFF72++HRepf5RaS34nbtf5o8oRPwlhc=;
	b=fEZlAn3G7+bM7nxTzBU1kPukxA2vhq793fsLQ60EI2m40S8Bc1wg3fm1vB11Th5P7RAcJe
	jsmVQ4ahJoeZTWjw2Yl5lUQRpBd7HC1FJ9nz0ECWEH4T5iiSGB+bMlQggQV4MLeuXuwWsI
	gc42j1Qh5SQrABvcDC+qaWrlWe1EJE8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784524;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w8iHrUZs4n7xFF72++HRepf5RaS34nbtf5o8oRPwlhc=;
	b=LsPhhnHUWAgECPPt1hTiiSDISCvYh3vqlhvzPq0YCZWhcEgehtkh6hTVECfe7iNvFXy5c+
	HeZVDHOhoMO3JlDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C35081339B;
	Mon,  7 Sep 2026 12:35:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UtaTLouvnmqLNQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:35:23 +0000
Message-ID: <cef571a9-4d24-4919-be92-9f9edfc1e8c1@suse.de>
Date: Mon, 7 Sep 2026 14:35:23 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/40] scsi: smartpqi: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-24-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-24-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the smartpqi driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 31 ++++++++++++++++-----------
>   1 file changed, 18 insertions(+), 13 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
