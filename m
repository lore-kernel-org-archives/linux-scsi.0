Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F9881E;
	Sat, 31 Aug 2024 17:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725123862; cv=none; b=LFXAShB5gW18Nl7gsG/qqy8QQwI4ibbqY/1nNfRnKjIWvgU+D4LflFsfS6i5/OdPthnjF4UGr9iN7dr0PB4DjLmILa4EhnHeOkmCTLI9S3QBu2/Oi4N8d1ZQ3C9EDjORCbyzu/RcjRC1A2RaW8WyTz2WTaMZWCxZfdQgasMrwsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725123862; c=relaxed/simple;
	bh=Z2iU+6iIeLl81YPYU9R32z056dUcEIKREbZfkSIl/+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FAE6Cj+ZxUvx5JMvmDLepRLW11YDf1AI1BEL2rxjy8R5ff9GSe9vW+tEF6B/QdLpUHc0HvTAh7G3OpMpMtmNddJrK8alSjCfaIjhuBJmNsILzuqFivG6ERiNbwvpzIgdx93kEHdFU0m/4VtVVJ4g9tk2/NWiTyx1Ns10LeCRTqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dLdtS2Om; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dLdtS2Om"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725123860; x=1756659860;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z2iU+6iIeLl81YPYU9R32z056dUcEIKREbZfkSIl/+4=;
  b=dLdtS2OmxO8S0fFXgyW01kvK/6fNBczOio5WcMRqz29BoGdca6NuUIdy
   3+BPNIA3erSLS7IpmlOt3LDari0qo2IyQL85RP20oGOVtWfb4hZOe19jj
   U28nnAMCVorvk3I4mVIwCMb0/4OE4M4hG3TETwf2lXVDwi2tHpEkWNVJz
   OLuoKjEg5LZ2ssSuS+NbmdywOkc/kE134DXeeR3vnVs7Soe2AXvbZhjYg
   enxo9UFnIESMLb6hS8+gEIGKFG9TM53n1p15u8DB17UPCmoFv4+dKKpEQ
   QAOj2Wmg7Oz8GU4j6emHSh+8AkNMqz1QipiEG0FfYXOYMej27QtsH0z3e
   w==;
X-CSE-ConnectionGUID: myj1gyB/QSW6qi062wC0Hg==
X-CSE-MsgGUID: ydIbGFH7TUuWrCYsYSU5Xg==
X-IronPort-AV: E=McAfee;i="6700,10204,11181"; a="34417907"
X-IronPort-AV: E=Sophos;i="6.10,192,1719903600"; 
   d="scan'208";a="34417907"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2024 10:04:19 -0700
X-CSE-ConnectionGUID: WrdMWQSZR8GSmtRM/bwj9A==
X-CSE-MsgGUID: YIfU7kXcSYiauu9dYqQMfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,192,1719903600"; 
   d="scan'208";a="94903747"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 31 Aug 2024 10:04:14 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1skRWF-0002x4-19;
	Sat, 31 Aug 2024 17:04:11 +0000
Date: Sun, 1 Sep 2024 01:04:07 +0800
From: kernel test robot <lkp@intel.com>
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, avri.altman@wdc.com,
	alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
	peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
	alice.chao@mediatek.com, cc.chou@mediatek.com,
	chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
	powen.kao@mediatek.com, qilin.tan@mediatek.com,
	lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
	eddie.huang@mediatek.com, naomi.chu@mediatek.com,
	ed.tsai@mediatek.com, bvanassche@acm.org, stable@vger.kernel.org
Subject: Re: [PATCH v1 2/2] ufs: core: requeue MCQ abort request
Message-ID: <202409010054.kNsXraZk-lkp@intel.com>
References: <20240830074426.21968-3-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830074426.21968-3-peter.wang@mediatek.com>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.11-rc5 next-20240830]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/peter-wang-mediatek-com/ufs-core-fix-the-issue-of-ICU-failure/20240830-154808
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240830074426.21968-3-peter.wang%40mediatek.com
patch subject: [PATCH v1 2/2] ufs: core: requeue MCQ abort request
config: arm-randconfig-002-20240831 (https://download.01.org/0day-ci/archive/20240901/202409010054.kNsXraZk-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240901/202409010054.kNsXraZk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409010054.kNsXraZk-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/ufs/core/ufshcd.c:6505:6: error: call to undeclared function 'is_mcq_enabled'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
           if (is_mcq_enabled(hba) && (*ret == 0))
               ^
   1 error generated.


vim +/is_mcq_enabled +6505 drivers/ufs/core/ufshcd.c

  6488	
  6489	static bool ufshcd_abort_one(struct request *rq, void *priv)
  6490	{
  6491		int *ret = priv;
  6492		u32 tag = rq->tag;
  6493		struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
  6494		struct scsi_device *sdev = cmd->device;
  6495		struct Scsi_Host *shost = sdev->host;
  6496		struct ufs_hba *hba = shost_priv(shost);
  6497		struct ufshcd_lrb *lrbp = &hba->lrb[tag];
  6498	
  6499		*ret = ufshcd_try_to_abort_task(hba, tag);
  6500		dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
  6501			hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
  6502			*ret ? "failed" : "succeeded");
  6503	
  6504		/* Host will post to CQ with OCS_ABORTED after SQ clean up */
> 6505		if (is_mcq_enabled(hba) && (*ret == 0))
  6506			lrbp->host_initiate_abort = true;
  6507	
  6508		return *ret == 0;
  6509	}
  6510	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
