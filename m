Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A07D49DB8E;
	Mon,  7 Sep 2026 12:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784662; cv=none; b=TgOzmH10C12hAXRdxxLxa79Kh8kwVSBeqm0Bj8xpN5Ul+gKw+DY42L6F4OMcajNOiag9WJe9jRxqWXSEJl08tv7shCFPiiJ+1lKez9F2bKAR+Z3x/QoJrK+7nZROZifCgJHi+RuCzVhbQ7fHFg0oHDMcoVfKT5aj9FXwzfHaMfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784662; c=relaxed/simple;
	bh=JSNfi3QxDmAPSxhpXow+19tas6TsdIRc5XlfThGStxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MPS/vYkZu4suqbO+/Qf4S/oalV0Ei/5rdC7YYX6itK/ifqaCxTDB3KlNDzR7SAteBFfIOVvUxFl/On0gxIqpvIXKQ4sOS/8Fsmnymd4jHn7Y6/O3XoaG9l7UXSKBA2xnd3ykiIe87dF36U4V9MekzVzFZYrx1bwJl7oNnM0+Ujk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bDH6+4se; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VvTNVCUq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nsLDFmfP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6z68/nBX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bDH6+4se";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VvTNVCUq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nsLDFmfP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6z68/nBX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9405E1F449;
	Mon,  7 Sep 2026 12:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jul0Jwm5fZEq4Vx7U+OiNqhGlkxc1JiUOCtIKviK8Ck=;
	b=bDH6+4seaGwYCRSxiSwKK6W4jDCZ6OGaczR5I1gVazWuW/wKQU07nhUDXoGcQbhzKKxJBS
	E6EZtqL5UhCwqOaWQ7Fy4wmNOf977JBan/NPSgGsKk8zj2uBVG/z75rc0awNzig8US10Ko
	0RXbfWXuB7NQtKmoYwr67JG0qzqLl4Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jul0Jwm5fZEq4Vx7U+OiNqhGlkxc1JiUOCtIKviK8Ck=;
	b=VvTNVCUqh37h6joutQCWp2icafpOkjV8Ltpd8rHD8mheaDBEySyw0nTOJoWmJScnA/CUAA
	C67y7Hz109po6gCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nsLDFmfP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="6z68/nBX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jul0Jwm5fZEq4Vx7U+OiNqhGlkxc1JiUOCtIKviK8Ck=;
	b=nsLDFmfPxBcNR4xRDo41UUznWqIAYjT21CFjVB8MNIiFekxpPbJHNiGDK464VE4E7n6x6M
	ZNBdbo9iuHeoymcduNpmLUXemMygczmPx4HwbhEgeGTWkndSXqx9Op3+SzabIlNA9DwfgU
	5ZPnyCtuuMPSGeejFwhMxD5Ei2TP3CQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jul0Jwm5fZEq4Vx7U+OiNqhGlkxc1JiUOCtIKviK8Ck=;
	b=6z68/nBX6Xg+XnIuJ9uaNBUx/nNgzwaTafPQlKP9BC00y6X5K1hgSYV47J8xSVpCLn26Pp
	yUzfAjQNzN1lu2AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 35F231339B;
	Mon,  7 Sep 2026 12:37:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q2eSCwuwnmq4NwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:37:31 +0000
Message-ID: <40fc67f8-df22-415e-bf4d-f08070cced5c@suse.de>
Date: Mon, 7 Sep 2026 14:37:30 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/40] scsi: lpfc: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-27-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-27-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9405E1F449
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
> Refactor the lpfc driver to use scsi_set_sense() and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 18 ++++++++++++------
>   1 file changed, 12 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
