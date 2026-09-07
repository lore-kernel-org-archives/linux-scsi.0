Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879784A64D3;
	Mon,  7 Sep 2026 12:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784199; cv=none; b=F+NH3gqCN7xlk42lTCqX4jDIFngBj7TU+QhNO5qSefbM+A4hu6EPrjzI+ytI2mvCNXC3FO8lQINq3bGf46gGzuIQoDDjfoLU0Oe4Gc+izvH2XZUR8hywToiyauSWidL9CIr2jKyxYIKGof1CqTIh02Os3mxbu+/fhhNN4Iduw/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784199; c=relaxed/simple;
	bh=EL+fBs45aRcZQCasJhJsZjDl6SGihIap9QL4IBUuuYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=By7cOxY36+zr6dk12NdS+yTTWruqp/djjbaG8iRZJcg/gWteg0Gwc3EVzA2ERWzsMtI/XJtL6obMFU4xZ1WgarZREga2C3t8RFAV5pTm/W6hMiCcaFcIzBanPicKheeQR3pXncFtA6sytFP8l6ZknnLiBSRksUeh93BPwtLi10M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0YZztZCv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SiTR4GhN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EKzmXHTC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rfsHa0Kr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0YZztZCv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SiTR4GhN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EKzmXHTC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rfsHa0Kr"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B43B521ABF;
	Mon,  7 Sep 2026 12:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JQZsCtwln9w0Pna2jjHPKa+Zriw724B9RIprr74119o=;
	b=0YZztZCvQPxwboUUEjl0Nu9xG0G5Sue1I3rHQPW6WHCtwrRG777gSpki5kczFBzMZ8SFMJ
	hRvuDyVnnekyt/FoS3K+ME/J1/HGkSI1Fv1RuF2SBAyZ2K3IrlWzZPyJUlF9rN0e7cmZtZ
	VTde5t7NHVC87HfrDwuDdHbRXS1fA/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784187;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JQZsCtwln9w0Pna2jjHPKa+Zriw724B9RIprr74119o=;
	b=SiTR4GhNHrfjwERf+COmBuLuO8n3L4OrO+FPh1CnnmmMNwmWohuL30K/nGVH1dvWu6pL08
	rFdPoOxOivz+7UDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EKzmXHTC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rfsHa0Kr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784183; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JQZsCtwln9w0Pna2jjHPKa+Zriw724B9RIprr74119o=;
	b=EKzmXHTCewwNMQQaCM1t7/hO2nSgg2x0i78MOOR1c+6SQVJF3kPnkdMuYAG6s3D8jZyhjU
	l4wqINy8eL1Efpw8crFvOI8PL7WlLZj1F+G2Z7ULPjrzrsTAB+bGXQAF7W7kjD3MhPtFiB
	BllMOUpNpmOpVpQ9bou/BaFof43BCY8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784183;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JQZsCtwln9w0Pna2jjHPKa+Zriw724B9RIprr74119o=;
	b=rfsHa0Kr4mGSIxYJpcrmYgkYaA6VEx3oDF/qnyj3mgm0cwNGYISJfTnks0l9JZT447Y81q
	rcyBePvK2VRCFFDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 210D413793;
	Mon,  7 Sep 2026 12:29:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 20JnBTeunmqHLwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:29:43 +0000
Message-ID: <d0080857-d5e3-4975-88b4-4d5584a0bed0@suse.de>
Date: Mon, 7 Sep 2026 14:29:42 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/40] scsi: mpt3sas: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-18-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B43B521ABF
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the mpt3sas driver to replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c | 69 +++++++++++++++-------------
>   1 file changed, 36 insertions(+), 33 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
