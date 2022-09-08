Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FA3C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 17:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiIHRqx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 13:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbiIHRqe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 13:46:34 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAE8A4B3C
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 10:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662659125; x=1694195125;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=29AXp0iXi+8az1iMZ7q8VVuBBk8bbBXC1MPi6grPbBI=;
  b=jamj8zEIkTwWhC/wj6OEt4V/gAi3JQKJ+VwcDutwHQs28ha+SfOpLyP8
   VwUV8we2Gy87dZXzJ49Q7LTq1mSQRZS7QIFxidpCzSN2gJbhzQeeqfjLd
   QvNLEWD8VX0nxqrI9Cb+pkXFNF/cCMD8BSDmcrRzaJSKJaioeVl7cqRAo
   DL6JjAGY7F+YBPsSk8OS1a9yT3RGmMt9pguxcD5wnIo9CsUk8Hyzk2BTn
   lXcdfXgEtKDMeyQEo9NP6dJRwR6fbhDRktAqJ3v6+gRLn/imUtSgzDI6c
   R7zHEfxnBnOL4oC/v+jCTYLfnpJOaeHF0Trg6TsWXiFZUTdN6IKdmlmqL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="277662079"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="277662079"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 10:45:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="790529144"
Received: from lkp-server02.sh.intel.com (HELO b2938d2e5c5a) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 08 Sep 2022 10:45:23 -0700
Received: from kbuild by b2938d2e5c5a with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oWLac-0000CD-1W;
        Thu, 08 Sep 2022 17:45:22 +0000
Date:   Fri, 9 Sep 2022 01:44:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 4/9] mpi3mr: Graceful handling of surprise removal of
 PCIe HBA
Message-ID: <202209090112.VUjjlLbL-lkp@intel.com>
References: <20220908125332.21110-5-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908125332.21110-5-sreekanth.reddy@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sreekanth,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next next-20220908]
[cannot apply to linus/master v6.0-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sreekanth-Reddy/mpi3mr-Few-Enhancements-and-minor-fixes/20220908-204501
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220909/202209090112.VUjjlLbL-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/b6e352223dd831f21b9e550698f58fb5a1389004
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sreekanth-Reddy/mpi3mr-Few-Enhancements-and-minor-fixes/20220908-204501
        git checkout b6e352223dd831f21b9e550698f58fb5a1389004
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/scsi/mpi3mr/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/scsi/mpi3mr/mpi3mr_fw.c:4071:13: warning: variable 'pe_timeout' is uninitialized when used here [-Wuninitialized]
           } while (--pe_timeout);
                      ^~~~~~~~~~
   drivers/scsi/mpi3mr/mpi3mr_fw.c:3949:16: note: initialize the variable 'pe_timeout' to silence this warning
           u32 pe_timeout, ioc_status;
                         ^
                          = 0
   1 warning generated.


vim +/pe_timeout +4071 drivers/scsi/mpi3mr/mpi3mr_fw.c

  3929	
  3930	/**
  3931	 * mpi3mr_reinit_ioc - Re-Initialize the controller
  3932	 * @mrioc: Adapter instance reference
  3933	 * @is_resume: Called from resume or reset path
  3934	 *
  3935	 * This the controller re-initialization routine, executed from
  3936	 * the soft reset handler or resume callback. Creates
  3937	 * operational reply queue pairs, allocate required memory for
  3938	 * reply pool, sense buffer pool, issue IOC init request to the
  3939	 * firmware, unmask the events and issue port enable to discover
  3940	 * SAS/SATA/NVMe devices and RAID volumes.
  3941	 *
  3942	 * Return: 0 on success and non-zero on failure.
  3943	 */
  3944	int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
  3945	{
  3946		int retval = 0;
  3947		u8 retry = 0;
  3948		struct mpi3_ioc_facts_data facts_data;
  3949		u32 pe_timeout, ioc_status;
  3950	
  3951	retry_init:
  3952		dprint_reset(mrioc, "bringing up the controller to ready state\n");
  3953		retval = mpi3mr_bring_ioc_ready(mrioc);
  3954		if (retval) {
  3955			ioc_err(mrioc, "failed to bring to ready state\n");
  3956			goto out_failed_noretry;
  3957		}
  3958	
  3959		if (is_resume) {
  3960			dprint_reset(mrioc, "setting up single ISR\n");
  3961			retval = mpi3mr_setup_isr(mrioc, 1);
  3962			if (retval) {
  3963				ioc_err(mrioc, "failed to setup ISR\n");
  3964				goto out_failed_noretry;
  3965			}
  3966		} else
  3967			mpi3mr_ioc_enable_intr(mrioc);
  3968	
  3969		dprint_reset(mrioc, "getting ioc_facts\n");
  3970		retval = mpi3mr_issue_iocfacts(mrioc, &facts_data);
  3971		if (retval) {
  3972			ioc_err(mrioc, "failed to get ioc_facts\n");
  3973			goto out_failed;
  3974		}
  3975	
  3976		dprint_reset(mrioc, "validating ioc_facts\n");
  3977		retval = mpi3mr_revalidate_factsdata(mrioc);
  3978		if (retval) {
  3979			ioc_err(mrioc, "failed to revalidate ioc_facts data\n");
  3980			goto out_failed_noretry;
  3981		}
  3982	
  3983		mpi3mr_print_ioc_info(mrioc);
  3984	
  3985		dprint_reset(mrioc, "sending ioc_init\n");
  3986		retval = mpi3mr_issue_iocinit(mrioc);
  3987		if (retval) {
  3988			ioc_err(mrioc, "failed to send ioc_init\n");
  3989			goto out_failed;
  3990		}
  3991	
  3992		dprint_reset(mrioc, "getting package version\n");
  3993		retval = mpi3mr_print_pkg_ver(mrioc);
  3994		if (retval) {
  3995			ioc_err(mrioc, "failed to get package version\n");
  3996			goto out_failed;
  3997		}
  3998	
  3999		if (is_resume) {
  4000			dprint_reset(mrioc, "setting up multiple ISR\n");
  4001			retval = mpi3mr_setup_isr(mrioc, 0);
  4002			if (retval) {
  4003				ioc_err(mrioc, "failed to re-setup ISR\n");
  4004				goto out_failed_noretry;
  4005			}
  4006		}
  4007	
  4008		dprint_reset(mrioc, "creating operational queue pairs\n");
  4009		retval = mpi3mr_create_op_queues(mrioc);
  4010		if (retval) {
  4011			ioc_err(mrioc, "failed to create operational queue pairs\n");
  4012			goto out_failed;
  4013		}
  4014	
  4015		if (!mrioc->pel_seqnum_virt) {
  4016			dprint_reset(mrioc, "allocating memory for pel_seqnum_virt\n");
  4017			mrioc->pel_seqnum_sz = sizeof(struct mpi3_pel_seq);
  4018			mrioc->pel_seqnum_virt = dma_alloc_coherent(&mrioc->pdev->dev,
  4019			    mrioc->pel_seqnum_sz, &mrioc->pel_seqnum_dma,
  4020			    GFP_KERNEL);
  4021			if (!mrioc->pel_seqnum_virt) {
  4022				retval = -ENOMEM;
  4023				goto out_failed_noretry;
  4024			}
  4025		}
  4026	
  4027		if (mrioc->shost->nr_hw_queues > mrioc->num_op_reply_q) {
  4028			ioc_err(mrioc,
  4029			    "cannot create minimum number of operational queues expected:%d created:%d\n",
  4030			    mrioc->shost->nr_hw_queues, mrioc->num_op_reply_q);
  4031			goto out_failed_noretry;
  4032		}
  4033	
  4034		dprint_reset(mrioc, "enabling events\n");
  4035		retval = mpi3mr_enable_events(mrioc);
  4036		if (retval) {
  4037			ioc_err(mrioc, "failed to enable events\n");
  4038			goto out_failed;
  4039		}
  4040	
  4041		if (!is_resume) {
  4042			mrioc->device_refresh_on = 1;
  4043			mpi3mr_add_event_wait_for_device_refresh(mrioc);
  4044		}
  4045	
  4046		ioc_info(mrioc, "sending port enable\n");
  4047		retval = mpi3mr_issue_port_enable(mrioc, 1);
  4048		if (retval) {
  4049			ioc_err(mrioc, "failed to issue port enable\n");
  4050			goto out_failed;
  4051		}
  4052		do {
  4053			ssleep(MPI3MR_PORTENABLE_POLL_INTERVAL);
  4054			if (mrioc->init_cmds.state == MPI3MR_CMD_NOTUSED)
  4055				break;
  4056			if (!pci_device_is_present(mrioc->pdev))
  4057				mrioc->unrecoverable = 1;
  4058			if (mrioc->unrecoverable) {
  4059				retval = -1;
  4060				goto out_failed_noretry;
  4061			}
  4062			ioc_status = readl(&mrioc->sysif_regs->ioc_status);
  4063			if ((ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) ||
  4064			    (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT)) {
  4065				mpi3mr_print_fault_info(mrioc);
  4066				mrioc->init_cmds.is_waiting = 0;
  4067				mrioc->init_cmds.callback = NULL;
  4068				mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
  4069				goto out_failed;
  4070			}
> 4071		} while (--pe_timeout);
  4072	
  4073		if (!pe_timeout) {
  4074			ioc_err(mrioc, "port enable timed out\n");
  4075			mpi3mr_check_rh_fault_ioc(mrioc,
  4076			    MPI3MR_RESET_FROM_PE_TIMEOUT);
  4077			mrioc->init_cmds.is_waiting = 0;
  4078			mrioc->init_cmds.callback = NULL;
  4079			mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
  4080			goto out_failed;
  4081		} else if (mrioc->scan_failed) {
  4082			ioc_err(mrioc,
  4083			    "port enable failed with status=0x%04x\n",
  4084			    mrioc->scan_failed);
  4085		} else
  4086			ioc_info(mrioc, "port enable completed successfully\n");
  4087	
  4088		ioc_info(mrioc, "controller %s completed successfully\n",
  4089		    (is_resume)?"resume":"re-initialization");
  4090		return retval;
  4091	out_failed:
  4092		if (retry < 2) {
  4093			retry++;
  4094			ioc_warn(mrioc, "retrying controller %s, retry_count:%d\n",
  4095			    (is_resume)?"resume":"re-initialization", retry);
  4096			mpi3mr_memset_buffers(mrioc);
  4097			goto retry_init;
  4098		}
  4099	out_failed_noretry:
  4100		ioc_err(mrioc, "controller %s is failed\n",
  4101		    (is_resume)?"resume":"re-initialization");
  4102		mpi3mr_issue_reset(mrioc, MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
  4103		    MPI3MR_RESET_FROM_CTLR_CLEANUP);
  4104		mrioc->unrecoverable = 1;
  4105		return retval;
  4106	}
  4107	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
