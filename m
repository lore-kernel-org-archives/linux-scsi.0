Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E699499F1E;
	Mon,  7 Sep 2026 12:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784054; cv=none; b=iX/Do9lQp5RwIJCdReSl/kUEBnjv+q4S69UogBURQmLf5vnJS027kygi7NtRxLiyCxIyo3I79H/UXCSk+DnsgOHhzVLC0HTrss6bZKLbYw0dnKqSa/fQ1JtRUfyfDWNWyrPY6eo2gn/ksT4dESC22h992BpzD4sr7m9QaiJW2wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784054; c=relaxed/simple;
	bh=JF9Ix47mTnO3t4ZL8PY/5GcEq1MrgERyp1M90elFNbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=b/PM0rmvMPQr/fgC/Vtn0pabcRq1di9ZZsD/HK6f6A+Qqeb/2BouDIbxvklt+2onLWi0sdbAhHjht4p5Gen9RfWUZCvYZRNNdFqDpphhHNhnSxBNowTnuC3Kcr/VpMTB/t1Yea5ZwOwldlzM6q9q97XZ8UXXvEqnpWhLu1ZFxc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DMRTuiP2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=chwSAj1k; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zMej1nc8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+ftQlmBS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DMRTuiP2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="chwSAj1k";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zMej1nc8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+ftQlmBS"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1406C1F74B;
	Mon,  7 Sep 2026 12:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784047; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mjSExrCbsaUfc/RxwBxxXpaT87qWlOkhiA6s4V6Zf50=;
	b=DMRTuiP25+8q0wbVa8MFwAfwxwxRFH3BXw39v89+xCr3hkaARMdMXz5aMKM6MaKV4a+gYg
	EJ+zHwV9H38UpwQ84GfaZsVKdG0wXdfFpZvX7ZYGDmCM7/IEcKl+4JULB0ID56/NiDYwbg
	TttirHuiKozqg6dqhxXtcGPWN4ew9hM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784047;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mjSExrCbsaUfc/RxwBxxXpaT87qWlOkhiA6s4V6Zf50=;
	b=chwSAj1k7opOEEj9d9BEqvUT/21wJmZRAvNEynaVrW1bNnAWuOZjFEadXhXVUQ3EtZcU+v
	eJjn4axDpM9IbuDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zMej1nc8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+ftQlmBS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mjSExrCbsaUfc/RxwBxxXpaT87qWlOkhiA6s4V6Zf50=;
	b=zMej1nc8gBZ8dQGz+trUcz27JIrP23x/tL3hG8ZJG8fhl5Uth9mZu5Ylj5EHY55tMXyyt1
	0tanYk3avy1vhtOJmD7OnvYrepqxnOqtLmo3O4PD5tOr8KLF+geIQB+rV/EQUc3HSHk/Q/
	HgTVeKxES5JrHxr1dX0pkYXjnDpFubI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784043;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mjSExrCbsaUfc/RxwBxxXpaT87qWlOkhiA6s4V6Zf50=;
	b=+ftQlmBSVHVM0mX74Ds06GhT/ZDPOTL+uvmqSGEbTfaFTMu40jFYoi6BfBZAWIbbJIiLDk
	B5AiOlg2BDHhoFBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B43FB1368D;
	Mon,  7 Sep 2026 12:27:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uBTsKqqtnmo1LQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:27:22 +0000
Message-ID: <ad64b67a-d16a-4152-b28d-9fcfce34c073@suse.de>
Date: Mon, 7 Sep 2026 14:27:22 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/40] scsi: ses: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-11-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-11-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1406C1F74B
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the SCSI stroage enclosure driver to use the 16-bits sense_code
> field of struct scsi_failure and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/ses.c | 15 +++++++--------
>   1 file changed, 7 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
