Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D292F1FA254;
	Tue,  8 Oct 2024 17:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728410299; cv=none; b=Q2/gBmWizzzD1sO8FAXpOEgDjKDo/1+KpAa6MzNqNxYLWqVXEhklM9EjT8n+svHoIEr/r+9Fiy+tkGihG6bfJDPlM9hZnEqxfq8mMv/YMJannQHiGfK0wYsoSV1c/pCMxliSj3fJFepSoF1NV04KpxSbXVnoQAutnNqND+qk+20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728410299; c=relaxed/simple;
	bh=4U1UeKZlaCfqzLoEn1fO7sTNMI+RyozZNZBl5ZowbL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l/m7L7k7RK/kaj/tWYwgCmvmrONw+q4Fr6cUhdN4OkSY7jry2mq0JiECPavnCbcxN0qSZqcUwcg2im1uCW+gXqnBg8MBvlslAAGnxooIhPYx6YCVj40cS6GllXBMxIrf3xFLhFHkG9KLbhlu2CRiqq80bF9Z0V7oO7mqxC0Xmus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=H7lFaxRn; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="H7lFaxRn"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XNNzR62Fhz6ClY9T;
	Tue,  8 Oct 2024 17:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1728410285; x=1731002286; bh=4U1UeKZlaCfqzLoEn1fO7sTN
	MI+RyozZNZBl5ZowbL4=; b=H7lFaxRn1xw2wn2LDW/u/CpFkHpOGamVeOWYBS2V
	DvVGxY2G/0hXDL6K3bdlwOuzluAFfY5DUR3k540PvQ39xfiWIjGJJDrKjUMkIt1L
	Jom7OQcOXiLbUS6y555iHeCL6ZdEFva2JnlGwH+chppj2elhO1XilUWhU1X4JJKu
	IwQPDF0QbwB6HK3WjYptr0lyhIiAtqBlgl7586RVz0yfZ3TnRhAAa1mxBG84I6rO
	twIIKHQudjdrHkn2Ax69JihAtZ2glxBA61ksF4y199nvRz5ROUg9jZ/3PWxxFW2B
	ieK2v1VDbFmwDYMKvAlOKQVh9VgybWyG7jZf80DywNaVHg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id w_FNwSulsJTo; Tue,  8 Oct 2024 17:58:05 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XNNzG0VGhz6ClY9R;
	Tue,  8 Oct 2024 17:58:01 +0000 (UTC)
Message-ID: <210ebb75-d384-4787-9e1a-d08643cc4843@acm.org>
Date: Tue, 8 Oct 2024 10:58:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] ufs: core: set SDEV_OFFLINE when ufs shutdown.
To: Seunghwan Baek <sh8267.baek@samsung.com>, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com, avri.altman@wdc.com,
 alim.akhtar@samsung.com
Cc: grant.jung@samsung.com, jt77.jang@samsung.com, junwoo80.lee@samsung.com,
 dh0421.hwang@samsung.com, jangsub.yi@samsung.com, sh043.lee@samsung.com,
 cw9316.lee@samsung.com, wkon.kim@samsung.com, stable@vger.kernel.org
References: <20240829093913.6282-1-sh8267.baek@samsung.com>
 <CGME20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64@epcas1p3.samsung.com>
 <20240829093913.6282-2-sh8267.baek@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240829093913.6282-2-sh8267.baek@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/29/24 2:39 AM, Seunghwan Baek wrote:
> There is a history of dead lock as reboot is performed at the beginning of
> booting. SDEV_QUIESCE was set for all lu's scsi_devices by ufs shutdown,
> and at that time the audio driver was waiting on blk_mq_submit_bio holding
> a mutex_lock while reading the fw binary. After that, a deadlock issue
> occurred while audio driver shutdown was waiting for mutex_unlock of
> blk_mq_submit_bio. To solve this, set SDEV_OFFLINE for all lus except wlun,
> so that any i/o that comes down after a ufs shutdown will return an error.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
