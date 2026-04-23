Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119B5386552
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 11:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776942200; cv=none; b=QQkkaOqmksy1XP3X21YmEaeO4bdsBnswUFxsguugtRDturNWQtBKvLVK8SFcRXf6QP1JwFQdsf1WJyS0mxiaLNkACbBXsbikFCHNRXZWIQkd6C9OcjjAzNGQPmJReieoXdAmCD2Eg3z33zK28XI+jK49I2iAM97SUVL5OfmkHpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776942200; c=relaxed/simple;
	bh=vCyn6ularYPgMK+JZIAFAVkpBaAqrjoWjndiPa6yQbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t6os1ut+ixO40t2O5i7OB8fLIiNW4AGlblyxVa+/bTBlknuIN1IKv4sqbRL2tw2fYULFYzH+UnaCv+k8+e8pzHhPjtdt6nbH+ZcvnkHkv7zThcRvu0WEngf0JlDmoXvLCl6ukWW9ojWUMblsLwG0LjpHtjKt3AOLLGWZxlOhGPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MXX1xtTB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FFnNSYk7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MXX1xtTB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FFnNSYk7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MXX1xtTB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FFnNSYk7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MXX1xtTB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FFnNSYk7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 514415BD79;
	Thu, 23 Apr 2026 11:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776942197; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yUJmH9rrYLiFteZFFzLNOgJG8T6aIo4w+/SpsRFCnsI=;
	b=MXX1xtTBsOQx3LyP0h3J/mtXCpw5wNwRLSWfB6vhqiF7y6fIfqURPegOEYkn8ab4K+QyVt
	B+SYCDJZ5DpopwH8A9mXf5WA3x8X0Tw7X/a29jCC9TMbRkZOr5WyKrSFqoQlTDznjS5GDY
	0EeE80aRxj7NMI3cJtOjWy3siAYmruY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776942197;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yUJmH9rrYLiFteZFFzLNOgJG8T6aIo4w+/SpsRFCnsI=;
	b=FFnNSYk7GSTX0tuQ0A15nlY3z6SjuAHv2Erc7lCW+yBaCLBawrnt6ygxNXTH8E1vVNmvXI
	9o0hAOztoOJuoxBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776942197; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yUJmH9rrYLiFteZFFzLNOgJG8T6aIo4w+/SpsRFCnsI=;
	b=MXX1xtTBsOQx3LyP0h3J/mtXCpw5wNwRLSWfB6vhqiF7y6fIfqURPegOEYkn8ab4K+QyVt
	B+SYCDJZ5DpopwH8A9mXf5WA3x8X0Tw7X/a29jCC9TMbRkZOr5WyKrSFqoQlTDznjS5GDY
	0EeE80aRxj7NMI3cJtOjWy3siAYmruY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776942197;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yUJmH9rrYLiFteZFFzLNOgJG8T6aIo4w+/SpsRFCnsI=;
	b=FFnNSYk7GSTX0tuQ0A15nlY3z6SjuAHv2Erc7lCW+yBaCLBawrnt6ygxNXTH8E1vVNmvXI
	9o0hAOztoOJuoxBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 37948593A3;
	Thu, 23 Apr 2026 11:03:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cZ0bDXX86WnaFAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 23 Apr 2026 11:03:17 +0000
Message-ID: <cb5255ef-ae53-46c7-8039-b1fff655883d@suse.de>
Date: Thu, 23 Apr 2026 13:03:16 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] ata: libata-scsi: add atapi_max_lun module
 parameter
To: Phil Pemberton <philpem@philpem.me.uk>,
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260420122321.4161027-1-philpem@philpem.me.uk>
 <20260420122321.4161027-2-philpem@philpem.me.uk>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260420122321.4161027-2-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
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
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO

On 4/20/26 14:23, Phil Pemberton wrote:
> Until now libata has hard-coded shost->max_lun = 1 for every ATA host,
> so the SCSI layer never scans past LUN 0.  This blocks support for
> the small handful of multi-LUN ATAPI devices (Panasonic LF-1195C and
> COMPAQ PD-1 PD/CD combos export CD on LUN 0 and PD on LUN 1; old
> Nakamichi MJ-x.y CD changers expose one LUN per disc slot, up to 7).
> 
> Introduce a libata module parameter, atapi_max_lun, that controls the
> upper bound of the per-host SCSI LUN scan.  Default is 1, preserving
> current behaviour exactly: out-of-the-box only LUN 0 is scanned.
> Range is clamped to 1..ATAPI_MAX_LUN (8, the SCSI-2 ceiling).
> 
> Subsequent patches gate actual LUN>0 probing on BLIST_FORCELUN, so a
> device must both be on the SCSI device list (or carry the appropriate
> quirk) and run on a host whose atapi_max_lun has been raised before
> any extra LUNs are scanned.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>   drivers/ata/libata-core.c | 5 +++++
>   drivers/ata/libata-scsi.c | 2 +-
>   drivers/ata/libata.h      | 1 +
>   include/linux/libata.h    | 1 +
>   4 files changed, 8 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
