Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36483132103;
	Sat,  5 Oct 2024 11:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728128111; cv=none; b=SpZ9Jw6+PJjsMPw4tFd6nyPcrUEt6p4rql2I7RaFuaDpGH3/5/Xr4H/lxLPh8ikC6elYr2I/AX1rkKXKOv3ebO6BmyXfvfBenTQn70+BdiCgq1mc9JZXS1QNRi9EYGxersMkDyTR3oxG/uDkakFzy3Z3z92ij55GustlfdzB2OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728128111; c=relaxed/simple;
	bh=deTssEe/7RvaSRhuh3Xd+JWp6Q777gEkbjZuYT8Hh+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLalNiYQnHAwtqbUnZjSymWR5lKYDccbNC7Gmk/Sgt4xrCcOjk8CJVudFTQ3pwQej9aQA8NHqgp6s6RK7Xu4hT5atkMljbPx1P5wJbsHJKHaFEgOZ3UO022m8dseCdlaLkBzoS8tItykuPwkbKRlsj16yRu76EcECvh6GFHaaPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FR/CG+ya; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FR/CG+ya"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728128110; x=1759664110;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=deTssEe/7RvaSRhuh3Xd+JWp6Q777gEkbjZuYT8Hh+A=;
  b=FR/CG+yau0/WIJ8Rud+reo9MEnxg/4AxZy4sk6BZGN4P4ntH0MXzDoVq
   13ZX9M4CCu+E/Vk27uNte+0imYlcVlaTmImx++f85ZrugDVave/lGdQ3L
   hOWGBhCYDid3BSWERBdy3w5sgMgL3dpVpzcw/cXSA0N2eyrXgGqlqsDFE
   TR5hmUGjmnD6mV77lIrZBtaPkEs43EWAriK6ShKoyoTcJSsbiLJxMcV+n
   jLbJ5gxIiuH//bK2u/2ZTEIoN0RK1FJTo2+Z2URVzPo9X6JYMHk5tVfow
   qkRGNUiQfVNmcigFpGrK1hOwbXR7ORDJN8i5nqeB5mBJkqRQcgEHaDO0i
   Q==;
X-CSE-ConnectionGUID: PqjfNi8SSwOk5mrVv2tyEg==
X-CSE-MsgGUID: AH5APngNRLmK+Kxf0JtC2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11215"; a="52737568"
X-IronPort-AV: E=Sophos;i="6.11,180,1725346800"; 
   d="scan'208";a="52737568"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2024 04:35:09 -0700
X-CSE-ConnectionGUID: BIPx5NIARoKlKy2zDgxxEw==
X-CSE-MsgGUID: 1qZFFwY0TM62XIkdICjMqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,180,1725346800"; 
   d="scan'208";a="78945910"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 05 Oct 2024 04:35:07 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sx33w-0002tv-2w;
	Sat, 05 Oct 2024 11:35:04 +0000
Date: Sat, 5 Oct 2024 19:34:28 +0800
From: kernel test robot <lkp@intel.com>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com,
	thenzl@redhat.com, mav@ixsystems.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] mpi3mr: Validating SAS port assignments
Message-ID: <202410051943.Mp9o5DlF-lkp@intel.com>
References: <20241004093140.149951-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004093140.149951-1-ranjan.kumar@broadcom.com>

Hi Ranjan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.12-rc1 next-20241004]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ranjan-Kumar/mpi3mr-Validating-SAS-port-assignments/20241004-173719
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241004093140.149951-1-ranjan.kumar%40broadcom.com
patch subject: [PATCH v1] mpi3mr: Validating SAS port assignments
config: x86_64-buildonly-randconfig-004-20241005 (https://download.01.org/0day-ci/archive/20241005/202410051943.Mp9o5DlF-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241005/202410051943.Mp9o5DlF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410051943.Mp9o5DlF-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/mpi3mr/mpi3mr_transport.c:599: warning: Function parameter or struct member 'host_node' not described in 'mpi3mr_delete_sas_phy'
   drivers/scsi/mpi3mr/mpi3mr_transport.c:1046: warning: Function parameter or struct member 'port_id' not described in 'mpi3mr_get_hba_port_by_id'


vim +599 drivers/scsi/mpi3mr/mpi3mr_transport.c

fc7212fd310092 Sreekanth Reddy 2022-08-04  587  
fc7212fd310092 Sreekanth Reddy 2022-08-04  588  /**
fc7212fd310092 Sreekanth Reddy 2022-08-04  589   * mpi3mr_delete_sas_phy - Remove a single phy from port
fc7212fd310092 Sreekanth Reddy 2022-08-04  590   * @mrioc: Adapter instance reference
fc7212fd310092 Sreekanth Reddy 2022-08-04  591   * @mr_sas_port: Internal Port object
fc7212fd310092 Sreekanth Reddy 2022-08-04  592   * @mr_sas_phy: Internal Phy object
fc7212fd310092 Sreekanth Reddy 2022-08-04  593   *
fc7212fd310092 Sreekanth Reddy 2022-08-04  594   * Return: None.
fc7212fd310092 Sreekanth Reddy 2022-08-04  595   */
fc7212fd310092 Sreekanth Reddy 2022-08-04  596  static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
fc7212fd310092 Sreekanth Reddy 2022-08-04  597  	struct mpi3mr_sas_port *mr_sas_port,
d909d8da87f441 Ranjan Kumar    2024-10-04  598  	struct mpi3mr_sas_phy *mr_sas_phy, u8 host_node)
fc7212fd310092 Sreekanth Reddy 2022-08-04 @599  {
fc7212fd310092 Sreekanth Reddy 2022-08-04  600  	u64 sas_address = mr_sas_port->remote_identify.sas_address;
fc7212fd310092 Sreekanth Reddy 2022-08-04  601  
fc7212fd310092 Sreekanth Reddy 2022-08-04  602  	dev_info(&mr_sas_phy->phy->dev,
fc7212fd310092 Sreekanth Reddy 2022-08-04  603  	    "remove: sas_address(0x%016llx), phy(%d)\n",
fc7212fd310092 Sreekanth Reddy 2022-08-04  604  	    (unsigned long long) sas_address, mr_sas_phy->phy_id);
fc7212fd310092 Sreekanth Reddy 2022-08-04  605  
fc7212fd310092 Sreekanth Reddy 2022-08-04  606  	list_del(&mr_sas_phy->port_siblings);
fc7212fd310092 Sreekanth Reddy 2022-08-04  607  	mr_sas_port->num_phys--;
d909d8da87f441 Ranjan Kumar    2024-10-04  608  
d909d8da87f441 Ranjan Kumar    2024-10-04  609  	if (host_node) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  610  		mr_sas_port->phy_mask &= ~(1 << mr_sas_phy->phy_id);
d909d8da87f441 Ranjan Kumar    2024-10-04  611  
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  612  		if (mr_sas_port->lowest_phy == mr_sas_phy->phy_id)
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  613  			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
d909d8da87f441 Ranjan Kumar    2024-10-04  614  	}
fc7212fd310092 Sreekanth Reddy 2022-08-04  615  	sas_port_delete_phy(mr_sas_port->port, mr_sas_phy->phy);
fc7212fd310092 Sreekanth Reddy 2022-08-04  616  	mr_sas_phy->phy_belongs_to_port = 0;
fc7212fd310092 Sreekanth Reddy 2022-08-04  617  }
fc7212fd310092 Sreekanth Reddy 2022-08-04  618  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
