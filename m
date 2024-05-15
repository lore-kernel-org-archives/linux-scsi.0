Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F267A6EB53
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 12:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715774626; cv=none; b=Z1ZkGgIEML3PiSW2+P/7vR3yQAWq7wdpMe/Tr5pXNOBgj9Uhv4DGKjmHCqzwm1mQNtqdd4V35qLHqlIzVTE9O8nGD1SDd1XccM9BoUyNJnV9I9pMRcOR+nh3v3UbhaMvEtSl0ndXYaR/BwFZ650L0HASasT7sKsvnACGsQfX0o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715774626; c=relaxed/simple;
	bh=/eYzU41qQy2blPCMPIPPUhFLCCQmby44oAuP5Umti9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TpnV0vgcYfxDKLHNHjqee923/EkM095jxdcYU6pLZiXCi8LPn5p+8ZanTCoEqymizCnPn3I98M3HaHfi0iYRtxC1kg7WwdBaqgCcNIeImR1XmXzbqz4xMmiQk4JZjcALsmyskksBpr5z2mI/BBkCO/4WEalfZm0EzonhsNH2q1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gVikAdRZ; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gVikAdRZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715774624; x=1747310624;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/eYzU41qQy2blPCMPIPPUhFLCCQmby44oAuP5Umti9M=;
  b=gVikAdRZ4z6hRgNQcynfMoFXeyCKb903hWGDyY7wyIoJ2y4aGud5ewdD
   TlagMYWw6lUC5e/qw2y/zhXBy9jhb1/CuwDvSg+LjaNl2EXKwhBkpJ85Z
   ClE020BfmxHFwIDxQugPvyizL2+lwp7m6X2153LaUgztiKZeBpMyj0pKb
   hPlwCrwderHUMPPJvYNutPhLbhuJVSeo611xiypdDZyl82mIr8eDjvL+/
   DbjrSTIXSIU4XZCAPDZL2jpe19MiqGHCi77f2MQuHKy4BaxHuySzElcj8
   uJTxLv3vCtgjxtioLkVnBCUWcFTNTFs7MZenHCJhRAkkFYJ/sEISdlcBh
   Q==;
X-CSE-ConnectionGUID: MXPeuvr6QzyqTsjzihGDcQ==
X-CSE-MsgGUID: 2rfheaEIRr2pirXGpom63Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="37196599"
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="37196599"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 05:03:43 -0700
X-CSE-ConnectionGUID: dD7PytfFQ8Sd9O9WcAXdBw==
X-CSE-MsgGUID: fQSlVub2Qu6DaHm8kfvHNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="35572525"
Received: from lkp-server01.sh.intel.com (HELO f8b243fe6e68) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 15 May 2024 05:03:41 -0700
Received: from kbuild by f8b243fe6e68 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s7DMA-000Cnb-2e;
	Wed, 15 May 2024 12:03:38 +0000
Date: Wed, 15 May 2024 20:03:21 +0800
From: kernel test robot <lkp@intel.com>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: Re: [PATCH v1 4/6] mpi3mr: Trigger support
Message-ID: <202405151955.BiAWI1SY-lkp@intel.com>
References: <20240514142858.51992-5-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240514142858.51992-5-ranjan.kumar@broadcom.com>

Hi Ranjan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master next-20240515]
[cannot apply to v6.9]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ranjan-Kumar/mpi3mr-HDB-allocation-and-posting-for-hardware-and-Firmware-buffers/20240514-223346
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240514142858.51992-5-ranjan.kumar%40broadcom.com
patch subject: [PATCH v1 4/6] mpi3mr: Trigger support
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20240515/202405151955.BiAWI1SY-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240515/202405151955.BiAWI1SY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405151955.BiAWI1SY-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/scsi/mpi3mr/mpi3mr_app.c:717: warning: Function parameter or struct member 'trigger_data' not described in 'mpi3mr_set_trigger_data_in_hdb'
   drivers/scsi/mpi3mr/mpi3mr_app.c:717: warning: Excess function parameter 'data' description in 'mpi3mr_set_trigger_data_in_hdb'
>> drivers/scsi/mpi3mr/mpi3mr_app.c:743: warning: Function parameter or struct member 'trigger_data' not described in 'mpi3mr_set_trigger_data_in_all_hdb'
>> drivers/scsi/mpi3mr/mpi3mr_app.c:743: warning: Excess function parameter 'data' description in 'mpi3mr_set_trigger_data_in_all_hdb'


vim +743 drivers/scsi/mpi3mr/mpi3mr_app.c

   726	
   727	/**
   728	 * mpi3mr_set_trigger_data_in_all_hdb - Updates HDB trigger type
   729	 * and trigger data for all HDB
   730	 *
   731	 * @mrioc: Adapter instance reference
   732	 * @type: Trigger type
   733	 * @data: Trigger data
   734	 * @force: Trigger overwrite flag
   735	 *
   736	 * Updates trigger type and trigger data based on parameter
   737	 * passed to this function
   738	 *
   739	 * Return: Nothing
   740	 */
   741	void mpi3mr_set_trigger_data_in_all_hdb(struct mpi3mr_ioc *mrioc,
   742		u8 type, union mpi3mr_trigger_data *trigger_data, bool force)
 > 743	{
   744		struct diag_buffer_desc *hdb = NULL;
   745	
   746		hdb = mpi3mr_diag_buffer_for_type(mrioc, MPI3_DIAG_BUFFER_TYPE_TRACE);
   747		if (hdb)
   748			mpi3mr_set_trigger_data_in_hdb(hdb, type, trigger_data, force);
   749		hdb = mpi3mr_diag_buffer_for_type(mrioc, MPI3_DIAG_BUFFER_TYPE_FW);
   750		if (hdb)
   751			mpi3mr_set_trigger_data_in_hdb(hdb, type, trigger_data, force);
   752	}
   753	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
