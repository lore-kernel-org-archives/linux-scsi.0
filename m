Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854C4C77B60
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Apr 2023 05:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239126AbjDZFQi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Apr 2023 01:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjDZFQh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2023 01:16:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3C6E77
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 22:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682486196; x=1714022196;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Eq8o8+B6diLLvj3cb6sS+tT9wrkN93md5/woie8nDsA=;
  b=botaXT95ElLEPnYDpbqqBOZugtBn8A+kM9w25KQsQqRz5OHNfmV0aebS
   aKstkiKzbBAbwL0pM/u7wyxxP6JHQF1vCmwikGd1xV5vTPp6Pwi0VAQ3w
   WBO5f5mXio0/FTO175RaTSf/vWG6dFfsLbiLnwBhHH3tG1EgrMjocKvCB
   pyLzc6QzoSm3VRfsLSmgdaL+nTs5YKiB+Nb9mZKucGgqosZ2CH4X6lJ+H
   MCqUm1V0UgrAoI99lcU1Gb+JlQ42Eef+Qdr7JVJSEFnMFbZu7xwWhzvbR
   aS+NX6dngoTWXzF6yKf9fG8jq6fcO7sh6hullGiueNPInZcMc/EMhEibi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="433277054"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="433277054"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 22:16:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="758455016"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="758455016"
Received: from lkp-server01.sh.intel.com (HELO 98ee5a99fc83) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 25 Apr 2023 22:16:33 -0700
Received: from kbuild by 98ee5a99fc83 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1prXW4-00008g-0v;
        Wed, 26 Apr 2023 05:16:32 +0000
Date:   Wed, 26 Apr 2023 13:16:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 3/4] scsi: Only kick the requeue list if necessary
Message-ID: <202304261310.YvjIbyb4-lkp@intel.com>
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
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20230426/202304261310.YvjIbyb4-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1f35bc98f5c39b963f1cbb31159a1e1395dda276
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Bart-Van-Assche/scsi-core-Use-min-instead-of-open-coding-it/20230426-073743
        git checkout 1f35bc98f5c39b963f1cbb31159a1e1395dda276
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/scsi/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304261310.YvjIbyb4-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/scsi/scsi_lib.c:509:28: error: use of undeclared identifier 'cmd'
           if (scsi_host_in_recovery(cmd->device->host))
                                     ^
   1 error generated.


vim +/cmd +509 drivers/scsi/scsi_lib.c

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
