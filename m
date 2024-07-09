Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2E91B86EF;
	Tue,  9 Jul 2024 17:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720547998; cv=none; b=VryJccrXX2nICWKvGxC8R0PtNVIcdtw3lVuOUuORLlyeIf0O4OGAQWovc1w4c6Pu6cLB2ohdDU7bGcndtNK/f9Z+QPJpidUbG7BMtaBtC4FgWf7b/i0l3iP4RsdKcpvqw63k3LN0+FLol3zsu5xU63wqHAkIBsbb+6YQyyUlUjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720547998; c=relaxed/simple;
	bh=kzPOectY0Lhz4s3POHrD5myXWQ+NDvyXbUOrB4dMHDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=drOI/0iTGMUDDb6WJKG/SncOF1RuqxKTED2kRanuGyM6oAj+P1Bt2zFZeOsEKQSj6Q77QODC/ncAwszKMjjPKOah7vsac5ccJ55VZyO2+bcAkajhk8pLp0gAnunkO3hlJR+x0a5IVkEM6KRkv/6KNjw86T+r3lgTlrjTVV2yaYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=asYNggQO; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="asYNggQO"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WJTKS0GV1zllBcn;
	Tue,  9 Jul 2024 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720547993; x=1723139994; bh=7s4OEXe8wodJEdOc9v/S5tUI
	ZeURYyrHN4Qd5tto/uk=; b=asYNggQOdNHz4MQUeQF8xlTaRBIs1sJsPJ7cLiL7
	2kRehbELd68/6PUmaB3hpxfEpwN51wnDoeImxz9JH5K5QxaSWJXXITJYHhLtFd3B
	fS7VwGS1jUZXjPsnG8sC39pYAaZ0JV372Z3uL7/oxztTnTqV8FYhPSoNAlVLz62d
	DQ65xoivAgKStdn6uRe75sEr4QvyL0gXYyXjMnoXTjstWh/QZhuZcXu482w4aPXo
	PK+ZHY+blFqmMA8OPn6vEC8hoTB/IPipkSFNp4NrkKXg5lHg4ENf/rBmJqU6NuB8
	XqGtE9zVN4ipNZE6u++OFYWYdDO+AMW3ivfmr0qnSOBsmw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JjGMN8IDE_9w; Tue,  9 Jul 2024 17:59:53 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WJTKP0cYnzllCRp;
	Tue,  9 Jul 2024 17:59:52 +0000 (UTC)
Message-ID: <bd27804e-b7bc-4693-90ac-363591ac9467@acm.org>
Date: Tue, 9 Jul 2024 10:59:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v3] scsi: sd: Fix an incorrect type in
 'sd_spinup_disk()'
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
 James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Abaci Robot <abaci@linux.alibaba.com>
References: <20240709093948.9617-1-jiapeng.chong@linux.alibaba.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240709093948.9617-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/24 2:39 AM, Jiapeng Chong wrote:
> The return value from the call to scsi_execute_cmd() is int. In the
              ^^^^^
               type

> 'else if' branch of the function scsi_execute_cmd, it will return -EINVAL.
> But the type of "the_result" is "unsigned int", causing the error code to
> reverse. Modify the type of "the_result" to solve this problem.
   ^^^^^^^

What is "reversing an error code"? Did you perhaps mean that the return
value is changed from a negative integer to a positive integer?

> ./drivers/scsi/sd.c:2333:6-16: WARNING: Unsigned expression compared
> with zero: the_result > 0.

Doesn't this patch fix reading uninitialized data? If so, shouldn't that
be mentioned in the patch description?

> Fixes: c1acf38cd11e ("scsi: sd: Have midlayer retry sd_spinup_disk() errors")

Hmm ... that seems incorrect to me. Commit c1acf38cd11e changed the
indentation of "the_result > 0" expressions but did not introduce these.
Is this perhaps the commit that introduced the "the_result > 0"
expressions: ced202f7bd78 ("scsi: core: Stop using DRIVER_ERROR")?

Thanks,

Bart.
