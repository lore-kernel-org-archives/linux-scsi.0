Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36B5215F51;
	Wed, 22 Jan 2025 18:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737571168; cv=none; b=Rw4CW+xT1QJUt3lCWxvg19Wgiq4xpJFVSQo1uN+d+hg7WhSNrzp+kP8ifMdVub2/KMP7DwWR66ivMUvKiv+cyZhGxRqAsrUeoCMJbEw1eNQRL53F+MDemX/3uLo461gxtM9E/Fj8uD/GsZA/9dMpm6tX7lUMYvMYKtd+GpzrYpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737571168; c=relaxed/simple;
	bh=7mQT8NfBJwt4YIHU+6h7LTOlV6/ISO078k8rQaIQcFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m6DYHXs4R6vaPSwf0rWnS+yD6/uXGWO9dQF4Cr99P70MzGGK9msHbdrBjfJsmGT7+FUOoh+5n8gDk7p1qw6J6POCNMS8ADnq6L+mF5bi9/6+FsLCYtBknK1Q9oglf1ST04fYyMkeRVZRkN5CKYMCKjNjP5rYjyZYF5VTSPr7JrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gyYpQd57; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gyYpQd57"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YdXt61pYKzlgT1M;
	Wed, 22 Jan 2025 18:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1737571163; x=1740163164; bh=ABzAhPxkmkfIph53hNNx+oSf
	N92jBAyOPc/Pg68nUgs=; b=gyYpQd57gl8lhax6EJu/KFk9Wyn+wytI2K2orDt/
	KJC2KUBA+nuCYBflvGcNyOX8fNzqJGHiSYE3LtDqR1eARh2L3yqqEapcKDPZoXDe
	IdTSGksC0W3aqLsP+VyQDOIwLBD3HOJGHZz4tMGirdE/iqJrJT6hY3iEE30RQSN+
	G0kpyPB+fTwPxLfwRae2r1h+64SkQPuT1WMcIqaRe/F+6hEvrgxz0JFo+rcJYTkA
	QkvVt1mwtxhk/95a/ogRjprNM2okshGq+rj4CzhyW5r1BoviZfVB+FLYAWq9Rldr
	6XUQlNuTOT/LxvSjzNwuJDx4k0T7Jtgc3mnQwQ4pQkoDPA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tG7ZwC_C2IKn; Wed, 22 Jan 2025 18:39:23 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YdXt13cHjzlgTWQ;
	Wed, 22 Jan 2025 18:39:20 +0000 (UTC)
Message-ID: <52d287b6-f6e4-4644-aef8-2c22bff59613@acm.org>
Date: Wed, 22 Jan 2025 10:39:18 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Move clock gating sysfs entries to ufs-sysfs.c
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
 Can Guo <cang@qti.qualcomm.com>
References: <20250122143605.3804506-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250122143605.3804506-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/22/25 6:36 AM, Avri Altman wrote:
> +static ssize_t
> +clkgate_enable_show(struct device *dev, struct device_attribute *attr,
> +		    char *buf)
> +{

The above formatting does not conform to the Linux kernel coding style. 
Please fix this, e.g. by running git clang-format HEAD^ && git commit 
--amend on the git branch with this patch.

> +	if (kstrtou32(buf, 0, &value))
> +		return -EINVAL;
> +
> +	value = !!value;

Please use kstrtobool() instead of the above code.

Thanks,

Bart.
