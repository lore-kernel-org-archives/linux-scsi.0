Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967CA137C39;
	Fri, 29 Mar 2024 21:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711747578; cv=none; b=Qv7111rT/jbCwsFZ9yXh91ZKmmZkDlCNGNJjQdL6Rkf9sR4FZTFFVsiOUoW00mez80sI6GyvC40QmY4zjFDP5ROKc3u2YCOBjP5zzYow79+dYqfz6EIj6E2sMuYJVqpg04+qiMfbockWFzGVxTz2DmZ/lwf1lwaKB1aRr6q1Q3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711747578; c=relaxed/simple;
	bh=uk31jn8Z89ca7NgLsTOFjv1I0TH/AQz9eJkNYZydrdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RCKZhNIl4Evx04htEoNEqggB6GsCaBvA6b4MQH54454ghYxgkJXRRtfaXZX1d8/GrsWeZ2VFyK4A0kD5eNDoDtvCLVquL2PP7297r2lmbn3qQ0P4aPALlG6eKrXXDo0kaH4+4biOhQ4t0n5bnMR4fahGyygjOQsuGIKl16syWFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NObyUmXU; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NObyUmXU"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V5tkd0JPcz6Cnk8t;
	Fri, 29 Mar 2024 21:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711747574; x=1714339575; bh=uk31jn8Z89ca7NgLsTOFjv1I
	0TH/AQz9eJkNYZydrdI=; b=NObyUmXU5vv0+nN+ygznpFnI5ucPDLMNwSK5Ip4U
	OXVd7rRiFPf/vRsJ3D8zbG2CDIIHEaw0smTMAFx6MPmI+oisCOB5ZSTw4sM55HF+
	uhYUEaOJPatPVb0ANmHBf/W/rLxgFF+j3xR+lEy5V1TJdqdIEh3eKCzpa0Lm3eQX
	QCawyW7XC0Z/f54+NPY1cq7zWq9QJTgsqn6t7lJ7188KNT2FVS8FHxrJm0Fo/BsD
	T8RUbeQpnMPxzq85I7VJAef0Y9sQ5ZRLkCHN5NMslYCC2xEXSOjNkjGB4nibmLBK
	w45L+aDFKtOA3apFwab01ucWcNwm+HmICdPrUbKAaT7kvw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 95op-4wcyktI; Fri, 29 Mar 2024 21:26:14 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V5tkW5GJXz6Cnk8m;
	Fri, 29 Mar 2024 21:26:11 +0000 (UTC)
Message-ID: <d2782cf4-a168-4192-80d4-7cf9ccdf8998@acm.org>
Date: Fri, 29 Mar 2024 14:26:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/30] block: Implement zone append emulation
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-13-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:43 PM, Damien Le Moal wrote:
> Given that zone write plugging manages all writes to zones of a zoned
> block device and track the write pointer position of all zones,

track -> tracks

