Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8859A26E71E;
	Wed,  5 Aug 2026 03:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785901677; cv=none; b=O5zIrcwg5kHzYVzfgkWiX0ZbPlWZN/gvxyu/ITcuXfl3U3vUpmq6ZeGsuZuQOWsy1CWbKFfHeml/fGC3KlH1/oWNcCn9dnFt0qfoYNSHF9E5+SffBXmSxKuBG0WAztVapVRxibNEhLlhZgJ0nBPrewekylJEukdiMD+kgcx5c3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785901677; c=relaxed/simple;
	bh=N/WIjZULUy5g1oD2a2MYPgsB9BRlcfzXlQKfbjVl0Yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8H7Qfbaw/yfTyh6eq4y8EondSp89xYSuop2VPquI5z+NdX3eHrwiJpGbeeI5UqyizCURa8qlwqwSXsrC8M5u2SpCnzzIhAB14kSelWS+ro3dncRMoGwKvWcd9cGxgeplwoOizfvybK3TNFCuNCE7gG5pr2+jQgcb60VsCZGVCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AbfzPmu3; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AbfzPmu3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785901675; x=1817437675;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N/WIjZULUy5g1oD2a2MYPgsB9BRlcfzXlQKfbjVl0Yg=;
  b=AbfzPmu3CRAsqfYXNUOISjCKEHjynMVhXcr4k6/XtpZHaZh9LeBt3aZU
   HbILV/P0SQpm3n9kp2HWyBctcOhxKAPTWgXj2OHJnIRBhuRCsYyBbMFd8
   I1/nPF1G+hOwYNMa7c+KeQQV99hTUBC9fMOaaG8FbkZomArTlZApFise9
   3LI8t+ssyRkUZMcYCzY9b4oaX6Fc/6yKeKKSURfmqNMmeZ+XbWpyXVe20
   bH5dcLIGMTyJlHrgS5nVr0BeMZpPoy0eHchZiDW+gBdPbotxEX48H4mdb
   M57tV/FJRCxUTrhH/k/aWbaWyDCfdiwAbWuZdP/ymB7HlMqohUHBplmUa
   A==;
X-CSE-ConnectionGUID: JLuPtgsuQWG12eW3E7Xk5Q==
X-CSE-MsgGUID: kjOlOFUnTF2mlJuy4liL/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="97113935"
X-IronPort-AV: E=Sophos;i="6.25,205,1779174000"; 
   d="scan'208";a="97113935"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2026 20:47:52 -0700
X-CSE-ConnectionGUID: 9UjFi83iSaOm1DSHm2cNoQ==
X-CSE-MsgGUID: NEHLd9UJSByesGr9SRgAAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,205,1779174000"; 
   d="scan'208";a="259042503"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 04 Aug 2026 20:47:51 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wrSbc-00000000BRF-1MJi;
	Wed, 05 Aug 2026 03:47:48 +0000
Date: Wed, 5 Aug 2026 11:47:29 +0800
From: kernel test robot <lkp@intel.com>
To: kensanya@163.com, martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, TanZheng <tanzheng@kylinos.cn>
Subject: Re: [PATCH] target/stat: implement scsiPortBusyStatuses counter
Message-ID: <202608051155.lyM6hfgB-lkp@intel.com>
References: <20260708093433.838647-1-kensanya@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708093433.838647-1-kensanya@163.com>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on linus/master v7.2-rc6 next-20260804]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/kensanya-163-com/target-stat-implement-scsiPortBusyStatuses-counter/20260805-032126
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260708093433.838647-1-kensanya%40163.com
patch subject: [PATCH] target/stat: implement scsiPortBusyStatuses counter
config: s390-randconfig-001-20260805 (https://download.01.org/0day-ci/archive/20260805/202608051155.lyM6hfgB-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260805/202608051155.lyM6hfgB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608051155.lyM6hfgB-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/target/target_core_stat.c: Assembler messages:
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
>> drivers/target/target_core_stat.c:49: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'
   drivers/target/target_core_stat.c:54: Warning: missing closing `"'


vim +49 drivers/target/target_core_stat.c

12d233842987d9 Nicholas Bellinger 2011-03-14 @49  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
