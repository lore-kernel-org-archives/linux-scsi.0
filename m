Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ECF37BE81
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 11:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776942954; cv=none; b=opFxNc5AsiUh+MZpSUNo/8QA2OXx5fO2zEZqtkjYOUftFVRql7OL5fpNbDhAPOFDNqyMh3SJqQIzz0CDvPNCPn7Z157NHIUB8NlDeUHt0nqNg7YIyLbjqWcD9xGXX2kUcqCHLF5gkpQYkHUNq+5IRpbDp4WSqkoAPJvHc4n1Ltw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776942954; c=relaxed/simple;
	bh=DznzqFC9T50WL71Vnb83dD9fbVWPkIkgwBiGPZfEFtY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AEi9Ah6ua3awdEY5H85HHQXSdrRrD8yyt3yvnSUdBK/DTe4A6E0JmdjOgChcV1blcuaqW90qJSDZU7rGiya0yfeY3X9P6ORVUOcOzxA7eDZzJFC0NxJZ9ZbSqOhho8zylcAEEwxap7//7GS7aes+rhdW89UzkyoqLM7oF7rXK9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lt7eWV9R; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Hd+Cq6wA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lt7eWV9R; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Hd+Cq6wA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lt7eWV9R";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Hd+Cq6wA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lt7eWV9R";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Hd+Cq6wA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 08AA16A869;
	Thu, 23 Apr 2026 11:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776942951; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nOnUrea+ERQfv3b1N4rR1jJJE1d3MIbsSDg9LYsXyiU=;
	b=lt7eWV9RvB9kzof0OORjow1JOhz/mM6TiqLcWitJSit8yHR8LhmfnrdqS1hyC7h6Dx0UaN
	/NIURF84JHiZGDelJ7H6IFWyyLRJXnpj1uKAvpdRCTQ+ItUBWUmd89zjyyeXlfPQHX+wdq
	O4zqjvO7iIrK4vXO8XARdqmO1kQOSII=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776942951;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nOnUrea+ERQfv3b1N4rR1jJJE1d3MIbsSDg9LYsXyiU=;
	b=Hd+Cq6wA0dcwr5OGFKXCetWGWM/eII8Cgvk3qL4zHyN+iWmW5fATcyq5DRElWwrZfTVmpc
	Ugw1P59b2iivXXDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lt7eWV9R;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Hd+Cq6wA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776942951; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nOnUrea+ERQfv3b1N4rR1jJJE1d3MIbsSDg9LYsXyiU=;
	b=lt7eWV9RvB9kzof0OORjow1JOhz/mM6TiqLcWitJSit8yHR8LhmfnrdqS1hyC7h6Dx0UaN
	/NIURF84JHiZGDelJ7H6IFWyyLRJXnpj1uKAvpdRCTQ+ItUBWUmd89zjyyeXlfPQHX+wdq
	O4zqjvO7iIrK4vXO8XARdqmO1kQOSII=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776942951;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nOnUrea+ERQfv3b1N4rR1jJJE1d3MIbsSDg9LYsXyiU=;
	b=Hd+Cq6wA0dcwr5OGFKXCetWGWM/eII8Cgvk3qL4zHyN+iWmW5fATcyq5DRElWwrZfTVmpc
	Ugw1P59b2iivXXDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5E35593A3;
	Thu, 23 Apr 2026 11:15:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Gm6ON2b/6WloIgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 23 Apr 2026 11:15:50 +0000
Message-ID: <7d7d368b-2660-42f4-8109-63d62239fcc7@suse.de>
Date: Thu, 23 Apr 2026 13:15:50 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] ata: libata-scsi: probe additional LUNs for
 multi-LUN ATAPI devices
To: Phil Pemberton <philpem@philpem.me.uk>,
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260420122321.4161027-1-philpem@philpem.me.uk>
 <20260420122321.4161027-5-philpem@philpem.me.uk>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260420122321.4161027-5-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[philpem.me.uk:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,suse.de:email]
X-Rspamd-Queue-Id: 08AA16A869
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 4/20/26 14:23, Phil Pemberton wrote:
> After LUN 0 is added for an ATAPI device, check its BLIST_FORCELUN
> flag.  If set, call scsi_scan_target() with SCAN_WILD_CARD to trigger
> the SCSI layer's built-in sequential LUN scan for that target only.
> This probes LUNs 1..shost->max_lun, driven by the atapi_max_lun module
> parameter from patch 1/5.  Devices without BLIST_FORCELUN (the vast
> majority of ATAPI devices) are left with only LUN 0 — no sequential
> scan is triggered, so single-LUN devices like the iHAS124 DVD writer
> are completely unaffected.
> 
> To suppress spurious "No Device" log entries from non-responding LUNs
> (e.g. LUN 2+ on a two-LUN PD/CD drive), set pdt_1f_for_no_lun on the
> scsi_target during LUN 0 configuration.  The Panasonic PD-1 returns
> PQ=0/PDT=0x1f for unpopulated LUNs rather than the standard PQ=3;
> with this flag, scsi_probe_and_add_lun() silently skips them.
> 
> If BLIST_FORCELUN is set but atapi_max_lun is still at its default of
> 1, an informational message points the user at the module parameter so
> the knob is discoverable from dmesg.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>   drivers/ata/libata-scsi.c | 53 ++++++++++++++++++++++++++++++++-------
>   1 file changed, 44 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 4e88ae7d94c3..9d18ef2835a5 100644
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
> @@ -1132,6 +1133,22 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
>   		sdev->security_supported = 1;
>   
>   	dev->sdev[sdev->lun] = sdev;
> +
> +	/*
> +	 * Tell the SCSI scan layer that PDT 0x1f with PQ 0 means "no LUN
> +	 * present" for this target.  The Panasonic PD-1 (and likely other
> +	 * multi-LUN ATAPI devices) returns PQ=0/PDT=0x1f for unpopulated
> +	 * LUNs instead of the standard PQ=3.  Setting this flag lets the
> +	 * sequential LUN scan skip those LUNs cleanly.
> +	 */

But this would hard-code device-specifics in the generic code.

> +	if (dev->class == ATA_DEV_ATAPI && sdev->lun == 0) {
> +		sdev->sdev_target->pdt_1f_for_no_lun = 1;

Don't. That should be done with blacklist flags for specific devices.

> +
> +		if ((sdev->sdev_bflags & BLIST_FORCELUN) && atapi_max_lun < 2)
> +			ata_dev_info(dev,
> +				"device has additional LUNs; set libata.atapi_max_lun=2 or higher to access them\n");

Huh? How do you know? The device _might_ have additional luns, but
here we just probed for LUN 0, giving no indication whether other
LUNs are present.

And you already know which devices are affected (as the blacklist flags
should make that clear).
So I don't think we need that warning.

> +	}
> +
>   	return 0;
>   }
>   
> @@ -4700,7 +4717,6 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>    repeat:
>   	ata_for_each_link(link, ap, EDGE) {
>   		ata_for_each_dev(dev, link, ENABLED) {
> -			struct scsi_device *sdev;
>   			int channel = 0, id = 0;
>   
>   			if (dev->sdev[0])
> @@ -4711,15 +4727,34 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>   			else
>   				channel = link->pmp;
>   
> -			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
> -						 NULL);
> -			if (!IS_ERR(sdev)) {
> -				dev->sdev[0] = sdev;
> -				ata_scsi_assign_ofnode(dev, ap);
> -				scsi_device_put(sdev);
> -			} else {
> -				dev->sdev[0] = NULL;
> +			{
> +				struct scsi_device *sdev;
> +
> +				sdev = __scsi_add_device(ap->scsi_host,
> +							 channel, id, 0, NULL);
> +				if (!IS_ERR(sdev)) {
> +					/*
> +					 * For multi-LUN ATAPI (BLIST_FORCELUN),
> +					 * trigger the sequential LUN scan.
> +					 * pdt_1f_for_no_lun (set during LUN 0
> +					 * configure) ensures non-responding LUNs
> +					 * are silently skipped.  dev->sdev[] is
> +					 * populated by ata_scsi_dev_config()
> +					 * during the scan callbacks.
> +					 */
> +					if (dev->class == ATA_DEV_ATAPI &&
> +					    sdev->sdev_bflags & BLIST_FORCELUN)
> +						scsi_scan_target(
> +							&ap->scsi_host->shost_gendev,
> +							channel, id,
> +							SCAN_WILD_CARD,
> +							SCSI_SCAN_RESCAN);
> +					scsi_device_put(sdev);
> +				}
>   			}
> +
> +			if (dev->sdev[0])
> +				ata_scsi_assign_ofnode(dev, ap);
>   		}
>   	}
>   

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
