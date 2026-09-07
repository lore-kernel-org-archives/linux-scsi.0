Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6F4442B1D;
	Mon,  7 Sep 2026 12:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788783960; cv=none; b=crbO7PNlxoIo+VtUO+q54oF5N7kYf25LbxPZKuotn1BY5A7WEFjgT3UwUZlcIlgSDuyl5aQLrk+4H+svf05aNunNdZk6N8VPcUbdgJOMZWYxoCAKLRRLcYcysGC+vb7JSI2fKNsE+Sy6kWRGztND6VDmxLSf3T5fIewdwef1MAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788783960; c=relaxed/simple;
	bh=RD8cJvCcWrITWOPcmJjIbbl5mO13rutxuoJTLDMaksA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ScA5jcayVbCd0gdE9+xkzh8S5uoSdf30Gf+QyQdEXwK9zM0RNwsRHIhwHrgO99weeTjnE5PkKYXBRF8Gg2vy3EMjmoBkFKHeRtetfeVBe66eGKInDTieOYoMH+pWRI/FunThAORyBSQWD7OIEMrNGuQk9JJKWiiFy0SckMwVG44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VlOHJ/ag; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TKi2DeEG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=S84etnik; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lVRTt0un; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VlOHJ/ag";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TKi2DeEG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="S84etnik";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lVRTt0un"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 79137219B0;
	Mon,  7 Sep 2026 12:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788783952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cNrJBRVqfDqJGfN/zCQUW6w8Y2kkMmeEAPhFE60Qg0Y=;
	b=VlOHJ/agDQ88lS20qmekudHbacUGIGq4BACMoz8+Q5JlbTl8U7+2jHIvLyq2Aj1SAHF4fD
	4ElWI/releUMLak67DiGHhfqBbK5ICEcO4Inw6JrxCBCHOq+fTkZZQr68JrMhsyKWHVSdK
	la4wjra+TfjmLG/CyJDMZXL3m6jFaUs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788783952;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cNrJBRVqfDqJGfN/zCQUW6w8Y2kkMmeEAPhFE60Qg0Y=;
	b=TKi2DeEGfv7KJK3y278GPC+oW8+jTievRKgTVAe9+yjneRAzSfMmhojCUI2SWtcLDoCr2J
	O3VsRGduzlkCMjCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=S84etnik;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lVRTt0un
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788783948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cNrJBRVqfDqJGfN/zCQUW6w8Y2kkMmeEAPhFE60Qg0Y=;
	b=S84etnik9RIKeT4O8WF/T7OR7ajNuikKwB7r6gxahB5PgOTYzqlcX7WcnfQ8geTpMGyoIK
	4dlmkNGVEDA02KciJ08z0rvcEdpYsuvyij8ezlw7ozGUBms/rgkhKWXHh1dbU5p2Xh+Azi
	Ew689Pl+0ZEco56msVpoHyWrzghy7M8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788783948;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cNrJBRVqfDqJGfN/zCQUW6w8Y2kkMmeEAPhFE60Qg0Y=;
	b=lVRTt0unTK0+KiMUSCuZnYxfF+7na5qRFppSsv69MSO4xntPGj0a7VJhd3AETFFqQxNpPz
	tudJdzyHguEtJ5Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 20455138A5;
	Mon,  7 Sep 2026 12:25:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cFa8BkytnmpJLAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:25:48 +0000
Message-ID: <2c2cff23-97bf-4e19-8660-011414294d04@suse.de>
Date: Mon, 7 Sep 2026 14:25:47 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/40] scsi: sd: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-9-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 79137219B0
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the SCSI disk driver to use as much as possible the 16-bits
> sense_code field of struct scsi_sense_hdr and struct scsi_failure and
> replace all hard-coded additional sense codes and additional sense code
> qualifiers with the enum values defined in include/scsi/scsi_sense.h. This
> helps with code clarity as the sense codes being processed are easier to
> test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sd.c     | 106 +++++++++++++++++++++---------------------
>   drivers/scsi/sd_zbc.c |   2 +-
>   2 files changed, 53 insertions(+), 55 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
