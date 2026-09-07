Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B07492520;
	Mon,  7 Sep 2026 12:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784124; cv=none; b=siaRmYa25uBiMHZYMkG4NnaudnNPZRVzHMFCfcqbVWA6g3kgoWQ3vrqPlHbJGWBy1Xt6qb2MTmi3dLCfOyfqfdB5cXRUySdedvpbtTA2o+5QJGDXNGrHYNXo0Zr1g+7jfN70xHeyWpnmWA6bFAACB/RGZJsnylAlzogf9o8va2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784124; c=relaxed/simple;
	bh=xhkiqNirWeJDKNkseJDyt+CijC6NQIw//NiON26uWSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=g2TYCKCwkvB8HwcuEEOuPezn8fzzuNmfwWPldlk6yg6+jxT+g31d8HDiZ2eS1j4KWjiRF7+NZm7rtKkySFI6HnRF5vnjo43WW/VLql0Dlwjf27LzPkhJUh+zy3kOvCHD/eN7z/g7SwoEoO6UaxnJak0bn1Aw3vUWP3UiMMwhEec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CvCkOxGa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qPrFHbOG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oIbSGZDw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jlUNEYs/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CvCkOxGa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qPrFHbOG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oIbSGZDw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jlUNEYs/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EFCE42119D;
	Mon,  7 Sep 2026 12:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OPE+z64M5jL7RA5VCAegGun575HUPF4XGoQWfUASEh8=;
	b=CvCkOxGaKujPV6sBcaQqRtOyqVbAuoSAdATidxuaHMRsd1mp/9QYZ4i99K6voz4h02Mm9K
	coVa2Ixbtk9TqfLyWaDvw8/L0ROlK4M5bjM5lTl3IKbd2kmLzHYDtCHetsX/UJzigXXIXJ
	hnx7RAs4WalrswANNefU/6gGflp3u74=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784117;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OPE+z64M5jL7RA5VCAegGun575HUPF4XGoQWfUASEh8=;
	b=qPrFHbOGljJZYbMtb6cUS7Q59ebjusWuN8P7SJ6jNdNpXLh/Th9VDXhkxqHZLQ+9/OxQVO
	t5sfu0W2YbFKZlDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oIbSGZDw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="jlUNEYs/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784112; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OPE+z64M5jL7RA5VCAegGun575HUPF4XGoQWfUASEh8=;
	b=oIbSGZDwipzGF0XjTlijmF8IcIqzBerxNCorpQxVW9rQGqWwZGngv/A5aIZnCVQCj+EjSS
	36MeApGSGsRf6JddZ9oydJBVRwvP8AOdSqn9rb9Cc7sLvag6E4CCxF8SBoYUeIsUdIigxI
	Flt6Sf7xsbGd1pBeDE1EZONZbmto6QY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784112;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OPE+z64M5jL7RA5VCAegGun575HUPF4XGoQWfUASEh8=;
	b=jlUNEYs/sp3xTR5bfx30mfKQDzEw0Ssk3S0ASFUTs/cqfFILaYJ1uAT8mfqDhtg50eGvQC
	iQIaksk8NnJfDZAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D3981339B;
	Mon,  7 Sep 2026 12:28:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KKc6IfCtnmqbLgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:28:32 +0000
Message-ID: <c71c3e15-52c6-47aa-95a0-41604b2af094@suse.de>
Date: Mon, 7 Sep 2026 14:28:32 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/40] scsi: device_handlers: hp_sw: use 16-bits
 defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-14-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-14-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: EFCE42119D
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the HP sw device handler driver to use the 16-bits sense_code
> field of struct scsi_sense_hdr and struct scsi_failure and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/device_handler/scsi_dh_hp_sw.c | 25 +++++++++------------
>   1 file changed, 11 insertions(+), 14 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
