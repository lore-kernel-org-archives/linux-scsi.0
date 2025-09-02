Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012DF2E03ED
	for <linux-scsi@vger.kernel.org>; Tue,  2 Sep 2025 06:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756795071; cv=none; b=MsxW2LGm8wNlj0ntZlPuaADhmC797GL159LMZ0Eex5vCxhKqGM2/3HcAYlJ+RmpmCgVDq1gr9iRgItRf6WmwPA6Sigxjy9+uUgeGBFVkVz4JSqxN6vt7OHUgKrX1SU/9S6lHWw6fopSDARFseAxfTkODTsN/Btq9bIr4AHmBWmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756795071; c=relaxed/simple;
	bh=sPE4Kc+Unl6reAmFjTL5aOHW/HQarIXSqOC1cc+Qdo4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sr9D4qMSyL44LAc1eNw75fHn1jGfC/Pnri9LpBJ5hhmy9qIdSkkyFf6PDzaKpVs6m9vwlpjf5lBBahPJBlVrDcUkIeGVP3bmVKV9OahV82vi6eODbvlY+zY8UrgHJnZ8hUvY6gdgdgqJA9gNtzAysXqie+sYa/uo6a3gC7B9AmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=X1pcGz/i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NPNvzpdO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=X1pcGz/i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NPNvzpdO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="X1pcGz/i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NPNvzpdO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="X1pcGz/i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NPNvzpdO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3F3CB1F395;
	Tue,  2 Sep 2025 06:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756795062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YdW9vvIXltHFOltrHb059oMVAnYxDBFx4gR2hd/NFC8=;
	b=X1pcGz/isnEA46NWN/CHqhQfFqd8a9jeTqsFicrxXPdpLUaZh/kL1pAVmf4UHaMj+EFLax
	igLYGnbCcfXKGPqqfD0MhlsneO9sL5ZkZ519Uu5Ne+lZCyih8rcyfuvoMgIYh+yf9ntmZS
	h3qAG5vICmXOCL17LFDGKB8D5yZNbMg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756795062;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YdW9vvIXltHFOltrHb059oMVAnYxDBFx4gR2hd/NFC8=;
	b=NPNvzpdO8s+0zZ/YNfwgT2fHAllyj8EEBrcgASCamUi0cTsZon2c1X8R92MN6YO3S5YjoC
	PLBhzR5bBZIWDxCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756795062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YdW9vvIXltHFOltrHb059oMVAnYxDBFx4gR2hd/NFC8=;
	b=X1pcGz/isnEA46NWN/CHqhQfFqd8a9jeTqsFicrxXPdpLUaZh/kL1pAVmf4UHaMj+EFLax
	igLYGnbCcfXKGPqqfD0MhlsneO9sL5ZkZ519Uu5Ne+lZCyih8rcyfuvoMgIYh+yf9ntmZS
	h3qAG5vICmXOCL17LFDGKB8D5yZNbMg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756795062;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YdW9vvIXltHFOltrHb059oMVAnYxDBFx4gR2hd/NFC8=;
	b=NPNvzpdO8s+0zZ/YNfwgT2fHAllyj8EEBrcgASCamUi0cTsZon2c1X8R92MN6YO3S5YjoC
	PLBhzR5bBZIWDxCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E32E813888;
	Tue,  2 Sep 2025 06:37:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id X+MiNbWQtmg/UwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 02 Sep 2025 06:37:41 +0000
Message-ID: <dc15bdf0-9b16-43a3-ba8a-b335b8042934@suse.de>
Date: Tue, 2 Sep 2025 08:37:41 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] scsi: scsi_error: Introduce new error handle
 mechanism
To: JiangJianJun <jiangjianjun3@huawei.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hewenliang4@huawei.com,
 yangyun50@huawei.com, wuyifeng10@huawei.com, yangxingui@h-partners.com
References: <17230842-0a7a-403e-abc7-a15e3aa5d424@suse.de>
 <20250902055628.2524926-1-jiangjianjun3@huawei.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250902055628.2524926-1-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 9/2/25 07:56, JiangJianJun wrote:
>> I fully agree that SCSI EH is in need of reworking. But adding
>> another layer of complexity on top of the existing one ... not sure.
> 
> Perhaps it would have been better to use only the error handler on the
> device from the start. Users might wonder why a single disk failure
> could cause other disks to become blocking.
> 
>> Additionally: TARGET RESET TMF is dead, and has been removed from SAM
>> since several years. It really is not worthwhile implementing.
> 
> Hmm.
> 
>> Can't we take a simple step, and just try to have a non-blocking version
>> of device reset?
>> I think that should cover quite some issues already.
> 
> Do you think it's necessary to escalate the issue after the device reset
> fails? Should we reset the bus or the host?
> Moreover, a failed device reset does not necessarily indicate a fault
> with the target or host.
> And what means of "non-blocking"?
> 
On the contrary, a failed device reset _always_ needs to be escalated.
The problem is that all EH issues start with a failed command (ignoring
the sg_reset case for now).
And a command typically is associated with data buffers / memory areas.
So when a command is failed we need to know when these buffers can be
released. If the device reset fails the command could not be reset,
and the buffers cannot be released. And without further escalation the
buffers remain locked until the next reboot.
That's why host reset is so important: that typically resets the entire
HBA (via a PCI-level reset or similar), so we can be sure that
afterwards all buffers are released and the command can be completed.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
