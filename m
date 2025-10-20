Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C0A1B85FD
	for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2025 04:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760932926; cv=none; b=kitVGgxTt4ViL5YDFWRMr9CIpmwwKWveBK2p5c3RIYJ4mUzcIpTqKKBdXa+3JGmIrLqk0FJUSFzEBm6qHsqp+bQMbYELkv8yVjsyBjhtjHVsQrJC29R59nlbyKmyCbtAPruJdn4jG8a2KCYZ/RgRGcJzVqQeFNel3710P9WJJ4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760932926; c=relaxed/simple;
	bh=XpTGEPwefqriVNunO+lSjBbGlZmhC/rdHfI5kdWKge4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQLk4d8fBX//Ysu7+BIdFE0cxlGFWNNfZ5FMJxf9jEmLg11beJj3dQjjc/nfpNT6WPe8sp6ojj1pwSj/jlKdGCPSn50rHPH1BcseBHUsJZFlLyWvG33It8hd/Wq+4TvzbkhVNTW6PIZhlEUSNwFH3/nw6zBv9K2KrWnaFNbhk5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bg5nSHly; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bg5nSHly"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760932925; x=1792468925;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XpTGEPwefqriVNunO+lSjBbGlZmhC/rdHfI5kdWKge4=;
  b=bg5nSHlyhu9jtdC0O6WB4JWylOM2TbOTBvzJ3ezjq4w/cHmF595GnGay
   HxYoTYIERZuMqCbMY8YE8M3SKh5KcFaUn8TxuaaNkSgVSS+mafm6w8BKQ
   WAHMR23dIjim7ZslrQmsLjeaqr/y9Izw1cJTCJkHVHzZu8fCjKLTLSvbk
   gsRD/AevFWi16wupDzoBjoUsttAIKgBPCmSdkq9WxfkVb+y/FwO32o33P
   7llirdiOf0WATN8cXwiJEm25VDQXTHl0k0f6kr8RZxs7xyS3Lvdk+OBf3
   GjHgtM42TMsmFXm8fTIIoLAGmUTrTepz6I8d23fWc1069PdJzO6qXk2IK
   g==;
X-CSE-ConnectionGUID: f4OMNs0dT/2SbmQ8H8z+/Q==
X-CSE-MsgGUID: rqFXX4RDSzu1EkC24ccf6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11587"; a="50619699"
X-IronPort-AV: E=Sophos;i="6.19,241,1754982000"; 
   d="scan'208";a="50619699"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2025 21:02:04 -0700
X-CSE-ConnectionGUID: 8ogO/liHR6GiQwDXlpyaxA==
X-CSE-MsgGUID: sbeS8ehmRK2JCNZakqRpaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,241,1754982000"; 
   d="scan'208";a="182376439"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 19 Oct 2025 21:02:02 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vAh5H-0009TN-2z;
	Mon, 20 Oct 2025 04:01:47 +0000
Date: Mon, 20 Oct 2025 12:00:55 +0800
From: kernel test robot <lkp@intel.com>
To: doubled <doubled@leap-io-kernel.com>
Cc: oe-kbuild-all@lists.linux.dev, James.Bottomley@hansenpartnership.com,
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v2] scsi: leapraid: Add new scsi driver
Message-ID: <202510201103.iSEx48e3-lkp@intel.com>
References: <20251017072807.3327789-1-doubled@leap-io-kernel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017072807.3327789-1-doubled@leap-io-kernel.com>

Hi doubled,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on next-20251017]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/doubled/scsi-leapraid-Add-new-scsi-driver/20251017-153514
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251017072807.3327789-1-doubled%40leap-io-kernel.com
patch subject: [PATCH v2] scsi: leapraid: Add new scsi driver
config: csky-randconfig-r112-20251020 (https://download.01.org/0day-ci/archive/20251020/202510201103.iSEx48e3-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251020/202510201103.iSEx48e3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510201103.iSEx48e3-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/scsi/leapraid/leapraid_func.c:535:9: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   drivers/scsi/leapraid/leapraid_func.c:535:9: sparse:     expected unsigned int [usertype] value
   drivers/scsi/leapraid/leapraid_func.c:535:9: sparse:     got restricted __le32 [usertype]
   drivers/scsi/leapraid/leapraid_func.c:549:9: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   drivers/scsi/leapraid/leapraid_func.c:549:9: sparse:     expected unsigned int [usertype] value
   drivers/scsi/leapraid/leapraid_func.c:549:9: sparse:     got restricted __le32 [usertype]
   drivers/scsi/leapraid/leapraid_func.c:564:9: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   drivers/scsi/leapraid/leapraid_func.c:564:9: sparse:     expected unsigned int [usertype] value
   drivers/scsi/leapraid/leapraid_func.c:564:9: sparse:     got restricted __le32 [usertype]

vim +535 drivers/scsi/leapraid/leapraid_func.c

   523	
   524	void
   525	leapraid_fire_scsi_io(struct leapraid_adapter *adapter,
   526		 u16 taskid, u16 handle)
   527	{
   528		struct leapraid_atomic_req_desc desc;
   529	
   530		desc.flg = LEAPRAID_REQ_DESC_FLG_SCSI_IO;
   531		desc.msix_idx
   532			 = leapraid_get_and_set_msix_idx_from_taskid(adapter,
   533					 taskid);
   534		desc.taskid = cpu_to_le16(taskid);
 > 535		writel(cpu_to_le32(*((u32 *)&desc)),
   536			 &adapter->iomem_base->atomic_req_desc_post);
   537	}
   538	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
