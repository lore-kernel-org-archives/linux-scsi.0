Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DF730B51A;
	Wed, 26 Nov 2025 18:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764180438; cv=none; b=luJtC5/hJPGIaqCyQPmBfZ8wNJtr4Qh4vFvZqVPcSjIXDRw5aytW102mx56mH972WctGJQWRX7vox8udiSIjQbYyfbCj0YEF9iz7+juYphh/96PzstXChCkWf7yLtCKPcr7CO7PkG83cjKdyu3qWWfUCnsWnxg4g9QzzPL4aTL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764180438; c=relaxed/simple;
	bh=ZxPVD2OX+mWyP8KER+7TTW6fM/MAUm90+J80CBazzDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u2SGUBTA1XE0adApFPeGcdXgguylhF5AxGm+C81AsYj74koMftHPGPcXH5x0SL9pPf8sz8dOgiUHOnWvTzIsxn5siJXoEVZTK4PelApAPmwrhr1S4FXHeubh7A91sXKD0h8ScW6dWTMi2jGAMbAFnSEqvosfGliDvqoxFx6UEGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vhf2rmyr; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vhf2rmyr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764180437; x=1795716437;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZxPVD2OX+mWyP8KER+7TTW6fM/MAUm90+J80CBazzDI=;
  b=Vhf2rmyrw0q9mxSzAZyQEIfuFAIJ7eUjXrf5hK7p7d3EB0Mm96DI/X9+
   vJXYltRIkGZuaqArSYGDyfMsQHkryuEnj/v6yuqn4WU8cFwSiB/f4GdGQ
   UkZKprLancr8RiH1YknZgWOoXjgtNy4nZKPCkEMULsGg3OcxYw3RvBZh9
   QSeM0FNxpl9XnKwVK693HcwP/2tZ4thOnqUroqEyZc0upRuOIxBUvCTxB
   LEFv8QHnNUmqLLzOe7WsZTW798Rn0gbwiQcoFCmpscWmiK9YNCI1i6jPk
   Z1xYZysDqzfOCyhLrpCHBT3HSVjEJdL+G/pYkoO0oTbuIwLjE4DyAbY9x
   A==;
X-CSE-ConnectionGUID: vDADToWTSwCG7L8ixFjIlQ==
X-CSE-MsgGUID: mWdWA913QiWU7p1FzedRHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="65412766"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="65412766"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 10:07:16 -0800
X-CSE-ConnectionGUID: k/fLjEWGQQq0kjdeccpQHA==
X-CSE-MsgGUID: 1Ys4OkOBRJ2TYAKR0MgXIg==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 26 Nov 2025 10:07:13 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vOJv5-000000003Dx-1cf2;
	Wed, 26 Nov 2025 18:07:11 +0000
Date: Thu, 27 Nov 2025 02:06:52 +0800
From: kernel test robot <lkp@intel.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, linux-block@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Mike Christie <michael.christie@oracle.com>,
	Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH 3/4] block: add IOC_PR_READ_KEYS ioctl
Message-ID: <202511270125.CJ6M2RHv-lkp@intel.com>
References: <20251126163600.583036-4-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126163600.583036-4-stefanha@redhat.com>

Hi Stefan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on axboe/for-next jejb-scsi/for-next linus/master v6.18-rc7 next-20251126]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Stefan-Hajnoczi/scsi-sd-reject-invalid-pr_read_keys-num_keys-values/20251127-003756
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251126163600.583036-4-stefanha%40redhat.com
patch subject: [PATCH 3/4] block: add IOC_PR_READ_KEYS ioctl
config: loongarch-allnoconfig (https://download.01.org/0day-ci/archive/20251127/202511270125.CJ6M2RHv-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9e9fe08b16ea2c4d9867fb4974edf2a3776d6ece)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251127/202511270125.CJ6M2RHv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511270125.CJ6M2RHv-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> block/ioctl.c:443:21: warning: result of comparison of constant 2305843009213693951 with expression of type '__u32' (aka 'unsigned int') is always false [-Wtautological-constant-out-of-range-compare]
     443 |         if (inout.num_keys > -sizeof(*keys_info) / sizeof(keys_info->keys[0]))
         |             ~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +443 block/ioctl.c

   426	
   427	static int blkdev_pr_read_keys(struct block_device *bdev, blk_mode_t mode,
   428			struct pr_read_keys __user *arg)
   429	{
   430		const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
   431		struct pr_keys *keys_info __free(kfree) = NULL;
   432		struct pr_read_keys inout;
   433		int ret;
   434	
   435		if (!blkdev_pr_allowed(bdev, mode))
   436			return -EPERM;
   437		if (!ops || !ops->pr_read_keys)
   438			return -EOPNOTSUPP;
   439	
   440		if (copy_from_user(&inout, arg, sizeof(inout)))
   441			return -EFAULT;
   442	
 > 443		if (inout.num_keys > -sizeof(*keys_info) / sizeof(keys_info->keys[0]))
   444			return -EINVAL;
   445	
   446		size_t keys_info_len = struct_size(keys_info, keys, inout.num_keys);
   447	
   448		keys_info = kzalloc(keys_info_len, GFP_KERNEL);
   449		if (!keys_info)
   450			return -ENOMEM;
   451	
   452		keys_info->num_keys = inout.num_keys;
   453	
   454		ret = ops->pr_read_keys(bdev, keys_info);
   455		if (ret)
   456			return ret;
   457	
   458		/* Copy out individual keys */
   459		u64 __user *keys_ptr = u64_to_user_ptr(inout.keys_ptr);
   460		u32 num_copy_keys = min(inout.num_keys, keys_info->num_keys);
   461		size_t keys_copy_len = num_copy_keys * sizeof(keys_info->keys[0]);
   462	
   463		if (copy_to_user(keys_ptr, keys_info->keys, keys_copy_len))
   464			return -EFAULT;
   465	
   466		/* Copy out the arg struct */
   467		inout.generation = keys_info->generation;
   468		inout.num_keys = keys_info->num_keys;
   469	
   470		if (copy_to_user(arg, &inout, sizeof(inout)))
   471			return -EFAULT;
   472		return ret;
   473	}
   474	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
