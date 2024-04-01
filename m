Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC471481B8;
	Mon,  1 Apr 2024 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991412; cv=none; b=cERhnDxww2WKc1EoI1vWEDqIT9wNjIuRXIS9FPDjxoaxCSFl1+vAJhCzvPYm3Sj0LiBH0ss1YFJEqR0JlFAajHmysIwlRzJRn1kBJNIYu/RVn+r27U68vT02odc/tCaVqQUhYhdGHizEJOPV41Yn/XmVVG2kVMub530QO7FAM+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991412; c=relaxed/simple;
	bh=OHHDYqVdBQMR6VKojyn4SweMs/KowhBYCBTrwuIvjig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WfjTZzmCAnMaEn3miJgyQE4T8dbL0BaSpMQP9WqWPCeAC3uBSjSxhhqDArruQEeyv8Izx6A2R7J70NQI8g45LbqdLz7iN8mqwzi0VrXJJkWe+k7BM3nqbEdj+Zbm80Mhe+C/EZ/6G6BOYQqDT0+yhIti0dYs38hAQ8i9RlZ/fVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=p6lG2fJP; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="p6lG2fJP"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V7cvb1rNyzlgTGW;
	Mon,  1 Apr 2024 17:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711991399; x=1714583400; bh=1o92p1iKBdPwfQBISSmyjUU6
	GZIxSKmRhiV8vXyFFZ4=; b=p6lG2fJP23uiQWdoS1ZScT3P/vz53S3CxFGmauwX
	oF9cRXI0lSm9Ov4Lgf2TboIScLi2BviC2rn1nbjsXPxaZ8MdtCKnNAnLqbfW6hh/
	c/uaoFuZ7Mws98IHyVm5zJa+4caGwJsshCFU/Vt+pgmZvQ4JoxOpgJRWiErZYVG0
	+2Gfo2kJFcfIV8F9yE/ZcS8v8SL+JhJ5L5+fPyNCSoxqp+D7cZKTM8OonA0iWjWG
	jPpCaHl9tfZ8xq6YO74wFcMb1qFCd0CXaWgNuFK0+B/XvyrssVWFFQPcNhWMx5xa
	QfU2+PUGAysY6nPHeqZesz9l/8FnaghI9dw/VHx4Md/crA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AmvmDwiwV-Af; Mon,  1 Apr 2024 17:09:59 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V7cvV68vmzlgTHp;
	Mon,  1 Apr 2024 17:09:58 +0000 (UTC)
Message-ID: <a8b8aabf-250d-46c0-a9b8-fba414e3cfcc@acm.org>
Date: Mon, 1 Apr 2024 10:09:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sg: Avoid race in error handling & drop bogus
 warn
Content-Language: en-US
To: Alexander Wetzel <Alexander@wetzel-home.de>, dgilbert@interlog.com
Cc: gregkh@linuxfoundation.org, sachinp@linux.ibm.com,
 linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 martin.petersen@oracle.com, stable@vger.kernel.org
References: <81266270-42F4-48F9-9139-8F0C3F0A6553@linux.ibm.com>
 <20240401100317.5395-1-Alexander@wetzel-home.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240401100317.5395-1-Alexander@wetzel-home.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/24 03:03, Alexander Wetzel wrote:
> commit 27f58c04a8f4 ("scsi: sg: Avoid sg device teardown race")
> introduced an incorrect WARN_ON_ONCE() and missed a sequence where
> sg_device_destroy() was used after scsi_device_put().

Isn't that too negative? I think that the WARN_ON_ONCE() mentioned above
has proven to be useful: it helped to catch a bug.

> sg_device_destroy() is accessing the parent scsi_device request_queue which
> will already be set to NULL when the preceding call to scsi_device_put()
> removed the last reference to the parent scsi_device.
> 
> Drop the incorrect WARN_ON_ONCE() - allowing more than one concurrent
> access to the sg device - and make sure sg_device_destroy() is not used
> after scsi_device_put() in the error handling.
> 
> Link: https://lore.kernel.org/all/5375B275-D137-4D5F-BE25-6AF8ACAE41EF@linux.ibm.com
> Fixes: 27f58c04a8f4 ("scsi: sg: Avoid sg device teardown race")

The "goto sg_put" removed by this patch was introduced by commit
cc833acbee9d ("sg: O_EXCL and other lock handling"). Since the latter
commit is older than the one mentioned above, shouldn't the Fixes tag
refer to the latter commit?

> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 386981c6976a..833c9277419b 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -372,8 +372,9 @@ sg_open(struct inode *inode, struct file *filp)
>   error_out:
>   	scsi_autopm_put_device(sdp->device);
>   sdp_put:
> +	kref_put(&sdp->d_ref, sg_device_destroy);
>   	scsi_device_put(sdp->device);
> -	goto sg_put;
> +	return retval;
>   }

Please add a comment above "return retval" that explains which code will
drop the sg reference.

Thanks,

Bart.
