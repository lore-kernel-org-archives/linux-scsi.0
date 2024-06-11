Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52B5171650
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jun 2024 06:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718087234; cv=none; b=Ne3tRw+LmcBi40/Zr77kqWN14egKeiRq9pAZBC8WKIxLqHtQZx25pAOSpVZWObP2ugN1K4JnKPrs8Xt1MkK14vf48/cJrf3pUvGGOZdHoIRxjeaDnOWe000BrzbpG04WvTE127GxbqXDF45P10Dqma3d9gkD3kW/k0lJHvAn2+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718087234; c=relaxed/simple;
	bh=1UBrqYMu7tIHsqc2uh7GqxGtVZRA2IknDI2/8L9fgpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WZU5cPBfCq3LMW306k8c36e6QRRVNEZA3A1Gg1XJXrgSHwKBV2XS/3YMwri+zVLm3t4tXBfe9TDTPh0byiRoni++UHlEaEwxx4D/ClQPORuK04LbcZChWZZU/cwifjBDs5+ey5DmhC2JCSB2mEa3zCcKPEGeqsVYwU+jVkiu1PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ydefi0UY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=d1PwkP5k; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ydefi0UY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=d1PwkP5k; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ydefi0UY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="d1PwkP5k";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ydefi0UY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="d1PwkP5k"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B356222C08;
	Tue, 11 Jun 2024 06:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718087230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pgmNr+2YbeR5b5qGTypRGQN5nZAlDEA3jv5cNG2TwaQ=;
	b=Ydefi0UYY7g4u+UcTsDAh2IW32ZE3LfHkY8stPwsuBQV/zE24NiaE1k2iT5xhg0GCNAUWy
	NjRWBx/Dla1/wbz4tvap3eiwq/QQr2a+an9bwk1NlLmWHCKPZ9xjt6Q9j0UCEuvq+bH9Ei
	ZnjtOCVCBt7qJDZHK6w8A3urK7uaB3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718087230;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pgmNr+2YbeR5b5qGTypRGQN5nZAlDEA3jv5cNG2TwaQ=;
	b=d1PwkP5k5G8cJq7DGs9V+cJ6TfJoMH2OMEWVmaycWvZFPS+BP1lJBVNeOlN5lwMaXKWdy5
	NWv7vG91zYclZLDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ydefi0UY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=d1PwkP5k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718087230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pgmNr+2YbeR5b5qGTypRGQN5nZAlDEA3jv5cNG2TwaQ=;
	b=Ydefi0UYY7g4u+UcTsDAh2IW32ZE3LfHkY8stPwsuBQV/zE24NiaE1k2iT5xhg0GCNAUWy
	NjRWBx/Dla1/wbz4tvap3eiwq/QQr2a+an9bwk1NlLmWHCKPZ9xjt6Q9j0UCEuvq+bH9Ei
	ZnjtOCVCBt7qJDZHK6w8A3urK7uaB3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718087230;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pgmNr+2YbeR5b5qGTypRGQN5nZAlDEA3jv5cNG2TwaQ=;
	b=d1PwkP5k5G8cJq7DGs9V+cJ6TfJoMH2OMEWVmaycWvZFPS+BP1lJBVNeOlN5lwMaXKWdy5
	NWv7vG91zYclZLDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D124137DF;
	Tue, 11 Jun 2024 06:27:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B80SHD7uZ2YLOQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 11 Jun 2024 06:27:10 +0000
Message-ID: <136d2ef0-7451-4477-91a9-97833bc2f92d@suse.de>
Date: Tue, 11 Jun 2024 08:27:09 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: Disable CDL by default
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: Igor Pylypiv <ipylypiv@google.com>
References: <20240607012507.111488-1-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240607012507.111488-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-6.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B356222C08
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -6.50

On 6/7/24 03:25, Damien Le Moal wrote:
> For scsi devices supporting the Command Duration Limits feature set, the
> user can enable/disable this feature use through the sysfs device
> attribute cdl_enable. This attribute modification triggers a call to
> scsi_cdl_enable() to enable and disable the feature for ATA devices and
> set the scsi device cdl_enable field to the user provided bool value.
> For SCSI devices supporting CDL, the feature set is always enabled and
> scsi_cdl_enable() is reduced to setting the cdl_enable field.
> 
> However, for ATA devices, a drive may spin-up with the CDL feature
> enabled by default. But the scsi device cdl_enable field is always
> initialized to false (CDL disabled), regardless of the actual device
> CDL feature state. For ATA devices managed by libata (or libsas),
> libata-core always disables the CDL feature set when the device is
> attached, thus syncing the state of the CDL feature on the device and of
> the scsi device cdl_enable field. However, for ATA devices connected to
> a SAS HBA, the CDL feature is not disabled on scan for ATA devices that
> have this feature enabled by default, leading to an inconsistent state
> of the feature on the device with the scsi device cdl_enable field.
> 
> Avoid this inconsistency by adding a call to scsi_cdl_enable() in
> scsi_cdl_check() to make sure that the device-side state of the CDL
> feature set always matches the scsi device cdl_enable field state.
> This implies that CDL will always be disabled for ATA devices connected
> to SAS HBAs, which is consistent with libata/libsas initialization of
> the device.
> 
> Reported-by: Scott McCoy <scott.mccoy@wdc.com>
> Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
> 
> Changes from v1:
>   - Fixed typo in the commit title and improved the commit message
> 
>   drivers/scsi/scsi.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

