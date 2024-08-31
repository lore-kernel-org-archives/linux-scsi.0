Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECED613BC3D;
	Sat, 31 Aug 2024 19:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725133765; cv=none; b=aEhEEG6ND9EKEGoYdL54f9Eri10KOFx/t5rLUHlNIAcl3sCs/dMIrcEzdQBvY54MouwdJ+JX/myetlyitdiLhYI/tcZ2uvF9Cmxtkq5mMxZp4J44WXFsyT5aG02VQf5dfLOVWR5zoEHvYwXsTKLYHV42HvXwyb/xbrZ9d7bPg1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725133765; c=relaxed/simple;
	bh=TjFqpOaghVpHu0OD8TVOsUrdkEB/DlbW93skVivqlMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DdJKqZUB2aale6vC9TwA5PKB8qT4tgJMWd/f2t7LGDfr8zQNjFIoMwfQSro41dnGzC6LmozKiwbCiP7wFvXdo56e5ZqPlWaPv20P2A5NrEnTkO5xWlHbLSOdqbNQQWI1iWl8h/1RKsPXky8lniBSAwdOGzBydThbpWMq5hgskj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U0I4yqoW; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U0I4yqoW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725133763; x=1756669763;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TjFqpOaghVpHu0OD8TVOsUrdkEB/DlbW93skVivqlMc=;
  b=U0I4yqoWUF6LRxnc9YFEpTKManBo2nb1tYW0Twaz9Ayd1yvco+v8mq3A
   K1+mzHFw7B6EbEVuuiwVCgtoBV+uh8Qk+SklGNCyrxJW0pAO/8EHFefDq
   iWIV0delmoUTZ1lhOp82eYCWtV/8lDv89E/hefN28Xvv/yasXQv/hV2Dq
   KWos1r1dWKc25E7JdqRTOaqGg5YbzOIFeAuCqpWfc8t5f6WGNR/k2FeaF
   p8rpUCY0nt5HlE7xK5Z7iLAv6F/nh/tgSAXE3X8Wb98KcuoowJABAWb4f
   CsGwOUCyZkZLBbtXdY1auwic4hHuWvMImeT6sXmFe3WB+XlpUvQM0zwb4
   g==;
X-CSE-ConnectionGUID: 3sIcwHddR0KYYrjt0iiUNg==
X-CSE-MsgGUID: PHaJFGXlSyG7+c4xZMyUrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11181"; a="23891612"
X-IronPort-AV: E=Sophos;i="6.10,192,1719903600"; 
   d="scan'208";a="23891612"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2024 12:49:22 -0700
X-CSE-ConnectionGUID: rkMK3vv3TlWSwvqmE8pJsw==
X-CSE-MsgGUID: 17sbqSKtTNqinfuAWjXqWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,192,1719903600"; 
   d="scan'208";a="64946347"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 31 Aug 2024 12:49:18 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1skU5z-00033u-0v;
	Sat, 31 Aug 2024 19:49:15 +0000
Date: Sun, 1 Sep 2024 03:49:10 +0800
From: kernel test robot <lkp@intel.com>
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, avri.altman@wdc.com,
	alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc: oe-kbuild-all@lists.linux.dev, wsd_upstream@mediatek.com,
	linux-mediatek@lists.infradead.org, peter.wang@mediatek.com,
	chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
	cc.chou@mediatek.com, chaotian.jing@mediatek.com,
	jiajie.hao@mediatek.com, powen.kao@mediatek.com,
	qilin.tan@mediatek.com, lin.gui@mediatek.com,
	tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
	naomi.chu@mediatek.com, ed.tsai@mediatek.com, bvanassche@acm.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v1 2/2] ufs: core: requeue MCQ abort request
Message-ID: <202409010304.Ivj4eQN6-lkp@intel.com>
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
config: arm64-randconfig-r132-20240831 (https://download.01.org/0day-ci/archive/20240901/202409010304.Ivj4eQN6-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce: (https://download.01.org/0day-ci/archive/20240901/202409010304.Ivj4eQN6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409010304.Ivj4eQN6-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/ufs/core/ufshcd.c:6505:6: error: implicit declaration of function 'is_mcq_enabled' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
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
