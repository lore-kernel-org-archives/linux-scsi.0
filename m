Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B754CA292;
	Mon,  7 Sep 2026 12:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788785245; cv=none; b=mMUcLkOzyitMoBag6V6qfJck22jrEFwT4tXOK7YzwsZbNuHLIMvNrWxfR7y96O4BZSIeD7AgCWKqiKmtXkPF6/cN9O+kaXQAJQK/CRLX8aU1Iko7FYrJkkpbRP+ia6903A6g/kh6C9d02h9YpjAtjUe4yfP4IBM415KloptfdFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788785245; c=relaxed/simple;
	bh=kWvJEA8gEVtI6cCXmrs5j8pkDJF+kU888izjP/fuIg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mOh3Zxxu7X7hBdnFVphL91w17XTHTZRCg1f3sGfohN3WMdSu2pZkLiGC7cgPx6D/fPSVUucs8/TWOxmNesPgLl4JXBLTa04ooa0yVmyOunXSHSHwB6T+MzYstgKCx8YEbE+xT4jSjQm1wLoUKgwgkjkWu2bq0D1+9rF1/qttvhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MoY0jCXl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=96IywHDg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xd4WgWnG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QOxCF0Ag; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MoY0jCXl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="96IywHDg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xd4WgWnG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QOxCF0Ag"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3701C1F79C;
	Mon,  7 Sep 2026 12:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788785238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MT+EdZqmpxS03n0Yp8lyfPsrvdzhSvUi6jS4lwSpJ6I=;
	b=MoY0jCXl6kfDEIMnKg/UmD+MPtLcVDZ4GqFfYMD7cyHipaSuUpWI0rPFTFE/oUUfWmTyJv
	OaxNX8tnk704NuumMCc9o3CKPIcDSE4gmhnh+pi2pPOJsvH958D73sB/osfiUYeQ2xxAo0
	0Gevy6ENq62N7LC1QP+nrDKBrc7TDds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788785238;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MT+EdZqmpxS03n0Yp8lyfPsrvdzhSvUi6jS4lwSpJ6I=;
	b=96IywHDgRtSJ7MsDcgWns0TvTODqjCsyfq7QUNTR2qHtKV/y7sP5S10apy2hV6bszFqwbh
	2vAfDr9QtvCjB5Bw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xd4WgWnG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QOxCF0Ag
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788785234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MT+EdZqmpxS03n0Yp8lyfPsrvdzhSvUi6jS4lwSpJ6I=;
	b=xd4WgWnGA3pfS5gjEajuK9Bk45tK+ONEFR0MtXoqKR3uk7uh8llhwcqOGfGmHuaiCdYLNn
	jMAH9cTnNEyNjy/hYccGBOynO80uGc+DhQx5UreQ84nfl9Kub5g7Rd8z7vFdnY12pdIphN
	81jqo4orNMPk/VSQpVWcY3Hr5nJ1mr0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788785234;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MT+EdZqmpxS03n0Yp8lyfPsrvdzhSvUi6jS4lwSpJ6I=;
	b=QOxCF0AgN5HgP37ZmJ5Ci9EgeaBr3E7BpJqNSUkdzw0cS77MNxltdUR7W2uZnFM67T4CgH
	nUTCkaGI3Pd4r/Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB4E31339B;
	Mon,  7 Sep 2026 12:47:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QEh0MFGynmppQQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:47:13 +0000
Message-ID: <39bede42-0b1c-401c-9a95-2a8f375f3811@suse.de>
Date: Mon, 7 Sep 2026 14:47:13 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 31/40] scsi: scsi_debug: use 16-bits defined sense
 codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-32-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-32-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3701C1F79C
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the scsi_debug driver to replace hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> The functions mk_sense_buffer() and mk_sense_info_tape() are modified to
> take a 16-bits sense code as argument.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/scsi_debug.c | 332 ++++++++++++++++++++------------------
>   1 file changed, 171 insertions(+), 161 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
