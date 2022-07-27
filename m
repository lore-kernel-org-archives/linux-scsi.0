Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28002C19F28
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 13:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiG0NP2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jul 2022 09:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbiG0NP0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2022 09:15:26 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F064B2C12B
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2022 06:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658927724; x=1690463724;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c8MQGhyHDMSBbzypeEjRhkbMqn1TTVH0O2qZWHkfsz4=;
  b=Xie4PGftXW/3Z0D3dc2hVrQnrNhVwGY207vcTqNuJpEVD7hKuztekhJq
   RN3EQBIH3O8IA0MyjqvMGKgyqOcdJA4cdBDjmCP8TLo7+KLyhJ37WwNkE
   CnBNEzSMTuAeDX3fpOHmtg68yn0aIojb4X8OqAM1Ox4GOdvShYq+FZwiL
   tc5sNqGnh+jpBYXfLCOYr9yiSKD34+auTIK+zxUtNCkuXq9F5W6qrHV5F
   Ji7kZtiee475jRL/bpwDos/NAjS51vTPfUiIF+bvR3uKi5iFuM7XdQbX6
   744p43SiD4byxTKhnQ+NHWWNGJyCZDKGlpypCGAYvVD907LCt1XWp4e6Q
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="268612146"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="268612146"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 06:15:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="742645921"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2022 06:15:22 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oGgsj-0008jP-2Z;
        Wed, 27 Jul 2022 13:15:21 +0000
Date:   Wed, 27 Jul 2022 21:14:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Bradley Grove <bradley.grove@gmail.com>, linux-scsi@vger.kernel.org
Cc:     kbuild-all@lists.01.org, martin.petersen@oracle.com,
        jejb@linux.ibm.com, suganath-prabu.subramani@broadcom.com,
        sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        Bradley Grove <bgrove@attotech.com>,
        Rob Crispo <rcrispo@attotech.com>
Subject: Re: [PATCH 1/2] scsi: mpt3sas: Add support for ATTO ExpressSAS H12xx
 GT devices
Message-ID: <202207272120.BKaTzCmC-lkp@intel.com>
References: <20220726180103.31575-1-bgrove@attotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726180103.31575-1-bgrove@attotech.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bradley,

I love your patch! Perhaps something to improve:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v5.19-rc8 next-20220726]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bradley-Grove/scsi-mpt3sas-Add-support-for-ATTO-ExpressSAS-H12xx-GT-devices/20220727-020431
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: arm64-randconfig-s032-20220724 (https://download.01.org/0day-ci/archive/20220727/202207272120.BKaTzCmC-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/7174cbb8a0179d86947dea7c91c71788ebdf3aa1
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Bradley-Grove/scsi-mpt3sas-Add-support-for-ATTO-ExpressSAS-H12xx-GT-devices/20220727-020431
        git checkout 7174cbb8a0179d86947dea7c91c71788ebdf3aa1
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/scsi/mpt3sas/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> drivers/scsi/mpt3sas/mpt3sas_base.c:5505:21: sparse: sparse: cast to restricted __be64
>> drivers/scsi/mpt3sas/mpt3sas_base.c:5553:52: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le64 [usertype] ReassignmentWWID @@     got unsigned long long @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:5553:52: sparse:     expected restricted __le64 [usertype] ReassignmentWWID
   drivers/scsi/mpt3sas/mpt3sas_base.c:5553:52: sparse:     got unsigned long long
>> drivers/scsi/mpt3sas/mpt3sas_base.c:5554:58: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le64 [usertype] ReassignmentDeviceName @@     got unsigned long long @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:5554:58: sparse:     expected restricted __le64 [usertype] ReassignmentDeviceName
   drivers/scsi/mpt3sas/mpt3sas_base.c:5554:58: sparse:     got unsigned long long

vim +5505 drivers/scsi/mpt3sas/mpt3sas_base.c

  5477	
  5478	/**
  5479	 * mpt3sas_atto_get_sas_addr - get the ATTO SAS address from mfg page 1
  5480	 *
  5481	 * @ioc : per adapter object
  5482	 * @*sas_addr : return sas address
  5483	 * Return: 0 for success, non-zero for failure.
  5484	 */
  5485	static int
  5486	mpt3sas_atto_get_sas_addr(struct MPT3SAS_ADAPTER *ioc, u64 *sas_addr)
  5487	{
  5488		Mpi2ManufacturingPage1_t mfg_pg1;
  5489		Mpi2ConfigReply_t mpi_reply;
  5490		struct ATTO_SAS_NVRAM *nvram;
  5491		int r;
  5492	
  5493		r = mpt3sas_config_get_manufacturing_pg1(ioc, &mpi_reply, &mfg_pg1);
  5494		if (r) {
  5495			ioc_err(ioc, "Failed to read manufacturing page 1\n");
  5496			return r;
  5497		}
  5498	
  5499		/* validate nvram */
  5500		nvram = (struct ATTO_SAS_NVRAM *) mfg_pg1.VPD;
  5501		r = mpt3sas_atto_validate_nvram(ioc, nvram);
  5502		if (r)
  5503			return r;
  5504	
> 5505		*sas_addr = be64_to_cpu(*((u64 *)nvram->SasAddr));
  5506		return r;
  5507	}
  5508	
  5509	/**
  5510	 * mpt3sas_atto_init - perform initializaion for ATTO branded
  5511	 *					adapter.
  5512	 * @ioc : per adapter object
  5513	 *
  5514	 * Return: 0 for success, non-zero for failure.
  5515	 */
  5516	static int
  5517	mpt3sas_atto_init(struct MPT3SAS_ADAPTER *ioc)
  5518	{
  5519		int sz = 0;
  5520		Mpi2BiosPage4_t *bios_pg4 = NULL;
  5521		Mpi2ConfigReply_t mpi_reply;
  5522		int r;
  5523		int ix;
  5524		u64 sas_addr;
  5525	
  5526		r = mpt3sas_atto_get_sas_addr(ioc, &sas_addr);
  5527		if (r)
  5528			return r;
  5529	
  5530		/* get header first to get size */
  5531		r = mpt3sas_config_get_bios_pg4(ioc, &mpi_reply, NULL, 0);
  5532		if (r) {
  5533			ioc_err(ioc, "Failed to read ATTO bios page 4 header.\n");
  5534			return r;
  5535		}
  5536	
  5537		sz = mpi_reply.Header.PageLength * sizeof(u32);
  5538		bios_pg4 = kzalloc(sz, GFP_KERNEL);
  5539		if (!bios_pg4) {
  5540			ioc_err(ioc, "Failed to allocate memory for ATTO bios page.\n");
  5541			return -ENOMEM;
  5542		}
  5543	
  5544		/* read bios page 4 */
  5545		r = mpt3sas_config_get_bios_pg4(ioc, &mpi_reply, bios_pg4, sz);
  5546		if (r) {
  5547			ioc_err(ioc, "Failed to read ATTO bios page 4\n");
  5548			goto out;
  5549		}
  5550	
  5551		/* Update bios page 4 with the ATTO WWID */
  5552		for (ix = 0; ix < bios_pg4->NumPhys; ix++) {
> 5553			bios_pg4->Phy[ix].ReassignmentWWID = sas_addr + ix;
> 5554			bios_pg4->Phy[ix].ReassignmentDeviceName =
  5555				sas_addr + ATTO_SAS_ADDR_DEVNAME_BIAS;
  5556		}
  5557		r = mpt3sas_config_set_bios_pg4(ioc, &mpi_reply, bios_pg4, sz);
  5558	
  5559	out:
  5560		kfree(bios_pg4);
  5561		return r;
  5562	}
  5563	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
