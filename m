Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC07A20DD4B;
	Fri, 13 Jun 2025 14:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749823847; cv=none; b=GSGwAn1t8PNCwb1sfAU0bCulQLAUUhGM6sHxLN39eiOhOmZ86jjfn9ZAGsriSdrhyAMPT+r9Lx2pqF4W8pXGF4UdX4+gfcUO99upG/nnBezfO6CEknA5Gml5dgSHcF1XmhnjZwArweJxBFgo9XWPO+wAS0Zf91GYcaGZEe/42S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749823847; c=relaxed/simple;
	bh=eP/zLTuwOfoP5vAhzw0ClxIdUUHuuKIgpOGHAKnN7mg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KTWV9ELYcGjHnnPKELh0wKHuhFuQQbQl2GpC+4Ort/kidotF83sAywZoFN39AMVZO/+W7Iire53cQP9evqv//kVI7xUHLC2cHlPf9IfluPZOpC3HsY2rilDnz6jI04tZcZ/QKk1E/FU7Al7kXjNsDaG90eRLcZvpidzxJknKqPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EqVBCvPe; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EqVBCvPe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749823846; x=1781359846;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eP/zLTuwOfoP5vAhzw0ClxIdUUHuuKIgpOGHAKnN7mg=;
  b=EqVBCvPe9IvKkNBemVCUc6G33l8AOZuKlz8WEAxxGuo+1rbXNYV+ecaW
   mNgE9rKQf0HluHdllBVHJN7EI0A0wUsJ2ghwUOcWs/CndxFPUgtoqVaPk
   7UJovy9ndgtg2f7NtidHa+M7FNob/bUHbAaOWPFkyRF43L3VNUx6Xl00m
   b+lbmAmBUn55LrrynmRZ7XfZJXcaslCkS3nHfPfJslbP5w6rklYFDKj8W
   AEhSTU/UfyQEjRLaiIU1+Rm3UOKWL5mm9RicnSgq6w9LZRs8Gbu8moQd4
   YZGEmGCbwb3OBbzEcNsKYr0vMebsDIX4lfefqFD7hhdXZ00UjPFiRwlPG
   g==;
X-CSE-ConnectionGUID: U5mxmRVBRQuJejHSgbezBg==
X-CSE-MsgGUID: lxCrfSrGSfuof2iXFevkAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11463"; a="51920488"
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="51920488"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 07:10:45 -0700
X-CSE-ConnectionGUID: aOa8+CR4RdWDgxcLFMnOQg==
X-CSE-MsgGUID: Q2Eg1+bKTHmgIOxNNWBurg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="152993991"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 13 Jun 2025 07:10:42 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uQ57A-000ChG-1q;
	Fri, 13 Jun 2025 14:10:40 +0000
Date: Fri, 13 Jun 2025 22:09:49 +0800
From: kernel test robot <lkp@intel.com>
To: Salomon Dushimirimana <salomondush@google.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Salomon Dushimirimana <salomondush@google.com>
Subject: Re: [PATCH] scsi: pm80xx: add controller scsi host fatal error
 uevents
Message-ID: <202506132133.ML6A1QnK-lkp@intel.com>
References: <20250612212504.512786-1-salomondush@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612212504.512786-1-salomondush@google.com>

Hi Salomon,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.16-rc1 next-20250613]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Salomon-Dushimirimana/scsi-pm80xx-add-controller-scsi-host-fatal-error-uevents/20250613-052945
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250612212504.512786-1-salomondush%40google.com
patch subject: [PATCH] scsi: pm80xx: add controller scsi host fatal error uevents
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20250613/202506132133.ML6A1QnK-lkp@intel.com/config)
compiler: clang version 20.1.2 (https://github.com/llvm/llvm-project 58df0ef89dd64126512e4ee27b4ac3fd8ddf6247)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250613/202506132133.ML6A1QnK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506132133.ML6A1QnK-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/scsi/pm8001/pm80xx_hwi.c:1560 function parameter 'error_reporter' not described in 'pm80xx_fatal_error_uevent_emit'
>> Warning: drivers/scsi/pm8001/pm80xx_hwi.c:1560 Excess function parameter 'error_type' description in 'pm80xx_fatal_error_uevent_emit'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
