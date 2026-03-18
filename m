Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F417614AD20;
	Wed, 18 Mar 2026 23:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773874879; cv=none; b=P1lQH8kgeyfPEBcTGDM61uzUvjSxG6OzSEdPVXj+t0lLhxS3+pXklz37KuFgZ8IaYbGM80F7L4GYVUA7p/lHaYTNzPLSGibNFKtyVE+IQmD3OYikB8xt1fTeUYs5xq/sGVXJEGc2dcwY5oqbhJr8tcbsDxqvdCP8uhm56yrUL+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773874879; c=relaxed/simple;
	bh=jnKbWmbN83+SErDUnlV52ppaKL5Kry+RXe7xRlzZGVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AW5pOfv4FcsvSqd/9ixG+MShf9nQ7vvjYIZBjMIvZtjjCbi+dNyvZjvsLdgWXnjSdmYLrYrP9mtleiDlNtV+E4OSKpwn+uUE9rfB/dXczqWj57Oe+odUxyW7awoJramvvCwuw7EBc3USBC7EupLcI+z6bue6m1FxoleKJsPz2AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R2N3Z686; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R2N3Z686"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773874877; x=1805410877;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jnKbWmbN83+SErDUnlV52ppaKL5Kry+RXe7xRlzZGVU=;
  b=R2N3Z686+tiwGM+t8aZW3PXZXxrrgKPkKpXoSFplT/mCkeEFp13ePSew
   +y8uh2RPl14Oa6vCQH7yuiIHAV34aTps/ZZ+JN0ERY0CtP8oAdLMOA3LZ
   eCo4jJeK0eL3UhvnfJS0WoTiH4DdoC9qL+gcCPgx5pzpk6PN4NlKX5kne
   s9GsqjoWJQomWm+RbXc1Hyz/FPESdFrWNtOaOrJqXPaA1GEP++0xO4jjS
   Cw8/xM+ysdRv5zCSeOFC5HsSxQ23UxAR94t/TDaBJfh7QhD4556JvqQoJ
   Ewkzl7fppqF8VLyHvpNpc2m8ZnUnvQWiNVemzI5aFHs2qIxE76e3VIJDj
   w==;
X-CSE-ConnectionGUID: aeAWZVjBRvmBk0Ps9LUWaA==
X-CSE-MsgGUID: o+fMfN/lRKyPtKWZdtWlnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="75127670"
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="75127670"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 16:01:17 -0700
X-CSE-ConnectionGUID: aDPUuuUHRXiIcJwwJe78yg==
X-CSE-MsgGUID: s8aqOPSVQReZ7QZjFxpggw==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO a51c2a36b9df) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 18 Mar 2026 16:01:14 -0700
Received: from kbuild by a51c2a36b9df with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w2zmn-0000000003V-3lF9;
	Wed, 18 Mar 2026 22:56:44 +0000
Date: Thu, 19 Mar 2026 06:54:23 +0800
From: kernel test robot <lkp@intel.com>
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
	james.bottomley@hansenpartnership.com, hare@suse.com,
	bmarzins@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, jmeneghi@redhat.com,
	linux-scsi@vger.kernel.org, michael.christie@oracle.com,
	snitzer@kernel.org, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 02/13] scsi: alua: Create a core ALUA driver
Message-ID: <202603190613.weiFq4ac-lkp@intel.com>
References: <20260317120703.3702387-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317120703.3702387-3-john.g.garry@oracle.com>

Hi John,

kernel test robot noticed the following build errors:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on jejb-scsi/for-next linus/master v7.0-rc4 next-20260318]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/John-Garry/scsi-scsi_dh_alua-Delete-alua_port_group/20260318-105207
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260317120703.3702387-3-john.g.garry%40oracle.com
patch subject: [PATCH 02/13] scsi: alua: Create a core ALUA driver
config: um-randconfig-001-20260319 (https://download.01.org/0day-ci/archive/20260319/202603190613.weiFq4ac-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260319/202603190613.weiFq4ac-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603190613.weiFq4ac-lkp@intel.com/

All errors (new ones prefixed by >>):

   /usr/bin/ld: drivers/scsi/scsi.o: in function `exit_scsi':
>> scsi.c:(.exit.text+0x1b): undefined reference to `scsi_exit_alua'
   /usr/bin/ld: drivers/scsi/scsi.o: in function `init_scsi':
>> scsi.c:(.init.text+0x8c): undefined reference to `scsi_alua_init'
   /usr/bin/ld: drivers/scsi/scsi_scan.o: in function `scsi_add_lun':
>> scsi_scan.c:(.text+0x1797): undefined reference to `scsi_alua_sdev_init'
   /usr/bin/ld: drivers/scsi/scsi_sysfs.o: in function `scsi_device_dev_release':
>> scsi_sysfs.c:(.text+0x1e8a): undefined reference to `scsi_alua_sdev_exit'
   collect2: error: ld returned 1 exit status

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
