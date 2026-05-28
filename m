Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D4B1C860A;
	Thu, 28 May 2026 02:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779933969; cv=none; b=QSoirRjkfRu8dRGlVVcDEDGVZk7GVX1dGT6RHJ2xh6HLPGj0DkS9gw1pnaMccwSjERVk1wMb3HLuEx6RCpcquWrytgV0CL7dEa1drfZtjlAF3F6AYFBM8aKLJskx0ukXYtQKWihmjLjjPy6A3L9zV2cehekKQOBNJTGd4I95PsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779933969; c=relaxed/simple;
	bh=fbHrRWsCsev0XpjRGu7MWKUSpSvEPDO2W7/tolEiVlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SivQud7ewQnHVKKwjENblJYUhgenp9f1T1chPSRmEOBIX3iKc5eOu17xaDV7umpdy//KshMGV2F4xtyI/v3Ly06+R8fyWGOVRK5TYBHJLklPPWSxLfoyPNKI5W2Z+oUTL7pv2s8OdCmX4ppMglsdeqs8XwfJR74eNg9Lt0oOptA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AphQ2ywH; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AphQ2ywH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779933968; x=1811469968;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fbHrRWsCsev0XpjRGu7MWKUSpSvEPDO2W7/tolEiVlI=;
  b=AphQ2ywHffViWftFWb9ThB8fbywwfUa8KXLxDEDUiy2b0WxjEUbRAkRA
   hrssin+ZDvjfUTXkhN+2TPxUfSG8fC1pLgK/dJYALYSEGUs/Q3jE0dCJl
   o3opgkPDB0RZwPSEzYOSDlL8macvu4ei6XWrPh9/Y+c8JRurTmVTxIeb4
   YxOwngHtlUKMsh4KT3+uzGLSleIK9QHKQnLMNJTyoAi0+lQBWRayQaEL5
   NSW1VuauhB4QKjUdolZ6+pxGZT255cGF/Pvk8N7bzQ73qkPOUYtMiF4dD
   0utzg5obIAhjZsY9nn1wXtu1pH5AYkmu31wtBvdjZ5rDBkls13NSk1jq2
   Q==;
X-CSE-ConnectionGUID: rvugshktRwaVGjY1JlOt9w==
X-CSE-MsgGUID: RA2/0aJjTrWdECZ8YpZ1pw==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80744162"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="80744162"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 19:06:08 -0700
X-CSE-ConnectionGUID: 0XcchuQ2Q0+DOBeLeejZqg==
X-CSE-MsgGUID: 1ZdgjI7BQ/yZvCad8/YcgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="280528462"
Received: from igk-lkp-server01.igk.intel.com (HELO 892db79562d4) ([10.211.93.152])
  by orviesa001.jf.intel.com with ESMTP; 27 May 2026 19:06:05 -0700
Received: from kbuild by 892db79562d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSQ8J-000000000F7-0YER;
	Thu, 28 May 2026 02:06:03 +0000
Date: Thu, 28 May 2026 04:05:45 +0200
From: kernel test robot <lkp@intel.com>
To: Wentao Liang <vulab@iscas.ac.cn>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, Kees Cook <kees@kernel.org>,
	Wentao Liang <vulab@iscas.ac.cn>, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] target: iscsi: cxgbit: fix cnp kref leak in
 __cxgbit_free_cdev_np()
Message-ID: <202605280336.gXG4Wlij-lkp@intel.com>
References: <20260527103823.869792-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527103823.869792-1-vulab@iscas.ac.cn>

Hi Wentao,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on kees/for-next/pstore kees/for-next/kspp linus/master v7.1-rc5 next-20260527]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Wentao-Liang/target-iscsi-cxgbit-fix-cnp-kref-leak-in-__cxgbit_free_cdev_np/20260527-184050
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260527103823.869792-1-vulab%40iscas.ac.cn
patch subject: [PATCH] target: iscsi: cxgbit: fix cnp kref leak in __cxgbit_free_cdev_np()
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260528/202605280336.gXG4Wlij-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605280336.gXG4Wlij-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605280336.gXG4Wlij-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/target/iscsi/cxgbit/cxgbit_cm.c: In function '__cxgbit_free_cdev_np':
>> drivers/target/iscsi/cxgbit/cxgbit_cm.c:547:9: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
     547 |         if (ret == -ETIMEDOUT)
         |         ^~
   drivers/target/iscsi/cxgbit/cxgbit_cm.c:549:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
     549 |                 return ret;
         |                 ^~~~~~


vim +/if +547 drivers/target/iscsi/cxgbit/cxgbit_cm.c

9730ffcb8957e1 Varun Prakash 2016-04-20  516  
9730ffcb8957e1 Varun Prakash 2016-04-20  517  static int
9730ffcb8957e1 Varun Prakash 2016-04-20  518  __cxgbit_free_cdev_np(struct cxgbit_device *cdev, struct cxgbit_np *cnp)
9730ffcb8957e1 Varun Prakash 2016-04-20  519  {
9730ffcb8957e1 Varun Prakash 2016-04-20  520  	int stid, ret;
9730ffcb8957e1 Varun Prakash 2016-04-20  521  	bool ipv6 = false;
9730ffcb8957e1 Varun Prakash 2016-04-20  522  
9730ffcb8957e1 Varun Prakash 2016-04-20  523  	stid = cxgbit_np_hash_del(cdev, cnp);
9730ffcb8957e1 Varun Prakash 2016-04-20  524  	if (stid < 0)
9730ffcb8957e1 Varun Prakash 2016-04-20  525  		return -EINVAL;
9730ffcb8957e1 Varun Prakash 2016-04-20  526  	if (!test_bit(CDEV_STATE_UP, &cdev->flags))
9730ffcb8957e1 Varun Prakash 2016-04-20  527  		return -EINVAL;
9730ffcb8957e1 Varun Prakash 2016-04-20  528  
9730ffcb8957e1 Varun Prakash 2016-04-20  529  	if (cnp->np->np_sockaddr.ss_family == AF_INET6)
9730ffcb8957e1 Varun Prakash 2016-04-20  530  		ipv6 = true;
9730ffcb8957e1 Varun Prakash 2016-04-20  531  
9730ffcb8957e1 Varun Prakash 2016-04-20  532  	cxgbit_get_cnp(cnp);
9730ffcb8957e1 Varun Prakash 2016-04-20  533  	cxgbit_init_wr_wait(&cnp->com.wr_wait);
9730ffcb8957e1 Varun Prakash 2016-04-20  534  	ret = cxgb4_remove_server(cdev->lldi.ports[0], stid,
9730ffcb8957e1 Varun Prakash 2016-04-20  535  				  cdev->lldi.rxq_ids[0], ipv6);
9730ffcb8957e1 Varun Prakash 2016-04-20  536  
9730ffcb8957e1 Varun Prakash 2016-04-20  537  	if (ret > 0)
9730ffcb8957e1 Varun Prakash 2016-04-20  538  		ret = net_xmit_errno(ret);
9730ffcb8957e1 Varun Prakash 2016-04-20  539  
9730ffcb8957e1 Varun Prakash 2016-04-20  540  	if (ret) {
9730ffcb8957e1 Varun Prakash 2016-04-20  541  		cxgbit_put_cnp(cnp);
9730ffcb8957e1 Varun Prakash 2016-04-20  542  		return ret;
9730ffcb8957e1 Varun Prakash 2016-04-20  543  	}
9730ffcb8957e1 Varun Prakash 2016-04-20  544  
9730ffcb8957e1 Varun Prakash 2016-04-20  545  	ret = cxgbit_wait_for_reply(cdev, &cnp->com.wr_wait,
9730ffcb8957e1 Varun Prakash 2016-04-20  546  				    0, 10, __func__);
9730ffcb8957e1 Varun Prakash 2016-04-20 @547  	if (ret == -ETIMEDOUT)
956027c993d5b2 Wentao Liang  2026-05-27  548  		cxgbit_put_cnp(cnp);
9730ffcb8957e1 Varun Prakash 2016-04-20  549  		return ret;
9730ffcb8957e1 Varun Prakash 2016-04-20  550  
9730ffcb8957e1 Varun Prakash 2016-04-20  551  	if (ipv6 && cnp->com.cdev) {
9730ffcb8957e1 Varun Prakash 2016-04-20  552  		struct sockaddr_in6 *sin6;
9730ffcb8957e1 Varun Prakash 2016-04-20  553  
9730ffcb8957e1 Varun Prakash 2016-04-20  554  		sin6 = (struct sockaddr_in6 *)&cnp->com.local_addr;
9730ffcb8957e1 Varun Prakash 2016-04-20  555  		cxgb4_clip_release(cdev->lldi.ports[0],
9730ffcb8957e1 Varun Prakash 2016-04-20  556  				   (const u32 *)&sin6->sin6_addr.s6_addr,
9730ffcb8957e1 Varun Prakash 2016-04-20  557  				   1);
9730ffcb8957e1 Varun Prakash 2016-04-20  558  	}
9730ffcb8957e1 Varun Prakash 2016-04-20  559  
9730ffcb8957e1 Varun Prakash 2016-04-20  560  	cxgb4_free_stid(cdev->lldi.tids, stid,
9730ffcb8957e1 Varun Prakash 2016-04-20  561  			cnp->com.local_addr.ss_family);
956027c993d5b2 Wentao Liang  2026-05-27  562  	cxgbit_put_cnp(cnp);
9730ffcb8957e1 Varun Prakash 2016-04-20  563  	return 0;
9730ffcb8957e1 Varun Prakash 2016-04-20  564  }
9730ffcb8957e1 Varun Prakash 2016-04-20  565  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
