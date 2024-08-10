Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DD3158528;
	Sat, 10 Aug 2024 14:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723300769; cv=none; b=Puqp+tRRxAkspeJzRsVM4/RNE0oPwXeb1WEKjF/7Of9W7sYnBHvWkJHfVJuhfwOsT58coyNIgomIc1KiYc+aqz0JEZdtjMAa8Agg7tKGgpd4PDmA6BgKl42jspwD5JR37tyJcLOHpLFhHwgVIXaAr4TeJNHN55XsxrAqgzDYqdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723300769; c=relaxed/simple;
	bh=zxFyaeB3BQP/TPfQeSmqZU4m8dfQgEH/lW3Cm7mp2Kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u1zlmjwTX00RZPNn3r24uqi9nWczRR8n5fYF0BgfvEx70bX3vrA3OwEtFLt6IgnN4hhSi7o8VQEm4t5+5w6KPsNhdfBUc4+OCtCuQFCj1lCh6ZoSJoz2E1TJUH8jhRppbnw2bWOrG6AI27K4M4hYUmErEhuJwVWQaP52lNKXFfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wsw5k2ie; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wsw5k2ie"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723300767; x=1754836767;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zxFyaeB3BQP/TPfQeSmqZU4m8dfQgEH/lW3Cm7mp2Kk=;
  b=Wsw5k2ieGCBewlPZTmAjWXUD2HOlJUMYMzirM3AyokmKNJnKp7T9atZl
   f39MG+dM6MOb6vSohWHF7WNsy+wWHv05TYhAd0mKgrE5pxn+Yq1Zna7yQ
   qP5cVwCutVul7wRQba/LXRNhWj/rGdjU5OKBElitENasv6vAx2K1dy9Q7
   biMOqbuB0Qs9syb67d+r1/r9mOJ9pfZE6DNoU6bN7AYtfpwLo6z3NwUDn
   XHTUvIxY/mFAaJOQuxDHvUPgZ+TBHkxh+nEHFyTaJYhbcxhiYxNaN8ck9
   8rn66rhkvr/8CfmonnKELs78rUGDdYUraP1xPNQoSbSS/xxMNv1/Mo6Ss
   Q==;
X-CSE-ConnectionGUID: LPh/ZLRcRjC323zrfZf2UQ==
X-CSE-MsgGUID: 50i3cNZjQ8KvRnA86tRgcA==
X-IronPort-AV: E=McAfee;i="6700,10204,11160"; a="38913063"
X-IronPort-AV: E=Sophos;i="6.09,279,1716274800"; 
   d="scan'208";a="38913063"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2024 07:39:27 -0700
X-CSE-ConnectionGUID: zHNQZHxwSP+MIUMJUwrSXA==
X-CSE-MsgGUID: OasArWppSamo4fHzLeQ3OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,279,1716274800"; 
   d="scan'208";a="88476573"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 10 Aug 2024 07:39:24 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1scnFZ-000A11-1F;
	Sat, 10 Aug 2024 14:39:21 +0000
Date: Sat, 10 Aug 2024 22:38:22 +0800
From: kernel test robot <lkp@intel.com>
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: oe-kbuild-all@lists.linux.dev, arulponn@cisco.com, djhawar@cisco.com,
	gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
	aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 03/14] scsi: fnic: Add support for fabric based
 solicited requests and responses
Message-ID: <202408102208.Vnf8XzGo-lkp@intel.com>
References: <20240809164240.47561-4-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809164240.47561-4-kartilak@cisco.com>

Hi Karan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.11-rc2 next-20240809]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Karan-Tilak-Kumar/scsi-fnic-Replace-shost_printk-with-dev_info-dev_err/20240810-053926
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240809164240.47561-4-kartilak%40cisco.com
patch subject: [PATCH v2 03/14] scsi: fnic: Add support for fabric based solicited requests and responses
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20240810/202408102208.Vnf8XzGo-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240810/202408102208.Vnf8XzGo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408102208.Vnf8XzGo-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/scsi/fnic/fnic_fcs.c:21:
   drivers/scsi/fnic/fnic_fcs.c: In function 'fdls_send_fcoe_frame':
>> drivers/scsi/fnic/fnic.h:159:33: warning: format '%lu' expects argument of type 'long unsigned int', but argument 7 has type 'unsigned int' [-Wformat=]
     159 |                                 "fnic<%d>: %s: %d: " fmt, fnic_num,\
         |                                 ^~~~~~~~~~~~~~~~~~~~
   drivers/scsi/fnic/fnic.h:146:25: note: in definition of macro 'FNIC_CHECK_LOGGING'
     146 |                         CMD;                                    \
         |                         ^~~
   include/scsi/scsi_host.h:738:9: note: in expansion of macro 'dev_printk'
     738 |         dev_printk(prefix, &(shost)->shost_gendev, fmt, ##a)
         |         ^~~~~~~~~~
   drivers/scsi/fnic/fnic.h:158:26: note: in expansion of macro 'shost_printk'
     158 |                          shost_printk(kern_level, host,                 \
         |                          ^~~~~~~~~~~~
   drivers/scsi/fnic/fnic_fcs.c:1227:25: note: in expansion of macro 'FNIC_FCS_DBG'
    1227 |                         FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
         |                         ^~~~~~~~~~~~


vim +159 drivers/scsi/fnic/fnic.h

5df6d737dd4b0f Abhijeet Joglekar 2009-04-17  149  
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11  150  #define FNIC_MAIN_DBG(kern_level, host, fnic_num, fmt, args...)		\
5df6d737dd4b0f Abhijeet Joglekar 2009-04-17  151  	FNIC_CHECK_LOGGING(FNIC_MAIN_LOGGING,			\
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11  152  			 shost_printk(kern_level, host,			\
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11  153  				"fnic<%d>: %s: %d: " fmt, fnic_num,\
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11  154  				__func__, __LINE__, ##args);)
5df6d737dd4b0f Abhijeet Joglekar 2009-04-17  155  
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11  156  #define FNIC_FCS_DBG(kern_level, host, fnic_num, fmt, args...)		\
5df6d737dd4b0f Abhijeet Joglekar 2009-04-17  157  	FNIC_CHECK_LOGGING(FNIC_FCS_LOGGING,			\
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11  158  			 shost_printk(kern_level, host,			\
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11 @159  				"fnic<%d>: %s: %d: " fmt, fnic_num,\
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11  160  				__func__, __LINE__, ##args);)
5df6d737dd4b0f Abhijeet Joglekar 2009-04-17  161  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
