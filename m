Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E273C433E9
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 21:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BD352313E
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 21:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbhAFVLG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 16:11:06 -0500
Received: from mga17.intel.com ([192.55.52.151]:23089 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbhAFVLG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Jan 2021 16:11:06 -0500
IronPort-SDR: WlCJ4uYZqyWOhsbxvbpg/iOVagSOkZ+dF7ygLeTgmn0T6EVZZc2zqPS1SjDoPK1gxYdF2USj86
 V7lMCGPNR/tA==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="157119986"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="gz'50?scan'50,208,50";a="157119986"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 13:10:24 -0800
IronPort-SDR: tW38kL7BqdEyouR6KiPf8nE1DMrFuhcb38BqmCo6U3ciECrlQXLJzIWiX2xtBRPCcFnyD7roCr
 Ijhxt7YsC2yQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="gz'50?scan'50,208,50";a="565938913"
Received: from lkp-server02.sh.intel.com (HELO 4242b19f17ef) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 06 Jan 2021 13:10:20 -0800
Received: from kbuild by 4242b19f17ef with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kxG4R-0009Af-PT; Wed, 06 Jan 2021 21:10:19 +0000
Date:   Thu, 7 Jan 2021 05:09:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Cc:     kbuild-all@lists.01.org, cang@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        Jaegeuk Kim <jaegeuk@google.com>
Subject: Re: [PATCH 2/2] scsi: ufs: handle LINERESET with correct tm_cmd
Message-ID: <202101070535.QkOU22yl-lkp@intel.com>
References: <20210106193649.3348230-2-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <20210106193649.3348230-2-jaegeuk@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jaegeuk,

I love your patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v5.11-rc2 next-20210104]
[cannot apply to linux/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Jaegeuk-Kim/scsi-ufs-fix-livelock-of-ufshcd_clear_ua_wluns/20210107-034119
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: nds32-randconfig-r012-20210106 (attached as .config)
compiler: nds32le-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/1ae2226bbc3a8096dfceaab9c598f02d387915ba
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jaegeuk-Kim/scsi-ufs-fix-livelock-of-ufshcd_clear_ua_wluns/20210107-034119
        git checkout 1ae2226bbc3a8096dfceaab9c598f02d387915ba
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=nds32 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/device.h:15,
                    from include/linux/async.h:14,
                    from drivers/scsi/ufs/ufshcd.c:12:
   drivers/scsi/ufs/ufshcd.c: In function 'ufshcd_err_handler':
>> drivers/scsi/ufs/ufshcd.c:5922:23: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'long unsigned int' [-Wformat=]
    5922 |     dev_err(hba->dev, "%s: timeout, outstanding=%x\n",
         |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:19:22: note: in definition of macro 'dev_fmt'
      19 | #define dev_fmt(fmt) fmt
         |                      ^~~
   drivers/scsi/ufs/ufshcd.c:5922:5: note: in expansion of macro 'dev_err'
    5922 |     dev_err(hba->dev, "%s: timeout, outstanding=%x\n",
         |     ^~~~~~~
   drivers/scsi/ufs/ufshcd.c:5922:50: note: format string is defined here
    5922 |     dev_err(hba->dev, "%s: timeout, outstanding=%x\n",
         |                                                 ~^
         |                                                  |
         |                                                  unsigned int
         |                                                 %lx


vim +5922 drivers/scsi/ufs/ufshcd.c

  5818	
  5819	/**
  5820	 * ufshcd_err_handler - handle UFS errors that require s/w attention
  5821	 * @work: pointer to work structure
  5822	 */
  5823	static void ufshcd_err_handler(struct work_struct *work)
  5824	{
  5825		struct ufs_hba *hba;
  5826		unsigned long flags;
  5827		bool err_xfer = false;
  5828		bool err_tm = false;
  5829		int err = 0, pmc_err;
  5830		int tag;
  5831		bool needs_reset = false, needs_restore = false;
  5832	
  5833		hba = container_of(work, struct ufs_hba, eh_work);
  5834	
  5835		down(&hba->eh_sem);
  5836		spin_lock_irqsave(hba->host->host_lock, flags);
  5837		if (ufshcd_err_handling_should_stop(hba)) {
  5838			if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
  5839				hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
  5840			spin_unlock_irqrestore(hba->host->host_lock, flags);
  5841			up(&hba->eh_sem);
  5842			return;
  5843		}
  5844		ufshcd_set_eh_in_progress(hba);
  5845		spin_unlock_irqrestore(hba->host->host_lock, flags);
  5846		ufshcd_err_handling_prepare(hba);
  5847		spin_lock_irqsave(hba->host->host_lock, flags);
  5848		ufshcd_scsi_block_requests(hba);
  5849		hba->ufshcd_state = UFSHCD_STATE_RESET;
  5850	
  5851		/* Complete requests that have door-bell cleared by h/w */
  5852		ufshcd_complete_requests(hba);
  5853	
  5854		/*
  5855		 * A full reset and restore might have happened after preparation
  5856		 * is finished, double check whether we should stop.
  5857		 */
  5858		if (ufshcd_err_handling_should_stop(hba))
  5859			goto skip_err_handling;
  5860	
  5861		if (hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
  5862			bool ret;
  5863	
  5864			spin_unlock_irqrestore(hba->host->host_lock, flags);
  5865			/* release the lock as ufshcd_quirk_dl_nac_errors() may sleep */
  5866			ret = ufshcd_quirk_dl_nac_errors(hba);
  5867			spin_lock_irqsave(hba->host->host_lock, flags);
  5868			if (!ret && ufshcd_err_handling_should_stop(hba))
  5869				goto skip_err_handling;
  5870		}
  5871	
  5872		if ((hba->saved_err & (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK)) ||
  5873		    (hba->saved_uic_err &&
  5874		     (hba->saved_uic_err != UFSHCD_UIC_PA_GENERIC_ERROR))) {
  5875			bool pr_prdt = !!(hba->saved_err & SYSTEM_BUS_FATAL_ERROR);
  5876	
  5877			spin_unlock_irqrestore(hba->host->host_lock, flags);
  5878			ufshcd_print_host_state(hba);
  5879			ufshcd_print_pwr_info(hba);
  5880			ufshcd_print_evt_hist(hba);
  5881			ufshcd_print_tmrs(hba, hba->outstanding_tasks);
  5882			ufshcd_print_trs(hba, hba->outstanding_reqs, pr_prdt);
  5883			spin_lock_irqsave(hba->host->host_lock, flags);
  5884		}
  5885	
  5886		/*
  5887		 * if host reset is required then skip clearing the pending
  5888		 * transfers forcefully because they will get cleared during
  5889		 * host reset and restore
  5890		 */
  5891		if (hba->force_reset || ufshcd_is_link_broken(hba) ||
  5892		    ufshcd_is_saved_err_fatal(hba) ||
  5893		    ((hba->saved_err & UIC_ERROR) &&
  5894		     (hba->saved_uic_err & (UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
  5895					    UFSHCD_UIC_DL_TCx_REPLAY_ERROR)))) {
  5896			needs_reset = true;
  5897			goto do_reset;
  5898		}
  5899	
  5900		/*
  5901		 * If LINERESET was caught, UFS might have been put to PWM mode,
  5902		 * check if power mode restore is needed.
  5903		 */
  5904		if (hba->saved_uic_err & UFSHCD_UIC_PA_GENERIC_ERROR) {
  5905			ktime_t start = ktime_get();
  5906	
  5907			hba->saved_uic_err &= ~UFSHCD_UIC_PA_GENERIC_ERROR;
  5908			if (!hba->saved_uic_err)
  5909				hba->saved_err &= ~UIC_ERROR;
  5910			spin_unlock_irqrestore(hba->host->host_lock, flags);
  5911			if (ufshcd_is_pwr_mode_restore_needed(hba))
  5912				needs_restore = true;
  5913			spin_lock_irqsave(hba->host->host_lock, flags);
  5914			/* Wait for IO completion to avoid aborting IOs */
  5915			while (hba->outstanding_reqs) {
  5916				ufshcd_complete_requests(hba);
  5917				spin_unlock_irqrestore(hba->host->host_lock, flags);
  5918				schedule();
  5919				spin_lock_irqsave(hba->host->host_lock, flags);
  5920				if (ktime_to_ms(ktime_sub(ktime_get(), start)) >
  5921							LINERESET_IO_TIMEOUT_MS) {
> 5922					dev_err(hba->dev, "%s: timeout, outstanding=%x\n",
  5923						__func__, hba->outstanding_reqs);
  5924					break;
  5925				}
  5926			}
  5927	
  5928			if (!hba->saved_err && !needs_restore)
  5929				goto skip_err_handling;
  5930		}
  5931	
  5932		hba->silence_err_logs = true;
  5933		/* release lock as clear command might sleep */
  5934		spin_unlock_irqrestore(hba->host->host_lock, flags);
  5935		/* Clear pending transfer requests */
  5936		for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
  5937			if (ufshcd_try_to_abort_task(hba, tag)) {
  5938				err_xfer = true;
  5939				goto lock_skip_pending_xfer_clear;
  5940			}
  5941		}
  5942	
  5943		/* Clear pending task management requests */
  5944		for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
  5945			if (ufshcd_clear_tm_cmd(hba, tag)) {
  5946				err_tm = true;
  5947				goto lock_skip_pending_xfer_clear;
  5948			}
  5949		}
  5950	
  5951	lock_skip_pending_xfer_clear:
  5952		spin_lock_irqsave(hba->host->host_lock, flags);
  5953	
  5954		/* Complete the requests that are cleared by s/w */
  5955		ufshcd_complete_requests(hba);
  5956		hba->silence_err_logs = false;
  5957	
  5958		if (err_xfer || err_tm) {
  5959			needs_reset = true;
  5960			goto do_reset;
  5961		}
  5962	
  5963		/*
  5964		 * After all reqs and tasks are cleared from doorbell,
  5965		 * now it is safe to retore power mode.
  5966		 */
  5967		if (needs_restore) {
  5968			spin_unlock_irqrestore(hba->host->host_lock, flags);
  5969			/*
  5970			 * Hold the scaling lock just in case dev cmds
  5971			 * are sent via bsg and/or sysfs.
  5972			 */
  5973			down_write(&hba->clk_scaling_lock);
  5974			hba->force_pmc = true;
  5975			pmc_err = ufshcd_config_pwr_mode(hba, &(hba->pwr_info));
  5976			if (pmc_err) {
  5977				needs_reset = true;
  5978				dev_err(hba->dev, "%s: Failed to restore power mode, err = %d\n",
  5979						__func__, pmc_err);
  5980			}
  5981			hba->force_pmc = false;
  5982			ufshcd_print_pwr_info(hba);
  5983			up_write(&hba->clk_scaling_lock);
  5984			spin_lock_irqsave(hba->host->host_lock, flags);
  5985		}
  5986	
  5987	do_reset:
  5988		/* Fatal errors need reset */
  5989		if (needs_reset) {
  5990			unsigned long max_doorbells = (1UL << hba->nutrs) - 1;
  5991	
  5992			/*
  5993			 * ufshcd_reset_and_restore() does the link reinitialization
  5994			 * which will need atleast one empty doorbell slot to send the
  5995			 * device management commands (NOP and query commands).
  5996			 * If there is no slot empty at this moment then free up last
  5997			 * slot forcefully.
  5998			 */
  5999			if (hba->outstanding_reqs == max_doorbells)
  6000				__ufshcd_transfer_req_compl(hba,
  6001							    (1UL << (hba->nutrs - 1)));
  6002	
  6003			hba->force_reset = false;
  6004			spin_unlock_irqrestore(hba->host->host_lock, flags);
  6005			err = ufshcd_reset_and_restore(hba);
  6006			if (err)
  6007				dev_err(hba->dev, "%s: reset and restore failed with err %d\n",
  6008						__func__, err);
  6009			else
  6010				ufshcd_recover_pm_error(hba);
  6011			spin_lock_irqsave(hba->host->host_lock, flags);
  6012		}
  6013	
  6014	skip_err_handling:
  6015		if (!needs_reset) {
  6016			if (hba->ufshcd_state == UFSHCD_STATE_RESET)
  6017				hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
  6018			if (hba->saved_err || hba->saved_uic_err)
  6019				dev_err_ratelimited(hba->dev, "%s: exit: saved_err 0x%x saved_uic_err 0x%x",
  6020				    __func__, hba->saved_err, hba->saved_uic_err);
  6021		}
  6022		ufshcd_clear_eh_in_progress(hba);
  6023		spin_unlock_irqrestore(hba->host->host_lock, flags);
  6024		ufshcd_scsi_unblock_requests(hba);
  6025		ufshcd_err_handling_unprepare(hba);
  6026		up(&hba->eh_sem);
  6027	
  6028		if (!err && needs_reset)
  6029			ufshcd_clear_ua_wluns(hba);
  6030	}
  6031	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--5mCyUwZo2JvN/JJP
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
083TJdOJ8rRB79htVIZd7qb7/V8dSr6Uy+wBAA==

--5mCyUwZo2JvN/JJP--
