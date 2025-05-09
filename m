Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D6D136672
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 01:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746755044; cv=none; b=puUiZvshv+GIZK7HKXUvhnub3GG83pDz55BP9yka1EUizlFHt63k90U4W+T84B6NWa91DjLk6pQ42G7LLUT54N+6FVq793Y/JTFMXcuYkDhjxG2we3nr9+8wv0V3ytYl6bAQvOysimsE1L1DUfPcOOdyb5/nDGdJZfjHCuf5lNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746755044; c=relaxed/simple;
	bh=njVig9ivo+i7YZm6pL5avQT7b85PeWJst1byYA9XM5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/8YRqMfirKS5c/uxQof2wuv2ToL7xKK8N2o9FKDTBaAqiT26WFphwOFGoHmj0B9j7YC9cfVrSRYAp/bLZ3RidgcNdn7GAu9sIZ2RMrUx9H7/eiPs6po8bhzFutlWJZDTFWfCHWXJS0FaoLlV/z1/5Z3/uyiC0WoDY5HUgxsLq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HT55Q9iU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HT55Q9iU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746755041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R1UZqb8T+DJxJnFpIsj/84dkc0Y9kPgWUwdXxP3YPOQ=;
	b=HT55Q9iUrqYoL3VQDh5tcUN/V5obvoINPJfCJK2h6lhg5/P1hgrOKzAYDgLUe7faJ/Tx8C
	25HwcMhjDFjLnGIzhOq5HGRoRTx+MpwWl4/Hu0cbduJ5zOXuav+XoyPNC9gA/wpC4UUEKF
	UPBqHyuA1Zd6G2YMObNc6yTiJuAlNhA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512-X1ua77XCO4K_Xsqy8wczjg-1; Thu,
 08 May 2025 21:43:58 -0400
X-MC-Unique: X1ua77XCO4K_Xsqy8wczjg-1
X-Mimecast-MFC-AGG-ID: X1ua77XCO4K_Xsqy8wczjg_1746755035
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB4F81956094;
	Fri,  9 May 2025 01:43:54 +0000 (UTC)
Received: from fedora (unknown [10.72.116.120])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B54BF30001A1;
	Fri,  9 May 2025 01:43:41 +0000 (UTC)
Date: Fri, 9 May 2025 09:43:36 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Daniel Wagner <wagi@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Costa Shulyupin <costa.shul@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Waiman Long <llong@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org, storagedev@microchip.com,
	virtualization@lists.linux.dev,
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v6 2/9] blk-mq: add number of queue calc helper
Message-ID: <aB1dyLaThXz8TpOH@fedora>
References: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
 <20250424-isolcpus-io-queues-v6-2-9a53a870ca1f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424-isolcpus-io-queues-v6-2-9a53a870ca1f@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Apr 24, 2025 at 08:19:41PM +0200, Daniel Wagner wrote:
> Multiqueue devices should only allocate queues for the housekeeping CPUs
> when isolcpus=io_queue is set. This avoids that the isolated CPUs get
> disturbed with OS workload.

io_queue isn't introduced yet, so the commit log needs to be updated.

Otherwise, looks fine:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks, 
Ming

