Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626714C957B;
	Mon,  7 Sep 2026 12:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788785839; cv=none; b=nw/pw7SlkdlUVqx2+4vESSev6DcqVnklTQxi7BsqqO9ug28ap17nZyoYOGVYR9SnGy6bI21JTnOIGIGZsnhxUKZXk8rJfr46aENnn8NGrq6Re1Gmpnlew5GX+KbkyYD77i4OaT7DTO71fnkUmVP0I1LLoBjwNTB2dj0HMcea4ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788785839; c=relaxed/simple;
	bh=UHtd0LUIVjT/zVVIcl3TSJfMlzHww86Siz4/NvT550g=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IP+omt/0pvpFlQQoPAF5Nkg9saQoAPuKEBW1tskL7m6kxH14GImeLrEf10cCKbs3mVuCdSKTqkcyG9T3UuLFrU2GLDNRVxqOqL+Kt5YU5IC0kr7eXs+vhWWYraC8wkB2WkkdIRbgGnl9Z4HVx12pJomKZx6bLOT25Zkwv0Hg33U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IWzXXy8W; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DnUaqQ0c; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cGTmRPQ+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qL7qlx41; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IWzXXy8W";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DnUaqQ0c";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cGTmRPQ+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qL7qlx41"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 92B2821962;
	Mon,  7 Sep 2026 12:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788785824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PCY95fqP9aEeZzs08v82g9KRX6awIW3yXQl14W9ouwU=;
	b=IWzXXy8Wyu+/RLC2nKKplqEvU8J+/XkGNWLM7D6DXv3Fkpc6E5R+aEJj6gXx6dblvTwdKI
	OEDpiC0LD4TBhDMlAr7TfLgb4ukk6hilGCOPFRtSmuHMoWOMLanZD77UlwVjRIq8gb1Q8f
	2r6bIRlDJ5nIho7IygT9G0c35a9aIks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788785824;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PCY95fqP9aEeZzs08v82g9KRX6awIW3yXQl14W9ouwU=;
	b=DnUaqQ0cvNZOynKfrp2Gg2H89vXm8fXDLaLToFdO5DxUI3FF3AA0RuTwGOZ8F3sptZWa3Q
	qHeGwVIjgn8kNdAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cGTmRPQ+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qL7qlx41
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788785820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PCY95fqP9aEeZzs08v82g9KRX6awIW3yXQl14W9ouwU=;
	b=cGTmRPQ+3x5U7qWl3LDeyjmH2uUcJnGFAOGtQ+po9ZGCUHHXTP0AszkMExQ+sUUysUFEPF
	4ksbPepAxvL/CGGYx8yyMS6KGbaSYeOhCQ2vW+dlHhO1TIlfor5c673+hJ8xZsDOxP5z/4
	mb8gtgJPdc6MlLhFSzBgDeR1NlE2Hqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788785820;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PCY95fqP9aEeZzs08v82g9KRX6awIW3yXQl14W9ouwU=;
	b=qL7qlx41CgJ1ZjGo8fqlDEKMDx+8clWFD/t1sGjiY82BTZTBuJ5yoKoFXa5Lz72n19Cr3V
	xvJSfEfliES5xqBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 37E3C1339B;
	Mon,  7 Sep 2026 12:57:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n3ERDJy0nmpJSwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:57:00 +0000
Message-ID: <f5aa111e-a883-4cd2-86db-ddee64d99d1d@suse.de>
Date: Mon, 7 Sep 2026 14:56:59 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 35/40] usb: storage: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-36-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-36-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 92B2821962
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
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the USB mass storage driver to replace all hard-coded additional
> sense codes and additional sense code qualifiers with the enum values
> defined in include/scsi/scsi_sense.h. This helps with code clarity as the
> sense codes being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/usb/gadget/function/f_mass_storage.c | 34 +++++-----
>   drivers/usb/gadget/function/storage_common.h | 71 +++++++++++++++-----
>   drivers/usb/storage/transport.c              |  5 +-
>   3 files changed, 74 insertions(+), 36 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
