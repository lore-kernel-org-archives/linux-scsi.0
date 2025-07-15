Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9871E1E16
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 14:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752591053; cv=none; b=rQYIoiFknj28739Jb5U0iMH0v73ekZMiOhJhXG/nAKOX6pdpv5F+1kFUaB9z6PK9jG96O1jjQxzk3aIP6QmDK4IxkAGNF0xH7KIHlPrkZXQ+4F97FnPMWY+cDv8xLJfuP4gYFdM3cE28gUvk8geF/+qYMQtjP8Kq3hXrrfdcEkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752591053; c=relaxed/simple;
	bh=bpis9JUZDh2bj0eq8RjJ+XR/khavYYmOjplEDA5Zxkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=N+Mm3dbxPnd9gHYGZXQu8VK+q0th7wI3V0neCwV8YZhWVm29O82bbAxJRFr0GiJsWz8dsoOTCxUMipJ0sRFr9vHghaYZR7hQgvHU0UMpRqEbzzhnHlL0WXvWZCaEL2Dotwvk0DNntP3pbo9b3VHYkKxSQVUj685vywQlV+dFAxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=G5Z0Bn1K; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4oQqa8iH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=G5Z0Bn1K; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4oQqa8iH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="G5Z0Bn1K";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4oQqa8iH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="G5Z0Bn1K";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4oQqa8iH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2D2BE1F7DB;
	Tue, 15 Jul 2025 14:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752591050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5FkpmA2dJaPh6lYsUWIhvp7LFVKy21U3SC7LsLOAcx0=;
	b=G5Z0Bn1KGvyz7fuViBY+R4GvP7R+z4nUeqc505GypwJ0CMyddOp6IqUep6PpYhrXVL2VSy
	L3N7KvLEC6zASRQx/tED78hGs5eJOxGJJuZ0rxLpNFIVjUmZJmKakljDldbJTLVbPimOkE
	8el/rd/MyhfFMj5ccmilvbdNsSfWuE4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752591050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5FkpmA2dJaPh6lYsUWIhvp7LFVKy21U3SC7LsLOAcx0=;
	b=4oQqa8iHjNu/QQFOlobu4Epkqdjw4TlFRLVjvyjcs5EY0hb8hu+86Gq0lfgfQgHSM7/QQe
	3JKHjcqupVDQ9JBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=G5Z0Bn1K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4oQqa8iH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752591050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5FkpmA2dJaPh6lYsUWIhvp7LFVKy21U3SC7LsLOAcx0=;
	b=G5Z0Bn1KGvyz7fuViBY+R4GvP7R+z4nUeqc505GypwJ0CMyddOp6IqUep6PpYhrXVL2VSy
	L3N7KvLEC6zASRQx/tED78hGs5eJOxGJJuZ0rxLpNFIVjUmZJmKakljDldbJTLVbPimOkE
	8el/rd/MyhfFMj5ccmilvbdNsSfWuE4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752591050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5FkpmA2dJaPh6lYsUWIhvp7LFVKy21U3SC7LsLOAcx0=;
	b=4oQqa8iHjNu/QQFOlobu4Epkqdjw4TlFRLVjvyjcs5EY0hb8hu+86Gq0lfgfQgHSM7/QQe
	3JKHjcqupVDQ9JBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC25013306;
	Tue, 15 Jul 2025 14:50:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id o/5lOMlqdmgoUgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 15 Jul 2025 14:50:49 +0000
Message-ID: <f7f4aacb-b6fc-42a9-9a35-ab252fbdc753@suse.de>
Date: Tue, 15 Jul 2025 16:50:41 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] ata: libata-eh: Remove ata_do_eh()
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>
References: <20250711083544.231706-1-dlemoal@kernel.org>
 <20250711083544.231706-2-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250711083544.231706-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 2D2BE1F7DB
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 7/11/25 10:35, Damien Le Moal wrote:
> The only reason for ata_do_eh() to exist is that the two caller sites,
> ata_std_error_handler() and ata_sff_error_handler() may pass it a
> NULL hardreset operation so that the built-in (generic) hardreset
> operation for a driver is ignored if the adapter SCR access is not
> available.
> 
> However, ata_std_error_handler() and ata_sff_error_handler()
> modifications of the hardreset port operation can easily be combined as
> they are mutually exclusive. That is, a driver using sata_std_hardreset()
> as its hardreset operation cannot use sata_sff_hardreset() and
> vice-versa.
> 
> With this observation, ata_do_eh() can be removed and its code moved to
> ata_std_error_handler(). The condition used to ignore the built-in
> hardreset port operation is modified to be the one that was used in
> ata_sff_error_handler(). This requires defining a stub for the function
> sata_sff_hardreset() to avoid compilation errors when CONFIG_ATA_SFF is
> not enabled.
> 
> This change simplifies ata_sff_error_handler() as this function now only
> needs to call ata_std_error_handler().
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-eh.c  | 46 ++++++++++++----------------------------
>   drivers/ata/libata-sff.c | 10 +--------
>   include/linux/libata.h   |  9 +++++---
>   3 files changed, 20 insertions(+), 45 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
