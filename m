Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C06F377A9F;
	Thu,  6 Aug 2026 00:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785976537; cv=none; b=UcJp80w5PZ2BVTFP/tINMep7wKNxxGPtFvICNbICtWUvRJ4tla/L/noWYQeyWqa8Y1VFXX3EPd+QDBXLvV2CNH6PrKytTuyKCChhkRWaZNzDdMqaZKAZk0QVZpZgmHEjvCQSwmRp6ufzOmQ3SazF6qeQZW6MW70IzdN63kHjC5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785976537; c=relaxed/simple;
	bh=MekGOkkgPmWP77iofoVqhciqMISUKEaV3fVaVM/Rpxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eUQAyMuP32UeYCi9DvC1w8uwa6Zjg4PeplJx3yjM7ag40y0891upWQQOpTNIvWXmUfJWEM2MBa5ysi6C0ATmTPrB1HlIuEFU9uJd2fpWcsW8BAv3fjUL9BsdSjVC5UILiHwj2wAQNwtv8pjOHsKI+tJ8zm9YLUu/kFRadL8rCgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e+lJRdkd; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e+lJRdkd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785976535; x=1817512535;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MekGOkkgPmWP77iofoVqhciqMISUKEaV3fVaVM/Rpxg=;
  b=e+lJRdkdLVpNWk/Fig6cciKPTehcIWLa5o4ynQ5KbLIJWQqQ5Mv4op/p
   Iqxg+IXn4TXih9+u3w4e6ZrTrOhPyTzCoqUr1Li+7quMMkcA2W6UJRcmG
   UZzUXTTl+/Jelr7vz1VJB/WFlJQkmw/vMnCakI+rqAqT10trgoIcTKn6Q
   iUx2iiNj+MuzMxlr7rw9EykvjYez9u3ghpM7B6O3rmV/Bv5ik8RucF9dW
   JAfw3rzYYT41I/3xkv5+aByoj9JWcrzP/gy2of+1UxjBwfLhfRkmzf0Sm
   wXsSYGTc7w1dCiPTg2OwPdB6SsJQ8tJEhmYamlgwj2NZVZlAecHM+pCST
   Q==;
X-CSE-ConnectionGUID: RmccD81/RMai4vFBj0BJtg==
X-CSE-MsgGUID: nUlzTa19SYyO61hEssalzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="86333365"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="86333365"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 17:35:34 -0700
X-CSE-ConnectionGUID: 7rI+GjarRiOc+dPX3KpAvw==
X-CSE-MsgGUID: RkY0MrcNQWqcq1LB2nGfOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="260177570"
Received: from igk-lkp-server01.igk.intel.com (HELO 3cba2a188a06) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 05 Aug 2026 17:35:32 -0700
Received: from kbuild by 3cba2a188a06 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wrm53-000000004Wc-35NL;
	Thu, 06 Aug 2026 00:35:29 +0000
Date: Thu, 6 Aug 2026 02:35:24 +0200
From: kernel test robot <lkp@intel.com>
To: WenTao Liang <vulab@iscas.ac.cn>, James Bottomley <jejb@linux.ibm.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	stable@vger.kernel.org, linux-kernel@vger.kernel.org,
	WenTao Liang <vulab@iscas.ac.cn>
Subject: Re: [PATCH] fix: scsi: srp_reconnect_rport: unbalanced
   scsi_block_targets/scsi_target_unblock
Message-ID: <202608060245.Qn5OJAhT-lkp@intel.com>
References: <20260626161402.55116-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626161402.55116-1-vulab@iscas.ac.cn>

Hi WenTao,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v7.2-rc6 next-20260805]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/WenTao-Liang/fix-scsi-srp_reconnect_rport-unbalanced-scsi_block_targets-scsi_target_unblock/20260805-214818
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260626161402.55116-1-vulab%40iscas.ac.cn
patch subject: [PATCH] fix: scsi: srp_reconnect_rport: unbalanced   scsi_block_targets/scsi_target_unblock
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260806/202608060245.Qn5OJAhT-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260806/202608060245.Qn5OJAhT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608060245.Qn5OJAhT-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/scsi_transport_srp.c:553:3: warning: misleading indentation; statement is not part of the previous 'if' [-Wmisleading-indentation]
     553 |                 blocked = true;
         |                 ^
   drivers/scsi/scsi_transport_srp.c:545:2: note: previous statement is here
     545 |         if (rport->state != SRP_RPORT_FAIL_FAST && rport->state != SRP_RPORT_LOST)
         |         ^
   1 warning generated.


vim +/if +553 drivers/scsi/scsi_transport_srp.c

   509	
   510	/**
   511	 * srp_reconnect_rport() - reconnect to an SRP target port
   512	 * @rport: SRP target port.
   513	 *
   514	 * Blocks SCSI command queueing before invoking reconnect() such that
   515	 * queuecommand() won't be invoked concurrently with reconnect() from outside
   516	 * the SCSI EH. This is important since a reconnect() implementation may
   517	 * reallocate resources needed by queuecommand().
   518	 *
   519	 * Notes:
   520	 * - This function neither waits until outstanding requests have finished nor
   521	 *   tries to abort these. It is the responsibility of the reconnect()
   522	 *   function to finish outstanding commands before reconnecting to the target
   523	 *   port.
   524	 * - It is the responsibility of the caller to ensure that the resources
   525	 *   reallocated by the reconnect() function won't be used while this function
   526	 *   is in progress. One possible strategy is to invoke this function from
   527	 *   the context of the SCSI EH thread only. Another possible strategy is to
   528	 *   lock the rport mutex inside each SCSI LLD callback that can be invoked by
   529	 *   the SCSI EH (the scsi_host_template.eh_*() functions and also the
   530	 *   scsi_host_template.queuecommand() function).
   531	 */
   532	int srp_reconnect_rport(struct srp_rport *rport)
   533	{
   534		struct Scsi_Host *shost = rport_to_shost(rport);
   535		struct srp_internal *i = to_srp_internal(shost->transportt);
   536		struct scsi_device *sdev;
   537		int res;
   538		bool blocked = false;
   539	
   540		pr_debug("SCSI host %s\n", dev_name(&shost->shost_gendev));
   541	
   542		res = mutex_lock_interruptible(&rport->mutex);
   543		if (res)
   544			goto out;
   545		if (rport->state != SRP_RPORT_FAIL_FAST && rport->state != SRP_RPORT_LOST)
   546			/*
   547			 * sdev state must be SDEV_TRANSPORT_OFFLINE, transition
   548			 * to SDEV_BLOCK is illegal. Calling scsi_target_unblock()
   549			 * later is ok though, scsi_internal_device_unblock_nowait()
   550			 * treats SDEV_TRANSPORT_OFFLINE like SDEV_BLOCK.
   551			 */
   552			scsi_block_targets(shost, &shost->shost_gendev);
 > 553			blocked = true;
   554		res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
   555		pr_debug("%s (state %d): transport.reconnect() returned %d\n",
   556			 dev_name(&shost->shost_gendev), rport->state, res);
   557		if (res == 0) {
   558			cancel_delayed_work(&rport->fast_io_fail_work);
   559			cancel_delayed_work(&rport->dev_loss_work);
   560	
   561			rport->failed_reconnects = 0;
   562			srp_rport_set_state(rport, SRP_RPORT_RUNNING);
   563			if (blocked)
   564				scsi_target_unblock(&shost->shost_gendev, SDEV_RUNNING);
   565			/*
   566			 * If the SCSI error handler has offlined one or more devices,
   567			 * invoking scsi_target_unblock() won't change the state of
   568			 * these devices into running so do that explicitly.
   569			 */
   570			shost_for_each_device(sdev, shost) {
   571				mutex_lock(&sdev->state_mutex);
   572				if (sdev->sdev_state == SDEV_OFFLINE)
   573					sdev->sdev_state = SDEV_RUNNING;
   574				mutex_unlock(&sdev->state_mutex);
   575			}
   576		} else if (rport->state == SRP_RPORT_RUNNING) {
   577			/*
   578			 * srp_reconnect_rport() has been invoked with fast_io_fail
   579			 * and dev_loss off. Mark the port as failed and start the TL
   580			 * failure timers if these had not yet been started.
   581			 */
   582			__rport_fail_io_fast(rport);
   583			__srp_start_tl_fail_timers(rport);
   584		} else if (rport->state != SRP_RPORT_BLOCKED) {
   585			if (blocked)
   586				scsi_target_unblock(&shost->shost_gendev,
   587					    SDEV_TRANSPORT_OFFLINE);
   588		}
   589		mutex_unlock(&rport->mutex);
   590	
   591	out:
   592		return res;
   593	}
   594	EXPORT_SYMBOL(srp_reconnect_rport);
   595	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
