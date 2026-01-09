Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F8532A3C3
	for <linux-scsi@vger.kernel.org>; Fri,  9 Jan 2026 14:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767967534; cv=none; b=SAiRJxP3g/2ibWk5hO3BYN285DRN3QnPb/VXchltrzRn4DWEnHws9XSsCGNbImPwMzhx4mUGtY0f50iYTv+zaryygqLajHArRSup37ioxhvp8MiQWXfnUyToc176sy0CB12ITJvBZoA2KfBTqdGWGOegU3pQgdb/GVKbpcjMYBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767967534; c=relaxed/simple;
	bh=1sdUxxxMj6Te9VUMe441yvD/bJT+sFEfb52bL1MG9Ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JewvNjEbCVNF4d1ilHP0Cd2xW4QXbGDPqvwrSjn4jqjUHBi6Z4AeP9aPdraNorf2BLDYrYxsiHHHDLg2F2fbeneKMW5jIDqKWc7xseo8NgFcatBxv4qnqZIwaFiX4qSw6taeA/BtT4952502huHPUfaTknJsk2BbYc4DF28icmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fiqpzWaT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fiqpzWaT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767967532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b3VglsdfHUODaL3LC/M2IqYKAkFnhhVnuDB4v1OmwBk=;
	b=fiqpzWaT8E5pDBU7Kb0U6U8UY/QuqXm4lxQfO8GT2qvRpd6jXMiv5kL/1Svo+v3jvmOykK
	ML1MEoeEPIurvK1VnfnFPyph4/IayPmeA1As3x2+Kg7dUwE8+67z1RAh/AzKMEePYAhdh9
	HmKa574ShBfj13gs2DciqyYgXjSEqCE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-592-O2MSAqv5NfuaIoXzaYFNQQ-1; Fri,
 09 Jan 2026 09:05:29 -0500
X-MC-Unique: O2MSAqv5NfuaIoXzaYFNQQ-1
X-Mimecast-MFC-AGG-ID: O2MSAqv5NfuaIoXzaYFNQQ_1767967527
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA4EC19560B7;
	Fri,  9 Jan 2026 14:05:26 +0000 (UTC)
Received: from fedora (unknown [10.72.116.172])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 763D31800995;
	Fri,  9 Jan 2026 14:05:17 +0000 (UTC)
Date: Fri, 9 Jan 2026 22:05:12 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	James.Bottomley@hansenpartnership.com, leonro@nvidia.com,
	kch@nvidia.com, LKML <linux-kernel@vger.kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>, riteshh@linux.ibm.com,
	ojaswin@linux.ibm.com
Subject: Re: [next-20260108]kernel BUG at drivers/scsi/scsi_lib.c:1173!
Message-ID: <aWELGGBf1Sl3RK6k@fedora>
References: <9687cf2b-1f32-44e1-b58d-2492dc6e7185@linux.ibm.com>
 <aWCYl3I7GtsGXIG3@infradead.org>
 <aWClEA6KuLP6E1cP@fedora>
 <7382f235-3e42-4b77-b18d-c38661816301@linux.ibm.com>
 <aWDspG-J1a3iyIqG@fedora>
 <b7624213-65e5-41d4-81ba-e95f885018dd@linux.ibm.com>
 <aWD7j3NR_m6EyZv1@fedora>
 <ab7635d7-70e7-4906-bdcf-90006d7edf85@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ab7635d7-70e7-4906-bdcf-90006d7edf85@linux.ibm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Fri, Jan 09, 2026 at 07:26:01PM +0530, Venkat Rao Bagalkote wrote:
> 
> On 09/01/26 6:28 pm, Ming Lei wrote:
> > On Fri, Jan 09, 2026 at 05:51:15PM +0530, Venkat Rao Bagalkote wrote:
> > > On 09/01/26 5:25 pm, Ming Lei wrote:
> > > > On Fri, Jan 09, 2026 at 05:14:36PM +0530, Venkat Rao Bagalkote wrote:
> > > > > On 09/01/26 12:19 pm, Ming Lei wrote:
> > > > > > On Thu, Jan 08, 2026 at 09:56:39PM -0800, Christoph Hellwig wrote:
> > > > > > > I've seen the same when running xfstests on xfs, and bisected it to:
> > > > > > > 
> > > > > > > commit ee623c892aa59003fca173de0041abc2ccc2c72d
> > > > > > > Author: Ming Lei <ming.lei@redhat.com>
> > > > > > > Date:   Wed Dec 31 11:00:55 2025 +0800
> > > > > > > 
> > > > > > >        block: use bvec iterator helper for bio_may_need_split()
> > > > > > > 
> > > > > > Hi Christoph and Venkat Rao Bagalkote,
> > > > > > 
> > > > > > Unfortunately I can't duplicate the issue in my environment, can you test
> > > > > > the following patch?
> > > > > > 
> > > > > > diff --git a/block/blk.h b/block/blk.h
> > > > > > index 98f4dfd4ec75..980eef1f5690 100644
> > > > > > --- a/block/blk.h
> > > > > > +++ b/block/blk.h
> > > > > > @@ -380,7 +380,7 @@ static inline bool bio_may_need_split(struct bio *bio,
> > > > > >                    return true;
> > > > > >            bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
> > > > > > -       if (bio->bi_iter.bi_size > bv->bv_len)
> > > > > > +       if (bio->bi_iter.bi_size > bv->bv_len - bio->bi_iter.bi_bvec_done)
> > > > > >                    return true;
> > > > > >            return bv->bv_len + bv->bv_offset > lim->max_fast_segment_size;
> > > > > >     }
> > > > > Hello Ming,
> > > > > 
> > > > > 
> > > > > This is not helping. I am hitting this issue, during kernel build itself.
> > > > Can you confirm if it can fix the blktests ext4/056 first?
> > > > 
> > > > If kernel building is running over new patched kernel, please provide the
> > > > dmesg log. And if it is reproduciable, can you confirm if it can be fixed
> > > > by reverting ee623c892aa59003 (block: use bvec iterator helper for bio_may_need_split())?
> > > 
> > > Unfortunately, even with revert, build fails.
> > > 
> > > 
> > > 
> > > commit c64b2ee9cddcb31546c8622ef018d344544a9388 (HEAD)
> > > Author: Super User <root@ltc-zzci-1.ltc.tadn.ibm.com>
> > > Date:   Fri Jan 9 06:51:19 2026 -0600
> > > 
> > >      Revert "block: use bvec iterator helper for bio_may_need_split()"
> > > 
> > >      This reverts commit ee623c892aa59003fca173de0041abc2ccc2c72d.
> > OK, then your issue isn't related with the above change.
> > 
> > Can you reproduce & collect dmesg log with the bad sg/rq/bio/bvec info by
> > applying the attached debug patch?
> > 
> > Also if possible, please collect your scsi queue's limit info before
> > reproducing the issue:
> > 
> > 	(cd /sys/block/$SD/queue && find . -type f -exec grep -aH . {} \;)
> 
> Hello Ming,
> 
> After applying the patch shared via attachment also, I see build failure.
> 
> I have attached the kernel config file.
> 
> 
> git diff
> diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
> index 752060d7261c..33c1b6a0a738 100644
> --- a/block/blk-mq-dma.c
> +++ b/block/blk-mq-dma.c
> @@ -4,8 +4,75 @@
>   */
>  #include <linux/blk-integrity.h>
>  #include <linux/blk-mq-dma.h>
> +#include <linux/scatterlist.h>
>  #include "blk.h"

Hi Venkat,

Thanks for your test.

But you didn't apply the whole debug patch in the following link:

https://lore.kernel.org/linux-block/aWD7j3NR_m6EyZv1@fedora/

otherwise something like "=== __blk_rq_map_sg DEBUG DUMP ===" will be
dumped in dmesg log.

> 
> make -j 48 -s && make modules_install && make install
> [ 5625.770436] ------------[ cut here ]------------
> [ 5625.770476] WARNING: block/blk-mq-dma.c:309 at

If the whole debug patch is applied correctly, the above line number should
have become 378 instead of original 309.

Please re-apply the debug patch & reproduce again.


Thanks, 
Ming

