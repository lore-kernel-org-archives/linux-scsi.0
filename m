Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4B3231832
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 07:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780989951; cv=none; b=cwsnKCSnBOwQ04G3G6e+SW/xf7zKT2LqZnR2QIrgyIA0fMBH71I3IvsWAzgOePcJStBndeSofEhZXeVIq7KTV0+Pah5DlAK7/oNfzPPybzfaQUVCjn+fQ7eTrjnBsBDJziAIKeAdjmynkkB4BX4fP0RjdfdKh5yScBopndflQ4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780989951; c=relaxed/simple;
	bh=q42eXoHCR7YgfO4/3gUva36dm3zZlWYGKQ1tE5CkdSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aYbRNGwPOCFNL9kbh1TKOTMIkWY/yaP0QzrQDSmV38dECw/HqZeaiwxeC4Q9qehuQeLWH/LZnQBw/iSRn0t4zU10OLyQbe6yfzPDaLDYTBFnZ1knhK5Bk+YiToY7GkhxpG4J431dR7J7e9CxVtV+u9DQv8JhBdGEfKgic4xmmn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0+mSiSSK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=p/S/nggy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NhB0sBUS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=panRXV2l; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0+mSiSSK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="p/S/nggy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NhB0sBUS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="panRXV2l"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E8D72758A0;
	Tue,  9 Jun 2026 07:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780989949; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y1c597nURKM193IqO1P0MsCFlL07GhCIzg4dHpv/0H4=;
	b=0+mSiSSKzNLB0VdVT0bTyg2oLpuG8G074YEFrpSJ6XRjUPibQa6sKN/W8xZZskCX9IAaOT
	nobuxDRb+z01cBvGGxC8BvAkmHII/AXPdA2nB2egIFjQemoe3ATScqzeLv/83b0GSvmwYS
	Ixh+zii6KN3MF4lREUnrIInEn/LiAvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780989949;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y1c597nURKM193IqO1P0MsCFlL07GhCIzg4dHpv/0H4=;
	b=p/S/nggyX0FAQyt26yxm9HAMYPB1unIsK1ks+W4jtZ3UU+9PXHOn91cdA72V+8pD1FNQHi
	SRVJ5Oi/EFcu7dBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780989948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y1c597nURKM193IqO1P0MsCFlL07GhCIzg4dHpv/0H4=;
	b=NhB0sBUSgT1yw/CBF6juJLc326xGC+vTvEyMNFsNtifORkhdwCJWI9/DEkGHLyPucSpbrk
	8iKsWFg+x6n/xMleMUCNb+Wu4kiivcJXUst/u3H9MhofIdgiVHnpoG7NE/tx9MsL+XHtv3
	Lze5l3LlJQwc3YQ5/2MoSQe1yYjMkSk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780989948;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y1c597nURKM193IqO1P0MsCFlL07GhCIzg4dHpv/0H4=;
	b=panRXV2lIZlX9uQ8xzaOTHPDiA3uoEVdwVvEewgeRO8jApgopVyco2ZI5FjF7+7F1yY8Vi
	JrqprB7KGIYabIDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A508C779A7;
	Tue,  9 Jun 2026 07:25:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4VfCJvy/J2psHAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 09 Jun 2026 07:25:48 +0000
Message-ID: <36b3d49f-7ad3-4b8d-9d74-a7ee9b9c429f@suse.de>
Date: Tue, 9 Jun 2026 09:25:48 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/6] ata: libata-scsi: probe additional LUNs for
 multi-LUN ATAPI devices
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260608213443.2296614-1-philpem@philpem.me.uk>
 <20260608213443.2296614-6-philpem@philpem.me.uk>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260608213443.2296614-6-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid,philpem.me.uk:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,philpem.me.uk:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -4.30

On 6/8/26 23:34, Phil Pemberton wrote:
> After LUN 0 is added for an ATAPI device, check its BLIST_FORCELUN
> flag.  If set, bump dev->nr_luns to the host's max_lun so the LUN
> routing in atapi_xlat() accepts the probe INQUIRYs, then call
> scsi_scan_target() with SCAN_WILD_CARD to trigger the SCSI layer's
> built-in sequential LUN scan for that target only.  This probes
> LUNs 1..shost->max_lun, driven by the libata atapi_max_lun module
> parameter.
> 
> Devices without BLIST_FORCELUN (the vast majority of ATAPI devices)
> are left with only LUN 0 -- no sequential scan is triggered, so
> single-LUN devices like the iHAS124 DVD writer are completely
> unaffected.
> 
> Non-responding LUNs (PQ=0/PDT=0x1f) are silently skipped by
> scsi_probe_and_add_lun() when BLIST_NO_LUN_1F is set on the device
> via scsi_devinfo.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>   drivers/ata/libata-scsi.c | 27 +++++++++++++++++++++++----
>   1 file changed, 23 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
