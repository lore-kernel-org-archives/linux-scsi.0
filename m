Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDEA472535;
	Mon,  7 Sep 2026 13:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788787199; cv=none; b=tYK86S/gKo9uLwd59WO3EpbAow88SiDHtop1lZPMR95ou1Bj2NNIiMfY2d2zYYXeXf/uA3IdVHjh2lnI0v+UUlgbdq9o/r4Rcl6U2umnMgRAdV6RBjkbWuI8V/9bwrEi1XtLUCQRvhdQETVPooqDbbXAcpAEQ+wq8w+IfHv+xCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788787199; c=relaxed/simple;
	bh=SlFCni4I01Cmwg78dJI+XGaA52eRZeI6Ui40RA/G3Lk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ucCUFEfSwy8L0VEo24xnTLSlmM9vcC4Hr5Z2u6xjpPbtebUrZ+F/26Aecywli+iYrIqy7xx9mGDRzvGlzSKiDD9AXszu9QFdkHHqa4OahAnNHUwn602/oqT0vh/rLlGmeH35XW8Cqk+vzRP+eNHTKYYFwBjhVcrAYikdm723hNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kHtjEv6N; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RKrGlu+d; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qfFBBZkE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YBkMTHG7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kHtjEv6N";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RKrGlu+d";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qfFBBZkE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YBkMTHG7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9AA141F456;
	Mon,  7 Sep 2026 13:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788787186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q3zWCVsnyA/6EJNsPKC08hk7u9t3pPNWsKQveMU1JMY=;
	b=kHtjEv6NCWyewxf4l/GmYndmvkdAeH6+jr76jlvV88uDXgzAkFCQI7sGFsR10z+opwd/MG
	Jx4r2xmisdsIKRVdXdMTG4rmMXcsVKyDrXbJ9t39NiU6hbUJAlav3RDvYu4Pexr4YZWXav
	DB4wwfYdgQHcdC8sna7ZNQyYUWhQPBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788787186;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q3zWCVsnyA/6EJNsPKC08hk7u9t3pPNWsKQveMU1JMY=;
	b=RKrGlu+d93JmXifoXhHZp7HLA+QBPqxXK5mTuGgJP+qDE0ENKJmDv7l+sM9/7wiK6c/yWf
	cSOQ1/toEncbJpAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qfFBBZkE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YBkMTHG7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788787182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q3zWCVsnyA/6EJNsPKC08hk7u9t3pPNWsKQveMU1JMY=;
	b=qfFBBZkEZ4Wlj7GHqTGTVgDuVk/j6HPBgGI9zKxnH28oYow2IpfYh/VT7d6ayMKInKyh/p
	+YEyqrvRzRJH0DKNTQdpg7XDNwggEyaj3pbHATXYiFolCLynKvPG1+APwDnSwx3wzYOJ5o
	/jf0BcW35ttWCLHMM0Y+fwoz/0XQo70=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788787182;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q3zWCVsnyA/6EJNsPKC08hk7u9t3pPNWsKQveMU1JMY=;
	b=YBkMTHG7N2+Pyf2Kb7bNqmL8y26uVId2RGJUO9rLwHVpMmWFWU1gAwpBQem05ky9ukexJh
	/JvXs93ish70VaDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D06713432;
	Mon,  7 Sep 2026 13:19:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id toCtEe65nmqiYQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 13:19:42 +0000
Message-ID: <dd80710b-c942-4412-8631-1b97d752f786@suse.de>
Date: Mon, 7 Sep 2026 15:19:41 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 37/40] ata: libata: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-38-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-38-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9AA141F456
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor libata core code to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-eh.c   |  13 +-
>   drivers/ata/libata-sata.c |  20 +--
>   drivers/ata/libata-scsi.c | 346 +++++++++++++++++++++++---------------
>   drivers/ata/libata.h      |   5 +-
>   4 files changed, 229 insertions(+), 155 deletions(-)
> 
Finally :-)

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
