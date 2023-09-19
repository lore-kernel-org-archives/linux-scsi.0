Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21172CD3438
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 04:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjISENu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 00:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbjISENt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 00:13:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD74102
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 21:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695096822; x=1726632822;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WZJ0m+dc8R+eXloEKls21l6T5masyhw2d6iFcNL6/2s=;
  b=bx9ReNc/8j/PddZL65/GlKVZkbQbkOlI2ENzckxX2fSjiFIqiBxRobIz
   pDEy0hJrPhJ4+4L2P5XAZt11N3gnyUxeqwAnB4nE+7/3+yDHWfnpyYrrn
   jtArz6B6IBIVTlKdeDQxz3AYlz/0enXO6B7mKnaEsakZ/EoxtPz/aO4Bb
   GEiK5Sv+W7r6qRL0pUo/MuI56KwvvL0C8tWbdApSXc/pvLY2nOU1eBVwH
   mK38HlsdIy49ovks4HUoQlX8dA+EiBe24H5V14LTBj+HJQH1B0fA+xT9z
   BbKyNNtJHGJp05/nY4sxL8QBtKAK/45Q+bJvTbE7/pPUD2t7Gw/Dlmdis
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10837"; a="379750811"
X-IronPort-AV: E=Sophos;i="6.02,158,1688454000"; 
   d="scan'208";a="379750811"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2023 21:13:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10837"; a="739505968"
X-IronPort-AV: E=Sophos;i="6.02,158,1688454000"; 
   d="scan'208";a="739505968"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 18 Sep 2023 21:13:39 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qiS7F-0006se-0z;
        Tue, 19 Sep 2023 04:13:37 +0000
Date:   Tue, 19 Sep 2023 12:12:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tyrel Datwyler <tyreld@linux.ibm.com>, martin.petersen@oracle.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 02/11] ibmvfc: implement channel queue depth and event
 buffer accounting
Message-ID: <202309191225.q759yNtz-lkp@intel.com>
References: <20230913230457.2575849-3-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230913230457.2575849-3-tyreld@linux.ibm.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Tyrel,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.6-rc2 next-20230918]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tyrel-Datwyler/ibmvfc-remove-BUG_ON-in-the-case-of-an-empty-event-pool/20230914-085530
base:   linus/master
patch link:    https://lore.kernel.org/r/20230913230457.2575849-3-tyreld%40linux.ibm.com
patch subject: [PATCH 02/11] ibmvfc: implement channel queue depth and event buffer accounting
config: powerpc-allyesconfig (https://download.01.org/0day-ci/archive/20230919/202309191225.q759yNtz-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230919/202309191225.q759yNtz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309191225.q759yNtz-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/ibmvscsi/ibmvfc.c:789: warning: Excess function parameter 'size' description in 'ibmvfc_init_event_pool'
>> drivers/scsi/ibmvscsi/ibmvfc.c:1534: warning: Function parameter or member 'reserved' not described in '__ibmvfc_get_event'
>> drivers/scsi/ibmvscsi/ibmvfc.c:1534: warning: expecting prototype for ibmvfc_get_event(). Prototype was for __ibmvfc_get_event() instead


vim +789 drivers/scsi/ibmvscsi/ibmvfc.c

072b91f9c6510d Brian King     2008-07-01  778  
225acf5f1aba3b Tyrel Datwyler 2021-01-14  779  /**
225acf5f1aba3b Tyrel Datwyler 2021-01-14  780   * ibmvfc_init_event_pool - Allocates and initializes the event pool for a host
225acf5f1aba3b Tyrel Datwyler 2021-01-14  781   * @vhost:	ibmvfc host who owns the event pool
dd9c772971485d Lee Jones      2021-03-17  782   * @queue:      ibmvfc queue struct
dd9c772971485d Lee Jones      2021-03-17  783   * @size:       pool size
225acf5f1aba3b Tyrel Datwyler 2021-01-14  784   *
225acf5f1aba3b Tyrel Datwyler 2021-01-14  785   * Returns zero on success.
225acf5f1aba3b Tyrel Datwyler 2021-01-14  786   **/
225acf5f1aba3b Tyrel Datwyler 2021-01-14  787  static int ibmvfc_init_event_pool(struct ibmvfc_host *vhost,
a7ed558d0b9030 Tyrel Datwyler 2023-09-13  788  				  struct ibmvfc_queue *queue)
225acf5f1aba3b Tyrel Datwyler 2021-01-14 @789  {
225acf5f1aba3b Tyrel Datwyler 2021-01-14  790  	int i;
225acf5f1aba3b Tyrel Datwyler 2021-01-14  791  	struct ibmvfc_event_pool *pool = &queue->evt_pool;
225acf5f1aba3b Tyrel Datwyler 2021-01-14  792  
225acf5f1aba3b Tyrel Datwyler 2021-01-14  793  	ENTER;
a7ed558d0b9030 Tyrel Datwyler 2023-09-13  794  	if (!queue->total_depth)
bb35ecb2a949d9 Tyrel Datwyler 2021-01-14  795  		return 0;
bb35ecb2a949d9 Tyrel Datwyler 2021-01-14  796  
a7ed558d0b9030 Tyrel Datwyler 2023-09-13  797  	pool->size = queue->total_depth;
a7ed558d0b9030 Tyrel Datwyler 2023-09-13  798  	pool->events = kcalloc(pool->size, sizeof(*pool->events), GFP_KERNEL);
225acf5f1aba3b Tyrel Datwyler 2021-01-14  799  	if (!pool->events)
225acf5f1aba3b Tyrel Datwyler 2021-01-14  800  		return -ENOMEM;
225acf5f1aba3b Tyrel Datwyler 2021-01-14  801  
225acf5f1aba3b Tyrel Datwyler 2021-01-14  802  	pool->iu_storage = dma_alloc_coherent(vhost->dev,
a7ed558d0b9030 Tyrel Datwyler 2023-09-13  803  					      pool->size * sizeof(*pool->iu_storage),
225acf5f1aba3b Tyrel Datwyler 2021-01-14  804  					      &pool->iu_token, 0);
225acf5f1aba3b Tyrel Datwyler 2021-01-14  805  
225acf5f1aba3b Tyrel Datwyler 2021-01-14  806  	if (!pool->iu_storage) {
225acf5f1aba3b Tyrel Datwyler 2021-01-14  807  		kfree(pool->events);
225acf5f1aba3b Tyrel Datwyler 2021-01-14  808  		return -ENOMEM;
225acf5f1aba3b Tyrel Datwyler 2021-01-14  809  	}
225acf5f1aba3b Tyrel Datwyler 2021-01-14  810  
225acf5f1aba3b Tyrel Datwyler 2021-01-14  811  	INIT_LIST_HEAD(&queue->sent);
225acf5f1aba3b Tyrel Datwyler 2021-01-14  812  	INIT_LIST_HEAD(&queue->free);
a7ed558d0b9030 Tyrel Datwyler 2023-09-13  813  	queue->evt_free = queue->evt_depth;
a7ed558d0b9030 Tyrel Datwyler 2023-09-13  814  	queue->reserved_free = queue->reserved_depth;
225acf5f1aba3b Tyrel Datwyler 2021-01-14  815  	spin_lock_init(&queue->l_lock);
225acf5f1aba3b Tyrel Datwyler 2021-01-14  816  
a7ed558d0b9030 Tyrel Datwyler 2023-09-13  817  	for (i = 0; i < pool->size; ++i) {
225acf5f1aba3b Tyrel Datwyler 2021-01-14  818  		struct ibmvfc_event *evt = &pool->events[i];
225acf5f1aba3b Tyrel Datwyler 2021-01-14  819  
a264cf5e81c78e Tyrel Datwyler 2021-07-16  820  		/*
a264cf5e81c78e Tyrel Datwyler 2021-07-16  821  		 * evt->active states
a264cf5e81c78e Tyrel Datwyler 2021-07-16  822  		 *  1 = in flight
a264cf5e81c78e Tyrel Datwyler 2021-07-16  823  		 *  0 = being completed
a264cf5e81c78e Tyrel Datwyler 2021-07-16  824  		 * -1 = free/freed
a264cf5e81c78e Tyrel Datwyler 2021-07-16  825  		 */
a264cf5e81c78e Tyrel Datwyler 2021-07-16  826  		atomic_set(&evt->active, -1);
225acf5f1aba3b Tyrel Datwyler 2021-01-14  827  		atomic_set(&evt->free, 1);
225acf5f1aba3b Tyrel Datwyler 2021-01-14  828  		evt->crq.valid = 0x80;
225acf5f1aba3b Tyrel Datwyler 2021-01-14  829  		evt->crq.ioba = cpu_to_be64(pool->iu_token + (sizeof(*evt->xfer_iu) * i));
225acf5f1aba3b Tyrel Datwyler 2021-01-14  830  		evt->xfer_iu = pool->iu_storage + i;
225acf5f1aba3b Tyrel Datwyler 2021-01-14  831  		evt->vhost = vhost;
225acf5f1aba3b Tyrel Datwyler 2021-01-14  832  		evt->queue = queue;
225acf5f1aba3b Tyrel Datwyler 2021-01-14  833  		evt->ext_list = NULL;
225acf5f1aba3b Tyrel Datwyler 2021-01-14  834  		list_add_tail(&evt->queue_list, &queue->free);
225acf5f1aba3b Tyrel Datwyler 2021-01-14  835  	}
225acf5f1aba3b Tyrel Datwyler 2021-01-14  836  
225acf5f1aba3b Tyrel Datwyler 2021-01-14  837  	LEAVE;
225acf5f1aba3b Tyrel Datwyler 2021-01-14  838  	return 0;
225acf5f1aba3b Tyrel Datwyler 2021-01-14  839  }
225acf5f1aba3b Tyrel Datwyler 2021-01-14  840  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
