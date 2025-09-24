Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E3D1F3BBB
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 12:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758717369; cv=none; b=LoUeC5gyNcqhTYjxRwix/HWzZEPirpLldrtbzIv+27XbuP3X57NMbZTR6P4CGhEqpwfddZk4ekZsAUcFPrOeaWpwpCsAhnJMV7GOdOJN3S8VAWC3siNdMaqSngDp3XNZcQQrN8aCbXn+ma4T6nqDIUnRM/NFUSWTdDLNmndbBxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758717369; c=relaxed/simple;
	bh=X5sdtRbqfRqOKgZRQ4qMnFy5pSpg8b0I3voFv146QK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NHX7B5vgQPQB0DhF3GjlF36ZdU183deRCN8Idj9eGtMAVZDb9FQ6I6wdF3W9TxrQfTrkYP7fqkhv8wfiwJx6p+uv3tP1rbMrjN0XqJLWlijNp2XD2OAdzg0gFVouPt9/XE45cjCZPA7edfBCGfFinZS29EgUYgQ2zzj56j00XQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ROiOdqYl; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ROiOdqYl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758717368; x=1790253368;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X5sdtRbqfRqOKgZRQ4qMnFy5pSpg8b0I3voFv146QK0=;
  b=ROiOdqYlh86UAt8cq3Suoo6qrWFSxXb5JCTmPv4XVvUAMPusowiAQzdp
   TJ+wdGCcnQqvAiU6x/4yLfvh/rRBZYOSobqyKzUQ8xXZzFyaO+ruM937z
   55SSFWcPtdP3FXjjA6qEy5DbQHANNW0EkdxwX8GRI7BHJlXmP0rK2d9NP
   ivjoRfjaarGKnpR+t0Hv70ZaH4bpnBsWkT5fUhqvymfP68KPXaIlLuP2B
   UWlMDA0BDLmzBRaW59AtB5mdeNZLcqGpqGGPp+bP/hJSfgjmj5p77+/D1
   MNtvV4MGGlW1jM50LG04d32YEpIzN2gklUiD7M9eMMGloCYOFQVFKdsBj
   w==;
X-CSE-ConnectionGUID: Xwf/aRNCSl21DnwEyneZOg==
X-CSE-MsgGUID: 7RUwd6raRP2U4mz+ccm+Ig==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="72113588"
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="72113588"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 05:36:07 -0700
X-CSE-ConnectionGUID: j3MuAqXlQJCBVs+Zc2Fykw==
X-CSE-MsgGUID: q0OCaGtzReuxvcJr5AO4nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="176147230"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 24 Sep 2025 05:36:05 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v1Oj4-00048T-25;
	Wed, 24 Sep 2025 12:36:02 +0000
Date: Wed, 24 Sep 2025 20:36:02 +0800
From: kernel test robot <lkp@intel.com>
To: doubled <doubled@leap-io-kernel.com>,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: leapraid: Add new scsi driver
Message-ID: <202509242058.b5d4n6HN-lkp@intel.com>
References: <20250919100032.3931476-1-doubled@leap-io-kernel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919100032.3931476-1-doubled@leap-io-kernel.com>

Hi doubled,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.17-rc7 next-20250923]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/doubled/scsi-leapraid-Add-new-scsi-driver/20250919-202535
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250919100032.3931476-1-doubled%40leap-io-kernel.com
patch subject: [PATCH] scsi: leapraid: Add new scsi driver
config: sparc64-randconfig-r072-20250922 (https://download.01.org/0day-ci/archive/20250924/202509242058.b5d4n6HN-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.5.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509242058.b5d4n6HN-lkp@intel.com/

smatch warnings:
drivers/scsi/leapraid/leapraid_func.c:7225 leapraid_set_msix() warn: inconsistent indenting
drivers/scsi/leapraid/leapraid_func.c:7797 leapraid_request_host_memory() warn: missing unwind goto?
drivers/scsi/leapraid/leapraid_func.c:7797 leapraid_request_host_memory() warn: missing unwind goto?
drivers/scsi/leapraid/leapraid_func.c:8271 leapraid_cfg_pages() warn: missing error code? 'rc'
drivers/scsi/leapraid/leapraid_func.c:8530 leapraid_make_adapter_available() warn: missing error code? 'rc'

vim +7225 drivers/scsi/leapraid/leapraid_func.c

  7166	
  7167	static int
  7168	leapraid_set_msix(struct leapraid_adapter *adapter)
  7169	{
  7170		int iopoll_qcnt = 0;
  7171		int msix_cnt, i, rc;
  7172	
  7173		if (msix_disable == 1)
  7174			goto legacy_int;
  7175	
  7176		msix_cnt = leapraid_msix_cnt(adapter->pdev);
  7177		if (msix_cnt <= 0) {
  7178			dev_info(&adapter->pdev->dev,
  7179				 "msix unsupported!\n");
  7180			goto legacy_int;
  7181		}
  7182	
  7183		if (reset_devices)
  7184			adapter->adapter_attr.rq_cnt = 1;
  7185		else
  7186			adapter->adapter_attr.rq_cnt = min_t(int,
  7187				 num_online_cpus(), msix_cnt);
  7188	
  7189		if (max_msix_vectors > 0)
  7190			adapter->adapter_attr.rq_cnt = min_t(int, max_msix_vectors,
  7191				 adapter->adapter_attr.rq_cnt);
  7192	
  7193		if (adapter->adapter_attr.rq_cnt <= 1)
  7194			adapter->shost->host_tagset = 0;
  7195		if (adapter->shost->host_tagset) {
  7196			iopoll_qcnt = poll_queues;
  7197			if (iopoll_qcnt >= adapter->adapter_attr.rq_cnt)
  7198				iopoll_qcnt = 0;
  7199		}
  7200	
  7201		if (iopoll_qcnt) {
  7202			adapter->notification_desc.blk_mq_poll_rqs =
  7203				 kcalloc(iopoll_qcnt,
  7204				 sizeof(struct leapraid_blk_mq_poll_rq), GFP_KERNEL);
  7205			if (!adapter->notification_desc.blk_mq_poll_rqs)
  7206				return -ENOMEM;
  7207			adapter->adapter_attr.rq_cnt =
  7208				 min(adapter->adapter_attr.rq_cnt +
  7209					 iopoll_qcnt, msix_cnt);
  7210		}
  7211	
  7212		adapter->notification_desc.iopoll_qdex =
  7213			 adapter->adapter_attr.rq_cnt - iopoll_qcnt;
  7214	
  7215		adapter->notification_desc.iopoll_qcnt = iopoll_qcnt;
  7216		dev_info(&adapter->pdev->dev,
  7217			 "MSIx: req queue cnt=%d, intr=%d/poll=%d rep queues!\n",
  7218			 adapter->adapter_attr.rq_cnt,
  7219			 adapter->notification_desc.iopoll_qdex,
  7220			 adapter->notification_desc.iopoll_qcnt);
  7221	
  7222			 adapter->notification_desc.int_rqs =
  7223			 kcalloc(adapter->notification_desc.iopoll_qdex,
  7224			 sizeof(struct leapraid_int_rq), GFP_KERNEL);
> 7225		if (!adapter->notification_desc.int_rqs) {
  7226			dev_err(&adapter->pdev->dev,
  7227				 "MSIx: allocate %d interrupt reply queues failed!\n",
  7228				 adapter->notification_desc.iopoll_qdex);
  7229			return -ENOMEM;
  7230		}
  7231	
  7232		for (i = 0; i < adapter->notification_desc.iopoll_qcnt; i++) {
  7233			adapter->notification_desc.blk_mq_poll_rqs[i].rq.adapter
  7234				 = adapter;
  7235			adapter->notification_desc.blk_mq_poll_rqs[i].rq.msix_idx =
  7236				 i + adapter->notification_desc.iopoll_qdex;
  7237			atomic_set(
  7238				&adapter->notification_desc.blk_mq_poll_rqs[i].rq.busy,
  7239					 0);
  7240			snprintf(adapter->notification_desc.blk_mq_poll_rqs[i].rq.name,
  7241				 LEAPRAID_NAME_LENGTH,
  7242				 "%s%u-MQ-Poll%u", LEAPRAID_DRIVER_NAME,
  7243				 adapter->adapter_attr.id, i);
  7244			atomic_set(&adapter->notification_desc.blk_mq_poll_rqs[i].busy,
  7245				 0);
  7246			atomic_set(
  7247				&adapter->notification_desc.blk_mq_poll_rqs[i].pause,
  7248				 0);
  7249		}
  7250	
  7251		adapter->notification_desc.msix_cpu_map_sz =
  7252			 num_online_cpus();
  7253		adapter->notification_desc.msix_cpu_map =
  7254			 kzalloc(adapter->notification_desc.msix_cpu_map_sz,
  7255				 GFP_KERNEL);
  7256		if (!adapter->notification_desc.msix_cpu_map)
  7257			return -ENOMEM;
  7258		memset(adapter->notification_desc.msix_cpu_map, 0,
  7259			 adapter->notification_desc.msix_cpu_map_sz);
  7260	
  7261		adapter->notification_desc.msix_enable = true;
  7262		rc = leapraid_setup_irqs(adapter);
  7263		if (rc) {
  7264			leapraid_free_irq(adapter);
  7265			adapter->notification_desc.msix_enable = false;
  7266			goto legacy_int;
  7267		}
  7268	
  7269		return 0;
  7270	
  7271	legacy_int:
  7272		rc = leapraid_set_legacy_int(adapter);
  7273	
  7274		return rc;
  7275	}
  7276	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
