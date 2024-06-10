Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE29D54FAD;
	Mon, 10 Jun 2024 23:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718061525; cv=none; b=XLjIho1/Y4tQFhGKpGR0axiwKlCdfPi8u08/9UIQLNzmk8pF1hlZvw1zU5NeO0eFOjmDa7h7/cXkPNHdGhMLZoZEmi/uFzk0zN3hOIHgmNLHDxm6iYj81BnHiTziNByhpGtWm4mhPDhuI4/AEhss+86w5b6dcM84/xolV3sMNdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718061525; c=relaxed/simple;
	bh=KIyL2/Hl4FaIl2MR/Gi9klRT1Z9ieuVHLhL4igv4HKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5ZMa+qYXsHxw+wjUda0lHfMIPqLEF/aSvseaQQxIDFjrQtshL3l42kuJGeIAufPAi1fc4k8rWsvtj32Zxqb4NK6Sj4BF42VAEAwzZDqkGOra3hRIypO55fRYnKhRaPK6JHCcjzKMkgU+PAp6/ZLbufk7thE+BSCg86EZh9ec1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e7m+kI7V; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e7m+kI7V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718061522; x=1749597522;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KIyL2/Hl4FaIl2MR/Gi9klRT1Z9ieuVHLhL4igv4HKw=;
  b=e7m+kI7VAbj1qz69uuH11lW+LphIRjgygNpKzMBi/2ugUjLSSJADuJG/
   p/cBpz5rDukLsf8sCJU/Ubn4WqtFgyujNjJBMw5Qkf995SUOYFdYXT7yF
   8C5HW61TS/9gRJAIUcUEo835I/wYFM25sXj2bYJilQijqzWx+xMHSDKVn
   iylV0JDxZdjjDPUGB3GLCPIIN5wpGbXYjBKtCDyKf/m1CEzk++rhUqOQm
   AOkVOCQwTRtuxlUhK2L2gRxzK1kksrm4ijZUuiddq21QcMr8k/BORK84Z
   Yc1vcoSQR23ZwIgxfYt7vV8kDkcyniTjkj9AIpCSnKTkRnbmvwy6q+fXO
   w==;
X-CSE-ConnectionGUID: LfkXujOERxGJFOfRwhNM4w==
X-CSE-MsgGUID: qLNlt7UdRZuQVbg4VMzngw==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="12008205"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="12008205"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 16:18:42 -0700
X-CSE-ConnectionGUID: 26nkzdepRRavkqvQZ6bjbg==
X-CSE-MsgGUID: 0M+KnpDiQsGcNL9mbEd6OA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="76672525"
Received: from lkp-server01.sh.intel.com (HELO 8967fbab76b3) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 10 Jun 2024 16:18:39 -0700
Received: from kbuild by 8967fbab76b3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sGoHc-0002Zd-3A;
	Mon, 10 Jun 2024 23:18:36 +0000
Date: Tue, 11 Jun 2024 07:18:15 +0800
From: kernel test robot <lkp@intel.com>
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: oe-kbuild-all@lists.linux.dev, arulponn@cisco.com, djhawar@cisco.com,
	gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: Re: [PATCH 06/14] scsi: fnic: Add and integrate support for FDMI
Message-ID: <202406110734.p2v8dq9v-lkp@intel.com>
References: <20240610215100.673158-7-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610215100.673158-7-kartilak@cisco.com>

Hi Karan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.10-rc3 next-20240607]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Karan-Tilak-Kumar/scsi-fnic-Replace-shost_printk-with-pr_info-pr_err/20240611-060227
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240610215100.673158-7-kartilak%40cisco.com
patch subject: [PATCH 06/14] scsi: fnic: Add and integrate support for FDMI
reproduce: (https://download.01.org/0day-ci/archive/20240611/202406110734.p2v8dq9v-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406110734.p2v8dq9v-lkp@intel.com/

versioncheck warnings: (new ones prefixed by >>)
   INFO PATH=/opt/cross/rustc-1.78.0-bindgen-0.65.1/cargo/bin:/opt/cross/clang-18/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
   /usr/bin/timeout -k 100 3h /usr/bin/make KCFLAGS= -Wtautological-compare -Wno-error=return-type -Wreturn-type -Wcast-function-type -funsigned-char -Wundef -fstrict-flex-arrays=3 -Wformat-overflow -Wformat-truncation -Wenum-conversion W=1 --keep-going LLVM=1 -j32 ARCH=x86_64 versioncheck
   find ./* \( -name SCCS -o -name BitKeeper -o -name .svn -o -name CVS -o -name .pc -o -name .hg -o -name .git \) -prune -o \
   	-name '*.[hcS]' -type f -print | sort \
   	| xargs perl -w ./scripts/checkversion.pl
   ./drivers/accessibility/speakup/genmap.c: 13 linux/version.h not needed.
   ./drivers/accessibility/speakup/makemapdata.c: 13 linux/version.h not needed.
>> ./drivers/scsi/fnic/fnic_pci_subsys_devid.c: 11 linux/version.h not needed.
   ./drivers/staging/media/atomisp/include/linux/atomisp.h: 23 linux/version.h not needed.
   ./samples/bpf/spintest.bpf.c: 8 linux/version.h not needed.
   ./samples/trace_events/trace_custom_sched.c: 11 linux/version.h not needed.
   ./sound/soc/codecs/cs42l42.c: 14 linux/version.h not needed.
   ./tools/lib/bpf/bpf_helpers.h: 423: need linux/version.h
   ./tools/testing/selftests/bpf/progs/dev_cgroup.c: 9 linux/version.h not needed.
   ./tools/testing/selftests/bpf/progs/netcnt_prog.c: 3 linux/version.h not needed.
   ./tools/testing/selftests/bpf/progs/test_map_lock.c: 4 linux/version.h not needed.
   ./tools/testing/selftests/bpf/progs/test_send_signal_kern.c: 4 linux/version.h not needed.
   ./tools/testing/selftests/bpf/progs/test_spin_lock.c: 4 linux/version.h not needed.
   ./tools/testing/selftests/bpf/progs/test_tcp_estats.c: 37 linux/version.h not needed.
   ./tools/testing/selftests/wireguard/qemu/init.c: 27 linux/version.h not needed.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
