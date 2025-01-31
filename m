Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BF5145A18;
	Fri, 31 Jan 2025 20:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738355555; cv=none; b=OQiTHxRHutN8eoSqjSHDTjswNf3u+9jX6qdC3ejj4LJBUPUpuVDbxs6GFePhqp8Id1GeTAGUPzTBIpBD5QbukW46H77/NfawmeGoN+OKgAUqn6FZ5V4YBWetQvXqOjpK1vW06TpxcSpT8xLG/Jopt2WU5k5JL6B7v2CsyGxuOgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738355555; c=relaxed/simple;
	bh=xyOk//pxxE1fGOVh04NQlxO3Cxm4Lxw5uBaQ5Ypn4H4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jR9xNF4zCSVeb2LqiCoKZCf42DbGnI4gbDaRo0rXYwN6jVUuEiVNxJMEuAHQvGiJb+SeT3ijVhZ5KB/peKvwv0XdFNZjd5J21fbBRIPq3Qb/7xm+Jt7fvylmi2LwrbdFy3UAfYpWqT0MQhcnE/ohM8bgDN9Jw0xAaM3T0rYGIvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Z7jtItJB; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Z7jtItJB"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Yl6yS5LsvzlgTvy;
	Fri, 31 Jan 2025 20:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1738355547; x=1740947548; bh=Gu3gh5W9nuKZwxt3f2g31Zen
	S/oOGGL97d861ZCsQlQ=; b=Z7jtItJBQP0kvzVti/07jvIlEVqcNmnVewOmYOYG
	SroSyfuygVjyxaoDQNt1y9Q9XoJwtlQrLK1RTGOO1N4lBRuHu1qGsWyJ+xXlnE81
	1mUCJhF2ODtBYNiuxsXAiOig1mngc5u82xaKsr8cbfbyekVs5RYA8VtnP7vV0CyQ
	FrBybVQQQSkN/xMj33uzjh9TTLnMqD2tKziQ3pclLfPOHsDvNWziQtcKbrkidBbs
	nI6RVA8hKim+8VOE50sUeKSh/8SrGUIzohQRENhquWN1wTvQmjsZOKMSI/dWOYyg
	2/6jN77iaLyavHm678TXtlDaxvskA2AXy8sPP+q9Ilnc9g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jR3Q4V-Fd0-H; Fri, 31 Jan 2025 20:32:27 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Yl6yJ61JnzlgTvv;
	Fri, 31 Jan 2025 20:32:24 +0000 (UTC)
Message-ID: <bbb46821-25dc-4f5d-a6bf-cbef34024afd@acm.org>
Date: Fri, 31 Jan 2025 12:32:23 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: qedf: Use kzalloc() and add check for bdt_info
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>, skashyap@marvell.com,
 jhasan@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 manish.rangankar@cavium.com, nilesh.javali@cavium.com, arun.easi@cavium.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250131195438.44964-1-jiashengjiangcool@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250131195438.44964-1-jiashengjiangcool@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/31/25 11:54 AM, Jiasheng Jiang wrote:
> -	cmgr->io_bdt_pool = kmalloc_array(num_ios, sizeof(struct io_bdt *),
> -	    GFP_KERNEL);
> +	cmgr->io_bdt_pool = kzalloc(num_ios * sizeof(struct io_bdt *), GFP_KERNEL);

Please do not reintroduce the possibility of multiplication overflow. 
What is wrong with adding __GFP_ZERO to the second kmalloc_array()
argument or with using kcalloc()? From include/linux/slab.h:

#define kcalloc(n, size, flags) kmalloc_array(n, size, (flags) | __GFP_ZERO)

Thanks,

Bart.
