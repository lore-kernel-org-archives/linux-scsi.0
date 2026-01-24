Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B678627B327;
	Sat, 24 Jan 2026 22:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769294506; cv=none; b=DLvocPyO+cOKhlupH4sFDgy2+imtpcazyiM5ZlySi6XgkaNbnW06GtI+0UAaCd9+G3wAcUlzNy2b9Hb5kmIESJzq8wKfbEhPF4wltaLvmJFt7xkQdffnkiR5RBF0QIDXkAdbFdK6EWD/ATwSluM1bZmLhTXC/8ssSzMWYS6ZCnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769294506; c=relaxed/simple;
	bh=WXKAC/fyF/NXplXJWNiQwBzi6DaoJqGNLNtWfgdhnOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xh1jLiLhaW0CGV1elwzovg4MKsugz4IlhhkXyQqQcYNpX73vhiMTfCa0jDZGtkN3ooqSLB10M9uZTHxnqfag4aXXhQSsiHR8ftt9KqTkhdPrfOCv5OlKQeZoIDH9O3Y82g7h2jqXpqC+kwm/rHAUM7DuFeC+XCZpxZ9LnvEif+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=laaX7ZAz; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="laaX7ZAz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769294505; x=1800830505;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WXKAC/fyF/NXplXJWNiQwBzi6DaoJqGNLNtWfgdhnOw=;
  b=laaX7ZAz9wBnBhzQRD16+BgWBaXmPp3PfOySzQ/UMaS8QjYE55br2f4J
   V8zcdf6ACFRob9OycyWO0PCkYCrhmp40qLnlVJMXXID9U5ZvwlCeNDG3+
   H7eLTCUxMJRkXT5OWOJMMciDIEA+FFtgbuiqKZCXemCM6iYkg4tlfnSUW
   IueVENnKYfjv8a8ubwc+CcddGOaJBQz/sTgEJh25vrezWtMwzsNDuCXe4
   cyViw2JZ6wNDh9w3jytILGnfIpzQCuKRWoADRu7W47Q/NHqoQpdP5mdYa
   SIGPxb+kK6ZaxoO58xKRBPq5zDxnrDsQjg2weZrjvQPfCWTEjaEtPLjHV
   Q==;
X-CSE-ConnectionGUID: VhBGJk2OQEKqGr7EXDsaRA==
X-CSE-MsgGUID: dw+sPdDUToyFcdUaIeqUEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="93174515"
X-IronPort-AV: E=Sophos;i="6.21,251,1763452800"; 
   d="scan'208";a="93174515"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 14:41:45 -0800
X-CSE-ConnectionGUID: rlROHsk0RwapfHGlgyqhJw==
X-CSE-MsgGUID: nrGQiIp0QWqPtPE6cH7Zmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,251,1763452800"; 
   d="scan'208";a="230293682"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 24 Jan 2026 14:41:38 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vjmJz-00000000Vau-3yq4;
	Sat, 24 Jan 2026 22:41:35 +0000
Date: Sun, 25 Jan 2026 06:41:04 +0800
From: kernel test robot <lkp@intel.com>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	Vinod Koul <vkoul@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Chaotian Jing <Chaotian.Jing@mediatek.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	kernel@collabora.com, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Subject: Re: [PATCH v6 14/24] scsi: ufs: mediatek: Switch to newer PM ops
 helpers
Message-ID: <202601250638.kCl6evPM-lkp@intel.com>
References: <20260124-mt8196-ufs-v6-14-e7c005b60028@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260124-mt8196-ufs-v6-14-e7c005b60028@collabora.com>

Hi Nicolas,

kernel test robot noticed the following build errors:

[auto build test ERROR on 4af4e95edc37ae54f64cbd75b46f16ce15f3a6b8]

url:    https://github.com/intel-lab-lkp/linux/commits/Nicolas-Frattaroli/dt-bindings-phy-Add-mediatek-mt8196-ufsphy-variant/20260124-201226
base:   4af4e95edc37ae54f64cbd75b46f16ce15f3a6b8
patch link:    https://lore.kernel.org/r/20260124-mt8196-ufs-v6-14-e7c005b60028%40collabora.com
patch subject: [PATCH v6 14/24] scsi: ufs: mediatek: Switch to newer PM ops helpers
config: arm64-randconfig-004-20260125 (https://download.01.org/0day-ci/archive/20260125/202601250638.kCl6evPM-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260125/202601250638.kCl6evPM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601250638.kCl6evPM-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/ufs/host/ufs-mediatek.c:2339:8: error: call to undeclared function 'ufshcd_system_suspend'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2339 |         ret = ufshcd_system_suspend(dev);
         |               ^
   drivers/ufs/host/ufs-mediatek.c:2339:8: note: did you mean 'ufs_mtk_system_suspend'?
   drivers/ufs/host/ufs-mediatek.c:2328:12: note: 'ufs_mtk_system_suspend' declared here
    2328 | static int ufs_mtk_system_suspend(struct device *dev)
         |            ^
    2329 | {
    2330 |         struct ufs_hba *hba = dev_get_drvdata(dev);
    2331 |         struct arm_smccc_res res;
    2332 |         int ret;
    2333 | 
    2334 |         if (hba->shutting_down) {
    2335 |                 ret = -EBUSY;
    2336 |                 goto out;
    2337 |         }
    2338 | 
    2339 |         ret = ufshcd_system_suspend(dev);
         |               ~~~~~~~~~~~~~~~~~~~~~
         |               ufs_mtk_system_suspend
>> drivers/ufs/host/ufs-mediatek.c:2370:8: error: call to undeclared function 'ufshcd_system_resume'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2370 |         ret = ufshcd_system_resume(dev);
         |               ^
   drivers/ufs/host/ufs-mediatek.c:2370:8: note: did you mean 'ufs_mtk_system_resume'?
   drivers/ufs/host/ufs-mediatek.c:2355:12: note: 'ufs_mtk_system_resume' declared here
    2355 | static int ufs_mtk_system_resume(struct device *dev)
         |            ^
    2356 | {
    2357 |         int ret = 0;
    2358 |         struct ufs_hba *hba = dev_get_drvdata(dev);
    2359 |         struct arm_smccc_res res;
    2360 | 
    2361 |         if (pm_runtime_suspended(hba->dev))
    2362 |                 goto out;
    2363 | 
    2364 |         if (ufs_mtk_is_rtff_mtcmos(hba))
    2365 |                 ufs_mtk_mtcmos_ctrl(true, res);
    2366 | 
    2367 |         ufs_mtk_dev_vreg_set_lpm(hba, false);
    2368 | 
    2369 | out:
    2370 |         ret = ufshcd_system_resume(dev);
         |               ~~~~~~~~~~~~~~~~~~~~
         |               ufs_mtk_system_resume
   2 errors generated.


vim +/ufshcd_system_suspend +2339 drivers/ufs/host/ufs-mediatek.c

ddd90623ce26ea drivers/scsi/ufs/ufs-mediatek.c Stanley Chu 2019-03-16  2327  
e7bf1d50063ce0 drivers/ufs/host/ufs-mediatek.c Stanley Chu 2022-06-23  2328  static int ufs_mtk_system_suspend(struct device *dev)
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2329  {
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2330  	struct ufs_hba *hba = dev_get_drvdata(dev);
a6888d623eae6d drivers/ufs/host/ufs-mediatek.c Alice Chao  2024-03-15  2331  	struct arm_smccc_res res;
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2332  	int ret;
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2333  
014de20bb36ba0 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-24  2334  	if (hba->shutting_down) {
014de20bb36ba0 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-24  2335  		ret = -EBUSY;
014de20bb36ba0 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-24  2336  		goto out;
014de20bb36ba0 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-24  2337  	}
014de20bb36ba0 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-24  2338  
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16 @2339  	ret = ufshcd_system_suspend(dev);
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2340  	if (ret)
77b96ef70b6ba4 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-03  2341  		goto out;
77b96ef70b6ba4 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-03  2342  
77b96ef70b6ba4 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-03  2343  	if (pm_runtime_suspended(hba->dev))
77b96ef70b6ba4 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-03  2344  		goto out;
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2345  
42b1928360a32e drivers/ufs/host/ufs-mediatek.c Stanley Chu 2022-06-16  2346  	ufs_mtk_dev_vreg_set_lpm(hba, true);
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2347  
a6888d623eae6d drivers/ufs/host/ufs-mediatek.c Alice Chao  2024-03-15  2348  	if (ufs_mtk_is_rtff_mtcmos(hba))
a6888d623eae6d drivers/ufs/host/ufs-mediatek.c Alice Chao  2024-03-15  2349  		ufs_mtk_mtcmos_ctrl(false, res);
a6888d623eae6d drivers/ufs/host/ufs-mediatek.c Alice Chao  2024-03-15  2350  
77b96ef70b6ba4 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-03  2351  out:
77b96ef70b6ba4 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-03  2352  	return ret;
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2353  }
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2354  
e7bf1d50063ce0 drivers/ufs/host/ufs-mediatek.c Stanley Chu 2022-06-23  2355  static int ufs_mtk_system_resume(struct device *dev)
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2356  {
77b96ef70b6ba4 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-03  2357  	int ret = 0;
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2358  	struct ufs_hba *hba = dev_get_drvdata(dev);
a6888d623eae6d drivers/ufs/host/ufs-mediatek.c Alice Chao  2024-03-15  2359  	struct arm_smccc_res res;
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2360  
77b96ef70b6ba4 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-03  2361  	if (pm_runtime_suspended(hba->dev))
77b96ef70b6ba4 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-03  2362  		goto out;
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2363  
a6888d623eae6d drivers/ufs/host/ufs-mediatek.c Alice Chao  2024-03-15  2364  	if (ufs_mtk_is_rtff_mtcmos(hba))
a6888d623eae6d drivers/ufs/host/ufs-mediatek.c Alice Chao  2024-03-15  2365  		ufs_mtk_mtcmos_ctrl(true, res);
a6888d623eae6d drivers/ufs/host/ufs-mediatek.c Alice Chao  2024-03-15  2366  
b2f8abadabea32 drivers/ufs/host/ufs-mediatek.c Alice Chao  2025-09-03  2367  	ufs_mtk_dev_vreg_set_lpm(hba, false);
b2f8abadabea32 drivers/ufs/host/ufs-mediatek.c Alice Chao  2025-09-03  2368  
77b96ef70b6ba4 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-03  2369  out:
77b96ef70b6ba4 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-03 @2370  	ret = ufshcd_system_resume(dev);
77b96ef70b6ba4 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-03  2371  
77b96ef70b6ba4 drivers/ufs/host/ufs-mediatek.c Peter Wang  2025-09-03  2372  	return ret;
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2373  }
3fd23b8dfb54d9 drivers/ufs/host/ufs-mediatek.c Po-Wen Kao  2022-06-16  2374  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
