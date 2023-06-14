Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BBBEB64D8
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 04:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbjFNE56 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 00:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbjFNE55 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 00:57:57 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01280122;
        Tue, 13 Jun 2023 21:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686718675; x=1718254675;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZzYK1qJbvS5rbTkIPTvyqdeqBd9oIHgEv+TMqS6toKk=;
  b=CkAYym0F0CJY2LqGA/ivbb3Z+R7o2zdVPw838rQLG2wleWH3xWegfHci
   smTIAIrICI4dyB1WXGv05ormvujC4bZokhWB9LkxvXxv8JIsGLzrUV8hU
   +xiOdo8gzGCnwQBBIsVrHKRACn38Gz9eChb0Q5fkNwxHlJNpgGWvHe5Ni
   12AcjVPYWTuhQbDFF+luWhL3Kvl1yjbqubh77X9FBt7YsDJU228F4ihFj
   MB57GUCfP/Y4TVhXJo96hc9gLi03cS+7UWCbTBY4fTTEqHWJzI3FoAz91
   PijDF15Y3BEsoY8UrK+VCLl96NrMFVUF/WJzeslh5Pst9tyEbroNRmsNP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="338153721"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="338153721"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 21:57:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="706071738"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="706071738"
Received: from lkp-server02.sh.intel.com (HELO d59cacf64e9e) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 13 Jun 2023 21:57:50 -0700
Received: from kbuild by d59cacf64e9e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q9IZp-0000CP-1u;
        Wed, 14 Jun 2023 04:57:49 +0000
Date:   Wed, 14 Jun 2023 12:54:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     oe-kbuild-all@lists.linux.dev,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>
Subject: Re: [PATCH v6 6/7] scsi: replace scsi_target_block() by
 scsi_block_targets()
Message-ID: <202306141255.47GfqLNb-lkp@intel.com>
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
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20230614/202306141255.47GfqLNb-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 12.3.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git remote add mkp-scsi https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
        git fetch mkp-scsi for-next
        git checkout mkp-scsi/for-next
        b4 shazam https://lore.kernel.org/r/20230613174227.11235-7-mwilck@suse.com
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=alpha olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash drivers/scsi/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306141255.47GfqLNb-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/scsi/scsi_lib.c:2912:1: error: conflicting types for 'scsi_block_targets'; have 'void(struct device *, struct Scsi_Host *)'
    2912 | scsi_block_targets(struct device *dev, struct Scsi_Host *shost)
         | ^~~~~~~~~~~~~~~~~~
   In file included from include/scsi/scsi_cmnd.h:12,
                    from drivers/scsi/scsi_lib.c:29:
   include/scsi/scsi_device.h:459:6: note: previous declaration of 'scsi_block_targets' with type 'void(struct Scsi_Host *, struct device *)'
     459 | void scsi_block_targets(struct Scsi_Host *shost, struct device *dev);
         |      ^~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/preempt.h:10,
                    from include/linux/spinlock.h:56,
                    from include/linux/wait.h:9,
                    from include/linux/mempool.h:8,
                    from include/linux/bio.h:8,
                    from drivers/scsi/scsi_lib.c:12:
   drivers/scsi/scsi_lib.c:2918:19: error: conflicting types for 'scsi_block_targets'; have 'void(struct device *, struct Scsi_Host *)'
    2918 | EXPORT_SYMBOL_GPL(scsi_block_targets);
         |                   ^~~~~~~~~~~~~~~~~~
   include/linux/export.h:87:28: note: in definition of macro '___EXPORT_SYMBOL'
      87 |         extern typeof(sym) sym;                                                 \
         |                            ^~~
   include/linux/export.h:147:41: note: in expansion of macro '__EXPORT_SYMBOL'
     147 | #define _EXPORT_SYMBOL(sym, sec)        __EXPORT_SYMBOL(sym, sec, "")
         |                                         ^~~~~~~~~~~~~~~
   include/linux/export.h:151:41: note: in expansion of macro '_EXPORT_SYMBOL'
     151 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "_gpl")
         |                                         ^~~~~~~~~~~~~~
   drivers/scsi/scsi_lib.c:2918:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    2918 | EXPORT_SYMBOL_GPL(scsi_block_targets);
         | ^~~~~~~~~~~~~~~~~
   include/scsi/scsi_device.h:459:6: note: previous declaration of 'scsi_block_targets' with type 'void(struct Scsi_Host *, struct device *)'
     459 | void scsi_block_targets(struct Scsi_Host *shost, struct device *dev);
         |      ^~~~~~~~~~~~~~~~~~


vim +2912 drivers/scsi/scsi_lib.c

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
