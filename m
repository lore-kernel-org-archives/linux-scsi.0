Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A33302149
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 09:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765358470; cv=none; b=N8cDtUeIT0KnwkgLDjTnGTOXnA+zhyiCgr0OtIAL10LK0xbJ6y4ruKPsPFFWKsSGP8sX6zwPqQhOo533qi5FrWdOdWSQ5fN2krb1OYQYjtjEXlPMZDCoFvgZgJL8cp+LtcNLodO8/pPNZBs/8LL+WMPquUsKbQX5uP0kqek94tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765358470; c=relaxed/simple;
	bh=LlVy34DVZlnoxK5wDWmUUmCPGryjoJ3ROBm/r4Qr0IY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aLyKBVmGKpOUh/o/XWs4PPUL9hrZyImL+e3+k4R3Dg+o1YvQT9E8/BiC2Ug2CerPwUxGmQvg79hBJSyzpaXRNl8AVy5Xu9dKhIUWp3brM9AABF7j3gJWgOBeMuu+RpC+TerqTEMzGKnT1tDXzdCitJPhpHqkXC2u9V9Y3+oviMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z9lED1kw; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z9lED1kw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765358468; x=1796894468;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LlVy34DVZlnoxK5wDWmUUmCPGryjoJ3ROBm/r4Qr0IY=;
  b=Z9lED1kwN7wuTZw3+aaaT2la0mYpv1bAQDMHgexFtH8dBzwFTreTM6tn
   ynZyWfjXmNPjN4E0A9qL3cX+ACn5INHt8pObPg/7qSgBEKvCqIeVua2O/
   scuIMZwyZ3t3BifG5kLM+DfObZATgYeET49v6eAo2fzKZzpHzLGfBuVyx
   WVbaK6Pp0cSSsOpqH6ftDJPhMGBYBwEtEf4Vl/pRK93pRLdDCmMKDoSk6
   YO6Q3y3nVObPDNfNYT2yQBHdxtXIHFtJPWXBOeD4CwEjIqrLwWcyf/AX5
   cttunEUfWcX78McIrBKsyiFQhq/jLhZBWQ1IJPzOjmvU4f6jxz5bsF5GO
   w==;
X-CSE-ConnectionGUID: oeInzukOSPqw5qN2mH3y2A==
X-CSE-MsgGUID: FAy3zC1+QqaFrc7XqXQU1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="71173930"
X-IronPort-AV: E=Sophos;i="6.20,263,1758610800"; 
   d="scan'208";a="71173930"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 01:21:08 -0800
X-CSE-ConnectionGUID: x1M5MgquT+aH98Fr93DKFw==
X-CSE-MsgGUID: xjxuHDkuRVGpvC+ZBbzJiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,263,1758610800"; 
   d="scan'208";a="195534049"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 10 Dec 2025 01:21:06 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vTGNc-00000000337-0OTu;
	Wed, 10 Dec 2025 09:21:04 +0000
Date: Wed, 10 Dec 2025 17:20:24 +0800
From: kernel test robot <lkp@intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: oe-kbuild-all@lists.linux.dev,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/8] scsi: sd: Convert to scsi bus methods
Message-ID: <202512101723.HHskrJpy-lkp@intel.com>
References: <1931ec5bbe8d0ad82b6fbc77939d43bf5a4f177f.1765312062.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1931ec5bbe8d0ad82b6fbc77939d43bf5a4f177f.1765312062.git.u.kleine-koenig@baylibre.com>

Hi Uwe,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 7d0a66e4bb9081d75c82ec4957c50034cb0ea449]

url:    https://github.com/intel-lab-lkp/linux/commits/Uwe-Kleine-K-nig/scsi-Pass-a-struct-scsi_driver-to-scsi_-un-register_driver/20251210-044843
base:   7d0a66e4bb9081d75c82ec4957c50034cb0ea449
patch link:    https://lore.kernel.org/r/1931ec5bbe8d0ad82b6fbc77939d43bf5a4f177f.1765312062.git.u.kleine-koenig%40baylibre.com
patch subject: [PATCH 4/8] scsi: sd: Convert to scsi bus methods
config: parisc-defconfig (https://download.01.org/0day-ci/archive/20251210/202512101723.HHskrJpy-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251210/202512101723.HHskrJpy-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512101723.HHskrJpy-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/scsi/sd.c:3912 function parameter 'sdp' not described in 'sd_probe'
>> Warning: drivers/scsi/sd.c:4061 function parameter 'sd' not described in 'sd_remove'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
