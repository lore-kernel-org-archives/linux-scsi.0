Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5EC2E371D;
	Thu, 24 Jul 2025 20:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753389994; cv=none; b=LdlebhZaT1DLcFQNgpNlrJKTdfMxVqZGgy+3QI9/cKHI+3jgSHMUinzpR3z0j5a8Grapsc7RS7jquGGWUhtJJq0A4cEidFisketVNmkBhKtiDtuT8P4KHIUh9GG8to0nWimsifGarmEX5HfKUPvgEAZcMJ9ixchvsq4eiFsGfKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753389994; c=relaxed/simple;
	bh=yuVbIq/Z+Q8wsJuZLNwT2uhzA5JQZ2Etn/Eyfh9HHLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sE9mGfL56EEej2UmB/tNIx5O/vYGze7ZeypvXSpKBY98BgULr1+hr/EKNnekhSqWGOX6agaUaJeuyIXGqKLDjFXnzLqtWMPu9NZGqKswrvE3aL8UGi3cWJXIx4YerpsMRxd8ZhpzaNqVoJAzhNoXy0bSTfX38O06n4LpzVG79PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ym7Z8ny0; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ym7Z8ny0"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bp32H3r5HzlgqV4;
	Thu, 24 Jul 2025 20:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753389990; x=1755981991; bh=Poh04G3fWQ5lclQ5/432jPff
	3wG00JscgyZFbbI5jE8=; b=ym7Z8ny0lKejZwdLeivMPQRuOMthighRTJ0rxEfZ
	c4IorQZeTVdHd1R6ESvd6yx3AKD8wtcMhYYM82hjIUgMl6IgqFFXchtis+S7GmRm
	Kgi0OeRVVIP76GarKdqLBI9cYltoKhW0B4BfXP+hC/2v413gX4mvoQ/2prDV8Zhl
	FJEg35Ov6XGg6tRuOmFF70r1x44lyPx4ffqW41IwMuEiPCPrsqFs2D57bTWTgtmt
	tPHZOurYyEU0Zrvkz5azWTr3//0jnaMm2PNY4h/R3PFQHZiRJ3GI//0VPjxFIod/
	i9xbXIuVCBmtjHnrY5ZPj5d/lAKutQ7mlSSKXPurGDpotg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LmNmYM3UKFSD; Thu, 24 Jul 2025 20:46:30 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bp3294KQLzlgqTx;
	Thu, 24 Jul 2025 20:46:23 +0000 (UTC)
Message-ID: <ad9e3921-43ed-4abd-acce-ce46d57f32c8@acm.org>
Date: Thu, 24 Jul 2025 13:46:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: fix sd shutdown to issue START STOP UNIT
 command appropriately
To: Salomon Dushimirimana <salomondush@google.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Vishakha Channapattan <vishakhavc@google.com>
References: <20250724203805.93944-1-salomondush@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250724203805.93944-1-salomondush@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/24/25 1:38 PM, Salomon Dushimirimana wrote:
> Commit aa3998dbeb3a ("ata: libata-scsi: Disable scsi device
> manage_system_start_stop") enabled libata EH to manage device power mode
> trasitions for system suspend/resume and removed the flag from
> ata_scsi_dev_config. However, since the sd_shutdown() function still
> relies on the manage_system_start_stop flag, a spin-down command is not
> issued to the disk with command "echo 1 > /sys/block/sdb/device/delete"
> 
> sd_shutdown() can be called for both system/runtime start stop
> operations, so utilize the manage_run_time_start_stop flag set in the
> ata_scsi_dev_config and issue a spin-down command during disk removal
> when the system is running. This is in addition to when the system is
> powering off and manage_shutdown flag is set. The
> manage_system_start_stop flag will still be used for drivers that still
> set the flag.
> 
> Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
> ---
>   drivers/scsi/sd.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index eeaa6af294b81..282000c761f8e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4173,7 +4173,9 @@ static void sd_shutdown(struct device *dev)
>   	if ((system_state != SYSTEM_RESTART &&
>   	     sdkp->device->manage_system_start_stop) ||
>   	    (system_state == SYSTEM_POWER_OFF &&
> -	     sdkp->device->manage_shutdown)) {
> +	     sdkp->device->manage_shutdown) ||
> +	    (system_state == SYSTEM_RUNNING &&
> +	     sdkp->device->manage_runtime_start_stop)) {
>   		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>   		sd_start_stop_device(sdkp, 0);
>   	}

A Fixes: tag is missing.

manage_runtime_start_stop is for runtime power management.
/sys/block/*/device/delete is not related to runtime power management.
Isn't manage_system_start_stop more appropriate here than
manage_runtime_start_stop? Shouldn't sd_shutdown() calls triggered by
writing into /sys/block/*/device/delete already be covered by this
test: system_state != SYSTEM_RESTART &&
   sdkp->device->manage_system_start_stop?

Thanks,

Bart.
