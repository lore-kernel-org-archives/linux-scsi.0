Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39BA1DFC4;
	Fri, 29 Mar 2024 21:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711747683; cv=none; b=VXK+pYaLSvJxuB7BO97jD3kzdvU+vkiD0uyBi4H3QyNtYtej6b2SxjjAIo4Oupk8oyo52KsIzgSdHg++e5uJF1uX9aM7jFvZu0YRPvz2/7wp/Zxt6d5LEVSONFC61tH4L5rDqTj+wE2S38xwsMGLTWskqXphLhdwTozXcJdPRiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711747683; c=relaxed/simple;
	bh=FRIggP1YvWWV3rj+5WU1Cj2nMoZrQOSbDSPE/2jMC40=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LfYuW5eb6SI8kfDJUzgeOw0CThWvzJ/gOBYFGo3IU8pnMPb8hKIPqlaOeCGUxT73kHBhnFSDryY9h+vK/kX1ucidmiaPmHN85zMDfIuv+GZ9/RXFJdoiEPQs99i+NcDkQS77j5AMejovjPEO+O8QXdOVOO4h1/kOVJpf4ItjU7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=V3cNSNny; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="V3cNSNny"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5tmd1slKzlgVnN;
	Fri, 29 Mar 2024 21:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711747679; x=1714339680; bh=FRIggP1YvWWV3rj+5WU1Cj2n
	MoZrQOSbDSPE/2jMC40=; b=V3cNSNnyJoK/fp047ivnpY8fYRZWIgmxKNhv3xHi
	zF1rENKQKN2u7fgSLX4SZbxfyb1O9QShDwxOpfWzDgNhBsxs7JUke/CpooPSvEDP
	UBbWW4b1+boD3mXOB2FBO8eafXPYVy23xpYyi4h2COPYHqQR1DCN5RfyxZcjPeYv
	ajQc3LJi6DBq2J3Zz60Uk+Xwc0YCEkgTbKNzKnqqz23hJXVWMhHV/ENv7aByEw7r
	xBs0G5yTutLAKHvNzxb0oaUbjDCmYMEPkZrsQdYb0sXQbHYgq+nI+pyMJeOj3kPR
	aPtBWEeUypCKRHXIGDQPlpARInE53q41kR1S++ERnYg9vA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8eY3fTIJ2hpS; Fri, 29 Mar 2024 21:27:59 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5tmX4jfhzlgTGW;
	Fri, 29 Mar 2024 21:27:56 +0000 (UTC)
Message-ID: <86d46dec-d7f0-467b-b714-b2e3bb52500a@acm.org>
Date: Fri, 29 Mar 2024 14:27:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/30] scsi: sd: Use the block layer zone append
 emulation
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-16-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-16-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
