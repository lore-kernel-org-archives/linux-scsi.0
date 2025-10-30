Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C24D23BD17
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761850153; cv=none; b=ec87tf9FVMGUjEy/RecPurFS4ftWDMd1yLgjARQlWKAAc/cHn5XtuB/Rpaixa1rRN+9jQChzwZDV/a2P9GgF6LYR9q1zHyRsDo1uZCaREIiErlMl1VFSzrxeRyGfkCcOthl72J5DRhllr57gdyYcPMtdqJsBEtiGDMH9WlWW36E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761850153; c=relaxed/simple;
	bh=VCuPSyWJoXsUEfwokDYoj/SLJGyu2B621/T8dElvZlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o0kB6Sg6Qpg/9BOXkuEpYLRyBjsltfCV+UPpF/czHmGEaOi64YVxj3Ux5vtxU5+0tA04QA4YnuebT/LzQpqssnNs8sOhmRxvFeL7LWEMxt64T6C9EJ4G0nJNrjeYPbjgnD9AqhmYKmAJq2MsHaC1Wck6lMotwtZnb46okbFGUc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MIPwLir5; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MIPwLir5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761850150; x=1793386150;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VCuPSyWJoXsUEfwokDYoj/SLJGyu2B621/T8dElvZlY=;
  b=MIPwLir5b9CCNvkz3zsVu70MWWkivTPaDultHLB+3WzKQIsg+fkRybuS
   jBN03Fu8fi7Rz0mLwq8YGGPJA/wbHPcGRkMT7XhU1AWrt2QIZMqqkpYoV
   47GKaV0NLBAAC8LlyRsURqAKK/79Aask7VnIDN/UtzmPuUXIVpl7ij8mT
   porQ3eUOk8jU+Z+KLfcxRijwxpAmaCTHDeR1SP5VoWl75T9Z3nHcW0wlp
   PVybF2FOac4Vqn1f2Ucu6IKYN3c/EhPtaWl19XB4Js+pGqJywb6JtavI/
   d0MTSFSmh2sl6orFQTMKYQ89f4iiB/XwT2WgcC6lOCmfVf59qRhzuLSLm
   A==;
X-CSE-ConnectionGUID: LruWD4u2RCOiBHdXnQXFRA==
X-CSE-MsgGUID: DDLJhiGsSlqlQeDToOIAwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="74603267"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="74603267"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 11:49:09 -0700
X-CSE-ConnectionGUID: 6ApZtlUSQLus/E7Ym+HZBQ==
X-CSE-MsgGUID: SMUMd3n/T3ivoE6UBpL9xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="223264628"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 30 Oct 2025 11:49:08 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vEXhl-000MQ4-1G;
	Thu, 30 Oct 2025 18:49:02 +0000
Date: Fri, 31 Oct 2025 02:48:30 +0800
From: kernel test robot <lkp@intel.com>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com, Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: Re: [PATCH v1 1/5] mpt3sas: Added no_turs flag to device unblock
 logic
Message-ID: <202510310216.gerpzbxP-lkp@intel.com>
References: <20251029181058.39157-2-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029181058.39157-2-ranjan.kumar@broadcom.com>

Hi Ranjan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.18-rc3 next-20251030]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ranjan-Kumar/mpt3sas-Added-no_turs-flag-to-device-unblock-logic/20251030-025730
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251029181058.39157-2-ranjan.kumar%40broadcom.com
patch subject: [PATCH v1 1/5] mpt3sas: Added no_turs flag to device unblock logic
config: i386-randconfig-054-20251030 (https://download.01.org/0day-ci/archive/20251031/202510310216.gerpzbxP-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251031/202510310216.gerpzbxP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510310216.gerpzbxP-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/scsi/mpt3sas/mpt3sas_scsih.c:3832 function parameter 'no_turs' not described in '_scsih_ublock_io_all_device'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
