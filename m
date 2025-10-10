Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBC62561A7;
	Fri, 10 Oct 2025 15:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760111581; cv=none; b=G05LLOfz/+yPGybV0YKJjoyZ6xo4zVlYqNMbtbejK9jWIUQTu+8n1yNyEGgcShlt3xrxUloMFsy6Nid50nQw8yKdG0tcUU9+rwcNRTQw6cjVnyKZljB5lqO/bE9sEGEo/eY1jZ3VVGgD4z5JjkEIkMlWf7bN/JNFO+tK5nNjyy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760111581; c=relaxed/simple;
	bh=bmLy073nPbVMhndhj/eanakmMRASnKS5w4Glykb/caE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hNbbyTKYgZ7obwA44g02aR9bOGv7hjTBBhOu/Ugl1Rv08PaHl5EkXoF//8hlwMBCGijiqVubR13nwB1g+byZX7xAy6EL848Ark5LbcFno7GJ/H6D7I/54GmnkqqEz1YUTJktXLxGkfcPU14wKuDyJcLCH9CbFfN8aH1/HLnbukU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mtktIV8A; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mtktIV8A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760111579; x=1791647579;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bmLy073nPbVMhndhj/eanakmMRASnKS5w4Glykb/caE=;
  b=mtktIV8A/BhydcZHtVdRPhbJ1BY/D9izzbRgVFnA44mHvQZKmVF1vRV0
   zuxlZ8TkFTgTfjvC3LvUwQHHhVuro3bUaSbqEpkhDinvBfVekJH+XjasW
   C5Wnj8kIsjaf1UIzt66K5MRIxVa4fXc7DYMMmBc9xky39XBNuh85EiZJj
   bdyZmwhaUHeApS8CXygZ7Q0pMv9T2vkY03WDavoe5NeYwiymX5wbtBlwv
   eOkYtFuZx2z+3Qai2iPEu2lrZJKK6A+L9Q+nazvCgZ4c/z9OKNykX/dg/
   wsGyZDJrn/RzzSpcO3shYDupDb+IP5efW35Yb10SayDhC4uJhEuPAXFXW
   A==;
X-CSE-ConnectionGUID: YJGl8V64SI6QrflGpczaIg==
X-CSE-MsgGUID: AiIr86EaT2OITn7vfaK/IQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11578"; a="65986443"
X-IronPort-AV: E=Sophos;i="6.19,219,1754982000"; 
   d="scan'208";a="65986443"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 08:52:58 -0700
X-CSE-ConnectionGUID: LBHphJwtT5azFcq7AB4Gnw==
X-CSE-MsgGUID: v7V31KnmT7+3m+qR8Fg9qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,219,1754982000"; 
   d="scan'208";a="186143529"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 10 Oct 2025 08:52:55 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7FQL-0002vX-1U;
	Fri, 10 Oct 2025 15:52:53 +0000
Date: Fri, 10 Oct 2025 23:52:51 +0800
From: kernel test robot <lkp@intel.com>
To: Markus Probst <markus.probst@posteo.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Markus Probst <markus.probst@posteo.de>
Subject: Re: [PATCH v2 2/2] ata: Use ACPI methods to power on ata ports
Message-ID: <202510102322.yF4HEkAc-lkp@intel.com>
References: <20251009112433.108643-3-markus.probst@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009112433.108643-3-markus.probst@posteo.de>

Hi Markus,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.17 next-20251009]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Markus-Probst/scsi-sd-Add-manage_restart-device-attribute-to-scsi_disk/20251010-111134
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251009112433.108643-3-markus.probst%40posteo.de
patch subject: [PATCH v2 2/2] ata: Use ACPI methods to power on ata ports
config: x86_64-randconfig-071-20251010 (https://download.01.org/0day-ci/archive/20251010/202510102322.yF4HEkAc-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251010/202510102322.yF4HEkAc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510102322.yF4HEkAc-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/ata/libata-acpi.c:277 function parameter 'enable' not described in 'ata_acpi_port_set_power_state'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
