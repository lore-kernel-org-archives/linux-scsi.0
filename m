Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DEE2206AC
	for <linux-scsi@vger.kernel.org>; Thu, 19 Dec 2024 08:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734597083; cv=none; b=LD3YkZ8Ml/4S7upSNcFadFgHblzCCYAp/AYLAk5uLGujWUvP2KVFlrVy5cY6DhVSYzCRK4Cr7rF2wz78yn566g4+ltg0sJGCGopAAXyUyZktbDDIyCFF2tRHaUq3lAt+KCF+/3jezVkZkzMYk0qX+WR9nKd8NscsHttZq43NMcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734597083; c=relaxed/simple;
	bh=2IM8Isl/HvcjVPdOdCc+YEyWJcS5dGDRruGLb2kRjFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u+DfGI0ynpbAqq/GccYVVSpDNyB5rZW41mvS0WXUuLNMJW+KFWnCBmX5BD/8FV2bcxEiGVd+TbDCEmCzZ7O58NXsGw0Xhr8rIVHKBWjYIE/JtZe5iRchnEPk6WZhST+05g3VFP3aEnZWKlcMWnvJo3pGgjrHEeN5DbQAt0XvSH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zx4accGI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zx4accGI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734597078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HKgfqq1V/q2Bw/na+eWOMQ9Qre2mVUN/gi9oaR1AL+A=;
	b=Zx4accGIe07HfV0SCAeZZWSgNa9Rjz/OqD2X8vdwSQ0QveNV2l5WGHIzHklgOR/sjwPHp1
	EwFAZJWmiL1E1D2NtCxMQrjmeawEFqlKICDGcVSVsbE9aWORqcj3xP7tx2fIZ+Ix3A2Ydn
	BradhHY7lm/WxFoNdWNya8tnAz+dO7Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-YDyXju_VPVmpg0nswj6SkA-1; Thu, 19 Dec 2024 03:31:16 -0500
X-MC-Unique: YDyXju_VPVmpg0nswj6SkA-1
X-Mimecast-MFC-AGG-ID: YDyXju_VPVmpg0nswj6SkA
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361f371908so4263955e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Dec 2024 00:31:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734597075; x=1735201875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HKgfqq1V/q2Bw/na+eWOMQ9Qre2mVUN/gi9oaR1AL+A=;
        b=EpR2awbXT/fYIHermHSQAmqZ2RcEJ2zufGGNQAU7tBLpxRSR99t0KPlrVW+yw+c6b4
         c69ZPIt4rhW3toJ6ljhueMzBOsI14h2/HcR+yCxECh5x/hqiYm5kSYK3OcyDr93SPS+I
         Jc62Rre/gLWI+NkeMzrZoMyE6kIeFmP6xT7kylIF7XgKGem1bTvrpEBad4u9/WsER5DX
         zayEWdxM23A4PLI9P7MZRrtsxaeWFwoPRBdJRIUiNGCQfm0n4ptlYsX398JeAO/BYM8x
         e6yaOzLS+4XrMLAhR2o6q/XZMJagQ4mvyDI+M7zYX9+xyJwVdB8Fol/chv9yR8DdkkFJ
         RlwQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5DoV8Aany5ye0NtpfPnaqvude6mHqhex8ZADIMhmT14L3YOvGLgKGJgxzk/VlxUuhuUBp9SRKk8PX@vger.kernel.org
X-Gm-Message-State: AOJu0YxlhLr0Ako6nM4AdXMm8eiM4iQSJXwuwOMU3U8PUvBiuFWiJiKG
	NxwQDLsaPMKyoGy3D3XGVzJYKBPO2bMtfrAsXCUR3YwRFMNvugfAV7tn2DF1Lucb3Y6OsIqzAfQ
	gtdR0iI3Yeq4He3MibX5PfwpMcU4uM2y8ZTuPSXe4LpJ7kP6yyhbvNFNBYLY=
X-Gm-Gg: ASbGncsmMes6LYs/tf0jZoNiZTYDtv5N01qhlKwHJ4N3/3pvtPpyc4fFNQD3QvVxqCs
	iGz1/Sq/fQ6PYgVjppMZQD1JAiC4NWMIIXSMipsSqSYVwbVI0f+0lhTFFcxiKmYa80OWaXZykUN
	wFtpW5Y/o1W6z/A17cIx20H8OOO5MqtL6WMQ7yQeTZWmiyXjBIacfo3iHIDWDPI6tANiv/dIgoA
	XmK6voxBQkj/5I0J1rKBYTBU3TC97hCtF6PBFg7+L7zn5dO3w==
X-Received: by 2002:a05:600c:4ed2:b0:434:f7ea:fb44 with SMTP id 5b1f17b1804b1-4365535c6a3mr57458565e9.14.1734597075387;
        Thu, 19 Dec 2024 00:31:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHmEAGsD3J5lAW4FA+s63y3sWjvKNvfQZ3gFL7w0rvckTj28XiNMSxT5zIucbWC042DWgnKHg==
X-Received: by 2002:a05:600c:4ed2:b0:434:f7ea:fb44 with SMTP id 5b1f17b1804b1-4365535c6a3mr57458095e9.14.1734597074934;
        Thu, 19 Dec 2024 00:31:14 -0800 (PST)
Received: from redhat.com ([2a02:14f:1f6:4834:3deb:8c9:181b:4574])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b4432dsm44515275e9.41.2024.12.19.00.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 00:31:14 -0800 (PST)
Date: Thu, 19 Dec 2024 03:31:05 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Daniel Wagner <wagi@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Don Brace <don.brace@microchip.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Costa Shulyupin <costa.shul@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
	Sridhar Balaraman <sbalaraman@parallelwireless.com>,
	"brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	storagedev@microchip.com, virtualization@lists.linux.dev
Subject: Re: [PATCH v4 6/9] virtio: blk/scsi: use block layer helpers to
 calculate num of queues
Message-ID: <20241219032956-mutt-send-email-mst@kernel.org>
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
 <20241217-isolcpus-io-queues-v4-6-5d355fbb1e14@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217-isolcpus-io-queues-v4-6-5d355fbb1e14@kernel.org>

On Tue, Dec 17, 2024 at 07:29:40PM +0100, Daniel Wagner wrote:
> Multiqueue devices should only allocate queues for the housekeeping CPUs
> when isolcpus=managed_irq is set. This avoids that the isolated CPUs get
> disturbed with OS workload.
> 
> Use helpers which calculates the correct number of queues which should
> be used when isolcpus is used.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>

The subject is misleading, one thinks it is onlu virtio blk.
It's best to just split each driver in a patch by its own.
for the changes in virtio:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/block/virtio_blk.c                | 5 ++---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
>  drivers/scsi/virtio_scsi.c                | 1 +
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index ed514ff46dc82acd629ae594cb0fa097bd301a9b..0287ceaaf19972f3a18e81cd2e3252e4d539ba93 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -976,9 +976,8 @@ static int init_vq(struct virtio_blk *vblk)
>  		return -EINVAL;
>  	}
>  
> -	num_vqs = min_t(unsigned int,
> -			min_not_zero(num_request_queues, nr_cpu_ids),
> -			num_vqs);
> +	num_vqs = blk_mq_num_possible_queues(
> +			min_not_zero(num_request_queues, num_vqs));
>  
>  	num_poll_vqs = min_t(unsigned int, poll_queues, num_vqs - 1);
>  
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 59d385e5a917979ae2f61f5db2c3355b9cab7e08..3ff0978b3acb5baf757fee25d9fccf4971976272 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -6236,7 +6236,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
>  		intr_coalescing = (scratch_pad_1 & MR_INTR_COALESCING_SUPPORT_OFFSET) ?
>  								true : false;
>  		if (intr_coalescing &&
> -			(blk_mq_num_online_queues(0) >= MR_HIGH_IOPS_QUEUE_COUNT) &&
> +			(blk_mq_num_online_queues(0) >=
> +			 MR_HIGH_IOPS_QUEUE_COUNT) &&
>  			(instance->msix_vectors == MEGASAS_MAX_MSIX_QUEUES))
>  			instance->perf_mode = MR_BALANCED_PERF_MODE;
>  		else
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 60be1a0c61836ba643adcf9ad8d5b68563a86cb1..46ca0b82f57ce2211c7e2817dd40ee34e65bcbf9 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -919,6 +919,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  	/* We need to know how many queues before we allocate. */
>  	num_queues = virtscsi_config_get(vdev, num_queues) ? : 1;
>  	num_queues = min_t(unsigned int, nr_cpu_ids, num_queues);
> +	num_queues = blk_mq_num_possible_queues(num_queues);
>  
>  	num_targets = virtscsi_config_get(vdev, max_target) + 1;
>  
> 
> -- 
> 2.47.1

