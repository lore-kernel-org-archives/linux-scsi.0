Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F80EB64DA
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 21:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239454AbjFMVQ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 17:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235998AbjFMVQ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 17:16:27 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF0C19B7;
        Tue, 13 Jun 2023 14:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686690986; x=1718226986;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xBxRrQSWCNJeRrf4b0WLzHh8isR+4h1yUuTtpwm0xS8=;
  b=Thb0yr6yDOENAAADQ/By5OkT5yGyR4hWy1y4J20bDPy6VTfPDAxMKLQy
   TzWgtPbSJjSkZ4oJQoFKUX5lgz0CPcj89m5ttxAW11nNses68G9r7M4oO
   x5IFReoswNbQOV48ToWuUsk1disZDLd6MRuoWPpmnqNqwRIZ34PVoZb1H
   NdD+eEcRirEdWrzHaWvYHflfq+zekAXInc5YKoZyyyGPvN8txp9TfG6jh
   1plnai4ngiCvihK8xUiMIO0+IpECLhPJnzAhiFyrjxPd4UbAVwFShjXYj
   YEBN1H8UHcSuoyCPCl+n5YrhuUudFg6tffWCl117VLl9GdxGiFA9ZLDJ9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="357334279"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="357334279"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 14:16:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="1041912514"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="1041912514"
Received: from lkp-server01.sh.intel.com (HELO 211f47bdb1cb) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 13 Jun 2023 14:16:22 -0700
Received: from kbuild by 211f47bdb1cb with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q9BNF-0001mK-2i;
        Tue, 13 Jun 2023 21:16:21 +0000
Date:   Wed, 14 Jun 2023 05:16:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>
Subject: Re: [PATCH v6 6/7] scsi: replace scsi_target_block() by
 scsi_block_targets()
Message-ID: <202306140503.hMWyg8Xa-lkp@intel.com>
References: <20230613174227.11235-7-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613174227.11235-7-mwilck@suse.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on jejb-scsi/for-next axboe-block/for-next linus/master v6.4-rc6 next-20230613]
[cannot apply to hch-configfs/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/mwilck-suse-com/bsg-increase-number-of-devices/20230614-014437
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20230613174227.11235-7-mwilck%40suse.com
patch subject: [PATCH v6 6/7] scsi: replace scsi_target_block() by scsi_block_targets()
config: arm-randconfig-r011-20230612 (https://download.01.org/0day-ci/archive/20230614/202306140503.hMWyg8Xa-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        git remote add mkp-scsi https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
        git fetch mkp-scsi for-next
        git checkout mkp-scsi/for-next
        b4 shazam https://lore.kernel.org/r/20230613174227.11235-7-mwilck@suse.com
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/scsi/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306140503.hMWyg8Xa-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/scsi/scsi_lib.c:2912:1: error: conflicting types for 'scsi_block_targets'
    2912 | scsi_block_targets(struct device *dev, struct Scsi_Host *shost)
         | ^
   include/scsi/scsi_device.h:459:6: note: previous declaration is here
     459 | void scsi_block_targets(struct Scsi_Host *shost, struct device *dev);
         |      ^
   1 error generated.


vim +/scsi_block_targets +2912 drivers/scsi/scsi_lib.c

  2898	
  2899	/**
  2900	 * scsi_block_targets - transition all SCSI child devices to SDEV_BLOCK state
  2901	 * @dev: a parent device of one or more scsi_target devices
  2902	 * @shost: the Scsi_Host to which this device belongs
  2903	 *
  2904	 * Iterate over all children of @dev, which should be scsi_target devices,
  2905	 * and switch all subordinate scsi devices to SDEV_BLOCK state. Wait for
  2906	 * ongoing scsi_queue_rq() calls to finish. May sleep.
  2907	 *
  2908	 * Note:
  2909	 * @dev must not itself be a scsi_target device.
  2910	 */
  2911	void
> 2912	scsi_block_targets(struct device *dev, struct Scsi_Host *shost)
  2913	{
  2914		WARN_ON_ONCE(scsi_is_target_device(dev));
  2915		device_for_each_child(dev, NULL, target_block);
  2916		blk_mq_wait_quiesce_done(&shost->tag_set);
  2917	}
  2918	EXPORT_SYMBOL_GPL(scsi_block_targets);
  2919	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
