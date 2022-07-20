Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85DBAC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 04:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiGTEoP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jul 2022 00:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiGTEoO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2022 00:44:14 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E74752DEE
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 21:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658292253; x=1689828253;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/PLZaqmDoCC44cS0HnAK5GL3TmSOOqBZ1O/+trd350M=;
  b=ItA5PuVRyIIVSncfiGYhEZCn+ohnNhVelyIKKQ/jk8UGTP0DKcMkYHFW
   7GIybV1rPLsF2VFh665exrttjMLT6cLW/Pxpz1TJxW1Fzjm894Algflj4
   7Pa+sbw3s8DiDwGwYJIOyhzdAqV5t4pMDNqC2S800e7v8+UNmmnvud0KR
   XwHOqQnm0D/AQd2oGQXhV8dFhKirbOvWIYdBvBmzprxVRrAYSJxyjhYay
   0zhLxqv/L2Wjc7a7Rs/D5BtNnh9DKRFhNJt7uAOUCs0iYGW9Aep4oK9Gl
   Bnf/KJqA6Z8Ld0DDBXNXiW720R95558oHMPwVe+aI660F0JB5K6ARjDGz
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="269704738"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="269704738"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 21:44:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="625501215"
Received: from lkp-server01.sh.intel.com (HELO 7dfbdc7c7900) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 19 Jul 2022 21:44:07 -0700
Received: from kbuild by 7dfbdc7c7900 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oE1Z8-00001V-Kw;
        Wed, 20 Jul 2022 04:44:06 +0000
Date:   Wed, 20 Jul 2022 12:43:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, bhazarika@marvell.com,
        agurumurthy@marvell.com
Subject: Re: [PATCH 2/6] qla2xxx: Add a generic tracing framework
Message-ID: <202207201230.esVUm6qp-lkp@intel.com>
References: <20220715060227.23923-3-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715060227.23923-3-njavali@marvell.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Nilesh,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on f095c3cd1b694a73a5de276dae919f05a8dd1811]

url:    https://github.com/intel-lab-lkp/linux/commits/Nilesh-Javali/qla2xxx-driver-features/20220715-140608
base:   f095c3cd1b694a73a5de276dae919f05a8dd1811
config: mips-allyesconfig (https://download.01.org/0day-ci/archive/20220720/202207201230.esVUm6qp-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d5f3010956e8a08bd2742acc3715478d1b961178
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Nilesh-Javali/qla2xxx-driver-features/20220715-140608
        git checkout d5f3010956e8a08bd2742acc3715478d1b961178
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash drivers/scsi/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

Note: the linux-review/Nilesh-Javali/qla2xxx-driver-features/20220715-140608 HEAD d044ae5809919c7fbaa3ca3c374d1dfd00403990 builds fine.
      It only hurts bisectability.

All error/warnings (new ones prefixed by >>):

   In file included from drivers/scsi/qla2xxx/qla_def.h:5498,
                    from drivers/scsi/qla2xxx/qla_os.c:6:
   drivers/scsi/qla2xxx/qla_dbg.h: In function 'qla_trace_init':
>> drivers/scsi/qla2xxx/qla_dbg.h:438:21: error: implicit declaration of function 'vzalloc'; did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
     438 |         trc->recs = vzalloc(trc->num_entries *
         |                     ^~~~~~~
         |                     kvzalloc
>> drivers/scsi/qla2xxx/qla_dbg.h:438:19: warning: assignment to 'struct qla_trace_rec *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     438 |         trc->recs = vzalloc(trc->num_entries *
         |                   ^
   drivers/scsi/qla2xxx/qla_dbg.h: In function 'qla_trace_uninit':
>> drivers/scsi/qla2xxx/qla_dbg.h:452:9: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
     452 |         vfree(trc->recs);
         |         ^~~~~
         |         kvfree
   In file included from drivers/scsi/qla2xxx/qla_os.c:9:
   include/linux/vmalloc.h: At top level:
>> include/linux/vmalloc.h:143:14: error: conflicting types for 'vzalloc'; have 'void *(long unsigned int)'
     143 | extern void *vzalloc(unsigned long size) __alloc_size(1);
         |              ^~~~~~~
   drivers/scsi/qla2xxx/qla_dbg.h:438:21: note: previous implicit declaration of 'vzalloc' with type 'int()'
     438 |         trc->recs = vzalloc(trc->num_entries *
         |                     ^~~~~~~
>> include/linux/vmalloc.h:163:13: warning: conflicting types for 'vfree'; have 'void(const void *)'
     163 | extern void vfree(const void *addr);
         |             ^~~~~
   drivers/scsi/qla2xxx/qla_dbg.h:452:9: note: previous implicit declaration of 'vfree' with type 'void(const void *)'
     452 |         vfree(trc->recs);
         |         ^~~~~
   cc1: some warnings being treated as errors
--
   In file included from drivers/scsi/qla2xxx/qla_def.h:5498,
                    from drivers/scsi/qla2xxx/qla_init.c:6:
   drivers/scsi/qla2xxx/qla_dbg.h: In function 'qla_trace_init':
>> drivers/scsi/qla2xxx/qla_dbg.h:438:21: error: implicit declaration of function 'vzalloc'; did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
     438 |         trc->recs = vzalloc(trc->num_entries *
         |                     ^~~~~~~
         |                     kvzalloc
>> drivers/scsi/qla2xxx/qla_dbg.h:438:19: warning: assignment to 'struct qla_trace_rec *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     438 |         trc->recs = vzalloc(trc->num_entries *
         |                   ^
   drivers/scsi/qla2xxx/qla_dbg.h: In function 'qla_trace_uninit':
>> drivers/scsi/qla2xxx/qla_dbg.h:452:9: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
     452 |         vfree(trc->recs);
         |         ^~~~~
         |         kvfree
   In file included from drivers/scsi/qla2xxx/qla_init.c:11:
   include/linux/vmalloc.h: At top level:
>> include/linux/vmalloc.h:143:14: error: conflicting types for 'vzalloc'; have 'void *(long unsigned int)'
     143 | extern void *vzalloc(unsigned long size) __alloc_size(1);
         |              ^~~~~~~
   drivers/scsi/qla2xxx/qla_dbg.h:438:21: note: previous implicit declaration of 'vzalloc' with type 'int()'
     438 |         trc->recs = vzalloc(trc->num_entries *
         |                     ^~~~~~~
>> include/linux/vmalloc.h:163:13: warning: conflicting types for 'vfree'; have 'void(const void *)'
     163 | extern void vfree(const void *addr);
         |             ^~~~~
   drivers/scsi/qla2xxx/qla_dbg.h:452:9: note: previous implicit declaration of 'vfree' with type 'void(const void *)'
     452 |         vfree(trc->recs);
         |         ^~~~~
   drivers/scsi/qla2xxx/qla_init.c: In function 'qla24xx_async_abort_cmd':
   drivers/scsi/qla2xxx/qla_init.c:171:17: warning: variable 'bail' set but not used [-Wunused-but-set-variable]
     171 |         uint8_t bail;
         |                 ^~~~
   drivers/scsi/qla2xxx/qla_init.c: In function 'qla2x00_async_tm_cmd':
   drivers/scsi/qla2xxx/qla_init.c:2023:17: warning: variable 'bail' set but not used [-Wunused-but-set-variable]
    2023 |         uint8_t bail;
         |                 ^~~~
   cc1: some warnings being treated as errors
--
   In file included from drivers/scsi/qla2xxx/qla_def.h:5498,
                    from drivers/scsi/qla2xxx/qla_mbx.c:6:
   drivers/scsi/qla2xxx/qla_dbg.h: In function 'qla_trace_init':
>> drivers/scsi/qla2xxx/qla_dbg.h:438:21: error: implicit declaration of function 'vzalloc'; did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
     438 |         trc->recs = vzalloc(trc->num_entries *
         |                     ^~~~~~~
         |                     kvzalloc
>> drivers/scsi/qla2xxx/qla_dbg.h:438:19: warning: assignment to 'struct qla_trace_rec *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     438 |         trc->recs = vzalloc(trc->num_entries *
         |                   ^
   drivers/scsi/qla2xxx/qla_dbg.h: In function 'qla_trace_uninit':
>> drivers/scsi/qla2xxx/qla_dbg.h:452:9: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
     452 |         vfree(trc->recs);
         |         ^~~~~
         |         kvfree
   cc1: some warnings being treated as errors
--
   In file included from drivers/scsi/qla2xxx/qla_def.h:5498,
                    from drivers/scsi/qla2xxx/qla_iocb.c:6:
   drivers/scsi/qla2xxx/qla_dbg.h: In function 'qla_trace_init':
>> drivers/scsi/qla2xxx/qla_dbg.h:438:21: error: implicit declaration of function 'vzalloc'; did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
     438 |         trc->recs = vzalloc(trc->num_entries *
         |                     ^~~~~~~
         |                     kvzalloc
>> drivers/scsi/qla2xxx/qla_dbg.h:438:19: warning: assignment to 'struct qla_trace_rec *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     438 |         trc->recs = vzalloc(trc->num_entries *
         |                   ^
   drivers/scsi/qla2xxx/qla_dbg.h: In function 'qla_trace_uninit':
>> drivers/scsi/qla2xxx/qla_dbg.h:452:9: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
     452 |         vfree(trc->recs);
         |         ^~~~~
         |         kvfree
   In file included from include/linux/string.h:253,
                    from include/linux/bitmap.h:11,
                    from include/linux/cpumask.h:12,
                    from include/linux/smp.h:13,
                    from arch/mips/include/asm/cpu-type.h:12,
                    from arch/mips/include/asm/timex.h:19,
                    from include/linux/timex.h:67,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from drivers/scsi/qla2xxx/qla_def.h:12:
   In function 'fortify_memcpy_chk',
       inlined from 'qla24xx_els_dcmd2_iocb' at drivers/scsi/qla2xxx/qla_iocb.c:3065:2:
   include/linux/fortify-string.h:352:25: warning: call to '__read_overflow2_field' declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
     352 |                         __read_overflow2_field(q_size_field, size);
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   In file included from drivers/scsi/qla2xxx/qla_def.h:5498,
                    from drivers/scsi/qla2xxx/qla_dfs.c:6:
   drivers/scsi/qla2xxx/qla_dbg.h: In function 'qla_trace_init':
>> drivers/scsi/qla2xxx/qla_dbg.h:438:21: error: implicit declaration of function 'vzalloc'; did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
     438 |         trc->recs = vzalloc(trc->num_entries *
         |                     ^~~~~~~
         |                     kvzalloc
>> drivers/scsi/qla2xxx/qla_dbg.h:438:19: warning: assignment to 'struct qla_trace_rec *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     438 |         trc->recs = vzalloc(trc->num_entries *
         |                   ^
   drivers/scsi/qla2xxx/qla_dbg.h: In function 'qla_trace_uninit':
>> drivers/scsi/qla2xxx/qla_dbg.h:452:9: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
     452 |         vfree(trc->recs);
         |         ^~~~~
         |         kvfree
   drivers/scsi/qla2xxx/qla_dfs.c: At top level:
   drivers/scsi/qla2xxx/qla_dfs.c:539:1: warning: 'qla_dfs_trace_write' defined but not used [-Wunused-function]
     539 | qla_dfs_trace_write(struct file *file, const char __user *buffer,
         | ^~~~~~~~~~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_dfs.c:504:1: warning: 'qla_dfs_trace_show' defined but not used [-Wunused-function]
     504 | qla_dfs_trace_show(struct seq_file *s, void *unused)
         | ^~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +438 drivers/scsi/qla2xxx/qla_dbg.h

   424	
   425	static inline void
   426	qla_trace_init(struct qla_trace *trc, char *name, u32 num_entries)
   427	{
   428		if (trc->recs)
   429			return;
   430	
   431		memset(trc, 0, sizeof(*trc));
   432	
   433		trc->name = name;
   434		spin_lock_init(&trc->trc_lock);
   435		if (!num_entries)
   436			return;
   437		trc->num_entries = num_entries;
 > 438		trc->recs = vzalloc(trc->num_entries *
   439					sizeof(struct qla_trace_rec));
   440		if (!trc->recs)
   441			return;
   442	
   443		set_bit(QLA_TRACE_ENABLED, &trc->flags);
   444	}
   445	
   446	static inline void
   447	qla_trace_uninit(struct qla_trace *trc)
   448	{
   449		if (!trc->recs)
   450			return;
   451	
 > 452		vfree(trc->recs);
   453		trc->recs = NULL;
   454		clear_bit(QLA_TRACE_ENABLED, &trc->flags);
   455	}
   456	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
