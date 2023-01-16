Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66FFC54EBE
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Jan 2023 17:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbjAPRny (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Jan 2023 12:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbjAPRnQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2023 12:43:16 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C817836B23
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2023 09:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673889720; x=1705425720;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=slWIquIwoxV/LesC+p+rpcqnFbCujILM9piVJ18z7mY=;
  b=gDhxzs8pihND31Z2a/dIQHI+WJJxM6CArsXLvHUkNFuxQN4Ha3awXtsf
   0/Jc+1vffVxWqWZfAVrtS+SuPsz8Gm89x6nq/pBSUP3ecL5V6IT676/2A
   nhnx6pTffOJcT3SZlH4j4hqSKHYx+ouc7fqOQpiF7hsYyVvcTPzr8bj1w
   tE5GyhTp+AHhKXXAN7SBEQCUFZMkymL6FPGe0KVQ/Mh2lriWk9dKfHDXC
   JnErgxIhp2XRa/cggeD+cK6E/e7ri4iwXy8CvMT8sahFuf5im87A0Pl5R
   jxz2iovr5DqoLMAYaLmjjGVbH7HXncYlv3KnJLLpvqgds2t4yZqiRI6N0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="386848700"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="386848700"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 09:22:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="747787714"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="747787714"
Received: from lkp-server02.sh.intel.com (HELO f57cd993bc73) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jan 2023 09:21:58 -0800
Received: from kbuild by f57cd993bc73 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pHTBB-0000b3-2w;
        Mon, 16 Jan 2023 17:21:56 +0000
Date:   Tue, 17 Jan 2023 01:20:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 c12e2e5b76b2e739ccdf196bee960412b45d5f85
Message-ID: <63c58779.uajdC0MYsLwvye/p%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: c12e2e5b76b2e739ccdf196bee960412b45d5f85  Add linux-next specific files for 20230116

Error/Warning: (recently discovered and may have been fixed)

drivers/gpu/drm/ttm/ttm_bo_util.c:364:32: error: implicit declaration of function 'vmap'; did you mean 'kmap'? [-Werror=implicit-function-declaration]
drivers/gpu/drm/ttm/ttm_bo_util.c:429:17: error: implicit declaration of function 'vunmap'; did you mean 'kunmap'? [-Werror=implicit-function-declaration]
drivers/scsi/qla2xxx/qla_mid.c:1094:51: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'unsigned int' [-Wformat=]
drivers/scsi/qla2xxx/qla_mid.c:1189:6: warning: no previous prototype for 'qla_trim_buf' [-Wmissing-prototypes]
drivers/scsi/qla2xxx/qla_mid.c:1221:6: warning: no previous prototype for '__qla_adjust_buf' [-Wmissing-prototypes]

Unverified Error/Warning (likely false positive, please contact us if interested):

FAILED: load BTF from vmlinux: No data available
drivers/firmware/arm_scmi/bus.c:128:18-22: ERROR: reference preceded by free on line 102
drivers/nvmem/imx-ocotp.c:599:21: sparse: sparse: symbol 'imx_ocotp_layout' was not declared. Should it be static?
libbpf: failed to find '.BTF' ELF section in vmlinux

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- arm-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- loongarch-randconfig-r035-20230116
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-ttm-ttm_bo_util.c:error:implicit-declaration-of-function-vmap
|   `-- drivers-gpu-drm-ttm-ttm_bo_util.c:error:implicit-declaration-of-function-vunmap
|-- mips-randconfig-c033-20230115
|   |-- drivers-gpu-drm-ttm-ttm_bo_util.c:error:implicit-declaration-of-function-vmap
|   `-- drivers-gpu-drm-ttm-ttm_bo_util.c:error:implicit-declaration-of-function-vunmap
|-- mips-randconfig-r025-20230115
|   |-- drivers-gpu-drm-ttm-ttm_bo_util.c:error:implicit-declaration-of-function-vmap
|   `-- drivers-gpu-drm-ttm-ttm_bo_util.c:error:implicit-declaration-of-function-vunmap
|-- nios2-randconfig-c031-20230115
|   `-- drivers-firmware-arm_scmi-bus.c:ERROR:reference-preceded-by-free-on-line
|-- openrisc-randconfig-r035-20230115
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|-- parisc-randconfig-s053-20230116
|   |-- FAILED:load-BTF-from-vmlinux:No-data-available
|   `-- libbpf:failed-to-find-.BTF-ELF-section-in-vmlinux
|-- powerpc-randconfig-s033-20230115
|   `-- drivers-nvmem-imx-ocotp.c:sparse:sparse:symbol-imx_ocotp_layout-was-not-declared.-Should-it-be-static
`-- x86_64-randconfig-k001-20230116
    `-- libbpf:failed-to-find-.BTF-ELF-section-in-vmlinux

elapsed time: 722m

configs tested: 69
configs skipped: 3

gcc tested configs:
powerpc                           allnoconfig
um                             i386_defconfig
x86_64                              defconfig
um                           x86_64_defconfig
x86_64                            allnoconfig
x86_64                               rhel-8.3
i386                                defconfig
sh                               allmodconfig
mips                             allyesconfig
x86_64                           allyesconfig
arc                                 defconfig
powerpc                          allmodconfig
arc                  randconfig-r043-20230116
alpha                               defconfig
x86_64                           rhel-8.3-syz
arm                                 defconfig
x86_64                         rhel-8.3-kunit
x86_64               randconfig-a011-20230116
i386                 randconfig-a014-20230116
ia64                             allmodconfig
x86_64                           rhel-8.3-kvm
s390                 randconfig-r044-20230116
i386                 randconfig-a013-20230116
x86_64               randconfig-a013-20230116
i386                 randconfig-a012-20230116
x86_64                           rhel-8.3-bpf
i386                 randconfig-a011-20230116
m68k                             allyesconfig
riscv                randconfig-r042-20230116
i386                 randconfig-a016-20230116
x86_64               randconfig-a012-20230116
i386                 randconfig-a015-20230116
m68k                             allmodconfig
arm64                            allyesconfig
i386                             allyesconfig
x86_64               randconfig-a015-20230116
arc                              allyesconfig
x86_64               randconfig-a014-20230116
alpha                            allyesconfig
x86_64               randconfig-a016-20230116
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
s390                                defconfig
s390                             allmodconfig
s390                             allyesconfig
x86_64               randconfig-k001-20230116
arm                         axm55xx_defconfig
arm                            mps2_defconfig
openrisc                       virt_defconfig
m68k                       m5275evb_defconfig
powerpc                      ppc6xx_defconfig
arm                              allyesconfig
arc                      axs103_smp_defconfig

clang tested configs:
x86_64                          rhel-8.3-rust
arm                  randconfig-r046-20230116
hexagon              randconfig-r045-20230116
hexagon              randconfig-r041-20230116
x86_64               randconfig-a001-20230116
x86_64               randconfig-a006-20230116
x86_64               randconfig-a003-20230116
x86_64               randconfig-a002-20230116
x86_64               randconfig-a004-20230116
x86_64               randconfig-a005-20230116
i386                 randconfig-a006-20230116
powerpc                     kilauea_defconfig
arm                       netwinder_defconfig
arm                       versatile_defconfig
mips                           mtx1_defconfig
arm                           spitz_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
