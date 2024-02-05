Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EC113FF0
	for <linux-scsi@vger.kernel.org>; Mon,  5 Feb 2024 10:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707127613; cv=none; b=M/2fKH8msC6TvXv+aFTQX7cZzGdFuHPJs8XUXq0vEAwrjr8yMotnbbl4S/lND8x9Vx9Qqwo4i494JKJgKXdQVyoFpsZ3Mx3SuWfK81KoT5IA6lffg4H6Yl0rGY9tGZ8uMTMSGruyjzM1rD6aaEMFAHq8XH0KYpXODE+rYr0GPn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707127613; c=relaxed/simple;
	bh=tXqUfbfbTPxlRaRUJ/MLjCbJOHNA1pZq5PhRen0F0l0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBmZwzFaTCJ4/4b78dKhv1wu/ip55Dqf/wkgl3yvkSejspyqOKLlE3jw/Wzoaf1/b5eD2OFUL0LpZ/B43Z+sTeebiWtaTV76XgEttmn0vJCVhwD6NwcWPwOWO+0n5CujHT6PxfUPjY83cWyUs9MOJhwv/JvHNht/TRmweZw2i2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=icLq6na7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="icLq6na7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707127610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u9ctPd0Qw1QM513nDTJvhPLi5Y7m0SlsDszmPq/msBA=;
	b=icLq6na7ZL4FmVZYIP0WpfJNevtDmvl+G7RdgS+Qol4jdewQyYNU8n3NhKTEyh4NWY/1PA
	qSttz2hbBGP+H5adZ8/6EKiw711MTCt7LRhSzPYpIFEoOUFkkxnGPLOhTz5RgmvFRCTd5I
	aCBNg84cUwpBBQcXwA0LIx4jDRpBs+o=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-ihPUgAKNPRiMSCyIlHEM-A-1; Mon,
 05 Feb 2024 05:06:45 -0500
X-MC-Unique: ihPUgAKNPRiMSCyIlHEM-A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50ECB1C04335;
	Mon,  5 Feb 2024 10:06:45 +0000 (UTC)
Received: from fedora (unknown [10.72.116.6])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E0321121313;
	Mon,  5 Feb 2024 10:06:41 +0000 (UTC)
Date: Mon, 5 Feb 2024 18:06:37 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/26] block: Introduce zone write plugging
Message-ID: <ZcCzLfocp4VcScOb@fedora>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-7-dlemoal@kernel.org>
 <Zb8K4uSN3SNeqrPI@fedora>
 <a3f17ffb-872b-49cf-a1a7-553ca4a272c0@kernel.org>
 <ZcBFoqweG+okoTN6@fedora>
 <58fa0123-e884-4321-9b9b-8575cc7b4e1d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58fa0123-e884-4321-9b9b-8575cc7b4e1d@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Mon, Feb 05, 2024 at 11:41:04AM +0900, Damien Le Moal wrote:
> On 2/5/24 11:19, Ming Lei wrote:
> >>>> +static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
> >>>> +					  struct bio *bio, unsigned int nr_segs)
> >>>> +{
> >>>> +	/*
> >>>> +	 * Keep a reference on the BIO request queue usage. This reference will
> >>>> +	 * be dropped either if the BIO is failed or after it is issued and
> >>>> +	 * completes.
> >>>> +	 */
> >>>> +	percpu_ref_get(&bio->bi_bdev->bd_disk->queue->q_usage_counter);
> >>>
> >>> It is fragile to get nested usage_counter, and same with grabbing/releasing it
> >>> from different contexts or even functions, and it could be much better to just
> >>> let block layer maintain it.
> >>>
> >>> From patch 23's change:
> >>>
> >>> +	 * Zoned block device information. Reads of this information must be
> >>> +	 * protected with blk_queue_enter() / blk_queue_exit(). Modifying this
> >>>
> >>> Anytime if there is in-flight bio, the block device is opened, so both gendisk and
> >>> request_queue are live, so not sure if this .q_usage_counter protection
> >>> is needed.
> >>
> >> Hannes also commented about this. Let me revisit this.
> > 
> > I think only queue re-configuration(blk_revalidate_zone) requires the
> > queue usage counter. Otherwise, bdev open()/close() should work just
> > fine.
> 
> I want to check FS case though. No clear if mounting FS that supports zone
> (btrfs) also uses bdev open ?

I feel the following delta change might be cleaner and easily documented:

- one IO takes single reference for both bio based and blk-mq,
- no drop & re-grab
- only grab extra reference for bio based
- two code paths share same pattern

diff --git a/block/blk-core.c b/block/blk-core.c
index 9520ccab3050..118dd789beb5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -597,6 +597,10 @@ static void __submit_bio(struct bio *bio)
 
 	if (!bio->bi_bdev->bd_has_submit_bio) {
 		blk_mq_submit_bio(bio);
+	} else if (bio_zone_write_plugging(bio)) {
+		struct gendisk *disk = bio->bi_bdev->bd_disk;
+
+		disk->fops->submit_bio(bio);
 	} else if (likely(bio_queue_enter(bio) == 0)) {
 		struct gendisk *disk = bio->bi_bdev->bd_disk;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f0fc61a3ec81..fc6d792747dc 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3006,8 +3006,12 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
 		goto queue_exit;
 
+	/*
+	 * Grab one reference for plugged zoned write and it will be reused in
+	 * next real submission
+	 */
 	if (blk_queue_is_zoned(q) && blk_zone_write_plug_bio(bio, nr_segs))
-		goto queue_exit;
+		return;
 
 	if (!rq) {
 new_request:
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index f6d4f511b664..87abb3f7ef30 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -514,7 +514,8 @@ static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
 	 * be dropped either if the BIO is failed or after it is issued and
 	 * completes.
 	 */
-	percpu_ref_get(&bio->bi_bdev->bd_disk->queue->q_usage_counter);
+	if (bio->bi_bdev->bd_has_submit_bio)
+		percpu_ref_get(&bio->bi_bdev->bd_disk->queue->q_usage_counter);
 
 	/*
 	 * The BIO is being plugged and thus will have to wait for the on-going
@@ -760,15 +761,10 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
 
 	blk_zone_wplug_unlock(zwplug, flags);
 
-	/*
-	 * blk-mq devices will reuse the reference on the request queue usage
-	 * we took when the BIO was plugged, but the submission path for
-	 * BIO-based devices will not do that. So drop this reference here.
-	 */
+	submit_bio_noacct_nocheck(bio);
+
 	if (bio->bi_bdev->bd_has_submit_bio)
 		blk_queue_exit(bio->bi_bdev->bd_disk->queue);
-
-	submit_bio_noacct_nocheck(bio);
 }
 
 static struct blk_zone_wplug *blk_zone_alloc_write_plugs(unsigned int nr_zones)

Thanks,
Ming

