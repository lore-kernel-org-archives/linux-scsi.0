Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C0E13B286;
	Sat, 26 Oct 2024 17:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729962262; cv=none; b=SGTmWtA0Kbw3F5SbGMZ4YaqhGYxDeNoQ/uPp2lnP4wCZ6cnxrnq0N3pwiHqlvXKQN/qITEkz6cSoFBXu9grqF2Rp5jhw4rhB2GIBIDNIp6KNGhUKp2LmUXvoB3PMCTXSrLRW4Cf8mtj3Q5lvjOfKucMyLRbVMk7s3lKH9uOQ+co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729962262; c=relaxed/simple;
	bh=wnSkEhmUEgW3X1vsBPM9gY4j2B1BaolcQuzXoGqR2B4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VAYz9u3JU+0R3hSBn//T5LSHY5j4XUoFc7xk+Skq3UtHKPRiicOi4aYeAV6fifrc+BrjIvangnm0U//wMtZGgTA+qq1Abyv4mnS5M4wuCW8dHacgeFXklU8/xHvl2w5rRsvwwxslRAjCF7tHsdbIynnvgGa6U9Dtm6y2u4LvGms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MNXbCJ/8; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MNXbCJ/8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729962260; x=1761498260;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wnSkEhmUEgW3X1vsBPM9gY4j2B1BaolcQuzXoGqR2B4=;
  b=MNXbCJ/8xxDaRobf+SN1LzAna7pp0RmuDGIE9SQQPxwcWjBsGwB/zhzX
   vDGt9qbOLKQHK30PcJCAxnIfUdepu5reD+w294Eccm/k0fz+l6re/dDp+
   0kYJ+ZjU6m4DAUSnJPM9JilNIm205ks0MoZbnLjzrAfy4AK1hbH6omQ0S
   Bn1OCnv73yPtuZROP4lnuTFMP+WmuXVIQfaVQynYuMsDvOoE2CtrCo8NA
   jqYr4V1OhrM+/15E5QDA7DA9VFU/i9hEZhGdmlMW1DKhdOr1Ril6hawRQ
   u49HuW/AxzX7vAbfpsmeAs84jh54HLaSNMawtCR8uUIoYlMLaJYYo3GnZ
   w==;
X-CSE-ConnectionGUID: J4TDE6y7SHiarcYTWsX67Q==
X-CSE-MsgGUID: wkuMxyvRQpi//Q7ojtPKXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11237"; a="29717500"
X-IronPort-AV: E=Sophos;i="6.11,235,1725346800"; 
   d="scan'208";a="29717500"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2024 10:04:20 -0700
X-CSE-ConnectionGUID: v2KZdODNSbaxkJyy4S/XOA==
X-CSE-MsgGUID: hB856hY6RmSThGOH82GxXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,235,1725346800"; 
   d="scan'208";a="81369676"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 26 Oct 2024 10:04:14 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t4kCx-000ZsF-2D;
	Sat, 26 Oct 2024 17:04:11 +0000
Date: Sun, 27 Oct 2024 01:03:20 +0800
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
Cc: oe-kbuild-all@lists.linux.dev, opensource.kernel@vivo.com,
	Huan Tang <tanghuan@vivo.com>
Subject: Re: [PATCH v2] ufs: core: Add WB buffer resize support
Message-ID: <202410270024.rwb7xAgC-lkp@intel.com>
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
config: i386-randconfig-141-20241026 (https://download.01.org/0day-ci/archive/20241027/202410270024.rwb7xAgC-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241027/202410270024.rwb7xAgC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410270024.rwb7xAgC-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/ufs/core/ufs-sysfs.c: In function 'wb_toggle_buf_resize_store':
>> drivers/ufs/core/ufs-sysfs.c:441:9: error: 'index' undeclared (first use in this function)
     441 |         index = ufshcd_wb_get_query_index(hba);
         |         ^~~~~
   drivers/ufs/core/ufs-sysfs.c:441:9: note: each undeclared identifier is reported only once for each function it appears in

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for GET_FREE_REGION
   Depends on [n]: SPARSEMEM [=n]
   Selected by [m]:
   - RESOURCE_KUNIT_TEST [=m] && RUNTIME_TESTING_MENU [=y] && KUNIT [=y]


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
