Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC786E619;
	Tue, 14 May 2024 12:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715691260; cv=none; b=o08KKS21ZtgCHDXn12SpBxxKWAJI1WdvqZRdnSnno3hr4kapj+ajZ3G6McwN6IcOxOIUXUxXWdWtKcYZ5XnI7vBUGI7b9kYcV2c0WHA5R4nvexwBEPHx+ugmZIg5GBrXl+st5HQGPXQWhaDQsra4wqwX3s/Cv/AV2JMnxH1V30E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715691260; c=relaxed/simple;
	bh=iYe+iTT9bJoy3cwBZwJPP1x2mJu0Ck4/Nz+MnlFpoUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A2JXihDU9Mh2p2bVW9W3pXc9gEwoJ296ZecprbNX3tJZGGDb9GhDP/5AOxtZ3NTEJTtV6b7i6ARLNg5YWcgyKHLOtJQUFXfL5aq//EWsioicOuRZtcwX6AKZD5N4iWepTZ44cR+/ZLuT+nD/tsHD0dJkuD9vvp5eKQ1PVQrj0Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HO7KrzuT; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HO7KrzuT"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VdxBX2sgXz6Cnk90;
	Tue, 14 May 2024 12:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1715691250; x=1718283251; bh=HtoUS49dCeKeP1r1bZaXN4sx
	0vh3C9G4d85yLgm0N7c=; b=HO7KrzuTaa//zmrOxBlnOlek6TvPMkMpBJlZcny4
	IzPoCFGtSK3dAa9Z4eEzOS5KB8WyBEVZ+8UmqwRQhUK/ZH2DC3+G6byz0aaz3kOD
	XkKksoeWMULTDI4Ig/v+tTZV4erX2ouN7E1X1DYtsbZBborRxUiExgQoSiEkonnn
	iMJ/CmgwXqQ71OIK0Sjc/hE1CSMrz69UOLI9YIT0TYVomSmdhBmDP6g2nF7bQLgm
	O6/edAihTSkX+zGFaDa27ufdOs8CLPN8/YQDue5okg/xvgx26qgHgb/78qU4Km4/
	/c2gqeUci6Q5s8ShYbuZv6TOcwXqIDqe2YmpnhTKHz/joA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VmpcSeklmOV7; Tue, 14 May 2024 12:54:10 +0000 (UTC)
Received: from [172.20.0.79] (unknown [8.9.45.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VdxBT3gFwz6Cnk8s;
	Tue, 14 May 2024 12:54:09 +0000 (UTC)
Message-ID: <34c50f23-82dc-4b53-b8cb-e5c07c6e0106@acm.org>
Date: Tue, 14 May 2024 06:54:08 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: ufs: Allow RTT negotiation
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240514050823.735-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240514050823.735-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 5/13/24 23:08, Avri Altman wrote:
> +/* bMaxNumOfRTT is equal to two after device manufacturing */
> +#define DEFAULT_MAX_NUM_RTT 2
> [ ... ]
> +	/* do not override if it was already written */
> +	if (dev_rtt != DEFAULT_MAX_NUM_RTT)
> +		return;

I haven't found any text in the UFSHCI 4.0 specification that says
that the default value for the number of outstanding RTT requests
should be 2. Did I perhaps overlook something? If I didn't overlook
anything, the driver should not try to check whether dev_rtt is at its
default value.

Thanks,

Bart.

