Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6CCC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 17:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5603360EDF
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 17:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhHIRBe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 13:01:34 -0400
Received: from mga17.intel.com ([192.55.52.151]:25430 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233348AbhHIRBd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Aug 2021 13:01:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="195001588"
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="gz'50?scan'50,208,50";a="195001588"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 10:01:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="gz'50?scan'50,208,50";a="670984155"
Received: from lkp-server01.sh.intel.com (HELO d053b881505b) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 09 Aug 2021 10:01:07 -0700
Received: from kbuild by d053b881505b with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mD8eB-000JkN-9Z; Mon, 09 Aug 2021 17:01:07 +0000
Date:   Tue, 10 Aug 2021 01:00:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     kbuild-all@lists.01.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kashyap.desai@broadcom.com, hare@suse.de, ming.lei@redhat.com,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 06/11] blk-mq: Pass driver tags to
 blk_mq_clear_rq_mapping()
Message-ID: <202108100007.jrbSQNQh-lkp@intel.com>
References: <1628519378-211232-7-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <1628519378-211232-7-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

I love your patch! Perhaps something to improve:

[auto build test WARNING on block/for-next]
[also build test WARNING on v5.14-rc5 next-20210809]
[cannot apply to mkp-scsi/for-next ceph-client/for-linus scsi/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/John-Garry/blk-mq-Reduce-static-requests-memory-footprint-for-shared-sbitmap/20210809-223943
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: um-x86_64_defconfig (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/535293cab26a196d29b64d9ce8a7274bfd1806d8
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review John-Garry/blk-mq-Reduce-static-requests-memory-footprint-for-shared-sbitmap/20210809-223943
        git checkout 535293cab26a196d29b64d9ce8a7274bfd1806d8
        # save the attached .config to linux build tree
        make W=1 ARCH=um SUBARCH=x86_64

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> block/blk-mq.c:2313:6: warning: no previous prototype for 'blk_mq_clear_rq_mapping' [-Wmissing-prototypes]
    2313 | void blk_mq_clear_rq_mapping(struct blk_mq_tags *drv_tags,
         |      ^~~~~~~~~~~~~~~~~~~~~~~


vim +/blk_mq_clear_rq_mapping +2313 block/blk-mq.c

  2311	
  2312	/* called before freeing request pool in @tags */
> 2313	void blk_mq_clear_rq_mapping(struct blk_mq_tags *drv_tags,
  2314				     struct blk_mq_tags *tags)
  2315	{
  2316		struct page *page;
  2317		unsigned long flags;
  2318	
  2319		list_for_each_entry(page, &tags->page_list, lru) {
  2320			unsigned long start = (unsigned long)page_address(page);
  2321			unsigned long end = start + order_to_size(page->private);
  2322			int i;
  2323	
  2324			for (i = 0; i < drv_tags->nr_tags; i++) {
  2325				struct request *rq = drv_tags->rqs[i];
  2326				unsigned long rq_addr = (unsigned long)rq;
  2327	
  2328				if (rq_addr >= start && rq_addr < end) {
  2329					WARN_ON_ONCE(refcount_read(&rq->ref) != 0);
  2330					cmpxchg(&drv_tags->rqs[i], rq, NULL);
  2331				}
  2332			}
  2333		}
  2334	
  2335		/*
  2336		 * Wait until all pending iteration is done.
  2337		 *
  2338		 * Request reference is cleared and it is guaranteed to be observed
  2339		 * after the ->lock is released.
  2340		 */
  2341		spin_lock_irqsave(&drv_tags->lock, flags);
  2342		spin_unlock_irqrestore(&drv_tags->lock, flags);
  2343	}
  2344	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--KsGdsel6WgEHnImy
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
2HTuEC0fPWmS/h9B5xsWyZQAAA==

--KsGdsel6WgEHnImy--
