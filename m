Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFA23985A;
	Fri, 29 Mar 2024 20:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711744656; cv=none; b=nK54uWWaTwslp6Ds7GcehG0se7ikNvSAZhnRyokWxaB188a9uGG7HIpSBcS0CbZ6DobMadSOH4aVf7xAi5V8c2NoMg541def13+mO5qlPMe96B5xZqW+Hzvelcw7qpqCVlV2g9sKuYsO6ya7fMFNCOJUEVgtKkPL3u/7HLtO5mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711744656; c=relaxed/simple;
	bh=d+rhaQeE4XFKYd1O2K6qSIHBuk+O1S/KN9jXVfQHUGg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Pcq1tyBC5rrqoQT6bZzaeozIEBq6qjOX7Q2xWNBrasnky+ddkaV/YZWN7Ec1lfbkgoNwoymR8ZpWeH5xnKE/70wMiGklFHZYkIHPTJ8r9svvcIQHB991WbvS8IR9hwXgETaxiMS1mu0POE3rP6dOkCXoDi/yHdpAnnn3GKFCrJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=t1T2dU2k; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="t1T2dU2k"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5sfQ2q2QzlgTGW;
	Fri, 29 Mar 2024 20:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711744652; x=1714336653; bh=XSrD+I5G2xuzgmbmL6BGldgz
	7UUYDzW35s5Oy1nLOsA=; b=t1T2dU2kxtPDSFUPNGYTj84cTtPhV0DWFlt1Mtxm
	Jx3jCEkbtfF4Ucz5B5JnjlryerMfCc7ssv3OEO4FW/27/3qfQ55BgRHdSuOuy6Os
	XD8OlwbGGq38ct7uZTxzqkU8Uaob+dTE0UWvER4+fQ74f9AVGfvKwTkcisqcx8U5
	Orvu/Z+CTzWAat21niWb/As7XQ32cJU7JrZUsS0UwV31RMy0M0ZSfhG6hXErQCc+
	Rha3dZneWI1iEVZooeYJM2fa2Rvz600jablTSckxoDnFQYRRdFru9FAtz4WT8U9I
	bOkaCvU++OzNDIlUm2WcLztVOJFsIttpGhfIBirxTOO7AA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gY31OGqN4otv; Fri, 29 Mar 2024 20:37:32 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5sfK5ctlzlgTHp;
	Fri, 29 Mar 2024 20:37:29 +0000 (UTC)
Message-ID: <8f8bf2dd-5a73-4952-ad76-dc0c79c65237@acm.org>
Date: Fri, 29 Mar 2024 13:37:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/30] block: Fake max open zones limit when there is
 no limit
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-11-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-11-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:43 PM, Damien Le Moal wrote:
> +	 * zone write plugsso that the user is aware of the potential
                       ^^^^^^^

A space is missing.

Thanks,

Bart.
