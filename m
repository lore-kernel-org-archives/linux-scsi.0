Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5011E3DE8
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 10:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736245543; cv=none; b=b1kbV41xsP7uBs714PQUJPNF3v72cfk1VNKUTubO5P81/0J6jYhCJLgVM7iWBRzHihjZXvW/kf0i4XAvKsuhtMvNJX/ts3oJOC7vQt/g6x8UhbIuZFxiZB0p+pDG3h9ShjetzQ6J1eF75m0V6BaiDA4+fs5ZU37Zkcya3TWhAjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736245543; c=relaxed/simple;
	bh=Ltko/t9sUklM1UW/yxtw+NkoOQ3q5ebqnCUDhoIeACs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZ78K/nBcQ4mXyx4dbrlh6VmSB3apd8xy/Lwj2rvOYbbaeDCXAaFp6XT61NCZwDhrj+01HC+KztOEh8+5b/Fcq0fbmgA9uX6xVmufhetBJz3dECPEZ6s8dEazZV6JTIXORAocqEBfPXyjSud0LK7SO/7ktvwK0fZ4uPuEJYSQbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QwGzK0qc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QwGzK0qc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736245539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g+kgv40Nv3jmk18aQH5jxbGFwIkI3jfpro4OOu8qIeE=;
	b=QwGzK0qcfSUl+FIR3c9wA4D+1ZgGhpqQnszaxcsUt/ToQmBUFmzHgXN6N0W7tSE00jbL2M
	VfdA4b3lOLMnN9TQ+xd6v9zq2UgLWsOQpEMbKS5IJT/kVUEG2Z82oQpHBT4CXziK1bxL36
	qpJJ3+Um7rDUpt72P6nGLyoT1HA/LjI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-580-w5dnKRt2PPm84kKWsCv9qg-1; Tue,
 07 Jan 2025 05:25:36 -0500
X-MC-Unique: w5dnKRt2PPm84kKWsCv9qg-1
X-Mimecast-MFC-AGG-ID: w5dnKRt2PPm84kKWsCv9qg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A16BB19560A3;
	Tue,  7 Jan 2025 10:25:32 +0000 (UTC)
Received: from fedora (unknown [10.72.116.66])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 318F5195605F;
	Tue,  7 Jan 2025 10:25:25 +0000 (UTC)
Date: Tue, 7 Jan 2025 18:25:20 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 4/8] block: add a store_limit operations for sysfs entries
Message-ID: <Z30AsQq89_lcstNl@fedora>
References: <20250107063120.1011593-1-hch@lst.de>
 <20250107063120.1011593-5-hch@lst.de>
 <Z3zXANbFk6GBZg_z@fedora>
 <ae6b7727-64d6-4d9e-9bf5-951e38d8a768@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae6b7727-64d6-4d9e-9bf5-951e38d8a768@linux.ibm.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Jan 07, 2025 at 01:21:14PM +0530, Nilay Shroff wrote:
> 
> 
> On 1/7/25 12:55 PM, Ming Lei wrote:
> > On Tue, Jan 07, 2025 at 07:30:36AM +0100, Christoph Hellwig wrote:
> >> De-duplicate the code for updating queue limits by adding a store_limit
> >> method that allows having common code handle the actual queue limits
> >> update.
> >>
> >> Note that this is a pure refactoring patch and does not address the
> >> existing freeze vs limits lock order problem in the refactored code,
> >> which will be addressed next.
> >>
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>

...

> > Order between freeze and ->sysfs_lock is changed, and it may cause new
> > lockdep warning because we may freeze queue first before acquiring
> > ->sysfs_lock in del_gendisk().
> > 
> On contrary, in elevator_disable() and elevator_switch() we acquire 
> ->sysfs_lock first before freezing the queue. I think this is a mess and 
> we need to fix ordering. We need to decide ordering rules. IMO, the 
> correct order should be to acquire ->sysfs_lock before freezing queue. 
> Likewise with this patch now we acquire ->limits_lock before freezing the 
> queue.

__blk_mq_update_nr_hw_queues() freezes queue before acquiring ->syfs_lock too.

So yes, it is a mess wrt. order between ->sysfs_lock and freezing queue.


Thanks,
Ming

