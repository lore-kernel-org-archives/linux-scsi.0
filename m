Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C5130E0F2
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 11:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777290858; cv=none; b=L00Dld+q4dtFlzQoOmyX15oYqSyOPuwB1yLLfjFchUlqH52H2mNOnFigzAvlwRj5H+MyryoVenvv+3F3cYTC+EshQmRDiYut8utCFL0uN9H0Zqzg8WjsLBCWBYIvWmIyKuKZgxg35/xlCanpPy5TSNE503leWVg69BYoyyvRUr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777290858; c=relaxed/simple;
	bh=QhdqulxejUEztqHqlXFck49j4ENe2vOY7mmR2dRGNq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RSEJwAWmNq4pD/G3gOtcb9azrl42dB3/m+NRSubbb5nt7a7d0Tmm1wtRHos0hDH+w/HAmpiIa1LRiFzEJZVuQ2y70K7maiAFE0CpZTIF9WoJznIbIrjM8JSycxhpex1/egiSh8dgaOhnbxZwSKkiRHXWdcdcMRdNw1SA/Nad9SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j6uDjtJz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fDgyN16l; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j6uDjtJz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fDgyN16l; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j6uDjtJz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fDgyN16l";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j6uDjtJz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fDgyN16l"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9B7025BCD2;
	Mon, 27 Apr 2026 11:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777290855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cygEz7Hg0EKq8oFQ2rX3PuYk3hTkHwdsO1RP13JbGgQ=;
	b=j6uDjtJzCHIiuAjVbpZEcipYdLzEgPGp6GvJ3zl4s0E820N9RoEAJtUVLbnwMi7nzXY/oh
	FqholXxRUdinmFy8qgSgjWaJag5wzYguX7OKSctM8061F74yR9Lun5l22GWhIWFkT4tIvJ
	NZXOhkMz/raNSgepoTUXYiR4bOvCeQk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777290855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cygEz7Hg0EKq8oFQ2rX3PuYk3hTkHwdsO1RP13JbGgQ=;
	b=fDgyN16l2Rdri4UFPrCOSte7aYz5TMag3UW2wI1xSfPDivaHNbo8qM1zqw30U6XDAXwOP/
	x+NdWoEqmtb7pABg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777290855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cygEz7Hg0EKq8oFQ2rX3PuYk3hTkHwdsO1RP13JbGgQ=;
	b=j6uDjtJzCHIiuAjVbpZEcipYdLzEgPGp6GvJ3zl4s0E820N9RoEAJtUVLbnwMi7nzXY/oh
	FqholXxRUdinmFy8qgSgjWaJag5wzYguX7OKSctM8061F74yR9Lun5l22GWhIWFkT4tIvJ
	NZXOhkMz/raNSgepoTUXYiR4bOvCeQk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777290855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cygEz7Hg0EKq8oFQ2rX3PuYk3hTkHwdsO1RP13JbGgQ=;
	b=fDgyN16l2Rdri4UFPrCOSte7aYz5TMag3UW2wI1xSfPDivaHNbo8qM1zqw30U6XDAXwOP/
	x+NdWoEqmtb7pABg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D141593B0;
	Mon, 27 Apr 2026 11:54:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id T6klGmdO72lzdAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 27 Apr 2026 11:54:15 +0000
Message-ID: <f654611e-5621-463d-a8be-c963f63f7155@suse.de>
Date: Mon, 27 Apr 2026 13:54:15 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] scsi: add BLIST_NO_LUN_1F blacklist flag
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260426190920.2051289-1-philpem@philpem.me.uk>
 <20260426190920.2051289-5-philpem@philpem.me.uk>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260426190920.2051289-5-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On 4/26/26 21:09, Phil Pemberton wrote:
> Some multi-LUN devices respond to INQUIRY on unpopulated LUNs with
> PQ=0 / PDT=0x1f instead of the standard PQ=3.  The SCSI scan layer
> normally adds such devices (PQ=0 means "connected"), producing
> spurious "No Device" entries.
> 
> The scsi_target field pdt_1f_for_no_lun already exists to suppress
> this, but was previously only set by the USB UFI driver.
> 
> Add BLIST_NO_LUN_1F so the flag can be set per-device from
> scsi_devinfo, and wire it up in scsi_add_lun() to set
> starget->pdt_1f_for_no_lun from the blacklist flags.  This runs
> during LUN 0 processing, before the sequential LUN scan probes
> higher LUNs.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>   drivers/scsi/scsi_scan.c    | 3 +++
>   include/scsi/scsi_devinfo.h | 6 +++---
>   2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 7b11bc7de0e3..d3f0540d79a2 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1070,6 +1070,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   
>   	sdev->sdev_bflags = *bflags;
>   
> +	if (*bflags & BLIST_NO_LUN_1F)
> +		sdev->sdev_target->pdt_1f_for_no_lun = 1;
> +
>   	if (scsi_device_is_pseudo_dev(sdev))
>   		return SCSI_SCAN_LUN_PRESENT;
>   
> diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
> index 1d79a3b536ce..6957b0705510 100644
> --- a/include/scsi/scsi_devinfo.h
> +++ b/include/scsi/scsi_devinfo.h
> @@ -34,7 +34,8 @@
>   #define BLIST_NOSTARTONADD	((__force blist_flags_t)(1ULL << 12))
>   /* do not ask for VPD page size first on some broken targets */
>   #define BLIST_NO_VPD_SIZE	((__force blist_flags_t)(1ULL << 13))
> -#define __BLIST_UNUSED_14	((__force blist_flags_t)(1ULL << 14))
> +/* PDT 0x1f with PQ 0 means no LUN present (e.g. some ATAPI multi-LUN) */
> +#define BLIST_NO_LUN_1F		((__force blist_flags_t)(1ULL << 14))
>   #define __BLIST_UNUSED_15	((__force blist_flags_t)(1ULL << 15))
>   #define __BLIST_UNUSED_16	((__force blist_flags_t)(1ULL << 16))
>   /* try REPORT_LUNS even for SCSI-2 devs (if HBA supports more than 8 LUNs) */
> @@ -77,8 +78,7 @@
>   #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
>   			       (__force blist_flags_t) \
>   			       ((__force __u64)__BLIST_LAST_USED - 1ULL)))
> -#define __BLIST_UNUSED_MASK (__BLIST_UNUSED_14 | \
> -			     __BLIST_UNUSED_15 | \
> +#define __BLIST_UNUSED_MASK (__BLIST_UNUSED_15 | \
>   			     __BLIST_UNUSED_16 | \
>   			     __BLIST_UNUSED_24 | \
>   			     __BLIST_UNUSED_27 | \

Much better.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
