Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF24158DD9;
	Tue, 26 Nov 2024 06:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732603979; cv=none; b=RVAOLBdtMgSggt2xMyTwgTdQAndCYMK+y4dvt0ejU3YPoPNEp2WoDg7M2AgnOy/5x20b77mRYvilo1k75DUgqCbHlYHbaDa3+MVLdL2E8+IZrqYcwlvcMv4UqSa5APQ61cRtpzrUpMIiKoXhujmCnKWAclUS2nzvK1iZniB8ufY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732603979; c=relaxed/simple;
	bh=WhuUvJO4mQBl1gJX1yaFM0Pszn18mRnvT+cgm78quZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ubEgF4MvxQmAyHCsqFyvSyEdIZ0cG0u8/akhOEtyUZnR7t79jgIYPiQdm8WQhl2tnUWSar/j93qiQfRdziRIBsATWS5/Wj4Ud5BsNhNmDKJRYzdRfFz4nigFHXEZufR4d/bu/uVeXjQ0JqW9dAvG2XlHTm7pbc0GBUr0IZnyQWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D551668D80; Tue, 26 Nov 2024 07:52:53 +0100 (CET)
Date: Tue, 26 Nov 2024 07:52:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] block: remove the ioprio field from struct request
Message-ID: <20241126065253.GB1133@lst.de>
References: <20241112170050.1612998-3-hch@lst.de> <20241122050419.21973-1-semen.protsenko@linaro.org> <20241122120444.GA25679@lst.de> <CAPLW+4==a515TCD93Kp-8zC8iYyYdh92U=j_emnG5sT_d7z64w@mail.gmail.com> <20241125073658.GA15834@lst.de> <CAPLW+4=kuHze3=+g80CsY6OkLno5gyjRfMWLXTFHu3N_=XcmqA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPLW+4=kuHze3=+g80CsY6OkLno5gyjRfMWLXTFHu3N_=XcmqA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Hi Sam,

please try the patch below:

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index acdc28756d9d..91b3789f710e 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -685,10 +685,9 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 
 	prio = ioprio_class_to_prio[ioprio_class];
 	per_prio = &dd->per_prio[prio];
-	if (!rq->elv.priv[0]) {
+	if (!rq->elv.priv[0])
 		per_prio->stats.inserted++;
-		rq->elv.priv[0] = (void *)(uintptr_t)1;
-	}
+	rq->elv.priv[0] = per_prio;
 
 	if (blk_mq_sched_try_insert_merge(q, rq, free))
 		return;
@@ -753,18 +752,14 @@ static void dd_prepare_request(struct request *rq)
  */
 static void dd_finish_request(struct request *rq)
 {
-	struct request_queue *q = rq->q;
-	struct deadline_data *dd = q->elevator->elevator_data;
-	const u8 ioprio_class = dd_rq_ioclass(rq);
-	const enum dd_prio prio = ioprio_class_to_prio[ioprio_class];
-	struct dd_per_prio *per_prio = &dd->per_prio[prio];
+	struct dd_per_prio *per_prio = rq->elv.priv[0];
 
 	/*
 	 * The block layer core may call dd_finish_request() without having
 	 * called dd_insert_requests(). Skip requests that bypassed I/O
 	 * scheduling. See also blk_mq_request_bypass_insert().
 	 */
-	if (rq->elv.priv[0])
+	if (per_prio)
 		atomic_inc(&per_prio->stats.completed);
 }
 
