Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A5F32B9A8;
	Thu, 12 Mar 2026 01:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773280189; cv=none; b=mopzTzmURNGvte7zGkAWXIa4k4wTAWeW0I9L+X/AFQHtzJYWnfeMyOEBqsBsGFNg7RbHLglFVy30sCkhtmUydYK6HjSSgNeIAVqIOc84T+bt48LtDtFKW5QPtcBbfO9u8mIOK+jMacJg8F4pg2VSLt2vmCGEVVZqKnkMRp+JVkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773280189; c=relaxed/simple;
	bh=7pyGelV79AEGbHfHfv0XLQIfbu8aHxnIWZ1Vr3FIRxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KrCJgOYBLCZcloSIr/T3r83pu7396POyGMhou4YmufrdQ4tK1TTI1wmAMjuwiB5T/BeXz2hCea97CQIVZ5kSF0pJpJfVhaYP2nPfDjp8EwJNPCMp1af+tn0ISi5HYRfzf9IWlu0oFHM8hBPozkuufZU82W7vA3bl36YbxvhELF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BPB2DK9M; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BPB2DK9M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773280185; x=1804816185;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7pyGelV79AEGbHfHfv0XLQIfbu8aHxnIWZ1Vr3FIRxU=;
  b=BPB2DK9Mf6gHZakh4fDEnRv15/F5oTp7N927aMCSb0LAoWi19SIOaYfQ
   x6IDG5Jfj3kzI4R19+fSEWxba9+qLzLVIGEl3Aah0oTt6DDqiSSYRfYX/
   waQBFEVxRXQ6oiOdKtjyhes+pNz2SqMl8QmKZruBPklRjfSfQGh5rR4WC
   wcup7yxzxOWPa34QwdwOCR/KX+gh3hHIn3bKQkQeHuMcOAvTQwfYdMTyU
   42dXyt/GQBgNPubS+F1ib7KHwczYQYLBiZysmXrLlJcpL90DNHc0Y3xZz
   y2Z74tWd6hLT51UAw5v4I3Gv95703ilopg0Tu6WYHR7lhqkUddvxzkeRP
   Q==;
X-CSE-ConnectionGUID: YYaiE0pYQlio042886i2ZQ==
X-CSE-MsgGUID: Xs7tWhfAR5ysFYQDDtE5ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11726"; a="74241213"
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="74241213"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 18:49:45 -0700
X-CSE-ConnectionGUID: 3HYzLJfPT0qWGvzXIZZV1w==
X-CSE-MsgGUID: n3xQw8bvQ/mBoRaRV9yrNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="225108599"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 11 Mar 2026 18:49:41 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0VB7-000000001v1-3ViA;
	Thu, 12 Mar 2026 01:49:33 +0000
Date: Thu, 12 Mar 2026 09:49:18 +0800
From: kernel test robot <lkp@intel.com>
To: David Jeffery <djeffery@redhat.com>, linux-kernel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, Tarun Sahu <tarunsahu@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	=?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
	Jordan Richards <jordanrichards@google.com>,
	Ewan Milne <emilne@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Lombardi, Maurizio" <mlombard@redhat.com>,
	David Jeffery <djeffery@redhat.com>,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH 2/5] driver core: separate function to shutdown one device
Message-ID: <202603120917.gDcyYG9H-lkp@intel.com>
References: <20260311171209.9205-2-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311171209.9205-2-djeffery@redhat.com>

Hi David,

kernel test robot noticed the following build warnings:

[auto build test WARNING on driver-core/driver-core-testing]
[also build test WARNING on driver-core/driver-core-next driver-core/driver-core-linus jejb-scsi/for-next mkp-scsi/for-next linus/master v7.0-rc3 next-20260311]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Jeffery/driver-core-separate-function-to-shutdown-one-device/20260312-011646
base:   driver-core/driver-core-testing
patch link:    https://lore.kernel.org/r/20260311171209.9205-2-djeffery%40redhat.com
patch subject: [PATCH 2/5] driver core: separate function to shutdown one device
config: arc-allnoconfig (https://download.01.org/0day-ci/archive/20260312/202603120917.gDcyYG9H-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260312/202603120917.gDcyYG9H-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603120917.gDcyYG9H-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/base/core.c: In function 'device_shutdown':
>> drivers/base/core.c:4824:30: warning: variable 'parent' set but not used [-Wunused-but-set-variable]
    4824 |         struct device *dev, *parent;
         |                              ^~~~~~


vim +/parent +4824 drivers/base/core.c

f9dcdf9ae03c40 David Jeffery      2026-03-11  4818  
37b0c020343080 Greg Kroah-Hartman 2007-11-26  4819  /**
37b0c020343080 Greg Kroah-Hartman 2007-11-26  4820   * device_shutdown - call ->shutdown() on each device to shutdown.
37b0c020343080 Greg Kroah-Hartman 2007-11-26  4821   */
37b0c020343080 Greg Kroah-Hartman 2007-11-26  4822  void device_shutdown(void)
37b0c020343080 Greg Kroah-Hartman 2007-11-26  4823  {
f123db8e9d6c84 Benson Leung       2013-09-24 @4824  	struct device *dev, *parent;
6245838fe4d2ce Hugh Daschbach     2010-03-22  4825  
3297c8fc65af5d Pingfan Liu        2018-07-19  4826  	wait_for_device_probe();
3297c8fc65af5d Pingfan Liu        2018-07-19  4827  	device_block_probing();
3297c8fc65af5d Pingfan Liu        2018-07-19  4828  
65650b35133ff2 Rafael J. Wysocki  2019-10-09  4829  	cpufreq_suspend();
65650b35133ff2 Rafael J. Wysocki  2019-10-09  4830  
6245838fe4d2ce Hugh Daschbach     2010-03-22  4831  	spin_lock(&devices_kset->list_lock);
6245838fe4d2ce Hugh Daschbach     2010-03-22  4832  	/*
6245838fe4d2ce Hugh Daschbach     2010-03-22  4833  	 * Walk the devices list backward, shutting down each in turn.
6245838fe4d2ce Hugh Daschbach     2010-03-22  4834  	 * Beware that device unplug events may also start pulling
6245838fe4d2ce Hugh Daschbach     2010-03-22  4835  	 * devices offline, even as the system is shutting down.
6245838fe4d2ce Hugh Daschbach     2010-03-22  4836  	 */
6245838fe4d2ce Hugh Daschbach     2010-03-22  4837  	while (!list_empty(&devices_kset->list)) {
6245838fe4d2ce Hugh Daschbach     2010-03-22  4838  		dev = list_entry(devices_kset->list.prev, struct device,
6245838fe4d2ce Hugh Daschbach     2010-03-22  4839  				kobj.entry);
d1c6c030fcec6f Ming Lei           2012-06-22  4840  
d1c6c030fcec6f Ming Lei           2012-06-22  4841  		/*
d1c6c030fcec6f Ming Lei           2012-06-22  4842  		 * hold reference count of device's parent to
d1c6c030fcec6f Ming Lei           2012-06-22  4843  		 * prevent it from being freed because parent's
d1c6c030fcec6f Ming Lei           2012-06-22  4844  		 * lock is to be held
d1c6c030fcec6f Ming Lei           2012-06-22  4845  		 */
f123db8e9d6c84 Benson Leung       2013-09-24  4846  		parent = get_device(dev->parent);
6245838fe4d2ce Hugh Daschbach     2010-03-22  4847  		get_device(dev);
6245838fe4d2ce Hugh Daschbach     2010-03-22  4848  		/*
6245838fe4d2ce Hugh Daschbach     2010-03-22  4849  		 * Make sure the device is off the kset list, in the
6245838fe4d2ce Hugh Daschbach     2010-03-22  4850  		 * event that dev->*->shutdown() doesn't remove it.
6245838fe4d2ce Hugh Daschbach     2010-03-22  4851  		 */
6245838fe4d2ce Hugh Daschbach     2010-03-22  4852  		list_del_init(&dev->kobj.entry);
6245838fe4d2ce Hugh Daschbach     2010-03-22  4853  		spin_unlock(&devices_kset->list_lock);
fe6b91f47080eb Alan Stern         2011-12-06  4854  
f9dcdf9ae03c40 David Jeffery      2026-03-11  4855  		shutdown_one_device(dev);
6245838fe4d2ce Hugh Daschbach     2010-03-22  4856  
6245838fe4d2ce Hugh Daschbach     2010-03-22  4857  		spin_lock(&devices_kset->list_lock);
37b0c020343080 Greg Kroah-Hartman 2007-11-26  4858  	}
6245838fe4d2ce Hugh Daschbach     2010-03-22  4859  	spin_unlock(&devices_kset->list_lock);
37b0c020343080 Greg Kroah-Hartman 2007-11-26  4860  }
99bcf217183e02 Joe Perches        2010-06-27  4861  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
