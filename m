Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49D119F422;
	Tue, 15 Apr 2025 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744724710; cv=none; b=ptqfojCL9c/y6qpSVpDWcclc3Dk+XUCrs4vHaajGYWSwiG0XU7ewWD1UhGUdNEvUtQzpWohLuziVzAbfLArCVFysSkc7+gbPqOsuDdthbGtZHBVYEuBczt0ifIUM6A3sgIK/7pmYmZugUzK+gdkkm0RB1RMu0QZzKvjjrqL2scc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744724710; c=relaxed/simple;
	bh=HYnPp9jHyi+2/ewnjYN1T/Y1OTx4xyzm9rXfzeGvPtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s85b1mcZ8hku44DYWnlw/7Z/UqMDl4EiNikWVxSaBF6L4R3CbicKwUe6vwtAvGTcIN2HvFE+h1MX2rpZSNMLH/dyXWwbu9wfJHypQjVVE2BfEq01+l8vACp5Ryu9bl+zB/s/GggcWTf2/L+DSzZCtipof+sbKCxh7uYENe16INY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nbhlPhsf; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nbhlPhsf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744724709; x=1776260709;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HYnPp9jHyi+2/ewnjYN1T/Y1OTx4xyzm9rXfzeGvPtI=;
  b=nbhlPhsfz0EvEiNa0muvngZOH6D4VekI2owWukYlBTHZIIMo4O/wZiHx
   G/K9CvJE3PV3ZNeS8o05Q80DS33aoNelR0Fo/wjPaG7ZRkfJsfzgnsCvR
   q75agY5qWXrKosSrK+fVsZBUqTk9b1B/i3wxwboiUItkhTQ1EhVnR3jCq
   PLb8ciurrhY2ytPZpI3BFM0Ah8DxWfYdp2l0mUMEqTauYiWr+DYlxeEp/
   2CYCr11gqXN5EUtBC9JoZZJ1x00lHUV73mMY2K4Apj19c1yJ1P0e5tpfH
   GUJqrRhmWyoYFyZnBPHEPcZF61qxzJQTBYYV38+MIWj53PkbvV7sIJ78G
   A==;
X-CSE-ConnectionGUID: H/CrkQhSS7qez6BONQFr+w==
X-CSE-MsgGUID: ESHOoTrcReq4usu44j5FaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11404"; a="46322448"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="46322448"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 06:45:08 -0700
X-CSE-ConnectionGUID: /8g+SDTdSl+uUaIFfQ+6yw==
X-CSE-MsgGUID: Lzu676qCSDaZGLuzYhhL2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="130659369"
Received: from lkp-server01.sh.intel.com (HELO b207828170a5) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 15 Apr 2025 06:45:06 -0700
Received: from kbuild by b207828170a5 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u4gb1-000GEA-26;
	Tue, 15 Apr 2025 13:45:03 +0000
Date: Tue, 15 Apr 2025 21:44:06 +0800
From: kernel test robot <lkp@intel.com>
To: Arthur Simchaev <arthur.simchaev@sandisk.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	avri.altman@sandisk.com, Avi.Shchislowski@sandisk.com,
	beanhuo@micron.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, bvanassche@acm.org
Subject: Re: [PATCH v2] ufs: bsg: Add hibern8 enter/exit to
 ufshcd_send_bsg_uic_cmd
Message-ID: <202504152109.JOmreWGE-lkp@intel.com>
References: <20250414120257.247858-1-arthur.simchaev@sandisk.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250414120257.247858-1-arthur.simchaev@sandisk.com>

Hi Arthur,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.15-rc2 next-20250415]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Arthur-Simchaev/ufs-bsg-Add-hibern8-enter-exit-to-ufshcd_send_bsg_uic_cmd/20250414-200404
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250414120257.247858-1-arthur.simchaev%40sandisk.com
patch subject: [PATCH v2] ufs: bsg: Add hibern8 enter/exit to ufshcd_send_bsg_uic_cmd
config: i386-buildonly-randconfig-004-20250415 (https://download.01.org/0day-ci/archive/20250415/202504152109.JOmreWGE-lkp@intel.com/config)
compiler: clang version 20.1.2 (https://github.com/llvm/llvm-project 58df0ef89dd64126512e4ee27b4ac3fd8ddf6247)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250415/202504152109.JOmreWGE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504152109.JOmreWGE-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/ufs/core/ufshcd.c:4360:38: error: too many arguments to function call, expected single argument 'hba', have 2 arguments
    4360 |                 ret = ufshcd_uic_hibern8_exit(hba, uic_cmd);
         |                       ~~~~~~~~~~~~~~~~~~~~~~~      ^~~~~~~
   include/ufs/ufshcd.h:1331:5: note: 'ufshcd_uic_hibern8_exit' declared here
    1331 | int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
         |     ^                       ~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10342:44: warning: shift count >= width of type [-Wshift-count-overflow]
    10342 |                 if (!dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(64)))
          |                                                          ^~~~~~~~~~~~~~~~
   include/linux/dma-mapping.h:73:54: note: expanded from macro 'DMA_BIT_MASK'
      73 | #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
         |                                                      ^ ~~~
   1 warning and 1 error generated.


vim +/hba +4360 drivers/ufs/core/ufshcd.c

  4331	
  4332	/**
  4333	 * ufshcd_send_bsg_uic_cmd - Send UIC commands requested via BSG layer and retrieve the result
  4334	 * @hba: per adapter instance
  4335	 * @uic_cmd: UIC command
  4336	 *
  4337	 * Return: 0 only if success.
  4338	 */
  4339	int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
  4340	{
  4341		int ret;
  4342	
  4343		if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
  4344			return 0;
  4345	
  4346		ufshcd_hold(hba);
  4347	
  4348		if (uic_cmd->argument1 == UIC_ARG_MIB(PA_PWRMODE) &&
  4349		    uic_cmd->command == UIC_CMD_DME_SET) {
  4350			ret = ufshcd_uic_pwr_ctrl(hba, uic_cmd);
  4351			goto out;
  4352		}
  4353	
  4354		if (uic_cmd->command == UIC_CMD_DME_HIBER_ENTER) {
  4355			ret = ufshcd_uic_hibern8_enter(hba);
  4356			goto out;
  4357		}
  4358	
  4359		if (uic_cmd->command == UIC_CMD_DME_HIBER_EXIT) {
> 4360			ret = ufshcd_uic_hibern8_exit(hba, uic_cmd);
  4361			goto out;
  4362		}
  4363	
  4364		mutex_lock(&hba->uic_cmd_mutex);
  4365		ufshcd_add_delay_before_dme_cmd(hba);
  4366	
  4367		ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
  4368		if (!ret)
  4369			ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
  4370	
  4371		mutex_unlock(&hba->uic_cmd_mutex);
  4372	
  4373	out:
  4374		ufshcd_release(hba);
  4375		return ret;
  4376	}
  4377	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
