Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D183FB9F;
	Sat, 26 Oct 2024 17:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729964723; cv=none; b=CAOcnLROLpzOb+dVEsglq+6i3pAYKkASBo/B0RBCGAkJPheXi24y5aBsnwLyRCwTrlOpfQfT6lWrXSWziL53erw8L/I4Onlcu9Q4JQlcL3xtmrmC6oA8cwXQ3lioyh4RldgFwvvPgyZnMXB2sBhubTuefwMzLBdGVJjtEYy30Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729964723; c=relaxed/simple;
	bh=+xOr9a7QBmgzvXt4K8ogW7y/X97Fm+JIp1HzB4NWPHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bMFpb7B+xKScjkzkaTgBSpg6sdFp8HUnseodvvuWbpj7XSQI9GzwNnb2ihI/wl/40/siYmKCLWhuz7sJwHc6z+2hrXxV7ZmfnFvqM1k8BeGQPKPVU3pc0UmOdq14g+SXSXkVHfTh1wsI6gFYhQ7glaDC6n28MUv+ugbetsniFEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jLRIoxno; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jLRIoxno"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729964721; x=1761500721;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+xOr9a7QBmgzvXt4K8ogW7y/X97Fm+JIp1HzB4NWPHM=;
  b=jLRIoxnomumwx3vNugVLyedLWTuV0pXCO0daKtIQY8tkewVAeWkUbBS0
   gDbgoSWuBDiH67sUwhD/ALHSCYZg5YYBKG4u6xfJ/SUxWZx7k1nDHpbYi
   bEFiDf+sGsjucu0rWwTtgJtoE2nhVqSMhAt72YA2kIVu+rAGAxxbEg71B
   0LHxTSXdlkskjvgU9hEx7dSEKE5enBbZ1qUdCfM1OVkXM6VE+4YVVewVc
   vAlqlY7XRLQmxJuwgS4rfjYILOC1iVxk9NaFlWwCPiCHQHub5RBIJhN+E
   PZtvuN3hiE3bwdlpwsxqvtesuC/Krd4CmTkHxq7YD7LdmikryPlnxPBj2
   A==;
X-CSE-ConnectionGUID: hLSFfTcIRliMxHvpi+WMsg==
X-CSE-MsgGUID: ottWsg4aTUa0fpCiaL/kbQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11237"; a="33524846"
X-IronPort-AV: E=Sophos;i="6.11,235,1725346800"; 
   d="scan'208";a="33524846"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2024 10:45:20 -0700
X-CSE-ConnectionGUID: ta/ZbhOLQbufXi2FTdmBvg==
X-CSE-MsgGUID: RgVkr9u8Ty6IAyzF3hBiyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="85974141"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 26 Oct 2024 10:45:15 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t4kqe-000Ztk-2L;
	Sat, 26 Oct 2024 17:45:12 +0000
Date: Sun, 27 Oct 2024 01:44:55 +0800
From: kernel test robot <lkp@intel.com>
To: Huan Tang <tanghuan@vivo.com>, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	beanhuo@micron.com, luhongfei@vivo.com, quic_cang@quicinc.com,
	keosung.park@samsung.com, viro@zeniv.linux.org.uk,
	quic_mnaresh@quicinc.com, peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org, ahalaney@redhat.com,
	quic_nguyenb@quicinc.com, linux@weissschuh.net, ebiggers@google.com,
	minwoo.im@samsung.com, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	opensource.kernel@vivo.com, Huan Tang <tanghuan@vivo.com>
Subject: Re: [PATCH v2] ufs: core: Add WB buffer resize support
Message-ID: <202410270108.zrM5GjRx-lkp@intel.com>
References: <20241026004423.135-1-tanghuan@vivo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241026004423.135-1-tanghuan@vivo.com>

Hi Huan,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.12-rc4 next-20241025]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Huan-Tang/ufs-core-Add-WB-buffer-resize-support/20241026-084545
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241026004423.135-1-tanghuan%40vivo.com
patch subject: [PATCH v2] ufs: core: Add WB buffer resize support
config: i386-buildonly-randconfig-001-20241026 (https://download.01.org/0day-ci/archive/20241027/202410270108.zrM5GjRx-lkp@intel.com/config)
compiler: clang version 19.1.2 (https://github.com/llvm/llvm-project 7ba7d8e2f7b6445b60679da826210cdde29eaf8b)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241027/202410270108.zrM5GjRx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410270108.zrM5GjRx-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/ufs/core/ufs-sysfs.c:12:
   In file included from drivers/ufs/core/ufshcd-priv.h:7:
   In file included from include/ufs/ufshcd.h:16:
   In file included from include/linux/blk-crypto-profile.h:9:
   In file included from include/linux/bio.h:10:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:8:
   In file included from include/linux/cacheflush.h:5:
   In file included from arch/x86/include/asm/cacheflush.h:5:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
>> drivers/ufs/core/ufs-sysfs.c:441:2: error: use of undeclared identifier 'index'
     441 |         index = ufshcd_wb_get_query_index(hba);
         |         ^
   1 warning and 1 error generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for GET_FREE_REGION
   Depends on [n]: SPARSEMEM [=n]
   Selected by [y]:
   - RESOURCE_KUNIT_TEST [=y] && RUNTIME_TESTING_MENU [=y] && KUNIT [=y]


vim +/index +441 drivers/ufs/core/ufs-sysfs.c

   413	
   414	static ssize_t wb_toggle_buf_resize_store(struct device *dev,
   415			struct device_attribute *attr, const char *buf, size_t count)
   416	{
   417		struct ufs_hba *hba = dev_get_drvdata(dev);
   418		unsigned int wb_buf_resize_op;
   419		ssize_t res;
   420	
   421		if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled ||
   422			!hba->dev_info.b_presrv_uspc_en) {
   423			dev_err(dev, "The WB buf resize is not allowed!\n");
   424			return -EOPNOTSUPP;
   425		}
   426	
   427		if (kstrtouint(buf, 0, &wb_buf_resize_op))
   428			return -EINVAL;
   429	
   430		if (wb_buf_resize_op != 0x01 && wb_buf_resize_op != 0x02) {
   431			dev_err(dev, "The operation %u is invalid!\n", wb_buf_resize_op);
   432			return -EINVAL;
   433		}
   434	
   435		down(&hba->host_sem);
   436		if (!ufshcd_is_user_access_allowed(hba)) {
   437			res = -EBUSY;
   438			goto out;
   439		}
   440	
 > 441		index = ufshcd_wb_get_query_index(hba);
   442		ufshcd_rpm_get_sync(hba);
   443		res = ufshcd_wb_toggle_buf_resize(hba, wb_buf_resize_op);
   444		ufshcd_rpm_put_sync(hba);
   445	
   446	out:
   447		up(&hba->host_sem);
   448		return res < 0 ? res : count;
   449	}
   450	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
