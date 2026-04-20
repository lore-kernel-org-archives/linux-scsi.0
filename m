Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817F3352F88
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 10:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776681317; cv=none; b=aYViNo2D6i3jea27vuqg+ff4D9yK/ZZlXXCAqJBFJGr22Uk+J/W2MdBzdivEscCQXlWFCC8R/y/68c/lUTbPiyCfTCCx3bNH/1KyRCZfb4W6MEZqEGBcIKqQB0c7/le3ey40DQxl4do0vVhA5TpjCICfpZ3PZ+QoBeMbRqNh7VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776681317; c=relaxed/simple;
	bh=rQD/EEbB5fHSCuOCSBJspMyyh1B3okhzcL7Md121GsY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RvdlSR6nQWDvICnD9P+Kxw1UieohUdJ3EN6BCEtQ2wxwQb+orYPFkkAPvHtxOJqujS6lLQXotNIX4H+hCg8CPp7YNPYOucmCAZvRml7a24Qj1+jVINkiqSXZfWXPjrd0xv6AwOmHA25TcwNl8i9BH7m0NWJQwUQqngY4l8zPtE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PQXA9qAI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UIAVRMMP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=V27hiUGN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QMfYJASh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PQXA9qAI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UIAVRMMP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="V27hiUGN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QMfYJASh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 83FCF6A7D2;
	Mon, 20 Apr 2026 10:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776681313; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yL9ALRkBhCzRGamVM3MOXybWbLh9CiPyUwlwiHoW+VA=;
	b=PQXA9qAI4DJWPpZ78jEbQiGZYgOYl9PwayMG4oeQIaHQstpXFlmYrBNvU75CN2xQPi1O8e
	abMC5udeimErfA+wrEZqpg8Yl7Qdt2N7Dd+Fi+xO39lmFO66YL6RacWwVA42B38tBo0ZZT
	eyt/FA95l2OxK4BpuSkRxcRHKL2keLA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776681313;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yL9ALRkBhCzRGamVM3MOXybWbLh9CiPyUwlwiHoW+VA=;
	b=UIAVRMMPP3DvDvxtrVzSUAmBy0vVbnga3iLLYwKVjGcFlpKgv/27N8k0sk1LLOEm6V9Ru5
	XKq4f/v8Sv3Jz6Dw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=V27hiUGN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QMfYJASh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776681312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yL9ALRkBhCzRGamVM3MOXybWbLh9CiPyUwlwiHoW+VA=;
	b=V27hiUGNwD4VSZVnCmy9ObGxn41J6YwGBI4bAbHp41kBjH/dtY8r863SEWcKKlftoc3bys
	O1L9fbcd6YaBXdIvrR35O1qV9GQ/2Vz8dEN4lFEjAMPCqceiQD97nMlQqT940bSH/q5ulL
	8Nm8SfTtrCPAB7JXhz8gWXLZFCkUazM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776681312;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yL9ALRkBhCzRGamVM3MOXybWbLh9CiPyUwlwiHoW+VA=;
	b=QMfYJAShRQVxpv8RLLw6kBR7kvJVBmesDDHzIpPoQSAicDUEqYS0XV5rM4ELMWd5/NXX5J
	Ku2RoEz+6De+mzBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1E8A7593AE;
	Mon, 20 Apr 2026 10:35:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6khYBmAB5mmCCQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 20 Apr 2026 10:35:12 +0000
Message-ID: <abdf7c80-7cf4-489f-a105-5f0c4b6e206b@suse.de>
Date: Mon, 20 Apr 2026 12:35:11 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: sas_user_scan: use scan_start if available
To: Martin Wilck <mwilck@suse.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microchip.com>
Cc: linux-scsi@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
 storagedev@microchip.com, Ranjan Kumar <ranjan.kumar@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>, mpi3mr-linuxdrv.pdl@broadcom.com,
 MPT-FusionLinux.pdl@broadcom.com, Yihang Li <liyihang9@h-partners.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, John Garry <john.g.garry@oracle.com>
References: <20260415204850.799431-1-mwilck@suse.com>
 <20260415204850.799431-3-mwilck@suse.com>
 <e8843bfe-b4cb-4639-977e-a278f4578887@suse.de>
 <84dd73f38214c2ff593a9f86d46d2100e111329a.camel@suse.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <84dd73f38214c2ff593a9f86d46d2100e111329a.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	URIBL_BLOCKED(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,microchip.com:email,ionos.com:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 83FCF6A7D2

On 4/16/26 11:51, Martin Wilck wrote:
> On Thu, 2026-04-16 at 08:04 +0200, Hannes Reinecke wrote:
>> On 4/15/26 22:48, Martin Wilck wrote:
>>> Since 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard
>>> and
>>> multi-channel scans"), a wildcard scan on a SAS host scans all
>>> channels.
>>> This can cause excessive resource usage and even system freeze with
>>> some controllers, e.g. smartpqi. smartpqi and other drivers provide
>>> the scan_start() and scan_finished() methods to scan devices
>>> efficiently. Instead of blindly scanning every device, use these
>>> methods to do the wildcard scan when available.
>>>
>>> Fixes: 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard
>>> and multi-channel scans")
>>> Signed-off-by: Martin Wilck <mwilck@suse.com>
>>> Cc: Don Brace <don.brace@microchip.com>
>>> Cc: storagedev@microchip.com
>>> Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
>>> Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
>>> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
>>> Cc: Sumit Saxena <sumit.saxena@broadcom.com>
>>> Cc: mpi3mr-linuxdrv.pdl@broadcom.com
>>> Cc: MPT-FusionLinux.pdl@broadcom.com
>>> Cc: Yihang Li <liyihang9@h-partners.com>
>>> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
>>> Cc: John Garry <john.g.garry@oracle.com>
>>>
>>> ----
>>> This patch has been tested successfully with smartpqi, but it would
>>> affect other drivers that provide scan_start(), and we don't have
>>> hardware to test them all. Affected drivers are aic94xx, hisi_sas,
>>> hpsa, isci, mpi3mr, mpt3sas, mvsas, pm8001, and smartpqi.
>>> I cc'd the maintainers of these drivers above.
>>> ---
>>>    drivers/scsi/scsi_transport_sas.c | 26 ++++++++++++++++++++++++++
>>>    1 file changed, 26 insertions(+)
>>>
>>> diff --git a/drivers/scsi/scsi_transport_sas.c
>>> b/drivers/scsi/scsi_transport_sas.c
>>> index 1341270..2231609d 100644
>>> --- a/drivers/scsi/scsi_transport_sas.c
>>> +++ b/drivers/scsi/scsi_transport_sas.c
>>> @@ -31,6 +31,7 @@
>>>    #include <linux/string.h>
>>>    #include <linux/blkdev.h>
>>>    #include <linux/bsg.h>
>>> +#include <linux/delay.h>
>>>    
>>>    #include <scsi/scsi.h>
>>>    #include <scsi/scsi_cmnd.h>
>>> @@ -1702,6 +1703,26 @@ static void scan_channel_zero(struct
>>> Scsi_Host *shost, uint id, u64 lun)
>>>    	}
>>>    }
>>>    
>>> +/*
>>> + * For wildcard scans on hosts that provide a scan_start method,
>>> + * use that instead of blindly scanning everything.
>>> + */
>>> +static int sas_user_scan_with_scan_start(struct Scsi_Host *shost)
>>> +{
>>> +	unsigned long start;
>>> +
>>> +	if (!shost->hostt->scan_finished || !shost->hostt-
>>>> scan_start)
>>> +		return 1;
>>> +
>> Technically 'scan_start' is optional (cf do_scsi_scan_host()), so it
>> would be better to just check for 'scan_finished'.
> 
> That's why I chose to check for `scan_start`. I wanted to activate this
> code path only for those drivers that provide both functions.
> 
> I have to say I don't quite understand in which scenario it makes sense
> to check for the scan being finished without starting it beforehand.
> Perhaps it works at driver load / boot time, but in the current use
> case I have no clue how it would. Somehow we need to tell the driver
> that it must trigger probing when the user writes to the "scan" sysfs
> attribute.
> 
The point here is not whether the functions have been called, but rather
whether these function (callbacks) _exist_.
Technically it's possible to have a driver which just provides as 
'scan_finished' callback but not 'scan_start' callback.
Some drivers (like ipr or ibmvfc) have their own automatic probing, so
'scan_start' is pointless, and 'scan_finished' merely waits for the
internal probing to finish.
(I think :-)

>>
>>> +	start = jiffies;
>>> +	shost->hostt->scan_start(shost);
>>> +
>>> +	while (!shost->hostt->scan_finished(shost, jiffies -
>>> start))
>>> +		msleep(10);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>    /*
>>>     * SCSI scan helper
>>>     */
>>> @@ -1721,6 +1742,11 @@ static int sas_user_scan(struct Scsi_Host
>>> *shost, uint channel,
>>>    		break;
>>>    
>>>    	case SCAN_WILD_CARD:
>>> +
>>> +		if (id == SCAN_WILD_CARD && lun == SCAN_WILD_CARD
>>> +			&& !sas_user_scan_with_scan_start(shost))
>>> +			return 0;
>>> +
>>>    		mutex_lock(&sas_host->lock);
>>>    		scan_channel_zero(shost, id, lun);
>>>    		mutex_unlock(&sas_host->lock);
>>
>> Wouldn't it be better to export do_scsi_scan_host() and call it
>> here, seeing that it's doing exactly the same thing?
> 
> Sure, I can do that if it's preferred. But currently my function does
> not do exactly the same thing, so I'd need to refactor
> do_scsi_scan_host() slightly.
> 
Please do, just to make clear where the differences are.
(And to show future reviewers that we _did_ think about it :).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
