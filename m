Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8384399E3;
	Wed, 22 Jul 2026 18:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784743721; cv=none; b=jmll6kS/kjuMCkPE0XfQVE8kIOW+9FgOXRy5+mIKnC+z/4SwxBIXKaAjx4FNZPyVFIxd0b69gX3BKA260164gFpPYH4m7IleA67ayWDen9FzLnKMEPRDwDhr3KUerhJyTnJTKvRf+T2udoB5mJfpJEEk4CiTzUEmZmcch5u7vpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784743721; c=relaxed/simple;
	bh=q3+IpMuC2sGf2wD1tE+uJ4c/oj72l8Jyvp/Jv+Dbj9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RDivTSQBi+VBU1RLA7E+O8s+xvJ2zskMEaNBE/LRlujyVnYnYRZDPyUVgRWv1DdP9ordOAlEubXOaRHFJ5KfI/tT9fgvpvDAOFNr/s7uPmU2+fzLGWX4dJVQkmwnDhNLL39NmX0rH5yqmpFg48gRYIB4PFdpem8rYhS4kxPM+C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IL8IVG8s; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IL8IVG8s"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h52Lb1qjTz1XM6JW;
	Wed, 22 Jul 2026 18:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784743713; x=1787335714; bh=bO5B19BLJCr+G0dzAzPZkjxH
	IZJbuRc8Vvqa9OvGsjU=; b=IL8IVG8sqdfW6kNDZTWUahm16lkfEAu+xxzOyzJ2
	OZBTj+vuquYhlKAFmcAInpPTFetma/Pf3dJ+h8BGxZNIblixmySntkTYvskGxRK+
	qvmDxXv4E47x7LWhqdqPWaOF0/VO+IiL/XXidLpfQS+PuG0un7iItOUS99fkymbV
	JJb8IpuU+upzIUnWTC0yx+A4/kWvupPH4tmQgUiIzLMHPa3+aPWvawX2RZeXuXJy
	/GzcH97XTOoDXM/tZvT+pr6qVvbMN8kS7rmkCdpPFepaOotpfKyGfdXy0aITYONs
	KpuQWIUoyT6VdOOBDVMtCO4eLWalcFaufbq4IgvThMGtrg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dTJGab0d3ZS4; Wed, 22 Jul 2026 18:08:33 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h52LQ07wmz1XM5kD;
	Wed, 22 Jul 2026 18:08:29 +0000 (UTC)
Message-ID: <ce9beb4b-a65e-4547-a809-1dd30621966f@acm.org>
Date: Wed, 22 Jul 2026 11:08:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] scsi: ufs: debugfs: Reserve space for a string
 terminator
To: Li Qiang <liqiang01@kylinos.cn>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com,
 can.guo@oss.qualcomm.com, adrian.hunter@intel.com, tomas.winkler@intel.com
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <20260717153914.26321-1-liqiang01@kylinos.cn>
 <20260717153914.26321-7-liqiang01@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260717153914.26321-7-liqiang01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/26 8:39 AM, Li Qiang wrote:
> ufs_saved_err_write() copies user input into a zero-initialized stack
> buffer and passes it to kstrtoint(). A write that fills the entire
> buffer overwrites its only terminator.
> 
> Reject an input whose length leaves no room for the trailing NUL.
> 
> Fixes: 7340faae9474 ("scsi: ufs: core: Add debugfs attributes for triggering the UFS EH")
> Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
> ---
>   drivers/ufs/core/ufs-debugfs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
> index e3dd81d6fe82..be527209540d 100644
> --- a/drivers/ufs/core/ufs-debugfs.c
> +++ b/drivers/ufs/core/ufs-debugfs.c
> @@ -165,7 +165,7 @@ static ssize_t ufs_saved_err_write(struct file *file, const char __user *buf,
>   	char val_str[16] = { };
>   	int val, ret;
>   
> -	if (count > sizeof(val_str))
> +	if (count >= sizeof(val_str))
>   		return -EINVAL;
>   	if (copy_from_user(val_str, buf, count))
>   		return -EFAULT;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
