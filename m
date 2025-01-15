Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776131D5ACD;
	Wed, 15 Jan 2025 17:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736963748; cv=none; b=cuRj/fFtRWyuJ2qJ5qdzoKABiZtb/qqGTQcOwl9VGjLNfxWVjZ00ofxUvQbudKzOZ4x87zkIoF8fHVAFOzoff+pQhUicO/tiZ6eRO2f0pxA/cxFiFoY4z4CvoouONKs3J30ucs05WAesF33rOUH0yc4l/2/OzGR594IzVK8c08Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736963748; c=relaxed/simple;
	bh=HbHc1Quug4HxfGhl/QO/zqGx+tczUS6Yp94AgXrY4W8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aH36ZzZRlTPh7r50iHt/wDZlK8dfJ5io88JjFYv9m07SfQ7s+Q8ZDpU5Odje+oy6woxPSBx4dP5XkxgpJaXpf/SwCUEzX02BPgcw492e4xwo1oBwQEWRHs82YGsv7c6UDIKYnpgtNdc44AVsuy/OThbOu0T9anlboi/ovdMaYtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lI3WTSMv; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lI3WTSMv"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YYDDr1Zrvz6CmQvG;
	Wed, 15 Jan 2025 17:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1736963737; x=1739555738; bh=IQrPPk8ZI7YwkkdlknsnWs+0
	0ELKasS1f0dJeFLIpvk=; b=lI3WTSMv0lZB8KmRIi23VE3TW8SAmxcVflkbPt4Q
	h6XwKjJN2ogCyg1xt1IeVhlkEWbnkdpcSLoNurnOlPOjQme/BOqwBQTm7cmMh29E
	Xqh5jyyP/Wue78NdR8p/OcuLXZLqzTK5iA1qyD83EcY/e4rcMfDN/chL3GXKMIst
	MoK2WPers4/+xluCCgbIseUgO26YUSpD/B9lBBxCfzMfxvEtvojz7yijCAYDp/Qa
	Vt1GjcScmmRTStIcJ/CM0dD+R27Bx4E+dFDm1GBmyvZ+7E10qiYE4Fe6OziAavLX
	TAhMfiJVlHvAISTG8LmaEkGFtJQPld6st1YN0TM8zILAiA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id y7cC8bSKdE8o; Wed, 15 Jan 2025 17:55:37 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YYDDm0zYVz6CmR09;
	Wed, 15 Jan 2025 17:55:35 +0000 (UTC)
Message-ID: <f595edbb-8b34-4663-97dc-07b7ec0d62b5@acm.org>
Date: Wed, 15 Jan 2025 09:55:34 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Simplify temperature exception event
 handling
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Guenter Roeck <linux@roeck-us.net>
References: <20250114181205.153760-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250114181205.153760-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/25 10:12 AM, Avri Altman wrote:
> This commit simplifies the temperature exception event handling by
> removing the `ufshcd_temp_exception_event_handler` function and directly
> calling `ufs_hwmon_notify_event` in the `ufshcd_exception_event_handler`
> function.
> 
> The `ufshcd_temp_exception_event_handler` function contained a
> placeholder comment for platform vendors to add additional steps if
> required. However, since its introduction a few years ago, no vendor has
> added any additional steps. Therefore, the placeholder function is
> removed to streamline the code.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
