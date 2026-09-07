Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F324477FA;
	Mon,  7 Sep 2026 13:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788789089; cv=none; b=ntp05T4t3kzyMKPY95KRSjxgx6VHGH+BMOXrIix/PJnPIyRfI4e3mKJkGRRGsZp0pmY5HH8wotyHx3938BBAcjtRz4gemmrJ3+QlmVE/iZs4pmFK84kPB78MtZBA/a2P8ulqLUFyutNnB8quBXrca6Sij+gWXJnuxmqEqe9Gcq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788789089; c=relaxed/simple;
	bh=WdJ+oZdeH9dcQfvRYMnmJ4txW1ET6Ups730EiwissU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=D4ifT3OCvYjannhKBFzTBKI2QsP/DzAO+fRNIMjCPKxt+dH57ED3sZznxiY5mXLiko7TYBsNSqLnZW3D596RUzrcEBKH6SCHXsoXpTyk7wryMXtRwX/UWOmXue7P4ASByo3RJADXXcnP9Df0WP6eYitJO7yeulVxS4VlVcaVwC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A5xWXNwg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CKsfj62n; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=scCdmYI9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=J5lCebmb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A5xWXNwg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CKsfj62n";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="scCdmYI9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="J5lCebmb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F126421ACB;
	Mon,  7 Sep 2026 13:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788789082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fUn8riISDGRXp8oj9IkzvWkv7jCNjZP7sAPRRn50hi4=;
	b=A5xWXNwgEcke8Y3J9l+spQARM8DzHaljoIWdvX8qt7rirS+CWCmJ8U/XKX+OI+zLQqbU0f
	Qe8mSsVKXxG3eQiiVUVrZcQ2hZiblvcXiarJO2UICuJfbR8MJ2DE3w5csSbEnXD95hVHDb
	YvlhqLJv7RD3enCzKMbxwenzw11FEXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788789082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fUn8riISDGRXp8oj9IkzvWkv7jCNjZP7sAPRRn50hi4=;
	b=CKsfj62nXARvsaTXGavQLocE8cMeiUasXOElTlNAtBHZsQF79i7VTfxwlDApryePVhxW32
	rgs+NPMY1XbxVbAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=scCdmYI9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=J5lCebmb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788789077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fUn8riISDGRXp8oj9IkzvWkv7jCNjZP7sAPRRn50hi4=;
	b=scCdmYI9n/J1J+Rqc8qJrcYb4V5YWEH0GSeo5UPlSnF5TeGM5wTkvfraEiHuAy4cT6SZhm
	u/ZybGcLj+usANmt9FXk+J+VXnVkY8BKimShWUuBcl+jBOqTzsDs8zfubaXTNjl1lTsz+b
	KCskHbM8RIyZ39wjH+qK6utimzwp/q0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788789077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fUn8riISDGRXp8oj9IkzvWkv7jCNjZP7sAPRRn50hi4=;
	b=J5lCebmbskQS3S8vE0hZ1PZ8sqDhf5/BqwJLI5/yvt+ZuTi9M7u/NG6eXTyEtQDwu6GjKN
	OYAJQ113iOq0U1Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9937913432;
	Mon,  7 Sep 2026 13:51:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vAYQJFXBnmqHAgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 13:51:17 +0000
Message-ID: <311615d0-a5e7-4b12-babd-9f5b4c8d3a8d@suse.de>
Date: Mon, 7 Sep 2026 15:51:17 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/40] scsi: 3w-xxxx: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-20-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-20-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: F126421ACB
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email,suse.de:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Modify the function tw_scsi_queue_lck() of the 3w-xxxx driver to use
> scsi_set_sense() and replace the hard-coded additional sense codes and
> additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/3w-xxxx.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
