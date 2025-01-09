Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1524A2D;
	Thu,  9 Jan 2025 00:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736381152; cv=none; b=VgwWu/J/v7G5jy84oJ1O3+u27kXBSSLDkHsXEHQN6WjoR+8OFrGyvvR9nyb03jGOV69STQtcymWx2AkOI9JSwpDfBjbrNcN58JQWGwpnuI5f2Du6cXYH2p9FoBdpV0c5cEASRTph6r9IBlrHrOPCYA8aMVagpqmmQPMf7l47i54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736381152; c=relaxed/simple;
	bh=DTOjgBiKSpoN3XkIpBaf09tRtrGiWwe2VWsbhvSVqH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k7pdVRNfJlAOTlN704xoRVJslUTEjNPFA2O7b7Ucwfe9cEO88aoDeZtCifhWiFIPiqQFmps+a9mYbvdfn7Q1U/hoSxwrsUsfdaYlGxPgLu7Ia8hO3IyUVVA653Z0EGY9E/toyanANtXHy89IaQZb+3hqz83cl0PCF07l5JTRl5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcZSPW5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcZSPW5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AC5C4CED3;
	Thu,  9 Jan 2025 00:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736381152;
	bh=DTOjgBiKSpoN3XkIpBaf09tRtrGiWwe2VWsbhvSVqH0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FcZSPW5M1yUGhnYttcPLKbWZto0i0n+wCvbVzl7Gormh5kCsGamWMy0qFJl8hkIMK
	 3xhiTf/fa1EWteBie5+fHvhhME5upKUs7ze5T1cESu1muNMaSG01Q5BOnr98ncaFpp
	 fxm/zSKzpItsxBIrV7L7WE/OxW9dU9PeG0qNx+9RirZLUM0lgbULfq5f9jOeEs4qVj
	 DnGm9J77/uwXHdOl/1+fyDfIXzlZPJy8amwvC/Sfs7DUqbb4efwHaFB7Up6b8AifAM
	 aqwxCtOvMMcdcpRDQD+ZgN4+Tvm2jCGZW3L1zrUk7BSOWBU7PPlR3sP94+3K1BUBId
	 IkT5gLlwEZMaA==
Message-ID: <a3bd231c-0568-4dad-9268-bc7edaace94b@kernel.org>
Date: Thu, 9 Jan 2025 09:05:49 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
To: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-4-hch@lst.de> <Z35T8xeLxhXe-zAS@fedora>
 <20250108152705.GA24792@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250108152705.GA24792@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/25 00:27, Christoph Hellwig wrote:
> On Wed, Jan 08, 2025 at 06:31:15PM +0800, Ming Lei wrote:
>>> -	if (!(q->limits.features & BLK_FEAT_POLL) &&
>>> -			(bio->bi_opf & REQ_POLLED)) {
>>> +	if ((bio->bi_opf & REQ_POLLED) && !bdev_can_poll(bdev)) {
>>
>> submit_bio_noacct() is called without grabbing .q_usage_counter,
>> so tagset may be freed now, then use-after-free on q->tag_set?
> 
> Indeed.  That also means the previous check wasn't reliable either.
> I think we can simple move the check into
> blk_mq_submit_bio/__submit_bio which means we'll do a bunch more
> checks before we eventually fail, but otherwise it'll work the
> same.

Given that the request queue is the same for all tag sets, I do not think we
need to have the queue_limits_start_update()/commit_update() within the tag set
loop in __blk_mq_update_nr_hw_queues(). So something like this should be enough
for an initial fix, no ?

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8ac19d4ae3c0..ac71e9cee25b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4986,6 +4986,7 @@ static void __blk_mq_update_nr_hw_queues(struct
blk_mq_tag_set *set,
                                                        int nr_hw_queues)
 {
        struct request_queue *q;
+       struct queue_limits lim;
        LIST_HEAD(head);
        int prev_nr_hw_queues = set->nr_hw_queues;
        int i;
@@ -4999,8 +5000,10 @@ static void __blk_mq_update_nr_hw_queues(struct
blk_mq_tag_set *set,
        if (set->nr_maps == 1 && nr_hw_queues == set->nr_hw_queues)
                return;

+       lim = queue_limits_start_update(q);
        list_for_each_entry(q, &set->tag_list, tag_set_list)
                blk_mq_freeze_queue(q);
+
        /*
         * Switch IO scheduler to 'none', cleaning up the data associated
         * with the previous scheduler. We will switch back once we are done
@@ -5036,13 +5039,10 @@ static void __blk_mq_update_nr_hw_queues(struct
blk_mq_tag_set *set,
                        set->nr_hw_queues = prev_nr_hw_queues;
                        goto fallback;
                }
-               lim = queue_limits_start_update(q);
                if (blk_mq_can_poll(set))
                        lim.features |= BLK_FEAT_POLL;
                else
                        lim.features &= ~BLK_FEAT_POLL;
-               if (queue_limits_commit_update(q, &lim) < 0)
-                       pr_warn("updating the poll flag failed\n");
                blk_mq_map_swqueue(q);
        }

@@ -5059,6 +5059,9 @@ static void __blk_mq_update_nr_hw_queues(struct
blk_mq_tag_set *set,
        list_for_each_entry(q, &set->tag_list, tag_set_list)
                blk_mq_unfreeze_queue(q);

+       if (queue_limits_commit_update(q, &lim) < 0)
+               pr_warn("updating the poll flag failed\n");
+
        /* Free the excess tags when nr_hw_queues shrink. */
        for (i = set->nr_hw_queues; i < prev_nr_hw_queues; i++)
                __blk_mq_free_map_and_rqs(set, i);

With that, no modification of the hot path to check the poll feature should be
needed. And I also fail to see why we need to do the queue freeze for all tag
sets. Once should be enough as well...

-- 
Damien Le Moal
Western Digital Research
