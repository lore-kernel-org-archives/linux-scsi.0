Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E72D4EB20
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 09:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715767183; cv=none; b=iY/xgf3q1CwKXp9G3MG2X2y5jU1D0MgnhfGxLQdhnf/O3NsXnJHLUofP8R+D4iBHxg67W8brLwAGIyA+QXkVBU0ntuYHUhGagD+ovSTNwFS7lK57a7bEQ3YIYj7fV1ugg+qhRVgPldt3LdHxIg8hLZV0SO6pPh0FB265laZNJmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715767183; c=relaxed/simple;
	bh=6fSq7acfWIb+p3oiQNEiEmUcRMs/hp6EJoH9GYmxJJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oz03SN7ZNXzUrOmnvhjvTeU26HvgnQRvibelopfO1LJ4Snet5OWO7JUCnUtsAm2ca4taDCF3oLlw36YskYXVrnjNMgeypN/KP5CE3p/QHfW0kwxfK2rwXIdxhfus2Y1fCiSYDrSfAEfu2G1Gx7fga6rcEJcqoFtUw2XnBy3gnZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MxRm56DV; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MxRm56DV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715767181; x=1747303181;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6fSq7acfWIb+p3oiQNEiEmUcRMs/hp6EJoH9GYmxJJg=;
  b=MxRm56DVQYpQyj57/5/aL6GUjR1QQFZXYDuhlnTu1MVpBnJ94sgHCEri
   09yrCu1a7R01ICZzMaQ7xhKpOGtp3HTNwI7NrcfNuPU9G2g7rNN4HftL1
   ljXcDscKZILmcje76wRsAY22BPVEUJ6iEHPreDzhS60tfoaVyVRlGEYi/
   Ge1oJywh82E41pQnKuWYyk1PpebyjfuBiRMzUvkADcQlQBxp74wsj5Khq
   ksTVYGCE4FvZRxdE1ppCJO/4oSBBTflb27b6Ma8kVz7dvnP7PJk0Bn8da
   MbJig2Q+bC/YRU4rGVEZ1BCrYWLCeYr9f3MWoxh8Lp3ijZre8ScqmVowF
   g==;
X-CSE-ConnectionGUID: 8t4JpEFuQx+plJlJc+EvYQ==
X-CSE-MsgGUID: HONEgynnQCqvzxbS6YeK0w==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11660388"
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="11660388"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 02:59:40 -0700
X-CSE-ConnectionGUID: vPp/Vu1+QXi5aI8IMSvV3Q==
X-CSE-MsgGUID: JMieIsOwSEagVb643J50IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="30931715"
Received: from lkp-server01.sh.intel.com (HELO f8b243fe6e68) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 15 May 2024 02:59:37 -0700
Received: from kbuild by f8b243fe6e68 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s7BQ6-000ChX-36;
	Wed, 15 May 2024 09:59:34 +0000
Date: Wed, 15 May 2024 17:58:50 +0800
From: kernel test robot <lkp@intel.com>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: Re: [PATCH v1 1/6] mpi3mr: HDB allocation and posting for hardware
 and Firmware buffers
Message-ID: <202405151758.7xrJz6rp-lkp@intel.com>
References: <20240514142858.51992-2-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240514142858.51992-2-ranjan.kumar@broadcom.com>

Hi Ranjan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.9 next-20240515]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ranjan-Kumar/mpi3mr-HDB-allocation-and-posting-for-hardware-and-Firmware-buffers/20240514-223346
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240514142858.51992-2-ranjan.kumar%40broadcom.com
patch subject: [PATCH v1 1/6] mpi3mr: HDB allocation and posting for hardware and Firmware buffers
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20240515/202405151758.7xrJz6rp-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240515/202405151758.7xrJz6rp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405151758.7xrJz6rp-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/mpi3mr/mpi3mr_app.c:460: warning: Function parameter or struct member 'trigger_data' not described in 'mpi3mr_set_trigger_data_in_hdb'
>> drivers/scsi/mpi3mr/mpi3mr_app.c:460: warning: Excess function parameter 'data' description in 'mpi3mr_set_trigger_data_in_hdb'


vim +460 drivers/scsi/mpi3mr/mpi3mr_app.c

   443	
   444	/**
   445	 * mpi3mr_set_trigger_data_in_hdb - Updates HDB trigger type and
   446	 * trigger data
   447	 *
   448	 * @hdb: HDB pointer
   449	 * @type: Trigger type
   450	 * @data: Trigger data
   451	 * @force: Trigger overwrite flag
   452	 *
   453	 * Updates trigger type and trigger data based on parameter
   454	 * passed to this function
   455	 *
   456	 * Return: Nothing
   457	 */
   458	void mpi3mr_set_trigger_data_in_hdb(struct diag_buffer_desc *hdb,
   459		u8 type, union mpi3mr_trigger_data *trigger_data, bool force)
 > 460	{
   461		if ((!force) && (hdb->trigger_type != MPI3MR_HDB_TRIGGER_TYPE_UNKNOWN))
   462			return;
   463		hdb->trigger_type = type;
   464		if (!trigger_data)
   465			memset(&hdb->trigger_data, 0, sizeof(*trigger_data));
   466		else
   467			memcpy(&hdb->trigger_data, trigger_data, sizeof(*trigger_data));
   468	}
   469	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
