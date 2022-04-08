Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1E5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 08:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiDHID1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 04:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiDHICh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 04:02:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121FC49C89
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 01:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649404811; x=1680940811;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RxVpt7VtidCAz2GgUbQBZKdYhvv68PbSH1gaQ+Hyerk=;
  b=URgL0O3YrfN8cMmgLrwdtCBkXOal2dx+pMUQbPQhjFce1+si1qQX1B4H
   67xDZm5x5rBQieicUTXiWQTADAchFUaUdvv27eglYacEZSgVVUl4TAIuF
   J/3NDlIu72HnjqWHer0owifKy5Usy/5Bb09wPFAbWaySBVfhFSOnoQD0M
   Td+YwKyFS3DGPZyVCfXtS5m9YkfAwr7H+pVbfM0/WXpFkQa0KneI07qIQ
   OH5CG04TMBKm00CUZFzsr5iCVu6ysVcNgbNtQYIc8YJ3bp33YZoWXi2E/
   nNWdHIpuEZbE8jE8+pauh7aRb+1b1sCehVBiwOwjHu3P+YFpEh0uKN+ar
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="249069378"
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="249069378"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 01:00:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="571403596"
Received: from lkp-server02.sh.intel.com (HELO 7e80bc2a00a0) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 08 Apr 2022 01:00:08 -0700
Received: from kbuild by 7e80bc2a00a0 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ncjXL-00001q-Cm;
        Fri, 08 Apr 2022 08:00:07 +0000
Date:   Fri, 8 Apr 2022 15:59:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@lst.de
Subject: Re: [PATCH 1/6] scsi_cmnd: reinstate support for cmd_len > 32
Message-ID: <202204081548.EhdacQg9-lkp@intel.com>
References: <20220408035651.6472-2-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408035651.6472-2-dgilbert@interlog.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Douglas,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next v5.18-rc1 next-20220407]
[cannot apply to hch-configfs/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Douglas-Gilbert/scsi-fix-scsi_cmd-cmd_len/20220408-121036
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: hexagon-randconfig-r041-20220408 (https://download.01.org/0day-ci/archive/20220408/202204081548.EhdacQg9-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c29a51b3a257908aebc01cd7c4655665db317d66)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/efdf7335424993375502b298131c1d106fc5e6d4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Douglas-Gilbert/scsi-fix-scsi_cmd-cmd_len/20220408-121036
        git checkout efdf7335424993375502b298131c1d106fc5e6d4
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/scsi/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/scsi/scsi_ioctl.c:444:28: warning: result of comparison of constant 260 with expression of type 'unsigned char' is always false [-Wtautological-constant-out-of-range-compare]
           if (unlikely(hdr->cmd_len > SCSI_MAX_RUN_TIME_CDB_LEN)) {
                        ~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:48:41: note: expanded from macro 'unlikely'
   #  define unlikely(x)   (__branch_check__(x, 0, __builtin_constant_p(x)))
                                             ^
   include/linux/compiler.h:33:34: note: expanded from macro '__branch_check__'
                           ______r = __builtin_expect(!!(x), expect);      \
                                                         ^
>> drivers/scsi/scsi_ioctl.c:444:28: warning: result of comparison of constant 260 with expression of type 'unsigned char' is always false [-Wtautological-constant-out-of-range-compare]
           if (unlikely(hdr->cmd_len > SCSI_MAX_RUN_TIME_CDB_LEN)) {
                        ~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:48:68: note: expanded from macro 'unlikely'
   #  define unlikely(x)   (__branch_check__(x, 0, __builtin_constant_p(x)))
                                                                        ^
   include/linux/compiler.h:35:19: note: expanded from macro '__branch_check__'
                                                expect, is_constant);      \
                                                        ^~~~~~~~~~~
   2 warnings generated.


vim +444 drivers/scsi/scsi_ioctl.c

   407	
   408	static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
   409	{
   410		unsigned long start_time;
   411		ssize_t ret = 0;
   412		int writing = 0;
   413		int at_head = 0;
   414		struct request *rq;
   415		struct scsi_cmnd *scmd;
   416		struct bio *bio;
   417	
   418		if (hdr->interface_id != 'S')
   419			return -EINVAL;
   420	
   421		if (hdr->dxfer_len > (queue_max_hw_sectors(sdev->request_queue) << 9))
   422			return -EIO;
   423	
   424		if (hdr->dxfer_len)
   425			switch (hdr->dxfer_direction) {
   426			default:
   427				return -EINVAL;
   428			case SG_DXFER_TO_DEV:
   429				writing = 1;
   430				break;
   431			case SG_DXFER_TO_FROM_DEV:
   432			case SG_DXFER_FROM_DEV:
   433				break;
   434			}
   435		if (hdr->flags & SG_FLAG_Q_AT_HEAD)
   436			at_head = 1;
   437	
   438		rq = scsi_alloc_request(sdev->request_queue, writing ?
   439				     REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
   440		if (IS_ERR(rq))
   441			return PTR_ERR(rq);
   442		scmd = blk_mq_rq_to_pdu(rq);
   443	
 > 444		if (unlikely(hdr->cmd_len > SCSI_MAX_RUN_TIME_CDB_LEN)) {
   445			ret = -EINVAL;
   446			goto out_put_request;
   447		}
   448	
   449		ret = scsi_fill_sghdr_rq(sdev, rq, hdr, mode);
   450		if (ret < 0)
   451			goto out_put_request;
   452	
   453		ret = 0;
   454		if (hdr->iovec_count) {
   455			struct iov_iter i;
   456			struct iovec *iov = NULL;
   457	
   458			ret = import_iovec(rq_data_dir(rq), hdr->dxferp,
   459					   hdr->iovec_count, 0, &iov, &i);
   460			if (ret < 0)
   461				goto out_put_request;
   462	
   463			/* SG_IO howto says that the shorter of the two wins */
   464			iov_iter_truncate(&i, hdr->dxfer_len);
   465	
   466			ret = blk_rq_map_user_iov(rq->q, rq, NULL, &i, GFP_KERNEL);
   467			kfree(iov);
   468		} else if (hdr->dxfer_len)
   469			ret = blk_rq_map_user(rq->q, rq, NULL, hdr->dxferp,
   470					      hdr->dxfer_len, GFP_KERNEL);
   471	
   472		if (ret)
   473			goto out_put_request;
   474	
   475		bio = rq->bio;
   476		scmd->allowed = 0;
   477	
   478		start_time = jiffies;
   479	
   480		blk_execute_rq(rq, at_head);
   481	
   482		hdr->duration = jiffies_to_msecs(jiffies - start_time);
   483	
   484		ret = scsi_complete_sghdr_rq(rq, hdr, bio);
   485	
   486	out_put_request:
   487		scsi_free_cmnd(scmd);
   488		return ret;
   489	}
   490	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
