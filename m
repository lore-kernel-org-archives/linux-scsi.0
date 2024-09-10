Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351211DFE8;
	Tue, 10 Sep 2024 02:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725935212; cv=none; b=CgFh1Ei4yLvoV1jWHnabN/4Pszjb6cK9S1CZnEcE1FcUSMaLHhh2gcXV9AhRuGh+jb9KySXBRDhgFcrC/pSXW+nqS5Gw79FRYH/VUp5mkM1tCeLzAWD5i6eqDLXyTA++UPo7J1yDfLLqOuaqJ1MntgIJNMELtiYVz7qPBQaNtPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725935212; c=relaxed/simple;
	bh=qfCo7CWDjo8C5PX//LxJClRCdMO1VezwbwLCIJ4qMEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gGvgriktPyAe83cUgsIZhhqQtAPiQM+SELD27zWFLbp5GE45bmmlx3XrNQQS/+1qF5mL8lYHxj287f1teYCQTUUHLb9z+IIVnrHhqc9AflQptnUvZLQir6bmvKR6wPuwHiaXggkwzU6FBurUjTJ2EdmFAqYvMYMeXTfGW/Tgx6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aaRlWjM/; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aaRlWjM/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725935210; x=1757471210;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qfCo7CWDjo8C5PX//LxJClRCdMO1VezwbwLCIJ4qMEg=;
  b=aaRlWjM/ZuNOgsVvuCO1SMDK7MMsR44Tp/WyOQI/ZtGgDBUwzNDO+NZK
   6UK0+DVsZt3/67O+ai5gY+TY55KGsUNi6sm/rR3kU08xkiUyjk3j7XCcp
   45nucbajyuk/pxo+cQypGDbt2rVnb5kYDv765ySHgM1EVBQ7dFxIfLBti
   Xx5lZo7ohBBoi9Yk7FAeftRPpFDljg/KG397nRzBwFkTM1vSAIC5dbEdL
   8hewJgFY0keUJ+fZxhJSrn52pTJzD2K0LHS0FFJKb+Kphr4RN/NLe3PdT
   b1YTDUWh+2dX92mi2DBPVZ/wA8L5eblJSmrfmKu5qzG/O74XpfUy05MMj
   w==;
X-CSE-ConnectionGUID: gzoAvRnURV+OvjfzoxsEtg==
X-CSE-MsgGUID: g3Vuod9DSTmeBsI5lVNx8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="27586037"
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="27586037"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 19:26:50 -0700
X-CSE-ConnectionGUID: X7VduuaZTvm4WkEzn3xtkg==
X-CSE-MsgGUID: Zn+BusswT2+GsUNA6xRSYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="67165077"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 09 Sep 2024 19:26:48 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1snqab-000FXi-1m;
	Tue, 10 Sep 2024 02:26:45 +0000
Date: Tue, 10 Sep 2024 10:25:58 +0800
From: kernel test robot <lkp@intel.com>
To: Avri Altman <avri.altman@wdc.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH] scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb
Message-ID: <202409101048.isDGxmBR-lkp@intel.com>
References: <20240909095646.3756308-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909095646.3756308-1-avri.altman@wdc.com>

Hi Avri,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.11-rc7 next-20240909]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Avri-Altman/scsi-ufs-Use-pre-calculated-offsets-in-ufshcd_init_lrb/20240909-180037
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240909095646.3756308-1-avri.altman%40wdc.com
patch subject: [PATCH] scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb
config: x86_64-randconfig-121-20240910 (https://download.01.org/0day-ci/archive/20240910/202409101048.isDGxmBR-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240910/202409101048.isDGxmBR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409101048.isDGxmBR-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/ufs/core/ufshcd.c:2922:40: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned short [usertype] response_offset @@     got restricted __le16 [usertype] response_upiu_offset @@
   drivers/ufs/core/ufshcd.c:2922:40: sparse:     expected unsigned short [usertype] response_offset
   drivers/ufs/core/ufshcd.c:2922:40: sparse:     got restricted __le16 [usertype] response_upiu_offset
>> drivers/ufs/core/ufshcd.c:2923:36: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned short [usertype] prdt_offset @@     got restricted __le16 [usertype] prd_table_offset @@
   drivers/ufs/core/ufshcd.c:2923:36: sparse:     expected unsigned short [usertype] prdt_offset
   drivers/ufs/core/ufshcd.c:2923:36: sparse:     got restricted __le16 [usertype] prd_table_offset

vim +2922 drivers/ufs/core/ufshcd.c

  2914	
  2915	static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
  2916	{
  2917		struct utp_transfer_cmd_desc *cmd_descp = (void *)hba->ucdl_base_addr +
  2918			i * ufshcd_get_ucd_size(hba);
  2919		struct utp_transfer_req_desc *utrdlp = hba->utrdl_base_addr;
  2920		dma_addr_t cmd_desc_element_addr = hba->ucdl_dma_addr +
  2921			i * ufshcd_get_ucd_size(hba);
> 2922		u16 response_offset = utrdlp[i].response_upiu_offset;
> 2923		u16 prdt_offset = utrdlp[i].prd_table_offset;
  2924	
  2925		lrb->utr_descriptor_ptr = utrdlp + i;
  2926		lrb->utrd_dma_addr = hba->utrdl_dma_addr +
  2927			i * sizeof(struct utp_transfer_req_desc);
  2928		lrb->ucd_req_ptr = (struct utp_upiu_req *)cmd_descp->command_upiu;
  2929		lrb->ucd_req_dma_addr = cmd_desc_element_addr;
  2930		lrb->ucd_rsp_ptr = (struct utp_upiu_rsp *)cmd_descp->response_upiu;
  2931		lrb->ucd_rsp_dma_addr = cmd_desc_element_addr + response_offset;
  2932		lrb->ucd_prdt_ptr = (struct ufshcd_sg_entry *)cmd_descp->prd_table;
  2933		lrb->ucd_prdt_dma_addr = cmd_desc_element_addr + prdt_offset;
  2934	}
  2935	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
