Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255E8253F12;
	Thu,  9 Oct 2025 21:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760045819; cv=none; b=dOzpiKFedK7XkuqKtvoTzVIDJjsmKBxg96s305TQukZnDfmaD72vgjpFaRgP9qs9v047xnCyFNDWxWGOxciHonX68TePMQFhXJVDhqBGMZtz3EcqlCB/qRd0I9eFIqc8vlseGqHibT7aHFA7UrTVYYMy2/7U7r1LVupzCoTOtdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760045819; c=relaxed/simple;
	bh=lRU6V8RgpwgSzX5ER9OoVwCUnbSEWEdwpO2FocCv3wU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oXMtKJfU6FIc5TrnI6fR649dsiER/4nxMMd77X/uvAOG494X6LnNGc3/4oe2P7Yiorsc99xHUsPCjle3yhFD5Ec7t86sEW80Ilna34vr9+1Ir39fNLx++pPd/XmL3wrNojLSEM+F/1ji54ZsrDcWXNkQnxDxWsR5wxZdDASydVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LAFXI5oH; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LAFXI5oH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760045817; x=1791581817;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lRU6V8RgpwgSzX5ER9OoVwCUnbSEWEdwpO2FocCv3wU=;
  b=LAFXI5oHGwkc+Uk1DZdna1Uy4f42Kb2fr8rh9WRVdAO4GO0Y+PqHM3l9
   QTwMPoFLOjS4lo9CXMHrC1DAr5IIPFwGljnjFKJJ96NQW+z6yw2Mw5Om6
   1D3z3yo5GKYVPd3qWH0IeQ9GbRwpkHK6ny07vDKZ6bAYOcgzO089SAU8f
   mZuVo1Sy61ucd5/WFuxrh/xTxQn/sh5NtNWALcGQSG7t8ldLZfGgH1rF3
   jTkgZrumje2ajhQf+G1+woG+CRby+PVRt3Le+ZNJQGfL1QVbbt2KYm07U
   xKSv8PqHAhNBtYk97vC9RJsaiqTlckiB6ewMet9KZm/GhUbayR580l7Nq
   g==;
X-CSE-ConnectionGUID: 8c1EaRRNSfOfE5XhtMHI+Q==
X-CSE-MsgGUID: ABdW0UkyTuuphbW9hEQt+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="87726917"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="87726917"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 14:36:56 -0700
X-CSE-ConnectionGUID: E7s1Qxo+TDKZWxnYoWat3w==
X-CSE-MsgGUID: HCDAc9lCTYWG9h1xUHCI/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="186082523"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 09 Oct 2025 14:36:53 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v6yJe-0001VF-2H;
	Thu, 09 Oct 2025 21:36:50 +0000
Date: Fri, 10 Oct 2025 05:36:32 +0800
From: kernel test robot <lkp@intel.com>
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com,
	avri.altman@sandisk.com, bvanassche@acm.org,
	alim.akhtar@samsung.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, can.guo@oss.qualcomm.com,
	ulf.hansson@linaro.org, beanhuo@micron.com,
	jens.wiklander@linaro.org
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
Message-ID: <202510100521.pnAPqTFK-lkp@intel.com>
References: <20251008201920.89575-4-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008201920.89575-4-beanhuo@iokpp.de>

Hi Bean,

kernel test robot noticed the following build errors:

[auto build test ERROR on v6.17]
[also build test ERROR on next-20251009]
[cannot apply to mkp-scsi/for-next jejb-scsi/for-next char-misc/char-misc-testing char-misc/char-misc-next char-misc/char-misc-linus linus/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bean-Huo/scsi-ufs-core-Convert-string-descriptor-format-macros-to-enum/20251009-204745
base:   v6.17
patch link:    https://lore.kernel.org/r/20251008201920.89575-4-beanhuo%40iokpp.de
patch subject: [PATCH v4 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices
config: sh-randconfig-002-20251010 (https://download.01.org/0day-ci/archive/20251010/202510100521.pnAPqTFK-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251010/202510100521.pnAPqTFK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510100521.pnAPqTFK-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/byteorder/big_endian.h:5,
                    from arch/sh/include/uapi/asm/byteorder.h:8,
                    from arch/sh/include/asm/bitops.h:10,
                    from include/linux/bitops.h:67,
                    from include/linux/log2.h:12,
                    from include/asm-generic/div64.h:55,
                    from ./arch/sh/include/generated/asm/div64.h:1,
                    from include/linux/math.h:6,
                    from include/linux/math64.h:6,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from drivers/ufs/core/ufs-rpmb.c:13:
   drivers/ufs/core/ufs-rpmb.c: In function 'ufs_rpmb_route_frames':
   drivers/ufs/core/ufs-rpmb.c:72:39: error: invalid use of undefined type 'struct rpmb_frame'
      72 |         req_type = be16_to_cpu(frm_out->req_resp);
         |                                       ^~
   include/uapi/linux/byteorder/big_endian.h:43:51: note: in definition of macro '__be16_to_cpu'
      43 | #define __be16_to_cpu(x) ((__force __u16)(__be16)(x))
         |                                                   ^
   drivers/ufs/core/ufs-rpmb.c:72:20: note: in expansion of macro 'be16_to_cpu'
      72 |         req_type = be16_to_cpu(frm_out->req_resp);
         |                    ^~~~~~~~~~~
   drivers/ufs/core/ufs-rpmb.c:75:14: error: 'RPMB_PROGRAM_KEY' undeclared (first use in this function)
      75 |         case RPMB_PROGRAM_KEY:
         |              ^~~~~~~~~~~~~~~~
   drivers/ufs/core/ufs-rpmb.c:75:14: note: each undeclared identifier is reported only once for each function it appears in
   drivers/ufs/core/ufs-rpmb.c:76:39: error: invalid application of 'sizeof' to incomplete type 'struct rpmb_frame'
      76 |                 if (req_len != sizeof(struct rpmb_frame) || resp_len != sizeof(struct rpmb_frame))
         |                                       ^~~~~~
   drivers/ufs/core/ufs-rpmb.c:76:80: error: invalid application of 'sizeof' to incomplete type 'struct rpmb_frame'
      76 |                 if (req_len != sizeof(struct rpmb_frame) || resp_len != sizeof(struct rpmb_frame))
         |                                                                                ^~~~~~
   drivers/ufs/core/ufs-rpmb.c:79:14: error: 'RPMB_GET_WRITE_COUNTER' undeclared (first use in this function)
      79 |         case RPMB_GET_WRITE_COUNTER:
         |              ^~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufs-rpmb.c:80:39: error: invalid application of 'sizeof' to incomplete type 'struct rpmb_frame'
      80 |                 if (req_len != sizeof(struct rpmb_frame) || resp_len != sizeof(struct rpmb_frame))
         |                                       ^~~~~~
   drivers/ufs/core/ufs-rpmb.c:80:80: error: invalid application of 'sizeof' to incomplete type 'struct rpmb_frame'
      80 |                 if (req_len != sizeof(struct rpmb_frame) || resp_len != sizeof(struct rpmb_frame))
         |                                                                                ^~~~~~
   drivers/ufs/core/ufs-rpmb.c:84:14: error: 'RPMB_WRITE_DATA' undeclared (first use in this function)
      84 |         case RPMB_WRITE_DATA:
         |              ^~~~~~~~~~~~~~~
   drivers/ufs/core/ufs-rpmb.c:85:38: error: invalid application of 'sizeof' to incomplete type 'struct rpmb_frame'
      85 |                 if (req_len % sizeof(struct rpmb_frame) || resp_len != sizeof(struct rpmb_frame))
         |                                      ^~~~~~
   drivers/ufs/core/ufs-rpmb.c:85:79: error: invalid application of 'sizeof' to incomplete type 'struct rpmb_frame'
      85 |                 if (req_len % sizeof(struct rpmb_frame) || resp_len != sizeof(struct rpmb_frame))
         |                                                                               ^~~~~~
   drivers/ufs/core/ufs-rpmb.c:88:14: error: 'RPMB_READ_DATA' undeclared (first use in this function); did you mean 'D_REAL_DATA'?
      88 |         case RPMB_READ_DATA:
         |              ^~~~~~~~~~~~~~
         |              D_REAL_DATA
   drivers/ufs/core/ufs-rpmb.c:89:39: error: invalid application of 'sizeof' to incomplete type 'struct rpmb_frame'
      89 |                 if (req_len != sizeof(struct rpmb_frame) || resp_len % sizeof(struct rpmb_frame))
         |                                       ^~~~~~
   drivers/ufs/core/ufs-rpmb.c:89:79: error: invalid application of 'sizeof' to incomplete type 'struct rpmb_frame'
      89 |                 if (req_len != sizeof(struct rpmb_frame) || resp_len % sizeof(struct rpmb_frame))
         |                                                                               ^~~~~~
   drivers/ufs/core/ufs-rpmb.c:109:43: error: invalid application of 'sizeof' to incomplete type 'struct rpmb_frame'
     109 |                 memset(frm_resp, 0, sizeof(*frm_resp));
         |                                           ^
   drivers/ufs/core/ufs-rpmb.c:110:25: error: invalid use of undefined type 'struct rpmb_frame'
     110 |                 frm_resp->req_resp = cpu_to_be16(RPMB_RESULT_READ);
         |                         ^~
   drivers/ufs/core/ufs-rpmb.c:110:50: error: 'RPMB_RESULT_READ' undeclared (first use in this function)
     110 |                 frm_resp->req_resp = cpu_to_be16(RPMB_RESULT_READ);
         |                                                  ^~~~~~~~~~~~~~~~
   include/uapi/linux/byteorder/big_endian.h:42:51: note: in definition of macro '__cpu_to_be16'
      42 | #define __cpu_to_be16(x) ((__force __be16)(__u16)(x))
         |                                                   ^
   drivers/ufs/core/ufs-rpmb.c:110:38: note: in expansion of macro 'cpu_to_be16'
     110 |                 frm_resp->req_resp = cpu_to_be16(RPMB_RESULT_READ);
         |                                      ^~~~~~~~~~~
   drivers/ufs/core/ufs-rpmb.c: At top level:
>> drivers/ufs/core/ufs-rpmb.c:135:5: error: redefinition of 'ufs_rpmb_probe'
     135 | int ufs_rpmb_probe(struct ufs_hba *hba)
         |     ^~~~~~~~~~~~~~
   In file included from drivers/ufs/core/ufs-rpmb.c:22:
   drivers/ufs/core/ufshcd-priv.h:424:19: note: previous definition of 'ufs_rpmb_probe' with type 'int(struct ufs_hba *)'
     424 | static inline int ufs_rpmb_probe(struct ufs_hba *hba)
         |                   ^~~~~~~~~~~~~~
>> drivers/ufs/core/ufs-rpmb.c:229:6: error: redefinition of 'ufs_rpmb_remove'
     229 | void ufs_rpmb_remove(struct ufs_hba *hba)
         |      ^~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd-priv.h:428:20: note: previous definition of 'ufs_rpmb_remove' with type 'void(struct ufs_hba *)'
     428 | static inline void ufs_rpmb_remove(struct ufs_hba *hba)
         |                    ^~~~~~~~~~~~~~~


vim +/ufs_rpmb_probe +135 drivers/ufs/core/ufs-rpmb.c

   133	
   134	/* UFS RPMB device registration */
 > 135	int ufs_rpmb_probe(struct ufs_hba *hba)
   136	{
   137		struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
   138		struct rpmb_dev *rdev;
   139		u8 cid[16] = { };
   140		int region;
   141		u8 *sn;
   142		u32 cap;
   143		int ret;
   144	
   145		if (!hba->ufs_rpmb_wlun || hba->dev_info.b_advanced_rpmb_en) {
   146			dev_info(hba->dev, "Skip OP-TEE RPMB registration\n");
   147			return -ENODEV;
   148		}
   149	
   150		/* Get the UNICODE serial number data */
   151		sn = hba->dev_info.serial_number;
   152		if (!sn) {
   153			dev_err(hba->dev, "Serial number not available\n");
   154			return -EINVAL;
   155		}
   156	
   157		INIT_LIST_HEAD(&hba->rpmbs);
   158	
   159		/* Copy serial number into device ID (max 15 chars + NUL). */
   160		strscpy(cid, sn);
   161	
   162		struct rpmb_descr descr = {
   163			.type = RPMB_TYPE_UFS,
   164			.route_frames = ufs_rpmb_route_frames,
   165			.dev_id_len = sizeof(cid),
   166			.reliable_wr_count = hba->dev_info.rpmb_io_size,
   167		};
   168	
   169		for (region = 0; region < ARRAY_SIZE(hba->dev_info.rpmb_region_size); region++) {
   170			cap = hba->dev_info.rpmb_region_size[region];
   171			if (!cap)
   172				continue;
   173	
   174			ufs_rpmb = devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);
   175			if (!ufs_rpmb) {
   176				ret = -ENOMEM;
   177				goto err_out;
   178			}
   179	
   180			ufs_rpmb->hba = hba;
   181			ufs_rpmb->dev.parent = &hba->ufs_rpmb_wlun->sdev_gendev;
   182			ufs_rpmb->dev.bus = &ufs_rpmb_bus_type;
   183			ufs_rpmb->dev.release = ufs_rpmb_device_release;
   184			dev_set_name(&ufs_rpmb->dev, "ufs_rpmb%d", region);
   185	
   186			/* Set driver data BEFORE device_register */
   187			dev_set_drvdata(&ufs_rpmb->dev, ufs_rpmb);
   188	
   189			ret = device_register(&ufs_rpmb->dev);
   190			if (ret) {
   191				dev_err(hba->dev, "Failed to register UFS RPMB device %d\n", region);
   192				put_device(&ufs_rpmb->dev);
   193				goto err_out;
   194			}
   195	
   196			/* Make CID unique for this region by appending region numbe */
   197			cid[sizeof(cid) - 1] = region;
   198			descr.dev_id = cid;
   199			descr.capacity = cap;
   200	
   201			/* Register RPMB device */
   202			rdev = rpmb_dev_register(&ufs_rpmb->dev, &descr);
   203			if (IS_ERR(rdev)) {
   204				dev_err(hba->dev, "Failed to register UFS RPMB device.\n");
   205				device_unregister(&ufs_rpmb->dev);
   206				ret = PTR_ERR(rdev);
   207				goto err_out;
   208			}
   209	
   210			ufs_rpmb->rdev = rdev;
   211			ufs_rpmb->region_id = region;
   212	
   213			list_add_tail(&ufs_rpmb->node, &hba->rpmbs);
   214	
   215			dev_info(hba->dev, "UFS RPMB region %d registered (capacity=%u)\n", region, cap);
   216		}
   217	
   218		return 0;
   219	err_out:
   220		list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
   221			list_del(&it->node);
   222			device_unregister(&it->dev);
   223		}
   224	
   225		return ret;
   226	}
   227	
   228	/* UFS RPMB remove handler */
 > 229	void ufs_rpmb_remove(struct ufs_hba *hba)
   230	{
   231		struct ufs_rpmb_dev *ufs_rpmb, *tmp;
   232	
   233		if (list_empty(&hba->rpmbs))
   234			return;
   235	
   236		/* Remove all registered RPMB devices */
   237		list_for_each_entry_safe(ufs_rpmb, tmp, &hba->rpmbs, node) {
   238			dev_info(hba->dev, "Removing UFS RPMB region %d\n", ufs_rpmb->region_id);
   239			/* Remove from list first */
   240			list_del(&ufs_rpmb->node);
   241			/* Unregister device */
   242			device_unregister(&ufs_rpmb->dev);
   243		}
   244	
   245		dev_info(hba->dev, "All UFS RPMB devices unregistered\n");
   246	}
   247	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
