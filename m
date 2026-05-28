Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBA6211A14;
	Thu, 28 May 2026 04:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779943213; cv=none; b=RGa7hQSocMHKWDC+vx+bIWw/g9VIF3Gptl5uiF8FM1ICVHDbphrEGlD/soowjJSIL3hbkCQJfhkXzwkPlwgp7q5DloQ02Y3WUkNdOUjhDtNjB1niuyotkf4gt30QGv09dGHWcJzLGyqhj7tYOJiTJI0y7OnsAf3xXLvguwI+3wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779943213; c=relaxed/simple;
	bh=x5TGPvVOFYm9oEdVnSiOrj933HocKAUxSINE+lDN2Co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAu+ZVcdgS2+FRH8z3fXxxWIJPUm8orrylyfDz3OM1ptOUWMMHHzlnxJKpZFQMRkUPldKVcIINi6npsRRx+0BkDjXQMZf17OCv0f/+WxugNRGgnmq9FF/hUjdxg7d702RJfybk4kq99s8jt5AG9CfxINwqZU6mejaERihs0/h/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b+HLQP5s; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b+HLQP5s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779943211; x=1811479211;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x5TGPvVOFYm9oEdVnSiOrj933HocKAUxSINE+lDN2Co=;
  b=b+HLQP5sHg64EWcdtBQcKHw8frYXK/tJPhPikBk7hfsZQG5BL7m9iDpV
   qQzSu0iSogp2JIpY4Uh7DT7WdQshBKut9lY4PwP6HuThYGRv3ESzXZGXP
   MHpB+fy74HEiFBQOlH8BzmAX31gNdapr8NLaoDjWEPizom3Hyg390dp/T
   p2cqNLv+DcORPZgKTmb5PiiGGVcwAeM5PM54MHGX1P31QNkXGnvVM4+Ss
   GS6CcYMVfpjWUjrieU9K50KPpRxAXxjw3sB1/qfiLNjYP3xvYEYfUIsG8
   /UEXb9g9DGMfgsg/WHzcx/jgyOV6ipcDm3x4yC/ZJF027Js+Hy1didoci
   g==;
X-CSE-ConnectionGUID: orjVgL9gTCOqTjMAyNLpqw==
X-CSE-MsgGUID: xl/0geG+QzeTFysmcWa71A==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="79930622"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="79930622"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 21:40:10 -0700
X-CSE-ConnectionGUID: 7hE9au+JQlifbRIX5PRzug==
X-CSE-MsgGUID: FOJZqsq8TxmKUs0b19kjiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="247392664"
Received: from igk-lkp-server01.igk.intel.com (HELO 892db79562d4) ([10.211.93.152])
  by orviesa005.jf.intel.com with ESMTP; 27 May 2026 21:40:08 -0700
Received: from kbuild by 892db79562d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSSXN-000000000Hx-1iPv;
	Thu, 28 May 2026 04:40:05 +0000
Date: Thu, 28 May 2026 06:39:18 +0200
From: kernel test robot <lkp@intel.com>
To: Wentao Liang <vulab@iscas.ac.cn>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Kees Cook <kees@kernel.org>, Wentao Liang <vulab@iscas.ac.cn>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] target: iscsi: cxgbit: fix cnp kref leak in
 __cxgbit_free_cdev_np()
Message-ID: <202605280601.qcftuh6t-lkp@intel.com>
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
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20260528/202605280601.qcftuh6t-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605280601.qcftuh6t-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605280601.qcftuh6t-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/target/iscsi/cxgbit/cxgbit_cm.c:549:3: warning: misleading indentation; statement is not part of the previous 'if' [-Wmisleading-indentation]
     549 |                 return ret;
         |                 ^
   drivers/target/iscsi/cxgbit/cxgbit_cm.c:547:2: note: previous statement is here
     547 |         if (ret == -ETIMEDOUT)
         |         ^
   1 warning generated.


vim +/if +549 drivers/target/iscsi/cxgbit/cxgbit_cm.c

9730ffcb8957e1c Varun Prakash 2016-04-20  516  
9730ffcb8957e1c Varun Prakash 2016-04-20  517  static int
9730ffcb8957e1c Varun Prakash 2016-04-20  518  __cxgbit_free_cdev_np(struct cxgbit_device *cdev, struct cxgbit_np *cnp)
9730ffcb8957e1c Varun Prakash 2016-04-20  519  {
9730ffcb8957e1c Varun Prakash 2016-04-20  520  	int stid, ret;
9730ffcb8957e1c Varun Prakash 2016-04-20  521  	bool ipv6 = false;
9730ffcb8957e1c Varun Prakash 2016-04-20  522  
9730ffcb8957e1c Varun Prakash 2016-04-20  523  	stid = cxgbit_np_hash_del(cdev, cnp);
9730ffcb8957e1c Varun Prakash 2016-04-20  524  	if (stid < 0)
9730ffcb8957e1c Varun Prakash 2016-04-20  525  		return -EINVAL;
9730ffcb8957e1c Varun Prakash 2016-04-20  526  	if (!test_bit(CDEV_STATE_UP, &cdev->flags))
9730ffcb8957e1c Varun Prakash 2016-04-20  527  		return -EINVAL;
9730ffcb8957e1c Varun Prakash 2016-04-20  528  
9730ffcb8957e1c Varun Prakash 2016-04-20  529  	if (cnp->np->np_sockaddr.ss_family == AF_INET6)
9730ffcb8957e1c Varun Prakash 2016-04-20  530  		ipv6 = true;
9730ffcb8957e1c Varun Prakash 2016-04-20  531  
9730ffcb8957e1c Varun Prakash 2016-04-20  532  	cxgbit_get_cnp(cnp);
9730ffcb8957e1c Varun Prakash 2016-04-20  533  	cxgbit_init_wr_wait(&cnp->com.wr_wait);
9730ffcb8957e1c Varun Prakash 2016-04-20  534  	ret = cxgb4_remove_server(cdev->lldi.ports[0], stid,
9730ffcb8957e1c Varun Prakash 2016-04-20  535  				  cdev->lldi.rxq_ids[0], ipv6);
9730ffcb8957e1c Varun Prakash 2016-04-20  536  
9730ffcb8957e1c Varun Prakash 2016-04-20  537  	if (ret > 0)
9730ffcb8957e1c Varun Prakash 2016-04-20  538  		ret = net_xmit_errno(ret);
9730ffcb8957e1c Varun Prakash 2016-04-20  539  
9730ffcb8957e1c Varun Prakash 2016-04-20  540  	if (ret) {
9730ffcb8957e1c Varun Prakash 2016-04-20  541  		cxgbit_put_cnp(cnp);
9730ffcb8957e1c Varun Prakash 2016-04-20  542  		return ret;
9730ffcb8957e1c Varun Prakash 2016-04-20  543  	}
9730ffcb8957e1c Varun Prakash 2016-04-20  544  
9730ffcb8957e1c Varun Prakash 2016-04-20  545  	ret = cxgbit_wait_for_reply(cdev, &cnp->com.wr_wait,
9730ffcb8957e1c Varun Prakash 2016-04-20  546  				    0, 10, __func__);
9730ffcb8957e1c Varun Prakash 2016-04-20  547  	if (ret == -ETIMEDOUT)
956027c993d5b20 Wentao Liang  2026-05-27  548  		cxgbit_put_cnp(cnp);
9730ffcb8957e1c Varun Prakash 2016-04-20 @549  		return ret;
9730ffcb8957e1c Varun Prakash 2016-04-20  550  
9730ffcb8957e1c Varun Prakash 2016-04-20  551  	if (ipv6 && cnp->com.cdev) {
9730ffcb8957e1c Varun Prakash 2016-04-20  552  		struct sockaddr_in6 *sin6;
9730ffcb8957e1c Varun Prakash 2016-04-20  553  
9730ffcb8957e1c Varun Prakash 2016-04-20  554  		sin6 = (struct sockaddr_in6 *)&cnp->com.local_addr;
9730ffcb8957e1c Varun Prakash 2016-04-20  555  		cxgb4_clip_release(cdev->lldi.ports[0],
9730ffcb8957e1c Varun Prakash 2016-04-20  556  				   (const u32 *)&sin6->sin6_addr.s6_addr,
9730ffcb8957e1c Varun Prakash 2016-04-20  557  				   1);
9730ffcb8957e1c Varun Prakash 2016-04-20  558  	}
9730ffcb8957e1c Varun Prakash 2016-04-20  559  
9730ffcb8957e1c Varun Prakash 2016-04-20  560  	cxgb4_free_stid(cdev->lldi.tids, stid,
9730ffcb8957e1c Varun Prakash 2016-04-20  561  			cnp->com.local_addr.ss_family);
956027c993d5b20 Wentao Liang  2026-05-27  562  	cxgbit_put_cnp(cnp);
9730ffcb8957e1c Varun Prakash 2016-04-20  563  	return 0;
9730ffcb8957e1c Varun Prakash 2016-04-20  564  }
9730ffcb8957e1c Varun Prakash 2016-04-20  565  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
