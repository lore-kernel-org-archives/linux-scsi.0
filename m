Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F5814900E;
	Wed,  9 Oct 2024 04:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728448713; cv=none; b=nh6Y+kiydBhep8oAUfB+QB2IdnIVXpBYiBm5+aDWDnthvBTDsCVeint0PfXw73HdyGxM5lSE1uAvmJFGXmuNLqoWhsvaOQtwJ4vWuUaijQsjk/Acb7d87mwxlk+gy8OjKNA/r714Y6P1oRNfPdT10k1jUARVifQLeNGrr+dkJNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728448713; c=relaxed/simple;
	bh=FN1tGQVC7ybcbMbZcgbYZ8fayCDnwecgtqAgDTZSukI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4Pia1gm40wWEphihG+rR38GBNjD/xQ2GXtAKbKQO4uO6z0COSaNqAl/NMMqsnw1gftSG+VlINqI3TVvLU3CG30ZpwqVQJsB23E9XipYPx7wJKIoORqBmJOeUzXXsjn4tOE795ysLanHE4gh06pLTQWMLwXGp+MrIlaeqYQuaN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BxJCfujT; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BxJCfujT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728448711; x=1759984711;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FN1tGQVC7ybcbMbZcgbYZ8fayCDnwecgtqAgDTZSukI=;
  b=BxJCfujTcN82vsglbbLIzgAoDxoxj7ptYhPkhl87rXVOZtxls1NUCoHF
   ym5P/ISHhAZbusHhZI+hjmcMTi4uYqLzCQTiu08vayEU/3vaOJMUGQbLP
   18arZLUd0Wg9zjKvHTOZ/0S4Zuu0P8MyEHuaaJnH/JNXQt6ku+5n+y/ZB
   KPVs75HDdhYpq88sGFF+49bif4c6md6n+DZ/aYxgKwfkVEzm2gEOacBkA
   tspSRGCV0qNvvLoiVMiHMJHBPfhBHqd76nfe6ckClatLm60NJOlvAeuwP
   1yuegFKf2jtl1pgVsUn1vvjQfMO47gmQqfNBAqDN6rMbOjIbb+op45mP/
   w==;
X-CSE-ConnectionGUID: CJ7Biv6JSc62ISz3J9emXg==
X-CSE-MsgGUID: qdk29gVtRxuIpQG9nxiuEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="45191242"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="45191242"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 21:38:30 -0700
X-CSE-ConnectionGUID: FDoY/wsJSRuqMA3cPovuoA==
X-CSE-MsgGUID: yZzapCFvQ5OmZSvpD5ZvTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="76081742"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 08 Oct 2024 21:38:28 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1syOSv-0008jN-0o;
	Wed, 09 Oct 2024 04:38:25 +0000
Date: Wed, 9 Oct 2024 12:38:08 +0800
From: kernel test robot <lkp@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, Thorsten Blum <thorsten.blum@linux.dev>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: fnic: Use vzalloc() instead of vmalloc() and
 memset(0)
Message-ID: <202410091405.LkpEl2OX-lkp@intel.com>
References: <20241008095152.1831-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008095152.1831-2-thorsten.blum@linux.dev>

Hi Thorsten,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.12-rc2 next-20241008]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Thorsten-Blum/scsi-fnic-Use-vzalloc-instead-of-vmalloc-and-memset-0/20241008-175453
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241008095152.1831-2-thorsten.blum%40linux.dev
patch subject: [PATCH v2] scsi: fnic: Use vzalloc() instead of vmalloc() and memset(0)
config: i386-randconfig-003-20241009 (https://download.01.org/0day-ci/archive/20241009/202410091405.LkpEl2OX-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241009/202410091405.LkpEl2OX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410091405.LkpEl2OX-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/scsi/fnic/fnic_trace.c: In function 'fnic_fc_trace_init':
>> drivers/scsi/fnic/fnic_trace.c:559:34: warning: assignment to 'long unsigned int' from 'void *' makes integer from pointer without a cast [-Wint-conversion]
     559 |         fnic_fc_ctlr_trace_buf_p =
         |                                  ^


vim +559 drivers/scsi/fnic/fnic_trace.c

abb14148c0f850 Hiral Shah         2014-04-18  537  
abb14148c0f850 Hiral Shah         2014-04-18  538  /*
abb14148c0f850 Hiral Shah         2014-04-18  539   * fnic_fc_ctlr_trace_buf_init -
abb14148c0f850 Hiral Shah         2014-04-18  540   * Initialize trace buffer to log fnic control frames
abb14148c0f850 Hiral Shah         2014-04-18  541   * Description:
abb14148c0f850 Hiral Shah         2014-04-18  542   * Initialize trace buffer data structure by allocating
abb14148c0f850 Hiral Shah         2014-04-18  543   * required memory for trace data as well as for Indexes.
abb14148c0f850 Hiral Shah         2014-04-18  544   * Frame size is 256 bytes and
abb14148c0f850 Hiral Shah         2014-04-18  545   * memory is allocated for 1024 entries of 256 bytes.
abb14148c0f850 Hiral Shah         2014-04-18  546   * Page_offset(Index) is set to the address of trace entry
abb14148c0f850 Hiral Shah         2014-04-18  547   * and page_offset is initialized by adding frame size
abb14148c0f850 Hiral Shah         2014-04-18  548   * to the previous page_offset entry.
abb14148c0f850 Hiral Shah         2014-04-18  549   */
abb14148c0f850 Hiral Shah         2014-04-18  550  
abb14148c0f850 Hiral Shah         2014-04-18  551  int fnic_fc_trace_init(void)
abb14148c0f850 Hiral Shah         2014-04-18  552  {
abb14148c0f850 Hiral Shah         2014-04-18  553  	unsigned long fc_trace_buf_head;
abb14148c0f850 Hiral Shah         2014-04-18  554  	int err = 0;
abb14148c0f850 Hiral Shah         2014-04-18  555  	int i;
abb14148c0f850 Hiral Shah         2014-04-18  556  
abb14148c0f850 Hiral Shah         2014-04-18  557  	fc_trace_max_entries = (fnic_fc_trace_max_pages * PAGE_SIZE)/
abb14148c0f850 Hiral Shah         2014-04-18  558  				FC_TRC_SIZE_BYTES;
42bc47b35320e0 Kees Cook          2018-06-12 @559  	fnic_fc_ctlr_trace_buf_p =
c9ff42f1a76c7b Thorsten Blum      2024-10-08  560  		vzalloc(array_size(PAGE_SIZE, fnic_fc_trace_max_pages));
abb14148c0f850 Hiral Shah         2014-04-18  561  	if (!fnic_fc_ctlr_trace_buf_p) {
abb14148c0f850 Hiral Shah         2014-04-18  562  		pr_err("fnic: Failed to allocate memory for "
abb14148c0f850 Hiral Shah         2014-04-18  563  		       "FC Control Trace Buf\n");
abb14148c0f850 Hiral Shah         2014-04-18  564  		err = -ENOMEM;
abb14148c0f850 Hiral Shah         2014-04-18  565  		goto err_fnic_fc_ctlr_trace_buf_init;
abb14148c0f850 Hiral Shah         2014-04-18  566  	}
abb14148c0f850 Hiral Shah         2014-04-18  567  
abb14148c0f850 Hiral Shah         2014-04-18  568  	/* Allocate memory for page offset */
42bc47b35320e0 Kees Cook          2018-06-12  569  	fc_trace_entries.page_offset =
c9ff42f1a76c7b Thorsten Blum      2024-10-08  570  		vzalloc(array_size(fc_trace_max_entries,
42bc47b35320e0 Kees Cook          2018-06-12  571  				   sizeof(unsigned long)));
abb14148c0f850 Hiral Shah         2014-04-18  572  	if (!fc_trace_entries.page_offset) {
abb14148c0f850 Hiral Shah         2014-04-18  573  		pr_err("fnic:Failed to allocate memory for page_offset\n");
abb14148c0f850 Hiral Shah         2014-04-18  574  		if (fnic_fc_ctlr_trace_buf_p) {
abb14148c0f850 Hiral Shah         2014-04-18  575  			pr_err("fnic: Freeing FC Control Trace Buf\n");
abb14148c0f850 Hiral Shah         2014-04-18  576  			vfree((void *)fnic_fc_ctlr_trace_buf_p);
abb14148c0f850 Hiral Shah         2014-04-18  577  			fnic_fc_ctlr_trace_buf_p = 0;
abb14148c0f850 Hiral Shah         2014-04-18  578  		}
abb14148c0f850 Hiral Shah         2014-04-18  579  		err = -ENOMEM;
abb14148c0f850 Hiral Shah         2014-04-18  580  		goto err_fnic_fc_ctlr_trace_buf_init;
abb14148c0f850 Hiral Shah         2014-04-18  581  	}
abb14148c0f850 Hiral Shah         2014-04-18  582  
abb14148c0f850 Hiral Shah         2014-04-18  583  	fc_trace_entries.rd_idx = fc_trace_entries.wr_idx = 0;
abb14148c0f850 Hiral Shah         2014-04-18  584  	fc_trace_buf_head = fnic_fc_ctlr_trace_buf_p;
abb14148c0f850 Hiral Shah         2014-04-18  585  
abb14148c0f850 Hiral Shah         2014-04-18  586  	/*
abb14148c0f850 Hiral Shah         2014-04-18  587  	* Set up fc_trace_entries.page_offset field with memory location
abb14148c0f850 Hiral Shah         2014-04-18  588  	* for every trace entry
abb14148c0f850 Hiral Shah         2014-04-18  589  	*/
abb14148c0f850 Hiral Shah         2014-04-18  590  	for (i = 0; i < fc_trace_max_entries; i++) {
abb14148c0f850 Hiral Shah         2014-04-18  591  		fc_trace_entries.page_offset[i] = fc_trace_buf_head;
abb14148c0f850 Hiral Shah         2014-04-18  592  		fc_trace_buf_head += FC_TRC_SIZE_BYTES;
abb14148c0f850 Hiral Shah         2014-04-18  593  	}
1dbaa379a41934 Greg Kroah-Hartman 2019-01-22  594  	fnic_fc_trace_debugfs_init();
abb14148c0f850 Hiral Shah         2014-04-18  595  	pr_info("fnic: Successfully Initialized FC_CTLR Trace Buffer\n");
abb14148c0f850 Hiral Shah         2014-04-18  596  	return err;
abb14148c0f850 Hiral Shah         2014-04-18  597  
abb14148c0f850 Hiral Shah         2014-04-18  598  err_fnic_fc_ctlr_trace_buf_init:
abb14148c0f850 Hiral Shah         2014-04-18  599  	return err;
abb14148c0f850 Hiral Shah         2014-04-18  600  }
abb14148c0f850 Hiral Shah         2014-04-18  601  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
