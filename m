Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F10CC77B61
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Apr 2023 03:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239061AbjDZDYh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 23:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbjDZDYe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 23:24:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5502E5E
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 20:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682479473; x=1714015473;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gBpkFmunFyAZMgi0zR7ubj2QtUAtmIrxTT39kEnW310=;
  b=lt1XIzYV2dvwnmfAw8bvtsuVU+OhS0WAFLAOs/t8Bg/n3l3Xp7TyzSnv
   lFbdvcO7VwRQOW6eLeQFiy4NqGeSvLDSRrQnBdiNGiGBi+PPa5bFGP231
   hhyiy6YoOoqN2XMQKHEcs4mBLP5q+7nw0VBLm/krXdz+7rMbvky8zodcm
   oHSGcc7OAeBfGLG3BTMWddNf+t58Upjgy/7tw2wAvjqQo76Gz9ucdGWct
   etHjb4kJOb2/U9zNXaG5vCWvS+wX21ZcsfYKNnmmvmjcMnDZkq6bP3CiG
   QKAECsWoGFtuRfrhJh6wz1Eo0rzDtKERgXNYfQsqAU5QqYi21wLwnLeag
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="349778872"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="349778872"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 20:24:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="696446908"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="696446908"
Received: from lkp-server01.sh.intel.com (HELO 98ee5a99fc83) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 25 Apr 2023 20:24:27 -0700
Received: from kbuild by 98ee5a99fc83 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1prVlb-00002q-0I;
        Wed, 26 Apr 2023 03:24:27 +0000
Date:   Wed, 26 Apr 2023 11:23:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     oe-kbuild-all@lists.linux.dev, Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 3/4] scsi: Only kick the requeue list if necessary
Message-ID: <202304261147.Vx9zYMCi-lkp@intel.com>
References: <20230425233446.1231000-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425233446.1231000-4-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

kernel test robot noticed the following build errors:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on jejb-scsi/for-next linus/master v6.3 next-20230425]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bart-Van-Assche/scsi-core-Use-min-instead-of-open-coding-it/20230426-073743
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20230425233446.1231000-4-bvanassche%40acm.org
patch subject: [PATCH 3/4] scsi: Only kick the requeue list if necessary
config: s390-allyesconfig (https://download.01.org/0day-ci/archive/20230426/202304261147.Vx9zYMCi-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1f35bc98f5c39b963f1cbb31159a1e1395dda276
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Bart-Van-Assche/scsi-core-Use-min-instead-of-open-coding-it/20230426-073743
        git checkout 1f35bc98f5c39b963f1cbb31159a1e1395dda276
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash drivers/scsi/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304261147.Vx9zYMCi-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/scsi/scsi_lib.c: In function 'scsi_run_queue_async':
>> drivers/scsi/scsi_lib.c:509:35: error: 'cmd' undeclared (first use in this function); did you mean 'cma'?
     509 |         if (scsi_host_in_recovery(cmd->device->host))
         |                                   ^~~
         |                                   cma
   drivers/scsi/scsi_lib.c:509:35: note: each undeclared identifier is reported only once for each function it appears in


vim +509 drivers/scsi/scsi_lib.c

   506	
   507	static void scsi_run_queue_async(struct scsi_device *sdev)
   508	{
 > 509		if (scsi_host_in_recovery(cmd->device->host))
   510			return;
   511	
   512		if (scsi_target(sdev)->single_lun ||
   513		    !list_empty(&sdev->host->starved_list)) {
   514			kblockd_schedule_work(&sdev->requeue_work);
   515		} else {
   516			/*
   517			 * smp_mb() present in sbitmap_queue_clear() or implied in
   518			 * .end_io is for ordering writing .device_busy in
   519			 * scsi_device_unbusy() and reading sdev->restarts.
   520			 */
   521			int old = atomic_read(&sdev->restarts);
   522	
   523			/*
   524			 * ->restarts has to be kept as non-zero if new budget
   525			 *  contention occurs.
   526			 *
   527			 *  No need to run queue when either another re-run
   528			 *  queue wins in updating ->restarts or a new budget
   529			 *  contention occurs.
   530			 */
   531			if (old && atomic_cmpxchg(&sdev->restarts, old, 0) == old)
   532				blk_mq_run_hw_queues(sdev->request_queue, true);
   533		}
   534	}
   535	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
