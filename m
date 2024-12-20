Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FBC259497
	for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2024 01:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734658640; cv=none; b=bcH453cC/ZKHRNQckajqi1ualfcypUoo7zELm4zKnnfUVS89IqZoBpmdENWvuaikBVtgBMkJZkYpMhwtWSE+KWTMd4UqIaZSmjeTMY0GG20xWovjMz2c8U3nkL94Ijziz1v+71g93yNV6PPDwezAZby9wp3uUXwObj20zHIvt/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734658640; c=relaxed/simple;
	bh=eQ+7ILVRFwm27dR6XvyoWPj3UUZ4jthSb7o1LLHVYX4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=eJJbBw3meMVQl6WvN3AsfWXBkQ7a1ILTghL+5PTXiC5Kqt4XMOyL3EYvVoXD0ULKmBzQMXjWsgKjoRJl+I69IfnGkYFgyH2nx7RR9M/ma2jYJnNxYAlRS791XSU/hzZZZLR8J7ulP7feNbYPHWNSRDjbOs70lo0TAnCz5Ai8Dh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=RwT8IHxa; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="RwT8IHxa"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734658628; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=hVo47zZLxVC66bnXsEFef9WvEb4M8TEGadKykZcXGZ4=;
	b=RwT8IHxaJOY7cG9829jIe4U6Qd71ZEYrgoQdQmSNiEGQ3x+0fnzR+LGA7Q+KfiAR7IcGHLK3rngpj5bzq7u3pp7bC1xAK8FTrgi176eKAZBWz7ErA4WK9TUhJ3E0w3Jxaoml8SDcqhRySIxkdgD+c6gm1Zj8NmZgY2P5zjO5F7s=
Received: from 30.178.82.44(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WLrwg2C_1734658626 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Dec 2024 09:37:07 +0800
Message-ID: <8e783802-a74f-42f9-b0cd-9b831179c472@linux.alibaba.com>
Date: Fri, 20 Dec 2024 09:37:04 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH v2] scsi: mpi3mr: fix possible crash when setup bsg fail
From: Guixin Liu <kanie@linux.alibaba.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
References: <20241217110408.126413-1-kanie@linux.alibaba.com>
In-Reply-To: <20241217110408.126413-1-kanie@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Gentle ping...

Best Regards,

Guixin Liu

在 2024/12/17 19:04, Guixin Liu 写道:
> If bsg_setup_queue() fails, the bsg_queue is assigned a non-NULL value.
> Consequently, in mpi3mr_bsg_exit(), the condition
> "if(!mrioc->bsg_queue)" will not be satisfied, preventing execution
> from entering bsg_remove_queue(), which could lead to a crash.
>
> Fixes: 4268fa751365 ("scsi: mpi3mr: Add bsg device support")
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
> ---
> Changes from v1 to v2:
> - Add return statement when setup bsg queue fail, sorry for the v1
> trouble.
>   drivers/scsi/mpi3mr/mpi3mr_app.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
> index 10b8e4dc64f8..7589f48aebc8 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -2951,6 +2951,7 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
>   		.max_hw_sectors		= MPI3MR_MAX_APP_XFER_SECTORS,
>   		.max_segments		= MPI3MR_MAX_APP_XFER_SEGMENTS,
>   	};
> +	struct request_queue *q;
>   
>   	device_initialize(bsg_dev);
>   
> @@ -2966,14 +2967,17 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
>   		return;
>   	}
>   
> -	mrioc->bsg_queue = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), &lim,
> +	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), &lim,
>   			mpi3mr_bsg_request, NULL, 0);
> -	if (IS_ERR(mrioc->bsg_queue)) {
> +	if (IS_ERR(q)) {
>   		ioc_err(mrioc, "%s: bsg registration failed\n",
>   		    dev_name(bsg_dev));
>   		device_del(bsg_dev);
>   		put_device(bsg_dev);
> +		return;
>   	}
> +
> +	mrioc->bsg_queue = q;
>   }
>   
>   /**
