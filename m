Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFC07DA9C;
	Thu, 12 Sep 2024 02:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726109913; cv=none; b=WVh9/TIKZ/6hOiO/+JLiUx/77zj/UVH8My7gAQ/PJGv2H2RJKGs8U841JciYQvPyBMnT3i12UjWyJjVsxWYo8bBzqdFXiX5bn6bXx7Q2gDD+Rcwh2sYTd9gvMZEPRoXH2SjVVGqu5YNwi8e2TPctu1pDU4IEgCYMLRtkyIdtqYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726109913; c=relaxed/simple;
	bh=4pKmHcSPb4q0CgxjlBXTua6+JlNlQQEApnOkulyQNEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MhiGOsox7YrDve2Nky7qOD5M7pWRp0Xfri8K02vpeOFBPR4pLt5CY6ZtcM/iYRsDZrr6FpjVh21RBBqy5FENs/bQLbFTc3oV9z9lf3OtBukICNyNtbJdlwjzRBBrx07bsTi1BJxoeCNuIs+vzEjgEKgeuDyxclrdFNUznwg79Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iokk/ozQ; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iokk/ozQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726109910; x=1757645910;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4pKmHcSPb4q0CgxjlBXTua6+JlNlQQEApnOkulyQNEQ=;
  b=Iokk/ozQBe0sYH8XKepIoNzECjPw/KCqgdhg7lU845ApNZrvZZ4K4J4v
   enVSPJo6I+R9IOUcftU5MYEe5iDu3FHk5x0TNqFSE10ZvE999PFeBxwy+
   qFzZjsi3vOteLmm6mL7rfzQhCyGSesBQ939S6z1AFwmFvRhOfsV8zkT0C
   RqG5IQ+m8wEtx9FR4cW5lbdkcvCfGuvV+mFSzPg7Yekgtfp0KStxiNLi5
   qgYg+1/7o8cBHgq9+TpqHB8mXPtueenbnp4wQtLqLrIKBBdp54TyFiVgP
   NOV1L4/xya3JSrxBDcxB4FEGcSK8ICUebbMHLlK0srPZIYZS3QW+8G7m9
   Q==;
X-CSE-ConnectionGUID: XnewuDC3ROCb14H9LmML3A==
X-CSE-MsgGUID: i/TvcZaARXKTCTbeX6xD2Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="27860136"
X-IronPort-AV: E=Sophos;i="6.10,221,1719903600"; 
   d="scan'208";a="27860136"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 19:58:28 -0700
X-CSE-ConnectionGUID: t6CqJGmhQxO0E1RqdC+Dlg==
X-CSE-MsgGUID: 80MknMOrR1CvdDD1np4JQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,221,1719903600"; 
   d="scan'208";a="67554007"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 11 Sep 2024 19:58:27 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1soa2L-0004QA-0m;
	Thu, 12 Sep 2024 02:58:25 +0000
Date: Thu, 12 Sep 2024 10:58:17 +0800
From: kernel test robot <lkp@intel.com>
To: Avri Altman <avri.altman@wdc.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
Message-ID: <202409121041.ZoEfIT5S-lkp@intel.com>
References: <20240911053951.4032533-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911053951.4032533-1-avri.altman@wdc.com>

Hi Avri,

kernel test robot noticed the following build errors:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on jejb-scsi/for-next linus/master v6.11-rc7 next-20240911]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Avri-Altman/scsi-ufs-Zero-utp_upiu_req-at-the-beginning-of-each-command/20240911-134349
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240911053951.4032533-1-avri.altman%40wdc.com
patch subject: [PATCH] scsi: ufs: Zero utp_upiu_req at the beginning of each command
config: x86_64-buildonly-randconfig-004-20240912 (https://download.01.org/0day-ci/archive/20240912/202409121041.ZoEfIT5S-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240912/202409121041.ZoEfIT5S-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409121041.ZoEfIT5S-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <built-in>:1:
>> ./usr/include/scsi/scsi_bsg_ufs.h:165:2: error: type name requires a specifier or qualifier
     165 |         struct_group(utp_upiu,
         |         ^
>> ./usr/include/scsi/scsi_bsg_ufs.h:166:3: error: expected identifier
     166 |                 union {
         |                 ^
>> ./usr/include/scsi/scsi_bsg_ufs.h:170:4: error: unexpected ';' before ')'
     170 |                 };
         |                  ^
   3 errors generated.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
