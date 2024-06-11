Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E58757F6;
	Tue, 11 Jun 2024 18:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718131143; cv=none; b=nhl2gbXdvrNl9KxA0tz9kETkuBqcfkU3lpHSDcziXO1nLo7ypYaVzNDjJxdocHXW+GyNJ7jZCirwupUOIOe3Jp3nlj0sK8fIZ2PXKytzVwWWF1e1WBxkRbt0Cb2TvkHEIyWIben7uOBm2W7Qqw8m1h1br/w5QGujtFXJL862XzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718131143; c=relaxed/simple;
	bh=ohppsjWPjJRyFtFqckt/hYnonCHoM/wgvmO6lrk5vdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ULDcR0olqw+vNtIAztCXFTB3HREquciIVbt8J9EJDEBNd2LUZO9IdSWccHga/I90GLjBoHalpYhMKCfJZDIX6aJOMROyoBYupEnSxtNTXenRqU2N18A7CEx7x8e1OErhefupuW4BjzWupDbIMB7FJAsezgMdvjpk4bIzWyIN6k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JUi0MIis; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JUi0MIis"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718131141; x=1749667141;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ohppsjWPjJRyFtFqckt/hYnonCHoM/wgvmO6lrk5vdw=;
  b=JUi0MIisWy/kvQ1qa5MALMjIN7qtJ/OXGB9bPgYGgKqbuwhLnXW7C6ud
   SNE6EFXxG+5+hBZ1egBVu7fytOPzqjKO1orAkjYnzBK/QVmEMK8CFWwQT
   ZMZ+zA6nfIqs4FGLx9pn0nRBsZ4DRhVZzA0+hNEbTXr7IlaNSrm15rXyL
   dCK6uOxFPffqH7LkMuv5l00DiBpSVpv1T9x9wSGDbHP2Oc7oCHL8KGhRX
   jDFRwxnezk+NAT0KZ6KSTTNGeqjWJpR6E5BeiKoz4CWOUhfmUMl7/hW4v
   4tKpEeUD1X74UCAiZE3Wrwdl+h9x+fe3/AOTUYTivqn9Po2OzhH1LIe0J
   A==;
X-CSE-ConnectionGUID: N705jKijR1mMIBKx/ITPeg==
X-CSE-MsgGUID: NSK1CjKpRg+5X+6ainA99A==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="14587440"
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="14587440"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 11:39:00 -0700
X-CSE-ConnectionGUID: wm7c0nIRRHiga9+KZhrnwg==
X-CSE-MsgGUID: Nqw0HRHOQOWT9fRxOWk9FA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="39631801"
Received: from lkp-server01.sh.intel.com (HELO 628d7d8b9fc6) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 11 Jun 2024 11:38:58 -0700
Received: from kbuild by 628d7d8b9fc6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sH6OV-0000mY-1r;
	Tue, 11 Jun 2024 18:38:55 +0000
Date: Wed, 12 Jun 2024 02:38:29 +0800
From: kernel test robot <lkp@intel.com>
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: oe-kbuild-all@lists.linux.dev, arulponn@cisco.com, djhawar@cisco.com,
	gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: Re: [PATCH 03/14] scsi: fnic: Add support for fabric based solicited
 requests and responses
Message-ID: <202406120201.VakI9Dly-lkp@intel.com>
References: <20240610215100.673158-4-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610215100.673158-4-kartilak@cisco.com>

Hi Karan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.10-rc3 next-20240611]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Karan-Tilak-Kumar/scsi-fnic-Replace-shost_printk-with-pr_info-pr_err/20240611-060227
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240610215100.673158-4-kartilak%40cisco.com
patch subject: [PATCH 03/14] scsi: fnic: Add support for fabric based solicited requests and responses
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20240612/202406120201.VakI9Dly-lkp@intel.com/config)
compiler: gcc-13 (Ubuntu 13.2.0-4ubuntu3) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240612/202406120201.VakI9Dly-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406120201.VakI9Dly-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/scsi/fnic/fnic_fcs.c:21:
   drivers/scsi/fnic/fnic_fcs.c: In function 'fdls_send_fcoe_frame':
>> drivers/scsi/fnic/fnic.h:159:33: warning: format '%ld' expects argument of type 'long int', but argument 7 has type 'unsigned int' [-Wformat=]
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
   drivers/scsi/fnic/fnic_fcs.c:1228:25: note: in expansion of macro 'FNIC_FCS_DBG'
    1228 |                         FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
         |                         ^~~~~~~~~~~~


vim +159 drivers/scsi/fnic/fnic.h

5df6d737dd4b0fe Abhijeet Joglekar 2009-04-17  149  
3df9dd0d51c2e4b Karan Tilak Kumar 2023-12-11  150  #define FNIC_MAIN_DBG(kern_level, host, fnic_num, fmt, args...)		\
5df6d737dd4b0fe Abhijeet Joglekar 2009-04-17  151  	FNIC_CHECK_LOGGING(FNIC_MAIN_LOGGING,			\
3df9dd0d51c2e4b Karan Tilak Kumar 2023-12-11  152  			 shost_printk(kern_level, host,			\
3df9dd0d51c2e4b Karan Tilak Kumar 2023-12-11  153  				"fnic<%d>: %s: %d: " fmt, fnic_num,\
3df9dd0d51c2e4b Karan Tilak Kumar 2023-12-11  154  				__func__, __LINE__, ##args);)
5df6d737dd4b0fe Abhijeet Joglekar 2009-04-17  155  
3df9dd0d51c2e4b Karan Tilak Kumar 2023-12-11  156  #define FNIC_FCS_DBG(kern_level, host, fnic_num, fmt, args...)		\
5df6d737dd4b0fe Abhijeet Joglekar 2009-04-17  157  	FNIC_CHECK_LOGGING(FNIC_FCS_LOGGING,			\
3df9dd0d51c2e4b Karan Tilak Kumar 2023-12-11  158  			 shost_printk(kern_level, host,			\
3df9dd0d51c2e4b Karan Tilak Kumar 2023-12-11 @159  				"fnic<%d>: %s: %d: " fmt, fnic_num,\
3df9dd0d51c2e4b Karan Tilak Kumar 2023-12-11  160  				__func__, __LINE__, ##args);)
5df6d737dd4b0fe Abhijeet Joglekar 2009-04-17  161  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
