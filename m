Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2A232572F
	for <linux-scsi@vger.kernel.org>; Fri,  9 Jan 2026 12:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963565; cv=none; b=iVtZ8Y0R1rmWh2SdyQRTuYKr4f7qeeaJMEgU3UcUctbYHIChgK2U0SKdfY9ILrrwXbsm8LZXa1SLmyu0/tZOENQTs+9nVVo26auDHTdfm+tRTXpGdq1Jf3qbayrL9k4CCQybwpkeyrlfViCOStzwMB8EkuAxVMtrASb8Nrbpso4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963565; c=relaxed/simple;
	bh=SywYImdD9t0SPL/FKsAXilQZf0r/LfY4dx2S63mfwZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fe7O554Q1ACjQbl5HNGtioenPfp9+PXvzQHDVVS8flBoZbDJXWvRMqLKIlIkbVUnXoLz3fiGbxztjJQ4uHaREqVU2T4KedHfqo9S03R7THAYt9/Yn+++OzuqI4ikiI37ATv5NwzBioA15kNJn8sdnO3ebTac1MbzBPD6oAXt2uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eRismp6N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eRismp6N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767963562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oXMA7qdNTbFAou+tiTx3NbdbqV4+2pXn9UDbRG9h2tE=;
	b=eRismp6Nvjc7OFBEankMWASllDJyk7hmpUTz8YIzgX4t/oyNyrcAy0+f9fVwgQC/SedJkA
	SONU/sFszmO4zEI8nKae/x9TVO1mJUR962RPnR6oPNgMbCoS5p1dWQDU0/GKPuTwddmy7l
	aWKVRXd6OQjHm8kc5tN3AjLLQHO4TLw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-343-ihnfsEvMODqXRqbL6EFWyQ-1; Fri,
 09 Jan 2026 07:59:19 -0500
X-MC-Unique: ihnfsEvMODqXRqbL6EFWyQ-1
X-Mimecast-MFC-AGG-ID: ihnfsEvMODqXRqbL6EFWyQ_1767963557
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 47C8B195609E;
	Fri,  9 Jan 2026 12:59:16 +0000 (UTC)
Received: from fedora (unknown [10.72.116.172])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BFE4D1956048;
	Fri,  9 Jan 2026 12:59:06 +0000 (UTC)
Date: Fri, 9 Jan 2026 20:58:55 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	James.Bottomley@hansenpartnership.com, leonro@nvidia.com,
	kch@nvidia.com, LKML <linux-kernel@vger.kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>, riteshh@linux.ibm.com,
	ojaswin@linux.ibm.com
Subject: Re: [next-20260108]kernel BUG at drivers/scsi/scsi_lib.c:1173!
Message-ID: <aWD7j3NR_m6EyZv1@fedora>
References: <9687cf2b-1f32-44e1-b58d-2492dc6e7185@linux.ibm.com>
 <aWCYl3I7GtsGXIG3@infradead.org>
 <aWClEA6KuLP6E1cP@fedora>
 <7382f235-3e42-4b77-b18d-c38661816301@linux.ibm.com>
 <aWDspG-J1a3iyIqG@fedora>
 <b7624213-65e5-41d4-81ba-e95f885018dd@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="d72Y9DGiNE0UCluM"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b7624213-65e5-41d4-81ba-e95f885018dd@linux.ibm.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17


--d72Y9DGiNE0UCluM
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jan 09, 2026 at 05:51:15PM +0530, Venkat Rao Bagalkote wrote:
> 
> On 09/01/26 5:25 pm, Ming Lei wrote:
> > On Fri, Jan 09, 2026 at 05:14:36PM +0530, Venkat Rao Bagalkote wrote:
> > > On 09/01/26 12:19 pm, Ming Lei wrote:
> > > > On Thu, Jan 08, 2026 at 09:56:39PM -0800, Christoph Hellwig wrote:
> > > > > I've seen the same when running xfstests on xfs, and bisected it to:
> > > > > 
> > > > > commit ee623c892aa59003fca173de0041abc2ccc2c72d
> > > > > Author: Ming Lei <ming.lei@redhat.com>
> > > > > Date:   Wed Dec 31 11:00:55 2025 +0800
> > > > > 
> > > > >       block: use bvec iterator helper for bio_may_need_split()
> > > > > 
> > > > Hi Christoph and Venkat Rao Bagalkote,
> > > > 
> > > > Unfortunately I can't duplicate the issue in my environment, can you test
> > > > the following patch?
> > > > 
> > > > diff --git a/block/blk.h b/block/blk.h
> > > > index 98f4dfd4ec75..980eef1f5690 100644
> > > > --- a/block/blk.h
> > > > +++ b/block/blk.h
> > > > @@ -380,7 +380,7 @@ static inline bool bio_may_need_split(struct bio *bio,
> > > >                   return true;
> > > >           bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
> > > > -       if (bio->bi_iter.bi_size > bv->bv_len)
> > > > +       if (bio->bi_iter.bi_size > bv->bv_len - bio->bi_iter.bi_bvec_done)
> > > >                   return true;
> > > >           return bv->bv_len + bv->bv_offset > lim->max_fast_segment_size;
> > > >    }
> > > Hello Ming,
> > > 
> > > 
> > > This is not helping. I am hitting this issue, during kernel build itself.
> > Can you confirm if it can fix the blktests ext4/056 first?
> > 
> > If kernel building is running over new patched kernel, please provide the
> > dmesg log. And if it is reproduciable, can you confirm if it can be fixed
> > by reverting ee623c892aa59003 (block: use bvec iterator helper for bio_may_need_split())?
> 
> 
> Unfortunately, even with revert, build fails.
> 
> 
> 
> commit c64b2ee9cddcb31546c8622ef018d344544a9388 (HEAD)
> Author: Super User <root@ltc-zzci-1.ltc.tadn.ibm.com>
> Date:   Fri Jan 9 06:51:19 2026 -0600
> 
>     Revert "block: use bvec iterator helper for bio_may_need_split()"
> 
>     This reverts commit ee623c892aa59003fca173de0041abc2ccc2c72d.

OK, then your issue isn't related with the above change.

Can you reproduce & collect dmesg log with the bad sg/rq/bio/bvec info by
applying the attached debug patch?

Also if possible, please collect your scsi queue's limit info before
reproducing the issue:

	(cd /sys/block/$SD/queue && find . -type f -exec grep -aH . {} \;)



Thanks, 
Ming

--d72Y9DGiNE0UCluM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rq-dbg.patch"

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index 752060d7261c..33c1b6a0a738 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -4,8 +4,75 @@
  */
 #include <linux/blk-integrity.h>
 #include <linux/blk-mq-dma.h>
+#include <linux/scatterlist.h>
 #include "blk.h"
 
+static void dump_rq_mapping_debug(struct request *rq, struct scatterlist *sglist,
+				  int nsegs)
+{
+	struct scatterlist *sg;
+	struct bio *bio;
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	int i;
+
+	pr_err("=== __blk_rq_map_sg DEBUG DUMP ===\n");
+	pr_err("DISK: %s\n", rq->q->disk ? rq->q->disk->disk_name : "(null)");
+
+	/* Dump nsegs vs expected */
+	pr_err("nsegs=%d nr_phys_segments=%u\n",
+	       nsegs, blk_rq_nr_phys_segments(rq));
+
+	/* Dump request info */
+	pr_err("REQUEST: __data_len=%u __sector=%llu cmd_flags=0x%x "
+	       "rq_flags=0x%x nr_phys_segments=%u phys_gap_bit=%u\n",
+	       rq->__data_len, (unsigned long long)rq->__sector,
+	       rq->cmd_flags, (__force unsigned int)rq->rq_flags,
+	       rq->nr_phys_segments, rq->phys_gap_bit);
+
+	/* Dump each SG element */
+	pr_err("--- SG LIST (%d entries) ---\n", nsegs);
+	for_each_sg(sglist, sg, nsegs, i) {
+		pr_err("  sg[%d]: pfn=0x%lx offset=%u len=%u dma_addr=0x%llx\n",
+		       i, page_to_pfn(sg_page(sg)), sg->offset, sg->length,
+		       (unsigned long long)sg_dma_address(sg));
+	}
+
+	/* Dump each bio */
+	pr_err("--- BIO LIST ---\n");
+	for (bio = rq->bio; bio; bio = bio->bi_next) {
+		pr_err("  BIO %p: bi_iter={sector=%llu size=%u idx=%u bvec_done=%u} "
+		       "bi_flags=0x%x bi_opf=0x%x bi_vcnt=%u bi_bvec_gap_bit=%u\n",
+		       bio,
+		       (unsigned long long)bio->bi_iter.bi_sector,
+		       bio->bi_iter.bi_size, bio->bi_iter.bi_idx,
+		       bio->bi_iter.bi_bvec_done,
+		       bio->bi_flags, bio->bi_opf, bio->bi_vcnt,
+		       bio->bi_bvec_gap_bit);
+
+		/* Dump each bvec in this bio */
+		pr_err("    --- BVECS (bi_vcnt=%u) ---\n", bio->bi_vcnt);
+		for (i = 0; i < bio->bi_vcnt; i++) {
+			struct bio_vec *bvp = &bio->bi_io_vec[i];
+
+			pr_err("      bvec[%d]: pfn=0x%lx len=%u offset=%u\n",
+			       i, page_to_pfn(bvp->bv_page), bvp->bv_len,
+			       bvp->bv_offset);
+		}
+
+		/* Also dump effective bvecs via iterator */
+		pr_err("    --- EFFECTIVE BVECS (via iter) ---\n");
+		i = 0;
+		bio_for_each_bvec(bv, bio, iter) {
+			pr_err("      eff_bvec[%d]: pfn=0x%lx len=%u offset=%u\n",
+			       i++, page_to_pfn(bv.bv_page), bv.bv_len,
+			       bv.bv_offset);
+		}
+	}
+
+	pr_err("=== END DEBUG DUMP ===\n");
+}
+
 static bool __blk_map_iter_next(struct blk_map_iter *iter)
 {
 	if (iter->iter.bi_size)
@@ -306,6 +373,8 @@ int __blk_rq_map_sg(struct request *rq, struct scatterlist *sglist,
 	 * Something must have been wrong if the figured number of
 	 * segment is bigger than number of req's physical segments
 	 */
+	if (nsegs > blk_rq_nr_phys_segments(rq))
+		dump_rq_mapping_debug(rq, sglist, nsegs);
 	WARN_ON(nsegs > blk_rq_nr_phys_segments(rq));
 
 	return nsegs;
diff --git a/block/blk.h b/block/blk.h
index 98f4dfd4ec75..980eef1f5690 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -380,7 +380,7 @@ static inline bool bio_may_need_split(struct bio *bio,
 		return true;
 
 	bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
-	if (bio->bi_iter.bi_size > bv->bv_len)
+	if (bio->bi_iter.bi_size > bv->bv_len - bio->bi_iter.bi_bvec_done)
 		return true;
 	return bv->bv_len + bv->bv_offset > lim->max_fast_segment_size;
 }

--d72Y9DGiNE0UCluM--

