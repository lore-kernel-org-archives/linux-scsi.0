Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B397464;
	Sun, 20 Oct 2024 17:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729445342; cv=none; b=lY/qAFcLeJvnSk+EaweHKA1ENKkoYdgWGi7cwOiOdlXfpvp50fajl2+sGyYPRgNppPZfv9atnjDvvTQLO27591Ky+kkVU1ZEuRPi10QgW/q0I8LsjicZKDAGNGvfIWym/RAIYyon+D1XjD+a657UWPvkbj0xoaKFes6rO6rgzG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729445342; c=relaxed/simple;
	bh=ZFpeJTW6o3nZXfFtsddiGs4QMrRHL9LEcDKDRj7coeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NRf2cghoX1GpzkagXbV7DiMp2XQvfu7aJj0PfYC6L/I/kSzuUdF9NxQpGTt6JRgmhqR2uNOM6cc2qnh7tchjailJx99XDQIQKf0DpjxXhVV6/oLLhR0wPXrl7S5yA7AFWRmF5p5lKc2LTn2sYzR7a7De8l9xrQHRbwGmT53MSa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hZvrpdsD; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hZvrpdsD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729445340; x=1760981340;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZFpeJTW6o3nZXfFtsddiGs4QMrRHL9LEcDKDRj7coeo=;
  b=hZvrpdsDJoeVPsLk1QMUpbPsp7Umv6pfkyt+GfT0E3oY8wN1neDDcGr7
   r5i578KrBrMlaHYt0uVxV1pW909/w76rszR/HZncLD+opMNhk2OxoqXVe
   N4A8Z7UCNpu96Vq0vAFnu78UI0BLU67S/2FXp+HEVB0nwx1Cvg+LIDAII
   fdgmq8lmPbEFTIpKQ7J/EAtXh7WWjtJOIFYkl6Oh/yfr8spv0VCDntq7w
   wb89KEM7x2tGhlv8uTYjHUF/7MpQgteSjCOVvrpUgOiY21GeUetRbqr+s
   uzG78e2TlDzjvSFfFgQjEeKc9i7/0jQFUCbydd9Hb7Dq5TRilv4MQ+dJ0
   Q==;
X-CSE-ConnectionGUID: dK/2QCcqSk+a8XjsT8Zv5w==
X-CSE-MsgGUID: et/DhYNoRNCRTQ2GRC+mIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11231"; a="40289816"
X-IronPort-AV: E=Sophos;i="6.11,218,1725346800"; 
   d="scan'208";a="40289816"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 10:28:59 -0700
X-CSE-ConnectionGUID: Q9W9Bg7yR4iC1TdO2P1XuA==
X-CSE-MsgGUID: s4K+UJV7QiuWedauub2Ubg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,219,1725346800"; 
   d="scan'208";a="80131036"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 20 Oct 2024 10:28:56 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t2ZjZ-000QXJ-1q;
	Sun, 20 Oct 2024 17:28:53 +0000
Date: Mon, 21 Oct 2024 01:28:20 +0800
From: kernel test robot <lkp@intel.com>
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, arulponn@cisco.com,
	djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
	satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: Re: [PATCH v5 09/14] scsi: fnic: Modify IO path to use FDLS
Message-ID: <202410210147.fQp7tYeb-lkp@intel.com>
References: <20241018161409.4442-10-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018161409.4442-10-kartilak@cisco.com>

Hi Karan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[cannot apply to jejb-scsi/for-next linus/master v6.12-rc3 next-20241018]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Karan-Tilak-Kumar/scsi-fnic-Replace-shost_printk-with-dev_info-dev_err/20241019-002800
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241018161409.4442-10-kartilak%40cisco.com
patch subject: [PATCH v5 09/14] scsi: fnic: Modify IO path to use FDLS
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20241021/202410210147.fQp7tYeb-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241021/202410210147.fQp7tYeb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410210147.fQp7tYeb-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/fnic/fnic_scsi.c:269:15: warning: variable 'ioreq_count' set but not used [-Wunused-but-set-variable]
     269 |         unsigned int ioreq_count;
         |                      ^
   drivers/scsi/fnic/fnic_scsi.c:928:6: warning: variable 'xfer_len' set but not used [-Wunused-but-set-variable]
     928 |         u64 xfer_len = 0;
         |             ^
   drivers/scsi/fnic/fnic_scsi.c:2506:21: warning: variable 'fnic_stats' set but not used [-Wunused-but-set-variable]
    2506 |         struct fnic_stats *fnic_stats;
         |                            ^
   3 warnings generated.


vim +/ioreq_count +269 drivers/scsi/fnic/fnic_scsi.c

   258	
   259	
   260	/*
   261	 * fnic_fw_reset_handler
   262	 * Routine to send reset msg to fw
   263	 */
   264	int fnic_fw_reset_handler(struct fnic *fnic)
   265	{
   266		struct vnic_wq_copy *wq = &fnic->hw_copy_wq[0];
   267		int ret = 0;
   268		unsigned long flags;
 > 269		unsigned int ioreq_count;
   270	
   271		/* indicate fwreset to io path */
   272		fnic_set_state_flags(fnic, FNIC_FLAGS_FWRESET);
   273		ioreq_count = fnic_count_all_ioreqs(fnic);
   274	
   275		/* wait for io cmpl */
   276		while (atomic_read(&fnic->in_flight))
   277			schedule_timeout(msecs_to_jiffies(1));
   278	
   279		spin_lock_irqsave(&fnic->wq_copy_lock[0], flags);
   280	
   281		if (vnic_wq_copy_desc_avail(wq) <= fnic->wq_copy_desc_low[0])
   282			free_wq_copy_descs(fnic, wq, 0);
   283	
   284		if (!vnic_wq_copy_desc_avail(wq))
   285			ret = -EAGAIN;
   286		else {
   287			fnic_queue_wq_copy_desc_fw_reset(wq, SCSI_NO_TAG);
   288			atomic64_inc(&fnic->fnic_stats.fw_stats.active_fw_reqs);
   289			if (atomic64_read(&fnic->fnic_stats.fw_stats.active_fw_reqs) >
   290				  atomic64_read(&fnic->fnic_stats.fw_stats.max_fw_reqs))
   291				atomic64_set(&fnic->fnic_stats.fw_stats.max_fw_reqs,
   292					atomic64_read(
   293					  &fnic->fnic_stats.fw_stats.active_fw_reqs));
   294		}
   295	
   296		spin_unlock_irqrestore(&fnic->wq_copy_lock[0], flags);
   297	
   298		if (!ret) {
   299			atomic64_inc(&fnic->fnic_stats.reset_stats.fw_resets);
   300			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
   301					"Issued fw reset\n");
   302		} else {
   303			fnic_clear_state_flags(fnic, FNIC_FLAGS_FWRESET);
   304			FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
   305					"Failed to issue fw reset\n");
   306		}
   307	
   308		return ret;
   309	}
   310	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
