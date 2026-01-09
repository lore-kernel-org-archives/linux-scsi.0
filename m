Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A10335561
	for <linux-scsi@vger.kernel.org>; Fri,  9 Jan 2026 11:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959741; cv=none; b=d8mxnL/HDgBhNgF5kfd+wSp6cFW5QOvTsUy7jIlHc/IRtgLOXx5PTCJFDcl9eSENV68R4bBiT++R8C3ev6XuIcwAnaV0oisnnpfbEZOJeJKvd5Jz/soeXoJCdoz1CGfYFPn1P89BTsoC0dbREGdcI1Mq9ACpl3Y1Uvlx9/4l0HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959741; c=relaxed/simple;
	bh=Z739FYAYIIvmG4MSdnhHHzwozj2zLGtWN1XC7gmryjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WO8KSzZSHrxk8tte5l7qe/UX5rXMiXAjjtF5hCM3LOr2E11Wc16p3rVGX0Q4cdnat2xa2vRQb18mVi4XbmdR/DT21xWwrMkFgTr6UAbqWHNKd/kPFyuFp4QCKR33MxjAjUVRt2Q+0bs0DwnFCctGOZVv5SK2ddmCspEpfK+DbYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PaGKALBa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PaGKALBa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767959738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0mSZppuxX2FI0NhswuVxeOzkN1IhYqQGZUHhovnGBno=;
	b=PaGKALBaPCQk1FV128REfKfE9JaziuXyd28ga1HnWtrbsBTQZOEImUV+Fxu7cYXod9JS+i
	8X/7W/DRfnH28aig+xlKn/ezydXY4kamGSBTRmqHeH+Pe+76bD8oCaLAW2f2TyhEeX7lFj
	9lGV6O+SaY+C98q32F5VMC79QfI9qiE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-365-yiGW_dtlNlyj3nlCdCJHMA-1; Fri,
 09 Jan 2026 06:55:35 -0500
X-MC-Unique: yiGW_dtlNlyj3nlCdCJHMA-1
X-Mimecast-MFC-AGG-ID: yiGW_dtlNlyj3nlCdCJHMA_1767959734
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 45B4019560B7;
	Fri,  9 Jan 2026 11:55:33 +0000 (UTC)
Received: from fedora (unknown [10.72.116.172])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F23771954185;
	Fri,  9 Jan 2026 11:55:22 +0000 (UTC)
Date: Fri, 9 Jan 2026 19:55:16 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	James.Bottomley@hansenpartnership.com, leonro@nvidia.com,
	kch@nvidia.com, LKML <linux-kernel@vger.kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>, riteshh@linux.ibm.com,
	ojaswin@linux.ibm.com
Subject: Re: [next-20260108]kernel BUG at drivers/scsi/scsi_lib.c:1173!
Message-ID: <aWDspG-J1a3iyIqG@fedora>
References: <9687cf2b-1f32-44e1-b58d-2492dc6e7185@linux.ibm.com>
 <aWCYl3I7GtsGXIG3@infradead.org>
 <aWClEA6KuLP6E1cP@fedora>
 <7382f235-3e42-4b77-b18d-c38661816301@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7382f235-3e42-4b77-b18d-c38661816301@linux.ibm.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Jan 09, 2026 at 05:14:36PM +0530, Venkat Rao Bagalkote wrote:
> 
> On 09/01/26 12:19 pm, Ming Lei wrote:
> > On Thu, Jan 08, 2026 at 09:56:39PM -0800, Christoph Hellwig wrote:
> > > I've seen the same when running xfstests on xfs, and bisected it to:
> > > 
> > > commit ee623c892aa59003fca173de0041abc2ccc2c72d
> > > Author: Ming Lei <ming.lei@redhat.com>
> > > Date:   Wed Dec 31 11:00:55 2025 +0800
> > > 
> > >      block: use bvec iterator helper for bio_may_need_split()
> > > 
> > Hi Christoph and Venkat Rao Bagalkote,
> > 
> > Unfortunately I can't duplicate the issue in my environment, can you test
> > the following patch?
> > 
> > diff --git a/block/blk.h b/block/blk.h
> > index 98f4dfd4ec75..980eef1f5690 100644
> > --- a/block/blk.h
> > +++ b/block/blk.h
> > @@ -380,7 +380,7 @@ static inline bool bio_may_need_split(struct bio *bio,
> >                  return true;
> >          bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
> > -       if (bio->bi_iter.bi_size > bv->bv_len)
> > +       if (bio->bi_iter.bi_size > bv->bv_len - bio->bi_iter.bi_bvec_done)
> >                  return true;
> >          return bv->bv_len + bv->bv_offset > lim->max_fast_segment_size;
> >   }
> 
> Hello Ming,
> 
> 
> This is not helping. I am hitting this issue, during kernel build itself.

Can you confirm if it can fix the blktests ext4/056 first?

If kernel building is running over new patched kernel, please provide the
dmesg log. And if it is reproduciable, can you confirm if it can be fixed
by reverting ee623c892aa59003 (block: use bvec iterator helper for bio_may_need_split())?


Thanks,
Ming

