Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880FA2575F;
	Wed,  7 Aug 2024 20:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723064168; cv=none; b=IstOUNq+/an8pnAZ6pSVe6g4ibLIGbGLXAhsl4WQtBPk7IyPlh7L2WekLLQS+x5syXJWQak2K/2Ev6L28NWHDqau0c9kb2Jw9nPSieq3BwRTHPXkvubE6SNIk/UZZKEBRus5x9dEPhaluNxzsHt3H63EIN1j7suV1XhnxEcIKBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723064168; c=relaxed/simple;
	bh=oasgz1nL0IJSjGJv2d4Ya9Zhj2u6ldXOLklj1B473V8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AylQlZUPU6A4c5CaaIPYuJ67Zf56/pfW+YMsgzCSaUUwx89LHLrTNpHrv4y76MHrsiQpIAWVgI8wCgnz61AkI1aXYQqy5rLLMtlDsHeup6KEVqUs4HUneMe4+OkZKHoB9V/cnMWEex35/qJzovzG6QF63Y3UnxRVTRCkAE1Bbfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CENRsVxL; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CENRsVxL"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WfMsG72pJzlgVnF;
	Wed,  7 Aug 2024 20:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723064161; x=1725656162; bh=w+JJjxCdnwFJOiB9JQ6tYzxa
	I1ITC7unatpf+kxjDRg=; b=CENRsVxLm4i5PY+bmEolxU3bklrXn4GEgph8kMgz
	uAwBfZyKm3D0nEJbsMS7yozE+kMye0oDo+fJJ8mfbEAWEQfV/a27Mq+EwM2WQqf7
	OkwF7zaIuZ1VoFKpf3SpmKRVEBcN1bW2u/N8BX5aoN2bpPqv6/Jfn6NyqBncisdc
	WhSqz1lHWVaEkxIgLF+3LvckXMYfS4Z6btH4LnlQuZcLEjziiQr0hLhjeykksZq3
	zVCckfJwtv2hMcFwLnc37iFAJXUTVjxntxX+iTqbiS+kcBcajKZgSe24h4QfMFKA
	rpv4g2GXHQq65mzj6Jg3U0dbCRV5rtA0jC9so78yST5dRQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JQebXUt6PTwp; Wed,  7 Aug 2024 20:56:01 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WfMsD2NvGzlgTGW;
	Wed,  7 Aug 2024 20:55:59 +0000 (UTC)
Message-ID: <28624a6d-fdc7-4458-8e8f-f8d764cd4b5b@acm.org>
Date: Wed, 7 Aug 2024 13:55:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: ufs: Add HCI capabilities sysfs group
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240804072109.2330880-1-avri.altman@wdc.com>
 <20240804072109.2330880-3-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240804072109.2330880-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/4/24 12:21 AM, Avri Altman wrote:
> +What:		/sys/bus/platform/drivers/ufshcd/ufshci_capabilities/capabilities

That path seems wrong to me. I think that "ufshcd" should be changed
into something like ${host_driver_name}/${ufshci_instance_name}. An 
example from a Pixel 8 device:

$ adb shell ls /sys/bus/platform/drivers/*ufs*
/sys/bus/platform/drivers/exynos-ufs:
13200000.ufs
module
uevent

/sys/bus/platform/drivers/ufshcd-hisi:
bind
uevent
unbind

> +What:		/sys/bus/platform/devices/*.ufs/ufshci_capabilities/capabilities
> +Date:		August 2024
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:
> +		Host Capabilities register group: host controller capabiities register.
> +		Symbol - CAP.  Offset: 0x00 - 0x03.

Please fix the spelling error that was already reported by Keoseong
Park. Otherwise this patch looks good to me.

Thanks,

Bart.
