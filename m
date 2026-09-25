Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4437A4734D0;
	Fri, 25 Sep 2026 22:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790375867; cv=none; b=b9Uy81TK0CRELcZtovZKchXKmONxBj1DYv7+cg6MR6u50/P/7BzCm5jZtx7qVkwVZsGDAMwEGrOQ4VgffrFyNgq4d47eg14KLtpMcbMrh5s6um/dH0WJwGlbn/xGPujL9Ra8CFDQ5tj/jcX4p+neaq4brBasgHzRVVyAPbJGObA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790375867; c=relaxed/simple;
	bh=HGj+dKrrXabAcVIQMQnX20XrKEuN4xcjHvuUJi1/Z/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YTsVN0QpcIvmgJe/FKEW7D4F87nyfPQ0xN1zaCx0KhxuHMI2IOVJN75tZLiNmG8FR0u1R8Wu+Sm2Ndqg8U5ukudMOVyMPGOFryJcAM9sF0Ez3wOqs9NUgBl1W+RmxB9JT5vxVKXOyB1UZ1OsG4QN7AId+AlxegkJ+oqRyEoMn6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P2sY71kB; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P2sY71kB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790375866; x=1821911866;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HGj+dKrrXabAcVIQMQnX20XrKEuN4xcjHvuUJi1/Z/Y=;
  b=P2sY71kBsYN9ZhGNln0G+IZh9FA4CDAHqIK+B4CBqH1g1WKQozKYJ6SM
   LVu1PqKdAZ9wEN49md9QOk5/YUA5Yiw8vbvOZZ9hZUTEQQNvc3wA/ULg1
   rmyz+Xz5VL7yp1sJo5na6hSTNa/uFB8y2q4RotdpMiyt96EtYNMWNKDdQ
   aklmuOviL/bOzJOvDTxcyt58ExtN6PjHaqRenPbukMwQGds14xzCptc2v
   dxTp6cVABgMNm+cPOpJMiWUCvOil4mxlIRMUOJ0VthAUR6QWL0lbTm9gX
   L1j9KKySu1tqWi5AUsQigmkCs2DNQSd4JlWEsPqcSXb4egYWULf5AiFM2
   g==;
X-CSE-ConnectionGUID: PLgMWBWJSsOmCCjDfZo21Q==
X-CSE-MsgGUID: yRjMHwaWTxyPPOA3N4VTpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11916"; a="112953933"
X-IronPort-AV: E=Sophos;i="6.27,123,1787036400"; 
   d="scan'208";a="112953933"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 15:37:45 -0700
X-CSE-ConnectionGUID: yCeMFlJ2S5Scl3RxreplAA==
X-CSE-MsgGUID: ilzjYurAQiOCKg7HgJezVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,123,1787036400"; 
   d="scan'208";a="302379387"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 25 Sep 2026 15:37:43 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xAEY0-00000000LHV-11UV;
	Fri, 25 Sep 2026 22:37:40 +0000
Date: Sat, 26 Sep 2026 06:36:40 +0800
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
Message-ID: <202609260636.G8CEOXSF-lkp@intel.com>
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
config: sparc64-randconfig-1001-20260926 (https://download.01.org/0day-ci/archive/20260926/202609260636.G8CEOXSF-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260926/202609260636.G8CEOXSF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609260636.G8CEOXSF-lkp@intel.com/

All errors (new ones prefixed by >>):

   sparc64-linux-ld: drivers/ufs/core/ufs-rpmb.o: in function `ufs_rpmb_init':
>> ufs-rpmb.c:(.init.text+0x0): multiple definition of `init_module'; drivers/ufs/core/ufshcd.o:ufshcd.c:(.init.text+0x0): first defined here
   sparc64-linux-ld: drivers/ufs/core/ufs-rpmb.o: in function `ufs_rpmb_exit':
>> ufs-rpmb.c:(.exit.text+0x0): multiple definition of `cleanup_module'; drivers/ufs/core/ufshcd.o:ufshcd.c:(.exit.text+0x0): first defined here

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
