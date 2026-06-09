Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E493C0624
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 07:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780989897; cv=none; b=o0sncu4YMp7roT1CGJBqpL4Q+Fmg5caSgShVL8QwJEiNTNeSRjPOSyv6SQZOXfXWQ8U7OyA1ja9Y36Z9uhjczhvGVvJrzmcylkWd7XQsflcVO7tFlYRT5a0WRWpB9+orVHJZqsIy0UInFMDjeZCc+xS2YiWUzPeCl1FAlI1L1dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780989897; c=relaxed/simple;
	bh=ewOpURvMIW3LwSKgzIU5K3XIS3Us6h1KQxntwIdikTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cvRxJwNMTujfiAyesV05zQ4G+x4rzcV8xaBVecUmnYolkqsSAyPEuirxS6T/JX9S7+QjX4djlKHfmAKpXZszcPgp1NK3ZdMdtrDtVdmF+b926tjHPJMXWnne8UO12SnN5ii0PO8ARZLxyEGHgF8HUwKDTg8VIV6uQsFccNcGzUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dhIObt66; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LiXE/eGc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dhIObt66; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LiXE/eGc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dhIObt66";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LiXE/eGc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dhIObt66";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LiXE/eGc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1BE8C759CA;
	Tue,  9 Jun 2026 07:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780989895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Urhm98+FLCEkqRXx3L9rWlda4EwBSEFcjvaDVia1hW0=;
	b=dhIObt666HpVekzPwHKkrRk6ELgbf5I1Jr8REs50UO4sTeBxFvNbZZZ6ri1u0VBEwcc8+5
	DWVki+q/CswfcMY5xSfT9w0/SbncGyxK8wU+6jyROoQ6xSG9ceUaQ+Uo5VMKUKiggPYyOL
	vkfwLutgAxoLs1STRlJR86v8W+CBct4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780989895;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Urhm98+FLCEkqRXx3L9rWlda4EwBSEFcjvaDVia1hW0=;
	b=LiXE/eGcRAsejicky1fixMvYH2N74ht98ZbUB7LZzaIuHO7fpBcolN0i0tRvkhWcAApdnV
	8SGnlQ+NZgTHYeAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dhIObt66;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="LiXE/eGc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780989895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Urhm98+FLCEkqRXx3L9rWlda4EwBSEFcjvaDVia1hW0=;
	b=dhIObt666HpVekzPwHKkrRk6ELgbf5I1Jr8REs50UO4sTeBxFvNbZZZ6ri1u0VBEwcc8+5
	DWVki+q/CswfcMY5xSfT9w0/SbncGyxK8wU+6jyROoQ6xSG9ceUaQ+Uo5VMKUKiggPYyOL
	vkfwLutgAxoLs1STRlJR86v8W+CBct4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780989895;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Urhm98+FLCEkqRXx3L9rWlda4EwBSEFcjvaDVia1hW0=;
	b=LiXE/eGcRAsejicky1fixMvYH2N74ht98ZbUB7LZzaIuHO7fpBcolN0i0tRvkhWcAApdnV
	8SGnlQ+NZgTHYeAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C684C779A7;
	Tue,  9 Jun 2026 07:24:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wMKpLsa/J2qeGwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 09 Jun 2026 07:24:54 +0000
Message-ID: <f8d54ab4-3228-46e6-b245-403606cc5b43@suse.de>
Date: Tue, 9 Jun 2026 09:24:54 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/6] scsi: add BLIST_NO_LUN_1F blacklist flag
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260608213443.2296614-1-philpem@philpem.me.uk>
 <20260608213443.2296614-5-philpem@philpem.me.uk>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260608213443.2296614-5-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[philpem.me.uk:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim,suse.de:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,philpem.me.uk:email,suse.de:email,suse.de:dkim,suse.de:mid];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1BE8C759CA
X-Spam-Score: -4.51

On 6/8/26 23:34, Phil Pemberton wrote:
> Some multi-LUN devices respond to INQUIRY on unpopulated LUNs with
> PQ=0 / PDT=0x1f instead of the standard PQ=3.  The SCSI scan layer
> normally adds such devices (PQ=0 means "connected"), producing
> spurious "No Device" entries.
> 
> The scsi_target field pdt_1f_for_no_lun already exists to suppress
> this, but was previously only set by the USB UFI driver.
> 
> Add BLIST_NO_LUN_1F so the flag can be set per-device from
> scsi_devinfo, and wire it up in scsi_add_lun() to set
> starget->pdt_1f_for_no_lun from the blacklist flags.  This runs
> during LUN 0 processing, before the sequential LUN scan probes
> higher LUNs.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>   drivers/scsi/scsi_scan.c    | 2 ++
>   include/scsi/scsi_devinfo.h | 6 +++---
>   2 files changed, 5 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
