Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492AC1E868;
	Sun, 29 Sep 2024 13:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727615617; cv=none; b=Fm4R3K407QXxaIc6WwzROSgtLzWdttmb9MqiGqNZZi2zFEFzLp7djvbGXEvQH0/4foHlm7/WLvtwBWOvfTU3dEvG6N6nFMwnDkOyv76d4A2JTj/CWM8FdiFNGSCbBCrJn1a2UJtGravhLpjJj1tUwYDKRIE0aZHtsracXaRuGfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727615617; c=relaxed/simple;
	bh=3F7xFSUGK/sZ4Xmlcg3e1EhoVv0SD/q3Pk0km8pPHFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V4M1lOa2sTVSmCWHQs4m2pCyJ18zBOqZD21Lcn501xHRXuPAZwe/t3wiGGjL+CyTELbqIP/UdyeSWXEI9da/aZ4kyOf7eiRolr6JBGxS8UyFpeh1Q6AfdqFES8Kgux8UIcOr1Xw5sQnEHV0azZtZIoh+cuscAf3xW1u1iZwsr9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mA6OjPds; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mA6OjPds"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727615614; x=1759151614;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3F7xFSUGK/sZ4Xmlcg3e1EhoVv0SD/q3Pk0km8pPHFg=;
  b=mA6OjPdsBjs8Qpo8Ve7Ec6REkMrnmZHEestwkAbQ2Jvszu6rM2LMyK9C
   rOrTnXpID/X7Au2KTt9bit4JJFWRIPZ+RctfYSpGTMyFY7F6X7vpSydiJ
   rxuYt44Z1KFSOPyC5nDX8g8OUERA5H2MkEMFvyN2/2cbcziy6b8GECIqb
   849eaD2DPlFIDfeWCJglUliqI5cvStrWNX7xMCLTM/wvYZZN4VI2J97TB
   V226IA5NQZVCq6kkOOEJJjlYJt48nj8fr51hEV1roVjsylda5S1uSpwY8
   C8P26O17iR6f3dFC0XLQ4iD3/aPs+vNaLmxSP2zRaZTMQYT7cvR2Ji3Qm
   A==;
X-CSE-ConnectionGUID: tzGBevkXThCl88h3swmvgQ==
X-CSE-MsgGUID: 4Zagzan4TZiLmaTyKIU8dw==
X-IronPort-AV: E=McAfee;i="6700,10204,11209"; a="29588741"
X-IronPort-AV: E=Sophos;i="6.11,163,1725346800"; 
   d="scan'208";a="29588741"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2024 06:13:33 -0700
X-CSE-ConnectionGUID: uiNVnPNkRKW0RuUvboYcfQ==
X-CSE-MsgGUID: ObDZashbSnqzIpS9YNS0xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,163,1725346800"; 
   d="scan'208";a="72892994"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 29 Sep 2024 06:13:30 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sutjr-000OIv-2Q;
	Sun, 29 Sep 2024 13:13:27 +0000
Date: Sun, 29 Sep 2024 21:13:19 +0800
From: kernel test robot <lkp@intel.com>
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, arulponn@cisco.com,
	djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
	satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: Re: [PATCH v3 08/14] scsi: fnic: Add functionality in fnic to
 support FDLS
Message-ID: <202409292037.ZYWZwIK6-lkp@intel.com>
References: <20240927184613.52172-9-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240927184613.52172-9-kartilak@cisco.com>

Hi Karan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.11 next-20240927]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Karan-Tilak-Kumar/scsi-fnic-Replace-shost_printk-with-dev_info-dev_err/20240928-025906
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240927184613.52172-9-kartilak%40cisco.com
patch subject: [PATCH v3 08/14] scsi: fnic: Add functionality in fnic to support FDLS
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20240929/202409292037.ZYWZwIK6-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240929/202409292037.ZYWZwIK6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409292037.ZYWZwIK6-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/fnic/fnic_scsi.c:2618:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
    2618 |         if (fnic->link_status) {
         |             ^~~~~~~~~~~~~~~~~
   drivers/scsi/fnic/fnic_scsi.c:2637:9: note: uninitialized use occurs here
    2637 |         return ret;
         |                ^~~
   drivers/scsi/fnic/fnic_scsi.c:2618:2: note: remove the 'if' if its condition is always true
    2618 |         if (fnic->link_status) {
         |         ^~~~~~~~~~~~~~~~~~~~~~
   drivers/scsi/fnic/fnic_scsi.c:2580:9: note: initialize the variable 'ret' to silence this warning
    2580 |         int ret;
         |                ^
         |                 = 0
   1 warning generated.
--
>> drivers/scsi/fnic/fnic_fcs.c:1031: warning: expecting prototype for fnic_tport_work(). Prototype was for fnic_tport_event_handler() instead


vim +2618 drivers/scsi/fnic/fnic_scsi.c

  2568	
  2569	/*
  2570	 * SCSI Error handling calls driver's eh_host_reset if all prior
  2571	 * error handling levels return FAILED. If host reset completes
  2572	 * successfully, and if link is up, then Fabric login begins.
  2573	 *
  2574	 * Host Reset is the highest level of error recovery. If this fails, then
  2575	 * host is offlined by SCSI.
  2576	 *
  2577	 */
  2578	int fnic_host_reset(struct Scsi_Host *shost)
  2579	{
  2580		int ret;
  2581		unsigned long wait_host_tmo;
  2582		struct fnic *fnic = *((struct fnic **) shost_priv(shost));
  2583		unsigned long flags;
  2584		struct fnic_iport_s *iport = &fnic->iport;
  2585	
  2586		spin_lock_irqsave(&fnic->fnic_lock, flags);
  2587		if (fnic->reset_in_progress == NOT_IN_PROGRESS) {
  2588			fnic->reset_in_progress = IN_PROGRESS;
  2589		} else {
  2590			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
  2591			wait_for_completion_timeout(&fnic->reset_completion_wait,
  2592										msecs_to_jiffies(10000));
  2593	
  2594			spin_lock_irqsave(&fnic->fnic_lock, flags);
  2595			if (fnic->reset_in_progress == IN_PROGRESS) {
  2596				spin_unlock_irqrestore(&fnic->fnic_lock, flags);
  2597				FNIC_SCSI_DBG(KERN_WARNING, fnic->lport->host, fnic->fnic_num,
  2598				  "Firmware reset in progress. Skipping another host reset\n");
  2599				return SUCCESS;
  2600			}
  2601			fnic->reset_in_progress = IN_PROGRESS;
  2602		}
  2603		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
  2604	
  2605		/*
  2606		 * If fnic_reset is successful, wait for fabric login to complete
  2607		 * scsi-ml tries to send a TUR to every device if host reset is
  2608		 * successful, so before returning to scsi, fabric should be up
  2609		 */
  2610		fnic_reset(shost);
  2611	
  2612		spin_lock_irqsave(&fnic->fnic_lock, flags);
  2613		fnic->reset_in_progress = NOT_IN_PROGRESS;
  2614		complete(&fnic->reset_completion_wait);
  2615		fnic->soft_reset_count++;
  2616	
  2617		/* wait till the link is up */
> 2618		if (fnic->link_status) {
  2619			wait_host_tmo = jiffies + FNIC_HOST_RESET_SETTLE_TIME * HZ;
  2620			ret = FAILED;
  2621			while (time_before(jiffies, wait_host_tmo)) {
  2622				if (iport->state != FNIC_IPORT_STATE_READY
  2623					&& fnic->link_status) {
  2624					spin_unlock_irqrestore(&fnic->fnic_lock, flags);
  2625					ssleep(1);
  2626					spin_lock_irqsave(&fnic->fnic_lock, flags);
  2627				} else {
  2628					ret = SUCCESS;
  2629					break;
  2630				}
  2631			}
  2632		}
  2633		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
  2634	
  2635		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  2636					  "host reset return status: %d\n", ret);
  2637		return ret;
  2638	}
  2639	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
