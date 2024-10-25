Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A285D1F9EA1;
	Fri, 25 Oct 2024 10:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729853883; cv=none; b=eLG5EALffGeCmeJjAnY10XWJXegx/8Z0WgOziYAB2mcyPM0TXM33HE3Mt3B2x5wKKidujX3hkkhSMvZ0prk8yEaztjWXwrWxsO9Fw1LPgxQrSakfXJDlZE0tP5anHq+7FSv4ioLYxyQ2mr8Ep9LdSgN78zMNZJi4GXqB0Whq/ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729853883; c=relaxed/simple;
	bh=xTif9zXtj8kg3yrLdzPkrKtdNWdx3OH4AUggyPOXCPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M0bKFlofVx2f2CGjTfiIwxN0MxpleNcG5yqHfx3xhymnl1sx/H7pr5ggU0bCcHJsYAErKEPKoKM+AeAOTbnH1gCPvuonaHQq1dOvfqIlx8dRF9coets0HimfxAL/sLjeKSBJt1JjoDcF5KaWKLTJr9oALgNRKEBb/y2mYO3FqXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SxDyj2U7; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SxDyj2U7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729853881; x=1761389881;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xTif9zXtj8kg3yrLdzPkrKtdNWdx3OH4AUggyPOXCPg=;
  b=SxDyj2U72fhyYOKef7llNvQzVLGIPgdJYm1l8+LtpGDVMPUeta14FATW
   6wIl/Kf/ZDx+Lr8cpA9Dep1tMbIXIxReeAOrQJEM/O5d6rLorhf6t/79Y
   ISuZWkdoCmA1j0SoVraa4DmHv4pLRO53AuI6CqlcA4uTp+WniEbA9F+hm
   tnuaGqwPPR23FpycbKlrs4xzVOxz/yV9DwtdA5odg+uAPRUukPA1zsO5p
   GQKmn9sCkeUEvd+4GQZNks8evSNq9N7A33VG/vV6dinDHkr7NL15bkCil
   pPLC6dg341QisW+VsZjs+ZRROS9VXl754alSRIe3FjKNXJpKpo9DJPN53
   g==;
X-CSE-ConnectionGUID: CYBPRE5FTEOIhkf5/xIpCA==
X-CSE-MsgGUID: mvBmlHLRREi2EdmXQ5tZug==
X-IronPort-AV: E=McAfee;i="6700,10204,11235"; a="17150163"
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="17150163"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2024 03:58:00 -0700
X-CSE-ConnectionGUID: bZSMsShPRSiqtrdmRk1ajw==
X-CSE-MsgGUID: bSO0aXD0SeypwIp4stBfkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="80805006"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 25 Oct 2024 03:57:57 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t4I0x-000Y4q-1M;
	Fri, 25 Oct 2024 10:57:55 +0000
Date: Fri, 25 Oct 2024 18:57:19 +0800
From: kernel test robot <lkp@intel.com>
To: Mirsad Todorovac <mtodorovac69@gmail.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v1 1/1] scsi: gla2xxx: use flexible array member at the
 end of structures
Message-ID: <202410251849.4PlXq31z-lkp@intel.com>
References: <20241023221700.220063-2-mtodorovac69@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023221700.220063-2-mtodorovac69@gmail.com>

Hi Mirsad,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.12-rc4 next-20241025]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mirsad-Todorovac/scsi-gla2xxx-use-flexible-array-member-at-the-end-of-structures/20241024-062120
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241023221700.220063-2-mtodorovac69%40gmail.com
patch subject: [PATCH v1 1/1] scsi: gla2xxx: use flexible array member at the end of structures
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20241025/202410251849.4PlXq31z-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241025/202410251849.4PlXq31z-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410251849.4PlXq31z-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   drivers/scsi/qla2xxx/qla_os.c: In function 'qla2x00_module_init':
>> include/linux/compiler_types.h:517:45: error: call to '__compiletime_assert_833' declared with attribute error: BUILD_BUG_ON failed: sizeof(struct qla2300_fw_dump) != 136100
     517 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:498:25: note: in definition of macro '__compiletime_assert'
     498 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:517:9: note: in expansion of macro '_compiletime_assert'
     517 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_os.c:8220:9: note: in expansion of macro 'BUILD_BUG_ON'
    8220 |         BUILD_BUG_ON(sizeof(struct qla2300_fw_dump) != 136100);
         |         ^~~~~~~~~~~~


vim +/__compiletime_assert_833 +517 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  503  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  504  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  505  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  506  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  507  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  508   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  509   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  510   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  511   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  512   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  513   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  514   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  515   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  516  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @517  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  518  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
