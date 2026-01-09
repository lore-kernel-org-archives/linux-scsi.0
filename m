Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739B635FF6C
	for <linux-scsi@vger.kernel.org>; Fri,  9 Jan 2026 14:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767969657; cv=none; b=MBkI+x4w5PuY2TDZUUIAp1XwxvB86Nn2APvlrMKRK7g3MdZ2dC6Tj1aMr0lc0oyb/1azP7iS8e5G79KBYc8bgtcv5jAU3Ji8x4Cj/FdLCCswB4vODAG9oewf8Rw7J9QK6Fv/h2I5xO7hA1i2MscwFl6k7ge2VJ9U1MMr1ZU+K7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767969657; c=relaxed/simple;
	bh=5jlOfYj+ObCR52PVgF13Z89GSOj3yoygabUG550Aazg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cPUvHyDF5Z6nJhn2dXdCNB70+gwt2JFsOwMWwJV5dDwh8rUXzKYHOdmu6zC5r+pQMnR/pMQHQFvYA3DLN/Sw/Q27s6RX3EiB9LfQdNc80WFMex8S2D7nUMkLLRPRQ49ZFSdcnsgD8v9utCGKbr7MpcGcMPaiF79bt4cO8fdzgis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UG9RBn/2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UG9RBn/2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767969655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4WZOrllwhvLAdn1gTsOABlv26CL05TG42u6HT7EiAos=;
	b=UG9RBn/2/Wp3dXwoFtEFUNen381Be0oq7LHElmbx7vsmQGpt2cm+6zM+kKco5kCZymVtSh
	cqp68/Eb1peGGOLTJokzKCyx1HAgGSyoUJk4Z1x5Bv9yP6TwbE61QDImOaBnCFnVvYvIrt
	CS5/SSO+y3GT/GsrlirmLJbNgOU3vpQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-611-e6P9twM5NRK4iZ5JdkpsHA-1; Fri,
 09 Jan 2026 09:40:51 -0500
X-MC-Unique: e6P9twM5NRK4iZ5JdkpsHA-1
X-Mimecast-MFC-AGG-ID: e6P9twM5NRK4iZ5JdkpsHA_1767969647
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B38721956053;
	Fri,  9 Jan 2026 14:40:47 +0000 (UTC)
Received: from fedora (unknown [10.72.116.172])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A7AD30002D1;
	Fri,  9 Jan 2026 14:40:40 +0000 (UTC)
Date: Fri, 9 Jan 2026 22:40:29 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	James.Bottomley@hansenpartnership.com, leonro@nvidia.com,
	kch@nvidia.com, LKML <linux-kernel@vger.kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>, riteshh@linux.ibm.com,
	ojaswin@linux.ibm.com
Subject: Re: [next-20260108]kernel BUG at drivers/scsi/scsi_lib.c:1173!
Message-ID: <aWETXSLwAYOVdB9J@fedora>
References: <9687cf2b-1f32-44e1-b58d-2492dc6e7185@linux.ibm.com>
 <aWCYl3I7GtsGXIG3@infradead.org>
 <aWClEA6KuLP6E1cP@fedora>
 <7382f235-3e42-4b77-b18d-c38661816301@linux.ibm.com>
 <aWDspG-J1a3iyIqG@fedora>
 <b7624213-65e5-41d4-81ba-e95f885018dd@linux.ibm.com>
 <aWD7j3NR_m6EyZv1@fedora>
 <ab7635d7-70e7-4906-bdcf-90006d7edf85@linux.ibm.com>
 <aWELGGBf1Sl3RK6k@fedora>
 <4c85df85-58f7-4e44-8201-2f0562f93439@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4c85df85-58f7-4e44-8201-2f0562f93439@linux.ibm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Jan 09, 2026 at 07:53:00PM +0530, Venkat Rao Bagalkote wrote:
> 
> On 09/01/26 7:35 pm, Ming Lei wrote:
> > On Fri, Jan 09, 2026 at 07:26:01PM +0530, Venkat Rao Bagalkote wrote:
> > > On 09/01/26 6:28 pm, Ming Lei wrote:
> > > > On Fri, Jan 09, 2026 at 05:51:15PM +0530, Venkat Rao Bagalkote wrote:
> > > > > On 09/01/26 5:25 pm, Ming Lei wrote:
> > > > > > On Fri, Jan 09, 2026 at 05:14:36PM +0530, Venkat Rao Bagalkote wrote:
> > > > > > > On 09/01/26 12:19 pm, Ming Lei wrote:
> > > > > > > > On Thu, Jan 08, 2026 at 09:56:39PM -0800, Christoph Hellwig wrote:
> > > > > > > > > I've seen the same when running xfstests on xfs, and bisected it to:
> > > > > > > > > 
> > > > > > > > > commit ee623c892aa59003fca173de0041abc2ccc2c72d
> > > > > > > > > Author: Ming Lei <ming.lei@redhat.com>
> > > > > > > > > Date:   Wed Dec 31 11:00:55 2025 +0800
> > > > > > > > > 
> > > > > > > > >         block: use bvec iterator helper for bio_may_need_split()
> > > > > > > > > 
> > > > > > > > Hi Christoph and Venkat Rao Bagalkote,
> > > > > > > > 
> > > > > > > > Unfortunately I can't duplicate the issue in my environment, can you test
> > > > > > > > the following patch?
> > > > > > > > 
> > > > > > > > diff --git a/block/blk.h b/block/blk.h
> > > > > > > > index 98f4dfd4ec75..980eef1f5690 100644
> > > > > > > > --- a/block/blk.h
> > > > > > > > +++ b/block/blk.h
> > > > > > > > @@ -380,7 +380,7 @@ static inline bool bio_may_need_split(struct bio *bio,
> > > > > > > >                     return true;
> > > > > > > >             bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
> > > > > > > > -       if (bio->bi_iter.bi_size > bv->bv_len)
> > > > > > > > +       if (bio->bi_iter.bi_size > bv->bv_len - bio->bi_iter.bi_bvec_done)
> > > > > > > >                     return true;
> > > > > > > >             return bv->bv_len + bv->bv_offset > lim->max_fast_segment_size;
> > > > > > > >      }
> > > > > > > Hello Ming,
> > > > > > > 
> > > > > > > 
> > > > > > > This is not helping. I am hitting this issue, during kernel build itself.
> > > > > > Can you confirm if it can fix the blktests ext4/056 first?
> > > > > > 
> > > > > > If kernel building is running over new patched kernel, please provide the
> > > > > > dmesg log. And if it is reproduciable, can you confirm if it can be fixed
> > > > > > by reverting ee623c892aa59003 (block: use bvec iterator helper for bio_may_need_split())?
> > > > > Unfortunately, even with revert, build fails.
> > > > > 
> > > > > 
> > > > > 
> > > > > commit c64b2ee9cddcb31546c8622ef018d344544a9388 (HEAD)
> > > > > Author: Super User <root@ltc-zzci-1.ltc.tadn.ibm.com>
> > > > > Date:   Fri Jan 9 06:51:19 2026 -0600
> > > > > 
> > > > >       Revert "block: use bvec iterator helper for bio_may_need_split()"
> > > > > 
> > > > >       This reverts commit ee623c892aa59003fca173de0041abc2ccc2c72d.
> > > > OK, then your issue isn't related with the above change.
> > > > 
> > > > Can you reproduce & collect dmesg log with the bad sg/rq/bio/bvec info by
> > > > applying the attached debug patch?
> > > > 
> > > > Also if possible, please collect your scsi queue's limit info before
> > > > reproducing the issue:
> > > > 
> > > > 	(cd /sys/block/$SD/queue && find . -type f -exec grep -aH . {} \;)
> > > Hello Ming,
> > > 
> > > After applying the patch shared via attachment also, I see build failure.
> > > 
> > > I have attached the kernel config file.
> > > 
> > > 
> > > git diff
> > > diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
> > > index 752060d7261c..33c1b6a0a738 100644
> > > --- a/block/blk-mq-dma.c
> > > +++ b/block/blk-mq-dma.c
> > > @@ -4,8 +4,75 @@
> > >    */
> > >   #include <linux/blk-integrity.h>
> > >   #include <linux/blk-mq-dma.h>
> > > +#include <linux/scatterlist.h>
> > >   #include "blk.h"
> > Hi Venkat,
> > 
> > Thanks for your test.
> > 
> > But you didn't apply the whole debug patch in the following link:
> > 
> > https://lore.kernel.org/linux-block/aWD7j3NR_m6EyZv1@fedora/
> > 
> > otherwise something like "=== __blk_rq_map_sg DEBUG DUMP ===" will be
> > dumped in dmesg log.
> > 
> > > make -j 48 -s && make modules_install && make install
> > > [ 5625.770436] ------------[ cut here ]------------
> > > [ 5625.770476] WARNING: block/blk-mq-dma.c:309 at
> > If the whole debug patch is applied correctly, the above line number should
> > have become 378 instead of original 309.
> > 
> > Please re-apply the debug patch & reproduce again.
> > 
> 
> Hello Ming,
> 
> 
> Apologies for back and forth. But I did apply the whole patch. Below is the
> git diff from my machine. Let me know, if I am missing anything.

OK, the patch is correct.

But you need to boot with one good kernel(such as, distribution shipped kernel) first
for building new test kernel against -next tree with this patch.

After this new test kernel is built & installed & reboot, you can start your
kernel build workload, then the issue will be triggered, and the log is
collected.

When the issue is triggered, `WARNING: block/blk-mq-dma.c:378 ` should be
shown in dmesg log, which signals you are running the test kernel with the
debug patch for collecting log.

Please let me know if anything is clear.

Thanks,
Ming

