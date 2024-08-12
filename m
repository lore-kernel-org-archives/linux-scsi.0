Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2806F1891AB;
	Mon, 12 Aug 2024 17:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723483809; cv=none; b=QRubxwgWTSz21nBKgf7b0sK8hqYqwzC2lWjClqaonqodzZgaaMwGnQJDpPdDb+J4Inel6SZl/F6Wamh+ByLVAjkOOaUuefXLkHfu8Mf5dprEiKgyCQJogzNY8Hc+Jz6BW8mzfEgJ3B7ktjdCNDD0Sl5JbLGaHk81u0pgEmgW1Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723483809; c=relaxed/simple;
	bh=Dj8PYH9oW7aGY1KsFlL/zhO2sek/0nRBJ/6Rbz/3Jgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZoNRjVHvg25bMktv1aMU3HZdaUsOV/g9wlLB2AKayn9lgAqeqpti6+644JuWd3clVFNpFQea/2GMH9yXGFgURxC+0oHjqHolZDeLOPGgM2PoNLhwTH34MIr1TVEztH6WHj93BTyRtRAHnShqFi4qJfEnXJzjvTTBZR9oG5rOBHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZE6loB4V; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZE6loB4V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723483808; x=1755019808;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Dj8PYH9oW7aGY1KsFlL/zhO2sek/0nRBJ/6Rbz/3Jgk=;
  b=ZE6loB4VxlM3nVmC7eM/p0OwZuPGgk1IoCrzS2m/msjFeZrUFre4HrRM
   YQxLfrSOzasirGd4zu24IH9OxltjlHomNQLHIEP7lEPQbl7156HSyks9+
   fc8TaYmOkCOYB2JNwOJzp/KQYCtaLVGVadPhZ04KEZVwy+bHJ/yclM/mj
   sWVO605W1CgDbkVfq/PX4G2bat/i/SfxAsrA/yuFdVj9SMJOuzWNcMn2+
   qldd5bAL/np4nbDiyQe9yVAu1zMWh3ChNVaP7BDq1YIp04Fp2zOGX4OTs
   SeOw2gWP/sp/Jqn+DgINU6/OKiEsV6zpbLeLH1lBFzdKUyUudKMFg3Qdk
   Q==;
X-CSE-ConnectionGUID: kPHuG11vR5OahATFyTc/jA==
X-CSE-MsgGUID: dkzULwGXTx+M9MHCzGte6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="39123945"
X-IronPort-AV: E=Sophos;i="6.09,283,1716274800"; 
   d="scan'208";a="39123945"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 10:30:07 -0700
X-CSE-ConnectionGUID: wb8C8qAhSEyNNp8BIl9PKQ==
X-CSE-MsgGUID: haAF1XmMRz+SJZTrb56Wug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,283,1716274800"; 
   d="scan'208";a="62991831"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 12 Aug 2024 10:30:01 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sdYrm-000C14-0K;
	Mon, 12 Aug 2024 17:29:58 +0000
Date: Tue, 13 Aug 2024 01:29:01 +0800
From: kernel test robot <lkp@intel.com>
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org, jejb@linux.ibm.com,
	martin.petersen@oracle.com, beanhuo@micron.com,
	adrian.hunter@intel.com, h10.kim@samsung.com, hy50.seo@samsung.com,
	sh425.lee@samsung.com, kwangwon.min@samsung.com,
	junwoo80.lee@samsung.com, wkon.kim@samsung.com
Cc: oe-kbuild-all@lists.linux.dev, Kiwoong Kim <kwmad.kim@samsung.com>
Subject: Re: [PATCH v1] scsi: ufs: core: introduce override_cqe_ocs
Message-ID: <202408122344.dvhCpFj0-lkp@intel.com>
References: <1723446114-153235-1-git-send-email-kwmad.kim@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1723446114-153235-1-git-send-email-kwmad.kim@samsung.com>

Hi Kiwoong,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.11-rc3 next-20240812]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kiwoong-Kim/scsi-ufs-core-introduce-override_cqe_ocs/20240812-151156
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/1723446114-153235-1-git-send-email-kwmad.kim%40samsung.com
patch subject: [PATCH v1] scsi: ufs: core: introduce override_cqe_ocs
config: arc-randconfig-002-20240812 (https://download.01.org/0day-ci/archive/20240812/202408122344.dvhCpFj0-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240812/202408122344.dvhCpFj0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408122344.dvhCpFj0-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/ufs/core/ufshcd.c:31:
   drivers/ufs/core/ufshcd-priv.h: In function 'ufshcd_vops_override_cqe_ocs':
>> drivers/ufs/core/ufshcd-priv.h:282:24: error: too few arguments to function 'hba->vops->override_cqe_ocs'
     282 |                 return hba->vops->override_cqe_ocs(hba);
         |                        ^~~
   drivers/ufs/core/ufshcd.c: In function 'ufshcd_get_tr_ocs':
>> drivers/ufs/core/ufshcd.c:828:53: error: 'hba' undeclared (first use in this function)
     828 |                 return ufshcd_vops_override_cqe_ocs(hba,
         |                                                     ^~~
   drivers/ufs/core/ufshcd.c:828:53: note: each undeclared identifier is reported only once for each function it appears in
--
   In file included from drivers/ufs/core/ufs_bsg.c:14:
   drivers/ufs/core/ufshcd-priv.h: In function 'ufshcd_vops_override_cqe_ocs':
>> drivers/ufs/core/ufshcd-priv.h:282:24: error: too few arguments to function 'hba->vops->override_cqe_ocs'
     282 |                 return hba->vops->override_cqe_ocs(hba);
         |                        ^~~


vim +282 drivers/ufs/core/ufshcd-priv.h

   277	
   278	static inline enum utp_ocs ufshcd_vops_override_cqe_ocs(struct ufs_hba *hba,
   279								enum utp_ocs ocs)
   280	{
   281		if (hba->vops && hba->vops->override_cqe_ocs)
 > 282			return hba->vops->override_cqe_ocs(hba);
   283	
   284		return ocs;
   285	}
   286	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
