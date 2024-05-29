Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE7126AD3;
	Wed, 29 May 2024 20:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717013566; cv=none; b=b8CSKJ6u0oDNp9G+pUtmuGZbVTe2Dk/W4tybCI4H2MjaPJSJ4yNkfaPr5a1bZyW3w8MtiAWe0gABrgI+upYeUlR1OjSFvPnS38iZxCyunI2VDGY1grmLAssYLstcet0P+UkhAnsPV0c/dRjM9nRVmneR7ObjrLIt55Bx2P6PFkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717013566; c=relaxed/simple;
	bh=1bhLZpjpBAAkJRT8AqeZYTCxTGjw//XFZbioD/g1dEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oiNh0ehgusKgysMdMKadPLj4+jlxfUTaCERY5J9s6DT7V+rH4+QOhzQW5Qt3D+6RMjhx+EJQ1D/k+HnBpWWbiKd3z0N809OXupt7/uU6/OC9bqGV56rSQ8UUFOEb1+X8U7iHAc0+GburpNY41UijajQkB9LP6ibYkf4j4ti6e6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wpN4y1a9; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wpN4y1a9"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VqLCc2DZvz6Cnk98;
	Wed, 29 May 2024 20:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717013562; x=1719605563; bh=sYFO1Oabf5gp0E80FPASdVqP
	HBMAvbLEasvnOxSrWEA=; b=wpN4y1a9SYlb8ekZfZy9MDBShPQRKTgmXkXP1Yyk
	SNLcg8KCd9ZHOyxvSEylU9UDX9E0l361iFZtdv2xbtsnaFzNUaiMCvZPr4VFseGg
	WtAMo01W8TW0h4uZnI2Ck3jnePIOlNq8WKi57YMl905CDoEO1WiyJdmJbMizI1Ph
	ESYNdEEwRaumSSeK5r9XsPSIiGDxQ/46stnrUhr38jzJPLRwRJW1JZHdgQRs2+Qy
	pGSm6bQe3I932PYbshEG6MW4/UPtT3Y/DqZryigKjvhfLk62pwG9ZI89d46hVJpP
	bMLc8Wcl/QgzI8ioWuJMllrYiBLLJHR6vT8sWMU+hCslUg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yqIE7em82E3h; Wed, 29 May 2024 20:12:42 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VqLCX5zTyz6Cnk97;
	Wed, 29 May 2024 20:12:40 +0000 (UTC)
Message-ID: <0555169e-2552-41d8-a515-8c394118cec7@acm.org>
Date: Wed, 29 May 2024 13:12:39 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/3] scsi: ufs: Maximum RTT supported by the host
 driver
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240526081636.2064-1-avri.altman@wdc.com>
 <20240526081636.2064-3-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240526081636.2064-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/26/24 01:16, Avri Altman wrote:
> -	rtt = min_t(int, dev_info->rtt_cap, hba->nortt);
> +	if (hba->vops && hba->vops->max_num_rtt)
> +		rtt = hba->vops->max_num_rtt;
> +	else
> +		rtt = min_t(int, dev_info->rtt_cap, hba->nortt);
> +

Shouldn't what the controller supports be compared with what the device supports,
e.g. as follows?

min_t(int, dev_info->rtt_cap, hba->vops->max_num_rtt ? : hba->nortt);

>   struct ufs_hba_variant_ops {
>   	const char *name;
> +	int	max_num_rtt;

Hmm ... why 'int' instead of an unsigned type? If the type would be changed
into 'u8' (the type of rtt_cap) then the above min_t() can be changed into
min().

Thanks,

Bart.

