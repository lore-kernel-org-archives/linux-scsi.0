Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9953793B8
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 11:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776943256; cv=none; b=qSPPagx6UYd4zoqJxwdzU0LK+h0m8rh0pMS/ANOQweoVV/ueQ4eMlmZmjZ/iqd0rpVtlYgLAJFHC9ApMf2D4QJ/d2Mkeu87nnGOv1Mw4qamUiL74ZJqvruGR3FbUvGP8j5R+SlrQyF6jDm8axSUs+ars45MK7xe0hZOiX0cGXTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776943256; c=relaxed/simple;
	bh=wdtDt0Zoy7gsW8T+KTUwLx/pZSQ5hjbQZtIJlEYc6+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ooRnzQesEN/VO8dtZ58c2tfOBYj6sSCbD88eBXkiE5/5RvgyPyRDh7TJ3lq8QQBq+jg6GvysojxeV+F888p4qrNqTNyll8nBXtTKiCuEqlzp/t4hDsr3I72MsKniK/DH1CNIIAtkq7uMZxeHXNyIaAfd43Gt4fJP3n40z3/ySXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jziyUc06; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/NDfWGPz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jziyUc06; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/NDfWGPz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jziyUc06";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/NDfWGPz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jziyUc06";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/NDfWGPz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0C0E85BD03;
	Thu, 23 Apr 2026 11:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776943253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ucIPHwRIq2/EbccRw0nTd8UVvGycCbpyiijSHMoguSc=;
	b=jziyUc06OPJ4fxaZa86kFWc9G8UtsCOBulwpizQOg1EL6Kui8HhrAukVzaYdJJ7XJqnHOZ
	we3Xnt8zxzLKJVUDv+3iQmF61mHDP4PSAxInurxRmWr33EvGiAzPTCfgO1EB3bYQAQMpq8
	FE2VHg4Y0iNxEcjUFe3C/ZuYM2Eubbg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776943253;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ucIPHwRIq2/EbccRw0nTd8UVvGycCbpyiijSHMoguSc=;
	b=/NDfWGPzlBW9vf1LD1xc4y7QhAq5UlDUOSz8hhMb8DAWpipA6DiuIsOQDezwIVMH6+mfPo
	j4dUS/OS9ewcuVBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776943253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ucIPHwRIq2/EbccRw0nTd8UVvGycCbpyiijSHMoguSc=;
	b=jziyUc06OPJ4fxaZa86kFWc9G8UtsCOBulwpizQOg1EL6Kui8HhrAukVzaYdJJ7XJqnHOZ
	we3Xnt8zxzLKJVUDv+3iQmF61mHDP4PSAxInurxRmWr33EvGiAzPTCfgO1EB3bYQAQMpq8
	FE2VHg4Y0iNxEcjUFe3C/ZuYM2Eubbg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776943253;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ucIPHwRIq2/EbccRw0nTd8UVvGycCbpyiijSHMoguSc=;
	b=/NDfWGPzlBW9vf1LD1xc4y7QhAq5UlDUOSz8hhMb8DAWpipA6DiuIsOQDezwIVMH6+mfPo
	j4dUS/OS9ewcuVBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D95A6593A3;
	Thu, 23 Apr 2026 11:20:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2BlsLpQA6mkMJwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 23 Apr 2026 11:20:52 +0000
Message-ID: <571ea193-7743-4464-a538-2a643fb039f5@suse.de>
Date: Thu, 23 Apr 2026 13:20:52 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN
 ATAPI device quirk
To: Phil Pemberton <philpem@philpem.me.uk>,
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260420122321.4161027-1-philpem@philpem.me.uk>
 <20260420122321.4161027-6-philpem@philpem.me.uk>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260420122321.4161027-6-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,philpem.me.uk:email]
X-Spam-Flag: NO

On 4/20/26 14:23, Phil Pemberton wrote:
> The COMPAQ PD-1 (OEM Panasonic/Matsushita LF-1195C) is a PD/CD combo
> drive that exposes two ATAPI LUNs: LUN 0 is a CD-ROM (TYPE_ROM),
> LUN 1 is a 650 MB PD (TYPE_DISK).
> 
> Add it to the SCSI device list with:
>    - BLIST_FORCELUN: tells the SCSI layer to scan past LUN 0
>    - BLIST_SINGLELUN: serialises commands across the two LUNs, since
>      the drive has a single transport and cannot handle concurrent
>      operations on both
> 
> The INQUIRY strings as reported by the device are:
>    Vendor:  "COMPAQ  " (T10 format, space-padded)
>    Product: "PD-1"
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>   drivers/scsi/scsi_devinfo.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index 68a992494b12..06b211b93567 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -150,6 +150,7 @@ static struct {
>   	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
>   	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
>   	{"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
> +	{"COMPAQ", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>   	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
>   	{"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
>   	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},

And as indicated, we should make the 'pdt_1f_for_no_lun' flag into a
blacklist flag, and set it from here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
