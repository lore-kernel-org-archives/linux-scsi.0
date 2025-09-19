Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AC332255A;
	Fri, 19 Sep 2025 17:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758303907; cv=none; b=l0kRjJPu/L56qy//pShMIe5sARPSWntJxfVwEAdI+dvxJgTSlA2GUpDLq0FF2rLHh+7L8Cnfsj+X7XJQQ7ApWqLLW7c/rqFHjN+J0umhWVFr2rXDPKMj2loNQYl9eE7xPN5pydm6WdB+SQ5CapWt5oeOvLvRQ71ercj0YNaWoic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758303907; c=relaxed/simple;
	bh=ruZL1+sZk87jbzcMPg4L7Xzp4wEUUUWQj4LRTo+RCh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=omZGmZrCkiWpsMho6UDwkERI6JITHYfFWU82VK+DBV2m4koizNYGo5xcfCOV+RGiIQ6ouoyTOv+dMCrHl57/h6E72OThyD2Nb/yB/lwr7up/LUPY+A9hB2fLa4HbBRS4nERS9seMuhCkHWs++tDhYSDvqCml+1Y4EXvA0Z1cbnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sL2JANKk; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sL2JANKk"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cT0JW1rWjzm1747;
	Fri, 19 Sep 2025 17:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758303896; x=1760895897; bh=KifpkoMQNZGnfKwHvbjFz6wL
	n+n9uAm028Wj6ai7BYo=; b=sL2JANKksLKbN0f97C8MtZs5hQjXwb1aqF4QGahh
	hT+L/Fd5fwr/sdHCAI98sOwAN5rj+S/YlmoreKmGLY4aKVAky+WbIEEWpo6wAwvH
	TtkO8AAfLTMUbmWu/orbEMw4YmgC2g0dheTV6q+mWe5rbdEu74ciGyFltSZksc+h
	baC5gs3yew2hV77TL4PCWi7B0VuxN+BDguTiVDctnx1YkVwXSU/6VPcotOafKcyf
	xhSaVvMZNk6eYKP89VqLqLZ01x7Paqeg/WlRfep8pzV4SJCNzqAQ7xpc+igd61qf
	NC+XIozCgBUCAa6inct+S9NAxeieAx/eCuqe+hEp21dGHQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cscHFmNmlGa7; Fri, 19 Sep 2025 17:44:56 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cT0JF6NM4zm0ysv;
	Fri, 19 Sep 2025 17:44:45 +0000 (UTC)
Message-ID: <911ac2e9-2f3d-41d2-8a2f-74d2aebef21d@acm.org>
Date: Fri, 19 Sep 2025 10:44:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] ufs: amd-versal2: Add AMD Versal Gen 2 UFS support
To: Ajay Neeli <ajay.neeli@amd.com>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, pedrom.sousa@synopsys.com
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, git@amd.com, michal.simek@amd.com,
 srinivas.goud@amd.com, radhey.shyam.pandey@amd.com,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
References: <20250919123835.17899-1-ajay.neeli@amd.com>
 <20250919123835.17899-6-ajay.neeli@amd.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250919123835.17899-6-ajay.neeli@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/25 5:38 AM, Ajay Neeli wrote:
> +#include "ufshcd-dwc.h"
> +#include "ufshcd-pltfrm.h"
> +#include "ufshci-dwc.h"

The *-dwc.h header files are for Synopsys Designware UFS host
controllers only and hence should not be included in the implementation
of the AMD Versal UFS host controller.

> diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
> index ad91ea5..379f3cf 100644
> --- a/drivers/ufs/host/ufshcd-dwc.h
> +++ b/drivers/ufs/host/ufshcd-dwc.h
> @@ -12,6 +12,55 @@
>   
>   #include <ufs/ufshcd.h>
>   
> +/* PHY modes */
> +#define UFSHCD_DWC_PHY_MODE_ROM         0

Please do not modify header files from other controller vendors.

Thanks,

Bart.
