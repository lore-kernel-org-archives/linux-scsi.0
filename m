Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EF3199FA8;
	Thu, 24 Oct 2024 20:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729800264; cv=none; b=gScmlJb37vJPnsBIsw5XUXgUC2gzcb1BPd6yMPGMin+aksetotMDqiOOUvhV1xjkeDn/mJGZ0uX7Ur+kqpQwyadrOZ12WmfQy4L3YorixPxSOvKRnrlKDRbYCvON2hrIS2tlfK3gTXLM+O2QNBIA+p+QX5kdAB5hNkPnQT83bVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729800264; c=relaxed/simple;
	bh=27C1Vzzp7RcsIVr1g7Bt2FGTpBOy0t2vuwO+ZbKtASk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gqSXdfSUmErNYIviCNozBFF2/dXw6bLb8p7H/rE9NouTMZOvBB2iZXdCI+YdM5oa0fEsDLyD703oNYUp9frNB7aaYSB2abz/3kxLyPys61CG9CH9/spcM6NQF0gfzIgY8dr78puRAyrwihDz1j06jGBhunhVBYsM34PXZRGQRMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ez2s3j7v; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ez2s3j7v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729800262; x=1761336262;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=27C1Vzzp7RcsIVr1g7Bt2FGTpBOy0t2vuwO+ZbKtASk=;
  b=Ez2s3j7vcyT5ZkMtufdhk7lpcP88hT+LoGD9/+ffGjnlJJP3lYuG6lz0
   VfJ7C7QIKnHefRgnlzo2zpiCOIlK/ZB2pleXljBOp9hBHzs2ROAMzFT9a
   If3SNRqTkHV+HWT+0EO0aNkRSqGG2x3GtX2jtNsI7zrqBC3kLZ+02l1xb
   byM5iZDZwgFQK5qCcpnSBtiWiri6nzPndhgkN4X+Cg79KTFwRHc84xWzQ
   mVNXLfR5CK7EWeSU/NV69V+W4odxlvBwDkI/6nFn5xb+A4bb4567l/W8W
   wdTPHDKIQ8Whik954YBOZx3ckOEQptZuaaC3uAPD8CEZabWYOIUOpBLro
   Q==;
X-CSE-ConnectionGUID: QaEsvvGkSuGaFYKnvVR5NA==
X-CSE-MsgGUID: tIC5aHMnQnqhbnxGtWZGog==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="46918344"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="46918344"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 13:04:21 -0700
X-CSE-ConnectionGUID: bIeS7D68Qvq4X/xJQ0sv5Q==
X-CSE-MsgGUID: E4GKgR+mTkOUwcac4J29sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,230,1725346800"; 
   d="scan'208";a="80351381"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 24 Oct 2024 13:04:19 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t4447-000X1d-32;
	Thu, 24 Oct 2024 20:04:15 +0000
Date: Fri, 25 Oct 2024 04:03:20 +0800
From: kernel test robot <lkp@intel.com>
To: Mirsad Todorovac <mtodorovac69@gmail.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v1 1/1] scsi: gla2xxx: use flexible array member at the
 end of structures
Message-ID: <202410250349.J9KCXkwk-lkp@intel.com>
References: <20241023221700.220063-2-mtodorovac69@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023221700.220063-2-mtodorovac69@gmail.com>

Hi Mirsad,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.12-rc4 next-20241024]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mirsad-Todorovac/scsi-gla2xxx-use-flexible-array-member-at-the-end-of-structures/20241024-062120
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241023221700.220063-2-mtodorovac69%40gmail.com
patch subject: [PATCH v1 1/1] scsi: gla2xxx: use flexible array member at the end of structures
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20241025/202410250349.J9KCXkwk-lkp@intel.com/config)
compiler: clang version 19.1.2 (https://github.com/llvm/llvm-project 7ba7d8e2f7b6445b60679da826210cdde29eaf8b)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241025/202410250349.J9KCXkwk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410250349.J9KCXkwk-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/scsi/qla2xxx/qla_os.c:6:
   In file included from drivers/scsi/qla2xxx/qla_def.h:14:
   In file included from include/linux/pci.h:1650:
   In file included from include/linux/dmapool.h:14:
   In file included from include/linux/scatterlist.h:8:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:504:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     504 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     505 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:511:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     511 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     512 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:524:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     524 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     525 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> drivers/scsi/qla2xxx/qla_os.c:8220:2: error: call to '__compiletime_assert_779' declared with 'error' attribute: BUILD_BUG_ON failed: sizeof(struct qla2300_fw_dump) != 136100
    8220 |         BUILD_BUG_ON(sizeof(struct qla2300_fw_dump) != 136100);
         |         ^
   include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^
   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^
   include/linux/compiler_types.h:517:2: note: expanded from macro 'compiletime_assert'
     517 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^
   include/linux/compiler_types.h:505:2: note: expanded from macro '_compiletime_assert'
     505 |         __compiletime_assert(condition, msg, prefix, suffix)
         |         ^
   include/linux/compiler_types.h:498:4: note: expanded from macro '__compiletime_assert'
     498 |                         prefix ## suffix();                             \
         |                         ^
   <scratch space>:71:1: note: expanded from here
      71 | __compiletime_assert_779
         | ^
   4 warnings and 1 error generated.


vim +8220 drivers/scsi/qla2xxx/qla_os.c

6a03b4cd78f3f2 Harish Zunjarrao   2010-05-04  8163  
^1da177e4c3f41 Linus Torvalds     2005-04-16  8164  /**
^1da177e4c3f41 Linus Torvalds     2005-04-16  8165   * qla2x00_module_init - Module initialization.
^1da177e4c3f41 Linus Torvalds     2005-04-16  8166   **/
^1da177e4c3f41 Linus Torvalds     2005-04-16  8167  static int __init
^1da177e4c3f41 Linus Torvalds     2005-04-16  8168  qla2x00_module_init(void)
^1da177e4c3f41 Linus Torvalds     2005-04-16  8169  {
fca297037127e5 Andrew Vasquez     2005-07-06  8170  	int ret = 0;
fca297037127e5 Andrew Vasquez     2005-07-06  8171  
8a73a0e002b318 Bart Van Assche    2020-05-18  8172  	BUILD_BUG_ON(sizeof(cmd_a64_entry_t) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8173  	BUILD_BUG_ON(sizeof(cmd_entry_t) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8174  	BUILD_BUG_ON(sizeof(cont_a64_entry_t) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8175  	BUILD_BUG_ON(sizeof(cont_entry_t) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8176  	BUILD_BUG_ON(sizeof(init_cb_t) != 96);
8a73a0e002b318 Bart Van Assche    2020-05-18  8177  	BUILD_BUG_ON(sizeof(mrk_entry_t) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8178  	BUILD_BUG_ON(sizeof(ms_iocb_entry_t) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8179  	BUILD_BUG_ON(sizeof(request_t) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8180  	BUILD_BUG_ON(sizeof(struct abort_entry_24xx) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8181  	BUILD_BUG_ON(sizeof(struct abort_iocb_entry_fx00) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8182  	BUILD_BUG_ON(sizeof(struct abts_entry_24xx) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8183  	BUILD_BUG_ON(sizeof(struct access_chip_84xx) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8184  	BUILD_BUG_ON(sizeof(struct access_chip_rsp_84xx) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8185  	BUILD_BUG_ON(sizeof(struct cmd_bidir) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8186  	BUILD_BUG_ON(sizeof(struct cmd_nvme) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8187  	BUILD_BUG_ON(sizeof(struct cmd_type_6) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8188  	BUILD_BUG_ON(sizeof(struct cmd_type_7) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8189  	BUILD_BUG_ON(sizeof(struct cmd_type_7_fx00) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8190  	BUILD_BUG_ON(sizeof(struct cmd_type_crc_2) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8191  	BUILD_BUG_ON(sizeof(struct ct_entry_24xx) != 64);
137316ba79a686 Arun Easi          2021-08-09  8192  	BUILD_BUG_ON(sizeof(struct ct_fdmi1_hba_attributes) != 2604);
8a73a0e002b318 Bart Van Assche    2020-05-18  8193  	BUILD_BUG_ON(sizeof(struct ct_fdmi2_hba_attributes) != 4424);
8a73a0e002b318 Bart Van Assche    2020-05-18  8194  	BUILD_BUG_ON(sizeof(struct ct_fdmi2_port_attributes) != 4164);
8a73a0e002b318 Bart Van Assche    2020-05-18  8195  	BUILD_BUG_ON(sizeof(struct ct_fdmi_hba_attr) != 260);
8a73a0e002b318 Bart Van Assche    2020-05-18  8196  	BUILD_BUG_ON(sizeof(struct ct_fdmi_port_attr) != 260);
8a73a0e002b318 Bart Van Assche    2020-05-18  8197  	BUILD_BUG_ON(sizeof(struct ct_rsp_hdr) != 16);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8198  	BUILD_BUG_ON(sizeof(struct ctio_crc2_to_fw) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8199  	BUILD_BUG_ON(sizeof(struct device_reg_24xx) != 256);
8a73a0e002b318 Bart Van Assche    2020-05-18  8200  	BUILD_BUG_ON(sizeof(struct device_reg_25xxmq) != 24);
8a73a0e002b318 Bart Van Assche    2020-05-18  8201  	BUILD_BUG_ON(sizeof(struct device_reg_2xxx) != 256);
8a73a0e002b318 Bart Van Assche    2020-05-18  8202  	BUILD_BUG_ON(sizeof(struct device_reg_82xx) != 1288);
8a73a0e002b318 Bart Van Assche    2020-05-18  8203  	BUILD_BUG_ON(sizeof(struct device_reg_fx00) != 216);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8204  	BUILD_BUG_ON(sizeof(struct els_entry_24xx) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8205  	BUILD_BUG_ON(sizeof(struct els_sts_entry_24xx) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8206  	BUILD_BUG_ON(sizeof(struct fxdisc_entry_fx00) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8207  	BUILD_BUG_ON(sizeof(struct imm_ntfy_from_isp) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8208  	BUILD_BUG_ON(sizeof(struct init_cb_24xx) != 128);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8209  	BUILD_BUG_ON(sizeof(struct init_cb_81xx) != 128);
8a73a0e002b318 Bart Van Assche    2020-05-18  8210  	BUILD_BUG_ON(sizeof(struct logio_entry_24xx) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8211  	BUILD_BUG_ON(sizeof(struct mbx_entry) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8212  	BUILD_BUG_ON(sizeof(struct mid_init_cb_24xx) != 5252);
8a73a0e002b318 Bart Van Assche    2020-05-18  8213  	BUILD_BUG_ON(sizeof(struct mrk_entry_24xx) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8214  	BUILD_BUG_ON(sizeof(struct nvram_24xx) != 512);
8a73a0e002b318 Bart Van Assche    2020-05-18  8215  	BUILD_BUG_ON(sizeof(struct nvram_81xx) != 512);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8216  	BUILD_BUG_ON(sizeof(struct pt_ls4_request) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8217  	BUILD_BUG_ON(sizeof(struct pt_ls4_rx_unsol) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8218  	BUILD_BUG_ON(sizeof(struct purex_entry_24xx) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8219  	BUILD_BUG_ON(sizeof(struct qla2100_fw_dump) != 123634);
8a73a0e002b318 Bart Van Assche    2020-05-18 @8220  	BUILD_BUG_ON(sizeof(struct qla2300_fw_dump) != 136100);
8a73a0e002b318 Bart Van Assche    2020-05-18  8221  	BUILD_BUG_ON(sizeof(struct qla24xx_fw_dump) != 37976);
8a73a0e002b318 Bart Van Assche    2020-05-18  8222  	BUILD_BUG_ON(sizeof(struct qla25xx_fw_dump) != 39228);
8a73a0e002b318 Bart Van Assche    2020-05-18  8223  	BUILD_BUG_ON(sizeof(struct qla2xxx_fce_chain) != 52);
8a73a0e002b318 Bart Van Assche    2020-05-18  8224  	BUILD_BUG_ON(sizeof(struct qla2xxx_fw_dump) != 136172);
8a73a0e002b318 Bart Van Assche    2020-05-18  8225  	BUILD_BUG_ON(sizeof(struct qla2xxx_mq_chain) != 524);
8a73a0e002b318 Bart Van Assche    2020-05-18  8226  	BUILD_BUG_ON(sizeof(struct qla2xxx_mqueue_chain) != 8);
8a73a0e002b318 Bart Van Assche    2020-05-18  8227  	BUILD_BUG_ON(sizeof(struct qla2xxx_mqueue_header) != 12);
8a73a0e002b318 Bart Van Assche    2020-05-18  8228  	BUILD_BUG_ON(sizeof(struct qla2xxx_offld_chain) != 24);
8a73a0e002b318 Bart Van Assche    2020-05-18  8229  	BUILD_BUG_ON(sizeof(struct qla81xx_fw_dump) != 39420);
8a73a0e002b318 Bart Van Assche    2020-05-18  8230  	BUILD_BUG_ON(sizeof(struct qla82xx_uri_data_desc) != 28);
8a73a0e002b318 Bart Van Assche    2020-05-18  8231  	BUILD_BUG_ON(sizeof(struct qla82xx_uri_table_desc) != 32);
8a73a0e002b318 Bart Van Assche    2020-05-18  8232  	BUILD_BUG_ON(sizeof(struct qla83xx_fw_dump) != 51196);
d9ab5f1f05fc14 Bart Van Assche    2020-05-18  8233  	BUILD_BUG_ON(sizeof(struct qla_fcp_prio_cfg) != FCP_PRIO_CFG_SIZE);
8a73a0e002b318 Bart Van Assche    2020-05-18  8234  	BUILD_BUG_ON(sizeof(struct qla_fdt_layout) != 128);
59d23cf3f2e4c1 Bart Van Assche    2020-05-18  8235  	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
59d23cf3f2e4c1 Bart Van Assche    2020-05-18  8236  	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
8a73a0e002b318 Bart Van Assche    2020-05-18  8237  	BUILD_BUG_ON(sizeof(struct qla_npiv_entry) != 24);
8a73a0e002b318 Bart Van Assche    2020-05-18  8238  	BUILD_BUG_ON(sizeof(struct qla_npiv_header) != 16);
8a73a0e002b318 Bart Van Assche    2020-05-18  8239  	BUILD_BUG_ON(sizeof(struct rdp_rsp_payload) != 336);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8240  	BUILD_BUG_ON(sizeof(struct sns_cmd_pkt) != 2064);
8a73a0e002b318 Bart Van Assche    2020-05-18  8241  	BUILD_BUG_ON(sizeof(struct sts_entry_24xx) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8242  	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8243  	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry_fx00) != 64);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8244  	BUILD_BUG_ON(sizeof(struct verify_chip_entry_84xx) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8245  	BUILD_BUG_ON(sizeof(struct verify_chip_rsp_84xx) != 52);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8246  	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
8a73a0e002b318 Bart Van Assche    2020-05-18  8247  	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8248  	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8249  	BUILD_BUG_ON(sizeof(struct vp_rpt_id_entry_24xx) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8250  	BUILD_BUG_ON(sizeof(sts21_entry_t) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8251  	BUILD_BUG_ON(sizeof(sts22_entry_t) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8252  	BUILD_BUG_ON(sizeof(sts_cont_entry_t) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8253  	BUILD_BUG_ON(sizeof(sts_entry_t) != 64);
8a73a0e002b318 Bart Van Assche    2020-05-18  8254  	BUILD_BUG_ON(sizeof(sw_info_t) != 32);
8a73a0e002b318 Bart Van Assche    2020-05-18  8255  	BUILD_BUG_ON(sizeof(target_id_t) != 2);
bc04459ce4e5d3 Bart Van Assche    2019-04-17  8256  
8bfc149ba24cb9 Arun Easi          2022-08-26  8257  	qla_trace_init();
8bfc149ba24cb9 Arun Easi          2022-08-26  8258  
^1da177e4c3f41 Linus Torvalds     2005-04-16  8259  	/* Allocate cache for SRBs. */
354d6b2196c8e5 Andrew Vasquez     2005-04-23  8260  	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
20c2df83d25c6a Paul Mundt         2007-07-20  8261  	    SLAB_HWCACHE_ALIGN, NULL);
^1da177e4c3f41 Linus Torvalds     2005-04-16  8262  	if (srb_cachep == NULL) {
7c3df1320e5e87 Saurav Kashyap     2011-07-14  8263  		ql_log(ql_log_fatal, NULL, 0x0001,
7c3df1320e5e87 Saurav Kashyap     2011-07-14  8264  		    "Unable to allocate SRB cache...Failing load!.\n");
^1da177e4c3f41 Linus Torvalds     2005-04-16  8265  		return -ENOMEM;
^1da177e4c3f41 Linus Torvalds     2005-04-16  8266  	}
^1da177e4c3f41 Linus Torvalds     2005-04-16  8267  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  8268  	/* Initialize target kmem_cache and mem_pools */
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  8269  	ret = qlt_init();
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  8270  	if (ret < 0) {
c794d24ec9eb66 Bart Van Assche    2019-04-04  8271  		goto destroy_cache;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  8272  	} else if (ret > 0) {
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  8273  		/*
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  8274  		 * If initiator mode is explictly disabled by qlt_init(),
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  8275  		 * prevent scsi_transport_fc.c:fc_scsi_scan_rport() from
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  8276  		 * performing scsi_scan_target() during LOOP UP event.
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  8277  		 */
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  8278  		qla2xxx_transport_functions.disable_target_scan = 1;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  8279  		qla2xxx_transport_vport_functions.disable_target_scan = 1;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  8280  	}
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  8281  
^1da177e4c3f41 Linus Torvalds     2005-04-16  8282  	/* Derive version string. */
^1da177e4c3f41 Linus Torvalds     2005-04-16  8283  	strcpy(qla2x00_version_str, QLA2XXX_VERSION);
11010fecd2a1fd Andrew Vasquez     2006-10-06  8284  	if (ql2xextended_error_logging)
^1da177e4c3f41 Linus Torvalds     2005-04-16  8285  		strcat(qla2x00_version_str, "-debug");
fed0f68aa167e5 Joe Carnuccio      2017-08-23  8286  	if (ql2xextended_error_logging == 1)
fed0f68aa167e5 Joe Carnuccio      2017-08-23  8287  		ql2xextended_error_logging = QL_DBG_DEFAULT1_MASK;
0181944fe647ca Andrew Vasquez     2006-06-23  8288  
1c97a12a29b49a Andrew Vasquez     2005-04-21  8289  	qla2xxx_transport_template =
1c97a12a29b49a Andrew Vasquez     2005-04-21  8290  	    fc_attach_transport(&qla2xxx_transport_functions);
2c3dfe3f6ad8da Seokmann Ju        2007-07-05  8291  	if (!qla2xxx_transport_template) {
7c3df1320e5e87 Saurav Kashyap     2011-07-14  8292  		ql_log(ql_log_fatal, NULL, 0x0002,
7c3df1320e5e87 Saurav Kashyap     2011-07-14  8293  		    "fc_attach_transport failed...Failing load!.\n");
c794d24ec9eb66 Bart Van Assche    2019-04-04  8294  		ret = -ENODEV;
c794d24ec9eb66 Bart Van Assche    2019-04-04  8295  		goto qlt_exit;
2c3dfe3f6ad8da Seokmann Ju        2007-07-05  8296  	}
6a03b4cd78f3f2 Harish Zunjarrao   2010-05-04  8297  
6a03b4cd78f3f2 Harish Zunjarrao   2010-05-04  8298  	apidev_major = register_chrdev(0, QLA2XXX_APIDEV, &apidev_fops);
6a03b4cd78f3f2 Harish Zunjarrao   2010-05-04  8299  	if (apidev_major < 0) {
7c3df1320e5e87 Saurav Kashyap     2011-07-14  8300  		ql_log(ql_log_fatal, NULL, 0x0003,
7c3df1320e5e87 Saurav Kashyap     2011-07-14  8301  		    "Unable to register char device %s.\n", QLA2XXX_APIDEV);
6a03b4cd78f3f2 Harish Zunjarrao   2010-05-04  8302  	}
6a03b4cd78f3f2 Harish Zunjarrao   2010-05-04  8303  
2c3dfe3f6ad8da Seokmann Ju        2007-07-05  8304  	qla2xxx_transport_vport_template =
2c3dfe3f6ad8da Seokmann Ju        2007-07-05  8305  	    fc_attach_transport(&qla2xxx_transport_vport_functions);
2c3dfe3f6ad8da Seokmann Ju        2007-07-05  8306  	if (!qla2xxx_transport_vport_template) {
7c3df1320e5e87 Saurav Kashyap     2011-07-14  8307  		ql_log(ql_log_fatal, NULL, 0x0004,
7c3df1320e5e87 Saurav Kashyap     2011-07-14  8308  		    "fc_attach_transport vport failed...Failing load!.\n");
c794d24ec9eb66 Bart Van Assche    2019-04-04  8309  		ret = -ENODEV;
c794d24ec9eb66 Bart Van Assche    2019-04-04  8310  		goto unreg_chrdev;
2c3dfe3f6ad8da Seokmann Ju        2007-07-05  8311  	}
7c3df1320e5e87 Saurav Kashyap     2011-07-14  8312  	ql_log(ql_log_info, NULL, 0x0005,
7c3df1320e5e87 Saurav Kashyap     2011-07-14  8313  	    "QLogic Fibre Channel HBA Driver: %s.\n",
fd9a29f03600f3 Andrew Vasquez     2008-05-12  8314  	    qla2x00_version_str);
7ee613970947bd Andrew Vasquez     2006-06-23  8315  	ret = pci_register_driver(&qla2xxx_pci_driver);
fca297037127e5 Andrew Vasquez     2005-07-06  8316  	if (ret) {
7c3df1320e5e87 Saurav Kashyap     2011-07-14  8317  		ql_log(ql_log_fatal, NULL, 0x0006,
7c3df1320e5e87 Saurav Kashyap     2011-07-14  8318  		    "pci_register_driver failed...ret=%d Failing load!.\n",
7c3df1320e5e87 Saurav Kashyap     2011-07-14  8319  		    ret);
c794d24ec9eb66 Bart Van Assche    2019-04-04  8320  		goto release_vport_transport;
fca297037127e5 Andrew Vasquez     2005-07-06  8321  	}
fca297037127e5 Andrew Vasquez     2005-07-06  8322  	return ret;
c794d24ec9eb66 Bart Van Assche    2019-04-04  8323  
c794d24ec9eb66 Bart Van Assche    2019-04-04  8324  release_vport_transport:
c794d24ec9eb66 Bart Van Assche    2019-04-04  8325  	fc_release_transport(qla2xxx_transport_vport_template);
c794d24ec9eb66 Bart Van Assche    2019-04-04  8326  
c794d24ec9eb66 Bart Van Assche    2019-04-04  8327  unreg_chrdev:
c794d24ec9eb66 Bart Van Assche    2019-04-04  8328  	if (apidev_major >= 0)
c794d24ec9eb66 Bart Van Assche    2019-04-04  8329  		unregister_chrdev(apidev_major, QLA2XXX_APIDEV);
c794d24ec9eb66 Bart Van Assche    2019-04-04  8330  	fc_release_transport(qla2xxx_transport_template);
c794d24ec9eb66 Bart Van Assche    2019-04-04  8331  
c794d24ec9eb66 Bart Van Assche    2019-04-04  8332  qlt_exit:
c794d24ec9eb66 Bart Van Assche    2019-04-04  8333  	qlt_exit();
c794d24ec9eb66 Bart Van Assche    2019-04-04  8334  
c794d24ec9eb66 Bart Van Assche    2019-04-04  8335  destroy_cache:
c794d24ec9eb66 Bart Van Assche    2019-04-04  8336  	kmem_cache_destroy(srb_cachep);
8bfc149ba24cb9 Arun Easi          2022-08-26  8337  
8bfc149ba24cb9 Arun Easi          2022-08-26  8338  	qla_trace_uninit();
c794d24ec9eb66 Bart Van Assche    2019-04-04  8339  	return ret;
^1da177e4c3f41 Linus Torvalds     2005-04-16  8340  }
^1da177e4c3f41 Linus Torvalds     2005-04-16  8341  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
