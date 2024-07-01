Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927AD381AA;
	Mon,  1 Jul 2024 06:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719814871; cv=none; b=PulTbFHG2/fd0qWfqJeE6dXrb5dVzqS+FEqX5VqXmZqnI1MX03kVr0yL8cbN5ccUYaeLN/Go8NqsUhYfgA7Gn3Qfb+QoQliAb+g6+ZF40TH/38YAeg3Fie3gbTTVaUCkSz1+3KONTJW/dfbdVCDiztEuZWohqnP2Rjkw8oYT8eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719814871; c=relaxed/simple;
	bh=2VN4I0AJWQlWLR4v0NS2ag8pEtJ2ocgozJoUwXrX36g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I/ZHC8MjYPJYjBGl7XsWbdjCNbtX/ViHJdMs8fcDa823mNC5zOsaHi6vjnvldL48MMlbaJC/7tgqWuv0ck895siq/lh44qrfxFpWhraSFpcYPyv2c053nEGmGbANiLKB9B3MaZolIkrbc/U5JLvZBgDSl/J/NpGUtr4PphtHc5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cVbxqJKw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rEgSUlCz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cVbxqJKw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rEgSUlCz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cVbxqJKw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rEgSUlCz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cVbxqJKw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rEgSUlCz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AC8F41F80E;
	Mon,  1 Jul 2024 06:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719814867; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ct52pDp4NXTLyq7RvaV9ECCmHt21J0SHg1fWo876k4k=;
	b=cVbxqJKwkbNh2clgWmUJrV87QB5XG6zY6FGPX+s6VSHcdIiKxUn7cCBNNO4R7BkohX4giu
	Yq6Ik0xhwYQh6rmagQzIg3Vwf1HZ8yLOTZZLXBHZDpzINSotCPTLhMgdBcUiM4ogdv71SK
	kriLTHK+WwagvHTBv5mkdR11LDdeE9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719814867;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ct52pDp4NXTLyq7RvaV9ECCmHt21J0SHg1fWo876k4k=;
	b=rEgSUlCzATcy/H8COTSXsitJVybsaYxItRw8eq8qjFqIFdk0IvZxGHOFw6/YhbWmLC7zGt
	ewe7+hybNqqUiFDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cVbxqJKw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rEgSUlCz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719814867; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ct52pDp4NXTLyq7RvaV9ECCmHt21J0SHg1fWo876k4k=;
	b=cVbxqJKwkbNh2clgWmUJrV87QB5XG6zY6FGPX+s6VSHcdIiKxUn7cCBNNO4R7BkohX4giu
	Yq6Ik0xhwYQh6rmagQzIg3Vwf1HZ8yLOTZZLXBHZDpzINSotCPTLhMgdBcUiM4ogdv71SK
	kriLTHK+WwagvHTBv5mkdR11LDdeE9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719814867;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ct52pDp4NXTLyq7RvaV9ECCmHt21J0SHg1fWo876k4k=;
	b=rEgSUlCzATcy/H8COTSXsitJVybsaYxItRw8eq8qjFqIFdk0IvZxGHOFw6/YhbWmLC7zGt
	ewe7+hybNqqUiFDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2267F13800;
	Mon,  1 Jul 2024 06:21:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OCAjBdNKgmaQXQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 01 Jul 2024 06:21:07 +0000
Message-ID: <591213f2-792b-4b5e-a344-fa410a1df7e4@suse.de>
Date: Mon, 1 Jul 2024 08:21:06 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] ata,scsi: libata-core: Do not leak memory for
 ata_port struct members
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
 linux-ide@vger.kernel.org
References: <20240629124210.181537-6-cassel@kernel.org>
 <20240629124210.181537-8-cassel@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240629124210.181537-8-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-5.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: AC8F41F80E
X-Spam-Flag: NO
X-Spam-Score: -5.50
X-Spam-Level: 

On 6/29/24 14:42, Niklas Cassel wrote:
> libsas is currently not freeing all the struct ata_port struct members,
> e.g. ncq_sense_buf for a driver supporting Command Duration Limits (CDL).
> 
> Add a function, ata_port_free(), that is used to free a ata_port,
> including its struct members. It makes sense to keep the code related to
> freeing a ata_port in its own function, which will also free all the
> struct members of struct ata_port.
> 
> Fixes: 18bd7718b5c4 ("scsi: ata: libata: Handle completion of CDL commands using policy 0xD")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   drivers/ata/libata-core.c          | 24 ++++++++++++++----------
>   drivers/scsi/libsas/sas_ata.c      |  2 +-
>   drivers/scsi/libsas/sas_discover.c |  2 +-
>   include/linux/libata.h             |  1 +
>   4 files changed, 17 insertions(+), 12 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

