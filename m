Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E195D14D280;
	Wed,  9 Oct 2024 05:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728450575; cv=none; b=uH7YL2qf2FJI021hYGmYWOYl5vOqGuWYjtMdlb1XwNe2YxnKraIiMthzNJcycviSq6Nxl7M/BRhlfXBIurjDTme+7x1Lq87HR7VWIQKLT+SLGtsM25uU0moBm+Hq3VC8+Cjffa2SABnETLwQkLJMdsH2GNM2pzJSmNVSJWR/dUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728450575; c=relaxed/simple;
	bh=+/lG6d/2yiL1coqVhRfclbMCgDsoHozt5HlulUhP8jQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kxFTkHs77FVQ3e34M1uGdNuG5ovC9grgq8BfJGTyw/jd8xjhD3Cu4q9ak0CRIm+oWEfZZ1OhDAVe3ZvvU2h88GMvr3sf8DqZaRjsHeFY7w5DREaqsUNZ9dauNjLO0scwiRaFCMoZzuwZPq+59bGnzjfvTUPrRuuFnzzIrzoD3uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KXXjcqWW; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KXXjcqWW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728450573; x=1759986573;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+/lG6d/2yiL1coqVhRfclbMCgDsoHozt5HlulUhP8jQ=;
  b=KXXjcqWWeEt06Pxu1tm4y7kB03Vpay/Q8CydyCkh6wVAW6OUvs03AoEu
   lyhNCcA65vrhe+i8Nr8YXZW/TjroYa4/E4BBhojNweIibnggddwg/sBAo
   9szFVm/FvsHCt4839nXsupemXWcgzIEd9CARv44/laOhtvllqXxxYdZmK
   RfDoPJeSXJCLzcZPsX4PC5KSM9m7K7JAWFVzrwRRjS94D4i0p72K27I6y
   rb0o0M6hvYv1OBp2lLASobZo/jYSnkwCg7x1MP7QTL7nplbaTlhr68SXJ
   Tb7SbjGLcFKfwjifDmg0qB769hdoUqiHj2VkYufHz7W/yvTfe2VjBEf+h
   g==;
X-CSE-ConnectionGUID: PzfHB7rURk2E+TPWxU7eCQ==
X-CSE-MsgGUID: 1yPT0X9kSSmZDmK1ZOttVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="31425379"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="31425379"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 22:09:32 -0700
X-CSE-ConnectionGUID: HgE7S8OtTvum40XWD/P7BQ==
X-CSE-MsgGUID: YcVLafYwToq0mu9eCJWT4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="75995876"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 08 Oct 2024 22:09:28 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1syOww-0008lM-0w;
	Wed, 09 Oct 2024 05:09:26 +0000
Date: Wed, 9 Oct 2024 13:09:17 +0800
From: kernel test robot <lkp@intel.com>
To: ed.tsai@mediatek.com, peter.wang@mediatek.com,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: oe-kbuild-all@lists.linux.dev, wsd_upstream@mediatek.com,
	chun-hung.wu@mediatek.com, Ed Tsai <ed.tsai@mediatek.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: configure individual LU queue
 flags
Message-ID: <202410091257.SE04cckD-lkp@intel.com>
References: <20241008065950.23431-1-ed.tsai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008065950.23431-1-ed.tsai@mediatek.com>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on jejb-scsi/for-next linus/master v6.12-rc2 next-20241008]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/ed-tsai-mediatek-com/scsi-ufs-ufs-mediatek-configure-individual-LU-queue-flags/20241008-153700
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241008065950.23431-1-ed.tsai%40mediatek.com
patch subject: [PATCH] scsi: ufs: ufs-mediatek: configure individual LU queue flags
config: arm-allyesconfig (https://download.01.org/0day-ci/archive/20241009/202410091257.SE04cckD-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241009/202410091257.SE04cckD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410091257.SE04cckD-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/ufs/host/ufs-mediatek.c: In function 'ufs_mtk_config_scsi_dev':
>> drivers/ufs/host/ufs-mediatek.c:1789:65: error: 'struct scsi_device' has no member named 'reqeust_queue'; did you mean 'request_queue'?
    1789 |                 blk_queue_flag_set(QUEUE_FLAG_SAME_FORCE, sdev->reqeust_queue);
         |                                                                 ^~~~~~~~~~~~~
         |                                                                 request_queue

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for GET_FREE_REGION
   Depends on [n]: SPARSEMEM [=n]
   Selected by [y]:
   - RESOURCE_KUNIT_TEST [=y] && RUNTIME_TESTING_MENU [=y] && KUNIT [=y]


vim +1789 drivers/ufs/host/ufs-mediatek.c

  1782	
  1783	static void ufs_mtk_config_scsi_dev(struct scsi_device *sdev)
  1784	{
  1785		struct ufs_hba *hba = shost_priv(sdev->host);
  1786	
  1787		dev_dbg(hba->dev, "lu %llu scsi device configured", sdev->lun);
  1788		if (sdev->lun == 2)
> 1789			blk_queue_flag_set(QUEUE_FLAG_SAME_FORCE, sdev->reqeust_queue);
  1790	}
  1791	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
