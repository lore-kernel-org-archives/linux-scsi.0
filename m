Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8656253B59
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2025 15:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739289093; cv=none; b=H6llfCYjM7P3N4R/rDxLKZKlHYcCZva5hK5YWj50R0DVJaIzhunEDGkG1wAHKL2OTl1vzqy/terPlMet/D+ttctgc62qwEmeSTdyctyVC7l0RZbUqXW4KHg5K+yn4xEoHQ4UMRyVcUW5LwoVUYymPSas2YvgGiUf2a/MCUAjsng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739289093; c=relaxed/simple;
	bh=U+7sT3fDI5fS3u8tJOcNRpDHMZKzDsexaIyzOyq+Xbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+8WlJ4yZOuRnUHPfnFBGWWBcTdaaSjG0rIe904ST/VFzfOEBD3f1f0foRMISDxB95CxqlTDkO9bHFmXIseAF2/DcPuBSo2eL72ALVeM6kO7I0PvTc+2ySlBVPgFvMyL3cOAK/ek7QiOXDLk1YmqqRsmKI/jUFjJ0iJqQIxcqLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RSx8v8FK; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RSx8v8FK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739289091; x=1770825091;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U+7sT3fDI5fS3u8tJOcNRpDHMZKzDsexaIyzOyq+Xbc=;
  b=RSx8v8FKc7zoXkq6cw/2SihRiG3H+wTX2jGrN6rNqPJCvHAnkGAqsnPu
   t1eWrQSlrD2G7HX7ZTxgbvqTqwiJYqt8O+yFrdfTSnqQNQAWuvvDz3QVr
   B5VQMfDUMIpVfmQpGBu0NW8SrjPWce+UyvTd/EibLz2IiR8MgRqHUOJxf
   ZroNYs+O24I1YalPtzKzLaZ0Z/y8Qth4DjTm1LPpghgBZq0u5dkmLy1kw
   Wiy+XUvJtJeuOuHNxxsIZNSDnijfv9My8rw1I62aG4jpvIpW+KvzLiNbR
   gxFFSMR1jXkspodetZjvZ8JipT8LodQAT63XoQJDWH3nZet4g08j/wY5v
   Q==;
X-CSE-ConnectionGUID: yf1L8iR/TKC/KEi/BTlfXg==
X-CSE-MsgGUID: +GqES4veTrm+YF3kRKC/KQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11342"; a="57450389"
X-IronPort-AV: E=Sophos;i="6.13,277,1732608000"; 
   d="scan'208";a="57450389"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 07:51:31 -0800
X-CSE-ConnectionGUID: SgTob9W9RviSj3oLQSeE0Q==
X-CSE-MsgGUID: UnGvSuyYR/qaq6SA9zX1BQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="117471640"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 11 Feb 2025 07:51:29 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1thsXm-0014Nf-04;
	Tue, 11 Feb 2025 15:51:26 +0000
Date: Tue, 11 Feb 2025 23:50:28 +0800
From: kernel test robot <lkp@intel.com>
To: Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
	linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com,
	jmeneghi@redhat.com,
	Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH v1 4/7] scsi: scsi_debug: Add read support and update
 locate for tapes
Message-ID: <202502112330.2jlgUZM7-lkp@intel.com>
References: <20250210191232.185207-5-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210191232.185207-5-Kai.Makisara@kolumbus.fi>

Hi Kai,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.14-rc2 next-20250210]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kai-M-kisara/scsi-scsi_debug-First-fixes-for-tapes/20250211-031623
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250210191232.185207-5-Kai.Makisara%40kolumbus.fi
patch subject: [PATCH v1 4/7] scsi: scsi_debug: Add read support and update locate for tapes
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20250211/202502112330.2jlgUZM7-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250211/202502112330.2jlgUZM7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502112330.2jlgUZM7-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/scsi/scsi_debug.c:31:
   In file included from include/linux/scatterlist.h:8:
   In file included from include/linux/mm.h:2224:
   include/linux/vmstat.h:504:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     504 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     505 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:511:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     511 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     512 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:524:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     524 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     525 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   drivers/scsi/scsi_debug.c:2989:3: warning: variable 'len' is uninitialized when used here [-Wuninitialized]
    2989 |                 len += resp_partition_m_pg(ap, pcontrol, target);
         |                 ^~~
   drivers/scsi/scsi_debug.c:2854:28: note: initialize the variable 'len' to silence this warning
    2854 |         u32 alloc_len, offset, len;
         |                                   ^
         |                                    = 0
>> drivers/scsi/scsi_debug.c:3419:8: warning: variable 'i' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    3419 |                         if (pos == 0)
         |                             ^~~~~~~~
   drivers/scsi/scsi_debug.c:3478:44: note: uninitialized use occurs here
    3478 |                         BEGINNING_OF_P_M_DETECTED_ASCQ, count - i,
         |                                                                 ^
   drivers/scsi/scsi_debug.c:3419:4: note: remove the 'if' if its condition is always false
    3419 |                         if (pos == 0)
         |                         ^~~~~~~~~~~~~
    3420 |                                 goto is_bop;
         |                                 ~~~~~~~~~~~~
    3421 |                         else {
         |                         ~~~~
   drivers/scsi/scsi_debug.c:3378:7: note: initialize the variable 'i' to silence this warning
    3378 |         int i, pos, count;
         |              ^
         |               = 0
   drivers/scsi/scsi_debug.c:3513:10: warning: variable 'i' is uninitialized when used here [-Wuninitialized]
    3513 |         for ( ; i < TAPE_MAX_PARTITIONS; i++)
         |                 ^
   drivers/scsi/scsi_debug.c:3502:7: note: initialize the variable 'i' to silence this warning
    3502 |         int i;
         |              ^
         |               = 0
   6 warnings generated.


vim +3419 drivers/scsi/scsi_debug.c

  3373	
  3374	static int resp_space(struct scsi_cmnd *scp,
  3375			struct sdebug_dev_info *devip)
  3376	{
  3377		unsigned char *cmd = scp->cmnd, code;
  3378		int i, pos, count;
  3379		struct tape_block *blp;
  3380		int partition = devip->tape_partition;
  3381	
  3382		count = get_unaligned_be24(cmd + 2);
  3383		if ((count & 0x800000) != 0) /* extend negative to 32-bit count */
  3384			count |= 0xff000000;
  3385		code = cmd[1] & 0x0f;
  3386	
  3387		pos = devip->tape_location[partition];
  3388		if (code == 0) { /* blocks */
  3389			if (count < 0) {
  3390				count = (-count);
  3391				pos -= 1;
  3392				for (i = 0, blp = devip->tape_blocks[partition] + pos; i < count;
  3393				     i++) {
  3394					if (pos < 0)
  3395						goto is_bop;
  3396					else if (IS_TAPE_BLOCK_FM(blp->fl_size))
  3397						goto is_fm;
  3398					if (i > 0) {
  3399						pos--;
  3400						blp--;
  3401					}
  3402				}
  3403			} else if (count > 0) {
  3404				for (i = 0, blp = devip->tape_blocks[partition] + pos; i < count;
  3405				     i++, pos++, blp++) {
  3406					if (IS_TAPE_BLOCK_EOD(blp->fl_size))
  3407						goto is_eod;
  3408					if (IS_TAPE_BLOCK_FM(blp->fl_size)) {
  3409						pos += 1;
  3410						goto is_fm;
  3411					}
  3412					if (pos >= devip->tape_eop[partition])
  3413						goto is_eop;
  3414				}
  3415			}
  3416		} else if (code == 1) { /* filemarks */
  3417			if (count < 0) {
  3418				count = (-count);
> 3419				if (pos == 0)
  3420					goto is_bop;
  3421				else {
  3422					for (i = 0, blp = devip->tape_blocks[partition] + pos;
  3423					     i < count && pos >= 0; i++, pos--, blp--) {
  3424						for (pos--, blp-- ; !IS_TAPE_BLOCK_FM(blp->fl_size) &&
  3425							     pos >= 0; pos--, blp--)
  3426							; /* empty */
  3427						if (pos < 0)
  3428							goto is_bop;
  3429					}
  3430				}
  3431				pos += 1;
  3432			} else if (count > 0) {
  3433				for (i = 0, blp = devip->tape_blocks[partition] + pos;
  3434				     i < count; i++, pos++, blp++) {
  3435					for ( ; !IS_TAPE_BLOCK_FM(blp->fl_size) &&
  3436						      !IS_TAPE_BLOCK_EOD(blp->fl_size) &&
  3437						      pos < devip->tape_eop[partition];
  3438					      pos++, blp++)
  3439						; /* empty */
  3440					if (IS_TAPE_BLOCK_EOD(blp->fl_size))
  3441						goto is_eod;
  3442					if (pos >= devip->tape_eop[partition])
  3443						goto is_eop;
  3444				}
  3445			}
  3446		} else if (code == 3) { /* EOD */
  3447			for (blp = devip->tape_blocks[partition] + pos;
  3448			     !IS_TAPE_BLOCK_EOD(blp->fl_size) && pos < devip->tape_eop[partition];
  3449			     pos++, blp++)
  3450				; /* empty */
  3451			if (pos >= devip->tape_eop[partition])
  3452				goto is_eop;
  3453		} else {
  3454			/* sequential filemarks not supported */
  3455			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 8, -1);
  3456			return check_condition_result;
  3457		}
  3458		devip->tape_location[partition] = pos;
  3459		return 0;
  3460	
  3461	is_fm:
  3462		devip->tape_location[partition] = pos;
  3463		mk_sense_info_tape(scp, NO_SENSE, NO_ADDITIONAL_SENSE,
  3464				FILEMARK_DETECTED_ASCQ, count - i,
  3465				SENSE_FLAG_FILEMARK);
  3466		return check_condition_result;
  3467	
  3468	is_eod:
  3469		devip->tape_location[partition] = pos;
  3470		mk_sense_info_tape(scp, BLANK_CHECK, NO_ADDITIONAL_SENSE,
  3471				EOD_DETECTED_ASCQ, count - i,
  3472				0);
  3473		return check_condition_result;
  3474	
  3475	is_bop:
  3476		devip->tape_location[partition] = 0;
  3477		mk_sense_info_tape(scp, NO_SENSE, NO_ADDITIONAL_SENSE,
  3478				BEGINNING_OF_P_M_DETECTED_ASCQ, count - i,
  3479				SENSE_FLAG_EOM);
  3480		devip->tape_location[partition] = 0;
  3481		return check_condition_result;
  3482	
  3483	is_eop:
  3484		devip->tape_location[partition] = devip->tape_eop[partition] - 1;
  3485		mk_sense_info_tape(scp, MEDIUM_ERROR, NO_ADDITIONAL_SENSE,
  3486				EOP_EOM_DETECTED_ASCQ, (unsigned int)i,
  3487				SENSE_FLAG_EOM);
  3488		return check_condition_result;
  3489	}
  3490	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
