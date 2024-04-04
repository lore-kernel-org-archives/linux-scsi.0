Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624E6129E88;
	Thu,  4 Apr 2024 17:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252137; cv=none; b=VJdumz+UGxQ/g6U5zqGKpFdVerbBXyrQh2ctJ/uAgyDilWX5zcU7uGtf4sY2vx9744uPWbrHzQMftqplD6wcRiCB0wFiksmq2Mb0+9SEjbEuWh5s5z0gxHPWe4R53eEJU/uXauemiSE+O8JGX5b10Nk/9axnQhEe5dTX/PXifmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252137; c=relaxed/simple;
	bh=kvPZNsaMOj7ewBGW3AQ0HZkEngetY2sLmOf3rqoVwwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dobRdszeRYcLtvk5YR2GoH0SQFQb9a191K0pov2Qqz988MPRrrC/GgntKClNnIGJteF4gnH8zlhcdXBCz9oWczTEk7dS7Gcc50y9F4DuL42rL7cU0eC/eAn4Hz8kzWR+yeV8+PJp4RwNbNbJCnfcack0i/rB5BIhY+OIv+jWD2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hCjT4nSY; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hCjT4nSY"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V9TKf5xg5zlgTGW;
	Thu,  4 Apr 2024 17:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712252131; x=1714844132; bh=Li/HYSqUiHHL1gshTVSsuPqG
	zmPzUmPuzsfkN43c+RM=; b=hCjT4nSYv13pVzrQUyrKZ70vuRRDYWP+O38zAytq
	e+qhefhOO5P6g+CZSiDTtAE4xsrsc7KfEaJDYlv4K7WdnVDJMa/2uOvLY+jEKDtn
	V1Z6VZNkI9q3POcFMaEaH8TH0Nv6D/7FdgBGZWLQyMXeQxeb9PWYgzvZm65g+nVy
	0gPvLCysBia2sSByxOoE14cP9l+L6n/MQjeJg5uYQhIfkHNESll0aMeDiLOj8k+8
	hGE9nT0GUrTkyouWdUA+8r8wtxX1AYnv9yV1+n4j/rNtJBt3tIDI4Uloj04LbPsB
	++NZALH2z6wE4oIpE7z62G6eOZquOMTltBC5gKU6825Y2A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id q-IbjMRqNSP9; Thu,  4 Apr 2024 17:35:31 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V9TKZ6n70zlgTHp;
	Thu,  4 Apr 2024 17:35:30 +0000 (UTC)
Message-ID: <d1c6b3bf-6381-438a-8814-6809753ac567@acm.org>
Date: Thu, 4 Apr 2024 10:35:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/28] block: Remember zone capacity when revalidating
 zones
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240403084247.856481-1-dlemoal@kernel.org>
 <20240403084247.856481-7-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240403084247.856481-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/24 01:42, Damien Le Moal wrote:
> In preparation for adding zone write plugging, modify
> blk_revalidate_disk_zones() to get the capacity of zones of a zoned
> block device. This capacity value as a number of 512B sectors is stored
> in the gendisk zone_capacity field.
> 
> Given that host-managed SMR disks (including zoned UFS drives) and all
> known NVMe ZNS devices have the same zone capacity for all zones
> blk_revalidate_disk_zones() returns an error if different capacities are
> detected for different zones.
> 
> This also adds check to verify that the values reported by the device
> for zone capacities are correct, that is, that the zone capacity is
> never 0, does not exceed the zone size and is equal to the zone size for
> conventional zones.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

