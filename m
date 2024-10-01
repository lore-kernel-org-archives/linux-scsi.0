Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D031C7B83
	for <linux-scsi@vger.kernel.org>; Tue,  1 Oct 2024 20:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727813719; cv=none; b=Azqpt/StGh2OCpJfEWgghzqw5sU6RgdKiyHFcwjxRkCDQxPoCmlVpbyWAidqm+8FM4VpM4p+9LTeljurnYEFAl3GS4VAUrSLngBCWvfh3I+hZCr7B/zDttJ8yDaOJql1CXlW2TtKRnysuyc/ffZ/JUWZzEbVV1LI9+hm4ngmoXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727813719; c=relaxed/simple;
	bh=fyl23egVGs5pWc2scwPcDuSr1U2sGFS623ksIOcyFgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vs8OMcztJ5CgonarkC1qIps34g0hNM/qZVcV5cbjWjvSPd77edIty1xrp+LYNyznIukkB6QOq2rHFy3tWBD2/FyRn1ZAYjUu01zjz0uH+voy4/0FH8vJpSxz7/4LKEi5eIEHeAnL9CYAZ9r64Vc7sqgsjoCCsCEPZL8L51d6cnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=S9K/31tI; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="S9K/31tI"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJ8Ls21SqzlgMVx;
	Tue,  1 Oct 2024 20:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727813716; x=1730405717; bh=80zPPR0JndwN5cg5rqfVhDpn
	k9plb6BweAekDEM6dbg=; b=S9K/31tIHVuSMQQflVEvL6T+4LRoO2KSv1uWr5S5
	9L7/EVjTXKE31WPknZdLLj7QANaLLz5Hpwd58lpIvjhg8ZPFMH2L93g+JGIi74vq
	uFV2Om3ofLMVAUOmN+u00HLrmXyDan8boJOJ+gb9HkHrVT9EnbNwy38zkhw0xgrq
	tt4dpFMSLsGV6Smo+/zT2LlxKUgfL/ioqDBW+nflXh1xNXokCu9cM9RXMYFWVSwY
	kfzLMDcI4vgrkD3zPqaFl7HtT/NIMS78ccz450NzIxTxXZwKR1KYZ2ihnge0pSOO
	c1uXVHlrQS+wwGx4SD+N/lFwgH89qeleoBUMiTwrqZ5ppw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fFI9HXqpuox3; Tue,  1 Oct 2024 20:15:16 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJ8Lp6zqyzlgMVs;
	Tue,  1 Oct 2024 20:15:14 +0000 (UTC)
Message-ID: <25f9f30c-6a1a-4bc6-8add-ee3a319dc61e@acm.org>
Date: Tue, 1 Oct 2024 13:15:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: Rename .slave_alloc() and .slave_destroy()
To: Randy Dunlap <rdunlap@infradead.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
References: <20240930201937.2020129-1-bvanassche@acm.org>
 <20240930201937.2020129-2-bvanassche@acm.org>
 <d5d5f76a-c10f-4334-8e14-bde6f9992f6d@infradead.org>
 <8d2e260d-399e-44b3-90a1-abed3b434370@infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8d2e260d-399e-44b3-90a1-abed3b434370@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/24 9:43 PM, Randy Dunlap wrote:
> For all 4 patches:
> 
> Tested-by: Randy Dunlap <rdunlap@infradead.org> # doc builds

Thanks!

Bart.

