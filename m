Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B1763CB;
	Thu, 12 Sep 2024 05:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726120418; cv=none; b=aYFBBhM5ST9ASZ4jJ9pJhiP7nBb9gPuHBtmjVq7/F0FtbydOH7YiQlO2U4ezV7MH1PRCHbpYNBY+CMLDb7ZiNBJpbFlNqqm2qLDeuUR5503/OrUo47JQpTE9nqVTHvZS3FS4ZJUbJp+Ij1wnSPvxnZQS6WiMd9jXTgCM0IrlNXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726120418; c=relaxed/simple;
	bh=ZCkO/5mSJ0mHwGXbYlJn+SQKakDCYdC3/McjGG/w+UY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tqIOXravwGhv1f7HKVNr7Izfq1WzLexfRZQC+KYGsTAb5Y58yPgAHGgGbKucEzjgVxAdk4pcunjSBYfII2yJbwZoNDAbBjNdFIHVgHbQN2E/y2qCXMM9Apj/FEhNNGAcSGiBGmlmscTtM7DpBp/m9BfNbAaPD3WhL4sm9MvyTvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U4IQVHBt; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U4IQVHBt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726120417; x=1757656417;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZCkO/5mSJ0mHwGXbYlJn+SQKakDCYdC3/McjGG/w+UY=;
  b=U4IQVHBtkc3oxjZwNxLQjesJ/MzDVsFd6XION0UlbEjeNEhiDkLsOVfW
   gq50rebAEBxFh/zzf31m5QTZ5t7UKksjiaRUBijhBPJ5TlT6cSyCi/Dw+
   OMOwzfLBNtSnwrjS64ZXZAxp3tL1e0xtW1O/6pPL6fCe3+sE8w1r+pOZw
   FrB7p2LpUg5M+DjIoaNDwbAl6rIJAsE8CHmU1JKeuQW+SGdF9SrV1qEHY
   ZqM2pvbCGmpjWuKjtEaoW3GaCM4wtt6qY5yXPhYTMypNGh7Ka6MtvqaT0
   ImFIcwrbZnhC3RKKX/HC8KX42M/qw+VHhYu9Opr+jYrpU2fPHf2NocktV
   A==;
X-CSE-ConnectionGUID: jNZNo+eYR+C8F/RGVu7O1Q==
X-CSE-MsgGUID: aI8RLX1UTRuplyQ1+Gq0eg==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="36091566"
X-IronPort-AV: E=Sophos;i="6.10,222,1719903600"; 
   d="scan'208";a="36091566"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 22:53:36 -0700
X-CSE-ConnectionGUID: 8dOeQaeZT0OWBveyB42R4Q==
X-CSE-MsgGUID: RCHp+Rx8TJmkDt8/Bbf6bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,222,1719903600"; 
   d="scan'208";a="90845677"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 11 Sep 2024 22:53:34 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1socln-0004Ze-2w;
	Thu, 12 Sep 2024 05:53:31 +0000
Date: Thu, 12 Sep 2024 13:52:39 +0800
From: kernel test robot <lkp@intel.com>
To: Avri Altman <avri.altman@wdc.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
Message-ID: <202409121226.ngZ7ruK0-lkp@intel.com>
References: <20240911053951.4032533-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911053951.4032533-1-avri.altman@wdc.com>

Hi Avri,

kernel test robot noticed the following build errors:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on jejb-scsi/for-next linus/master v6.11-rc7 next-20240911]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Avri-Altman/scsi-ufs-Zero-utp_upiu_req-at-the-beginning-of-each-command/20240911-134349
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240911053951.4032533-1-avri.altman%40wdc.com
patch subject: [PATCH] scsi: ufs: Zero utp_upiu_req at the beginning of each command
config: i386-buildonly-randconfig-001-20240912 (https://download.01.org/0day-ci/archive/20240912/202409121226.ngZ7ruK0-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240912/202409121226.ngZ7ruK0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409121226.ngZ7ruK0-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
>> ./usr/include/scsi/scsi_bsg_ufs.h:165:9: error: expected specifier-qualifier-list before 'struct_group'
     165 |         struct_group(utp_upiu,
         |         ^~~~~~~~~~~~

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
