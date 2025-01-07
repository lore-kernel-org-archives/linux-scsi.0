Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097FB1537C3
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 15:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736264368; cv=none; b=Bpv8opRsslXzB+7AB+MkusPjMd3o7QGCfm9JdaK06W6xDXWXbPdDv1IpbknTcorN5mUPqKhkMk/Hgq9C8wpDtwi0Btl1R4Qp+4jk7sdY3evL0WQVx89qvAXHdvGt9HDNhDy3Rzys37B8330lVzhaiE3U7dvkILctUe2PAcGSj2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736264368; c=relaxed/simple;
	bh=FRVjJvG/HbiP4iJ9ShtEBTB73KvSoziGGuOe71w7ujY=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=JL/72sw8zWQOPJPVQixGID6FWRjfmQGfEOAgNLX4XhKziqePdw+x1NZqn2G1/76qwNppjOund5UtQ6mJgmPGa7pi7tRqjDD9nthWtgE5LA8gBmjqfnV+yJH/eTE7Ir9p3XVrdx0Y6y1sYxX/A6zx6qeiccKX//uPrkFjvuDuOck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cFz7WPyY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cFz7WPyY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736264366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iHSg1y6UnjoLFUKVWKkQCt5FDx941kJIeDF0Ru2YJVU=;
	b=cFz7WPyYI0v6enNRUlbDjZQGXhtwssRZBQNiLx4CdylJUVYqv9PTS0aEKllRIE50zjvyMn
	6m2js7rC+fHodreE3CbPpDQVxf2IYV8WyLi7mWHGJFd8rwzFm5NHpFsJoq4AncNsyFvacK
	SQj6xXNmvZAlwrWFXeucj70/y6qTloE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-4AZZlbOKOzuOvkk9X0i2Vg-1; Tue, 07 Jan 2025 10:39:25 -0500
X-MC-Unique: 4AZZlbOKOzuOvkk9X0i2Vg-1
X-Mimecast-MFC-AGG-ID: 4AZZlbOKOzuOvkk9X0i2Vg
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6d8f8b9d43aso337367876d6.0
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jan 2025 07:39:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736264364; x=1736869164;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iHSg1y6UnjoLFUKVWKkQCt5FDx941kJIeDF0Ru2YJVU=;
        b=DTErfJFlKKtHAD+rvcpYdb3OeL5rO2uhwHs9CcGwQtEE0gle61IqyZ70mOuGmO0Qwe
         fQlCHhKy03gUbDhIPOcCTXe3RHCq/Wdsvzfy29WKEQyHmckaDHO+05IXVtgVHgLvv47G
         tH9OeNL0YB112yo81BSShElzCQxtU/8RmJGPGFIp/qeUgMEbcc94ubHXEubh/3p52NEd
         7ai3CcSBb0GP58k3PJW4eOs+QStrgX31GkfrvoFcdImKLGijA6bbciQyiH9miylGxW6y
         blQ1dM60RkWzpAilDMvjzNsBO6Gt1NvQat4XOUb88bH2X4hIfKMSR9DuKiFWo/EGoOUx
         aqyg==
X-Forwarded-Encrypted: i=1; AJvYcCXG0zHDOiT/dhmw71FZBiI1r1xDv8hpvBmLBCC68HDgoukr5k5pEsDFDLdSP5fiB9V2Ub/ElzjhTEvp@vger.kernel.org
X-Gm-Message-State: AOJu0YyzAqrzwNz8dbXWiLWSjhXh6ZAGfwxQslTWszSt/ay+79qRZZnI
	/xH2kogs9kH84DE/lRSr3ug2qcse9Nw1CejSpj84Jq9dto8fnDjNYXPoNduCNT8wIFTZiH0B737
	LCwra+i8QUGp6G5qO0zOrWrfDDSpRVTeidI7xL/avORZH36ehs6HrSaTJ8Qc=
X-Gm-Gg: ASbGncuN5No3tSUwaXQVrGxV0Wr79HJDCNze1K6R5Rr4e+yh/ZhTRO5Xl3IR6zV1A5f
	1TvCzjBTMALIXDwRb10hy+uS0doPx8lx//BM1nw9uHo+FnCrtUAXAphzsl9vh6kMCqX3QvTEDxX
	wLjOmOt9QJwCVLIvNeK7fD+fpCDCQohPbOsFh4/z5xWX8wjiDqf2hcDdrpFY+KOilC6J5oH97vm
	zxzZZ1ueuLi99nxonJdfMF/yrrBqb32EpdJSy+AQa4Jy43k5Q+iBVWq1V2QQ8dbkxm+mwoZe3e0
	n1T7pKfw7DmkvZRLK7R48GH9
X-Received: by 2002:a05:6214:33c4:b0:6dd:d3b:de4e with SMTP id 6a1803df08f44-6dd2339a922mr1051439526d6.36.1736264362704;
        Tue, 07 Jan 2025 07:39:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE4W8jiXvb2g7SfEbTpg7s86WYmhnjTSw6XGGd3uv3PzoxZkmqTCVHHTeUleWDp0snzmmaxAg==
X-Received: by 2002:a05:6214:33c4:b0:6dd:d3b:de4e with SMTP id 6a1803df08f44-6dd2339a922mr1051439056d6.36.1736264362302;
        Tue, 07 Jan 2025 07:39:22 -0800 (PST)
Received: from ?IPV6:2601:188:ca00:a00:f844:fad5:7984:7bd7? ([2601:188:ca00:a00:f844:fad5:7984:7bd7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dd181a7c13sm182664036d6.77.2025.01.07.07.39.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 07:39:21 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <a04eb7d4-4817-41db-bc74-a9fb63f33c5c@redhat.com>
Date: Tue, 7 Jan 2025 10:39:00 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/9] sched/isolation: document HK_TYPE housekeeping
 option
To: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Kashyap Desai
 <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 Don Brace <don.brace@microchip.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>
Cc: Costa Shulyupin <costa.shul@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider
 <vschneid@redhat.com>, Waiman Long <llong@redhat.com>,
 Ming Lei <ming.lei@redhat.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Frederic Weisbecker <frederic@kernel.org>,
 Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
 Sridhar Balaraman <sbalaraman@parallelwireless.com>,
 "brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 storagedev@microchip.com, virtualization@lists.linux.dev
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
 <20241217-isolcpus-io-queues-v4-2-5d355fbb1e14@kernel.org>
Content-Language: en-US
In-Reply-To: <20241217-isolcpus-io-queues-v4-2-5d355fbb1e14@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/17/24 1:29 PM, Daniel Wagner wrote:
> The enum is a public API which can be used all over the kernel. This
> warrants a bit of documentation.
>
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   include/linux/sched/isolation.h | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
>
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index 2b461129d1fad0fd0ef1ad759fe44695dc635e8c..6649c3a48e0ea0a88c84bf5f2a74bff039fadaf2 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -6,6 +6,19 @@
>   #include <linux/init.h>
>   #include <linux/tick.h>
>   
> +/**
> + * enum hk_type - housekeeping cpu mask types
> + * @HK_TYPE_TIMER:	housekeeping cpu mask for timers
> + * @HK_TYPE_RCU:	housekeeping cpu mask for RCU
> + * @HK_TYPE_MISC:	housekeeping cpu mask for miscalleanous resources
> + * @HK_TYPE_SCHED:	housekeeping cpu mask for scheduling
> + * @HK_TYPE_TICK:	housekeeping cpu maks for timer tick
> + * @HK_TYPE_DOMAIN:	housekeeping cpu mask for general SMP balancing
> + *			and scheduling algoririthms
> + * @HK_TYPE_WQ:		housekeeping cpu mask for worksqueues
> + * @HK_TYPE_MANAGED_IRQ: housekeeping cpu mask for managed IRQs
> + * @HK_TYPE_KTHREAD:	housekeeping cpu mask for kthreads
> + */
>   enum hk_type {
>   	HK_TYPE_TIMER,
>   	HK_TYPE_RCU,
>
The various housekeeping types are in the process of being consolidated 
as most of them cannot be set independently. See commit 6010d245ddc9 
("sched/isolation: Consolidate housekeeping cpumasks that are always 
identical") in linux-next or tip. So this patch will have conflict.

Cheers,
Longman


