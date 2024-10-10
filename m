Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7D21D432A;
	Thu, 10 Oct 2024 14:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728572312; cv=none; b=VFa0msGb4im2DYFhItY5IqeU5VQt3pGpcn4YvZ1Cx1X6StemTAgOXheL+BJGXn1Pwj87NM1YBdkI9t+5wAVcH/hmMaua4tlBKibkrFGSj7mWwdp7DQxyEkoDmcoNNOamKjeYYVDZEEg6sS3LtSs+Fv5jIxzr5pyTvJhwAboWB4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728572312; c=relaxed/simple;
	bh=1kOWkynVp4rK5gUY/zt1gcriNQSJjm+QKCLYZq7uQsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l7qrSvmAMJw1pX0+hwFFpWeb6AfsgFP63vdHcJ2sqB/fSTv0KBm3UDPTw2kms/nVjiB7kSFX04lZCesNp5Q/JDUced+4GeUIkMwLVqNUfhUUuVyjCK+djPipE+LC6hIlJgcUYHitn4jRzHQQN9R6F4DRf50WRv1qIYlNXv77f0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TsmPr2m6; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TsmPr2m6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728572310; x=1760108310;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1kOWkynVp4rK5gUY/zt1gcriNQSJjm+QKCLYZq7uQsI=;
  b=TsmPr2m6fagbTS4N66LA58LCk4jDTCketKQ5MAFEMQfXNYjLjHgTDDIt
   2oyzQ3gXzPKganxWb7Iej+Tmxpnn+CzmwVB1J9VW8+P4+yIw/IS5oEZs5
   jXPAN47x2JGIPqBBkCJESWF8W6fcPachOxyEfAgu2ofugytwrii9eyJEO
   Lz1Uzb47Z48xyYQzJ3bFe02ymm0P/xvIiR58BKYmGCG8qMQJxVBfn+LMV
   0AGIzMgF6FsXBdUID8NjiM8fZjJXJp6+GHQHrzhtdRLzs1GKI/SVPbpBA
   akpXbgueW4ypCZ8aBlX3UkFAPtt56pM3Cso4+qbXIeNRmWV2n7KiHQSuK
   A==;
X-CSE-ConnectionGUID: kG10qj/3TtqDW15ob5LtPg==
X-CSE-MsgGUID: c98afSp9SIiDv5AGzokkTQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11220"; a="27828676"
X-IronPort-AV: E=Sophos;i="6.11,193,1725346800"; 
   d="scan'208";a="27828676"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 07:58:20 -0700
X-CSE-ConnectionGUID: HCGVbAjDTLC/6a7OesI7qA==
X-CSE-MsgGUID: xojyvDq3SrKCNO7YMFsKew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,193,1725346800"; 
   d="scan'208";a="107337880"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 10 Oct 2024 07:58:15 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1syucH-000Asl-2J;
	Thu, 10 Oct 2024 14:58:13 +0000
Date: Thu, 10 Oct 2024 22:57:58 +0800
From: kernel test robot <lkp@intel.com>
To: Anastasia Kovaleva <a.kovaleva@yadro.com>, target-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	bvanassche@acm.org, quinn.tran@cavium.com,
	himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux@yadro.com, hare@suse.de,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] scsi: qla2xxx: Drop starvation counter on success
Message-ID: <202410102244.4WCXxyGQ-lkp@intel.com>
References: <20241009111654.4697-2-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009111654.4697-2-a.kovaleva@yadro.com>

Hi Anastasia,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.12-rc2 next-20241010]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anastasia-Kovaleva/scsi-qla2xxx-Drop-starvation-counter-on-success/20241009-192031
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241009111654.4697-2-a.kovaleva%40yadro.com
patch subject: [PATCH v2 1/3] scsi: qla2xxx: Drop starvation counter on success
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20241010/202410102244.4WCXxyGQ-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241010/202410102244.4WCXxyGQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410102244.4WCXxyGQ-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/alpha/include/asm/rwonce.h:33,
                    from include/linux/compiler.h:317,
                    from include/linux/build_bug.h:5,
                    from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/module.h:12,
                    from drivers/scsi/qla2xxx/qla_target.c:17:
   drivers/scsi/qla2xxx/qla_target.c: In function 'qlt_24xx_process_atio_queue':
>> include/asm-generic/rwonce.h:55:32: error: lvalue required as unary '&' operand
      55 |         *(volatile typeof(x) *)&(x) = (val);                            \
         |                                ^
   include/asm-generic/rwonce.h:61:9: note: in expansion of macro '__WRITE_ONCE'
      61 |         __WRITE_ONCE(x, val);                                           \
         |         ^~~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_target.c:6833:25: note: in expansion of macro 'WRITE_ONCE'
    6833 |                         WRITE_ONCE(&vha->hw->exch_starvation, 0);
         |                         ^~~~~~~~~~


vim +55 include/asm-generic/rwonce.h

e506ea451254ab Will Deacon 2019-10-15  52  
e506ea451254ab Will Deacon 2019-10-15  53  #define __WRITE_ONCE(x, val)						\
e506ea451254ab Will Deacon 2019-10-15  54  do {									\
e506ea451254ab Will Deacon 2019-10-15 @55  	*(volatile typeof(x) *)&(x) = (val);				\
e506ea451254ab Will Deacon 2019-10-15  56  } while (0)
e506ea451254ab Will Deacon 2019-10-15  57  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
