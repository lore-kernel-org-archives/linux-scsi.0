Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34FC13AA38;
	Fri,  9 Aug 2024 19:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230396; cv=none; b=smwZa0Hbmsbg9QR1jJZBrxPafMRx2zq9yTHKGGNCu3zG+K9FHDqHyUz81fow9yQgLDaiU08FcRxmo0tPLbb/x/PM2+HFto+A4JwgQTZYvOqoU/XJvUKW74nzL2C5LcoCf6IJnvQrps42y+bwqCtpxb7gvSJ0OxfViMqoyJ8bXEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230396; c=relaxed/simple;
	bh=GDeSvflfgNP53Bnn6NwxyLup2T5xICejTY4xxMRsW7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aElxyq5AHAPT8Y1/pX9fIjkpy9FbVFeTNfS9Z++XWwec+x4yceTJc9gqpmw6AP901aCCqzo/OdiwVZxK/qMt4iaIsSbPubiUJmf2ThSZFfdo1skW2O8yVaEBFJTsHc9AivBH/cRIpWsuxwnr+y/3mNbJzvIDQDH/nN4v57Q53CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3wXsC+yv; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3wXsC+yv"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WgYKw2KlczlgTGW;
	Fri,  9 Aug 2024 19:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723230383; x=1725822384; bh=DW9duP/WSzGKgw6N8JbyhvDM
	ENJtltoq9LzdIzH07QI=; b=3wXsC+yvI86+JvuSDvFMn01MUZMGzMz2kM9Uk5Eh
	RCKjdsUJIDoh75MzaP+PnO72nSGuFBR/O2RaYlKMy9ZFQmPqH+GDQliUKFyLSCCq
	7xK11ehoXOSd4+d1T/hUaBGrAMYbbem0X55iR40Gd5MIryd6ux678DoaWO0PCd6D
	848CscKTSWYB+QINptqqSnN8T7mph67+mQRJu+Y4ww0FppF9IX3CgiMgZouLlmZe
	pVa13dekFI6+puujw35+mayzi01rk7V4pwQoOHhO+5CGevKkxOBNG5UUyVQYNtE8
	x4k7rjwOYh9/Zc7ff2AwnXPd3GB0aSYmcS9DkasBob2uXw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aW_A8ey1jKET; Fri,  9 Aug 2024 19:06:23 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WgYKl5vvLzlgVnF;
	Fri,  9 Aug 2024 19:06:19 +0000 (UTC)
Message-ID: <203bf2c3-e55d-4b1e-9ef1-a7d73401ce52@acm.org>
Date: Fri, 9 Aug 2024 12:06:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] scsi: ufs: rockchip: init support for UFS
To: Shawn Lin <shawn.lin@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Heiko Stuebner <heiko@sntech.de>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, YiFeng Zhao <zyf@rock-chips.com>,
 Liang Chen <cl@rock-chips.com>, linux-scsi@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723089163-28983-4-git-send-email-shawn.lin@rock-chips.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1723089163-28983-4-git-send-email-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/24 8:52 PM, Shawn Lin wrote:
> RK3576 contains a UFS controller, add init support fot it.
					^^^^	     ^^^
                                         initial      for

Again a very short patch description. What is "RK3576"? Please explain.

> +config SCSI_UFS_ROCKCHIP
> +	tristate "Rockchip specific hooks to UFS controller platform driver"

A better description would be: "Rockchip UFS host controller driver"

> +#include "ufshcd-dwc.h"

No, you should not include the ufshcd-dwc.h header file. That is a 
header file for the Designware UFS host controller.

> +	reset_control_assert(host->rst);
> +	udelay(1);
> +	reset_control_deassert(host->rst);

Why udelay() instead of usleep_range()?

> +static int ufs_rockchip_device_reset(struct ufs_hba *hba)
> +{
> +	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> +
> +	if (!host->rst_gpio)
> +		return -EOPNOTSUPP;
> +
> +	gpiod_set_value_cansleep(host->rst_gpio, 0);
> +	udelay(20);
> +
> +	gpiod_set_value_cansleep(host->rst_gpio, 1);
> +	udelay(20);
> +
> +	return 0;
> +}

Same question here: why udelay() instead of usleep_range()?

Thanks,

Bart.
