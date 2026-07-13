Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FC62F363F
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 09:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783935572; cv=none; b=I1Xbtyf9Me5DO2RvdAuoibrJTDn4rGChSwuoLLKlEQdwM/12xBZDjdQd3zK3s/t/0J1aLGTM+fKJ5h3DVxMKDRJgUDz6BmJ9SNo7s4hmfnOG9hPEy0vmALEUQKkwpioYRN0Ldn7ZmxVXnBmpZgGkwa1qlcgJ7A4/R/+Yfk5njjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783935572; c=relaxed/simple;
	bh=s+w7lq8SwrtetqdgLCHyNUlwifk26161L7SWSsFH8s4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MoQ4Drnw6mApCHXu0DZoePNmnwsDgQVQNz9BswcxGl+svZu+5hqKNGcMTNc1y++lvcZXrR8nOiWnLv2rzGhEBmNY+5/Fvtk51/EEAhtOUgPS2pCnYGeLLCXgGiauwDqkSj5VY1jlLn0+AcFSHJGMtlYDepCFMcjaXanTNDNOWzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZOt7rdZ/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=a9jJ8vnE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZOt7rdZ/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=a9jJ8vnE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZOt7rdZ/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="a9jJ8vnE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZOt7rdZ/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="a9jJ8vnE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0E8B975E60;
	Mon, 13 Jul 2026 09:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783935570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4MXRpNllqgjtYyNVPWT2xww6aizcLjkTcMWi1XyaFLk=;
	b=ZOt7rdZ/9j7SNb7DQ2x815aVduNsDzHDvXAQnrm6yNtzBq07+KEzGTmpbLfUqvrX1WNGTy
	Xou9bwLad5WqHgAPgV6PJ4xx6pGc/4b1lUZkgJDEYJB70ElwDPtEfj8wz5PR/TgmgLxaaZ
	93OCdIApDJSZav2+LbSJx8ZetFLNG4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783935570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4MXRpNllqgjtYyNVPWT2xww6aizcLjkTcMWi1XyaFLk=;
	b=a9jJ8vnEvMvQmAHkyuBhKul67K9srYx0XN+gSarPun8vvx2Ws4aqosVetIhv+hK/w6hmWz
	FT/Do+A2ZWr3OrCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783935570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4MXRpNllqgjtYyNVPWT2xww6aizcLjkTcMWi1XyaFLk=;
	b=ZOt7rdZ/9j7SNb7DQ2x815aVduNsDzHDvXAQnrm6yNtzBq07+KEzGTmpbLfUqvrX1WNGTy
	Xou9bwLad5WqHgAPgV6PJ4xx6pGc/4b1lUZkgJDEYJB70ElwDPtEfj8wz5PR/TgmgLxaaZ
	93OCdIApDJSZav2+LbSJx8ZetFLNG4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783935570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4MXRpNllqgjtYyNVPWT2xww6aizcLjkTcMWi1XyaFLk=;
	b=a9jJ8vnEvMvQmAHkyuBhKul67K9srYx0XN+gSarPun8vvx2Ws4aqosVetIhv+hK/w6hmWz
	FT/Do+A2ZWr3OrCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F0E70779AE;
	Mon, 13 Jul 2026 09:39:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zDEtOlGyVGp2AwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jul 2026 09:39:29 +0000
Message-ID: <2610e83d-7740-4c2d-b30a-3f8d5fb1ee8c@suse.de>
Date: Mon, 13 Jul 2026 11:39:29 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 8/9] ata: libata-scsi: add support for the RESTORE
 ELEMENTS AND REBUILD command
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260706065610.3559692-1-dlemoal@kernel.org>
 <20260706065610.3559692-9-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260706065610.3559692-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 
X-Spam-Score: -4.30

On 7/6/26 8:56 AM, Damien Le Moal wrote:
> Define the translation for the RESTORE ELEMENTS AND REBUILD command
> (SERVICE ACTION IN command with service action
> SAI_RESTORE_ELEMENTS_AND_REBUILD) into the ATA command
> ATA_CMD_RESTORE_ELEMENTS_AND_REBUILD with the new function
> ata_scsi_restore_elements_and_rebuild_xlat()
> 
> The array of supported commands ata_supported_cmds is modified to add a
> new entry for this command. ata_scsi_cmd_is_supported() is also modify to
> correctly handle this new entry depending on the target device flag
> ATA_DFLAG_DEPOP_RESTORE being set.
> 
> The ATA command completion is handled using the function
> ata_scsi_depop_ua_cap_changed_complete() so that on a successful
> completion, a UNIT ATTENTION with the additional sense code set to
> CAPACITY DATA HAS CHANGED is raised.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-scsi.c | 37 +++++++++++++++++++++++++++++++++++--
>   include/linux/ata.h       |  1 +
>   2 files changed, 36 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
