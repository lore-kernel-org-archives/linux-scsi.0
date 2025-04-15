Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF6C19F422;
	Tue, 15 Apr 2025 13:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744725314; cv=none; b=IplZVKGSuJJzHpRFtGtANn1bORrJOVE2ciflgB3wysc6eJCPVILlvozBsImY/QSa0k1RkaFq7z3lh4SPRaUFcF47hsK/1gl0G+wFcoO75GTjMf5eN3Zr3mzs3N4S6rMmBt6jxKNic12Na9uwScWmX5ghzdnaJKv8S4OV3MidTFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744725314; c=relaxed/simple;
	bh=755NGgblQW9HkSMmzLZEBTgNnlFCcB7cI0M7GpYpsTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a+SMf34SI7OzyQHYKjGTCual8MAyAzjtxQLrTYDwk52KTXZfWFqE83yAQJTC+D5QIzBpgOoH+NFKyhVe28y0ttKo1SS6YmLiIy5nb6Ig9OiTPtavbiLDooGj12qmmH77kNYf9VQwvGig3x+IGXC9plmhszDFvTJam/+LTW++chE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sth2R2Ly; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sth2R2Ly"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744725312; x=1776261312;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=755NGgblQW9HkSMmzLZEBTgNnlFCcB7cI0M7GpYpsTQ=;
  b=Sth2R2Lyivx2TL1+doXjCj4uW83pxPEGnxd7CUS6SB7cjFJ2XfQUGs5N
   l9Ua2wZ1gWU1sMQMt6eCEnD0ZDRZTA5qeSjRwBG4v3bwCRK9dxyBvkpa6
   z9wSiEcKG9oKDk45iigHmnNqDamTPi/eHWy2Wki02IwjlMXX0n44WbMH9
   mUfENq/KWB8udiD82jL+KBZ0CLUKTCzWIiSHCmKv/v3ch6rQh0bU5g1uy
   BgT2GrYxZLKsq1mzNnsYY8U1X59BBT0tW9yMd0cBum8khQxRr8OZSURbU
   324lqfYkIOgyJMTc9asSbSvLs7z6M/hT4cuNFInwpeQkIHzASNBiX7qXL
   g==;
X-CSE-ConnectionGUID: BPryvVwPROqKAs35JpLsAQ==
X-CSE-MsgGUID: ieyt3azQTXOxAGzs4utYHA==
X-IronPort-AV: E=McAfee;i="6700,10204,11404"; a="46124380"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="46124380"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 06:55:09 -0700
X-CSE-ConnectionGUID: uxfaW6T8QYaTnAcbc4WFVQ==
X-CSE-MsgGUID: FouCYPlFSgukV2pkoOZSUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="135308407"
Received: from lkp-server01.sh.intel.com (HELO b207828170a5) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 15 Apr 2025 06:55:07 -0700
Received: from kbuild by b207828170a5 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u4gkj-000GFC-1S;
	Tue, 15 Apr 2025 13:55:05 +0000
Date: Tue, 15 Apr 2025 21:54:22 +0800
From: kernel test robot <lkp@intel.com>
To: Arthur Simchaev <arthur.simchaev@sandisk.com>
Cc: oe-kbuild-all@lists.linux.dev, avri.altman@sandisk.com,
	Avi.Shchislowski@sandisk.com, beanhuo@micron.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org
Subject: Re: [PATCH v2] ufs: bsg: Add hibern8 enter/exit to
 ufshcd_send_bsg_uic_cmd
Message-ID: <202504152111.1Huykiqb-lkp@intel.com>
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
config: s390-randconfig-002-20250415 (https://download.01.org/0day-ci/archive/20250415/202504152111.1Huykiqb-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 7.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250415/202504152111.1Huykiqb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504152111.1Huykiqb-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/ufs/core/ufshcd.c: In function 'ufshcd_send_bsg_uic_cmd':
>> drivers/ufs/core/ufshcd.c:4360:9: error: too many arguments to function 'ufshcd_uic_hibern8_exit'
      ret = ufshcd_uic_hibern8_exit(hba, uic_cmd);
            ^~~~~~~~~~~~~~~~~~~~~~~
   In file included from drivers/ufs/core/ufshcd-priv.h:7:0,
                    from drivers/ufs/core/ufshcd.c:31:
   include/ufs/ufshcd.h:1331:5: note: declared here
    int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
        ^~~~~~~~~~~~~~~~~~~~~~~


vim +/ufshcd_uic_hibern8_exit +4360 drivers/ufs/core/ufshcd.c

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
