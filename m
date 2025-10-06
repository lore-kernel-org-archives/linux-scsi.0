Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843E722D4DC
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 07:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759734773; cv=none; b=oCRpM9BflvKsinYOB8bIcMMCW/KnP//Ns5hu6KienCz5eb3ZMukVn52qrIcmCHLr/FtUz+tvT40X8tMtFlK/Nxd0yc7ulj9m8YoUTxWruyVrwllFAJ3Jwfb5FitYa/3/obRpEGhWwq2KfftvZzP266cZ8pBdVwu9Mk0a+wIOyGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759734773; c=relaxed/simple;
	bh=3q3tsItUDQqiuANO1T33SBu0RAHMrJGe/yDsoKvjthc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eKo+Xz1XGuSy5B+gATmQLBvo8eUK5rMTF3/+G3N8vbhpAg6UQnZvZKSXEmckUHGK5PYiDcRqGCLbzEjTkeCVkWWjXtebAGOcBtomfxeKgWUATS+/uWgsVoSCXp7uDSGOB3FkiPSBfCaLZVWIRMadOlqHTRYUuZ4qOUmHgDRB6Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ELb9Lipe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eyqnzfys; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DH/UQA5f; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HkFBIz91; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ELb9Lipe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eyqnzfys";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DH/UQA5f";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HkFBIz91"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E78C91F83F;
	Mon,  6 Oct 2025 07:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759734770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YVETF4d3bqYhAyMLMLANQ8JXCxRCYuuw8Shm1QGnRKA=;
	b=ELb9LipeZB/34JdwgwusQ1+HhXkz9fTK5rNOe4/2wRdHHyA8oMh+b8yVugSH+uCfuuQEKx
	PkcGwArhUvypWpLBdYNC5yITICJBctT2T6Ckz6mKrD4xs39GT9EhRhav0iHKAUYlwkVENx
	7gVdGrfLszhOYBfN8cSZVjqzOk+w40Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759734770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YVETF4d3bqYhAyMLMLANQ8JXCxRCYuuw8Shm1QGnRKA=;
	b=eyqnzfysH6WSDxscLrhaY8+BI02BBc0kjypSl/4/FWesU0ozfMIslOGY6a5zumB71W0+gd
	nnL3akL+BrDqYwBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759734769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YVETF4d3bqYhAyMLMLANQ8JXCxRCYuuw8Shm1QGnRKA=;
	b=DH/UQA5fY0n35hVhwlBaMcXoUByNIyPtSX/6HylYDFc5laTqJOi4UtqkOEsy++AOVq088H
	P71WWB56LXOcoWyQLIZRs9Y4H37DM6NttwxKGWFgC3iv0pGDoDHQcpB99XKxtoIFXjg3fj
	nVYZ4BgNRuvpKGtX0GywIWPBjKfi8Co=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759734769;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YVETF4d3bqYhAyMLMLANQ8JXCxRCYuuw8Shm1QGnRKA=;
	b=HkFBIz91ex5qqDPVTT8X4dys+BK/xIg7Ef0XRWtDUl4Y2CLPXRv6NQe0OOXDWCj6FV3P4u
	BDsykLLeEPMPEvAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B5AD613700;
	Mon,  6 Oct 2025 07:12:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pm7vKvFr42gTFQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 06 Oct 2025 07:12:49 +0000
Message-ID: <af2047ff-0bfb-4809-99b8-7d22eebe52f5@suse.de>
Date: Mon, 6 Oct 2025 09:12:49 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] scsi: scsi_debug: Add "only_once" module option to
 inject an error one time
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-10-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251002192510.1922731-10-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 10/2/25 21:25, Ewan D. Milne wrote:
> The "every_nth" module option allows either periodic injection of errors
> every N commands, or injection of errors on all commands after N commands.
> It does not allow injection of a single error after N commands, which is
> useful for testing things like code in the device probe path.
> 
> Add a new "only_once" module option that allows injection of a single error.
> The "every_nth" module options are still used to control when the error
> is injected, to simplify the code.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/scsi_debug.c | 50 +++++++++++++++++++++++++++++++++------
>   1 file changed, 43 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
