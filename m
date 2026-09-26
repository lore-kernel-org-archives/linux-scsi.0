Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84387288C2D;
	Sat, 26 Sep 2026 01:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790387423; cv=none; b=G2zFuK1ZjFTMY7FCSE2G1/DF64Z5ZhdDXpDaLmPoSuz1QpFZW2zAYQbSV5WIlfuQy9x7UnBixkHEfNajyX9ze7qJBbvFg0gL1vfAQOjLwFuhwZm/9KeRcfDzZTuXPW5MfNI6rso9lCHih7ffkw0DWnbNj4/SvGShaFHJu+DykoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790387423; c=relaxed/simple;
	bh=gvlAMryz1WLaIdzCvIYBahSgwylu41M6JAq44ILGcJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HD8wRfcOkHeYyKjMrl8NT5DAaeDQ7qCI6PgZJFITcMGd43r+IfGmkVjNGJJW3TZS+4PJMUzkFbYlcnz/ppC7+DpLGjt5Vzt52CmeNvR85WXjU6PETFA9sz755nMpeHMQWBiPEJ+UWHYKCHN2JppvTGs1JBnK1EhEAC4gA02fvC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W+CZuW+o; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W+CZuW+o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790387421; x=1821923421;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gvlAMryz1WLaIdzCvIYBahSgwylu41M6JAq44ILGcJM=;
  b=W+CZuW+ooGS9IlaGcfbPL77CKHkTGNYMyCtTBiKzVtAfBSYXUmMVQTjH
   TVkMDnxGNY/ur68cGR7mYay8820e17kxl8OiZuAJYcf3aqhZnQ40pKVRp
   7UTcmKu/c1eZ4hDGHGGUUTdizJpbvGUGt4pKxzY+0Eijbp+Ijx4j2Gnp3
   0JlkT+rxAMpoPMcy2q+7l/hB+bCJz7h9eYagJw1eHLw8W+TIiM0CPC37I
   73H38U+jnvmXTidHvypjIFpKlfYlvCeoMf9+rUu2orNzVKXhUjaWix8eM
   XwE0DA1S5TdxcY5aIxdWi6ddXrMSMYuF40dgB3KsudlQMO48XX57JWLgC
   g==;
X-CSE-ConnectionGUID: MglgMDdvR2ewoMCjNSAXmQ==
X-CSE-MsgGUID: HewxSX91SBS31UvmyePn5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11916"; a="102541840"
X-IronPort-AV: E=Sophos;i="6.27,123,1787036400"; 
   d="scan'208";a="102541840"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 18:50:20 -0700
X-CSE-ConnectionGUID: X3qFXGIDQuGf03P7+LteNg==
X-CSE-MsgGUID: /hzAtJMeT7CGXtiLpgUxpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,123,1787036400"; 
   d="scan'208";a="272636984"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 25 Sep 2026 18:50:17 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xAHYM-00000000LRJ-2CH3;
	Sat, 26 Sep 2026 01:50:14 +0000
Date: Sat, 26 Sep 2026 09:49:36 +0800
From: kernel test robot <lkp@intel.com>
To: Dmitry Baryshkov <lumag@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Can Guo <can.guo@oss.qualcomm.com>, Bean Huo <beanhuo@micron.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: rpmb: register and unregister the ufs_rpmb bus
Message-ID: <202609260913.FY1vuM99-lkp@intel.com>
References: <20260920-fix-ufs-rpmb-v1-1-560b842c589d@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920-fix-ufs-rpmb-v1-1-560b842c589d@oss.qualcomm.com>

Hi Dmitry,

kernel test robot noticed the following build errors:

[auto build test ERROR on 3f2425f5b5bbbdd991ca9cdfd5502e68d8895998]

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Baryshkov/scsi-ufs-rpmb-register-and-unregister-the-ufs_rpmb-bus/20260920-175018
base:   3f2425f5b5bbbdd991ca9cdfd5502e68d8895998
patch link:    https://lore.kernel.org/r/20260920-fix-ufs-rpmb-v1-1-560b842c589d%40oss.qualcomm.com
patch subject: [PATCH] scsi: ufs: rpmb: register and unregister the ufs_rpmb bus
config: arc-randconfig-1001-20260926 (https://download.01.org/0day-ci/archive/20260926/202609260913.FY1vuM99-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260926/202609260913.FY1vuM99-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609260913.FY1vuM99-lkp@intel.com/

All errors (new ones prefixed by >>):

   arc-linux-ld: drivers/ufs/core/ufs-rpmb.o: in function `ufs_rpmb_init':
>> drivers/ufs/core/ufs-rpmb.c:280: multiple definition of `init_module'; drivers/ufs/core/ufshcd.o:drivers/ufs/core/ufshcd.c:11609: first defined here
   arc-linux-ld: drivers/ufs/core/ufs-rpmb.o: in function `ufs_rpmb_exit':
>> drivers/ufs/core/ufs-rpmb.c:285: multiple definition of `cleanup_module'; drivers/ufs/core/ufshcd.o:drivers/ufs/core/ufshcd.c:11623: first defined here


vim +280 drivers/ufs/core/ufs-rpmb.c

   277	
   278	static int __init ufs_rpmb_init(void)
   279	{
 > 280		return bus_register(&ufs_rpmb_bus_type);
   281	}
   282	
   283	static void __exit ufs_rpmb_exit(void)
   284	{
 > 285		bus_unregister(&ufs_rpmb_bus_type);
   286	}
   287	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
