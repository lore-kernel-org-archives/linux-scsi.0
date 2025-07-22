Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554FF1DF247
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 04:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753158496; cv=none; b=sbvtxanqr/rFV150A8ppPk8xA7y4uAFwUx2W28UJTWHNuXvT1A3sxgc4V+Tafna+e70pu954kExuTM9425WXXxfigxACLkoluROTrtmbWP0Xtf+Jyyz5iKsWEKxpnBU0cGmIOxAqkw0yFPOdE/5MWSWmOP19BSl9RVjrKC6ilMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753158496; c=relaxed/simple;
	bh=LyEeU5mwZHzf3UuUO2etZxIqfrt48ZUd/T4jOsvyU9Q=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=D7luFXbkyP7hjKjz+JcJUs/QhXBzgoTkYntLK1UFppITMEiDE9DCnmYnnaScxK4NoDmhO/cQdn4lGKYHZidY9MF82yUMTP+N2CmlBe4vFBMPiLuM3Ni2lIjzXfoyThQ5DDdsMwgnOTjblogoSXQzGtJ1oJ/vO6b3RqsoWei8674=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i+Y249Bv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+Y249Bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E6BC4CEEB;
	Tue, 22 Jul 2025 04:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753158493;
	bh=LyEeU5mwZHzf3UuUO2etZxIqfrt48ZUd/T4jOsvyU9Q=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=i+Y249Bv6zFy70V8rVgQbimAJzGLj6T+HqMZr4nAa4GHB9xfmk8Dej6eqK6nsvZRL
	 jvhBqSqqU5ITRb18F73L/RGvzag0E4MLq7f/rBkUvjLoLK5a0nIhhYdKbRFQP7aV1Z
	 zxtlO0KMf/stZEpQvaddfUiz//ddbMf2uApc5t93O1cUIgDBEQQ0lm04DHqM1xI4ZO
	 4cVVHnDpc81zrdW3lvNPLcQFi6bmZbj9UVEelCQPZ4CyyvBFEYMYnJulQyo6ui0UDC
	 2EsyattgBFspR7QxCrTsEbKKWQOazZDp21blsfz9tQZafHTERn2lCxwA82kj7p+0c9
	 Fm3E/xMw8m+9Q==
Message-ID: <5056b88b-0f42-4a02-906f-197492d76827@kernel.org>
Date: Tue, 22 Jul 2025 13:25:47 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: pm80xx: Do not use libsas port ID"
From: Damien Le Moal <dlemoal@kernel.org>
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
 <70d2f593-3121-4684-8632-6a4ea1dc72ea@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <70d2f593-3121-4684-8632-6a4ea1dc72ea@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/22/25 10:28 AM, Damien Le Moal wrote:
> On 7/19/25 7:30 AM, Igor Pylypiv wrote:
>> Hey Niklas,
>>
>> Could you try the following fix with your expander setup, please?
>> The fix assumes the problematic patch is not yet revered.
>>
>> $ git diff
>> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
>> index f7067878b34f..cd9513c23c71 100644
>> --- a/drivers/scsi/pm8001/pm8001_sas.c
>> +++ b/drivers/scsi/pm8001/pm8001_sas.c
>> @@ -503,7 +503,7 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
>>         spin_lock_irqsave(&pm8001_ha->lock, flags);
>>  
>>         pm8001_dev = dev->lldd_dev;
>> -       port = pm8001_ha->phy[pm8001_dev->attached_phy].port;
>> +       port = dev->port->lldd_port;
>>  
>>         if (!internal_abort &&
>>             (DEV_IS_GONE(pm8001_dev) || !port || !port->port_attached)) {
> 
> Igor,
> 
> I tested this, or rather, a variation of it that clean things up at the same time:
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index f7067878b34f..753c09363cbb 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -477,7 +477,7 @@ int pm8001_queue_command(struct sas_task *task, gfp_t
> gfp_flags)
>         struct pm8001_device *pm8001_dev = dev->lldd_dev;
>         bool internal_abort = sas_is_internal_abort(task);
>         struct pm8001_hba_info *pm8001_ha;
> -       struct pm8001_port *port = NULL;
> +       struct pm8001_port *port;
>         struct pm8001_ccb_info *ccb;
>         unsigned long flags;
>         u32 n_elem = 0;
> @@ -502,8 +502,7 @@ int pm8001_queue_command(struct sas_task *task, gfp_t
> gfp_flags)
> 
>         spin_lock_irqsave(&pm8001_ha->lock, flags);
> 
> -       pm8001_dev = dev->lldd_dev;
> -       port = pm8001_ha->phy[pm8001_dev->attached_phy].port;
> +       port = dev->port->lldd_port;
> 
>         if (!internal_abort &&
>             (DEV_IS_GONE(pm8001_dev) || !port || !port->port_attached)) {
> 
> 
> And it works, I can see the drives in the enclosure behind the expander.
> Care to send a proper path ?
> 
> I think this needs more testing though, especially special cases like yanking
> the SAS cable and doing device hotplug/unplug. Will do that later today.

So I did that. And things are not pretty... Even a simple "rmmod pm80xx"
crashes the kernel on a bad pointer dereference (invalid port address). Same if
I hot-unplug drives from the enclosure. But that happens even with only Niklas
revert patch applied. So I think that is unrelated to this change.

That said, I will dig further to understand how the port pointers become
invalid, and make sure this change is OK. Note that there are no issues that I
can see when there is no expander (drives directly attached to the HBA).

Cheers.


-- 
Damien Le Moal
Western Digital Research
