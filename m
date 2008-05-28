From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: bsg locking patches update
Date: Wed, 28 May 2008 21:00:56 +0900
Message-ID: <20080528210048L.tomof@acm.org>
References: <20080526165318.GA5466@osc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:39268 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbYE1MBM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2008 08:01:12 -0400
In-Reply-To: <20080526165318.GA5466@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pw@osc.edu
Cc: fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 26 May 2008 12:53:18 -0400
Pete Wyckoff <pw@osc.edu> wrote:

> I finally got around to testing the set of lifetime management
> fixes you applied.  This is 2.6.26-rc3 with some varlen, bidi,
> iser patches, and iovec on bsg, but nothing that should affect
> the locking.
> 
> I can confirm that the first two of these three old bugs are
> no longer reproducable:
> 
>     http://marc.info/?l=linux-scsi&m=120508166505141&w=2
>     http://marc.info/?l=linux-scsi&m=120508177905365&w=2
>     http://marc.info/?l=linux-scsi&m=120508178005376&w=2
> 
> Thanks!  The third, however, is a hang that still can happen.  But
> it is very obscure and requires a bit of timing to get right.  As a
> reminder, here's the setup, and updated traces.

Ah, sorry about it. I didn't understand the third correctly.


> Maybe it is necessary to split up that bsg_mutex to use multiple
> finer-grained locks.

We could but we use bsg_mutex to protect bsg_device_list and idr. So I
think that we don't need hold bsg_mutex during
bsg_complete_all_commands. How about this?


diff --git a/block/bsg.c b/block/bsg.c
index f0b7cd3..d81104e 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -721,8 +721,6 @@ static int bsg_put_device(struct bsg_device *bd)
 	int ret = 0, do_free;
 	struct request_queue *q = bd->queue;
 
-	mutex_lock(&bsg_mutex);
-
 	do_free = atomic_dec_and_test(&bd->ref_count);
 	if (!do_free)
 		goto out;
@@ -741,10 +739,12 @@ static int bsg_put_device(struct bsg_device *bd)
 	 */
 	ret = bsg_complete_all_commands(bd);
 
+	mutex_lock(&bsg_mutex);
 	hlist_del(&bd->dev_list);
+	mutex_unlock(&bsg_mutex);
+
 	kfree(bd);
 out:
-	mutex_unlock(&bsg_mutex);
 	kref_put(&q->bsg_dev.ref, bsg_kref_release_function);
 	if (do_free)
 		blk_put_queue(q);
-- 
1.5.4.2

