Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C9C538B
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jan 2024 05:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lv/0QewG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704431716; x=1735967716;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=O5Leue77prLqsizR2g27j+Tdxy1bfueSC9G+lydx2HA=;
  b=Lv/0QewGOGhYePY1exCbZ1YVi0sBtUY9QAvBwf/ZTz8ac7Bp/LFEh/iS
   QXbsmeTYhVIwGqt/hXLPMa7wk3RSzR1T8iFBT/p44H2dni8Z1l5r575DL
   OsBF03LBCdbGduuWyBB+eD5QSyjXji9Rea4tNJkJNQQ73yfTC+xds5ZTM
   WAsObqJ+iz1Aw9mKRZKTyoSHiQIHuG1VhclpKdnhH72k/I8tI2BiEkvJF
   UO0MVwAAggqCCP511l0FOrdIQ5LWmW2xcq+TbHWbUjDx0njMcCFwEiAZW
   Fxi684FaIS6ly2ddFyodXQE4ilug2QDEAJ56GtPVDpSc56KtIOyXU/OJh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="4794264"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="4794264"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 21:15:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="756843010"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="756843010"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 04 Jan 2024 21:15:12 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rLcY1-0000oO-2o;
	Fri, 05 Jan 2024 05:15:09 +0000
Date: Fri, 5 Jan 2024 13:14:13 +0800
From: kernel test robot <lkp@intel.com>
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
	lduncan@suse.com, cleech@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	GR-QLogic-Storage-Upstream@marvell.com, jmeneghi@redhat.com
Subject: Re: [PATCH v2 2/3] cnic,bnx2,bnx2x: use UIO_MEM_DMA_COHERENT
Message-ID: <202401051255.Qa1W34Jr-lkp@intel.com>
References: <20240103091137.27142-3-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103091137.27142-3-njavali@marvell.com>

Hi Nilesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on char-misc/char-misc-testing]
[also build test WARNING on char-misc/char-misc-next char-misc/char-misc-linus linus/master v6.7-rc8 next-20240104]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nilesh-Javali/uio-introduce-UIO_MEM_DMA_COHERENT-type/20240103-171531
base:   char-misc/char-misc-testing
patch link:    https://lore.kernel.org/r/20240103091137.27142-3-njavali%40marvell.com
patch subject: [PATCH v2 2/3] cnic,bnx2,bnx2x: use UIO_MEM_DMA_COHERENT
config: arc-allmodconfig (https://download.01.org/0day-ci/archive/20240105/202401051255.Qa1W34Jr-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240105/202401051255.Qa1W34Jr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202401051255.Qa1W34Jr-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/broadcom/cnic.c: In function 'cnic_init_uio':
>> drivers/net/ethernet/broadcom/cnic.c:1120:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    1120 |                 uinfo->mem[1].addr = (phys_addr_t)cp->bnx2x_def_status_blk &
         |                                      ^
   drivers/net/ethernet/broadcom/cnic.c:1130:30: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    1130 |         uinfo->mem[2].addr = (phys_addr_t)udev->l2_ring;
         |                              ^
   drivers/net/ethernet/broadcom/cnic.c:1135:30: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    1135 |         uinfo->mem[3].addr = (phys_addr_t)udev->l2_buf;
         |                              ^


vim +1120 drivers/net/ethernet/broadcom/cnic.c

  1088	
  1089	static int cnic_init_uio(struct cnic_dev *dev)
  1090	{
  1091		struct cnic_local *cp = dev->cnic_priv;
  1092		struct cnic_uio_dev *udev = cp->udev;
  1093		struct uio_info *uinfo;
  1094		int ret = 0;
  1095	
  1096		if (!udev)
  1097			return -ENOMEM;
  1098	
  1099		uinfo = &udev->cnic_uinfo;
  1100	
  1101		uinfo->mem[0].addr = pci_resource_start(dev->pcidev, 0);
  1102		uinfo->mem[0].internal_addr = dev->regview;
  1103		uinfo->mem[0].memtype = UIO_MEM_PHYS;
  1104	
  1105		if (test_bit(CNIC_F_BNX2_CLASS, &dev->flags)) {
  1106			uinfo->mem[0].size = MB_GET_CID_ADDR(TX_TSS_CID +
  1107							     TX_MAX_TSS_RINGS + 1);
  1108			uinfo->mem[1].addr = (unsigned long) cp->status_blk.gen &
  1109						CNIC_PAGE_MASK;
  1110			uinfo->mem[1].dma_addr = cp->status_blk_map;
  1111			if (cp->ethdev->drv_state & CNIC_DRV_STATE_USING_MSIX)
  1112				uinfo->mem[1].size = BNX2_SBLK_MSIX_ALIGN_SIZE * 9;
  1113			else
  1114				uinfo->mem[1].size = BNX2_SBLK_MSIX_ALIGN_SIZE;
  1115	
  1116			uinfo->name = "bnx2_cnic";
  1117		} else if (test_bit(CNIC_F_BNX2X_CLASS, &dev->flags)) {
  1118			uinfo->mem[0].size = pci_resource_len(dev->pcidev, 0);
  1119	
> 1120			uinfo->mem[1].addr = (phys_addr_t)cp->bnx2x_def_status_blk &
  1121				CNIC_PAGE_MASK;
  1122			uinfo->mem[1].dma_addr = cp->status_blk_map;
  1123			uinfo->mem[1].size = sizeof(*cp->bnx2x_def_status_blk);
  1124	
  1125			uinfo->name = "bnx2x_cnic";
  1126		}
  1127	
  1128		uinfo->mem[1].memtype = UIO_MEM_DMA_COHERENT;
  1129	
  1130		uinfo->mem[2].addr = (phys_addr_t)udev->l2_ring;
  1131		uinfo->mem[2].dma_addr = udev->l2_ring_map;
  1132		uinfo->mem[2].size = udev->l2_ring_size;
  1133		uinfo->mem[2].memtype = UIO_MEM_DMA_COHERENT;
  1134	
  1135		uinfo->mem[3].addr = (phys_addr_t)udev->l2_buf;
  1136		uinfo->mem[3].dma_addr = udev->l2_buf_map;
  1137		uinfo->mem[3].size = udev->l2_buf_size;
  1138		uinfo->mem[3].memtype = UIO_MEM_DMA_COHERENT;
  1139	
  1140		uinfo->version = CNIC_MODULE_VERSION;
  1141		uinfo->irq = UIO_IRQ_CUSTOM;
  1142	
  1143		uinfo->open = cnic_uio_open;
  1144		uinfo->release = cnic_uio_close;
  1145	
  1146		if (udev->uio_dev == -1) {
  1147			if (!uinfo->priv) {
  1148				uinfo->priv = udev;
  1149	
  1150				ret = uio_register_device(&udev->pdev->dev, uinfo);
  1151			}
  1152		} else {
  1153			cnic_init_rings(dev);
  1154		}
  1155	
  1156		return ret;
  1157	}
  1158	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
