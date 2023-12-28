Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE42101C0
	for <linux-scsi@vger.kernel.org>; Thu, 28 Dec 2023 15:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YA3O6h4d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703777639; x=1735313639;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3pEokfFz2y7pz/JF0Tg91xNugi6ayGfFjBITwIgc/rU=;
  b=YA3O6h4dANuQyzpPMtMiOaTW+wPAMRXQ9hihmq4l/1o4RV4UrXGM9Uda
   2qZXMkk940bpD0Ju/cK4GCMvKpI7WxAxgE4bHuo0eg7MDWsflfNiW/kx4
   ErDH7Zaxf2uo+7BPOmjyF9uPpJMEGnYbKvhvrXsnkOMhJPeNTx+j/2XE6
   IOb23v96hgJJ+3re9girsM5OsuUkLKF82a66sNuuEMiIAXHqq387xuC6F
   b6GCcnzOO96rpjXz24fgKsfQAwOvUsroWY8wy3F3jXO4W9TYKH8N7EWiR
   gETtCG9e4bWhEW3+UuIskRscFknMOdcdLkqV56gnFVRXBfhYSKi6hyAUZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10936"; a="3858126"
X-IronPort-AV: E=Sophos;i="6.04,312,1695711600"; 
   d="scan'208";a="3858126"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2023 07:33:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10936"; a="901995269"
X-IronPort-AV: E=Sophos;i="6.04,312,1695711600"; 
   d="scan'208";a="901995269"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 28 Dec 2023 07:33:29 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rIsNx-000GZP-37;
	Thu, 28 Dec 2023 15:33:26 +0000
Date: Thu, 28 Dec 2023 23:32:36 +0800
From: kernel test robot <lkp@intel.com>
To: Guixin Liu <kanie@linux.alibaba.com>, sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: use ida to manage mrioc's id
Message-ID: <202312282332.zSXzP6f3-lkp@intel.com>
References: <20231228032545.22644-1-kanie@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231228032545.22644-1-kanie@linux.alibaba.com>

Hi Guixin,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.7-rc7 next-20231222]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Guixin-Liu/scsi-mpi3mr-use-ida-to-manage-mrioc-s-id/20231228-113132
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20231228032545.22644-1-kanie%40linux.alibaba.com
patch subject: [PATCH] scsi: mpi3mr: use ida to manage mrioc's id
config: microblaze-allmodconfig (https://download.01.org/0day-ci/archive/20231228/202312282332.zSXzP6f3-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231228/202312282332.zSXzP6f3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202312282332.zSXzP6f3-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/scsi/mpi3mr/mpi3mr_os.c: In function 'mpi3mr_probe':
>> drivers/scsi/mpi3mr/mpi3mr_os.c:5081:35: warning: 'sprintf' may write a terminating nul past the end of the destination [-Wformat-overflow=]
    5081 |         sprintf(mrioc->name, "%s%d", mrioc->driver_name, mrioc->id);
         |                                   ^
   drivers/scsi/mpi3mr/mpi3mr_os.c:5081:9: note: 'sprintf' output between 2 and 43 bytes into a destination of size 32
    5081 |         sprintf(mrioc->name, "%s%d", mrioc->driver_name, mrioc->id);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/scsi/mpi3mr/mpi3mr_os.c:5178:18: warning: '_fwevt_wrkr' directive output may be truncated writing 11 bytes into a region of size between 0 and 31 [-Wformat-truncation=]
    5178 |             "%s%d_fwevt_wrkr", mrioc->driver_name, mrioc->id);
         |                  ^~~~~~~~~~~
   drivers/scsi/mpi3mr/mpi3mr_os.c:5177:9: note: 'snprintf' output between 13 and 54 bytes into a destination of size 32
    5177 |         snprintf(mrioc->fwevt_worker_name, sizeof(mrioc->fwevt_worker_name),
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    5178 |             "%s%d_fwevt_wrkr", mrioc->driver_name, mrioc->id);
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
   drivers/scsi/mpi3mr/mpi3mr_fw.c: In function 'mpi3mr_setup_isr':
>> drivers/scsi/mpi3mr/mpi3mr_fw.c:732:60: warning: '-msix' directive output may be truncated writing 5 bytes into a region of size between 0 and 31 [-Wformat-truncation=]
     732 |         snprintf(intr_info->name, MPI3MR_NAME_LENGTH, "%s%d-msix%d",
         |                                                            ^~~~~
   In function 'mpi3mr_request_irq',
       inlined from 'mpi3mr_setup_isr' at drivers/scsi/mpi3mr/mpi3mr_fw.c:857:12:
   drivers/scsi/mpi3mr/mpi3mr_fw.c:732:55: note: directive argument in the range [0, 65535]
     732 |         snprintf(intr_info->name, MPI3MR_NAME_LENGTH, "%s%d-msix%d",
         |                                                       ^~~~~~~~~~~~~
   drivers/scsi/mpi3mr/mpi3mr_fw.c:732:9: note: 'snprintf' output between 8 and 53 bytes into a destination of size 32
     732 |         snprintf(intr_info->name, MPI3MR_NAME_LENGTH, "%s%d-msix%d",
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     733 |             mrioc->driver_name, mrioc->id, index);
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/scsi/mpi3mr/mpi3mr_fw.c: In function 'mpi3mr_start_watchdog':
   drivers/scsi/mpi3mr/mpi3mr_fw.c:2685:60: warning: '%s' directive output may be truncated writing up to 31 bytes into a region of size 11 [-Wformat-truncation=]
    2685 |             sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
         |                                                            ^~
   drivers/scsi/mpi3mr/mpi3mr_fw.c:2684:9: note: 'snprintf' output between 11 and 52 bytes into a destination of size 20
    2684 |         snprintf(mrioc->watchdog_work_q_name,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2685 |             sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2686 |             mrioc->id);
         |             ~~~~~~~~~~


vim +/sprintf +5081 drivers/scsi/mpi3mr/mpi3mr_os.c

28cbe2f420d338 Kashyap Desai        2021-05-20  5040  
824a156633dfdb Kashyap Desai        2021-05-20  5041  /**
824a156633dfdb Kashyap Desai        2021-05-20  5042   * mpi3mr_probe - PCI probe callback
824a156633dfdb Kashyap Desai        2021-05-20  5043   * @pdev: PCI device instance
824a156633dfdb Kashyap Desai        2021-05-20  5044   * @id: PCI device ID details
824a156633dfdb Kashyap Desai        2021-05-20  5045   *
824a156633dfdb Kashyap Desai        2021-05-20  5046   * controller initialization routine. Checks the security status
824a156633dfdb Kashyap Desai        2021-05-20  5047   * of the controller and if it is invalid or tampered return the
824a156633dfdb Kashyap Desai        2021-05-20  5048   * probe without initializing the controller. Otherwise,
824a156633dfdb Kashyap Desai        2021-05-20  5049   * allocate per adapter instance through shost_priv and
824a156633dfdb Kashyap Desai        2021-05-20  5050   * initialize controller specific data structures, initializae
824a156633dfdb Kashyap Desai        2021-05-20  5051   * the controller hardware, add shost to the SCSI subsystem.
824a156633dfdb Kashyap Desai        2021-05-20  5052   *
824a156633dfdb Kashyap Desai        2021-05-20  5053   * Return: 0 on success, non-zero on failure.
824a156633dfdb Kashyap Desai        2021-05-20  5054   */
824a156633dfdb Kashyap Desai        2021-05-20  5055  
824a156633dfdb Kashyap Desai        2021-05-20  5056  static int
824a156633dfdb Kashyap Desai        2021-05-20  5057  mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
824a156633dfdb Kashyap Desai        2021-05-20  5058  {
824a156633dfdb Kashyap Desai        2021-05-20  5059  	struct mpi3mr_ioc *mrioc = NULL;
824a156633dfdb Kashyap Desai        2021-05-20  5060  	struct Scsi_Host *shost = NULL;
13ef29ea4aa065 Kashyap Desai        2021-05-20  5061  	int retval = 0, i;
824a156633dfdb Kashyap Desai        2021-05-20  5062  
28cbe2f420d338 Kashyap Desai        2021-05-20  5063  	if (osintfc_mrioc_security_status(pdev)) {
28cbe2f420d338 Kashyap Desai        2021-05-20  5064  		warn_non_secure_ctlr = 1;
28cbe2f420d338 Kashyap Desai        2021-05-20  5065  		return 1; /* For Invalid and Tampered device */
28cbe2f420d338 Kashyap Desai        2021-05-20  5066  	}
28cbe2f420d338 Kashyap Desai        2021-05-20  5067  
824a156633dfdb Kashyap Desai        2021-05-20  5068  	shost = scsi_host_alloc(&mpi3mr_driver_template,
824a156633dfdb Kashyap Desai        2021-05-20  5069  	    sizeof(struct mpi3mr_ioc));
824a156633dfdb Kashyap Desai        2021-05-20  5070  	if (!shost) {
824a156633dfdb Kashyap Desai        2021-05-20  5071  		retval = -ENODEV;
824a156633dfdb Kashyap Desai        2021-05-20  5072  		goto shost_failed;
824a156633dfdb Kashyap Desai        2021-05-20  5073  	}
824a156633dfdb Kashyap Desai        2021-05-20  5074  
824a156633dfdb Kashyap Desai        2021-05-20  5075  	mrioc = shost_priv(shost);
422412712184f9 Guixin Liu           2023-12-28  5076  	retval = ida_alloc(&mrioc_ida, GFP_KERNEL);
422412712184f9 Guixin Liu           2023-12-28  5077  	if (retval < 0)
422412712184f9 Guixin Liu           2023-12-28  5078  		goto id_alloc_failed;
422412712184f9 Guixin Liu           2023-12-28  5079  	mrioc->id = retval;
824a156633dfdb Kashyap Desai        2021-05-20  5080  	sprintf(mrioc->driver_name, "%s", MPI3MR_DRIVER_NAME);
824a156633dfdb Kashyap Desai        2021-05-20 @5081  	sprintf(mrioc->name, "%s%d", mrioc->driver_name, mrioc->id);
824a156633dfdb Kashyap Desai        2021-05-20  5082  	INIT_LIST_HEAD(&mrioc->list);
824a156633dfdb Kashyap Desai        2021-05-20  5083  	spin_lock(&mrioc_list_lock);
824a156633dfdb Kashyap Desai        2021-05-20  5084  	list_add_tail(&mrioc->list, &mrioc_list);
824a156633dfdb Kashyap Desai        2021-05-20  5085  	spin_unlock(&mrioc_list_lock);
824a156633dfdb Kashyap Desai        2021-05-20  5086  
824a156633dfdb Kashyap Desai        2021-05-20  5087  	spin_lock_init(&mrioc->admin_req_lock);
824a156633dfdb Kashyap Desai        2021-05-20  5088  	spin_lock_init(&mrioc->reply_free_queue_lock);
824a156633dfdb Kashyap Desai        2021-05-20  5089  	spin_lock_init(&mrioc->sbq_lock);
13ef29ea4aa065 Kashyap Desai        2021-05-20  5090  	spin_lock_init(&mrioc->fwevt_lock);
13ef29ea4aa065 Kashyap Desai        2021-05-20  5091  	spin_lock_init(&mrioc->tgtdev_lock);
672ae26c82166d Kashyap Desai        2021-05-20  5092  	spin_lock_init(&mrioc->watchdog_lock);
023ab2a9b4edd4 Kashyap Desai        2021-05-20  5093  	spin_lock_init(&mrioc->chain_buf_lock);
125ad1e6b445e8 Sreekanth Reddy      2022-08-04  5094  	spin_lock_init(&mrioc->sas_node_lock);
824a156633dfdb Kashyap Desai        2021-05-20  5095  
13ef29ea4aa065 Kashyap Desai        2021-05-20  5096  	INIT_LIST_HEAD(&mrioc->fwevt_list);
13ef29ea4aa065 Kashyap Desai        2021-05-20  5097  	INIT_LIST_HEAD(&mrioc->tgtdev_list);
13ef29ea4aa065 Kashyap Desai        2021-05-20  5098  	INIT_LIST_HEAD(&mrioc->delayed_rmhs_list);
c1af985d27da2d Sreekanth Reddy      2021-12-20  5099  	INIT_LIST_HEAD(&mrioc->delayed_evtack_cmds_list);
125ad1e6b445e8 Sreekanth Reddy      2022-08-04  5100  	INIT_LIST_HEAD(&mrioc->sas_expander_list);
125ad1e6b445e8 Sreekanth Reddy      2022-08-04  5101  	INIT_LIST_HEAD(&mrioc->hba_port_table_list);
7188c03ff8849c Sreekanth Reddy      2022-08-04  5102  	INIT_LIST_HEAD(&mrioc->enclosure_list);
13ef29ea4aa065 Kashyap Desai        2021-05-20  5103  
fb9b04574f1478 Kashyap Desai        2021-05-20  5104  	mutex_init(&mrioc->reset_mutex);
824a156633dfdb Kashyap Desai        2021-05-20  5105  	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
e844adb1fbdc41 Kashyap Desai        2021-05-20  5106  	mpi3mr_init_drv_cmd(&mrioc->host_tm_cmds, MPI3MR_HOSTTAG_BLK_TMS);
f5e6d5a3437610 Sumit Saxena         2022-04-29  5107  	mpi3mr_init_drv_cmd(&mrioc->bsg_cmds, MPI3MR_HOSTTAG_BSG_CMDS);
32d457d5a2af9b Sreekanth Reddy      2022-08-04  5108  	mpi3mr_init_drv_cmd(&mrioc->cfg_cmds, MPI3MR_HOSTTAG_CFG_CMDS);
2bd37e28491401 Sreekanth Reddy      2022-08-04  5109  	mpi3mr_init_drv_cmd(&mrioc->transport_cmds,
2bd37e28491401 Sreekanth Reddy      2022-08-04  5110  	    MPI3MR_HOSTTAG_TRANSPORT_CMDS);
672ae26c82166d Kashyap Desai        2021-05-20  5111  
13ef29ea4aa065 Kashyap Desai        2021-05-20  5112  	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
13ef29ea4aa065 Kashyap Desai        2021-05-20  5113  		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
13ef29ea4aa065 Kashyap Desai        2021-05-20  5114  		    MPI3MR_HOSTTAG_DEVRMCMD_MIN + i);
13ef29ea4aa065 Kashyap Desai        2021-05-20  5115  
e39ea831ebad4a Shin'ichiro Kawasaki 2023-02-14  5116  	for (i = 0; i < MPI3MR_NUM_EVTACKCMD; i++)
e39ea831ebad4a Shin'ichiro Kawasaki 2023-02-14  5117  		mpi3mr_init_drv_cmd(&mrioc->evtack_cmds[i],
e39ea831ebad4a Shin'ichiro Kawasaki 2023-02-14  5118  				    MPI3MR_HOSTTAG_EVTACKCMD_MIN + i);
e39ea831ebad4a Shin'ichiro Kawasaki 2023-02-14  5119  
c9260ff28ee561 Sumit Saxena         2023-11-23  5120  	if ((pdev->device == MPI3_MFGPAGE_DEVID_SAS4116) &&
c9260ff28ee561 Sumit Saxena         2023-11-23  5121  		!pdev->revision)
c9260ff28ee561 Sumit Saxena         2023-11-23  5122  		mrioc->enable_segqueue = false;
c9260ff28ee561 Sumit Saxena         2023-11-23  5123  	else
c9566231cfaf44 Kashyap Desai        2021-05-20  5124  		mrioc->enable_segqueue = true;
824a156633dfdb Kashyap Desai        2021-05-20  5125  
fb9b04574f1478 Kashyap Desai        2021-05-20  5126  	init_waitqueue_head(&mrioc->reset_waitq);
824a156633dfdb Kashyap Desai        2021-05-20  5127  	mrioc->logging_level = logging_level;
824a156633dfdb Kashyap Desai        2021-05-20  5128  	mrioc->shost = shost;
824a156633dfdb Kashyap Desai        2021-05-20  5129  	mrioc->pdev = pdev;
f5e6d5a3437610 Sumit Saxena         2022-04-29  5130  	mrioc->stop_bsgs = 1;
824a156633dfdb Kashyap Desai        2021-05-20  5131  
d9adb81e67e9be Ranjan Kumar         2023-08-04  5132  	mrioc->max_sgl_entries = max_sgl_entries;
d9adb81e67e9be Ranjan Kumar         2023-08-04  5133  	if (max_sgl_entries > MPI3MR_MAX_SGL_ENTRIES)
d9adb81e67e9be Ranjan Kumar         2023-08-04  5134  		mrioc->max_sgl_entries = MPI3MR_MAX_SGL_ENTRIES;
d9adb81e67e9be Ranjan Kumar         2023-08-04  5135  	else if (max_sgl_entries < MPI3MR_DEFAULT_SGL_ENTRIES)
d9adb81e67e9be Ranjan Kumar         2023-08-04  5136  		mrioc->max_sgl_entries = MPI3MR_DEFAULT_SGL_ENTRIES;
d9adb81e67e9be Ranjan Kumar         2023-08-04  5137  	else {
d9adb81e67e9be Ranjan Kumar         2023-08-04  5138  		mrioc->max_sgl_entries /= MPI3MR_DEFAULT_SGL_ENTRIES;
d9adb81e67e9be Ranjan Kumar         2023-08-04  5139  		mrioc->max_sgl_entries *= MPI3MR_DEFAULT_SGL_ENTRIES;
d9adb81e67e9be Ranjan Kumar         2023-08-04  5140  	}
d9adb81e67e9be Ranjan Kumar         2023-08-04  5141  
824a156633dfdb Kashyap Desai        2021-05-20  5142  	/* init shost parameters */
824a156633dfdb Kashyap Desai        2021-05-20  5143  	shost->max_cmd_len = MPI3MR_MAX_CDB_LENGTH;
824a156633dfdb Kashyap Desai        2021-05-20  5144  	shost->max_lun = -1;
824a156633dfdb Kashyap Desai        2021-05-20  5145  	shost->unique_id = mrioc->id;
824a156633dfdb Kashyap Desai        2021-05-20  5146  
97e6ea6d78064e Sreekanth Reddy      2021-10-14  5147  	shost->max_channel = 0;
824a156633dfdb Kashyap Desai        2021-05-20  5148  	shost->max_id = 0xFFFFFFFF;
824a156633dfdb Kashyap Desai        2021-05-20  5149  
465191d6526a8e Sreekanth Reddy      2022-06-28  5150  	shost->host_tagset = 1;
465191d6526a8e Sreekanth Reddy      2022-06-28  5151  
74e1f30a286809 Kashyap Desai        2021-05-20  5152  	if (prot_mask >= 0)
74e1f30a286809 Kashyap Desai        2021-05-20  5153  		scsi_host_set_prot(shost, prot_mask);
74e1f30a286809 Kashyap Desai        2021-05-20  5154  	else {
74e1f30a286809 Kashyap Desai        2021-05-20  5155  		prot_mask = SHOST_DIF_TYPE1_PROTECTION
74e1f30a286809 Kashyap Desai        2021-05-20  5156  		    | SHOST_DIF_TYPE2_PROTECTION
74e1f30a286809 Kashyap Desai        2021-05-20  5157  		    | SHOST_DIF_TYPE3_PROTECTION;
74e1f30a286809 Kashyap Desai        2021-05-20  5158  		scsi_host_set_prot(shost, prot_mask);
74e1f30a286809 Kashyap Desai        2021-05-20  5159  	}
74e1f30a286809 Kashyap Desai        2021-05-20  5160  
74e1f30a286809 Kashyap Desai        2021-05-20  5161  	ioc_info(mrioc,
74e1f30a286809 Kashyap Desai        2021-05-20  5162  	    "%s :host protection capabilities enabled %s%s%s%s%s%s%s\n",
74e1f30a286809 Kashyap Desai        2021-05-20  5163  	    __func__,
74e1f30a286809 Kashyap Desai        2021-05-20  5164  	    (prot_mask & SHOST_DIF_TYPE1_PROTECTION) ? " DIF1" : "",
74e1f30a286809 Kashyap Desai        2021-05-20  5165  	    (prot_mask & SHOST_DIF_TYPE2_PROTECTION) ? " DIF2" : "",
74e1f30a286809 Kashyap Desai        2021-05-20  5166  	    (prot_mask & SHOST_DIF_TYPE3_PROTECTION) ? " DIF3" : "",
74e1f30a286809 Kashyap Desai        2021-05-20  5167  	    (prot_mask & SHOST_DIX_TYPE0_PROTECTION) ? " DIX0" : "",
74e1f30a286809 Kashyap Desai        2021-05-20  5168  	    (prot_mask & SHOST_DIX_TYPE1_PROTECTION) ? " DIX1" : "",
74e1f30a286809 Kashyap Desai        2021-05-20  5169  	    (prot_mask & SHOST_DIX_TYPE2_PROTECTION) ? " DIX2" : "",
74e1f30a286809 Kashyap Desai        2021-05-20  5170  	    (prot_mask & SHOST_DIX_TYPE3_PROTECTION) ? " DIX3" : "");
74e1f30a286809 Kashyap Desai        2021-05-20  5171  
74e1f30a286809 Kashyap Desai        2021-05-20  5172  	if (prot_guard_mask)
74e1f30a286809 Kashyap Desai        2021-05-20  5173  		scsi_host_set_guard(shost, (prot_guard_mask & 3));
74e1f30a286809 Kashyap Desai        2021-05-20  5174  	else
74e1f30a286809 Kashyap Desai        2021-05-20  5175  		scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
74e1f30a286809 Kashyap Desai        2021-05-20  5176  
13ef29ea4aa065 Kashyap Desai        2021-05-20  5177  	snprintf(mrioc->fwevt_worker_name, sizeof(mrioc->fwevt_worker_name),
13ef29ea4aa065 Kashyap Desai        2021-05-20 @5178  	    "%s%d_fwevt_wrkr", mrioc->driver_name, mrioc->id);
13ef29ea4aa065 Kashyap Desai        2021-05-20  5179  	mrioc->fwevt_worker_thread = alloc_ordered_workqueue(
334ae6459aa38a Sreekanth Reddy      2022-02-18  5180  	    mrioc->fwevt_worker_name, 0);
13ef29ea4aa065 Kashyap Desai        2021-05-20  5181  	if (!mrioc->fwevt_worker_thread) {
13ef29ea4aa065 Kashyap Desai        2021-05-20  5182  		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
13ef29ea4aa065 Kashyap Desai        2021-05-20  5183  		    __FILE__, __LINE__, __func__);
13ef29ea4aa065 Kashyap Desai        2021-05-20  5184  		retval = -ENODEV;
fe6db615156573 Sreekanth Reddy      2021-12-20  5185  		goto fwevtthread_failed;
13ef29ea4aa065 Kashyap Desai        2021-05-20  5186  	}
13ef29ea4aa065 Kashyap Desai        2021-05-20  5187  
824a156633dfdb Kashyap Desai        2021-05-20  5188  	mrioc->is_driver_loading = 1;
fe6db615156573 Sreekanth Reddy      2021-12-20  5189  	mrioc->cpu_count = num_online_cpus();
fe6db615156573 Sreekanth Reddy      2021-12-20  5190  	if (mpi3mr_setup_resources(mrioc)) {
fe6db615156573 Sreekanth Reddy      2021-12-20  5191  		ioc_err(mrioc, "setup resources failed\n");
fe6db615156573 Sreekanth Reddy      2021-12-20  5192  		retval = -ENODEV;
fe6db615156573 Sreekanth Reddy      2021-12-20  5193  		goto resource_alloc_failed;
fe6db615156573 Sreekanth Reddy      2021-12-20  5194  	}
fe6db615156573 Sreekanth Reddy      2021-12-20  5195  	if (mpi3mr_init_ioc(mrioc)) {
fe6db615156573 Sreekanth Reddy      2021-12-20  5196  		ioc_err(mrioc, "initializing IOC failed\n");
824a156633dfdb Kashyap Desai        2021-05-20  5197  		retval = -ENODEV;
fe6db615156573 Sreekanth Reddy      2021-12-20  5198  		goto init_ioc_failed;
824a156633dfdb Kashyap Desai        2021-05-20  5199  	}
824a156633dfdb Kashyap Desai        2021-05-20  5200  
824a156633dfdb Kashyap Desai        2021-05-20  5201  	shost->nr_hw_queues = mrioc->num_op_reply_q;
afd3a5793fe2a2 Sreekanth Reddy      2021-12-20  5202  	if (mrioc->active_poll_qcount)
afd3a5793fe2a2 Sreekanth Reddy      2021-12-20  5203  		shost->nr_maps = 3;
afd3a5793fe2a2 Sreekanth Reddy      2021-12-20  5204  
824a156633dfdb Kashyap Desai        2021-05-20  5205  	shost->can_queue = mrioc->max_host_ios;
d9adb81e67e9be Ranjan Kumar         2023-08-04  5206  	shost->sg_tablesize = mrioc->max_sgl_entries;
fe6db615156573 Sreekanth Reddy      2021-12-20  5207  	shost->max_id = mrioc->facts.max_perids + 1;
824a156633dfdb Kashyap Desai        2021-05-20  5208  
824a156633dfdb Kashyap Desai        2021-05-20  5209  	retval = scsi_add_host(shost, &pdev->dev);
824a156633dfdb Kashyap Desai        2021-05-20  5210  	if (retval) {
824a156633dfdb Kashyap Desai        2021-05-20  5211  		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
824a156633dfdb Kashyap Desai        2021-05-20  5212  		    __FILE__, __LINE__, __func__);
824a156633dfdb Kashyap Desai        2021-05-20  5213  		goto addhost_failed;
824a156633dfdb Kashyap Desai        2021-05-20  5214  	}
824a156633dfdb Kashyap Desai        2021-05-20  5215  
824a156633dfdb Kashyap Desai        2021-05-20  5216  	scsi_scan_host(shost);
4268fa7513655a Sumit Saxena         2022-04-29  5217  	mpi3mr_bsg_init(mrioc);
824a156633dfdb Kashyap Desai        2021-05-20  5218  	return retval;
824a156633dfdb Kashyap Desai        2021-05-20  5219  
824a156633dfdb Kashyap Desai        2021-05-20  5220  addhost_failed:
fe6db615156573 Sreekanth Reddy      2021-12-20  5221  	mpi3mr_stop_watchdog(mrioc);
fe6db615156573 Sreekanth Reddy      2021-12-20  5222  	mpi3mr_cleanup_ioc(mrioc);
fe6db615156573 Sreekanth Reddy      2021-12-20  5223  init_ioc_failed:
fe6db615156573 Sreekanth Reddy      2021-12-20  5224  	mpi3mr_free_mem(mrioc);
fe6db615156573 Sreekanth Reddy      2021-12-20  5225  	mpi3mr_cleanup_resources(mrioc);
fe6db615156573 Sreekanth Reddy      2021-12-20  5226  resource_alloc_failed:
13ef29ea4aa065 Kashyap Desai        2021-05-20  5227  	destroy_workqueue(mrioc->fwevt_worker_thread);
fe6db615156573 Sreekanth Reddy      2021-12-20  5228  fwevtthread_failed:
422412712184f9 Guixin Liu           2023-12-28  5229  	ida_free(&mrioc_ida, mrioc->id);
824a156633dfdb Kashyap Desai        2021-05-20  5230  	spin_lock(&mrioc_list_lock);
824a156633dfdb Kashyap Desai        2021-05-20  5231  	list_del(&mrioc->list);
824a156633dfdb Kashyap Desai        2021-05-20  5232  	spin_unlock(&mrioc_list_lock);
422412712184f9 Guixin Liu           2023-12-28  5233  id_alloc_failed:
824a156633dfdb Kashyap Desai        2021-05-20  5234  	scsi_host_put(shost);
824a156633dfdb Kashyap Desai        2021-05-20  5235  shost_failed:
824a156633dfdb Kashyap Desai        2021-05-20  5236  	return retval;
824a156633dfdb Kashyap Desai        2021-05-20  5237  }
824a156633dfdb Kashyap Desai        2021-05-20  5238  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
