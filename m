Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DAE20EB
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 00:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755044002; cv=none; b=eietBmJWzf9dUkbFljQbvfXehoTPmohJQuYYs2RhNdsWAlnpwYZ5kFMsk7v+9D0UDJR6P/+T5tWriYQ+k4pFfYkfVPW1z0cX6vWP7xKnlfZRdMliIVqc5M1thBXqodHhiK0FHcGNQWDLU1Yp16/Xpqt1lI4DEchP1ctR8TB/OAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755044002; c=relaxed/simple;
	bh=lqM8ttT1xaNFVvInPFGCVNoW0eBZuv+kHqg5FCcyNB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q0tfIz8b4oPAqVv5Xh3RRcLxP45OyXFzmCNqsqaBnqaDVSAjP0PMqvPbMnvz/ttyhnKjNSUV1185mmpRPK3LF8mVRw5U80JE8Lv5Sp+EXNHx29kzqJSv62KiSYZPijnLcbIbaZ12fw2DkcAMcUdHEHGhvZgYNBkjGdaLmnj5WgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2qF6JQBk; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2qF6JQBk"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c1pk64hBwzlgqV4;
	Wed, 13 Aug 2025 00:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755043996; x=1757635997; bh=ur8WI4eEQliJMFdnn9xflbrN
	ZjJ6T4KY2yLf+pXpmnc=; b=2qF6JQBkVYLCgAcoFjlfPz1dt6oNiuywJftrq1DQ
	BvTthWusOCBixYVMT9TE8zFHcdn/zZxUxnJIbb5ld8Y7swzXeOJHgZFH8qDWK2SB
	fl8Sfw5nLOeJ4HPTPhJnEhL26YxdDA8/aanQRPpjSmAtdoT0RuBRDj9qoajJcDSo
	qf9UkM784bh8WuBAh35QXnaqTRXAxD1wWPERlf7fx+L/E+h39TCfk4TR8j1PLIjb
	YloKJJ3AOTTqs10lKnHSWU3zse8AbSxSb0Wpz+qzxS30QIDnarRGt7hsd6Ad9aHU
	x7ZB3JZQBxRdnLW+kC74gAZnHDkQ9s/8l363ZTzimUU/nA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NEtJx2VdFqNN; Wed, 13 Aug 2025 00:13:16 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c1pk06Nhszlfl2f;
	Wed, 13 Aug 2025 00:13:11 +0000 (UTC)
Message-ID: <adf6c004-5d51-434f-96cb-fca1d14214c2@acm.org>
Date: Tue, 12 Aug 2025 17:13:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] scsi: sd: Check for and retry in case of
 READ_CAPCITY(10)/(16) returning no data
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250716184833.67055-1-emilne@redhat.com>
 <20250716184833.67055-5-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250716184833.67055-5-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/25 11:48 AM, Ewan D. Milne wrote:
> sd_read_capacity_10() and sd_read_capacity_16() do not check for underflow
> and can extract invalid (e.g. zero) data when a malfunctioning device does
> not actually transfer any data, but returnes a good status otherwise.
                                       returns?

> +		if (the_result == 0) {
> +			/*
> +			 * if nothing was transferred, we try
> +			 * again. It's a workaround for a broken
> +			 * device.
> +			 */
> +			if (resid == RC16_LEN)
> +				continue;
> +		}

Please combine the above two if-statements into a single if-statement.

> +#define RC10_LEN 8
> +#if RC10_LEN > SD_BUF_SIZE
> +#error RC10_LEN must not be more than SD_BUF_SIZE
> +#endif

Please pass the 'buffer' length as an argument to read_capacity_10().
That will make it easier to spot an inconsistent buffer size value by
auditing the caller of this function (I am aware that the above code
follows the style of the read_capacity_16() function).

> +		if (the_result == 0) {
> +			/*
> +			 * if nothing was transferred, we try
> +			 * again. It's a workaround for a broken
> +			 * device.
> +			 */
> +			if (resid == RC10_LEN)
> +				continue;
> +		}

Also here, please combine the two if-statements into a single if-statement.

Thanks,

Bart.
