Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41832171B6
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 04:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719462112; cv=none; b=G2NJp/W+/Tj6YJhIYPdLF3eBmLKLfpphavLFg+1ym+yGtEH3IiO9vZzocSdt0WFsjbHxfjQAE25Ajdh8x4K4vZupAehJw3FJUIvqrmp6bftaxJqdsUYYi/A+6Thv71H2xk+tDyU055cIBFBLgrG6O8ZWh4AKLfI7F6M+MMZO4Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719462112; c=relaxed/simple;
	bh=5UegQqWQsCrlAFZT2NeTlWfU49EK6/ZeYOTRJo3viL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VDcAP/eb4JQfbY4wBWj+1yvgcZvfF0Q+RFi4dORcSRx/fRSquRpTj78KYl/+bhU1zR1H40CKczrs7jKHD4Z+mfeOJR9Afnp6Zwmr9RcZoMEkGJw2aHB1mJNxGBrGg70dkOA3u78djeug7IptDTu70dvib/JyxTKdxhg1nkNEedk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EPwY/0nF; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EPwY/0nF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719462111; x=1750998111;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5UegQqWQsCrlAFZT2NeTlWfU49EK6/ZeYOTRJo3viL0=;
  b=EPwY/0nF28UEDuhNFNrldzPCzW4U6iE1+HJ1WJOLh5wJhGtMq+mXCEjU
   qBbsvC7z8TqevVJyD/Svc5mfiFHHtZS8oiR2mp9JlZUnm7O2KQsTYjA0k
   ACA/6i/nadcgCstu5OT9mZhhrK5/CtV4nkQtsewiYO7b+2U+ePqBHX6yy
   72MV7I3D8cUKSRk6l76Lnm4/rWftrcNDjcSsAR7ruXBHXHbd9MTQs54N0
   0hG6VWiLYMCSjXVPONWtrakcaRJK3XMnSvRaIMX2kr3idNqewiqd8Wim1
   +gBYOO3tXTR6wPgJv5Ltkcd8FOTnRdfScX2Bbd24ECfyAp+d45xn2lhpk
   w==;
X-CSE-ConnectionGUID: s9+61gcWSnq9tCan4WPo6w==
X-CSE-MsgGUID: Gk04pi1+R+6Rj7NO2LGZfQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11115"; a="19456522"
X-IronPort-AV: E=Sophos;i="6.08,269,1712646000"; 
   d="scan'208";a="19456522"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 21:21:50 -0700
X-CSE-ConnectionGUID: 3f6O4e0xRcqxP/Fdxfs1Ww==
X-CSE-MsgGUID: CbtD1KXbS0mjvkCjDEReyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,269,1712646000"; 
   d="scan'208";a="49406920"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 26 Jun 2024 21:21:49 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sMgdm-000Fsc-28;
	Thu, 27 Jun 2024 04:21:46 +0000
Date: Thu, 27 Jun 2024 12:21:03 +0800
From: kernel test robot <lkp@intel.com>
To: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>,
	linux-scsi@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: Re: [PATCH 14/14] scsi: st: Used max() for buffer size in
 setup_buffering and Simplified transfer calculations in st_read,
 append_to_buffer, and from_buffer
Message-ID: <202406271136.iI4L3oPV-lkp@intel.com>
References: <20240626101342.1440049-15-prabhakar.pujeri@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626101342.1440049-15-prabhakar.pujeri@gmail.com>

Hi Prabhakar,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.10-rc5 next-20240626]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Prabhakar-Pujeri/scsi-advansys-Simplified-memcpy-length-calculation-in-adv_build_req/20240626-231800
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240626101342.1440049-15-prabhakar.pujeri%40gmail.com
patch subject: [PATCH 14/14] scsi: st: Used max() for buffer size in setup_buffering and Simplified transfer calculations in st_read, append_to_buffer, and from_buffer
config: arm-randconfig-001-20240627 (https://download.01.org/0day-ci/archive/20240627/202406271136.iI4L3oPV-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240627/202406271136.iI4L3oPV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406271136.iI4L3oPV-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/module.h:12,
                    from drivers/scsi/st.c:23:
   drivers/scsi/st.c: In function 'st_read':
>> include/linux/build_bug.h:78:41: error: static assertion failed: "min(STbp->buffer_bytes, count - total) signedness error, fix types or consider umin() before min_t()"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/minmax.h:51:9: note: in expansion of macro 'static_assert'
      51 |         static_assert(__types_ok(x, y),                 \
         |         ^~~~~~~~~~~~~
   include/linux/minmax.h:58:17: note: in expansion of macro '__cmp_once'
      58 |                 __cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y)))
         |                 ^~~~~~~~~~
   include/linux/minmax.h:85:25: note: in expansion of macro '__careful_cmp'
      85 | #define min(x, y)       __careful_cmp(min, x, y)
         |                         ^~~~~~~~~~~~~
   drivers/scsi/st.c:2189:36: note: in expansion of macro 'min'
    2189 |                         transfer = min(STbp->buffer_bytes, count - total);
         |                                    ^~~


vim +78 include/linux/build_bug.h

bc6245e5efd70c Ian Abbott       2017-07-10  60  
6bab69c65013be Rasmus Villemoes 2019-03-07  61  /**
6bab69c65013be Rasmus Villemoes 2019-03-07  62   * static_assert - check integer constant expression at build time
6bab69c65013be Rasmus Villemoes 2019-03-07  63   *
6bab69c65013be Rasmus Villemoes 2019-03-07  64   * static_assert() is a wrapper for the C11 _Static_assert, with a
6bab69c65013be Rasmus Villemoes 2019-03-07  65   * little macro magic to make the message optional (defaulting to the
6bab69c65013be Rasmus Villemoes 2019-03-07  66   * stringification of the tested expression).
6bab69c65013be Rasmus Villemoes 2019-03-07  67   *
6bab69c65013be Rasmus Villemoes 2019-03-07  68   * Contrary to BUILD_BUG_ON(), static_assert() can be used at global
6bab69c65013be Rasmus Villemoes 2019-03-07  69   * scope, but requires the expression to be an integer constant
6bab69c65013be Rasmus Villemoes 2019-03-07  70   * expression (i.e., it is not enough that __builtin_constant_p() is
6bab69c65013be Rasmus Villemoes 2019-03-07  71   * true for expr).
6bab69c65013be Rasmus Villemoes 2019-03-07  72   *
6bab69c65013be Rasmus Villemoes 2019-03-07  73   * Also note that BUILD_BUG_ON() fails the build if the condition is
6bab69c65013be Rasmus Villemoes 2019-03-07  74   * true, while static_assert() fails the build if the expression is
6bab69c65013be Rasmus Villemoes 2019-03-07  75   * false.
6bab69c65013be Rasmus Villemoes 2019-03-07  76   */
6bab69c65013be Rasmus Villemoes 2019-03-07  77  #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
6bab69c65013be Rasmus Villemoes 2019-03-07 @78  #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
6bab69c65013be Rasmus Villemoes 2019-03-07  79  
07a368b3f55a79 Maxim Levitsky   2022-10-25  80  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
