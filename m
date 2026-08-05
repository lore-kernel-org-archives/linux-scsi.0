Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAF43BCD05;
	Wed,  5 Aug 2026 22:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785968581; cv=none; b=BIvDiJNkfeyA8ztuD9aarc1iWu7eLn62VvH/qGyjnAPGai90obc3wRWk93IjKaopyU09QRlQWKu/wKwK9OZ3pyBSEYPIPDNszEJjS89k2+47mfJYiLrmxbhaTA+qSYjxuTy08Iax0xEbSM2iWdx655vaMf6cOmnE/Mbwi29dcEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785968581; c=relaxed/simple;
	bh=fYeX9sBmULBDC2u6zUcc37fkoRNrtqSQOpJ4mmrtqOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qCH2UOOTRoB/Fo9krby6/+dx03hLjMEGoCTr+GMYQTBHysc6EQrSFiGqwsJ/H+9wVNNf0+wiY3e/Dq5QvpZcWuwO7QQcqUq6ScyHkiH8HPPr0gVdIBpCfazFklkcUr7c5bPqffy0C9YjQvaDmQPCOGSEBQBM1QTcEBYxLxp9+wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oi1hm8bM; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oi1hm8bM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785968580; x=1817504580;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fYeX9sBmULBDC2u6zUcc37fkoRNrtqSQOpJ4mmrtqOA=;
  b=Oi1hm8bMGEXc2VlfSuL3jTBVEvrFMWFdisJirhg91+61RlOL6IDTWjLA
   1LxeX4+XHNoegGllmfUtqOp8Uv3bmIGIEpxcq50RQ3he5fbnRaPheFERI
   fJIgRFlTeU/mUaFU1l1pKpAewAEZPbaNPKpkXASZhUPcQKT4PHB+a61dd
   fF5ps3LtIFPtzv2edVgPgHgV5T12Ovka0ANBkm+c5B5rtVKPgaUdBiVpk
   Z60f/8X0AcBk3lvOIEqvgP383psp5CWKe+4E0nwConay3fCZeUeDDOnXk
   8ZR2ebKCBn+LZIc3tnUKhn8PkIY8ejpNL62mEwD8lNqha7p2ixbP7Kb7V
   A==;
X-CSE-ConnectionGUID: SeQWkpkfQH+ePw111VlTBA==
X-CSE-MsgGUID: OjFRQaBrRwiyTnRIAavwxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="103956708"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="103956708"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 15:22:59 -0700
X-CSE-ConnectionGUID: xmgdpI6XQTOY2UxV6Kc/EA==
X-CSE-MsgGUID: ORH0FegOTHuV8fCOdPFXnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="265773485"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 05 Aug 2026 15:22:57 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wrk0k-00000000DYv-3F2I;
	Wed, 05 Aug 2026 22:22:54 +0000
Date: Thu, 6 Aug 2026 06:22:29 +0800
From: kernel test robot <lkp@intel.com>
To: WenTao Liang <vulab@iscas.ac.cn>, James Bottomley <jejb@linux.ibm.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org, WenTao Liang <vulab@iscas.ac.cn>
Subject: Re: [PATCH] fix: scsi: srp_reconnect_rport: unbalanced
   scsi_block_targets/scsi_target_unblock
Message-ID: <202608060507.BrNCKCeH-lkp@intel.com>
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
config: alpha-allmodconfig (https://download.01.org/0day-ci/archive/20260806/202608060507.BrNCKCeH-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260806/202608060507.BrNCKCeH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608060507.BrNCKCeH-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/scsi/scsi_transport_srp.c: In function 'srp_reconnect_rport':
>> drivers/scsi/scsi_transport_srp.c:545:9: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
     545 |         if (rport->state != SRP_RPORT_FAIL_FAST && rport->state != SRP_RPORT_LOST)
         |         ^~
   drivers/scsi/scsi_transport_srp.c:553:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
     553 |                 blocked = true;
         |                 ^~~~~~~


vim +/if +545 drivers/scsi/scsi_transport_srp.c

29c17324803c8a Bart Van Assche 2013-10-26  509  
29c17324803c8a Bart Van Assche 2013-10-26  510  /**
29c17324803c8a Bart Van Assche 2013-10-26  511   * srp_reconnect_rport() - reconnect to an SRP target port
0c7f82189d2249 Bart Van Assche 2014-01-13  512   * @rport: SRP target port.
29c17324803c8a Bart Van Assche 2013-10-26  513   *
29c17324803c8a Bart Van Assche 2013-10-26  514   * Blocks SCSI command queueing before invoking reconnect() such that
29c17324803c8a Bart Van Assche 2013-10-26  515   * queuecommand() won't be invoked concurrently with reconnect() from outside
29c17324803c8a Bart Van Assche 2013-10-26  516   * the SCSI EH. This is important since a reconnect() implementation may
29c17324803c8a Bart Van Assche 2013-10-26  517   * reallocate resources needed by queuecommand().
29c17324803c8a Bart Van Assche 2013-10-26  518   *
29c17324803c8a Bart Van Assche 2013-10-26  519   * Notes:
29c17324803c8a Bart Van Assche 2013-10-26  520   * - This function neither waits until outstanding requests have finished nor
29c17324803c8a Bart Van Assche 2013-10-26  521   *   tries to abort these. It is the responsibility of the reconnect()
29c17324803c8a Bart Van Assche 2013-10-26  522   *   function to finish outstanding commands before reconnecting to the target
29c17324803c8a Bart Van Assche 2013-10-26  523   *   port.
29c17324803c8a Bart Van Assche 2013-10-26  524   * - It is the responsibility of the caller to ensure that the resources
29c17324803c8a Bart Van Assche 2013-10-26  525   *   reallocated by the reconnect() function won't be used while this function
29c17324803c8a Bart Van Assche 2013-10-26  526   *   is in progress. One possible strategy is to invoke this function from
29c17324803c8a Bart Van Assche 2013-10-26  527   *   the context of the SCSI EH thread only. Another possible strategy is to
29c17324803c8a Bart Van Assche 2013-10-26  528   *   lock the rport mutex inside each SCSI LLD callback that can be invoked by
29c17324803c8a Bart Van Assche 2013-10-26  529   *   the SCSI EH (the scsi_host_template.eh_*() functions and also the
29c17324803c8a Bart Van Assche 2013-10-26  530   *   scsi_host_template.queuecommand() function).
29c17324803c8a Bart Van Assche 2013-10-26  531   */
29c17324803c8a Bart Van Assche 2013-10-26  532  int srp_reconnect_rport(struct srp_rport *rport)
29c17324803c8a Bart Van Assche 2013-10-26  533  {
29c17324803c8a Bart Van Assche 2013-10-26  534  	struct Scsi_Host *shost = rport_to_shost(rport);
29c17324803c8a Bart Van Assche 2013-10-26  535  	struct srp_internal *i = to_srp_internal(shost->transportt);
29c17324803c8a Bart Van Assche 2013-10-26  536  	struct scsi_device *sdev;
29c17324803c8a Bart Van Assche 2013-10-26  537  	int res;
cc89c54580eff2 WenTao Liang    2026-06-27  538  	bool blocked = false;
29c17324803c8a Bart Van Assche 2013-10-26  539  
29c17324803c8a Bart Van Assche 2013-10-26  540  	pr_debug("SCSI host %s\n", dev_name(&shost->shost_gendev));
29c17324803c8a Bart Van Assche 2013-10-26  541  
29c17324803c8a Bart Van Assche 2013-10-26  542  	res = mutex_lock_interruptible(&rport->mutex);
29c17324803c8a Bart Van Assche 2013-10-26  543  	if (res)
29c17324803c8a Bart Van Assche 2013-10-26  544  		goto out;
5cd0f6f57639c5 Martin Wilck    2021-04-01 @545  	if (rport->state != SRP_RPORT_FAIL_FAST && rport->state != SRP_RPORT_LOST)
72eeb7c7151302 Martin Wilck    2021-01-11  546  		/*
72eeb7c7151302 Martin Wilck    2021-01-11  547  		 * sdev state must be SDEV_TRANSPORT_OFFLINE, transition
72eeb7c7151302 Martin Wilck    2021-01-11  548  		 * to SDEV_BLOCK is illegal. Calling scsi_target_unblock()
72eeb7c7151302 Martin Wilck    2021-01-11  549  		 * later is ok though, scsi_internal_device_unblock_nowait()
72eeb7c7151302 Martin Wilck    2021-01-11  550  		 * treats SDEV_TRANSPORT_OFFLINE like SDEV_BLOCK.
72eeb7c7151302 Martin Wilck    2021-01-11  551  		 */
31950192d939a9 Martin Wilck    2023-06-14  552  		scsi_block_targets(shost, &shost->shost_gendev);
cc89c54580eff2 WenTao Liang    2026-06-27  553  		blocked = true;
93079162bf0ed2 Bart Van Assche 2013-12-11  554  	res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
29c17324803c8a Bart Van Assche 2013-10-26  555  	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
29c17324803c8a Bart Van Assche 2013-10-26  556  		 dev_name(&shost->shost_gendev), rport->state, res);
29c17324803c8a Bart Van Assche 2013-10-26  557  	if (res == 0) {
29c17324803c8a Bart Van Assche 2013-10-26  558  		cancel_delayed_work(&rport->fast_io_fail_work);
29c17324803c8a Bart Van Assche 2013-10-26  559  		cancel_delayed_work(&rport->dev_loss_work);
29c17324803c8a Bart Van Assche 2013-10-26  560  
8c64e4531c3c3b Bart Van Assche 2013-10-26  561  		rport->failed_reconnects = 0;
29c17324803c8a Bart Van Assche 2013-10-26  562  		srp_rport_set_state(rport, SRP_RPORT_RUNNING);
cc89c54580eff2 WenTao Liang    2026-06-27  563  		if (blocked)
29c17324803c8a Bart Van Assche 2013-10-26  564  			scsi_target_unblock(&shost->shost_gendev, SDEV_RUNNING);
29c17324803c8a Bart Van Assche 2013-10-26  565  		/*
29c17324803c8a Bart Van Assche 2013-10-26  566  		 * If the SCSI error handler has offlined one or more devices,
29c17324803c8a Bart Van Assche 2013-10-26  567  		 * invoking scsi_target_unblock() won't change the state of
29c17324803c8a Bart Van Assche 2013-10-26  568  		 * these devices into running so do that explicitly.
29c17324803c8a Bart Van Assche 2013-10-26  569  		 */
0db6ca8a5e1ea5 Bart Van Assche 2017-06-02  570  		shost_for_each_device(sdev, shost) {
0db6ca8a5e1ea5 Bart Van Assche 2017-06-02  571  			mutex_lock(&sdev->state_mutex);
a817e73fe693f0 Linus Torvalds  2017-11-07  572  			if (sdev->sdev_state == SDEV_OFFLINE)
29c17324803c8a Bart Van Assche 2013-10-26  573  				sdev->sdev_state = SDEV_RUNNING;
0db6ca8a5e1ea5 Bart Van Assche 2017-06-02  574  			mutex_unlock(&sdev->state_mutex);
0db6ca8a5e1ea5 Bart Van Assche 2017-06-02  575  		}
29c17324803c8a Bart Van Assche 2013-10-26  576  	} else if (rport->state == SRP_RPORT_RUNNING) {
29c17324803c8a Bart Van Assche 2013-10-26  577  		/*
18cc4e02508e3f Bart Van Assche 2013-12-11  578  		 * srp_reconnect_rport() has been invoked with fast_io_fail
18cc4e02508e3f Bart Van Assche 2013-12-11  579  		 * and dev_loss off. Mark the port as failed and start the TL
18cc4e02508e3f Bart Van Assche 2013-12-11  580  		 * failure timers if these had not yet been started.
29c17324803c8a Bart Van Assche 2013-10-26  581  		 */
29c17324803c8a Bart Van Assche 2013-10-26  582  		__rport_fail_io_fast(rport);
29c17324803c8a Bart Van Assche 2013-10-26  583  		__srp_start_tl_fail_timers(rport);
29c17324803c8a Bart Van Assche 2013-10-26  584  	} else if (rport->state != SRP_RPORT_BLOCKED) {
cc89c54580eff2 WenTao Liang    2026-06-27  585  		if (blocked)
29c17324803c8a Bart Van Assche 2013-10-26  586  			scsi_target_unblock(&shost->shost_gendev,
29c17324803c8a Bart Van Assche 2013-10-26  587  				    SDEV_TRANSPORT_OFFLINE);
29c17324803c8a Bart Van Assche 2013-10-26  588  	}
29c17324803c8a Bart Van Assche 2013-10-26  589  	mutex_unlock(&rport->mutex);
29c17324803c8a Bart Van Assche 2013-10-26  590  
29c17324803c8a Bart Van Assche 2013-10-26  591  out:
29c17324803c8a Bart Van Assche 2013-10-26  592  	return res;
29c17324803c8a Bart Van Assche 2013-10-26  593  }
29c17324803c8a Bart Van Assche 2013-10-26  594  EXPORT_SYMBOL(srp_reconnect_rport);
29c17324803c8a Bart Van Assche 2013-10-26  595  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
