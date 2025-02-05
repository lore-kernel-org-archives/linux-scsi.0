Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3645B1FC7E4;
	Wed,  5 Feb 2025 18:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779248; cv=none; b=UCob7dgU43z2dNI6QCZ20gT1kxFHBIk19YAlnt0H2iE1JGMkQRj6c3Mwo6s3ROnIjQyU0OWxazs5MUNDz8H97orjat4QQhqnOf8J5A9uv2bSwBpiZr2Om3VJpl5pLNyjSUyPGWTc4DfiwxhvUFh8H87R7Gn9QB5j6a3Og03c3P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779248; c=relaxed/simple;
	bh=G7l7JdImMCvSgoCUhDeuMaQYe2Qovr9EpWjwedh621g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oZijQUQlQaWixqml2Kl9jWz3DUeCcVmhBfrXWI+KyOjGKx9iBQZGe0NT91lEsyltvtr3fb+IiTO4bAIa2d554RntMXIO7sn98KaGaSj1v4KdSrQZQmiJVkDTFbZHFdhOfT5sc/A5bWo1Ise43kgSeMY1E+g/fIKqOPR17sEAtFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kTYWVJcT; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kTYWVJcT"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Yp7fQ4sTpzlgTwJ;
	Wed,  5 Feb 2025 18:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1738779243; x=1741371244; bh=Mf++ETLLr9pHBF3Oo78AdeN0
	9Bxk0ieB7AF3HN2/J0M=; b=kTYWVJcTEoRe4igR648/FStmviVZHwK3WFKkqRkk
	wKOjMgqmVzIaZSkrEYyV2O+zYp/8ZEF0KbQ3dZn4quJ5bISdBQTL5jj/89LMLLFv
	QpFrc6In7rr8O83+6PPpq/w+hdNxCrrjfYaTwtQexqvfLiyPy+zSDrB6uhBPt1PA
	5UcM2RgfARA6ThnBxjmdztkRTvmsf2TcWe6/6bRgBKFUe/JnyF50KX9IvIr7Vsh8
	39FSYvcXQPoPrEF/cI4s2Zat3IsKMHBqpyJ3j3UkWW+BboN+zWKNq8B0TUW7TXzp
	mwa3mhDjThbm3jcv39ftriVfFdbmWqVI56KyJ2gWVbdiMg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ao6zdBx8RmGR; Wed,  5 Feb 2025 18:14:03 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Yp7fK0GwqzlgTw2;
	Wed,  5 Feb 2025 18:14:00 +0000 (UTC)
Message-ID: <4f6c65f7-2042-44af-8080-5737542e048b@acm.org>
Date: Wed, 5 Feb 2025 10:13:58 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: Do not retry I/Os during depopulation
To: Igor Pylypiv <ipylypiv@google.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20250131184408.859579-1-ipylypiv@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250131184408.859579-1-ipylypiv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/31/25 10:44 AM, Igor Pylypiv wrote:
> Fail I/Os instead of retry to prevent user space processes from being
> blocked on the I/O completion for several minutes.
> 
> Retrying I/Os during "depopulation in progress" or "depopulation restore
> in progress" results in a continuous retry loop until the depopulation
> completes or until the I/O retry loop is aborted due to a timeout by
> the scsi_cmd_runtime_exceeced().
> 
> Depopulation is slow and can take 24+ hours to complete on 20+ TB HDDs.
> Most I/Os in the depopulation retry loop end up taking several minutes
> before returning the failure to user space.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
