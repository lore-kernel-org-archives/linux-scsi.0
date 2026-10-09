Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9F83E0255;
	Fri,  9 Oct 2026 05:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791523239; cv=none; b=jb6TLAp+Po3DnOz0FyxPK4qO5+6JV/b6RKRAsf+hu7GlfuLOUqxyk9MJ0Cc2ExRTvcXy9HtxQrxT0pHMEWnk6VoTBz93nrJLz7BDqm++Y3vBir5dLtRkMS8dLGKby0at0O8YF+ZzzDV51lgTbA5Va6ykqdNfD1A14wU0YzXc5Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791523239; c=relaxed/simple;
	bh=WUJ5y7qSeRkwAzEkHoEamlAmEM85Quzp2HqacvciaU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZMIgurCrWYupPO7Pyf0csimGT4ZDMZFIkbhgEIF3K5YBZfbdvReV0sPXVKbIfTK4GpVMrcpsDiMO08bAy7W8L3IQjuvVXkHlrfUEYLWsXiXaAfrnDKfdWz67FKYVZ9IDh20/3YDzQriiRd/Q0Iw2X1OWAoOVInvOU14+5bE9fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XTRRTF8c; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XTRRTF8c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791523237; x=1823059237;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WUJ5y7qSeRkwAzEkHoEamlAmEM85Quzp2HqacvciaU8=;
  b=XTRRTF8cPY8Usw4bN74Qq54j/GfMzzVFkUipZcvtiGIciC7hVaAefQZ5
   osafH9mGiPn9xLFVJWDmbR+w/FDSBxcz+NlSSkn8XkSQhcY6maJlXKVI/
   oumn41TPRFgs6f+tkKDRidLkTMQqnl9UZcURbDCbC3j4uNBORPjGbjycF
   VE4whq8kIRFzEkjMtse1WEvKg4T5rlUGIUkih9rVIkcNQPEAurIw5mleB
   m4S/oKaMVMCyX9HMMdW04xwXhtHuQpzcVfrlsGGDcekUsXvh7mPXAz4hx
   I9Zvp953+r2rbrsgy/NvUURF48qh1zq6G5ztTG+fcm8p2oKoJSBTgT9M1
   g==;
X-CSE-ConnectionGUID: WRyXFtULRIux2h4ui9xNwQ==
X-CSE-MsgGUID: fyV3H4bsRL+olOWFYuurtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="191513"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="191513"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 22:20:36 -0700
X-CSE-ConnectionGUID: L1kiEqFiQb6nAV9QQyROiQ==
X-CSE-MsgGUID: /HmoO0+yTXuFpqzCVn9QOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="171261"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 08 Oct 2026 22:20:33 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xF31y-000000005Lq-1yYo;
	Fri, 09 Oct 2026 05:20:30 +0000
Date: Fri, 9 Oct 2026 13:20:05 +0800
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
Subject: Re: [PATCH v13 04/11] scsi: ibmvfc: add basic FPIN support
Message-ID: <202610091350.pfimX8kZ-lkp@intel.com>
References: <20261007-ibmvfc-fpin-support-v13-4-b816abfa4fcc@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007-ibmvfc-fpin-support-v13-4-b816abfa4fcc@linux.ibm.com>

Hi Dave,

kernel test robot noticed the following build warnings:

[auto build test WARNING on c3cff7fac01638ab58e85fe7df41a04fa25c5bae]

url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Marquardt-via-B4-Relay/scsi-ibmvfc-fix-IRQ-leak-and-guard-deregister-on-channel-reg-failure/20261007-142545
base:   c3cff7fac01638ab58e85fe7df41a04fa25c5bae
patch link:    https://lore.kernel.org/r/20261007-ibmvfc-fpin-support-v13-4-b816abfa4fcc%40linux.ibm.com
patch subject: [PATCH v13 04/11] scsi: ibmvfc: add basic FPIN support
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20261009/202610091350.pfimX8kZ-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261009/202610091350.pfimX8kZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610091350.pfimX8kZ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:1905 expecting prototype for ibmvfc_relogin(). Prototype was for ibmvfc_scsi_relogin() instead
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'fpin_status' not described in 'ibmvfc_common_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'wwpn' not described in 'ibmvfc_common_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'type' not described in 'ibmvfc_common_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'modifier' not described in 'ibmvfc_common_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'threshold' not described in 'ibmvfc_common_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'event_count' not described in 'ibmvfc_common_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3401 function parameter 'crq' not described in 'ibmvfc_basic_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3401 function parameter 'wwpn' not described in 'ibmvfc_basic_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3401 Excess function parameter 'ibmvfc_fpin' description in 'ibmvfc_basic_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:5258 function parameter 'protocol' not described in 'ibmvfc_alloc_target'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'fpin_status' not described in 'ibmvfc_common_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'wwpn' not described in 'ibmvfc_common_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'type' not described in 'ibmvfc_common_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'modifier' not described in 'ibmvfc_common_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'threshold' not described in 'ibmvfc_common_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'event_count' not described in 'ibmvfc_common_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3401 function parameter 'crq' not described in 'ibmvfc_basic_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3401 function parameter 'wwpn' not described in 'ibmvfc_basic_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3401 Excess function parameter 'ibmvfc_fpin' description in 'ibmvfc_basic_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:5258 function parameter 'protocol' not described in 'ibmvfc_alloc_target'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
