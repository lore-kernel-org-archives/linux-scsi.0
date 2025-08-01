Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F34635947
	for <linux-scsi@vger.kernel.org>; Fri,  1 Aug 2025 06:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754029956; cv=none; b=IOlaofzI4A+yD0TWDLvqsgK//+m3GiPkB7AUNCimVuf0Q/3oKblQ9My9jZwGaISQzoCHfLmQQnx05ARE5wAyS/oVcu6HxHzwhyfr5q6jOOHN6JAYeB5sQ/prjBA5/+IsABdte82d3130oFyGyR0Nw9Js7dxKBo+ynUGhgFwAVgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754029956; c=relaxed/simple;
	bh=JubIEVlZHjr72yC0ERPyQNbiqcneohyuqVs5Pc2m/3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SX0oGXq5W56fdtWF+MMOB5DodabwAUs2+ttc19hh1x2LEzEdvKah+Gah3c9tLhW1TyRp0n1mBO+7Qn/zGhc/SVDfC4PN4CozkAsXkftnIXpU5RxO3dY5l/a3ROiARmX7y3L/YJtvQI+4Mklw5yPRAO12LrIbeMgiNCzgVmV7Fck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dhuT6zZJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kwEZGUC4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dhuT6zZJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kwEZGUC4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dhuT6zZJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kwEZGUC4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dhuT6zZJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kwEZGUC4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 479471FC84;
	Fri,  1 Aug 2025 06:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754029952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A31BsiWtvcmVeIB/t4EVsCqunSCcSiqEfWml/sCmWn4=;
	b=dhuT6zZJozq5rxhWOiKYIY3rY62s3sI9ViJ0zl/uiM0GdlzJ8wf//DqMrTtu1YALZi4SJ5
	nqwhO4+kJiu8tHWBgVDCN1PiRlHHKCdHdltM384ElM0UG5G9EsbDMrJtNRsB8RYJqMLkL8
	eRv2qCSytge6EgdJq3FTp99ZzeuHo9A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754029952;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A31BsiWtvcmVeIB/t4EVsCqunSCcSiqEfWml/sCmWn4=;
	b=kwEZGUC4A0LfylJje6VhwiLtKrUF+9WuMqR6561iFTUKvsAizcpag8chEo8y56nN92zWqp
	1YHqn4Co2CsQ3vCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754029952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A31BsiWtvcmVeIB/t4EVsCqunSCcSiqEfWml/sCmWn4=;
	b=dhuT6zZJozq5rxhWOiKYIY3rY62s3sI9ViJ0zl/uiM0GdlzJ8wf//DqMrTtu1YALZi4SJ5
	nqwhO4+kJiu8tHWBgVDCN1PiRlHHKCdHdltM384ElM0UG5G9EsbDMrJtNRsB8RYJqMLkL8
	eRv2qCSytge6EgdJq3FTp99ZzeuHo9A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754029952;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A31BsiWtvcmVeIB/t4EVsCqunSCcSiqEfWml/sCmWn4=;
	b=kwEZGUC4A0LfylJje6VhwiLtKrUF+9WuMqR6561iFTUKvsAizcpag8chEo8y56nN92zWqp
	1YHqn4Co2CsQ3vCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 21441138A5;
	Fri,  1 Aug 2025 06:32:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id t82dBoBfjGh6fwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 01 Aug 2025 06:32:32 +0000
Message-ID: <e7c9494d-7d72-4185-a315-e84e8e9e3e2c@suse.de>
Date: Fri, 1 Aug 2025 08:32:31 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] scsi: libsas: Simplify sas_ata_wait_eh()
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 John Garry <john.g.garry@oracle.com>
References: <20250724000235.143460-1-dlemoal@kernel.org>
 <20250724000235.143460-3-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250724000235.143460-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 7/24/25 02:02, Damien Le Moal wrote:
> Simplify the code of sas_ata_wait_eh(), removing the local variable ap
> for the pointer to the device ata_port structure. The test using
> dev_is_sata() is also removed as all call sites of this function check
> if the device is a SATA one before calling this function.
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/libsas/sas_ata.c | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
