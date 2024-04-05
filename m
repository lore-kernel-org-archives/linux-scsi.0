Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDC5171672
	for <linux-scsi@vger.kernel.org>; Fri,  5 Apr 2024 19:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712346457; cv=none; b=mZSIvcYaOphXvM15ifGIFWvTjAdrwvBDi7/HlPiPRGA5Y/AYmR42BZYfFwaD71Xrqfunx4H1eLL8EI61gWEIOt2cHnMiDb5aLukKm6AkMU4RupXNep3N+D/OB+tWRYv7uZOX5N0GGlIs+cNJ+5PZLLP8OqfIe5N5Qm3GURcqf6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712346457; c=relaxed/simple;
	bh=gkoayhTTvZREL59mTkY0nwUBRlLRsmQMGX3MQaZV0E4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DL0u1IjVNblUupaFHLhONOGP9z+8yA3C/qZm3HTdILecaGyASbU0CUoAavWWs6MdQ2vVrO2TZ7ReOhb5M2ByimSymV/onj7Qq+slp/dK+T0LWPBveCoHvvR8Bny9o4taGFbybJ3MzyBZEJmbjPiZvL7aNoiGXJXtvvSobdS2qNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0ieUr1sE; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0ieUr1sE"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VB8CW0f2nzll9bZ;
	Fri,  5 Apr 2024 19:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712346454; x=1714938455; bh=gkoayhTTvZREL59mTkY0nwUB
	RlLRsmQMGX3MQaZV0E4=; b=0ieUr1sE9+/3N5ehr+Phu7Elmrm91VTXyYZYWtlc
	xzFDvMurWb8cyq0JVwPK9UcKj0zYaYgt1/+5xdLhej/VHLzxyjFplRkqQR/LMNGr
	jO2DXVhkGOb6I6hDCXJL/i67zCPiIXBdvHFHBZgIxCakD38Ujjmz9RbFJ+KhnBtD
	rbrX3Zvc4knq4nY6ctm84pw09FV6dctqDOjA2Ab/zxOyYDjNG8U13KD7ODSaDODW
	XFNuZn10GaVOyGd+kgV3TN0qiYdX8V1pHhj7Rnv0ZmlDwghbz5C75qSfuC3LLR/P
	XRg1w4HCR4rdA6HlogWgKRSjkhZn7L7y4MK/nX6Ooxj7Vg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0VsymMMGL_ZN; Fri,  5 Apr 2024 19:47:34 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VB8CV17JYzlgVnY;
	Fri,  5 Apr 2024 19:47:33 +0000 (UTC)
Message-ID: <cd08ed26-7353-4d2d-b064-91180a0282d7@acm.org>
Date: Fri, 5 Apr 2024 12:47:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Improve the code for showing commands in debugfs
Content-Language: en-US
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20240325224755.1477910-1-bvanassche@acm.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325224755.1477910-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/25/24 15:47, Bart Van Assche wrote:
> The SCSI debugfs code may show information in debugfs that is invalid.
> Hence this patch series that makes sure only valid information is shown
> in debugfs. Please consider this patch series for the next merge window.

Can anyone help with reviewing this patch series?

Thanks,

Bart.

