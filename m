Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863F62D4B66;
	Mon, 27 Oct 2025 03:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761535722; cv=none; b=HHDVD8Ldi/3DWLzKVF6ZEaVxB6mbm7uvi3TZ6hxdSD5+yhXms1kpjZbECYKdXZjdpcLqQDppi+pzvwTHWzznrYniGqpCybzEkOBgBO7aPWIg7VccOQ0xq1FsCnY3ORJdvxY0fA2mTNUQ63MoRE04DgBI9q509icu5r2b9kffdnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761535722; c=relaxed/simple;
	bh=wtr4gepnuJldZ/3JOAsCDSPjx742id8Kyk8x7uv+BzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BP3ZUDAM8Flfbyv+Csmpy8GuX7Ixpllihz+ryJT2xv7EHJVgZANe7NLX+np6WVRV7yIvjk6mh1YNf3eOkg8eh8II4s9RNSQ4dxUJQ8UDst49FiGpc/167CTNytDltM+Ym4P20ArnDDzk06ErfBvGallyYJ+eYqk1NpjeOaJQjyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bxBQe8pr; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bxBQe8pr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761535720; x=1793071720;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wtr4gepnuJldZ/3JOAsCDSPjx742id8Kyk8x7uv+BzU=;
  b=bxBQe8pr3c9w6CnUu1xLs68q7NCXfiwpm0aFUf5sEAxS17TWSN/oM8a8
   c4/Q+Fgjmizguuqb4HRehXVi+u/m0YmZlKHWurRQj5/MplnWp6uHn+vIU
   MvrckQYMUIXPK5m+E9HymJjzkYsyw4dbsNxTyc4CWcKKgcMIaO3h5zZNq
   Qfkq7Kj+ceMOeiwW3sig0I4l8D9UWMweguQzSlTbQ6WT0KXGLy0E0rPCL
   RwV4Tg0RPSQcnFML510w2Os2IKUQgFeoSS2cr5+r+Xt5WnoKfGRD32tDR
   uUNpTh3fazLazEnQ0E7xge342td/7VkR1OKaUzAlhStwoR6m6iLTcdcve
   g==;
X-CSE-ConnectionGUID: FuD1wwiSRceT9uL+cQ0TBg==
X-CSE-MsgGUID: /eyj7J5xR8iPjrAaUZ+9AA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="51187824"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="51187824"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2025 20:28:39 -0700
X-CSE-ConnectionGUID: +ntuL4LQSiyTHFBcTyHXiQ==
X-CSE-MsgGUID: MXLeokXjR1646sfcu3u/Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184825500"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 26 Oct 2025 20:28:35 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vDDuL-000GUn-08;
	Mon, 27 Oct 2025 03:28:33 +0000
Date: Mon, 27 Oct 2025 11:27:50 +0800
From: kernel test robot <lkp@intel.com>
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com,
	avri.altman@sandisk.com, bvanassche@acm.org,
	alim.akhtar@samsung.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, can.guo@oss.qualcomm.com,
	ulf.hansson@linaro.org, beanhuo@micron.com,
	jens.wiklander@linaro.org
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
Message-ID: <202510271043.ptLcyAfD-lkp@intel.com>
References: <20251026212506.4136610-4-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251026212506.4136610-4-beanhuo@iokpp.de>

Hi Bean,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on char-misc/char-misc-testing char-misc/char-misc-next char-misc/char-misc-linus linus/master v6.18-rc3]
[cannot apply to mkp-scsi/for-next next-20251024]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bean-Huo/scsi-ufs-core-Convert-string-descriptor-format-macros-to-enum/20251027-053339
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251026212506.4136610-4-beanhuo%40iokpp.de
patch subject: [PATCH v6 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices
config: x86_64-buildonly-randconfig-001-20251027 (https://download.01.org/0day-ci/archive/20251027/202510271043.ptLcyAfD-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251027/202510271043.ptLcyAfD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510271043.ptLcyAfD-lkp@intel.com/

All errors (new ones prefixed by >>):

                    from include/asm-generic/qrwlock_types.h:6,
                    from arch/x86/include/asm/spinlock_types.h:7,
                    from include/linux/spinlock_types_raw.h:7,
                    from include/linux/ratelimit_types.h:7,
                    from include/linux/printk.h:9,
                    from include/asm-generic/bug.h:22,
                    from arch/x86/include/asm/bug.h:108,
                    from arch/x86/include/asm/alternative.h:9,
                    from arch/x86/include/asm/barrier.h:5,
                    from include/linux/list.h:11,
                    from include/linux/module.h:12,
                    from drivers/ufs/core/ufs-rpmb.c:13:
   drivers/ufs/core/ufs-rpmb.c: In function 'ufs_rpmb_route_frames':
   drivers/ufs/core/ufs-rpmb.c:72:39: error: invalid use of undefined type 'struct rpmb_frame'
      72 |         req_type = be16_to_cpu(frm_out->req_resp);
         |                                       ^~
   include/uapi/linux/swab.h:102:54: note: in definition of macro '__swab16'
     102 | #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
         |                                                      ^
   include/linux/byteorder/generic.h:97:21: note: in expansion of macro '__be16_to_cpu'
      97 | #define be16_to_cpu __be16_to_cpu
         |                     ^~~~~~~~~~~~~
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
   In file included from include/linux/string.h:382,
                    from include/linux/bitmap.h:13,
                    from include/linux/cpumask.h:12,
                    from arch/x86/include/asm/cpumask.h:5,
                    from arch/x86/include/asm/msr.h:11,
                    from arch/x86/include/asm/tsc.h:11,
                    from arch/x86/include/asm/timex.h:6,
                    from include/linux/timex.h:67,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13:
   drivers/ufs/core/ufs-rpmb.c:109:43: error: invalid application of 'sizeof' to incomplete type 'struct rpmb_frame'
     109 |                 memset(frm_resp, 0, sizeof(*frm_resp));
         |                                           ^
   include/linux/fortify-string.h:502:42: note: in definition of macro '__fortify_memset_chk'
     502 |         size_t __fortify_size = (size_t)(size);                         \
         |                                          ^~~~
   drivers/ufs/core/ufs-rpmb.c:109:17: note: in expansion of macro 'memset'
     109 |                 memset(frm_resp, 0, sizeof(*frm_resp));
         |                 ^~~~~~
   drivers/ufs/core/ufs-rpmb.c:110:25: error: invalid use of undefined type 'struct rpmb_frame'
     110 |                 frm_resp->req_resp = cpu_to_be16(RPMB_RESULT_READ);
         |                         ^~
   drivers/ufs/core/ufs-rpmb.c:110:50: error: 'RPMB_RESULT_READ' undeclared (first use in this function)
     110 |                 frm_resp->req_resp = cpu_to_be16(RPMB_RESULT_READ);
         |                                                  ^~~~~~~~~~~~~~~~
   include/uapi/linux/swab.h:102:54: note: in definition of macro '__swab16'
     102 | #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
         |                                                      ^
   include/linux/byteorder/generic.h:96:21: note: in expansion of macro '__cpu_to_be16'
      96 | #define cpu_to_be16 __cpu_to_be16
         |                     ^~~~~~~~~~~~~
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
>> drivers/ufs/core/ufs-rpmb.c:234:6: error: redefinition of 'ufs_rpmb_remove'
     234 | void ufs_rpmb_remove(struct ufs_hba *hba)
         |      ^~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd-priv.h:428:20: note: previous definition of 'ufs_rpmb_remove' with type 'void(struct ufs_hba *)'
     428 | static inline void ufs_rpmb_remove(struct ufs_hba *hba)
         |                    ^~~~~~~~~~~~~~~

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for OF_GPIO
   Depends on [n]: GPIOLIB [=y] && OF [=n] && HAS_IOMEM [=y]
   Selected by [y]:
   - GPIO_TB10X [=y] && GPIOLIB [=y] && HAS_IOMEM [=y] && (ARC_PLAT_TB10X || COMPILE_TEST [=y])
   WARNING: unmet direct dependencies detected for GPIO_SYSCON
   Depends on [n]: GPIOLIB [=y] && HAS_IOMEM [=y] && MFD_SYSCON [=y] && OF [=n]
   Selected by [y]:
   - GPIO_SAMA5D2_PIOBU [=y] && GPIOLIB [=y] && HAS_IOMEM [=y] && MFD_SYSCON [=y] && OF_GPIO [=y] && (ARCH_AT91 || COMPILE_TEST [=y])
   WARNING: unmet direct dependencies detected for I2C_K1
   Depends on [n]: I2C [=y] && HAS_IOMEM [=y] && (ARCH_SPACEMIT || COMPILE_TEST [=y]) && OF [=n]
   Selected by [m]:
   - MFD_SPACEMIT_P1 [=m] && HAS_IOMEM [=y] && (ARCH_SPACEMIT || COMPILE_TEST [=y]) && I2C [=y]


vim +/ufs_rpmb_probe +135 drivers/ufs/core/ufs-rpmb.c

   133	
   134	/* UFS RPMB device registration */
 > 135	int ufs_rpmb_probe(struct ufs_hba *hba)
   136	{
   137		struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
   138		struct rpmb_dev *rdev;
   139		char *cid = NULL;
   140		int region;
   141		u32 cap;
   142		int ret;
   143	
   144		if (!hba->ufs_rpmb_wlun || hba->dev_info.b_advanced_rpmb_en) {
   145			dev_info(hba->dev, "Skip OP-TEE RPMB registration\n");
   146			return -ENODEV;
   147		}
   148	
   149		/* Check if device_id is available */
   150		if (!hba->dev_info.device_id) {
   151			dev_err(hba->dev, "UFS Device ID not available\n");
   152			return -EINVAL;
   153		}
   154	
   155		INIT_LIST_HEAD(&hba->rpmbs);
   156	
   157		struct rpmb_descr descr = {
   158			.type = RPMB_TYPE_UFS,
   159			.route_frames = ufs_rpmb_route_frames,
   160			.reliable_wr_count = hba->dev_info.rpmb_io_size,
   161		};
   162	
   163		for (region = 0; region < ARRAY_SIZE(hba->dev_info.rpmb_region_size); region++) {
   164			cap = hba->dev_info.rpmb_region_size[region];
   165			if (!cap)
   166				continue;
   167	
   168			ufs_rpmb = devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);
   169			if (!ufs_rpmb) {
   170				ret = -ENOMEM;
   171				goto err_out;
   172			}
   173	
   174			ufs_rpmb->hba = hba;
   175			ufs_rpmb->dev.parent = &hba->ufs_rpmb_wlun->sdev_gendev;
   176			ufs_rpmb->dev.bus = &ufs_rpmb_bus_type;
   177			ufs_rpmb->dev.release = ufs_rpmb_device_release;
   178			dev_set_name(&ufs_rpmb->dev, "ufs_rpmb%d", region);
   179	
   180			/* Set driver data BEFORE device_register */
   181			dev_set_drvdata(&ufs_rpmb->dev, ufs_rpmb);
   182	
   183			ret = device_register(&ufs_rpmb->dev);
   184			if (ret) {
   185				dev_err(hba->dev, "Failed to register UFS RPMB device %d\n", region);
   186				put_device(&ufs_rpmb->dev);
   187				goto err_out;
   188			}
   189	
   190			/* Create unique ID by appending region number to device_id */
   191			cid = kasprintf(GFP_KERNEL, "%s-R%d", hba->dev_info.device_id, region);
   192			if (!cid) {
   193				device_unregister(&ufs_rpmb->dev);
   194				ret = -ENOMEM;
   195				goto err_out;
   196			}
   197	
   198			descr.dev_id = cid;
   199			descr.dev_id_len = strlen(cid);
   200			descr.capacity = cap;
   201	
   202			/* Register RPMB device */
   203			rdev = rpmb_dev_register(&ufs_rpmb->dev, &descr);
   204			if (IS_ERR(rdev)) {
   205				dev_err(hba->dev, "Failed to register UFS RPMB device.\n");
   206				device_unregister(&ufs_rpmb->dev);
   207				ret = PTR_ERR(rdev);
   208				goto err_out;
   209			}
   210	
   211			kfree(cid);
   212			cid = NULL;
   213	
   214			ufs_rpmb->rdev = rdev;
   215			ufs_rpmb->region_id = region;
   216	
   217			list_add_tail(&ufs_rpmb->node, &hba->rpmbs);
   218	
   219			dev_info(hba->dev, "UFS RPMB region %d registered (capacity=%u)\n", region, cap);
   220		}
   221	
   222		return 0;
   223	err_out:
   224		kfree(cid);
   225		list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
   226			list_del(&it->node);
   227			device_unregister(&it->dev);
   228		}
   229	
   230		return ret;
   231	}
   232	
   233	/* UFS RPMB remove handler */
 > 234	void ufs_rpmb_remove(struct ufs_hba *hba)
   235	{
   236		struct ufs_rpmb_dev *ufs_rpmb, *tmp;
   237	
   238		if (list_empty(&hba->rpmbs))
   239			return;
   240	
   241		/* Remove all registered RPMB devices */
   242		list_for_each_entry_safe(ufs_rpmb, tmp, &hba->rpmbs, node) {
   243			dev_info(hba->dev, "Removing UFS RPMB region %d\n", ufs_rpmb->region_id);
   244			/* Remove from list first */
   245			list_del(&ufs_rpmb->node);
   246			/* Unregister device */
   247			device_unregister(&ufs_rpmb->dev);
   248		}
   249	
   250		dev_info(hba->dev, "All UFS RPMB devices unregistered\n");
   251	}
   252	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
