Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02AB37165;
	Tue, 10 Sep 2024 01:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725932073; cv=none; b=jXc0cLTfaXZsbR/udru5Qy88KkjEy8fnl0cjjA6NHNCMZhYw6SWcT9toSLGwkjzcdP7gwRTAWfH0CTfijWg9sD0mDjF5lxnvYY5B85bR0Jlm/Ac+7oDFqsYgyjigIkUeqRPhvYsMxp9ac+zzfub8vi5aMVlcMNhW9rlEmi3VmsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725932073; c=relaxed/simple;
	bh=e1rVwTMNq7di54sGOAsuF2je2ceVH7dA0EPFlPu/fPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jgw6xf6WC7uVbFtjCbhqMNkOGCR+2sT3yC0GleUuytkG3mv1PxxeoBOi0Ukr4OIvGBQuNSTMIk/jg9KJEWJNGt/F33SSUaIWywIpOaV20zT3vsPN93lqZ+z2u4ZptZD1pfrm2tyLNoAqBqS2dSyLQF189lJg/A7gaKw+5+c3buU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dICHMSqb; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dICHMSqb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725932072; x=1757468072;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e1rVwTMNq7di54sGOAsuF2je2ceVH7dA0EPFlPu/fPU=;
  b=dICHMSqb83SSaPdnmqqMykmCJ07QRKwxpFamc81LY2A2oyiwZob9voEs
   Pu5Ev7HOUQ63fSqdhSq76EQt+IXlQv3FqX6thTQ8rHrdwU2XziGr5r32J
   HKBA7Bcw5dXg/12LMc/HNN+05V8VvHCSRSwVVhq/tttbD54cPOubdRQ8b
   uoh8aR/3kb1SCr2N0mB1xx52m/fY8mICmWs9cQ69EW7a/HlIBYqPIWIDg
   f5Z5HImTyLW5PfyGM8iqZRHNt7EqzVzKyhT7RdX9dH63HA+JgpnUqI0Rj
   Ff/SAsGZVPXXCAcDZvsa3Y53d/LYFyAxntEb1f08z2TiWC6sTihYLxxst
   Q==;
X-CSE-ConnectionGUID: HoaH4PFzRViKmfAF/4zTLA==
X-CSE-MsgGUID: yF55tJ8LRaa8FFC6NeYeDg==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24767202"
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="24767202"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 18:34:31 -0700
X-CSE-ConnectionGUID: YJEpADTRS9exfSCUvCWxzA==
X-CSE-MsgGUID: JSwMfiM8Qe2M1xL8UpcOYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="71828488"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 09 Sep 2024 18:34:26 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1snplv-000FSW-0o;
	Tue, 10 Sep 2024 01:34:23 +0000
Date: Tue, 10 Sep 2024 09:33:49 +0800
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
	quic_nguyenb@quicinc.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ufs: core: requeue aborted request
Message-ID: <202409100826.Iql38Ss9-lkp@intel.com>
References: <20240909082100.24019-3-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909082100.24019-3-peter.wang@mediatek.com>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.11-rc7 next-20240909]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/peter-wang-mediatek-com/ufs-core-fix-the-issue-of-ICU-failure/20240909-163021
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240909082100.24019-3-peter.wang%40mediatek.com
patch subject: [PATCH v3 2/2] ufs: core: requeue aborted request
config: i386-buildonly-randconfig-002-20240910 (https://download.01.org/0day-ci/archive/20240910/202409100826.Iql38Ss9-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240910/202409100826.Iql38Ss9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409100826.Iql38Ss9-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/ufs/core/ufshcd.c: In function 'ufshcd_abort_one':
>> drivers/ufs/core/ufshcd.c:6491:28: warning: unused variable 'lrbp' [-Wunused-variable]
    6491 |         struct ufshcd_lrb *lrbp = &hba->lrb[tag];
         |                            ^~~~


vim +/lrbp +6491 drivers/ufs/core/ufshcd.c

2355b66ed20ce4 drivers/scsi/ufs/ufshcd.c Can Guo         2020-08-24  6482  
f9c028e7415a5b drivers/ufs/core/ufshcd.c Bart Van Assche 2023-07-27  6483  static bool ufshcd_abort_one(struct request *rq, void *priv)
b817e6ffbad7a1 drivers/ufs/core/ufshcd.c Bart Van Assche 2022-10-31  6484  {
f9c028e7415a5b drivers/ufs/core/ufshcd.c Bart Van Assche 2023-07-27  6485  	int *ret = priv;
f9c028e7415a5b drivers/ufs/core/ufshcd.c Bart Van Assche 2023-07-27  6486  	u32 tag = rq->tag;
f9c028e7415a5b drivers/ufs/core/ufshcd.c Bart Van Assche 2023-07-27  6487  	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
f9c028e7415a5b drivers/ufs/core/ufshcd.c Bart Van Assche 2023-07-27  6488  	struct scsi_device *sdev = cmd->device;
f9c028e7415a5b drivers/ufs/core/ufshcd.c Bart Van Assche 2023-07-27  6489  	struct Scsi_Host *shost = sdev->host;
f9c028e7415a5b drivers/ufs/core/ufshcd.c Bart Van Assche 2023-07-27  6490  	struct ufs_hba *hba = shost_priv(shost);
93e6c0e19d5bb1 drivers/ufs/core/ufshcd.c Peter Wang      2023-11-15 @6491  	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen   2023-05-29  6492  
f9c028e7415a5b drivers/ufs/core/ufshcd.c Bart Van Assche 2023-07-27  6493  	*ret = ufshcd_try_to_abort_task(hba, tag);
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen   2023-05-29  6494  	dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen   2023-05-29  6495  		hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
f9c028e7415a5b drivers/ufs/core/ufshcd.c Bart Van Assche 2023-07-27  6496  		*ret ? "failed" : "succeeded");
93e6c0e19d5bb1 drivers/ufs/core/ufshcd.c Peter Wang      2023-11-15  6497  
f9c028e7415a5b drivers/ufs/core/ufshcd.c Bart Van Assche 2023-07-27  6498  	return *ret == 0;
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen   2023-05-29  6499  }
f9c028e7415a5b drivers/ufs/core/ufshcd.c Bart Van Assche 2023-07-27  6500  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
