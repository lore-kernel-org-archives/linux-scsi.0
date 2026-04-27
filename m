Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB21318BB5
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 11:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777290937; cv=none; b=riwUVb99qMbVr37OCAwobz5eC3jY45Z9Oist/LUndANXQtkj3gfCI1VdeP/IflRM/BtlKCNRosQAxzO7cdhUcCFj7c9SL73a99KIYGGHPic9BxgqZh3J9yHA9yJsvszpnQP3z6a9csgwYKNf5K1XQhNhhh3ZOYq8B1RPU56E3Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777290937; c=relaxed/simple;
	bh=ZP1c4ky3bJXIySKuxipX8ApHDQjQJNDazRF+acMyh4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VOiy3SqHc99mY3/XbazJpgav1kiVWoHScFj8Ji3d15zpAluFgphDdTOf54eLI3FooTz4Xy+7K58IUDURdhWA7N5NUvu6Bh82/0A3s/hEjcF8UkrCZTZ/P4vn9MfhZYm2Oxw9R9cUJH9EFYSWyekjpaAOf6shmQc9M3cG/xxfBwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oWSX+b78; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Z5Zzr6DW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P7S/VOVi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VfeGtbjJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oWSX+b78";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Z5Zzr6DW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="P7S/VOVi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VfeGtbjJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5FE255BCCD;
	Mon, 27 Apr 2026 11:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777290933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=swr+kJLdakYoARhnjNVMQ6vKSx0E0Hlgsx2lgeP1Otc=;
	b=oWSX+b78+HEIpN6yCZye893zAB9kg7JV5hrze71qgcP6vju/yNrU1c45pdQhVrdT+CyYKb
	tviy/2iXsDU8JCOdSYMQVrzzIFvV10ltQ8oTnH0JRvXjtSC7HCvNUnRrX+eUafMiUlG8ir
	xyM/YQo0YD3sT0mTTjtUzdrz3r/qEhY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777290933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=swr+kJLdakYoARhnjNVMQ6vKSx0E0Hlgsx2lgeP1Otc=;
	b=Z5Zzr6DWpOCc5MtaDCGh39Kv92c2lTxzi12MoqIpm08SzwElDiLCbQE9aY9eHqO4a4wgig
	jK4BjuAKll9hfwDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777290932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=swr+kJLdakYoARhnjNVMQ6vKSx0E0Hlgsx2lgeP1Otc=;
	b=P7S/VOViO8pKDSQUDThC5S/zA6VgIlxpQsgIJxI43XCvoFcI0FWvVrrplIMhEkAjxRy+wH
	1E5mpv6ceFeqff1sUpeVG51xuSlR7BKrkQ+/30mgsqrJ6ysTcsXEsRViT6viaQ0qytER3+
	BxpCp0lcu0KV13lLnNYCNTceScshhsc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777290932;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=swr+kJLdakYoARhnjNVMQ6vKSx0E0Hlgsx2lgeP1Otc=;
	b=VfeGtbjJ1hXtZoFZ1I85gIvtRtIiifVH0UyMTKjphfRRgS9oMB0hpK9/assKJfzsWVKTur
	NLY+B8xWiJmMcdCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4768E593B0;
	Mon, 27 Apr 2026 11:55:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BCe5ELRO72nedQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 27 Apr 2026 11:55:32 +0000
Message-ID: <db7414db-ac82-4cf0-a86c-ab54950137ae@suse.de>
Date: Mon, 27 Apr 2026 13:55:31 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN
 ATAPI device quirk
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260426190920.2051289-1-philpem@philpem.me.uk>
 <20260426190920.2051289-7-philpem@philpem.me.uk>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260426190920.2051289-7-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email,philpem.me.uk:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 4/26/26 21:09, Phil Pemberton wrote:
> The COMPAQ PD-1 (OEM Panasonic/Matsushita LF-1195C) is a PD/CD combo
> drive that exposes two ATAPI LUNs: LUN 0 is a CD-ROM (TYPE_ROM),
> LUN 1 is a 650 MB PD (TYPE_DISK).
> 
> Add it to the SCSI device list with:
>    - BLIST_FORCELUN: tells the SCSI layer to scan past LUN 0
>    - BLIST_SINGLELUN: serialises commands across the two LUNs, since
>      the drive has a single transport and cannot handle concurrent
>      operations on both
>    - BLIST_NO_LUN_1F: the drive returns PQ=0/PDT=0x1f for unpopulated
>      LUNs instead of PQ=3; this flag tells scsi_probe_and_add_lun()
>      to silently skip them
> 
> The INQUIRY strings as reported by the device are:
>    Vendor:  "COMPAQ  " (T10 format, space-padded)
>    Product: "PD-1"
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>   drivers/scsi/scsi_devinfo.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index 68a992494b12..bfc2cbd43897 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -150,6 +150,8 @@ static struct {
>   	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
>   	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
>   	{"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
> +	{"COMPAQ", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN |
> +				 BLIST_NO_LUN_1F},
>   	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
>   	{"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
>   	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
