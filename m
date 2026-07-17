Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADCF37475E
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 17:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784309094; cv=none; b=AXsrnuDszBCnXT8d3bF/mkr6Hi62ZokOol6Zy9Mo8aAyQQQKyS0CRyP8hXaAebxEl3B2kWTS51Y7XgoktIuyo3rSotXRPUpRXwNX/NMErPOf352UAIU97YidramPwQ7asddrmQbjLlp2UUKVORSq+C1ji48iZXofMxWZOyk0eeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784309094; c=relaxed/simple;
	bh=MCA0OCEMVKiyOK4nz7GVKUzrVTgj4fnlaKAthBpHR0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NyTKJ7zxTD5N/3KArSrLFvaVHh1/6cHtqeeOV9tqX5cQRGJqXg1b33zbkRtEv7rSjxcQJDudsz1jnbOdHInk7F1xRB0+ZfQ625PN1NptqsrHqlyNXB+g7Pogb70sl3/HkS5N6aohZwTsCSiUmpCw09dKaS6VhNnZ1V62Zx+wv3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XkGE9Cr6; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XkGE9Cr6"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h1xcN6wrcz1XM6JV;
	Fri, 17 Jul 2026 17:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784309091; x=1786901092; bh=MCA0OCEMVKiyOK4nz7GVKUzr
	VTgj4fnlaKAthBpHR0U=; b=XkGE9Cr6jY6pZjjbMNN2XQyya7EYLqYdDflZyZLI
	RG31jLMbxv476sXa9Up9pxCyAwVRLPO+SBY4WPMjPfhrx1yJ3myxoXqAhEGOIn9P
	KA3JSvWLy4qS+t7xDYy45HBUMQPjAklwdZ8c3eOBizD3Vc+T5G1ubjDU7AWX7SeA
	ePBwNbrfIdMKDkizGZbOR57G68V0Tzw+DrRj4dS4YjVCM0zgbjMDXJ+69KGeiQkx
	+D8+6wihU3YbV5rc6o6Ew7JP4gEX9ToBOomEC/XuW+1LLGyXm6708e4lQ8miCXpF
	7TzffUsmNHeXiD/fCeMpvt+mDkGTM4OOSNTI7VSGOd8cgg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id otuqxLp5IdEQ; Fri, 17 Jul 2026 17:24:51 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h1xcL59g8z1XM5jn;
	Fri, 17 Jul 2026 17:24:50 +0000 (UTC)
Message-ID: <ab0c0110-5b87-4e35-b8c5-15d5c3ab9e68@acm.org>
Date: Fri, 17 Jul 2026 10:24:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: host: Remove redundant dev_err()
To: Pan Chuang <panchuang@vivo.com>, Peter Wang <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20260717035013.563791-1-panchuang@vivo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260717035013.563791-1-panchuang@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/26 8:50 PM, Pan Chuang wrote:
> Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
> devm_request_*_irq()"), devm_request_irq() automatically logs
> detailed error messages on failure. Remove the now-redundant
> driver-specific dev_err() calls.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
