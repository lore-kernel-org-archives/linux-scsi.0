Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517AF81AC4
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 09:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719478808; cv=none; b=bSJxePH0F2sZmKo9k0nrm1YBASWvGV1fTJoLPLJHGiF4yXCJPnxpOljqnT5drNIrvl1G6eQ6yaQI49OLH4l28+Gc3adttF+Q1wjkpu7+HuxZxpGlHmnJR2AlYfRjblBuFyajL1zS0zRFXTveiquxFf+UO0v3I3yzgVKtmJJQD00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719478808; c=relaxed/simple;
	bh=dPNR2Inhf0KY+9CFEY59+VCURP+oBd2v09VybzbiRcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SGPa1VZVstuohI4XdLnEnEiCCFtS8/4HeY8vroCaHc92JfHTzlbT7nJ9+DgndUpFkDmpv2a/4jh6wiwIcTBPoBbT2mUyPkzN422u4wpB3S3EIVGSjqcJmEUJsojHwMrKfBOjoluB9b+xUv62L9jgVCbYS1elnD7xT16LPCfHQAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WD9Kp20/; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WD9Kp20/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719478806; x=1751014806;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=dPNR2Inhf0KY+9CFEY59+VCURP+oBd2v09VybzbiRcs=;
  b=WD9Kp20/O1HBOVwPfw7D0DZWtrJ3J/95b8HnM4JFrcpzSH4wD4LCqYKk
   6ibhDI2LIlLYOM3Wrd/yrdSHPBfoI/6rPaO0lEOolqxIaKS1YCY63UXnK
   NoS+iS7R87hu6SlCvk4eg6LFdK0Td3puv/IfNKDx7ou7vymkHuWhyVCfF
   PAkCoL/T5lUhbYfABbrBOfLSAP2nPd5a9rzrDIo6ovQaB+NmdYwTRYDRW
   BTJlDr+C7LoN3v898Au0kFdbL8YnoRezG5Y/o/lrYrF/8JNHKlelEAo6b
   x9V4Xz+ZXEmRelfTKVF5DCg8OHpV1r+Mi5ufOq+ynqf+CKJlIJvuTGlrD
   A==;
X-CSE-ConnectionGUID: R4c+yIxTQySzS22/pLVqEQ==
X-CSE-MsgGUID: 09TiM8EPSe2/ctpCVoUyLw==
X-IronPort-AV: E=McAfee;i="6700,10204,11115"; a="12276851"
X-IronPort-AV: E=Sophos;i="6.08,269,1712646000"; 
   d="scan'208";a="12276851"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 02:00:04 -0700
X-CSE-ConnectionGUID: wZPDLb7/SXSEmamO3pKIRQ==
X-CSE-MsgGUID: nmD/6ze9TTG3DjcAwXysPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,269,1712646000"; 
   d="scan'208";a="45052962"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 27 Jun 2024 02:00:02 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sMkz2-000G4t-1d;
	Thu, 27 Jun 2024 09:00:00 +0000
Date: Thu, 27 Jun 2024 16:59:33 +0800
From: kernel test robot <lkp@intel.com>
To: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>,
	linux-scsi@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: Re: [PATCH 04/14] scsi: cxlflash: Replaced ternary operation in
 write_same16 with min()
Message-ID: <202406271631.jhZ8qH3o-lkp@intel.com>
References: <20240626101342.1440049-5-prabhakar.pujeri@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240626101342.1440049-5-prabhakar.pujeri@gmail.com>

Hi Prabhakar,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.10-rc5 next-202=
40626]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Prabhakar-Pujeri/scs=
i-advansys-Simplified-memcpy-length-calculation-in-adv_build_req/20240626-2=
31800
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-n=
ext
patch link:    https://lore.kernel.org/r/20240626101342.1440049-5-prabhakar=
=2Epujeri%40gmail.com
patch subject: [PATCH 04/14] scsi: cxlflash: Replaced ternary operation in =
write_same16 with min()
config: powerpc-allyesconfig (https://download.01.org/0day-ci/archive/20240=
627/202406271631.jhZ8qH3o-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project ad7=
9a14c9e5ec4a369eed4adf567c22cc029863f)
reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archive=
/20240627/202406271631.jhZ8qH3o-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406271631.jhZ8qH3o-lkp@i=
ntel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/scsi/cxlflash/vlun.c:11:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/powerpc/include/asm/hardirq.h:6:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/powerpc/include/asm/io.h:24:
   In file included from include/linux/mm.h:2253:
   include/linux/vmstat.h:500:43: warning: arithmetic between different enu=
meration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-en=
um-conversion]
     500 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     501 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:507:43: warning: arithmetic between different enu=
meration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-en=
um-conversion]
     507 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     508 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:514:36: warning: arithmetic between different enu=
meration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-con=
version]
     514 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "n=
r_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:519:43: warning: arithmetic between different enu=
meration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-en=
um-conversion]
     519 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     520 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:528:43: warning: arithmetic between different enu=
meration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-en=
um-conversion]
     528 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     529 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> drivers/scsi/cxlflash/vlun.c:448:22: error: static assertion failed due =
to requirement '__builtin_choose_expr((sizeof(int) =3D=3D sizeof (*(8 ? ((v=
oid *)((long)((((const unsigned int)(-1)) < (const unsigned int)1)) * 0L)) =
: (int *)8))), (((const unsigned int)(-1)) < (const unsigned int)1), 0) =3D=
=3D __builtin_choose_expr((sizeof(int) =3D=3D sizeof (*(8 ? ((void *)((long=
)((((int)(-1)) < (int)1)) * 0L)) : (int *)8))), (((int)(-1)) < (int)1), 0) =
|| __builtin_choose_expr((sizeof(int) =3D=3D sizeof (*(8 ? ((void *)((long)=
((((unsigned int)(-1)) < (unsigned int)1)) * 0L)) : (int *)8))), (((unsigne=
d int)(-1)) < (unsigned int)1), 0) =3D=3D __builtin_choose_expr((sizeof(int=
) =3D=3D sizeof (*(8 ? ((void *)((long)((((int)(-1)) < (int)1)) * 0L)) : (i=
nt *)8))), (((int)(-1)) < (int)1), 0) || (__builtin_choose_expr((sizeof(int=
) =3D=3D sizeof (*(8 ? ((void *)((long)(ws_limit) * 0L)) : (int *)8))) && _=
_builtin_choose_expr((sizeof(int) =3D=3D sizeof (*(8 ? ((void *)((long)((((=
const unsigned int)(-1)) < (const unsigned int)1)) * 0L)) : (int *)8))), ((=
(const unsigned int)(-1)) < (const unsigned int)1), 0), ws_limit, -1) >=3D =
0) || (__builtin_choose_expr((sizeof(int) =3D=3D sizeof (*(8 ? ((void *)((l=
ong)(left) * 0L)) : (int *)8))) && __builtin_choose_expr((sizeof(int) =3D=
=3D sizeof (*(8 ? ((void *)((long)((((int)(-1)) < (int)1)) * 0L)) : (int *)=
8))), (((int)(-1)) < (int)1), 0), left, -1) >=3D 0)': min(ws_limit, left) s=
ignedness error, fix types or consider umin() before min_t()
     448 |                 put_unaligned_be32(min(ws_limit, left),
         |                                    ^~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:85:19: note: expanded from macro 'min'
      85 | #define min(x, y)       __careful_cmp(min, x, y)
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:58:3: note: expanded from macro '__careful_cmp'
      58 |                 __cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_=
ID(__y)))
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~
   include/linux/minmax.h:51:16: note: expanded from macro '__cmp_once'
      51 |         static_assert(__types_ok(x, y),                 \
         |         ~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      52 |                 #op "(" #x ", " #y ") signedness error, fix type=
s or consider u" #op "() before " #op "_t()"); \
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=
=3D0 to see all)
   include/linux/minmax.h:31:2: note: expanded from macro '__is_signed'
      31 |         __builtin_choose_expr(__is_constexpr(is_signed_type(type=
of(x))),        \
         |         ^
   include/linux/build_bug.h:77:50: note: expanded from macro 'static_asser=
t'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_AR=
GS__, #expr)
         |                                  ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~=
~~~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: expanded from macro '__static_ass=
ert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   5 warnings and 1 error generated.


vim +448 drivers/scsi/cxlflash/vlun.c

   392=09
   393	/**
   394	 * write_same16() - sends a SCSI WRITE_SAME16 (0) command to specifi=
ed LUN
   395	 * @sdev:	SCSI device associated with LUN.
   396	 * @lba:	Logical block address to start write same.
   397	 * @nblks:	Number of logical blocks to write same.
   398	 *
   399	 * The SCSI WRITE_SAME16 can take quite a while to complete. Should =
an EEH occur
   400	 * while in scsi_execute_cmd(), the EEH handler will attempt to reco=
ver. As
   401	 * part of the recovery, the handler drains all currently running io=
ctls,
   402	 * waiting until they have completed before proceeding with a reset.=
 As this
   403	 * routine is used on the ioctl path, this can create a condition wh=
ere the
   404	 * EEH handler becomes stuck, infinitely waiting for this ioctl thre=
ad. To
   405	 * avoid this behavior, temporarily unmark this thread as an ioctl t=
hread by
   406	 * releasing the ioctl read semaphore. This will allow the EEH handl=
er to
   407	 * proceed with a recovery while this thread is still running. Once =
the
   408	 * scsi_execute_cmd() returns, reacquire the ioctl read semaphore an=
d check the
   409	 * adapter state in case it changed while inside of scsi_execute_cmd=
(). The
   410	 * state check will wait if the adapter is still being recovered or =
return a
   411	 * failure if the recovery failed. In the event that the adapter res=
et failed,
   412	 * simply return the failure as the ioctl would be unable to continu=
e.
   413	 *
   414	 * Note that the above puts a requirement on this routine to only be=
 called on
   415	 * an ioctl thread.
   416	 *
   417	 * Return: 0 on success, -errno on failure
   418	 */
   419	static int write_same16(struct scsi_device *sdev,
   420				u64 lba,
   421				u32 nblks)
   422	{
   423		u8 *cmd_buf =3D NULL;
   424		u8 *scsi_cmd =3D NULL;
   425		int rc =3D 0;
   426		int result =3D 0;
   427		u64 offset =3D lba;
   428		int left =3D nblks;
   429		struct cxlflash_cfg *cfg =3D shost_priv(sdev->host);
   430		struct device *dev =3D &cfg->dev->dev;
   431		const u32 s =3D ilog2(sdev->sector_size) - 9;
   432		const u32 to =3D sdev->request_queue->rq_timeout;
   433		const u32 ws_limit =3D
   434			sdev->request_queue->limits.max_write_zeroes_sectors >> s;
   435=09
   436		cmd_buf =3D kzalloc(CMD_BUFSIZE, GFP_KERNEL);
   437		scsi_cmd =3D kzalloc(MAX_COMMAND_SIZE, GFP_KERNEL);
   438		if (unlikely(!cmd_buf || !scsi_cmd)) {
   439			rc =3D -ENOMEM;
   440			goto out;
   441		}
   442=09
   443		while (left > 0) {
   444=09
   445			scsi_cmd[0] =3D WRITE_SAME_16;
   446			scsi_cmd[1] =3D cfg->ws_unmap ? 0x8 : 0;
   447			put_unaligned_be64(offset, &scsi_cmd[2]);
 > 448			put_unaligned_be32(min(ws_limit, left),
   449					   &scsi_cmd[10]);
   450=09
   451			/* Drop the ioctl read semaphore across lengthy call */
   452			up_read(&cfg->ioctl_rwsem);
   453			result =3D scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_OUT,
   454						  cmd_buf, CMD_BUFSIZE, to,
   455						  CMD_RETRIES, NULL);
   456			down_read(&cfg->ioctl_rwsem);
   457			rc =3D check_state(cfg);
   458			if (rc) {
   459				dev_err(dev, "%s: Failed state result=3D%08x\n",
   460					__func__, result);
   461				rc =3D -ENODEV;
   462				goto out;
   463			}
   464=09
   465			if (result) {
   466				dev_err_ratelimited(dev, "%s: command failed for "
   467						    "offset=3D%lld result=3D%08x\n",
   468						    __func__, offset, result);
   469				rc =3D -EIO;
   470				goto out;
   471			}
   472			left -=3D ws_limit;
   473			offset +=3D ws_limit;
   474		}
   475=09
   476	out:
   477		kfree(cmd_buf);
   478		kfree(scsi_cmd);
   479		dev_dbg(dev, "%s: returning rc=3D%d\n", __func__, rc);
   480		return rc;
   481	}
   482=09

--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
