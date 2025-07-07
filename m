Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8F9205E3E
	for <linux-scsi@vger.kernel.org>; Mon,  7 Jul 2025 19:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751918335; cv=none; b=loAhC1brD+0N29GCiF5iRFUGJ+aW68ta2PkVo3GxmW8GJet7cAhVQBmmySJc8syda3SdQgclsCgexIlQ4kv97fzuhACwMBlyTW6XpsMio+kcoSRbFaf44zxQsINPdmHk00XjKdc01n5Fq6kmRXVHNvQZCDXPQPRQSMUZ3q18ik4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751918335; c=relaxed/simple;
	bh=Bk5g85FCZs7iy7lgB3uYsvBdM4U0MphufyabLBCQxCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tSHXupOagK+MiDY6g1dYUpmwPyxyqNDU5KjZLIXrgYEE8hYGOS9iPYjXih5qoLTP+IBgbdng18nDt+rxLUJ8vOeGPv0t3HnpgTfrfpvSBGl0K+yJdXEluELXQwZx6G/FhGMyz7RSndMnMYq6/MSTDRHiQiZIls1irmC7rnBUAWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nAdr76k8; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nAdr76k8"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bbZn84GBrzltKGk;
	Mon,  7 Jul 2025 19:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1751918331; x=1754510332; bh=wRkwwaV6v2zyajUs+U9MPZlt
	8onusLjc47oAV6K6B50=; b=nAdr76k8bgXIdmiRFrumnXjwk82Nvm17d8OII462
	Nt0ezUMyYuhH+4aTXgNYIeBGbkc3lSW0F2PgbvUwaGqoPEKt3PpthMrrv7RT5l5o
	G1O6WEV8GGOGvgXdisd1E+m55bCRz0rS6mJAc1YCDMR3JK45LW1oA0GCgp9J9VEb
	qSMPFAcGLl/xJggorL6ytNkhnw158NuPV0pMC7kMVGflSNHAg+X08TWToDk8AAGs
	1k//ckRCMHs1egIcPSmJl2KWomQno/pBblOr/vg2lTgP9lAX0tez3MVcjaRbYcQp
	tOoFgZIltBiowSsAdzy8+C3WTtEbR6Slp/8L1WGGqaMKsA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 18xCWavNKIGD; Mon,  7 Jul 2025 19:58:51 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bbZn33wfRzlh0dZ;
	Mon,  7 Jul 2025 19:58:46 +0000 (UTC)
Message-ID: <5fb9ba7f-cd44-43f4-aaf4-d15de73bda3d@acm.org>
Date: Mon, 7 Jul 2025 12:58:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: ufs: ufs-pci: Remove UFS PCI driver's
 ->late_init() call back
To: Adrian Hunter <adrian.hunter@intel.com>,
 Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@sandisk.com>,
 Archana Patni <archana.patni@intel.com>, linux-scsi@vger.kernel.org
References: <20250703064322.46679-1-adrian.hunter@intel.com>
 <20250703064322.46679-4-adrian.hunter@intel.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250703064322.46679-4-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/25 11:43 PM, Adrian Hunter wrote:
>   ->late_init() was introduced to allow the default values for rpm_lvl and
> spm_lvl to be set.  Since commit bb9850704c04 ("scsi: ufs: core: Honor
> runtime/system PM levels if set by host controller drivers") and
> commit fe06b7c07f3f ("scsi: ufs: core: Set default runtime/system PM levels
> before ufshcd_hba_init()"), those default values can be set in the ->init()
> variant call back.
> 
> Move the setting of default values for rpm_lvl and spm_lvl to ->init() and
> remove ->late_init().

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
