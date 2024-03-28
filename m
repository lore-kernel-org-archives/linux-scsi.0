Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8341384B3;
	Thu, 28 Mar 2024 22:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711664959; cv=none; b=Jp4QosUBulxH8rjXbAbJL84aEhZD742tl6+BVcCs8MpaUkzrvz3OfoxjtHmEuQl/dsQw3hpGgxYRclncrRnwtZXdJaqeZxp+TtyzQrQvjrytca5wZoxc2faKtbMiZwoPqH5fJYPKozsvGN3IXbypVyEPETovttZL1/iJgDEl2J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711664959; c=relaxed/simple;
	bh=H4QQZfrZU0MxBXl2n+UXU1HklTcyk+tNDJ5dZZ+aR5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GRD1iXgNMimogWSu4imJB8a1pANTfoczkKTAw/tCMFWnB1H3mSdek6N+f9p4sbiMprL6vQ0ugGiwwSRGtih50YsiOoHQBeqjyefVXY2i7DCF3GmKtuMIe8Ut5dv6KfsD2FYDwLmYBq/1t9mxKBmnxXm4W9VvuvjHSNIejAJz21c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WGRjrY8M; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WGRjrY8M"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V5J9n5gCFz6Cnk8t;
	Thu, 28 Mar 2024 22:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711664954; x=1714256955; bh=IVxtrsQyU59W5Vggd5LI5HVP
	rndB9GeCBj+KxNWWa4c=; b=WGRjrY8Mbq21ADwKQKBYOrZXqMNykXjiqMsEqSvk
	ynupNMIjngpQPs4evEW+Rpz3ctV1rFfX+1jtgCu9VOYd4CNoDHRDKelaYDXdgCX5
	5stoUEXe2mg9EY2PN4lB5EA+WcKCPM74Q4fqCMAw5yemE0ZTs6LumG5lrYsB+QWe
	tPLkTEvlEuXI/J5WIyT5cPAlrry5gcU8lpQx/65gqjmDS6/ahBvGcmks6ydEaQtf
	2bZHYtZXIezOuQj/KILkUWHqlpdQDhLDOy+c91yTLEOnkyocvWgRuDrBnPBItrsj
	YmkH0xsbf33dTvoGc5c08l2tfxOY1r7sRzLxYutGwjb0Lg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id H57sQG6YDuzT; Thu, 28 Mar 2024 22:29:14 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V5J9j06CYz6Cnk8m;
	Thu, 28 Mar 2024 22:29:12 +0000 (UTC)
Message-ID: <5f98992d-e94a-4558-84bf-2602a13b6f74@acm.org>
Date: Thu, 28 Mar 2024 15:29:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/30] block: Pre-allocate zone write plugs
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-10-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:43 PM, Damien Le Moal wrote:
> Allocating zone write plugs using kmalloc() does not guarantee that
> enough write plugs can be allocated to simultaneously write up to
> the maximum number of active zones or maximum number of open zones of
> a zoned block device.
> 
> Avoid any issue with memory allocation by pre-allocating zone write
> plugs up to the disk maximum number of open zones or maximum number of
> active zones, whichever is larger. For zoned devices that do not have
> open or active zone limits, the default 128 is used as the number of
> write plugs to pre-allocate.
> 
> Pre-allocated zone write plugs are managed using a free list. If a
> change to the device zone limits is detected, the disk free list is
> grown if needed when blk_revalidate_disk_zones() is executed.

Is there a way to retry bio submission if allocating a zone write plug
fails? Would that make it possible to drop this patch?

Thanks,

Bart.

