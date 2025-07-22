Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9A3145323
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 01:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753147862; cv=none; b=ZoG3+F7iB7ioocx18MyaBv5pMQqiH2Wo+Cgfu5bg3N1NCc2qOxNAwqqA6MfaPriSX+StDLlRNc50xUNGpiujX3LNDy2N7w/oqF2MXMnMoI64EGAtSsYysuYR8wvTMeTeJKkzlbLY1ZOcRBM4Mk/cTrh4CYWWwT2CNH6g8l6974A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753147862; c=relaxed/simple;
	bh=GaAoXITOuW8MIkohiMm6BZsGpfNUB5dW93Aw5vqHpPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OlfBC5IBMX3TrazVFdbVoOTvGAouHNldsn2a3txXfMWmdor1UBOtqopZQwCP0VqtRrDiWp7+mxSEN4Mxs78Y34+7KF0srW8HDf6kWljh3/RoLMSux3imVmo+MUaYL3qCA3XgA/lKDcNBvH8rb/B7wHA9AGL/N/UkHYJ1Tx3nJnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PblJkyRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PblJkyRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F94C4CEED;
	Tue, 22 Jul 2025 01:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753147862;
	bh=GaAoXITOuW8MIkohiMm6BZsGpfNUB5dW93Aw5vqHpPA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PblJkyRd6ivG16eVHkWcNr3l2f1eUDseCoGG92dopKALg4+nU3zIOZxk6arr26Pxh
	 Qg+/72mAx/0zWFvMoptNhntZFWIwAsBm5q6ZyXG3CRt8Yw2wertWD4QYEhbgFKdljK
	 YOPMJMryUMRYsX+6XKqsCCrLXOmkV0b1SSUOmAxSLTtmWpKYpTt++I6KPhJdqXDGgk
	 XzKtRVpgARUq2nEIOhNyh7oKNjjQcXNUaBzvcKTR9/gaRx2VY6HL9oYkr2QXzo7IUu
	 IpWd7inavVXS+HD4M7Q3rSAi+p0ihOm1b2+eDXJ+BEFruDOu4ao81cjSej5JmWhtJX
	 abUKskLpKs4Jg==
Message-ID: <70d2f593-3121-4684-8632-6a4ea1dc72ea@kernel.org>
Date: Tue, 22 Jul 2025 10:28:35 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: pm80xx: Do not use libsas port ID"
To: Igor Pylypiv <ipylypiv@google.com>
Cc: Niklas Cassel <cassel@kernel.org>, Jack Wang
 <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Terrence Adams <tadamsjr@google.com>, linux-scsi@vger.kernel.org
References: <20250717165606.3099208-2-cassel@kernel.org>
 <aHlpNRsPbmrTgv0O@google.com>
 <a09dea31-0de3-4859-95d9-2d83fc1ccc73@kernel.org>
 <aHrLBPunX8Fuv1zz@google.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <aHrLBPunX8Fuv1zz@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/19/25 7:30 AM, Igor Pylypiv wrote:
> Hey Niklas,
> 
> Could you try the following fix with your expander setup, please?
> The fix assumes the problematic patch is not yet revered.
> 
> $ git diff
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index f7067878b34f..cd9513c23c71 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -503,7 +503,7 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
>         spin_lock_irqsave(&pm8001_ha->lock, flags);
>  
>         pm8001_dev = dev->lldd_dev;
> -       port = pm8001_ha->phy[pm8001_dev->attached_phy].port;
> +       port = dev->port->lldd_port;
>  
>         if (!internal_abort &&
>             (DEV_IS_GONE(pm8001_dev) || !port || !port->port_attached)) {

Igor,

I tested this, or rather, a variation of it that clean things up at the same time:

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index f7067878b34f..753c09363cbb 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -477,7 +477,7 @@ int pm8001_queue_command(struct sas_task *task, gfp_t
gfp_flags)
        struct pm8001_device *pm8001_dev = dev->lldd_dev;
        bool internal_abort = sas_is_internal_abort(task);
        struct pm8001_hba_info *pm8001_ha;
-       struct pm8001_port *port = NULL;
+       struct pm8001_port *port;
        struct pm8001_ccb_info *ccb;
        unsigned long flags;
        u32 n_elem = 0;
@@ -502,8 +502,7 @@ int pm8001_queue_command(struct sas_task *task, gfp_t
gfp_flags)

        spin_lock_irqsave(&pm8001_ha->lock, flags);

-       pm8001_dev = dev->lldd_dev;
-       port = pm8001_ha->phy[pm8001_dev->attached_phy].port;
+       port = dev->port->lldd_port;

        if (!internal_abort &&
            (DEV_IS_GONE(pm8001_dev) || !port || !port->port_attached)) {


And it works, I can see the drives in the enclosure behind the expander.
Care to send a proper path ?

I think this needs more testing though, especially special cases like yanking
the SAS cable and doing device hotplug/unplug. Will do that later today.

Thanks !

-- 
Damien Le Moal
Western Digital Research
