Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77ED7C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 14:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242309AbhK3OqQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 09:46:16 -0500
Received: from mga18.intel.com ([134.134.136.126]:50064 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242163AbhK3OqP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Nov 2021 09:46:15 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="223107403"
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="223107403"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 06:42:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="595449490"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Nov 2021 06:42:53 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1ms4LM-000DQw-DF; Tue, 30 Nov 2021 14:42:52 +0000
Date:   Tue, 30 Nov 2021 22:42:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 1/5] blk-mq: remove hctx_lock and hctx_unlock
Message-ID: <202111302217.rEsBycwv-lkp@intel.com>
References: <20211130073752.3005936-2-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130073752.3005936-2-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ming,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on mkp-scsi/for-next v5.16-rc3 next-20211130]
[cannot apply to linux-nvme/for-next hch-configfs/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Ming-Lei/blk-mq-quiesce-improvement/20211130-154015
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: hexagon-randconfig-r045-20211129 (https://download.01.org/0day-ci/archive/20211130/202111302217.rEsBycwv-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 25eb7fa01d7ebbe67648ea03841cda55b4239ab2)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/4575a8b36e3a56fa87b1f77e0064fc2ec36ebb7c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Ming-Lei/blk-mq-quiesce-improvement/20211130-154015
        git checkout 4575a8b36e3a56fa87b1f77e0064fc2ec36ebb7c
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> block/blk-mq.c:2482:2: warning: '(' and '{' tokens introducing statement expression appear in different macro expansion contexts [-Wcompound-token-split-by-macro]
           blk_mq_run_dispatch_ops(hctx,
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   block/blk-mq.c:1079:3: note: expanded from macro 'blk_mq_run_dispatch_ops'
                   (dispatch_ops);                                 \
                   ^
   block/blk-mq.c:2483:3: note: '{' token is here
                   {
                   ^
   block/blk-mq.c:1079:4: note: expanded from macro 'blk_mq_run_dispatch_ops'
                   (dispatch_ops);                                 \
                    ^~~~~~~~~~~~
>> block/blk-mq.c:2489:3: warning: '}' and ')' tokens terminating statement expression appear in different macro expansion contexts [-Wcompound-token-split-by-macro]
                   }
                   ^
   block/blk-mq.c:1079:4: note: expanded from macro 'blk_mq_run_dispatch_ops'
                   (dispatch_ops);                                 \
                    ^~~~~~~~~~~~
   block/blk-mq.c:2482:2: note: ')' token is here
           blk_mq_run_dispatch_ops(hctx,
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   block/blk-mq.c:1079:16: note: expanded from macro 'blk_mq_run_dispatch_ops'
                   (dispatch_ops);                                 \
                                ^
>> block/blk-mq.c:2482:2: warning: '(' and '{' tokens introducing statement expression appear in different macro expansion contexts [-Wcompound-token-split-by-macro]
           blk_mq_run_dispatch_ops(hctx,
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   block/blk-mq.c:1086:3: note: expanded from macro 'blk_mq_run_dispatch_ops'
                   (dispatch_ops);                                 \
                   ^
   block/blk-mq.c:2483:3: note: '{' token is here
                   {
                   ^
   block/blk-mq.c:1086:4: note: expanded from macro 'blk_mq_run_dispatch_ops'
                   (dispatch_ops);                                 \
                    ^~~~~~~~~~~~
>> block/blk-mq.c:2489:3: warning: '}' and ')' tokens terminating statement expression appear in different macro expansion contexts [-Wcompound-token-split-by-macro]
                   }
                   ^
   block/blk-mq.c:1086:4: note: expanded from macro 'blk_mq_run_dispatch_ops'
                   (dispatch_ops);                                 \
                    ^~~~~~~~~~~~
   block/blk-mq.c:2482:2: note: ')' token is here
           blk_mq_run_dispatch_ops(hctx,
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   block/blk-mq.c:1086:16: note: expanded from macro 'blk_mq_run_dispatch_ops'
                   (dispatch_ops);                                 \
                                ^
   4 warnings generated.


vim +2482 block/blk-mq.c

  2466	
  2467	/**
  2468	 * blk_mq_try_issue_directly - Try to send a request directly to device driver.
  2469	 * @hctx: Pointer of the associated hardware queue.
  2470	 * @rq: Pointer to request to be sent.
  2471	 *
  2472	 * If the device has enough resources to accept a new request now, send the
  2473	 * request directly to device driver. Else, insert at hctx->dispatch queue, so
  2474	 * we can try send it another time in the future. Requests inserted at this
  2475	 * queue have higher priority.
  2476	 */
  2477	static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
  2478			struct request *rq)
  2479	{
  2480		blk_status_t ret;
  2481	
> 2482		blk_mq_run_dispatch_ops(hctx,
  2483			{
  2484			ret = __blk_mq_try_issue_directly(hctx, rq, false, true);
  2485			if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE)
  2486				blk_mq_request_bypass_insert(rq, false, true);
  2487			else if (ret != BLK_STS_OK)
  2488				blk_mq_end_request(rq, ret);
> 2489			}
  2490		);
  2491	}
  2492	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
