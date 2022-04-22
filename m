Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64553C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Apr 2022 21:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiDVV52 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Apr 2022 17:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiDVV5C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2022 17:57:02 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F711CCF81
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 13:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650659990; x=1682195990;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cRmlJBeHNAQIBt/ZfajDI8w281clVFBMSHKQ8pGbptc=;
  b=e0IEgBNJ0SCHN0PLb2AIoo2QvplUr5lB1o66a29303mywvzcFHG8l6dt
   SUN7Tq3nbp9ho4B7Y8f5jYBwSHihxS62+2bz8nXoifMvFQbipVbYijv8b
   M+YtOlYGJ0urMs5N/7XoKGoZrtgmpF11ijw1sXF72nxQBaBjRjp85ngjH
   IIqCQJJbEaYhQphwPcj5500lX4f4QuwI/ZqpzVeTPc+6Cu/tUzZedY9Gm
   UMB65C0MjgT2omZCDTut2tFvnCR2QRhkKN9gBiQtX2eHeMd4llbsya9SN
   y+iPGuDe0fTr41bHHh/lOO2p1z+48PUNcD8tC2O7a+xWx8ze+SSPqOWx9
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="325188998"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="325188998"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 10:25:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="648708789"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Apr 2022 10:25:52 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nhx2W-000AOQ-6M;
        Fri, 22 Apr 2022 17:25:52 +0000
Date:   Sat, 23 Apr 2022 01:25:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     kbuild-all@lists.01.org, martin.petersen@oracle.com,
        bvanassche@acm.org, hch@lst.de, hare@suse.de,
        himanshu.madhani@oracle.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, chandrakanth.patil@broadcom.com,
        sreekanth.reddy@broadcom.com, prayas.patel@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH v5 1/8] mpi3mr: add BSG device support
Message-ID: <202204230118.pTp3NoQc-lkp@intel.com>
References: <20220422115423.279805-2-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422115423.279805-2-sumit.saxena@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sumit,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next hch-configfs/for-next linus/master v5.18-rc3 next-20220422]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Sumit-Saxena/mpi3mr-add-BSG-interface-support-for-controller-management/20220422-201527
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: alpha-randconfig-r033-20220422 (https://download.01.org/0day-ci/archive/20220423/202204230118.pTp3NoQc-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/a45cf34a6056cbcfd60079926a424e2ca56021aa
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sumit-Saxena/mpi3mr-add-BSG-interface-support-for-controller-management/20220422-201527
        git checkout a45cf34a6056cbcfd60079926a424e2ca56021aa
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash drivers/scsi/mpi3mr/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/scsi/mpi3mr/mpi3mr_app.c:21:5: warning: no previous prototype for 'mpi3mr_bsg_request' [-Wmissing-prototypes]
      21 | int mpi3mr_bsg_request(struct bsg_job *job)
         |     ^~~~~~~~~~~~~~~~~~
>> drivers/scsi/mpi3mr/mpi3mr_app.c:55:6: warning: no previous prototype for 'mpi3mr_bsg_node_release' [-Wmissing-prototypes]
      55 | void mpi3mr_bsg_node_release(struct device *dev)
         |      ^~~~~~~~~~~~~~~~~~~~~~~


vim +/mpi3mr_bsg_request +21 drivers/scsi/mpi3mr/mpi3mr_app.c

    12	
    13	/**
    14	 * mpi3mr_bsg_request - bsg request entry point
    15	 * @job: BSG job reference
    16	 *
    17	 * This is driver's entry point for bsg requests
    18	 *
    19	 * Return: 0 on success and proper error codes on failure
    20	 */
  > 21	int mpi3mr_bsg_request(struct bsg_job *job)
    22	{
    23		return 0;
    24	}
    25	
    26	/**
    27	 * mpi3mr_bsg_exit - de-registration from bsg layer
    28	 *
    29	 * This will be called during driver unload and all
    30	 * bsg resources allocated during load will be freed.
    31	 *
    32	 * Return:Nothing
    33	 */
    34	void mpi3mr_bsg_exit(struct mpi3mr_ioc *mrioc)
    35	{
    36		if (!mrioc->bsg_queue)
    37			return;
    38	
    39		bsg_remove_queue(mrioc->bsg_queue);
    40		mrioc->bsg_queue = NULL;
    41	
    42		device_del(mrioc->bsg_dev);
    43		put_device(mrioc->bsg_dev);
    44		kfree(mrioc->bsg_dev);
    45	}
    46	
    47	/**
    48	 * mpi3mr_bsg_node_release -release bsg device node
    49	 * @dev: bsg device node
    50	 *
    51	 * decrements bsg dev reference count
    52	 *
    53	 * Return:Nothing
    54	 */
  > 55	void mpi3mr_bsg_node_release(struct device *dev)
    56	{
    57		put_device(dev);
    58	}
    59	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
