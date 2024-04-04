Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD31130E29;
	Thu,  4 Apr 2024 19:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712257843; cv=none; b=vBQNeIDu8f1DCwFe9jr4MfFQ7LFXl6D9QXOdyNzZyU4llODDB4TpWe+HTW3aVsTxh07F2aTUHb7seVpqPHRnvZ7YwCLHi/FgOeDer0FVsQmy9c4hjW6XNK/bn98vaInKyVFqOq2Si3/annHwQ6+DgQy45chQmjiBWknjWyQ5i+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712257843; c=relaxed/simple;
	bh=mBj19F9ORttERvbBuoN7Es4+xu0huIRpLr90v22XLn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LCcOioVraZodmyp/4N30K7eZffKowMja6r2GzUXRaoX9JtUdFHnS1C8/26X2rXFTyKLoEWLT0BS7L/i4atz/3sexlek5ChRvqfJqRf5f95s5gM5myxgRUncv7PSSeuTaNAMG5IQNfXX9jR2man5TAvBjJrukKzyGsnf01PQiOwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DjR4MexM; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DjR4MexM"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V9WRP67kkzlgTGW;
	Thu,  4 Apr 2024 19:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712257838; x=1714849839; bh=AtoYjWVEBbEBGedpPcc/1CpV
	KlgTfT+Xy2OLNe5u1fM=; b=DjR4MexMiWy6HGNtCcdZL+it0XjOJBacseACSp/a
	SCcDIduL9qVq1nQA4iEWLiB4JeYL46o98l3BqHQq2TgGIYzhBrHWPhme/JuKvn2x
	k4RBgfnNCwD+c2URRZpd1oIReo7ye5pdyVggAYuUnOT8Db/n6KbTDFQQeF/9lxy1
	+3CZb1ai2lNjhPxfCZlxb/dw+78sTMb3QXUGzBJKrphBIUeRlfvsX/RmiFzJTFTC
	E5WQaGPCkv4OmH7OnWPqmZunaIP6WlrAtwbm06Nar8AgQdqKxBs+PeOZfWaxWs9T
	5waa61P3EZI+DhYE1HRRaLMT49QDP8o8ZJ8JeTzZoc80OQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xU0Ys0OmGidF; Thu,  4 Apr 2024 19:10:38 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V9WRJ00PyzlgTHp;
	Thu,  4 Apr 2024 19:10:35 +0000 (UTC)
Message-ID: <da09a76f-de4d-405e-af0a-79df59e081a6@acm.org>
Date: Thu, 4 Apr 2024 12:10:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/28] block: Allow BIO-based drivers to use
 blk_revalidate_disk_zones()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240403084247.856481-1-dlemoal@kernel.org>
 <20240403084247.856481-12-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240403084247.856481-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/24 01:42, Damien Le Moal wrote:
> In preparation for allowing BIO based device drivers to use zone write
> plugging and its zone append emulation, allow these drivers to call
> blk_revalidate_disk_zones() so that all zone resources necessary to zone
> write plugging can be initialized.
> 
> To do so, remove the check in blk_revalidate_disk_zones() restricting
> the use of this function to mq request-based drivers to allow also
> BIO-based drivers to use it. This is safe to do as long as the
> BIO-based block device queue is already setup and usable, as it should,
> and can be safely frozen.
> 
> The helper function disk_need_zone_resources() is added to control the
> allocation and initialization of the zone write plug hash table and
> of the conventional zone bitmap only for mq devices and for BIO-based
> devices that require zone append emulation.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
