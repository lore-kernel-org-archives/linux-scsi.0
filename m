Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B005786340
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jan 2025 03:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736132533; cv=none; b=RwcIEETehSFuSVx2RyCyIUbDxRbzagm6Sm3qaLip4mJ09IKBsuN/bK/JoOmTGt/rvGw+WW2a1F2zajQbuyhCzfmsOz+JSJDIyG9YBIPF0jMl95RU/jl7UV8y7HT08w2prMpXulDkQlndHwiB5UAID9exGJOQld7jxzU2IdiGTNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736132533; c=relaxed/simple;
	bh=SVbK895MZQ7KlVUxguEV0bCKzTPvHgQXiJCeqiZF/IE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a5EfQeWfIWVKmpHZaX0n2dhvQbCBpCaC0zyt1E4pnCe5I6z40f3pP4TPVQG0UWKsDtnFN+HmO8llcYgB0wZsXtZ0nsbwreGORv4nNDRcXh0yDzIYPEZIcKpDpgcdEb5tCHprOpfn0Cl9/3qfdeWxkTjLuSTtUsRLJAHPJGXpDuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LPiOYvCL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LPiOYvCL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736132530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QuJePIFMwbXTYOYRpOx/vNyM6sxPxRc6sYfg7toUIkM=;
	b=LPiOYvCLvgZlTwelBG/biwffRe3dtuN5kapUXFc08Q9T8vNfzAbAVBgDAjYFTblVIhanNK
	F9URD9FWf8sUkzFxnudvD6vStVixH61gkxPLwdtJjU/+zwgsvcIcmeFdqgAo1eJLAcM9zv
	Vi5PgrplUo/UXRcqr7nSQ5xX+LkVIiU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-275-LbBnK8huOoGU9VxByKFLmg-1; Sun,
 05 Jan 2025 22:02:07 -0500
X-MC-Unique: LbBnK8huOoGU9VxByKFLmg-1
X-Mimecast-MFC-AGG-ID: LbBnK8huOoGU9VxByKFLmg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8E3D19560AF;
	Mon,  6 Jan 2025 03:02:05 +0000 (UTC)
Received: from fedora (unknown [10.72.116.65])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 59B451956088;
	Mon,  6 Jan 2025 03:02:00 +0000 (UTC)
Date: Mon, 6 Jan 2025 11:01:55 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>
Subject: Re: [PATCH] scsi: avoid to send scsi command with ->queue_limits
 lock held
Message-ID: <Z3tHozKiUqWr7gjO@fedora>
References: <20241231042241.171227-1-ming.lei@redhat.com>
 <770947cc-6ce9-4ef0-8577-6966c7b8d555@kernel.org>
 <Z3srsii5EhZmnU9D@fedora>
 <1231beed-7c85-4c72-970c-a0f9d155f99d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231beed-7c85-4c72-970c-a0f9d155f99d@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Jan 06, 2025 at 10:30:10AM +0900, Damien Le Moal wrote:
> On 1/6/25 10:02 AM, Ming Lei wrote:
> > On Sat, Jan 04, 2025 at 04:17:47PM +0900, Damien Le Moal wrote:
> >> On 12/31/24 13:22, Ming Lei wrote:
> >>> Block request queue is often frozen before acquiring the queue
> >>> ->limits_lock.
> >>
> >> "often" is rather vague. What cases are we talking about here beside the block
> >> layer sysfs ->store() operations ? Fixing these is easy and does not need this
> >> change.
> > 
> > Is it really necessary to make freeze lock to depend on ->limits_lock?
> 
> Yes, because you do not want to have requests in-flight when applying new limits.

Thinking of further, actually almost all soft update in ->store()
needn't to freeze queue:

- all are scalar update 

- we can guarantee the new value is correct by validating first, so both
new val and old val are correct from device viewpoint

- the freeze is added recently in v6.11 af2814149883 ("block: freeze the queue
in queue_attr_store") for addressing nothing

Not mention sd_revalidate_disk() can be called in sd_open() without queue
freeze.

But update from hardware need queue to be frozen, or doing that before
disk is up.

My idea is to try to cut the lock chain, and your approach is to try to
order everything. From lock dependency viewpoint, it is simpler to
avoid the dependency from beginning because it is too complicated to
order everything.

> 
> > 
> > sd_revalidate_disk() is really one special case, so I think this patch
> > does correct thing.
> > 
> >>
> >> Furthermore, this change almost feels like a layering violation as it replicates
> >> most of the queue limits structure inside sd. This introducing a strong
> >> dependency to the block layer internals which we should avoid.
> > 
> > No.
> > 
> > block layer is common library, which is storage abstraction, so it is
> > pretty reasonable for storage drivers to depend block layer. You can
> > look at it from another way, if any related queue limits change, the
> > current storage driver need corresponding change too, with or without
> > this change.
> 
> Of course block device driver layers like SCSI depend on the block layer. But
> that dependency is at a high level API/function level. My concern is that your
> patch mimics too much the block layer implementation internals instead of
> relying on a high level API like we do now.

Here block layer API isn't involved, since block layer doesn't or can't
provide API to update single field of queue_limits.

Also the shadow sd_limits can be thought as one scsi's own hardware property
abstract, and its name just follows block layer queue's limits for the
sake of simplicity.

Long term, block layer may do similar categorization for queue_limits
according to function, then scsi disk's shadow structure can be removed
if scsi doesn't have special requirement.


Thanks,
Ming

