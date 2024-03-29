Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4457D2C859;
	Fri, 29 Mar 2024 19:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711738823; cv=none; b=jkHMljxErPtQ4G1Wop8BfJNDonDfcByH5yVY5/kxi51mMH8OA/TDDjSrE5QQr4Q5e7oTElc+13MczJn801BSnalC4HEyUcTwcyFvFTAa/LITVz5U/KPtXkResBLU/F8kEG4pU47J0p5ELfzZWop6Ppc1zugBkdUE8Jrt7xLuR/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711738823; c=relaxed/simple;
	bh=g7Av2jin4sX0Cfb78/pBPBNfyidDPOykp9LCP0eWApg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LBSxvly78jqCoyyF3OXgqy46L+Fm/tC8Y66ciOKGGrcWeqgaAELEMSlMmzS5oBtVeyOg2xs3d9BruhvB3whP4L8cnzXVgng34h7zk58+4EjeoUYKtzPAJT6IVco2zFdzkfae6pcvAg66gQ22L/ppKjvdk6YTr+0Iqf8YowHRoXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=399cq4Xg; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="399cq4Xg"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5qVD51PVzlgTGW;
	Fri, 29 Mar 2024 19:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711738818; x=1714330819; bh=g7Av2jin4sX0Cfb78/pBPBNf
	yidDPOykp9LCP0eWApg=; b=399cq4XgVFCAZleHjaMjkk4Dxz80eXehdQuOh3Il
	N/xxtb52kFk+EnmbeXSc55NK98tQrHiBX5qGwHPsGM7Wyfh+dJGkxU/kHwtgkqSu
	Jcp7xrkbNiHI/P+bEJxyL2BzvdY3t55N25/V2sOb/kHtsmF9t5FMmyJ6GpoCGQYl
	Bdr6EVgtt0lVBy7GowlZy+Sa0Sp8+6AdaYLngZNCbLh5tguBeX8M35tGr6pjgU4K
	ijBqqQekpzB1E1aYObWhiCfFMPzXmkUCGwfIootc1ALsLE3jf6m/Me+1TcA6QuWQ
	dRJ2z3PZdx9Asl0tjJROWVx0p2xYfseLBSlHN5NFx33drQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PaHJm4o6KFQU; Fri, 29 Mar 2024 19:00:18 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5qV76jybzlgTHp;
	Fri, 29 Mar 2024 19:00:15 +0000 (UTC)
Message-ID: <17a9b0ce-1423-408a-8c70-767218572d64@acm.org>
Date: Fri, 29 Mar 2024 12:00:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 26/30] block: Move zone related debugfs attribute to
 blk-zoned.c
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-27-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-27-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:44 PM, Damien Le Moal wrote:
> block/blk-mq-debugfs-zone.c contains a single debugfs attribute
> function. Defining this outside of block/blk-zoned.c does not really
> help in any way, so move this zone related debugfs attribute to
> block/blk-zoned.c and delete block/blk-mq-debugfs-zone.c.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

