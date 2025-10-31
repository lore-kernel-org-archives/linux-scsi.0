Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A94D27442
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 01:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761875418; cv=none; b=Kf/RpIzuWNC8R1cAm9nNs3UWr9+zly7hAYZuRkx914F7zXYWCqok64GUd/cq9yg1uTLG1L8NO3yaDupFDJexi5ZNXWvigeuyHZPIsEINiybJ77F8nCB7QDi8Pry15s6bAPmImIyWHtjL+OG4nuQSqTucI+I4QgO/q6z/o1Vq6xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761875418; c=relaxed/simple;
	bh=YL0NbDRqiCyitqQvGZiAJqiTPU7arUeiQi1RUntgDM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u88FdjbcufRF+SfubJN7W4YvqKTTeQcUl4rPTFEzK0RtAWVRQzYorwi7JsmwY9ESCt77iQOObaOR8sJ9Jo0dEzrHXacuGRhCLizbnTmNI1Lvj8qR45HV2aEVcgAhClLa4OqxgeVlf31s4QZBnxKcjOlkertLt89PrQDRtmO3eNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i8hYjsdV; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i8hYjsdV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761875416; x=1793411416;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YL0NbDRqiCyitqQvGZiAJqiTPU7arUeiQi1RUntgDM4=;
  b=i8hYjsdVs90J6+6WpqO/Hu7XaqnHxxyjpCrl1wGfRk2GQ3DBQZjaJ2zh
   p7dGpEqqAJxUWtieNpf/FduWoVpr2J2UynjEZ/so12cKlBWhCEJWgl7Xq
   wosCKJJqVKENcMCnd4oaDRUAJld1JSDYphtZScl6ZPqwbJfSScJJzfpjX
   Rcx+pBOrIA8xjHiFhTjFdL7odGz3aTbZW/IrqwqLBU0/SHYudsqFIFnt3
   U9SjQxfSJiT9vbAgGfbnll6P/q3UZMnYcTocCMYPyurCzBxjcpH+T0ayd
   ZEWhGX94xysJVZLX9ROCll3eQK6O15tnwwlTU/4Dn7Fb23NONQ+T7Zqo8
   Q==;
X-CSE-ConnectionGUID: JZWcqt1+QdOYqQZnkyrWBw==
X-CSE-MsgGUID: a6EqvLJ0ReiVRibhSZllOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="63052147"
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="63052147"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 18:50:16 -0700
X-CSE-ConnectionGUID: CdHoEGHAR7qnuFmFpidqKA==
X-CSE-MsgGUID: Dc9/6WjaTbG0wuwB+ns1OA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="190459933"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 30 Oct 2025 18:50:13 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vEeGu-000Mg4-1J;
	Fri, 31 Oct 2025 01:49:46 +0000
Date: Fri, 31 Oct 2025 09:49:10 +0800
From: kernel test robot <lkp@intel.com>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com, Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: Re: [PATCH v1 3/5] mpt3sas: improve device discovery and readiness
 handling for slow devices part-2
Message-ID: <202510310924.crvtELzs-lkp@intel.com>
References: <20251029181058.39157-4-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029181058.39157-4-ranjan.kumar@broadcom.com>

Hi Ranjan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.18-rc3 next-20251030]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ranjan-Kumar/mpt3sas-Added-no_turs-flag-to-device-unblock-logic/20251030-025730
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251029181058.39157-4-ranjan.kumar%40broadcom.com
patch subject: [PATCH v1 3/5] mpt3sas: improve device discovery and readiness handling for slow devices part-2
config: i386-randconfig-054-20251030 (https://download.01.org/0day-ci/archive/20251031/202510310924.crvtELzs-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251031/202510310924.crvtELzs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510310924.crvtELzs-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/scsi/mpt3sas/mpt3sas_scsih.c:274 struct member 'retries' not described in 'fw_event_work'
>> Warning: drivers/scsi/mpt3sas/mpt3sas_scsih.c:274 struct member 'delayed_work_active' not described in 'fw_event_work'
>> Warning: drivers/scsi/mpt3sas/mpt3sas_scsih.c:274 struct member 'delayed_work' not described in 'fw_event_work'
   Warning: drivers/scsi/mpt3sas/mpt3sas_scsih.c:3885 function parameter 'no_turs' not described in '_scsih_ublock_io_all_device'
>> Warning: drivers/scsi/mpt3sas/mpt3sas_scsih.c:3921 function parameter 'sas_address' not described in '_scsih_ublock_io_device_wait'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
