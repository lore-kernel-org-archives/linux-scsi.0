Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6E819D8AC
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 06:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780295963; cv=none; b=Ij6jJ6AYCCrT9n94dCE6xz5q13XxcEl0JUXaF7SZ4PUcaIYMVeAS7L66k9ixVHU8biTEpcoUmwarBSeeyvBoTBSTBLa51VLXBlDwAgMtHYEveIkEITkEL4eqfgFsyhLqpJpAOGLC3dDbTv8p6zcosXD56zqd/DJAQ7CH5Kd9xGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780295963; c=relaxed/simple;
	bh=r5eRx32/6x+Fw26Ag4ukNzCLDpszuuIypS+/PYHoG9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HMa4yLwnpjBJ+XqQH9rT3oJU5605YkRxmFtnqui/XMn2ecuZ+X9z7umv7E4F27c7zhTDjwYeOKEVIZYThPM+b7keQNSoOBEfeNxacGvP/h4y/UKtOh9KY3pRvQZgk327G7Y0DeVMTLBfWuD76ULmrdIdwtqAkdlztyYSfvEzpkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rruTbmZl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eTRntuuJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rruTbmZl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eTRntuuJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rruTbmZl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eTRntuuJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rruTbmZl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eTRntuuJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 89AB96AB6D;
	Mon,  1 Jun 2026 06:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780295960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hY946+s7qhMHyMz2lNemuwA9/gVCAnP7R9qcOiQHgw8=;
	b=rruTbmZlyQDQYubQF8x4AareEeNqmGxMBGCt7KROHFsV+ejczz/N3L+XZVfut69DMci9lJ
	qnfeGhbeHKeWuJO5YVbNO5n09NKxYk3o+kkvXNDAg6GD8sGiKkBGsxE2LLlkk6Gnfi6Ad4
	ubsVxdV6s2Gi6lrFtFYeX+RYWvo38mY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780295960;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hY946+s7qhMHyMz2lNemuwA9/gVCAnP7R9qcOiQHgw8=;
	b=eTRntuuJoPN1RXEx+qJJ2oP8mYkC6EyWtLn22nA7JzhqlqsgYLXpZ6SQGiobvhgw5eEfys
	LrYCibADtkHVg9CA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rruTbmZl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eTRntuuJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780295960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hY946+s7qhMHyMz2lNemuwA9/gVCAnP7R9qcOiQHgw8=;
	b=rruTbmZlyQDQYubQF8x4AareEeNqmGxMBGCt7KROHFsV+ejczz/N3L+XZVfut69DMci9lJ
	qnfeGhbeHKeWuJO5YVbNO5n09NKxYk3o+kkvXNDAg6GD8sGiKkBGsxE2LLlkk6Gnfi6Ad4
	ubsVxdV6s2Gi6lrFtFYeX+RYWvo38mY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780295960;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hY946+s7qhMHyMz2lNemuwA9/gVCAnP7R9qcOiQHgw8=;
	b=eTRntuuJoPN1RXEx+qJJ2oP8mYkC6EyWtLn22nA7JzhqlqsgYLXpZ6SQGiobvhgw5eEfys
	LrYCibADtkHVg9CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50F39779A7;
	Mon,  1 Jun 2026 06:39:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OJTtERgpHWotJAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 01 Jun 2026 06:39:20 +0000
Message-ID: <a4d05f07-3800-44e1-b7f9-511c25ca2561@suse.de>
Date: Mon, 1 Jun 2026 08:39:19 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] scsi: core: Protect INQUIRY sysfs attributes with
 mutex
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org, Krishna Kant <krishna.kant@purestorage.com>
References: <20260429224939.77082-1-brian@purestorage.com>
 <20260530002019.47109-1-brian@purestorage.com>
 <20260530002019.47109-2-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260530002019.47109-2-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 89AB96AB6D
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]

On 5/30/26 02:20, Brian Bunker wrote:
> All INQUIRY-derived sysfs attributes (type, scsi_level, vendor, model,
> rev, cdl_supported, and the binary inquiry attribute) read data that
> can be updated during device rescan. These reads must be protected
> against concurrent updates.
> 
> Use the existing inquiry_mutex to protect access to these sysfs
> attributes. This ensures that userspace always sees consistent INQUIRY
> data, even if a rescan is updating the buffer concurrently.
> 
> Update the sdev_rd_attr macro to take inquiry_mutex around the field
> access and switch to sysfs_emit. Since vendor, model, and rev are
> NUL-terminated fixed-size arrays, %s format handles all field types
> correctly.
> 
> This is preparatory work for adding INQUIRY data update support during
> device rescan operations.
> 
> Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/scsi_sysfs.c | 28 +++++++++++++++++++---------
>   1 file changed, 19 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
