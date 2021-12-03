Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04965C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 22:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240817AbhLCXBw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:01:52 -0500
Received: from mga12.intel.com ([192.55.52.136]:32318 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233523AbhLCXBw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Dec 2021 18:01:52 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="217093439"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="217093439"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:58:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="501359484"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 03 Dec 2021 14:58:25 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mtHVY-000IA0-Fc; Fri, 03 Dec 2021 22:58:24 +0000
Date:   Sat, 4 Dec 2021 06:58:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-scsi@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 REPOST] scsi: be2iscsi: Replace irq_poll with threaded
 IRQ handler.
Message-ID: <202112040653.cszvYjJj-lkp@intel.com>
References: <20211202200556.qz7cjuktgxoum2u2@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202200556.qz7cjuktgxoum2u2@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sebastian,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next v5.16-rc3 next-20211203]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Sebastian-Andrzej-Siewior/scsi-be2iscsi-Replace-irq_poll-with-threaded-IRQ-handler/20211203-040851
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: riscv-buildonly-randconfig-r002-20211203 (https://download.01.org/0day-ci/archive/20211204/202112040653.cszvYjJj-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project d30fcadf07ee552f20156ea90be2fdb54cb9cb08)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/0day-ci/linux/commit/46ae6b75188a7c555a80135814182b82a0fad7c8
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sebastian-Andrzej-Siewior/scsi-be2iscsi-Replace-irq_poll-with-threaded-IRQ-handler/20211203-040851
        git checkout 46ae6b75188a7c555a80135814182b82a0fad7c8
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/ata/ drivers/infiniband/sw/rxe/ drivers/scsi/be2iscsi/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/scsi/be2iscsi/be_main.c:5392:33: warning: variable 'i' is uninitialized when used here [-Wuninitialized]
                   pbe_eq = &phwi_context->be_eq[i];
                                                 ^
   drivers/scsi/be2iscsi/be_main.c:5377:16: note: initialize the variable 'i' to silence this warning
           unsigned int i;
                         ^
                          = 0
   1 warning generated.


vim +/i +5392 drivers/scsi/be2iscsi/be_main.c

d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5363  
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5364  /*
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5365   * beiscsi_disable_port()- Disable port and cleanup driver resources.
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5366   * This is called in HBA error handling and driver removal.
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5367   * @phba: Instance Priv structure
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5368   * @unload: indicate driver is unloading
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5369   *
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5370   * Free the OS and HW resources held by the driver
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5371   **/
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5372  static void beiscsi_disable_port(struct beiscsi_hba *phba, int unload)
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5373  {
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5374  	struct hwi_context_memory *phwi_context;
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5375  	struct hwi_controller *phwi_ctrlr;
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5376  	struct be_eq_obj *pbe_eq;
831488669a334e Christoph Hellwig 2017-01-13  5377  	unsigned int i;
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5378  
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5379  	if (!test_and_clear_bit(BEISCSI_HBA_ONLINE, &phba->state))
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5380  		return;
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5381  
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5382  	phwi_ctrlr = phba->phwi_ctrlr;
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5383  	phwi_context = phwi_ctrlr->phwi_ctxt;
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5384  	hwi_disable_intr(phba);
45371aa398c647 Jitendra Bhivare  2017-10-10  5385  	beiscsi_free_irqs(phba);
831488669a334e Christoph Hellwig 2017-01-13  5386  	pci_free_irq_vectors(phba->pcidev);
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5387  
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5388  	cancel_delayed_work_sync(&phba->eqd_update);
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5389  	cancel_work_sync(&phba->boot_work);
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5390  	/* WQ might be running cancel queued mcc_work if we are not exiting */
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5391  	if (!unload && beiscsi_hba_in_error(phba)) {
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19 @5392  		pbe_eq = &phwi_context->be_eq[i];
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5393  		cancel_work_sync(&pbe_eq->mcc_work);
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5394  	}
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5395  	hwi_cleanup_port(phba);
dd940972f36779 Jitendra Bhivare  2016-12-13  5396  	beiscsi_cleanup_port(phba);
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5397  }
d1d5ca887c0ee6 Jitendra Bhivare  2016-08-19  5398  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
