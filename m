Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36884DE72D;
	Fri,  9 Oct 2026 13:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552218; cv=none; b=TrToTAjgIyq07T9mNB22NkVYZsI0xVkxbysq3695ryON91yc5G/Y1JQ5Q0o1gmoAOP0h+A8baKXcu8s8j6WOdieighYHOE2QsgB4sfg9pAbwgzJepPWumiOZgCce1VD5G1OeyMxCAgKxteSNw7uIMz/eOf9Y+yK3xJeArDLA6bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552218; c=relaxed/simple;
	bh=4H+cfQ6gedWLiGYFeWv9qkDPH02uU6E0Vl/1XEXCSTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TRtydNdwGDSD4K/OXYYMelCbgkHU+cOD58pm4FhwHGg7D2uKSDtHscUTE8xBpQwOB/lI5Yfo9/kUrWRg7FhBW/41O1wtPNCmb3J9JreWYSt8og3caGAiDzn0bXK5HNHY57JKCmGI2E68QO8JvyfUoWkjGga13FFs/F1STtxPchY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZYheJiFO; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZYheJiFO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791552216; x=1823088216;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4H+cfQ6gedWLiGYFeWv9qkDPH02uU6E0Vl/1XEXCSTU=;
  b=ZYheJiFOSUi/wHBCMj8p9BkATO8008knz5uOPjMq1fjK4e4lOL06KGWe
   mL9eF8iQ/dhvuIJUc/Cyub1rItoehqfRyLtveulHVJL14mxotIFfMd6LE
   XU0QbI8NSmwo/9g1ge6xBZ9fqur6Pd5ixwFiIn7k5TzI0FIYfRgTJW+Q9
   KiKGJwb0WayuH2vPYhJNVMG+RKMVZlR4VPv4aKqgWZO2F37aVcTFQOu1o
   kAJGEOIF5v3jvlmxUEU6kFLSJXVzsSj6Kl3E/K+2negWVgvBDxq8cdDcO
   T5irmgrs0wHefjzghoQ4HKB3i83qT2nzFHSoYkUtzeHPBx2iSpmII6nqT
   Q==;
X-CSE-ConnectionGUID: ZcUgQNTRQAivdlehww5HIA==
X-CSE-MsgGUID: hJdRQp12QvyU3vd0hOXECw==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="351439"
X-IronPort-AV: E=Sophos;i="6.27,148,1787036400"; 
   d="scan'208";a="351439"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 06:23:35 -0700
X-CSE-ConnectionGUID: fM27SqKuQ1a9/cYZZhFHCQ==
X-CSE-MsgGUID: aqHt4obJTHKybI4bEsAbVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,148,1787036400"; 
   d="scan'208";a="437266"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 09 Oct 2026 06:23:33 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xFAZN-000000005q0-2wVU;
	Fri, 09 Oct 2026 13:23:29 +0000
Date: Fri, 9 Oct 2026 21:22:57 +0800
From: kernel test robot <lkp@intel.com>
To: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Dave Marquardt <davemarq@linux.ibm.com>
Subject: Re: [PATCH v13 07/11] scsi: ibmvfc: extend async event handlers for
 async sub-CRQ events
Message-ID: <202610092107.e7gHIyl7-lkp@intel.com>
References: <20261007-ibmvfc-fpin-support-v13-7-b816abfa4fcc@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007-ibmvfc-fpin-support-v13-7-b816abfa4fcc@linux.ibm.com>

Hi Dave,

kernel test robot noticed the following build warnings:

[auto build test WARNING on c3cff7fac01638ab58e85fe7df41a04fa25c5bae]

url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Marquardt-via-B4-Relay/scsi-ibmvfc-fix-IRQ-leak-and-guard-deregister-on-channel-reg-failure/20261007-142545
base:   c3cff7fac01638ab58e85fe7df41a04fa25c5bae
patch link:    https://lore.kernel.org/r/20261007-ibmvfc-fpin-support-v13-7-b816abfa4fcc%40linux.ibm.com
patch subject: [PATCH v13 07/11] scsi: ibmvfc: extend async event handlers for async sub-CRQ events
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20261009/202610092107.e7gHIyl7-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261009/202610092107.e7gHIyl7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610092107.e7gHIyl7-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:1907 expecting prototype for ibmvfc_relogin(). Prototype was for ibmvfc_scsi_relogin() instead
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'fpin_status' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'wwpn' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'type' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'modifier' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'threshold' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'event_count' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3403 function parameter 'crq' not described in 'ibmvfc_basic_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3403 function parameter 'wwpn' not described in 'ibmvfc_basic_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3403 Excess function parameter 'ibmvfc_fpin' description in 'ibmvfc_basic_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3442 function parameter 'wwpn' not described in 'ibmvfc_full_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:5367 function parameter 'protocol' not described in 'ibmvfc_alloc_target'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'fpin_status' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'wwpn' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'type' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'modifier' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'threshold' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'event_count' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3403 function parameter 'crq' not described in 'ibmvfc_basic_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3403 function parameter 'wwpn' not described in 'ibmvfc_basic_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3403 Excess function parameter 'ibmvfc_fpin' description in 'ibmvfc_basic_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3442 function parameter 'wwpn' not described in 'ibmvfc_full_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:5367 function parameter 'protocol' not described in 'ibmvfc_alloc_target'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
