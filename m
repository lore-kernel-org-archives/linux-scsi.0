Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C1B2C15AC;
	Sat, 14 Jun 2025 14:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749909840; cv=none; b=MqaBYfU6yTsETr4Wv4WsY02SuGN/k1ejx7yUbNnjhuvNqxaumtZyrg2wVXk8OpxDGS8OU+zK3iemBqpF3vyh7UyyuBtyc0byC6vuFx0qhuEWz5oHkinIulCMMgcUAobm/aWgGcRDtdF5r2EEzBUmtzp4c94Z2FO2zNzWqN8RIMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749909840; c=relaxed/simple;
	bh=Fi81CSRlkWepJqnNVO5qINgjPScf4yeYt7CwcLuEmJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OmCBVubSA059DpI5S7b/gRtfg0qbPnAwc9LSmVoTYufGP/f9E8ZLUdlJJWDmclpFRNTfTCK1JgDKYPULabnOQPKyP4NEYuZ9YeBtNsONjlPr9o4nUMQkTyUVRQKGW+McAefNo4I+oLqSmsn4WFEd+5tkIRfi/1cLG07wso3xDi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nmGJnB0A; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nmGJnB0A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749909839; x=1781445839;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Fi81CSRlkWepJqnNVO5qINgjPScf4yeYt7CwcLuEmJ0=;
  b=nmGJnB0Anp9Yvgqgr9ggdGDsuALS4ASOgvBqvtEYd3B/bLElioZWZEU5
   dLJqGoujjiwiasLyIzFWsirpXFwoWhhyppHk2Q6V8Xk66Se/rut0DvEPM
   2nXxsmU+8oyp6bQgeh35SCKnhvTpdaSBrOnC3n76IOwt+9/EgtFkpocIS
   ilmPu2bTsO1R1+YyHMqtqtsZX8bJZtIu0dojf5cyAADFnzPBdU2CXzNBf
   q9fCqdnNsY992+3rsL9EbBzHF/u6mggAWxSngbXt8tufaDjymV267kdec
   yX1mos0JD1Y1q2/67f9o/+vs6DsK4Ob4jlDwR8Ldp/TP5c2VYNr6I+qfW
   w==;
X-CSE-ConnectionGUID: R5Im8qcYQSWcjBqVP70fYA==
X-CSE-MsgGUID: 2tyLHbDNR0C85fDHTnB/pQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11464"; a="55913034"
X-IronPort-AV: E=Sophos;i="6.16,236,1744095600"; 
   d="scan'208";a="55913034"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2025 07:03:58 -0700
X-CSE-ConnectionGUID: f8x+VdHoTISIQB0lZOW10Q==
X-CSE-MsgGUID: rvag/gqYSuGKVPQDKhktVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,236,1744095600"; 
   d="scan'208";a="153221007"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 14 Jun 2025 07:03:54 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uQRU7-000DYQ-33;
	Sat, 14 Jun 2025 14:03:51 +0000
Date: Sat, 14 Jun 2025 22:03:50 +0800
From: kernel test robot <lkp@intel.com>
To: Steve Siwinski <stevensiwinski@gmail.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com
Cc: oe-kbuild-all@lists.linux.dev, gustavoars@kernel.org,
	James.Bottomley@hansenpartnership.com, kashyap.desai@broadcom.com,
	kees@kernel.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
	prayas.patel@broadcom.com, ranjan.kumar@broadcom.com,
	sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
	ssiwinski@atto.com, sumit.saxena@broadcom.com, bgrove@atto.com,
	tdoedline@atto.com
Subject: Re: [PATCH 2/2] scsi: mpi3mr: Add initialization for ATTO 24Gb SAS
 HBAs
Message-ID: <202506142133.g9g2Gp1d-lkp@intel.com>
References: <20250613202941.62114-2-ssiwinski@atto.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613202941.62114-2-ssiwinski@atto.com>

Hi Steve,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.16-rc1 next-20250613]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steve-Siwinski/scsi-mpi3mr-Add-initialization-for-ATTO-24Gb-SAS-HBAs/20250614-043438
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250613202941.62114-2-ssiwinski%40atto.com
patch subject: [PATCH 2/2] scsi: mpi3mr: Add initialization for ATTO 24Gb SAS HBAs
config: microblaze-randconfig-r112-20250614 (https://download.01.org/0day-ci/archive/20250614/202506142133.g9g2Gp1d-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 12.4.0
reproduce: (https://download.01.org/0day-ci/archive/20250614/202506142133.g9g2Gp1d-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506142133.g9g2Gp1d-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/scsi/mpi3mr/mpi3mr_fw.c:4248:54: sparse: sparse: cast to restricted __le32
>> drivers/scsi/mpi3mr/mpi3mr_fw.c:4248:54: sparse: sparse: cast to restricted __le32
>> drivers/scsi/mpi3mr/mpi3mr_fw.c:4248:54: sparse: sparse: cast to restricted __le32
>> drivers/scsi/mpi3mr/mpi3mr_fw.c:4248:54: sparse: sparse: cast to restricted __le32
>> drivers/scsi/mpi3mr/mpi3mr_fw.c:4248:54: sparse: sparse: cast to restricted __le32
>> drivers/scsi/mpi3mr/mpi3mr_fw.c:4248:54: sparse: sparse: cast to restricted __le32
>> drivers/scsi/mpi3mr/mpi3mr_fw.c:4286:24: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long long [usertype] q @@     got restricted __le64 [usertype] @@
   drivers/scsi/mpi3mr/mpi3mr_fw.c:4286:24: sparse:     expected unsigned long long [usertype] q
   drivers/scsi/mpi3mr/mpi3mr_fw.c:4286:24: sparse:     got restricted __le64 [usertype]
>> drivers/scsi/mpi3mr/mpi3mr_fw.c:4347:45: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le64 [usertype] device_name @@     got unsigned long long [addressable] [assigned] [usertype] q @@
   drivers/scsi/mpi3mr/mpi3mr_fw.c:4347:45: sparse:     expected restricted __le64 [usertype] device_name
   drivers/scsi/mpi3mr/mpi3mr_fw.c:4347:45: sparse:     got unsigned long long [addressable] [assigned] [usertype] q
>> drivers/scsi/mpi3mr/mpi3mr_fw.c:4348:42: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le64 [usertype] ioc_wwid @@     got unsigned long long [addressable] [assigned] [usertype] q @@
   drivers/scsi/mpi3mr/mpi3mr_fw.c:4348:42: sparse:     expected restricted __le64 [usertype] ioc_wwid
   drivers/scsi/mpi3mr/mpi3mr_fw.c:4348:42: sparse:     got unsigned long long [addressable] [assigned] [usertype] q
>> drivers/scsi/mpi3mr/mpi3mr_fw.c:4349:43: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le64 [usertype] sata_wwid @@     got unsigned long long [addressable] [assigned] [usertype] q @@
   drivers/scsi/mpi3mr/mpi3mr_fw.c:4349:43: sparse:     expected restricted __le64 [usertype] sata_wwid
   drivers/scsi/mpi3mr/mpi3mr_fw.c:4349:43: sparse:     got unsigned long long [addressable] [assigned] [usertype] q
   drivers/scsi/mpi3mr/mpi3mr_fw.c:5256:24: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned char [addressable] [assigned] [usertype] class @@     got restricted __le16 [usertype] @@
   drivers/scsi/mpi3mr/mpi3mr_fw.c:5256:24: sparse:     expected unsigned char [addressable] [assigned] [usertype] class
   drivers/scsi/mpi3mr/mpi3mr_fw.c:5256:24: sparse:     got restricted __le16 [usertype]
>> drivers/scsi/mpi3mr/mpi3mr_fw.c:6720:23: sparse: sparse: restricted __le16 degrades to integer

vim +4248 drivers/scsi/mpi3mr/mpi3mr_fw.c

  4205	
  4206	/**
  4207	 * mpi3mr_atto_validate_nvram - validate the ATTO nvram
  4208	 *
  4209	 * @mrioc:  Adapter instance reference
  4210	 * @nvram: ptr to the ATTO nvram structure
  4211	 * Return: 0 for success, non-zero for failure.
  4212	 */
  4213	static int mpi3mr_atto_validate_nvram(struct mpi3mr_ioc *mrioc, struct ATTO_SAS_NVRAM *nvram)
  4214	{
  4215		int r = -EINVAL;
  4216		union ATTO_SAS_ADDRESS *sasaddr;
  4217		u32 len;
  4218		u8 *pb;
  4219		u8 cksum;
  4220	
  4221		/* validate nvram checksum */
  4222		pb = (u8 *) nvram;
  4223		cksum = ATTO_SASNVR_CKSUM_SEED;
  4224		len = sizeof(struct ATTO_SAS_NVRAM);
  4225	
  4226		while (len--)
  4227			cksum = cksum + pb[len];
  4228	
  4229		if (cksum) {
  4230			ioc_err(mrioc, "Invalid ATTO NVRAM checksum\n");
  4231			return r;
  4232		}
  4233	
  4234		sasaddr = (union ATTO_SAS_ADDRESS *) nvram->sasaddr;
  4235	
  4236		if (nvram->signature[0] != 'E'
  4237		|| nvram->signature[1] != 'S'
  4238		|| nvram->signature[2] != 'A'
  4239		|| nvram->signature[3] != 'S')
  4240			ioc_err(mrioc, "Invalid ATTO NVRAM signature\n");
  4241		else if (nvram->version > ATTO_SASNVR_VERSION)
  4242			ioc_info(mrioc, "Invalid ATTO NVRAM version");
  4243		else if ((nvram->sasaddr[7] & (ATTO_SAS_ADDR_ALIGN - 1))
  4244				|| sasaddr->b[0] != 0x50
  4245				|| sasaddr->b[1] != 0x01
  4246				|| sasaddr->b[2] != 0x08
  4247				|| (sasaddr->b[3] & 0xF0) != 0x60
> 4248				|| ((sasaddr->b[3] & 0x0F) | le32_to_cpu(sasaddr->d[1])) == 0) {
  4249			ioc_err(mrioc, "Invalid ATTO SAS address\n");
  4250		} else
  4251			r = 0;
  4252		return r;
  4253	}
  4254	
  4255	/**
  4256	 * mpi3mr_atto_get_sas_addr - get the ATTO SAS address from driver page 2
  4257	 *
  4258	 * @mrioc: Adapter instance reference
  4259	 * @*sas_address: return sas address
  4260	 * Return: 0 for success, non-zero for failure.
  4261	 */
  4262	static int mpi3mr_atto_get_sas_addr(struct mpi3mr_ioc *mrioc, union ATTO_SAS_ADDRESS *sas_address)
  4263	{
  4264		struct mpi3_driver_page2 *driver_pg2 = NULL;
  4265		struct ATTO_SAS_NVRAM *nvram;
  4266		u16 sz;
  4267		int r;
  4268		__be64 addr;
  4269	
  4270		sz = mpi3mr_cfg_get_page_size(mrioc, MPI3_CONFIG_PAGETYPE_DRIVER, 2);
  4271		driver_pg2 = kzalloc(sz, GFP_KERNEL);
  4272		if (!driver_pg2)
  4273			goto out;
  4274	
  4275		r = mpi3mr_cfg_get_driver_pg2(mrioc, driver_pg2, sz, MPI3_CONFIG_ACTION_READ_PERSISTENT);
  4276		if (r)
  4277			goto out;
  4278	
  4279		nvram = (struct ATTO_SAS_NVRAM *) &driver_pg2->trigger;
  4280	
  4281		r = mpi3mr_atto_validate_nvram(mrioc, nvram);
  4282		if (r)
  4283			goto out;
  4284	
  4285		addr = *((__be64 *) nvram->sasaddr);
> 4286		sas_address->q = cpu_to_le64(be64_to_cpu(addr));
  4287	
  4288	out:
  4289		kfree(driver_pg2);
  4290		return r;
  4291	}
  4292	
  4293	/**
  4294	 * mpi3mr_atto_init - Initialize the controller
  4295	 * @mrioc: Adapter instance reference
  4296	 *
  4297	 * This the ATTO controller initialization routine
  4298	 *
  4299	 * Return: 0 on success and non-zero on failure.
  4300	 */
  4301	static int mpi3mr_atto_init(struct mpi3mr_ioc *mrioc)
  4302	{
  4303		int i, bias = 0;
  4304		u16 sz;
  4305		struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 = NULL;
  4306		struct mpi3_man_page5 *man_pg5 = NULL;
  4307		union ATTO_SAS_ADDRESS base_address;
  4308		union ATTO_SAS_ADDRESS dev_address;
  4309		union ATTO_SAS_ADDRESS sas_address;
  4310	
  4311		sz = mpi3mr_cfg_get_page_size(mrioc, MPI3_CONFIG_PAGETYPE_SAS_IO_UNIT, 0);
  4312		sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
  4313		if (!sas_io_unit_pg0)
  4314			goto out;
  4315	
  4316		if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
  4317			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
  4318			    __FILE__, __LINE__, __func__);
  4319			goto out;
  4320		}
  4321	
  4322		sz = mpi3mr_cfg_get_page_size(mrioc, MPI3_CONFIG_PAGETYPE_MANUFACTURING, 5);
  4323		man_pg5 = kzalloc(sz, GFP_KERNEL);
  4324		if (!man_pg5)
  4325			goto out;
  4326	
  4327		if (mpi3mr_cfg_get_man_pg5(mrioc, man_pg5, sz)) {
  4328			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
  4329			    __FILE__, __LINE__, __func__);
  4330			goto out;
  4331		}
  4332	
  4333		mpi3mr_atto_get_sas_addr(mrioc, &base_address);
  4334	
  4335		dev_address.q = base_address.q;
  4336		dev_address.b[0] += ATTO_SAS_ADDR_DEVNAME_BIAS;
  4337	
  4338		for (i = 0; i < man_pg5->num_phys; i++) {
  4339			if (sas_io_unit_pg0->phy_data[i].phy_flags &
  4340				(MPI3_SASIOUNIT0_PHYFLAGS_HOST_PHY |
  4341				MPI3_SASIOUNIT0_PHYFLAGS_VIRTUAL_PHY))
  4342				continue;
  4343	
  4344			sas_address.q = base_address.q;
  4345			sas_address.b[0] += bias++;
  4346	
> 4347			man_pg5->phy[i].device_name = dev_address.q;
> 4348			man_pg5->phy[i].ioc_wwid = sas_address.q;
> 4349			man_pg5->phy[i].sata_wwid = sas_address.q;
  4350		}
  4351	
  4352		if (mpi3mr_cfg_set_man_pg5(mrioc, man_pg5, sz))
  4353			ioc_info(mrioc, "ATTO set manufacuring page 5 failed\n");
  4354	
  4355	out:
  4356		kfree(sas_io_unit_pg0);
  4357		kfree(man_pg5);
  4358	
  4359		return 0;
  4360	}
  4361	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
