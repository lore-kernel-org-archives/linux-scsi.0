Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9413813C807
	for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2024 03:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732159088; cv=none; b=SVTAy4caRATaUXy9leapg1e2ZrWmDf/+Foj2XAwjwAJGxCapsakQP2Ytgq9bH0RPw+N3inGrphX82+uh2yWEWxmfckx2ZAlMiQJmu2+dDzr+wIAwclTwt2owC1LkDnEEmpufnLA2YDIVxaHojNa6T3topQIoBFeL+hM2Ut9nTjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732159088; c=relaxed/simple;
	bh=Gv2WTv/RHyyTjXZzvU6darKROH8goLI5nvGgzCz7ycI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dqYUAN8YZnz5RevBgvETuQi1oeSUeFEWPrKofnndv94jC62YPSbGtobUC6hO9BPCPAWVI0gf9n8X9Za0YoRmR6SZFLabGP/CGfrHJ8CVkYb67flxi9xjHxdmp4GeSVb6gUzT1pYbD4wN55koSSr62IaZLU071JuE7ni/jkeTA5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dE5Q5sUq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dE5Q5sUq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732159085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R+WIG4TPfrG4VASxbGrgOqgHpj5Duzkfx8Vl/VFOUF0=;
	b=dE5Q5sUqOyykNvZbccpHXIZLVluf9V88YIEmMJhEGxec1VoEE7AuI+7oGIgIV1bZacJqiI
	d9goeOd21Rs3lIFfKRmWpJIG7btMnfejvTHzMQLkXkF5aLPVkoI/VjEMpmat4TSbV47xTS
	2+1bV3rtzlGQc1IShYlF+NKQyOXHpVg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-389-PeCzXuiKPk2GasMU42hR-Q-1; Wed,
 20 Nov 2024 22:18:01 -0500
X-MC-Unique: PeCzXuiKPk2GasMU42hR-Q-1
X-Mimecast-MFC-AGG-ID: PeCzXuiKPk2GasMU42hR-Q
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1A421956077;
	Thu, 21 Nov 2024 03:17:57 +0000 (UTC)
Received: from fedora (unknown [10.72.116.87])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 335FB1956086;
	Thu, 21 Nov 2024 03:17:43 +0000 (UTC)
Date: Thu, 21 Nov 2024 11:17:38 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Daniel Wagner <wagi@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	John Garry <john.g.garry@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com, storagedev@microchip.com,
	linux-nvme@lists.infradead.org
Subject: Re: [PATCH v5 7/8] virtio: blk/scsi: replace
 blk_mq_virtio_map_queues with blk_mq_map_hw_queues
Message-ID: <Zz6mUlLliyL73Xyf@fedora>
References: <20241115-refactor-blk-affinity-helpers-v5-0-c472afd84d9f@kernel.org>
 <20241115-refactor-blk-affinity-helpers-v5-7-c472afd84d9f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115-refactor-blk-affinity-helpers-v5-7-c472afd84d9f@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Nov 15, 2024 at 05:37:51PM +0100, Daniel Wagner wrote:
> Replace all users of blk_mq_virtio_map_queues with the more generic
> blk_mq_map_hw_queues. This in preparation to retire
> blk_mq_virtio_map_queues.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Daniel Wagner <wagi@kernel.org>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

