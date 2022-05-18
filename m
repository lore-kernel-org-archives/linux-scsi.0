Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E9E3C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 18 May 2022 23:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbiERXX7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 19:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiERXX7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 19:23:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51B01D89FE;
        Wed, 18 May 2022 16:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652916236; x=1684452236;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mRamq6y/FrL9IrxKmzQMYKfzRyhfzGHairLTpmN6JHc=;
  b=CtC+lfNDKnQw12RjOKavFSJ3288yv4TzPRU5rxWEvf0TrEwxGdaJpZaG
   8K03M5N1c0N96IACHZUL9aT7OWAZWhVOb52kJhOlzhL7itmnQOxUFdHb9
   Gw7dR31QEv9FRbZWSr/WG0Lk2pO4baBU0zxgpBYGAAuj1by8AsIzZXfAw
   TVTZhFIXmOthmxOSQBHqgkSlZkI81gpo3/rYaMRKXAwvEiMiFSpKrSrgJ
   IcCt2EEEu0uUoE/CkvcUfZxZTKyAxKLY28z0z6CEndglx07gbSumwgX08
   CiK7VVLjq64GUqHxS2lUYs6Q6zBLAYRXkkNxqbnP49L9YFHXatS1O9LJ1
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="272064309"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="272064309"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 16:23:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="627292758"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 18 May 2022 16:23:54 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrT1F-0002lT-NY;
        Wed, 18 May 2022 23:23:53 +0000
Date:   Thu, 19 May 2022 07:23:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     kbuild-all@lists.01.org, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] blk-mq: remove the done argument to
 blk_execute_rq_nowait
Message-ID: <202205190712.zyCIh9kG-lkp@intel.com>
References: <20220517064901.3059255-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517064901.3059255-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,

I love your patch! Yet something to improve:

[auto build test ERROR on axboe-block/for-next]
[also build test ERROR on next-20220518]
[cannot apply to mkp-scsi/for-next jejb-scsi/for-next linus/master v5.18-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Christoph-Hellwig/blk-mq-remove-__blk_execute_rq_nowait/20220517-154900
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220519/202205190712.zyCIh9kG-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2dc03b4b4f1f1aa542a1ab6d6ff64be3d9db050c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Christoph-Hellwig/blk-mq-remove-__blk_execute_rq_nowait/20220517-154900
        git checkout 2dc03b4b4f1f1aa542a1ab6d6ff64be3d9db050c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/scsi/ufs/ufshpb.c: In function 'ufshpb_execute_map_req':
>> drivers/scsi/ufs/ufshpb.c:721:41: error: expected ';' before 'hpb'
     721 |         blk_execute_rq_nowait(req, true)
         |                                         ^
         |                                         ;
     722 | 
     723 |         hpb->stats.map_req_cnt++;
         |         ~~~                              


vim +721 drivers/scsi/ufs/ufshpb.c

   683	
   684	static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
   685					  struct ufshpb_req *map_req, bool last)
   686	{
   687		struct request_queue *q;
   688		struct request *req;
   689		struct scsi_cmnd *scmd;
   690		int mem_size = hpb->srgn_mem_size;
   691		int ret = 0;
   692		int i;
   693	
   694		q = hpb->sdev_ufs_lu->request_queue;
   695		for (i = 0; i < hpb->pages_per_srgn; i++) {
   696			ret = bio_add_pc_page(q, map_req->bio, map_req->rb.mctx->m_page[i],
   697					      PAGE_SIZE, 0);
   698			if (ret != PAGE_SIZE) {
   699				dev_err(&hpb->sdev_ufs_lu->sdev_dev,
   700					   "bio_add_pc_page fail %d - %d\n",
   701					   map_req->rb.rgn_idx, map_req->rb.srgn_idx);
   702				return ret;
   703			}
   704		}
   705	
   706		req = map_req->req;
   707	
   708		blk_rq_append_bio(req, map_req->bio);
   709	
   710		req->end_io_data = map_req;
   711		req->end_io = ufshpb_map_req_compl_fn;
   712	
   713		if (unlikely(last))
   714			mem_size = hpb->last_srgn_entries * HPB_ENTRY_SIZE;
   715	
   716		scmd = blk_mq_rq_to_pdu(req);
   717		ufshpb_set_read_buf_cmd(scmd->cmnd, map_req->rb.rgn_idx,
   718					map_req->rb.srgn_idx, mem_size);
   719		scmd->cmd_len = HPB_READ_BUFFER_CMD_LENGTH;
   720	
 > 721		blk_execute_rq_nowait(req, true)
   722	
   723		hpb->stats.map_req_cnt++;
   724		return 0;
   725	}
   726	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
