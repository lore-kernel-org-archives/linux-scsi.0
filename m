Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07EB1C8FA3;
	Wed, 29 May 2024 21:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717017101; cv=none; b=iqQxT2Kaj2T6N+S8Ig//GHfEpZZcxGJ+oJCV3ohp5WP91iy5+4caLMJbQK5u0o/j5iNYBifNAbhUxDok/3ZZb7jdSKVp2nIJrvgXi6AfSoiu8zanuRoJRFk1/Zwk2ztBgxK4iZmH5Oh2xvg514DXOGq7hjATetbv8Wcz6vVU+nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717017101; c=relaxed/simple;
	bh=wVUy7o3bXf/noy6YSu0RsfBfkRiwLQrgb5cMP2Pa7q8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EIPcID5yQTgQMVcNVAm+ok1zEaRaPOxeFrAdlbpbsSpAMXSRJfjdknLAmXr8p0T+8JoOkLD214cbM0QLlnZQIbJTLo+QiSyMsRrfpTS6uNss99BQG4E9A7gbzLzFtIA8t3m7MzSszWX6X4ZYv+CiLXEggt4WaamhM54pwXjKgwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QFjHmHY3; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QFjHmHY3"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VqMWZ58Ltz6Cnk97;
	Wed, 29 May 2024 21:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717017094; x=1719609095; bh=wVUy7o3bXf/noy6YSu0RsfBf
	kRiwLQrgb5cMP2Pa7q8=; b=QFjHmHY3/zEesfTR56+Y2SAfx/9kF8USAaPfodaa
	1NlbISeQtFhMQo5eKeT71tNXYkxOsczf07HR2Jg7kDECPZHbMqyg4jYdehcmpc6U
	pDScRpKKu8Rjyhm7pbf60HZtmxriYQ66+aBloWTpP6m/aGYjU5d8dR4eSVUqQ/OA
	xYtc6lzNLpfolCh3T1Mfx+tpCeFXkuhAlul/aC6d93xzuIXsbbqvGhKw9HLqQ8Hv
	yZpoz1hZaaNwZnzsSClMVINGA6pWnoN6MCYirTHscroKGo27eDVHIhGrEeOJHh7Z
	7W5OQwUFrkBQjwlsjPeC4wUGmMgkfdxis25NEBJvc3gvXQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MByd4wIRut8R; Wed, 29 May 2024 21:11:34 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VqMWR0L4Mz6Cnk95;
	Wed, 29 May 2024 21:11:30 +0000 (UTC)
Message-ID: <7828c48b-2a37-4033-a634-7a4fad4f94fd@acm.org>
Date: Wed, 29 May 2024 14:11:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/12] sd: factor out a sd_discard_mode helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240529050507.1392041-1-hch@lst.de>
 <20240529050507.1392041-8-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240529050507.1392041-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/24 22:04, Christoph Hellwig wrote:
> Split the logic to pick the right discard mode into a little helper
> to prepare for further changes.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
