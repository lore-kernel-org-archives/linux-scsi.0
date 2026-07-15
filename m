Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB15A2F7F14;
	Wed, 15 Jul 2026 04:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784089333; cv=none; b=TNToZjOq6GBCwV6yfsowzU5vVEb6r3GQXGaUnNrT6nTucHp7YQW+gIiya4+aEuU6cDGO0vkXxvV78RKcA9dOtcrZJfNnRMsrEAG7HG15TJMS47MJ+RUdEmxjuXacgIp7QKB3LxSfN7YoTNkQKNqtBU8uY4KvNwUOei3zfSeQVrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784089333; c=relaxed/simple;
	bh=yOkM685yJQdbKVpHEhMOVPwInqzc8Xw3E5+TywZRXT0=;
	h=Date:From:To:Cc:Subject:Message-ID; b=mBFy6gdBoZQZsR1qfHEUxu4RNDcahHojphSNHhywrnhaaQUmYqTq/HDDgKRCHO9E7pGe0XCkcZx7V1R+JBk1OW4+mtQcR4S2jFOImrg+j7bNw30fQ/q8VJVaYtZXHdEMPYhusPzStGYa8n/4zQaIDTlnL5e89B/7Z56Qhk6wXWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XpZyJwo2; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XpZyJwo2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784089331; x=1815625331;
  h=date:from:to:cc:subject:message-id;
  bh=yOkM685yJQdbKVpHEhMOVPwInqzc8Xw3E5+TywZRXT0=;
  b=XpZyJwo2PgFLGHYp0os1a5LzOtRAeSTRIqdne1QRp+lw+0ugGyfjal7J
   BmkqbPDNGTqOn7K+Qrl+swtYw7C95kJIBGOVIcn9d4P7wTF4Ub9XAJQJr
   e0BcmGv0SA7IWJDrPFchz5aKEo0Qfk7OBn8CHi+Lm+Egb+v1R6Cr8nPmO
   RMIZjXvavQolBSK41v6/+KZ1jlRNo4TAIC3yNjctKGc4gMhhz6kJsnrX5
   vIEGPDNqZLO3Sys686x35k1xvHp0XqPcFhjOh2OFFU7cfKu3CRbO84Akg
   PcGfxA0xBoCEWsYtKhteiFCv0kRcWmHLbUnsYSTBL4ZDnvxgZZXWwUZpI
   w==;
X-CSE-ConnectionGUID: FP+XxV4CS+mINEwrI+UmOw==
X-CSE-MsgGUID: cDBseSqFT763fLD4Veq72A==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="84571732"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="84571732"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 21:22:10 -0700
X-CSE-ConnectionGUID: hvNO03mgQV+d0iWYqg69PQ==
X-CSE-MsgGUID: uN6TXpdmQpuBO0IRmGbeag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="252662372"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 14 Jul 2026 21:22:08 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wjr8H-00000000NHb-2tuv;
	Wed, 15 Jul 2026 04:22:05 +0000
Date: Wed, 15 Jul 2026 12:21:36 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 linux-media@vger.kernel.org, linux-scsi@vger.kernel.org,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 cc2b5f627e8ccbae1188ef2d8be3e451d7f933a5
Message-ID: <202607151249.N5niNXKX-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: cc2b5f627e8ccbae1188ef2d8be3e451d7f933a5  Add linux-next specific files for 20260714

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202607150709.CagVDeyK-lkp@intel.com

    drivers/scsi/gvp11.c:444:51: warning: missing braces around initializer [-Wmissing-braces]
    qcom_scm.c:(.text+0x41cc): undefined reference to `of_address_to_resource'

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607150800.r5xDoCDS-lkp@intel.com

    ERROR: modpost: "power_supply_reg_notifier" [drivers/usb/dwc3/dwc3.ko] undefined!
    ERROR: modpost: "power_supply_unreg_notifier" [drivers/usb/dwc3/dwc3.ko] undefined!
    arm-linux-gnueabi-ld: core.c:(.text+0x23c0): undefined reference to `power_supply_unreg_notifier'
    core.c:(.text+0x1c60): undefined reference to `power_supply_unreg_notifier'
    core.c:(.text+0x220c): undefined reference to `power_supply_reg_notifier'
    drivers/media/i2c/imx678.c:1152 imx678_init_controls() error: buffer overflow 'min_hmax_4lane' 8 <= 64
    drivers/media/i2c/imx678.c:905 imx678_write_common() error: buffer overflow 'link_freqs_reg_value' 8 <= 64
    ld.lld: error: undefined symbol: power_supply_reg_notifier
    ld.lld: error: undefined symbol: power_supply_unreg_notifier

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-004-20260715
|   |-- arm-linux-gnueabi-ld:core.c:(.text):undefined-reference-to-power_supply_unreg_notifier
|   |-- core.c:(.text):undefined-reference-to-power_supply_reg_notifier
|   `-- core.c:(.text):undefined-reference-to-power_supply_unreg_notifier
|-- hexagon-randconfig-002-20260714
|   |-- ld.lld:error:undefined-symbol:power_supply_reg_notifier
|   `-- ld.lld:error:undefined-symbol:power_supply_unreg_notifier
|-- loongarch-randconfig-r073-20260714
|   |-- drivers-media-i2c-imx678.c-imx678_init_controls()-error:buffer-overflow-min_hmax_4lane
|   `-- drivers-media-i2c-imx678.c-imx678_write_common()-error:buffer-overflow-link_freqs_reg_value
|-- m68k-allmodconfig
|   `-- drivers-scsi-gvp11.c:warning:missing-braces-around-initializer
|-- m68k-defconfig
|   `-- drivers-scsi-gvp11.c:warning:missing-braces-around-initializer
|-- mips-randconfig-r072-20260715
|   |-- ERROR:power_supply_reg_notifier-drivers-usb-dwc3-dwc3.ko-undefined
|   `-- ERROR:power_supply_unreg_notifier-drivers-usb-dwc3-dwc3.ko-undefined
`-- s390-randconfig-r062-20260714
    `-- qcom_scm.c:(.text):undefined-reference-to-of_address_to_resource

elapsed time: 764m

configs tested: 262
configs skipped: 7

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260715    gcc-10.5.0
arc                   randconfig-002-20260715    gcc-10.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-003-20260715    gcc-10.5.0
arm                   randconfig-004-20260715    gcc-10.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260715    gcc-16.1.0
arm64                 randconfig-001-20260715    gcc-9.5.0
arm64                 randconfig-002-20260715    gcc-15.2.0
arm64                 randconfig-002-20260715    gcc-16.1.0
arm64                 randconfig-003-20260715    clang-23
arm64                 randconfig-003-20260715    gcc-16.1.0
arm64                 randconfig-004-20260715    gcc-11.5.0
arm64                 randconfig-004-20260715    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260715    gcc-16.1.0
csky                  randconfig-002-20260715    gcc-13.4.0
csky                  randconfig-002-20260715    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260714    clang-20
hexagon               randconfig-002-20260714    clang-23
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260715    clang-22
i386        buildonly-randconfig-002-20260715    clang-22
i386        buildonly-randconfig-002-20260715    gcc-14
i386        buildonly-randconfig-003-20260715    clang-22
i386        buildonly-randconfig-003-20260715    gcc-14
i386        buildonly-randconfig-004-20260715    clang-22
i386        buildonly-randconfig-004-20260715    gcc-14
i386        buildonly-randconfig-005-20260715    clang-22
i386        buildonly-randconfig-006-20260715    clang-22
i386        buildonly-randconfig-006-20260715    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260715    clang-22
i386                  randconfig-001-20260715    gcc-14
i386                  randconfig-002-20260715    clang-22
i386                  randconfig-003-20260715    clang-22
i386                  randconfig-003-20260715    gcc-12
i386                  randconfig-004-20260715    clang-22
i386                  randconfig-004-20260715    gcc-14
i386                  randconfig-005-20260715    clang-22
i386                  randconfig-006-20260715    clang-22
i386                  randconfig-006-20260715    gcc-14
i386                  randconfig-007-20260715    clang-22
i386                  randconfig-007-20260715    gcc-14
i386                  randconfig-011-20260715    clang-22
i386                  randconfig-011-20260715    gcc-14
i386                  randconfig-012-20260715    gcc-14
i386                  randconfig-013-20260715    gcc-14
i386                  randconfig-014-20260715    clang-22
i386                  randconfig-014-20260715    gcc-14
i386                  randconfig-015-20260715    clang-22
i386                  randconfig-015-20260715    gcc-14
i386                  randconfig-016-20260715    clang-22
i386                  randconfig-016-20260715    gcc-14
i386                  randconfig-017-20260715    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260714    gcc-16.1.0
loongarch             randconfig-001-20260715    gcc-16.1.0
loongarch             randconfig-002-20260714    gcc-14.3.0
loongarch             randconfig-002-20260715    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
m68k                            mac_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                        bcm63xx_defconfig    clang-23
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260714    gcc-11.5.0
nios2                 randconfig-001-20260715    gcc-16.1.0
nios2                 randconfig-002-20260714    gcc-11.5.0
nios2                 randconfig-002-20260715    gcc-16.1.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260714    gcc-13.4.0
parisc                randconfig-001-20260715    clang-23
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260714    gcc-11.5.0
parisc                randconfig-002-20260715    clang-23
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260714    clang-17
powerpc               randconfig-001-20260715    clang-23
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260714    clang-17
powerpc               randconfig-002-20260715    clang-23
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260714    clang-17
powerpc64             randconfig-001-20260715    clang-23
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260714    clang-23
powerpc64             randconfig-002-20260715    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260715    clang-17
riscv                 randconfig-001-20260715    gcc-15.2.0
riscv                 randconfig-002-20260715    gcc-15.2.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260715    gcc-12.5.0
s390                  randconfig-001-20260715    gcc-15.2.0
s390                  randconfig-002-20260715    clang-23
s390                  randconfig-002-20260715    gcc-15.2.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260715    gcc-15.2.0
sh                    randconfig-001-20260715    gcc-16.1.0
sh                    randconfig-002-20260715    gcc-15.2.0
sh                    randconfig-002-20260715    gcc-9.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260715    gcc-16.1.0
sparc                 randconfig-002-20260715    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260715    clang-23
sparc64               randconfig-001-20260715    gcc-16.1.0
sparc64               randconfig-002-20260715    clang-20
sparc64               randconfig-002-20260715    gcc-16.1.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260715    clang-23
um                    randconfig-001-20260715    gcc-16.1.0
um                    randconfig-002-20260715    gcc-14
um                    randconfig-002-20260715    gcc-16.1.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260715    clang-22
x86_64      buildonly-randconfig-001-20260715    gcc-14
x86_64      buildonly-randconfig-002-20260715    gcc-14
x86_64      buildonly-randconfig-003-20260715    gcc-14
x86_64      buildonly-randconfig-004-20260715    gcc-14
x86_64      buildonly-randconfig-005-20260715    clang-22
x86_64      buildonly-randconfig-005-20260715    gcc-14
x86_64      buildonly-randconfig-006-20260715    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260715    clang-22
x86_64                randconfig-002-20260715    clang-22
x86_64                randconfig-003-20260715    clang-22
x86_64                randconfig-004-20260715    clang-22
x86_64                randconfig-004-20260715    gcc-14
x86_64                randconfig-005-20260715    clang-22
x86_64                randconfig-006-20260715    clang-22
x86_64                randconfig-006-20260715    gcc-14
x86_64                randconfig-011-20260715    clang-22
x86_64                randconfig-012-20260715    clang-22
x86_64                randconfig-012-20260715    gcc-14
x86_64                randconfig-013-20260715    clang-22
x86_64                randconfig-014-20260715    clang-22
x86_64                randconfig-015-20260715    clang-22
x86_64                randconfig-016-20260715    clang-22
x86_64                randconfig-071-20260715    gcc-14
x86_64                randconfig-072-20260715    gcc-14
x86_64                randconfig-073-20260715    gcc-14
x86_64                randconfig-074-20260715    gcc-14
x86_64                randconfig-075-20260715    gcc-14
x86_64                randconfig-076-20260715    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-001-20260715    gcc-14.3.0
xtensa                randconfig-001-20260715    gcc-16.1.0
xtensa                randconfig-002-20260715    gcc-12.5.0
xtensa                randconfig-002-20260715    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
