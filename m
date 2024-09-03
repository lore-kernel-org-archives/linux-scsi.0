Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0C71D5CC6;
	Tue,  3 Sep 2024 19:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725391143; cv=none; b=rJQ0ruvkOBqGFFJxxMpJfYOIrDVuZl5l4iSt7jzbk41lH+qM32hTzhFvfHhd3e0nLsC+fMdtL/IgGFaoJhNrFrmlMe+NMdqNDOIKn4UkddqsXrW6PrK44VPyJpOLax2P7UD/WmMo+IFBLqZjDjVc5FWVuicyuiuCrdn6iuK1Khc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725391143; c=relaxed/simple;
	bh=C6tyTlzrvQ744QWHSoF7W4UR1hVGzE0ndrYG0/hpzi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CTyebVzMzjjMD8i+vSH+qqIIScZnyg4CP2JyfTvdAeb5H0WTcE+NZgqCM6pzG6JsTdRTLotzAJv1ISX9DNyPjXpdMQuwSUhFNFmtOZtPXgHYSmii3GFLls8Hjfruw/gZIk36PnLCmO6SZWEbLpESx/HdkTqNWMZZkZAtRVk6yYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nq+KH05I; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nq+KH05I"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WywQr4RVlzlgTWR;
	Tue,  3 Sep 2024 19:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725391138; x=1727983139; bh=coBZ9lyHTBRDqRpSWT44D/Qb
	8lF4EuJZ+HhHtbYLR84=; b=nq+KH05ICOejEbF/Vx9An/ZPSCrbZ9al6t60YGnM
	3+jcmjDwTpzIXxAkK8yP7ETk41ppy6mTmftCMkt774RTyHjswE3KB+tftKBfYnSZ
	HMgckfje6oChlcucWYiR7YbDc6tuMAhPAp9Mg0okrfrKugfAcmtpHCpB6JJvlxM3
	FpwfByf1NTuQ2tglPUEvyFryOmRIjfYNRstqkIRRSFmBYNwOj9hce30NthTMVdde
	i/bOo9AUXgAW8kEWmBSKdJ4ekoq9QfG1za3cIxm1094ZwmQ84DFwvvTFOHPDVutd
	WOTKz1vdWL4k3hkppWC3hA7oShOjaDJb8sZJySmiP9QZ6A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XDfrxYmerwhi; Tue,  3 Sep 2024 19:18:58 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WywQn6JmnzlgTWP;
	Tue,  3 Sep 2024 19:18:57 +0000 (UTC)
Message-ID: <b7f0acf4-5e7d-4491-81be-71518197c58b@acm.org>
Date: Tue, 3 Sep 2024 12:18:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: aacraid: Fix memory leak in open_getadapter_fib
 function
To: Riyan Dhiman <riyandhiman14@gmail.com>, aacraid@microsemi.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240903185410.21144-1-riyandhiman14@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240903185410.21144-1-riyandhiman14@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/24 11:54 AM, Riyan Dhiman wrote:
> In the open_getadapter_fib() function, memory allocated for the fibctx structure
> was not freed when copy_to_user() failed. This can lead to memory leaks as the
> allocated memory remains unreferenced and cannot be reclaimed.
> 
> This patch ensures that the allocated memory for fibctx is properly
> freed if copy_to_user() fails, thereby preventing potential memory leaks.

What made you analyze the code modified by this patch?

How has this patch been tested?

> Changes:
> - Added kfree(fibctx); to release memory when copy_to_user() fails.

Changes compared to what? I don't see a version number in the email
subject.

> @@ -220,6 +220,7 @@ static int open_getadapter_fib(struct aac_dev * dev, void __user *arg)
>   		if (copy_to_user(arg, &fibctx->unique,
>   						sizeof(fibctx->unique))) {
>   			status = -EFAULT;
> +			kfree(fibctx);
>   		} else {
>   			status = 0;
>   		}

Just above the copy_to_user() call there is the following statement:

	list_add_tail(&fibctx->next, &dev->fib_list);

Does that mean that the above kfree() will cause list corruption?

Bart.
