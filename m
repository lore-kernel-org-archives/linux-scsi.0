Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A430E154420;
	Fri, 28 Jun 2024 16:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719592383; cv=none; b=C6HubA9AH7HK6MT+QZH0bOTnoCLVm9seYdbK6IgP6pprEjnjJVVQiIVuy8xGq+QbUAaIZmNlmQ4XcKZ7R86XbCQ2uhEQC71FebI4l7gagtunVuRmOkKLbWo0O3SaNGtfcf/qbKUcU7bo7qZfUHUJKWjTE3LSeLRHWYCnp57XiGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719592383; c=relaxed/simple;
	bh=UziAVxGIMxKimVIvWEEoSCI3IvuFy9O2kjXtnQXXDzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GL4cROj3Rkho8Tn0Zxu0uUSrlzzKlkmoC2YN32c4zoJvvpWOXeJ2c29JC0glKPhlfP4vJrtzm2yaaqhUuUdv76S6ryqSZG5Y6+MQXJ3QKzBfWyeW3G5c4I9IHy/bWbVEI+NJXHl0K4dihAPHYwvRzevZMSPo193EDKxvMWLsE/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qm81/sWK; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qm81/sWK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719592382; x=1751128382;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UziAVxGIMxKimVIvWEEoSCI3IvuFy9O2kjXtnQXXDzM=;
  b=Qm81/sWKrmFsBaHzgE2p8fLGmd87Od+LY4LUEmdS76vFyTaHu8Eskjmf
   Rz10fJQ21Vvq+n/ceSBXGG4B0mLFCDJtF0v+xhjnIy84zQfpY8STppKdd
   4oS3NdeOIsyJMRvD+lQzxghKclb2PufvS8VyRk9YUn971vlWRr6lyKK22
   DB+hQZ1mP1+vi6snOTuZRjWowbjOt1cxCCynSgkNh3NeyGFKK/eI3HD5y
   wD003dC/SIOuc1kVEfYhf9s2rEnIQSMRMyWzr/mylvT9QERRXERYwn0Tl
   1YXKPuVpAojDHjtLbjiex5CBIH27lU72cZevrH/xHqIYuP3mqoQcR7Wiu
   Q==;
X-CSE-ConnectionGUID: f395nVZXQW28M7ZbLZYshw==
X-CSE-MsgGUID: LZtZ+9KdTtm2m+AC0I8r5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="16457624"
X-IronPort-AV: E=Sophos;i="6.09,169,1716274800"; 
   d="scan'208";a="16457624"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 09:33:01 -0700
X-CSE-ConnectionGUID: PjH0WufYSg2TMeOvv/BMKA==
X-CSE-MsgGUID: iBTfl+UnRi+7HD2djoy5ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,169,1716274800"; 
   d="scan'208";a="44904378"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 28 Jun 2024 09:32:58 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sNEWu-000HOn-1c;
	Fri, 28 Jun 2024 16:32:56 +0000
Date: Sat, 29 Jun 2024 00:31:57 +0800
From: kernel test robot <lkp@intel.com>
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 11/13] ata: libata-core: Reuse available ata_port
 print_ids
Message-ID: <202406290027.cdgsPQAF-lkp@intel.com>
References: <20240626180031.4050226-26-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626180031.4050226-26-cassel@kernel.org>

Hi Niklas,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.10-rc5 next-20240627]
[cannot apply to mkp-scsi/for-next jejb-scsi/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Niklas-Cassel/ata-libata-core-Fix-null-pointer-dereference-on-error/20240627-123023
base:   linus/master
patch link:    https://lore.kernel.org/r/20240626180031.4050226-26-cassel%40kernel.org
patch subject: [PATCH v2 11/13] ata: libata-core: Reuse available ata_port print_ids
config: i386-randconfig-141-20240628 (https://download.01.org/0day-ci/archive/20240629/202406290027.cdgsPQAF-lkp@intel.com/config)
compiler: gcc-8 (Ubuntu 8.4.0-3ubuntu2) 8.4.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406290027.cdgsPQAF-lkp@intel.com/

smatch warnings:
drivers/ata/libata-core.c:5467 ata_port_alloc() warn: unsigned 'ap->print_id' is never less than zero.

vim +5467 drivers/ata/libata-core.c

  5443	
  5444	/**
  5445	 *	ata_port_alloc - allocate and initialize basic ATA port resources
  5446	 *	@host: ATA host this allocated port belongs to
  5447	 *
  5448	 *	Allocate and initialize basic ATA port resources.
  5449	 *
  5450	 *	RETURNS:
  5451	 *	Allocate ATA port on success, NULL on failure.
  5452	 *
  5453	 *	LOCKING:
  5454	 *	Inherited from calling layer (may sleep).
  5455	 */
  5456	struct ata_port *ata_port_alloc(struct ata_host *host)
  5457	{
  5458		struct ata_port *ap;
  5459	
  5460		ap = kzalloc(sizeof(*ap), GFP_KERNEL);
  5461		if (!ap)
  5462			return NULL;
  5463	
  5464		ap->pflags |= ATA_PFLAG_INITIALIZING | ATA_PFLAG_FROZEN;
  5465		ap->lock = &host->lock;
  5466		ap->print_id = ida_alloc_min(&ata_ida, 1, GFP_KERNEL);
> 5467		if (ap->print_id < 0) {
  5468			kfree(ap);
  5469			return NULL;
  5470		}
  5471		ap->host = host;
  5472		ap->dev = host->dev;
  5473	
  5474		mutex_init(&ap->scsi_scan_mutex);
  5475		INIT_DELAYED_WORK(&ap->hotplug_task, ata_scsi_hotplug);
  5476		INIT_DELAYED_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
  5477		INIT_LIST_HEAD(&ap->eh_done_q);
  5478		init_waitqueue_head(&ap->eh_wait_q);
  5479		init_completion(&ap->park_req_pending);
  5480		timer_setup(&ap->fastdrain_timer, ata_eh_fastdrain_timerfn,
  5481			    TIMER_DEFERRABLE);
  5482	
  5483		ap->cbl = ATA_CBL_NONE;
  5484	
  5485		ata_link_init(ap, &ap->link, 0);
  5486	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
