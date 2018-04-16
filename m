From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 08/12] mmc: reduce use of block bounce buffers (fwd)
Date: Mon, 16 Apr 2018 21:11:46 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1804162110510.3044@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kbuild-all@01.org
List-Id: linux-scsi@vger.kernel.org

There is a duplicated test on line 360.

julia

---------- Forwarded message ----------
Date: Mon, 16 Apr 2018 23:04:18 +0800
From: kbuild test robot <lkp@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 08/12] mmc: reduce use of block bounce buffers

CC: kbuild-all@01.org
In-Reply-To: <20180416085032.7367-9-hch@lst.de>
References: <20180416085032.7367-9-hch@lst.de>
TO: Christoph Hellwig <hch@lst.de>
CC: iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org

Hi Christoph,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.17-rc1 next-20180416]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Christoph-Hellwig/iscsi_tcp-don-t-set-a-bounce-limit/20180416-172618
:::::: branch date: 6 hours ago
:::::: commit date: 6 hours ago

>> drivers/mmc/core/queue.c:360:5-29: duplicated argument to && or ||

# https://github.com/0day-ci/linux/commit/6620a69f0eea8e8b7586f08f721c95a336022497
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 6620a69f0eea8e8b7586f08f721c95a336022497
vim +360 drivers/mmc/core/queue.c

81196976 Adrian Hunter     2017-11-29  350
c8b5fd03 Adrian Hunter     2017-09-22  351  static void mmc_setup_queue(struct mmc_queue *mq, struct mmc_card *card)
c8b5fd03 Adrian Hunter     2017-09-22  352  {
c8b5fd03 Adrian Hunter     2017-09-22  353  	struct mmc_host *host = card->host;
c8b5fd03 Adrian Hunter     2017-09-22  354
8b904b5b Bart Van Assche   2018-03-07  355  	blk_queue_flag_set(QUEUE_FLAG_NONROT, mq->queue);
8b904b5b Bart Van Assche   2018-03-07  356  	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, mq->queue);
c8b5fd03 Adrian Hunter     2017-09-22  357  	if (mmc_can_erase(card))
c8b5fd03 Adrian Hunter     2017-09-22  358  		mmc_queue_setup_discard(mq->queue, card);
c8b5fd03 Adrian Hunter     2017-09-22  359
6620a69f Christoph Hellwig 2018-04-16 @360  	if (!mmc_dev(host)->dma_mask || !mmc_dev(host)->dma_mask)
6620a69f Christoph Hellwig 2018-04-16  361  		blk_queue_bounce_limit(mq->queue, BLK_BOUNCE_HIGH);
c8b5fd03 Adrian Hunter     2017-09-22  362  	blk_queue_max_hw_sectors(mq->queue,
c8b5fd03 Adrian Hunter     2017-09-22  363  		min(host->max_blk_count, host->max_req_size / 512));
c8b5fd03 Adrian Hunter     2017-09-22  364  	blk_queue_max_segments(mq->queue, host->max_segs);
c8b5fd03 Adrian Hunter     2017-09-22  365  	blk_queue_max_segment_size(mq->queue, host->max_seg_size);
c8b5fd03 Adrian Hunter     2017-09-22  366
1e8e55b6 Adrian Hunter     2017-11-29  367  	INIT_WORK(&mq->recovery_work, mmc_mq_recovery_handler);
81196976 Adrian Hunter     2017-11-29  368  	INIT_WORK(&mq->complete_work, mmc_blk_mq_complete_work);
81196976 Adrian Hunter     2017-11-29  369
81196976 Adrian Hunter     2017-11-29  370  	mutex_init(&mq->complete_lock);
81196976 Adrian Hunter     2017-11-29  371
81196976 Adrian Hunter     2017-11-29  372  	init_waitqueue_head(&mq->wait);
81196976 Adrian Hunter     2017-11-29  373  }
81196976 Adrian Hunter     2017-11-29  374

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
