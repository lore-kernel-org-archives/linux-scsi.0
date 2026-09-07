Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39419493638;
	Mon,  7 Sep 2026 12:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784166; cv=none; b=FApLOZfa4Fp6u+zs2v6wMpzOkUisxD4J7KDGTjL7HYyPr+AwZpueAnDL6SbO8vABuvI1r+idJB4o6OOVkADGZTjt5H+1sscih1D75Czsvb764ThffsY9rvuerJa2D0Bvrny+kNDXPo99D3wxmJdsTzCcnl/DUwah1VgSdSPAtvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784166; c=relaxed/simple;
	bh=6JivA/e3EBXwh5+jh3gzSwKsSoH/jBu/VTqCLr9VgZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=d4bO2b77sin3YOkasS279JgzkwnqmLOXYQTwuv4zspxIHUgrWJYBPnxXNCMRGh8XTDW++FGn2IyU+y9s0vSNU+jKuZr3T7I6MqnTr1eooo1AXLuU5RV/PitvDDGQvxySOBEljXdfX0QCq3QApgb8Pc6aj1oDISka2qSipmemegw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qz1dqfZb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iv5XHP70; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RT7sKhDv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rIyM49Y5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qz1dqfZb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iv5XHP70";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RT7sKhDv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rIyM49Y5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C3F1E1F785;
	Mon,  7 Sep 2026 12:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JBlHdQi5CB/C9agDYNVtypQvveft3Ytmn+fH/Q8XNg4=;
	b=qz1dqfZbnG14EkZD+HFRJ1SbNaC5/8hsdcaufN3xvaDoIrVGHCv7znXKcBYAQVk0ORknCm
	M/OWstppAZ/u5XWpNAJcNwpfPJXA4/VVzxOE0GMxEkxZtnrC6NaFYwTICoTDvLNqesy+KI
	dxaNm+2nJvSV1a/Iq52P8v1R8O8Yj1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JBlHdQi5CB/C9agDYNVtypQvveft3Ytmn+fH/Q8XNg4=;
	b=iv5XHP70ZqCcZROVgqyTnvjh/hobCMT7Re+Z2ohp854UH3njncT4Wve/jZlW0WRYP9ula2
	PpcgIHKacP/WBXAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RT7sKhDv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rIyM49Y5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JBlHdQi5CB/C9agDYNVtypQvveft3Ytmn+fH/Q8XNg4=;
	b=RT7sKhDvnbsZkgu1C+n+QSDRvSMfy4Z5UXVsLZPsGtLgyVyvsDgFIZkLgp1hDDllmsGLj5
	uq8uLgjmT6NaTow6QxmDrypzOeewyM5zCGdvwJLnNDhWMDcZuax0403pT1PYtqd7d8mGGf
	NOAGPPJCQisgy7GM7Dr0exjB2ynOj9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784150;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JBlHdQi5CB/C9agDYNVtypQvveft3Ytmn+fH/Q8XNg4=;
	b=rIyM49Y5EPNN58oR96TbXb0ZEZCdLQPYgZXfeYQuBI6EfQRO/5tpqbnGF72bYkglQQ5LQz
	F6tdH122CYNt6CAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6BB9F1368D;
	Mon,  7 Sep 2026 12:29:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uGQ8GRaunmpDLwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:29:10 +0000
Message-ID: <86f1ebfa-ca44-4dc6-a484-4fc87d99e8a6@suse.de>
Date: Mon, 7 Sep 2026 14:29:09 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/40] scsi: device_handlers: alua: use 16-bits defined
 sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-17-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-17-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C3F1E1F785
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the SCSI ALUA devie handler driver to use the 16-bits sense_code
> field of struct scsi_sense_hdr and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/device_handler/scsi_dh_alua.c | 55 ++++++++--------------
>   1 file changed, 19 insertions(+), 36 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
