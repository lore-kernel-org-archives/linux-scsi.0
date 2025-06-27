Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75DE258CE8
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 20:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751057641; cv=none; b=dtATdpTaN676HAUvNfW7NkU7mRQ6rShSHqKUtQzKLBR2eYqnu8zpS222Ir9CzFA3hnaCATNxjbuA1+j47imuuE0fkZGnRwGv0SDJwLMUoaDidgkxXjHI8jL/c9zEc+yMdsYqUyup7XJot9u+lsu0OP3SiLM0tlTx/zaVznZfMBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751057641; c=relaxed/simple;
	bh=jQnbCAt92ZTIQ6zDGGeLPvn1fXN17yc+ucOGRP3mE9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SH7VwHUzCe/klskglT+YgWG0hINoafqmmWvyQrW6egebi8kNPZRgEhav4Myo8gPPbyWASxvbUxZ8m0KmHAS/eg4Nxtnt0tZeQDaB+E4/i5M4ZFGAqE49KfHSztGFg0HxTxseeVqkIunNoQM87J66angOTy4V9pzPr+IcCFwHxOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UoYw3Ttn; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UoYw3Ttn"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bTSTD2zmnzlssxm;
	Fri, 27 Jun 2025 20:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1751057631; x=1753649632; bh=DyVWalj1NfVtV+DeAfuKf2G2
	1ywBjwmIpsbezV/FaSA=; b=UoYw3Ttn3QsaTcsgHWPrQT2IO1vkUOhat3VWCtGk
	HGnOGonhsHh3tJ8hHbVhvrgTV7MBLODiYKBZjiYTtOnwsRh5yMh0bnh90P0fM0yr
	XwrI1Qup57vgm74BP0vo6e5wsv0FaaFw4uI3PSEgCiQ+ISj4cOsy044hxhy1p4Io
	fvGVzPull6njq96KZMLi3qDickpbOFcFt098Y1UgDr89APYJ6njY8VAUdO9hMItn
	yN9cxPNDbCZ3nBcTFAdiv6JGGr0Lj2gEVDpb5hiWF/v3J6RmtnIP564vSOb/82EH
	gQ5pWW8lzuTfKCw4QeyqDcbjkELIS/Ygk2ugOVdFWa7UfA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ePRU34gIjdZR; Fri, 27 Jun 2025 20:53:51 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bTST818ktzlstRW;
	Fri, 27 Jun 2025 20:53:46 +0000 (UTC)
Message-ID: <4ded8779-9987-465a-8c13-3de42321032a@acm.org>
Date: Fri, 27 Jun 2025 13:53:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sysfs: replace scnprintf() with sysfs_emit() in
 sdev_show_blacklist()
To: Shankari Anand <shankari.ak0208@gmail.com>, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
References: <20250620105344.455283-1-shankari.ak0208@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250620105344.455283-1-shankari.ak0208@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/20/25 3:53 AM, Shankari Anand wrote:
> Documentation/filesystems/sysfs.rst mentions that show() should only
> use sysfs_emit() or sysfs_emit_at() when formating the value to be
> returned to user space. So replace scnprintf() with sysfs_emit().
> 
> Signed-off-by: Shankari Anand <shankari.ak0208@gmail.com>
> ---
>   drivers/scsi/scsi_sysfs.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index d772258e29ad..074b02e4cf9e 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1095,14 +1095,14 @@ sdev_show_blacklist(struct device *dev, struct device_attribute *attr,
>   			name = sdev_bflags_name[i];
>   
>   		if (name)
> -			len += scnprintf(buf + len, PAGE_SIZE - len,
> +			len += sysfs_emit(buf + len,
>   					 "%s%s", len ? " " : "", name);
>   		else
> -			len += scnprintf(buf + len, PAGE_SIZE - len,
> +			len += sysfs_emit(buf + len,
>   					 "%sINVALID_BIT(%d)", len ? " " : "", i);
>   	}
>   	if (len)
> -		len += scnprintf(buf + len, PAGE_SIZE - len, "\n");
> +		len += sysfs_emit(buf + len, "\n");
>   	return len;
>   }
>   static DEVICE_ATTR(blacklist, S_IRUGO, sdev_show_blacklist, NULL);

This patch changes correct code into broken code. Hence, to the SCSI
maintainer, please do *not* apply this patch.

Bart.
