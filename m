Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B374C6F17
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 13:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778677945; cv=none; b=bfjxEQGGjXwlZLe3WRbhLF2O346H3g6YaFcXpV2cuTDRkfIeq6fQw+hVuoyKD9rAM8A8CYaOy1xD0hyBrxRBLBJtYsNFrjGe2ohJcNbKBZ6cN+sKFdAat2Ys1oMFXz9+e2vHNuq7OGqidPBd4sL/fbZcKnGQtO9l92RO1nHGq+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778677945; c=relaxed/simple;
	bh=mKslkkPNFADSA80b85jkPLf4uRMlTJwe9KeE4Lx2IeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hVWTdEUQfN8jL6xSSfTIiYO15qiwvmNWofm5KhfBqKjUT+K0JE7iUgmmknrp0gQAHhD5of7mDsq7C/XvmsXSOSKbwiEdCAcyqWFTiCiYLcdNdiUDa/0g8V4i4re2wyeW2MyHfoZWm1uSvfuMeh6PBPwYQzyoM8V397M8R38fVQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CBT7nYFD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xS7BT05R; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CBT7nYFD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xS7BT05R; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CBT7nYFD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xS7BT05R";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CBT7nYFD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xS7BT05R"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 72DB775AD1;
	Wed, 13 May 2026 13:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778677942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ctFmtGzWh59JzxP4JQBACBn8erEAkWyV6YditMA6vsY=;
	b=CBT7nYFDs0htpIPnSfcZeT+F/qdkcVXNEcXM8cZABpXUqtWhqIsqKKq18YikYXeM/YIKM/
	34+weytkrarLC2Vz07vhegjOG8QdHkzQci7NmWvnaM8TcvJMMQA03eCNFgjnMl8A5dUZGv
	kj6UeU9Hbi+HM5Yz3Ee0H+AJf1QTIw4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778677942;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ctFmtGzWh59JzxP4JQBACBn8erEAkWyV6YditMA6vsY=;
	b=xS7BT05Ri8ZRGZHmaRv1MM7/lE+JFOQGtZ7Y76dnNn0pLKeRD4Lmf1o4S5O9SU0ahwZK1W
	W+w2EmbIbjjOXECg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CBT7nYFD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xS7BT05R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778677942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ctFmtGzWh59JzxP4JQBACBn8erEAkWyV6YditMA6vsY=;
	b=CBT7nYFDs0htpIPnSfcZeT+F/qdkcVXNEcXM8cZABpXUqtWhqIsqKKq18YikYXeM/YIKM/
	34+weytkrarLC2Vz07vhegjOG8QdHkzQci7NmWvnaM8TcvJMMQA03eCNFgjnMl8A5dUZGv
	kj6UeU9Hbi+HM5Yz3Ee0H+AJf1QTIw4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778677942;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ctFmtGzWh59JzxP4JQBACBn8erEAkWyV6YditMA6vsY=;
	b=xS7BT05Ri8ZRGZHmaRv1MM7/lE+JFOQGtZ7Y76dnNn0pLKeRD4Lmf1o4S5O9SU0ahwZK1W
	W+w2EmbIbjjOXECg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 47AB8593A9;
	Wed, 13 May 2026 13:12:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UJPJELZ4BGo5TQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 13 May 2026 13:12:22 +0000
Message-ID: <48f1b7b5-73ca-4b58-bd59-5e786fba7031@suse.de>
Date: Wed, 13 May 2026 15:12:21 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/6] ata: libata-scsi: probe additional LUNs for
 multi-LUN ATAPI devices
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260512202728.299414-1-philpem@philpem.me.uk>
 <20260512202728.299414-6-philpem@philpem.me.uk>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260512202728.299414-6-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[philpem.me.uk:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim,suse.de:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 72DB775AD1
X-Spam-Level: 

On 5/12/26 22:27, Phil Pemberton wrote:
> After LUN 0 is added for an ATAPI device, check its BLIST_FORCELUN
> flag.  If set, bump dev->nr_luns to the host's max_lun so the LUN
> routing in atapi_xlat() accepts the probe INQUIRYs, then call
> scsi_scan_target() with SCAN_WILD_CARD to trigger the SCSI layer's
> built-in sequential LUN scan for that target only.  This probes
> LUNs 1..shost->max_lun, driven by the libata atapi_max_lun module
> parameter.
> 
> Devices without BLIST_FORCELUN (the vast majority of ATAPI devices)
> are left with only LUN 0 -- no sequential scan is triggered, so
> single-LUN devices like the iHAS124 DVD writer are completely
> unaffected.
> 
> Non-responding LUNs (PQ=0/PDT=0x1f) are silently skipped by
> scsi_probe_and_add_lun() when BLIST_NO_LUN_1F is set on the device
> via scsi_devinfo.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>   drivers/ata/libata-scsi.c | 27 +++++++++++++++++++++++----
>   1 file changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 2d714efc855f..a6f5557014c7 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -26,6 +26,7 @@
>   #include <scsi/scsi_device.h>
>   #include <scsi/scsi_tcq.h>
>   #include <scsi/scsi_transport.h>
> +#include <scsi/scsi_devinfo.h>
>   #include <linux/libata.h>
>   #include <linux/hdreg.h>
>   #include <linux/uaccess.h>
> @@ -4745,12 +4746,30 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>   			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
>   						 NULL);
>   			if (!IS_ERR(sdev)) {
> -				dev->sdev[0] = sdev;
> -				ata_scsi_assign_ofnode(dev, ap);
> +				/*
> +				 * For multi-LUN ATAPI (BLIST_FORCELUN), bump
> +				 * dev->nr_luns to the host max so the LUN
> +				 * routing in atapi_xlat() accepts the probe
> +				 * INQUIRYs to LUN > 0, then trigger the
> +				 * sequential scan.  pdt_1f_for_no_lun, set
> +				 * during LUN 0 configure, ensures
> +				 * non-responding LUNs are silently skipped;
> +				 * dev->sdev[] is populated by
> +				 * ata_scsi_dev_config() during the scan.
> +				 */
> +				if (dev->class == ATA_DEV_ATAPI &&
> +				    sdev->sdev_bflags & BLIST_FORCELUN) {
> +					dev->nr_luns = ap->scsi_host->max_lun;
> +					scsi_scan_target(
> +						&ap->scsi_host->shost_gendev,
> +						channel, id, SCAN_WILD_CARD,
> +						SCSI_SCAN_RESCAN);
> +				}

Again, nr_luns is not required here.
We only need to check that host->max_lun does not exceed ATAPI_MAX_LUN.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
