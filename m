Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B37F22A4FC
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 06:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776319493; cv=none; b=jE5Zd+1XD8ZBVonJxBAavNT4IhzN6zyxjJ+/22Dw+orViXNHPDpxyehFTw/21LSlHdlHh9rQ538u2aZt1ylSUs6KKh6Hsqm7KUcGdXnMLEgIoLR9GoARYggHjs1XXhlVnKZxeGuKpsaaKyveG1dtG2cvllaH6Khs3OuCkU6UQAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776319493; c=relaxed/simple;
	bh=7I2DA2Eab2ddMH3PcHUCXA2zDBiCauCjDCXRmJWp52s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KuneFrZ1LWQxgI2NdXiqKGtvfJYHIwwWsbcIv0qxKdfX+tUfyx0Q5oDqM5vQhVPzXwCUE0gTbCjo/5rDpCLxlF/nTFdlTzaAsxOi0jBHrFdVIsn//xJxSx4EYwCZ0B3ermwfuhSi/Ai/q3i5oiJw4gkfTF4ete58qlLfQsRrIlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZD4WxGK3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mzsuE5+J; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZD4WxGK3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mzsuE5+J; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZD4WxGK3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mzsuE5+J";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZD4WxGK3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mzsuE5+J"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2B9C65BD17;
	Thu, 16 Apr 2026 06:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776319490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+qb8NQgnDh+q1/Co+UvEVKUE25skzGMNuS1QcMLVfjY=;
	b=ZD4WxGK3ZdqrkT2FlIA9AgsTD7jMOnXlUu3WysnnBLf9zMzGnHF1ypoH3pZOp0lWx8lbJx
	cjcSwEyrxleJOTFai9tAOj5ZPASv3z4nBGY9Lb3tN7siaXici+//rUSuNHy9Poh2vZZbvq
	vmr5WZWwu0wwWxAFjDHEuFpCIS7QloA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776319490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+qb8NQgnDh+q1/Co+UvEVKUE25skzGMNuS1QcMLVfjY=;
	b=mzsuE5+JTj0dU3gpZVnQtT6ymOnUzHbrusTRd3V1GW7ZrDqqaspm+6O93zA0g0rRIv127V
	xi9FrHyniUDzf/AQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776319490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+qb8NQgnDh+q1/Co+UvEVKUE25skzGMNuS1QcMLVfjY=;
	b=ZD4WxGK3ZdqrkT2FlIA9AgsTD7jMOnXlUu3WysnnBLf9zMzGnHF1ypoH3pZOp0lWx8lbJx
	cjcSwEyrxleJOTFai9tAOj5ZPASv3z4nBGY9Lb3tN7siaXici+//rUSuNHy9Poh2vZZbvq
	vmr5WZWwu0wwWxAFjDHEuFpCIS7QloA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776319490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+qb8NQgnDh+q1/Co+UvEVKUE25skzGMNuS1QcMLVfjY=;
	b=mzsuE5+JTj0dU3gpZVnQtT6ymOnUzHbrusTRd3V1GW7ZrDqqaspm+6O93zA0g0rRIv127V
	xi9FrHyniUDzf/AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A2FEE4BDEB;
	Thu, 16 Apr 2026 06:04:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id umxcJgF84Gl8HgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 16 Apr 2026 06:04:49 +0000
Message-ID: <e8843bfe-b4cb-4639-977e-a278f4578887@suse.de>
Date: Thu, 16 Apr 2026 08:04:49 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: sas_user_scan: use scan_start if available
To: Martin Wilck <martin.wilck@suse.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microchip.com>
Cc: linux-scsi@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
 Martin Wilck <mwilck@suse.com>, storagedev@microchip.com,
 Ranjan Kumar <ranjan.kumar@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>, mpi3mr-linuxdrv.pdl@broadcom.com,
 MPT-FusionLinux.pdl@broadcom.com, Yihang Li <liyihang9@h-partners.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, John Garry <john.g.garry@oracle.com>
References: <20260415204850.799431-1-mwilck@suse.com>
 <20260415204850.799431-3-mwilck@suse.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260415204850.799431-3-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,broadcom.com:email,suse.com:email,suse.de:mid,suse.de:email,oracle.com:email,microchip.com:email,h-partners.com:email,ionos.com:email]
X-Spam-Flag: NO

On 4/15/26 22:48, Martin Wilck wrote:
> Since 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and
> multi-channel scans"), a wildcard scan on a SAS host scans all channels.
> This can cause excessive resource usage and even system freeze with
> some controllers, e.g. smartpqi. smartpqi and other drivers provide
> the scan_start() and scan_finished() methods to scan devices
> efficiently. Instead of blindly scanning every device, use these
> methods to do the wildcard scan when available.
> 
> Fixes: 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Cc: Don Brace <don.brace@microchip.com>
> Cc: storagedev@microchip.com
> Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
> Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> Cc: mpi3mr-linuxdrv.pdl@broadcom.com
> Cc: MPT-FusionLinux.pdl@broadcom.com
> Cc: Yihang Li <liyihang9@h-partners.com>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Cc: John Garry <john.g.garry@oracle.com>
> 
> ----
> This patch has been tested successfully with smartpqi, but it would
> affect other drivers that provide scan_start(), and we don't have
> hardware to test them all. Affected drivers are aic94xx, hisi_sas,
> hpsa, isci, mpi3mr, mpt3sas, mvsas, pm8001, and smartpqi.
> I cc'd the maintainers of these drivers above.
> ---
>   drivers/scsi/scsi_transport_sas.c | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 1341270..2231609d 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -31,6 +31,7 @@
>   #include <linux/string.h>
>   #include <linux/blkdev.h>
>   #include <linux/bsg.h>
> +#include <linux/delay.h>
>   
>   #include <scsi/scsi.h>
>   #include <scsi/scsi_cmnd.h>
> @@ -1702,6 +1703,26 @@ static void scan_channel_zero(struct Scsi_Host *shost, uint id, u64 lun)
>   	}
>   }
>   
> +/*
> + * For wildcard scans on hosts that provide a scan_start method,
> + * use that instead of blindly scanning everything.
> + */
> +static int sas_user_scan_with_scan_start(struct Scsi_Host *shost)
> +{
> +	unsigned long start;
> +
> +	if (!shost->hostt->scan_finished || !shost->hostt->scan_start)
> +		return 1;
> +
Technically 'scan_start' is optional (cf do_scsi_scan_host()), so it
would be better to just check for 'scan_finished'.

> +	start = jiffies;
> +	shost->hostt->scan_start(shost);
> +
> +	while (!shost->hostt->scan_finished(shost, jiffies - start))
> +		msleep(10);
> +
> +	return 0;
> +}
> +
>   /*
>    * SCSI scan helper
>    */
> @@ -1721,6 +1742,11 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
>   		break;
>   
>   	case SCAN_WILD_CARD:
> +
> +		if (id == SCAN_WILD_CARD && lun == SCAN_WILD_CARD
> +			&& !sas_user_scan_with_scan_start(shost))
> +			return 0;
> +
>   		mutex_lock(&sas_host->lock);
>   		scan_channel_zero(shost, id, lun);
>   		mutex_unlock(&sas_host->lock);

Wouldn't it be better to export do_scsi_scan_host() and call it
here, seeing that it's doing exactly the same thing?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
