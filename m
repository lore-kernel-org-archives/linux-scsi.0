Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D333AC0C5;
	Thu, 12 Mar 2026 19:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773343995; cv=none; b=bsklcal4RiclcQdnzzkVcRNRrHgD8seCDPoVbPluhAi9c87IGJeqXYuY+16pW4LrB+eDx4Sy3alXNxpwwZ23JKvqCSX0sCdAhKPuRhv7vZJyLCM3NxlIy/M9yjfBUMNvK0HkYHtVpkgXP5a4w6FhFno9eIHWsOZGzCwFBUd5/L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773343995; c=relaxed/simple;
	bh=Bl1MkRTMlK071o3hwVuTuiY5TEiIohK2VvBTvQkiQNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=avkrqKydq4uZKWIPI89PC7OddX9EKRjG9C6t53e127JBwfsV/LC2CAZPIva42IDXbjodH85t0Khy72D0lBGI1dji8xTzs/hruJuddoDvttucOXd4c1lXRCUqtK9eFf5scSh6paT007zIOkEyVSe/4GPo4Ltw125YpwekDil+k1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=y/Mep5Iq; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="y/Mep5Iq"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fWyT55J44z1XM6JX;
	Thu, 12 Mar 2026 19:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773343990; x=1775935991; bh=+FY1r4B1qhwbz73N8bQiuVsJ
	PRit70J2+np02N9T/1c=; b=y/Mep5IqBlUXdgFjPIaxCReQLcsv1JjgHi/Mwbxd
	MXjXL/q8HhK+ff/cIqL+tUlFLEjlO2c5UoH6oN/cjOs8D//0pwwM9vs6G2GsEFQK
	w2JaU3hXqmjvGVqlGi/fBZR4lLh3rbIvoQJWdIuZYY59M0rrRJmkM5zkS2/YmOkq
	6/60VsD9cFXkxMwfK1rlFi9Ssm75EJT0lrHvx8r/d3L9qrmL9SVAW6uOreGrwopP
	C31jENpVkH7Fsz1vG8KjdejblkAz60fEJiHyBgUsbVEw15LQnOlOTFZejeMBVrsg
	1ZeowOYGAnKQvH5fpwYxxonroi8kSbztJr0zZi1xg72u2w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3sqN4gWjBOhD; Thu, 12 Mar 2026 19:33:10 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fWyT10gpdz1XM31H;
	Thu, 12 Mar 2026 19:33:08 +0000 (UTC)
Message-ID: <96545a0f-2cdf-47ae-bf15-bfb33a35c799@acm.org>
Date: Thu, 12 Mar 2026 12:33:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/3] bsg: add io_uring command support to generic layer
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, axboe@kernel.dk,
 fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260312092237.2464560-1-yangxiuwei@kylinos.cn>
 <20260312092237.2464560-3-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260312092237.2464560-3-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/26 2:22 AM, Yang Xiuwei wrote:
> +static int bsg_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
> +{
> +	struct request_queue *q;
> +	struct bsg_device *bd;
> +	bool open_for_write = ioucmd->file->f_mode & FMODE_WRITE;
> +	int ret;
> +
> +	bd = to_bsg_device(file_inode(ioucmd->file));
> +	q = bd->queue;

Please combine the above assignments with the declarations of the
modified variables.

Thanks,

Bart.
