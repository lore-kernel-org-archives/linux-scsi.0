Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D134218C3B
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 05:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719464782; cv=none; b=OlfFc8+LFZJgkvOUdBurIyVgQytnYqjf5WBTqAnRuumL3ayIMR8rOwgj+8o8A0oOW1E3t2/pG3YRDy/l+G7DXdeMgNUg14g+T5cac/zMHi4/24LryNc1m5sPqZuwxIA8vud5/6f5TpaXfT8A3IlFLW/V0rC+tAgtU9uULj44xPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719464782; c=relaxed/simple;
	bh=BPsrokCsoYTuLFksoFsNmomVcZpRoUD7LdyKbtsEufU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z3dy4OiZdETuI2AmWwXnnlZmVxK9O7P5bH5+Ss2C6tpxkAdEZVVyj4/rqwcleKV30LfxotTD4CDcNI81L9LoObEQTjDRu3dUGoDk9x7b64rZl9vqTzUjaea1JF8HQZeF519Z8wC0B8x7PkAFEhnTJdSDpERn5fl8ptlXayIDOwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OAPhe1KH; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OAPhe1KH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719464780; x=1751000780;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BPsrokCsoYTuLFksoFsNmomVcZpRoUD7LdyKbtsEufU=;
  b=OAPhe1KHuX1DQbx/LdqUwxdOsYBhToSGFGJB+Jg2UIwukliSPsIpO679
   avziMf0iptwSnuFsBrAuxjyPO2Zmf26Cio6+tWelZntt/z3HFTOkeodqj
   uhjMKTbCBI8f0mPTQGH47rHUdpG672d8NdNfTJbyQnC1w7czLpu7jhE0L
   TNBidPk9Ch+0RYmoyKj/JeZNueMA02BlYZ58gqUJofNFBYRk2hfYuw0DX
   g24yKHXwzuCt1bTXVCI+bDqbulR+o/i6pBHmPn2YkbaT/xkqJZLUDZT17
   Gbp9MH1qYN5kwWtqKC6vAnvt+w2tzJZCtoNFn7WZFBXEvq+xSMufTa5Ak
   A==;
X-CSE-ConnectionGUID: gS1KMlu8SOuYwla1c1mBsQ==
X-CSE-MsgGUID: I5rAcIdzThupVYUUN2vDUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11115"; a="20391194"
X-IronPort-AV: E=Sophos;i="6.08,269,1712646000"; 
   d="scan'208";a="20391194"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 22:06:20 -0700
X-CSE-ConnectionGUID: U9MxD4AHQ/KjvfsKnFBiFA==
X-CSE-MsgGUID: MqLVHRnTQl+JqjirHjGFAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,269,1712646000"; 
   d="scan'208";a="44085927"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 26 Jun 2024 22:06:19 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sMhKr-000Fua-0L;
	Thu, 27 Jun 2024 05:06:17 +0000
Date: Thu, 27 Jun 2024 13:05:48 +0800
From: kernel test robot <lkp@intel.com>
To: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>,
	linux-scsi@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: Re: [PATCH 04/14] scsi: cxlflash: Replaced ternary operation in
 write_same16 with min()
Message-ID: <202406271203.uuqA8eNf-lkp@intel.com>
References: <20240626101342.1440049-5-prabhakar.pujeri@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626101342.1440049-5-prabhakar.pujeri@gmail.com>

Hi Prabhakar,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.10-rc5 next-20240626]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Prabhakar-Pujeri/scsi-advansys-Simplified-memcpy-length-calculation-in-adv_build_req/20240626-231800
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240626101342.1440049-5-prabhakar.pujeri%40gmail.com
patch subject: [PATCH 04/14] scsi: cxlflash: Replaced ternary operation in write_same16 with min()
config: powerpc-powernv_defconfig (https://download.01.org/0day-ci/archive/20240627/202406271203.uuqA8eNf-lkp@intel.com/config)
compiler: powerpc64le-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240627/202406271203.uuqA8eNf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406271203.uuqA8eNf-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/container_of.h:5,
                    from include/linux/kernel.h:22,
                    from include/linux/interrupt.h:6,
                    from drivers/scsi/cxlflash/vlun.c:11:
   drivers/scsi/cxlflash/vlun.c: In function 'write_same16':
>> include/linux/build_bug.h:78:41: error: static assertion failed: "min(ws_limit, left) signedness error, fix types or consider umin() before min_t()"
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
   drivers/scsi/cxlflash/vlun.c:448:36: note: in expansion of macro 'min'
     448 |                 put_unaligned_be32(min(ws_limit, left),
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
