Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8AF131BDE;
	Thu,  4 Apr 2024 19:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712258383; cv=none; b=FlSt0P+n0zoBlkWNrD8m+S7pvhk+Byp1EJQUz01Rme1EGmvZICOMl8Ro+ajf7/kA811inQ764OrMS8/lwedF7aWdJAj2JniFMLnF4iIm+kprT3tPsjyrtyxschkJ5ka9QW0mjNfLdhspbsi6hr+cZDGyqA4Ophpz7CaoZI9faYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712258383; c=relaxed/simple;
	bh=x3KJKPqBiEQUqA07Jv2uCkRaiDLxFOVuN4vA96PEeMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=m3MaIx4RCwXLXfAEIOqlao3IpoOEY7BZdU9XM/HMu7sa3FSRNGlftZQVka4J9Npw+27WatKQ3RioAiRO6twOsz/1KjRmRR4oTW8KOe/m9x2LOammEcywA8SSAO1wKLRdljHYOPVRnJTUqq6WLSdDmXOlWSCrQKy8Ckyq4QnoFd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jZzO5f1a; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jZzO5f1a"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V9Wdn6BKKzlgTGW;
	Thu,  4 Apr 2024 19:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712258379; x=1714850380; bh=uDsKL1QiwoPnb3DPPSNAnwv8
	B0WMDvDvSC95Kd32o4U=; b=jZzO5f1a9M+32mbS1Kc6amuQDPz0acn5nyNP0vm9
	F/9aEF2pN/RL/bnrWn2hjuoexlMoumRnYP8Rti6p7VfBs9ScfV2aq3jPSFIsWp3u
	KaXdpBHj52V/83hsRBdJ3uHEUAQKHqKsmsG4Ghq/kSttMQyVoi1Up2sDcM7bxVg9
	s+lJybNWmfl/pU9xuLqKuLw5N1iIHUslq1mNK56huwhyYawdnqoDOFNgUF+BkjgR
	kH2dqaz4AsPlE17LLCC6QiV7F7gT74AZ1xsCdt60vuOVExlJUYq5Y1m+Hai1xSUb
	Q8dyIO3Ya4/uZmJr8HNxKs4F9fGkhUiaX+N2UJwpInpRQw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 25_BboewrjHv; Thu,  4 Apr 2024 19:19:39 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V9Wdh65BVzlgTHp;
	Thu,  4 Apr 2024 19:19:36 +0000 (UTC)
Message-ID: <5c00c902-8ed7-430b-8be8-ca4d7e3730ac@acm.org>
Date: Thu, 4 Apr 2024 12:19:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 16/28] null_blk: Introduce zone_append_max_sectors
 attribute
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240403084247.856481-1-dlemoal@kernel.org>
 <20240403084247.856481-17-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240403084247.856481-17-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/24 01:42, Damien Le Moal wrote:
> +	zone_append_max_bytes =
> +		ALIGN_DOWN(dev->zone_append_max_sectors << SECTOR_SHIFT,
> +			   dev->blocksize);
> +	dev->zone_append_max_sectors =
> +		min(zone_append_max_bytes >> SECTOR_SHIFT, zone_capacity_sects);

I think the above code can be simplified to the following:

dev->zone_append_max_sectors =
         min(ALIGN_DOWN(dev->zone_append_max_sectors,
                        dev->blocksize >> SECTOR_SHIFT),
             zone_capacity_sects);

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
