Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3865F16F8E9;
	Mon,  9 Dec 2024 04:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733718927; cv=none; b=kaDGZsCOmsEEQKfwycYr7tWd/M8Nb6fZowiYyD8Hw3FygJJGuVjzf2YoyJMXN/WLH4cIWtdwnrw0jdrUYs/rRGObcakonNy7Hezup0SmoPOmPL+mkMfBiTzS0OI/jbJlfcgQCD5YogivSwS54j0gTXRhsHCIREYToOEp8CnR+l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733718927; c=relaxed/simple;
	bh=e0msx8DoGYxBgxhnq1KW8NrILsSQHRKlDWN0V1Q+IL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=is6Bo7YZ5NoaeD9p4keKrJBCMG7bzWsQzqe/vFQUCwm550vrclr0Uyn260iBeE0NHkMqBOou4t1ap1Nzs6Oj0TlQAdGjTzkqKq4rslLqqY+CG82gxadV42mP7PlOSIshAPFfe4IPVOhQUF+/DbCWzMTSA96SJ2PLn9sSctnZg6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xq8VipPi; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xq8VipPi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733718926; x=1765254926;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e0msx8DoGYxBgxhnq1KW8NrILsSQHRKlDWN0V1Q+IL0=;
  b=Xq8VipPi8rofUllQdd9H1WrFRR6y1LJTt2D+YHF/wocWapR76vKX4JuX
   05MREg5Orv5UkJkS1wJHGvz3t+Snlc6ER9fMY9MMHR5av5KchE1aF8Woy
   +AjlnzTtF9KqNf5r+9ngNUSACXf6I1KUjgktr8yxMpLoM2XzYYFKRWSiQ
   Rl8RbEFFbt7FUaJy2M32otWAMcQJUuMB4GNgb5P+b8b0HlI/uEWRhe0W0
   wtvuC+1I9pnMiSDdJjJIWKRabQoKszzI5XXDLHCf1A0UvG2tkmZwzZ+8X
   4ZvpIS+Np52r1VO+rL78eU3SUlU4Vi4EGAVMbLzahgZ5o+Pva14/JTZlR
   Q==;
X-CSE-ConnectionGUID: eYKNvnIcTUORcAxdmu/vEQ==
X-CSE-MsgGUID: 3ILZzx+qQkq3UT3uvo3KLw==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="34237099"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="34237099"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 20:35:26 -0800
X-CSE-ConnectionGUID: Do6IxgJjTGeygUubTLHx2w==
X-CSE-MsgGUID: XH1UaaCxSTC9G2nF+WsJEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="125844611"
Received: from lkp-server01.sh.intel.com (HELO 82a3f569d0cb) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 08 Dec 2024 20:35:22 -0800
Received: from kbuild by 82a3f569d0cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tKVUO-0003se-0a;
	Mon, 09 Dec 2024 04:35:20 +0000
Date: Mon, 9 Dec 2024 12:35:08 +0800
From: kernel test robot <lkp@intel.com>
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: oe-kbuild-all@lists.linux.dev, arulponn@cisco.com, djhawar@cisco.com,
	gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
	aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v6 03/15] scsi: fnic: Add support for fabric based
 solicited requests and responses
Message-ID: <202412080837.2JU0r2Ny-lkp@intel.com>
References: <20241206210852.3251-4-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241206210852.3251-4-kartilak@cisco.com>

Hi Karan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on linus/master v6.13-rc1 next-20241206]
[cannot apply to mkp-scsi/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Karan-Tilak-Kumar/scsi-fnic-Replace-shost_printk-with-dev_info-dev_err/20241207-054453
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241206210852.3251-4-kartilak%40cisco.com
patch subject: [PATCH v6 03/15] scsi: fnic: Add support for fabric based solicited requests and responses
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20241208/202412080837.2JU0r2Ny-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241208/202412080837.2JU0r2Ny-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412080837.2JU0r2Ny-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/scsi/fnic/fnic_fcs.c:22:
   drivers/scsi/fnic/fnic_fcs.c: In function 'fdls_send_fcoe_frame':
>> drivers/scsi/fnic/fnic.h:164:33: warning: format '%lu' expects argument of type 'long unsigned int', but argument 7 has type 'unsigned int' [-Wformat=]
     164 |                                 "fnic<%d>: %s: %d: " fmt, fnic_num,\
         |                                 ^~~~~~~~~~~~~~~~~~~~
   drivers/scsi/fnic/fnic.h:151:25: note: in definition of macro 'FNIC_CHECK_LOGGING'
     151 |                         CMD;                                    \
         |                         ^~~
   include/scsi/scsi_host.h:737:9: note: in expansion of macro 'dev_printk'
     737 |         dev_printk(prefix, &(shost)->shost_gendev, fmt, ##a)
         |         ^~~~~~~~~~
   drivers/scsi/fnic/fnic.h:163:26: note: in expansion of macro 'shost_printk'
     163 |                          shost_printk(kern_level, host,                 \
         |                          ^~~~~~~~~~~~
   drivers/scsi/fnic/fnic_fcs.c:1231:25: note: in expansion of macro 'FNIC_FCS_DBG'
    1231 |                         FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
         |                         ^~~~~~~~~~~~


vim +164 drivers/scsi/fnic/fnic.h

5df6d737dd4b0f Abhijeet Joglekar 2009-04-17  154  
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11  155  #define FNIC_MAIN_DBG(kern_level, host, fnic_num, fmt, args...)		\
5df6d737dd4b0f Abhijeet Joglekar 2009-04-17  156  	FNIC_CHECK_LOGGING(FNIC_MAIN_LOGGING,			\
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11  157  			 shost_printk(kern_level, host,			\
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11  158  				"fnic<%d>: %s: %d: " fmt, fnic_num,\
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11  159  				__func__, __LINE__, ##args);)
5df6d737dd4b0f Abhijeet Joglekar 2009-04-17  160  
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11  161  #define FNIC_FCS_DBG(kern_level, host, fnic_num, fmt, args...)		\
5df6d737dd4b0f Abhijeet Joglekar 2009-04-17  162  	FNIC_CHECK_LOGGING(FNIC_FCS_LOGGING,			\
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11  163  			 shost_printk(kern_level, host,			\
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11 @164  				"fnic<%d>: %s: %d: " fmt, fnic_num,\
3df9dd0d51c2e4 Karan Tilak Kumar 2023-12-11  165  				__func__, __LINE__, ##args);)
5df6d737dd4b0f Abhijeet Joglekar 2009-04-17  166  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
