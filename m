Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4119E13D891;
	Tue, 25 Nov 2025 07:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764054020; cv=none; b=FQMdNvcGnMaMHEqc6qYCN03Wjo+c5CPL6uuy43Meswkq+IPML/n8E4slxM2yeEI4pNi3zqEpTMDLZt7r26wmT+bhsqK4rO673YLwgxwKngKH1RNtkTU3TJ6EIq2ktwBL+eiD9sh5VMZ8ww7r0Qi2PYfZx2+QQEE42VYvuE0Rmys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764054020; c=relaxed/simple;
	bh=OMcXJ2dkVm7jKJ9rum+8R9nzWkBHh1MYXvp80cM24SA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nsYj5QbKRltpW7VBT3BzBc2TFy42zNoFp1fkrxU9I9CwrOtmXELnPSpkQQzxljR/GRNTZ0wHHYGP3aXkzHKYvcPEFvVvR7amcKBWSLLRRQCikTQ7BxdbnAEsxr48oNWTZbRI9mho1dqqVd7gjxF+OLE4zyJAs3xYVtjahrOYlHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CPeL5OC4; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CPeL5OC4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764054020; x=1795590020;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OMcXJ2dkVm7jKJ9rum+8R9nzWkBHh1MYXvp80cM24SA=;
  b=CPeL5OC4E+lOy4V3dEOS1qL/DNjwxq+OkTi0AtBi+dxKpNQojSO2uB0l
   oEDQ7uN6NUxqRIoH7vARQ0nghVv+nJDuXnuf9cxKu0WA66UPW72IAPWXV
   6XcXAzoJZ6Ric5VHFJ0kJ+q4F8R6/30WJc/09b4iCVrCrhVEkZSB1JSNB
   vSYkYrGnwgG1PVg7EsHQMzxGXFy3L2Z+GBj+T4ZvUuK7C9Y/e88xY+t8D
   qr3b6bH+YU2Soj22VRDpX6a10YGi3kXhRRVLyl4fwMxNndDvJzU34CKR4
   7aay5vyLWkcS7jgwJsVulrPwyW0o6rDlI8qfxK4dY+i3sAwzH4U+OpARj
   Q==;
X-CSE-ConnectionGUID: VLD0+oB4R5Cp7Wn9m4J+Ng==
X-CSE-MsgGUID: x1mMYEN8Semi7MqS6nRbpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="65952038"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="65952038"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 23:00:16 -0800
X-CSE-ConnectionGUID: znWy9/oWQbi+RJXZ3xcLbA==
X-CSE-MsgGUID: svTfXJE4S8+gb+Ng3MRsKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="192631933"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 24 Nov 2025 23:00:11 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vNn21-000000001Rx-2WBZ;
	Tue, 25 Nov 2025 07:00:09 +0000
Date: Tue, 25 Nov 2025 14:59:25 +0800
From: kernel test robot <lkp@intel.com>
To: Guangshuo Li <lgs201920130244@gmail.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Guangshuo Li <lgs201920130244@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] [SCSI] hptiop: Add inbound queue offset bounds check in
 iop_get_config_itl
Message-ID: <202511251457.AUHUgeyl-lkp@intel.com>
References: <20251124145848.45687-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124145848.45687-1-lgs201920130244@gmail.com>

Hi Guangshuo,

kernel test robot noticed the following build errors:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on jejb-scsi/for-next akpm-mm/mm-everything linus/master v6.18-rc7 next-20251124]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Guangshuo-Li/hptiop-Add-inbound-queue-offset-bounds-check-in-iop_get_config_itl/20251124-230112
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251124145848.45687-1-lgs201920130244%40gmail.com
patch subject: [PATCH] [SCSI] hptiop: Add inbound queue offset bounds check in iop_get_config_itl
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251125/202511251457.AUHUgeyl-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251125/202511251457.AUHUgeyl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511251457.AUHUgeyl-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/scsi/hptiop.c:170:17: error: no member named 'pdev' in 'struct hptiop_hba'
     170 |                 dev_err(&hba->pdev->dev,
         |                          ~~~  ^
   include/linux/dev_printk.h:154:44: note: expanded from macro 'dev_err'
     154 |         dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                                                   ^~~
   include/linux/dev_printk.h:110:11: note: expanded from macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                         ^~~
   1 error generated.


vim +170 drivers/scsi/hptiop.c

   160	
   161	static void mv_inbound_write(u64 p, struct hptiop_hba *hba)
   162	{
   163		u32 inbound_head = readl(&hba->u.mv.mu->inbound_head);
   164		u32 head = inbound_head + 1;
   165	
   166		if (head == MVIOP_QUEUE_LEN)
   167			head = 0;
   168	
   169		if (inbound_head >= MVIOP_QUEUE_LEN) {
 > 170			dev_err(&hba->pdev->dev,
   171				"hptiop: inbound_head out of range (%u)\n",
   172				inbound_head);
   173			inbound_head = 0;
   174			head = 1;
   175		}
   176	
   177		memcpy_toio(&hba->u.mv.mu->inbound_q[inbound_head], &p, 8);
   178		writel(head, &hba->u.mv.mu->inbound_head);
   179		writel(MVIOP_MU_INBOUND_INT_POSTQUEUE,
   180				&hba->u.mv.regs->inbound_doorbell);
   181	}
   182	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
